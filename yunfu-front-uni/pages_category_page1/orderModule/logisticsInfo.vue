<!-- 物流详情 -->
<template>
  <view>
    <view
        class="content"
        style="padding-bottom:100upx;"
        v-if="steps.length >0"
    >
      <view class="order-details-information mt20">
        <view class="order-title-box">
          <view class="order-title padd-l">
            <text class="line"></text>
            <text style="margin-left: 10upx;">物流信息</text>
          </view>
        </view>
      </view>
      <view class="logistics">
        <uni-steps
            :options="steps"
            direction="column"
            :active="0"
        ></uni-steps>
      </view>
    </view>
    <view
        v-else
        class="emptyOrder-box flex-items-plus flex-column"
    >
      <image
          class="emptyOrder-img"
          :src="`${VUE_APP_STATIC_URL}static/img/bgnull.png`"
      ></image>
      <label class="font-color-999 fs26 mar-top-30">你还没有物流信息哦～</label>
    </view>
  </view>
</template>

<script setup>
import { request } from "@/utils/request";
import API from "@/config/api";
import { ref } from "vue";
import { onLoad } from "@dcloudio/uni-app";
import { VUE_APP_STATIC_URL } from "@/config/api";

const express = ref('')
const deliverFormid = ref('')
const steps = ref([])
onLoad(options => {
  express.value = options.express
  deliverFormid.value = options.deliverFormid
  getShippingTrace(express.value, deliverFormid.value)
})

//物流信息
function getShippingTrace(express, deliverFormid) {
  request(API.ShippingTrace, {
    express: express,
    deliverFormid: deliverFormid
  }, "GET").then(res => {
    let traces = res.data
    let len = traces.length
    for (let i = 0; i < len; i++) {
      let item = traces[i]
      steps.value.push({
        title: item.reason,
        desc: item.time,
      })
    }
    steps.value = steps.value.reverse()
  }).catch(res => {
  })
}
</script>

<style lang="scss">
.emptyOrder-box {
  margin-top: 200rpx;

  .emptyOrder-img {
    width: 113upx;
    height: 98upx;
  }
}

page {
  background: #f7f7f7;
}

.logistics {
  padding: 20upx 20upx;
}

.content {
  padding: 0 0 120upx 0;
}

.order-details-information {
  background: #fff;
  flex-shrink: 0;
  display: flex;
  flex-direction: row;
  align-items: center;
  height: 98upx;

}

.order-details-information.padd {
  padding: 30upx;
  box-sizing: border-box;
}

.order-details-information .order-title {
  font-size: 30upx;
  margin-left: 30upx;
  color: #333;
  font-weight: 500;
  display: flex;
  flex-direction: row;
  align-items: center;
}

.order-details-information .order-title .line {
  width: 10upx;
  height: 30upx;
  background: #ff7911;
  margin-right: 10upx;
}

.order-details-information .info-box {
  margin-top: 30upx;
}

.order-details-information .info-box .item {
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: space-between;
  font-size: 24upx;
  color: #666;
  margin-bottom: 20upx;
}

.order-details-information .info-box .item .copy-color {
  font-size: 24upx;
  color: #ff7911;
}

.arrow-down-img {
  width: 90upx;
  height: 90upx;
  padding: 30upx;
  box-sizing: border-box;
}

.mt20 {
  margin-top: 20upx;
}
</style>
