<!--
    * @FileDescription: 收银台
    * @Author: kahu
    * @Date: 2022/11/21
    * @LastEditors: kahu
    * @LastEditTime: 2022/11/21
-->
<template>
  <view class="cashier-list-content">
    <u-radio-group
        v-model="paymentMode"
        placement="row"
        iconPlacement="right"
        @change="handleChangePaymentMode"
    >
      <view
          class="cashier"
          v-for="payment in paymentList"
          :key="payment.id"
      >
        <view class="cashier-item" @click="handleChangePaymentMode(payment.paymentMode,payment.disabled)"
        >
          <view class="icon-text">
            <image
                class="pay-type-img-inner"
                :src="payment.icon"
                mode="widthFix"
            />
            {{ payment.label }}
            <span v-if="paymentMode===3 && paymentMode === payment.paymentMode">（手续费：￥{{ flowerObj.hbServiceChargeTotal }}）</span>
          </view>
          <view class="radio">
            <u-radio
                :disabled="payment.disabled"
                activeColor="#c5aa7b"
                :name="payment.paymentMode"
            />
          </view>
        </view>
        <!-- 花呗分期 -->
        <view
            class="ali-hb-content"
            v-if="paymentMode===3 && paymentMode === payment.paymentMode"
        >
          <u-radio-group
              v-model="flowerObj.hbByStagesPeriods"
              placement="row"
              iconPlacement="right"
              @change="handleChangePeriods"
          >
            <view
                class="cashier"
                v-for="(flowerItem,index) in flowerObj.hbByStagesList"
                :key="index"
            >
              <view class="cashier-item" @click="handleChangePeriods(flowerItem.numberOfStages,flowerItem.disabled)">
                <view class="icon-text">
                  {{ flowerItem.numberOfStages }}期（￥{{ flowerItem.price }}/期）
                </view>
                <view class="radio-context">
                  手续费：￥{{ flowerItem.serviceCharge }}/期
                  <u-radio
                      class="radio"
                      activeColor="#c5aa7b"
                      :disabled="flowerItem.disabled"
                      :name="flowerItem.numberOfStages"
                  />
                </view>
              </view>
            </view>
          </u-radio-group>
        </view>
      </view>
    </u-radio-group>
  </view>
</template>

