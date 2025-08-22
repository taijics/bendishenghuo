<!--
    * @FileDescription: 海觅渠道落地页
    * @Author: kahu
    * @Date: 2022/8/25
    * @LastEditors: kahu
    * @LastEditTime: 2022/8/25
-->
<template>
  <view class="content">
    <view class="coupon-box">
      <!-- 优惠券项 -->
      <template v-if="list.length>0">
        <view
            class="coupon-item"
            v-for="item in list"
            :key="item.id"
        >
          <!--  左侧  -->
          <view
              class="price-info pink-color"
              v-if="item.couponType===1"
          >
            <view class="price">
              <span>￥</span>{{ item.reduceMoney }}
            </view>
            <view class="info">
              <span v-if=" item.fullMoney <=0">无门槛</span>
              <span v-else>
                         满{{ item.fullMoney }}可用
            </span>
            </view>
            <view class="line"></view>
          </view>
          <view
              class="price-info pink-color"
              v-else
          >
            <view class="price">
              {{ item.reduceMoney }}<span>折</span>
            </view>
            <view class="info">
              <span v-if=" item.fullMoney <=0">无门槛</span>
              <span v-else>
                         满{{ item.fullMoney }}可用
            </span>
            </view>
            <view class="line"></view>
          </view>
          <!-- 右侧 -->
          <view class="coupon-info pink-color">
            <view class="coupon-desc">
              <view class="name">{{ item.couponName }}</view>
              <view class="time">
                <view>有效期</view>
                <view>{{ item.startTime }} - {{ item.endTime }}</view>
              </view>
            </view>
            <view :class="[item.state===3?'get-btn':'',item.state===0?'get-btn can-not-get':'']">
              <span v-if="item.state === 3" @click="handleGetCoupon(item)">待领取</span>
              <span v-if="item.state === 0" @click="handleUseCoupon(false,item)">去使用</span>
            </view>
          </view>
          <view class="right-icon"></view>
          <!-- 一键领取 -->
          <view class="all-get-btn" @click="handleGetAllCoupon" v-if="!isGet">一键领取</view>
          <view class="all-get-btn no-get" @click="handleUseCoupon" v-else>立即使用</view>
        </view>
      </template>
      <template v-else>
        <view class="empty-box">
          <image class="emptyCart-img" :src="`${VUE_APP_STATIC_URL}static/images/searchEmpty.png`"></image>
          暂无优惠券
        </view>
      </template>

    </view>
    <view style="width: 100%;height: 80rpx"></view>
  </view>
</template>

<script setup>
import API from "../../config/api";
import { request } from "../../utils/request";
import { ref, getCurrentInstance } from 'vue';
import { onShow, onLoad } from "@dcloudio/uni-app";
import { VUE_APP_STATIC_URL } from "@/config/api";

const isGet = ref(false); // 是否已经领取
const channelActivityId = ref(null);
const list = ref([]);

onLoad((param) => {
  if (param.activityId) {
    channelActivityId.value = param.activityId
  }
})

onShow(() => {
  let currentPages = getCurrentPages();
  let curRoute = currentPages[currentPages.length - 1]
  let queryObj = curRoute.$route.query
  let channelActivityIdData = null
  if(Object.keys(queryObj).length>0){
    // 永远拿第一个参数的key
    channelActivityIdData=Object.keys(queryObj)[0]
  }
  channelActivityId.value = channelActivityIdData
  if(!channelActivityId.value){
    uni.showToast({
      icon: "error",
      title: "未携带活动ID"
    })
    setTimeout(() => {
      uni.switchTab({url: "/pages/tabbar/index/index"})
    }, 1000)
    return
  }
  handleCouponGetList()
})

const handleCheckIsGet = () => {
  const every = list.value.every(item=>item.state === 0);
  isGet.value = every
}

const handleUseCoupon = (isAll = true, item=null) => {
  if(isAll){
    uni.redirectTo({
      url:"/pages_category_page2/userModule/coupon"
    })
  }else{
    uni.redirectTo({
      url:"/pages_category_page1/goodsModule/couponShopList?shopCouponId="+item.couponId
    })
  }
}

// 获取优惠券列表
const handleCouponGetList = () => {
  uni.showLoading()
  request(API.getCouponsByActivityId + "?activityId=" + channelActivityId.value, {}, 'GET').then(res => {
    list.value = res.data
    handleCheckIsGet()
  }).finally(() => {
    uni.hideLoading()
  })
}

// 领取优惠券
const handleGetCoupon = (item) => {
  return
  uni.showLoading()
  const paramsData = {
    shopCouponId:item.couponId,
    source:5
  }
  request(API.ReceiveCoupon, paramsData, 'POST').then(res => {
    uni.hideLoading()
    uni.showToast({
      title: '领取成功',
      icon: "success"
    })
    handleCouponGetList()
  }).finally(() => {
    uni.hideLoading()
  })
}

