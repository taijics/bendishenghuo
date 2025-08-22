<!--
    * @FileDescription: 阿里花呗分期支付
    * @Author: kahu
    * @Date: 2022/11/21
    * @LastEditors: kahu
    * @LastEditTime: 2022/11/21
-->
<template>
  <view class="ali-hb-pay-content">
    <u-popup
        class="pay-type-popup"
        v-model="showPopup"
        mode="bottom"
        border-radius="14"
        close-icon-pos="top-right"
        close-icon-size="20"
    >
      <view class="pay-type-item">
        <radio-group
            @change="payTypeChange"
            v-model="flowerObj.paymentMode"
        >
          <view class="pay-type-radio">
            <view class="pay-type-img">
              <img
                  class="pay-type-img-inner"
                  :src="`${VUE_APP_STATIC_URL}static/images/alipay.png`"
              />
            </view>
            <label class="pay-type-label">支付宝支付</label>
            <radio
                class="pay-type-radio-item"
                style="transform:scale(0.7)"
                :checked="flowerObj.paymentMode === '2'"
                value="2"
            />
          </view>
          <view class="pay-type-radio">
            <view class="pay-type-img">
              <img
                  class="pay-type-img-inner"
                  :src="`${VUE_APP_STATIC_URL}static/images/huabei.png`"
              />
            </view>
            <label class="pay-type-label">花呗分期</label>
            <radio
                class="pay-type-radio-item"
                style="transform:scale(0.7)"
                :disabled="totalPrice < 0.03"
                :checked="flowerObj.paymentMode === '3'"
                value="3"
            />
          </view>
        </radio-group>
        <view class="huabei-detail" v-if="flowerObj.paymentMode==='3'">
          <radio-group
              @change="handleChangePeriods"
              v-model="flowerObj.hbByStagesPeriods"
          >
            <view class="period-radio" v-for="stages in flowerObj.hbByStagesList">
              <view class="period-amount">
                <label class="period-each">￥ {{ stages.price }}x{{ stages.numberOfStages }}期</label>
                <label class="period-each-charge">手续费￥{{ stages.serviceCharge}}/期</label>
              </view>
              <radio
                  class="period-type-radio-item"
                  style="transform:scale(0.7)"
                  :disabled="stages.disabled"
                  :checked="Number(flowerObj.hbByStagesPeriods) === stages.numberOfStages"
                  :value="stages.numberOfStages+''"
              />
            </view>
          </radio-group>
        </view>
      </view>
      <view class="paytype-confirm">
        <view
            class="fenqi-total-amount"
            v-if="totalPrice >= 0.03 && flowerObj.paymentMode === '3'"
        >
          <label class="fenqi-all">分期总额 ￥{{ totalPrice }}</label>
          <label class="charge-fee-all">手续费 ￥{{ flowerObj.hbServiceChargeTotal }}</label>
        </view>
        <view
            class="fenqi-total-amount"
            v-if="flowerObj.paymentMode === '2'"
        >
          <label class="order-amount">订单总额 ￥{{ totalPrice }}</label>
        </view>
        <view class="fenqi-confirm">
          <text
              class="btn active"
              @click="handleAliPayConfirm"
          >确认
          </text>
        </view>
      </view>
    </u-popup>
  </view>
</template>

