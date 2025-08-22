<template>
  <view>
    <global-loading/>

    <view v-if="ifShow">
      <view class="unliquidated-topBackImg flex-items flex-column">
        <view class="totalAward-content flex-column font-color-FFF">
          <view class="flex-items-plus  mar-top-60">
            <label class="fs60 amount">￥{{ ZSalesOrderData.total }}</label>
          </view>
          <view class="flex-row-plus flex-sp-around fs24 mar-top-30">
            <view class="awardBox">
              <view class="fs36 font-color-FFF">{{ ZSalesOrderData.directPrice }}</view>
              <view class="awardTit font-color-FFF">直接奖励(元）</view>
            </view>
            <view class="awardBox">
              <view class="fs36 font-color-FFF">{{ ZSalesOrderData.indirectPrice }}</view>
              <view class="awardTit font-color-FFF">间接奖励(元）</view>
            </view>
          </view>
        </view>
      </view>
      <view class="awardType">
        <view class="awardType-box flex-center">
          <view class="awardType-content">
            <u-tabs :list="awardTypeList" bar-width="60" :bold="false" active-color="#C5AA7B" inactive-color="#999999"
                    :is-scroll="false" :current="awardTypeFlag" @change="awardTypeActive"></u-tabs>
          </view>
        </view>
        <view v-if="awardTypeFlag == 0">
          <view v-if="ZStotallength>0">
            <view class="flex-center" v-for="(item, index) in ZSalesOrderDatalist" :key="index">
              <view class="directAward-box font-color-656 fs26" @click="arrowTypeChange1(index)">
                <view style="display: flex;" class="directAwardInfo">
                  <view style="flex: 1;" class="flex-items flex-sp-between">
                    <label class="orderId-box font-color-999">订单号：{{ item.orderFormid }}</label>
                    <view class="mar-right-50 font-color-999">
                      佣金：<label class="font-color-C5AA7B">¥{{ item.commission }}</label>
                    </view>
                  </view>
                  <view>
                    <image v-if="item.ifOpen == false" class="arrow-down"
                           :src="`${VUE_APP_STATIC_URL}static/images/arrowDownIcon.png`"></image>
                    <image v-if="item.ifOpen == true" class="arrow-down"
                           :src="`${VUE_APP_STATIC_URL}static/images/arrowUpIcon.png`"></image>
                  </view>
                </view>
                <view v-if="item.ifOpen == true">
                  <view class="flex-row-plus flex-items flex-sp-between mar-top-30">
                    <label class="orderId-box font-color-999">商品数：{{ item.products }}</label>
                    <label class="commission-box mar-left-70 font-color-999">实付金额：¥{{ item.price }}</label>
                  </view>
                  <view class="flex-row-plus flex-items mar-top-30">
                    <label class="orderId-box font-color-999">下单人：{{ item.customerName }}</label>
                  </view>
                </view>
              </view>
            </view>
          </view>
          <view v-else class="emptyCart-box flex-items-plus flex-column">
            <image class="emptyCart-img" :src="`${VUE_APP_STATIC_URL}static/img/bgnull.png`"></image>
            <label class="font-color-999 fs26 mar-top-30">这里空空如也~</label>
          </view>
        </view>
        <view v-if="awardTypeFlag == 1">
          <view v-if="JStotallength>0">
            <view class="flex-center" v-for="(item, index) in JSalesOrderDatalist" :key="index">
              <view class="directAward-box font-color-656 fs26" @click="arrowTypeChange(index)">
                <view style="display: flex;" class="directAwardInfo">
                  <view style="flex: 1;" class="flex-items flex-sp-between">
                    <label class="orderId-box font-color-999">订单号：{{ item.orderFormid }}</label>
                    <view class="mar-right-50 font-color-999">
                      佣金：<label class="font-color-C5AA7B">¥{{ item.commission }}</label>
                    </view>
                  </view>
                  <view>
                    <image v-if="item.ifOpen == false" class="arrow-down"
                           :src="`${VUE_APP_STATIC_URL}static/images/arrowDownIcon.png`"></image>
                    <image v-if="item.ifOpen  == true" class="arrow-down"
                           :src="`${VUE_APP_STATIC_URL}static/images/arrowUpIcon.png`"></image>
                  </view>
                </view>
                <view v-if="item.ifOpen == true">
                  <view class="flex-row-plus flex-items flex-sp-between mar-top-30">
                    <label class="orderId-box font-color-999">商品数：{{ item.products }}</label>
                    <label class="commission-box mar-left-70 font-color-999">实付金额：¥{{ item.price }}</label>
                  </view>
                  <view class="flex-row-plus flex-items mar-top-30">
                    <label class="orderId-box font-color-999">下单人：{{ item.customerName }}</label>
                  </view>
                  <view class="flex-row-plus flex-items mar-top-30">
                    <label class="orderId-box font-color-999">分销员：{{ item.distributorName }}</label>
                  </view>
                </view>
              </view>
            </view>
          </view>
          <view v-else class="emptyCart-box flex-items-plus flex-column">
            <image class="emptyCart-img" :src="`${VUE_APP_STATIC_URL}static/img/bgnull.png`"></image>
            <label class="font-color-999 fs26 mar-top-30">这里空空如也~</label>
          </view>
        </view>
      </view>
    </view>
  </view>
</template>

<script setup>
import {ref} from "vue";
import {request} from "../../utils/request";
import {onLoad, onReachBottom} from "@dcloudio/uni-app";
import { VUE_APP_STATIC_URL } from "@/config/api";
import API from "../../config/api";

const awardTypeList = ref([
  { name: '直接奖励' },
  { name: '间接奖励' },
])
const awardTypeFlag = ref(0)
const SalesOrderQuery = ref({
  model: {
    tenantCode: '',
    settleStatus: '',
    type: '',
  },
  current: 0,
  size: 10,
})
const SalesOrderData = ref([])
const ZSalesOrderData = ref([]) // 奖励金额信息数据
const JSalesOrderData = ref([])
const shopId = ref(0)
const distributorId = ref(0)
const ZStotallength = ref(0)
const JStotallength = ref(0)
const page = ref(1)
const pageSize = ref(20)
const loadingType = ref(0)
const loadingType1 = ref(0)
const ZSalesOrderDatalist = ref([])
const JSalesOrderDatalist = ref([])
const ifShow = ref(false)

onLoad ((options) => {
  shopId.value = options.shopId
  distributorId.value = options.distributorId
  getZSalesOrderData()
  getJSalesOrderData()
})

onReachBottom(() => {
  if (awardTypeFlag.value == 0) {
    if (loadingType.value == 1) {
      uni.stopPullDownRefresh()
    } else {
      page.value = page.value + 1
      getZSalesOrderData()
    }
  } else {
    if (loadingType1.value == 1) {
      uni.stopPullDownRefresh()
    } else {
      page.value = page.value + 1
      getJSalesOrderData()
    }
  }
})

const getZSalesOrderData = async () => {
  try {
    const res = await request(API.GetNotReward, {
      shopId: shopId.value,
      distributorId: distributorId.value,
      type: 1,
      page: page.value,
      pageSize: pageSize.value
    }, 'GET')
    uni.hideLoading()
    if (res.data.page.list.length == 0) {
      loadingType.value = 1
    }
    ZSalesOrderDatalist.value = ZSalesOrderDatalist.value.concat(res.data.page.list)
    ZSalesOrderData.value = res.data
    ZStotallength.value = ZSalesOrderData.value.page.total
    ifShow.value = true
  } catch (err) {
    uni.hideLoading()
  }
}

const getJSalesOrderData = async () => {
  try {
    const res = await request(API.GetNotReward, {
      shopId: shopId.value,
      distributorId: distributorId.value,
      type: 2,
      page: page.value,
      pageSize: pageSize.value
    }, 'GET')
    uni.hideLoading()
    if (res.data.page.list.length == 0) {
      loadingType1.value = 1
      uni.showToast({
        title: '已加载全部···',
        duration: 2000,
        icon: 'none'
      });
    }
    JSalesOrderDatalist.value = JSalesOrderDatalist.value.concat(res.data.page.list)
    JSalesOrderData.value = res.data
    JStotallength.value = JSalesOrderData.value.page.total
  } catch (err) {
    uni.hideLoading()
  }
}

const awardTypeActive = (type) => {
  awardTypeFlag.value = type
  page.value = 1
}

const arrowTypeChange1 = (arrowTypeId) => {
  ZSalesOrderData.value.page.list[arrowTypeId].ifOpen = ZSalesOrderData.value.page.list[arrowTypeId].ifOpen == false ? true : false
}

const arrowTypeChange = (arrowTypeId) => {
  JSalesOrderData.value.page.list[arrowTypeId].ifOpen = JSalesOrderData.value.page.list[arrowTypeId].ifOpen == false ? true : false
}
</script>

<style lang="scss">
@import "../../style/images";
page {
  background: #333333;
}

.emptyCart-box {
  margin-top: 70rpx;

  .emptyCart-img {
    width: 225rpx;
    height: 196rpx;
  }
}

.unliquidated-topBackImg {
  width: 100%;
  height: 360rpx;
  background: $unliquidatedBg no-repeat;
  background-size: 100%;
  margin-top: 30rpx;

  .totalAward-content {
    width: 90%;

    .awardBox {
      text-align: center;

      .awardTit {
        opacity: 0.7;
      }
    }

    .amount {
      color: #FFEBC4;
    }
  }
}

.awardType-box {
  border-bottom: 1rpx solid #666666;

  .awardType-content {
    height: 80rpx;
    width: 500rpx;
  }
}

.directAward-box {
  width: 94%;
  border-bottom: 1rpx solid #666666;
  padding: 30rpx;
  display: flex;
  justify-content: flex-start;
  flex-direction: column;
  background: #FFFFFF;
  margin-top: 30rpx;

  .orderId-box {
    display: flex;
    justify-content: flex-start;
    flex-direction: row;
  }

  .commission-box {
    width: 260rpx;
  }

  .arrow-down {
    width: 24rpx;
    height: 24rpx;
  }
}

.totalAwardEmpty-box {
  margin-top: 65rpx;

  .totalAwardEmpty {
    width: 270rpx;
    height: 270rpx;
  }
}
</style>
<style scoped>
.awardType /deep/ .u-tabs {
  background: none !important;
}
</style>