// 一键领取
const handleGetAllCoupon = () => {
  const params = []
  list.value.forEach(item=>{
    const param = {
      shopCouponId:item.couponId,
      source:5
    }
    params.push(param)
  })
  if(params.length<=0)return uni.showToast({title:"没有可领取的优惠券~",icon:"none"})
  uni.showLoading()
  request(API.takeChannelActivityCoupon, {activityId: channelActivityId.value}, 'POST').then(res => {
    uni.showToast({
      title:"领取成功"
    })
    // uni.hideLoading()
    setTimeout(()=>{
      handleCouponGetList()
    },1000)
  }).finally(() => {
    // uni.hideLoading()
  })
}
</script>
<style
    lang="scss"
    scoped
>
@import '../../style/images';
.pink-color {
  background-color: #fdedea;
}

.content {
  width: 100%;
  min-height: 100vh;
  background: $channelBg no-repeat #FFFFFF;
  background-size: 100vw 100vh;
  padding: 380rpx 30rpx 0 30rpx;
  box-sizing: border-box;

  .coupon-box {
    width: 100%;
    min-height: 60vh;
    padding: 30rpx;
    background-color: #fff;
    border-radius: 32rpx;
    box-sizing: border-box;
    position: relative;


    .empty-box{
      width: 100%;
      //height: 100%;
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      font-size: 24rpx;
      font-weight: 400;
      color: #999999;
      image{
        width: 330rpx;
        height: 193rpx;
        display: inline-block;
        margin: 140rpx 0 30rpx 0;
      }
    }

    .coupon-item {
      width: 100%;
      min-height: 180rpx;
      margin: 16rpx 0;
      box-sizing: border-box;
      display: flex;
      align-items: stretch;
      justify-content: space-between;

      .price-info {
        position: relative;
        background-image: radial-gradient(8px at right bottom, #fff, #fff 8px, transparent 8px),
        radial-gradient(8px at right top, #fff, #fff 8px, transparent 10px);
        padding: 20rpx 15rpx 20rpx 30rpx;
        width: 25%;
        display: flex;
        flex-direction: column;
        justify-content: center;
        align-items: center;
        flex: 1 0 auto;

        .price {
          font-size: 64rpx;
          font-family: PingFang SC-Semibold, PingFang SC;
          font-weight: 600;
          color: #E85A2B;

          span {
            font-size: 32rpx;
          }
        }

        .info {
          font-size: 24rpx;
          font-family: PingFang SC-Regular, PingFang SC;
          font-weight: 400;
          color: #E85A2B;
        }

        .line {
          position: absolute;
          top: 50%;
          transform: translateY(-50%);
          right: 0;
          z-index: 999;
          width: 2rpx;
          height: 70%;
          border-right: 2rpx dashed #ffc1ad;
        }
      }

      .coupon-info {
        background-image: radial-gradient(8px at left bottom, #fff, #fff 8px, transparent 8px),
        radial-gradient(8px at left top, #fff, #fff 8px, transparent 10px);
        padding: 20rpx 30rpx 20rpx 15rpx;
        width: 70%;
        flex: 1 0 auto;
        //height: 100%;
        display: flex;
        align-items: stretch;
        justify-content: space-between;

        .coupon-desc {
          width: 80%;
          //height: 100%;
          display: flex;
          flex-direction: column;
          justify-content: space-between;
          align-items: flex-start;

          .name {
            font-size: 32rpx;
            font-family: PingFang SC-Semibold, PingFang SC;
            font-weight: 600;
            color: #E85A2B;
          }

          .time {
            font-size: 20rpx;
            font-family: PingFang SC-Regular, PingFang SC;
            font-weight: 400;
            color: #E85A2B;
          }
        }

        .get-btn {
          background-color: #E85A2B;
          color: #fff;
          max-height: 68rpx;
          border-radius: 68rpx;
          padding: 16rpx 40rpx;
          font-size: 24rpx;
          font-family: PingFang SC-Medium, PingFang SC;
          font-weight: 500;
          white-space: nowrap;
          box-sizing: border-box;
        }

        .can-not-get {
          background-color: #E85A2B;
          color: #FFFFFF;
          border: 2rpx solid #E85A2B;
        }
      }
      .right-icon {
        width: 8rpx;
        background: $allGet no-repeat;
      }
    }

    .all-get-btn {
      z-index: 9999;
      width: 80%;
      height: 100rpx;
      border-radius: 96rpx;
      position: absolute;
      bottom: 20rpx;
      left: 50%;
      transform: translateX(-50%);
      text-align: center;
      line-height: 100rpx;
      background: #E85A2B;
      color: #FFFFFF;
    }
    .no-get{
      background-size: 100% 100%;
    }
  }
}
.empty-box {
  .emptyCart-img{
    width: 225rpx !important;
    height: 196rpx !important;
  }
}
</style>