<script>
import { request } from "../../utils/request";
import API from "../../config/api";
import {VUE_APP_STATIC_URL} from "../../config/api";
export default {
  name: "CashierList",
  props: {
    totalPrice: {
      type: Number,
      default: () => 200
    }
  },
  data() {
    return {
      paymentMode: 1, // 支付方式 1微信 2支付宝 3花呗分期
      paymentList: [
        {
          id: 1,
          label: '微信支付',
          paymentMode: 1,
          icon: `${VUE_APP_STATIC_URL}images/wechat_pay.png`,
          disabled:false
        },
        {
          id: 2,
          label: '支付宝支付',
          paymentMode: 2,
          icon: `${VUE_APP_STATIC_URL}images/alipay.png`,
          disabled:false
        },
        {
          id: 3,
          label: '花呗分期',
          paymentMode: 3,
          icon: `${VUE_APP_STATIC_URL}images/huabei.png`,
          disabled:false
        }
      ],
      // 花呗相关
      flowerObj: {
        hbChargeType: 1,// 花呗手续费支付方式 1-商户支付 2-用户支付 后端接口返回
        hbByStagesPeriods: -1, // 花呗分期期数 3 6 12
        hbByStagesList: [
          {
            rate: 0,
            price: 0,
            numberOfStages: 3,
            serviceCharge: 0,
            disabled: false
          },
          {
            rate: 0,
            price: 0,
            numberOfStages: 6,
            serviceCharge: 0,
            disabled: false
          },
          {
            rate: 0,
            price: 0,
            numberOfStages: 12,
            serviceCharge: 0,
            disabled: false
          }
        ], // 花呗手续费比例列表 【{3期}，{6期}，{12期}】
        hbServiceChargeTotal: 0, // 花呗支付总手续费
      },
    }
  },
  mounted(){
    this.getTheFlowerConfig()
    this.handleSetDisable()
    this.handleNoticeFather()
  },
  methods: {
    /**
     * 根据环境更改可选支付项
     */
    handleSetDisable(){
      // #ifdef MP-WEIXIN
      this.paymentList[0].disabled = false
      this.paymentList[1].disabled = true
      this.paymentList[2].disabled = true
      this.paymentMode = 1
      // #endif
      // #ifdef MP-ALIPAY
      this.paymentList[0].disabled = true
      this.paymentList[1].disabled = false
      this.paymentList[2].disabled = false
      this.paymentMode = 2
      // #endif
      // #ifdef APP-PLUS || H5
      this.paymentList[0].disabled = false
      this.paymentList[1].disabled = true
      this.paymentList[2].disabled = true
      this.paymentMode = 1
      // #endif
    },
    /**
     * 支付方式改变事件
     * @param paymentMode
     * @param disabled
     */
    handleChangePaymentMode(paymentMode,disabled=false) {
      if(disabled) return
      this.paymentMode = paymentMode
      const { flowerObj } = this
      if ([1, 2].includes(paymentMode)) {
        // 支付宝支付，取消分期选择
        flowerObj.hbByStagesPeriods = -1
        // 3 6 12 全部禁止
        flowerObj.hbByStagesList.map(item => {
          item.disabled = true
        })
      } else {
        // 分期支付，默认选三期
        flowerObj.hbByStagesPeriods = 3
      }
      this.handleHbStagesAndPrice()
      this.handleNoticeFather()
    },

    /**
     * 获取花呗分期配置
     */
    async getTheFlowerConfig() {
      const {data} = await request(API.GetHuabeiConfig, {}, 'GET')
      const {flowerObj} = this
      flowerObj.hbChargeType = data.huabeiChargeType
      // 如果后端返回的是用户支付手续费，设置费率信息
      if (data.huabeiChargeType === 1) {
        data.huabeiFeeRateList.forEach((rate, index) => {
          flowerObj.hbByStagesList[index].rate = rate
        })
      }
      console.log(flowerObj)
    },

    /**
     * 处理花呗期数选择
     * @param periods 期数
     * @param disabled
     */
    handleChangePeriods(periods,disable=false) {
      if(disable)return
      const { flowerObj } = this
      flowerObj.hbByStagesPeriods = periods
      this.handleHbStagesAndPrice()
      this.handleNoticeFather()
    },

    /**
     * 处理花呗价格和手续费显示
     */
    handleHbStagesAndPrice() {
      const {flowerObj, totalPrice} = this
      if (this.paymentMode !== 3) return
      flowerObj.hbByStagesList.forEach(stages => {
        // 根据价格填充每一期价格和手续费信息
        stages.price = ((totalPrice * (1 + stages.rate / 100)) / stages.numberOfStages).toFixed(2) // 每一期价格
        stages.serviceCharge = ((totalPrice * (stages.rate / 100)) / stages.numberOfStages).toFixed(2) // 每一期手续费
        // 计算总手续费
        if (stages.numberOfStages === Number(flowerObj.hbByStagesPeriods)) {
          flowerObj.hbServiceChargeTotal = (totalPrice * (stages.rate / 100)).toFixed(2)
        }
        // 处理允许分期的区间，公式为总价格要大于分期数/100
        this.totalPrice < stages.numberOfStages / 100?stages.disabled = true:stages.disabled = false
      })
    },

    /**
     * 通知父组件
     */
    handleNoticeFather(){
      const { paymentMode,flowerObj } = this
      const params = {
        paymentMode,
        huabeiPeriod:flowerObj.hbByStagesPeriods
      }
      this.$emit('change',params)
    }
  }
}
</script>

<style
    lang="scss"
    scoped
>
.cashier-list-content {
  width: 100%;
  padding: 0rpx 15rpx;
  box-sizing: border-box;
  background: #fff;

  .u-radio-group {
    display: block !important;
  }

  .cashier {
    border-bottom: 2rpx solid #d0d0d0;

    &:last-child {
      border-bottom: none
    }

    .cashier-item {
      display: flex;
      align-items: center;
      justify-content: space-between;
      padding: 20rpx 0;
      box-sizing: border-box;
      position: relative;

      .icon-text {
        display: flex;
        align-items: center;
        justify-content: center;

        image {
          width: 50rpx;
          height: 50rpx;
          margin-right: 15rpx;
        }
      }
      .radio-context{
        display: flex;
        align-items: center;
        font-size: 14rpx;
        .radio{
          margin-left: 15rpx;
        }
      }
    }

    .ali-hb-content {
      padding: 10rpx 20px;
      box-sizing: border-box;
      border-top: 2rpx solid #d0d0d0;
    }
  }
}
</style>