<script>
import { request } from "../../utils/request";
import API from "../../config/api";
import { handleDoPay } from "../../utils/payUtil";
import { VUE_APP_STATIC_URL } from "@/config/api";
export default {
  name: "AliHbPay",
  data() {
    return {
      // 花呗相关
      flowerObj: {
        paymentMode: '2',// 支付方式 1-微信支付 2-支付宝支付 3-花呗分期
        hbChargeType: 1,// 花呗手续费支付方式 1-商户支付 2-用户支付 后端接口返回
        hbByStagesPeriods: '-1', // 花呗分期期数 3 6 12
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
  props:{
    totalPrice:{
      type:Number | String,
      default:()=>0
    },
    show:{
      type:Boolean,
      default:false
    },
    alipayInfo:{
      type:Object,
      default:()=>({})
    }
  },
  computed:{
    showPopup:{
      get(){
        return this.show
      },
      set(value){
        this.$emit('change',value)
      }
    }
  },
  model:{
    prop:'show',
    event:'change'
  },
  mounted(){
    this.getTheFlowerConfig()
  },
  methods: {
    /**
     * 获取花呗分期配置
     */
    async getTheFlowerConfig() {
      const {data} = await request(API.GetHuabeiConfig, {}, 'GET')
      const {flowerObj} = this
      flowerObj.hbChargeType = data.huabeiChargeType
      // 如果后端返回的是用户支付手续费，设置费率信息
      if (data.huabeiChargeType === 2) {
        data.huabeiFeeRateList.forEach((rate, index) => {
          flowerObj.hbByStagesList[index].rate = rate
        })
      }
    },

    /**
     * 处理花呗期数选择
     * @param event
     */
    handleChangePeriods(event) {
      this.flowerObj.hbByStagesPeriods = event
      console.log(event)
      this.handleHbStagesAndPrice()
    },

    /**
     * 处理支付宝支付方式选择逻辑
     * @param event
     */
    payTypeChange(event) {
      const flowerObj = this.flowerObj
      const paymentMode = flowerObj.paymentMode = event.target.value;
      if (paymentMode === '2') {
        // 支付宝支付，取消分期选择
        flowerObj.hbByStagesPeriods = '-1'
        // 3 6 12 全部禁止
        flowerObj.hbByStagesList.map(item => {
          item.disabled = true
        })
      } else {
        // 分期支付，默认选三期
        flowerObj.hbByStagesPeriods = '3'
      }
      this.handleHbStagesAndPrice()
    },

    /**
     * 处理花呗价格和手续费显示
     */
    handleHbStagesAndPrice() {
      const {flowerObj, totalPrice} = this
      if (flowerObj.paymentMode !== '3') return
      flowerObj.hbByStagesList.forEach(stages => {
        // 根据价格填充每一期价格和手续费信息
        stages.price = ((totalPrice * (1 + stages.rate / 100)) / stages.numberOfStages).toFixed(2) // 每一期价格
        stages.serviceCharge = ((totalPrice * (stages.rate / 100)) / stages.numberOfStages).toFixed(2) // 每一期手续费
        // 计算总手续费
        if (stages.numberOfStages === Number(flowerObj.hbByStagesPeriods)) {
          flowerObj.hbServiceChargeTotal = (totalPrice * (stages.rate / 100)).toFixed(2)
        }
        // 处理允许分期的区间，公式为总价格要大于分期数/100
        if (this.totalPrice < stages.numberOfStages / 100) {
          stages.disabled = true
        }
      })
    },

    /**
     * 确认支付宝支付
     * @return {Promise<void>}
     */
    async handleAliPayConfirm() {
      const payInfo = Object.assign({}, this.alipayInfo, {
        'paymentMode': this.flowerObj.paymentMode,
        'huabeiPeriod': this.flowerObj.hbByStagesPeriods
      });
      await handleDoPay.call(this, payInfo)
      this.$emit('confirm',{
        'paymentMode': this.flowerObj.paymentMode,
        'huabeiPeriod': this.flowerObj.hbByStagesPeriods
      })
    }
  }
}
</script>

<style
    lang="scss"
    scoped
>
.pay-type-item {
  .pay-type-radio {
    background-color: white;
    border-bottom: 1upx solid #EDEDED;
    margin-bottom: 20upx;
    padding: 24upx 20upx 24upx 20upx;

    .pay-type-img {
      display: inline-block;

      .pay-type-img-inner {
        width: 50upx;
        height: 50upx;
        vertical-align: middle;
      }
    }

    .pay-type-label {
      vertical-align: middle;
      margin-left: 30upx;
    }

    .pay-type-radio-item {
      float: right;
      margin-right: 20upx;
      width: 50upx;
      height: 50upx;
    }
  }

  .huabei-detail {
    margin-top: 20upx;

    .fenqi-wenzi {
      display: inline-block;
      margin-left: 64upx;
    }

    .fenqi-amount {
      display: block;
      margin-left: 64upx;
      margin-top: 14upx;
      color: #BABBBC;
    }

    .fenqi-charge-fee {
      float: right;
      margin-right: 68upx;
      color: #BABBBC;
    }

    .fenqi-modal {
      width: 40upx;
      height: 40upx;
      margin-left: 20upx;
      float: right;
      position: relative;
      top: -80upx;
    }
  }
}

.paytype-confirm {
  height: 120upx;
  padding: 0upx 108upx 0upx 32upx;

  .fenqi-all {
    display: inline-block;
    width: 100%;
  }

  .fenqi-total-amount {
    width: 65%;
    float: left;
  }

  .fenqi-confirm {
    float: right;
    width: 160upx;
    padding: 0upx 20upx;

    .btn {
      width: 216upx;
      height: 80upx;
      line-height: 80upx;
      border-radius: 40upx;
      font-size: 28upx;
      text-align: center;
      background: linear-gradient(90deg, rgba(255, 162, 0, 1), rgba(255, 121, 17, 1));
      color: #fff;
      display: inline-block;
      margin-right: 66upx;
    }
  }
}

.period-radio {
  margin: 30upx;
  padding-right: 100upx;
  width: 95%;
  border-bottom: 1px solid #EFEFEF;

  .period-amount {
    display: inline-block;

    .period-each-charge {
      display: inline-block;
      margin-top: 12upx;
      margin-left: 6upx;
      font-size: 26upx;
      color: #b7b7b7;
      margin-bottom: 13upx;
    }
  }

  .period-each {
    display: block;
  }

  .period-type-radio-item {
    float: right;
  }
}
</style>
