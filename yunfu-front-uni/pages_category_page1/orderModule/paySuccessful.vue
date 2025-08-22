<template>
  <view class="payCourteous">
    <global-loading />

    <view
        class="payTitBox flex-items flex-center"
        :style="{'padding-top': topHeight + 'px'}"
    >
      <view class="payTit fs30">支付成功</view>
    </view>
    <view class="resultCard">
      <view class="imgBox">
        <image :src="`${VUE_APP_STATIC_URL}static/images/payIcon.png`"></image>
      </view>
      <view class="successful">支付成功</view>
      <view class="btnBox fs28 font-color-333">
        <view
            class="orderBtn btn"
            @click="goToOrder"
        >查看订单
        </view>
        <view
            class="homeBtn btn"
            @click="goToHome"
        >返回首页
        </view>
      </view>
      <view
          class="orderPolite"
          v-if="orderPolite.growth || orderPolite.couponList"
      >
        <view class="politeImgBox">
          <image :src="`${VUE_APP_STATIC_URL}static/images/politeIcon.png`"></image>
        </view>
        <view class="rightInfo">
          <view
              class="growthBox"
              v-if="orderPolite.credit"
          >
            恭喜获得额外积分
            <text class="growth">{{ orderPolite.credit }}</text>
          </view>
          <view
              class="growthBox"
              v-if="orderPolite.growth"
          >
            恭喜获得额外会员成长值
            <text class="growth">{{ orderPolite.growth }}</text>
          </view>
          <view
              class="couponBox"
              v-for="(item, index) of orderPolite.couponList"
              :key="index"
          >
            恭喜获得
            <text class="coupon">{{ item.discount }}</text>
            {{ item.couponType === 1 ? '满减优惠券' : '折扣券' }}
          </view>
        </view>
      </view>
    </view>

    <!-- 推荐 -->
    <HotTemplate />
    <!-- 广告 -->
    <ad-window ref="adWindow"
        :triggerCondition="2"
    ></ad-window>
  </view>
</template>

<script setup>
import HotTemplate from '@/components/hoteRecommed/index.vue'
import AdWindow from "../../components/adWindow";

import { request } from '../../utils/request'
import API from "../../config/api";
import { onLoad, onShow } from "@dcloudio/uni-app";
import { nextTick, ref } from "vue";
import { VUE_APP_STATIC_URL } from "@/config/api";

onShow(() => {
  // #ifdef MP-WEIXIN || MP-BAIDU || MP-TOUTIAO || MP-QQ
  let menuButtonInfo = uni.getMenuButtonBoundingClientRect()
  topHeight.value = menuButtonInfo.top + 10
  // #endif
})
const adWindow = ref()
onLoad(option => {
  orderId.value = option.orderId
  if (orderId.value) {
    getOrderPoliteFn()
  }
  nextTick(() => {
    adWindow.value.getAd()
  })
})

const orderId = ref(null)
const orderPolite = ref({})
const topHeight = ref(0)

function goToOrder() {
  uni.navigateTo({
    url: '../orderModule/index'
  })
}

function goToHome() {
  uni.switchTab({
    url: '../../pages/tabbar/index/index'
  })
}

function getOrderPoliteFn() {
  // uni.showLoading({
  //   mask: true,
  //   title: '加载中...',
  // })
  request(API.getOrderPolite, {
    orderId: orderId.value
  }, 'GET').then(res => {
    uni.hideLoading()
    orderPolite.value = res.data
  }).catch(res => {
    uni.hideLoading()
  })
}
</script>

<style
    lang="scss"
    scoped
>
.payCourteous {
  .payTitBox {
    height: 100rpx;
    position: fixed;
    left: 0;
    top: 0;
    width: 100%;
    background: #FFFFFF;
    z-index: 99;
  }

  .resultCard {
    padding: 200rpx 0 50rpx 0;

    .imgBox {
      padding-top: 100rpx;
      display: flex;
      justify-content: center;

      image {
        width: 166rpx;
        height: 121rpx;
      }
    }

    .successful {
      text-align: center;
      margin-top: 30rpx;
    }

    .btnBox {
      display: flex;
      justify-content: center;
      margin-top: 30rpx;

      .btn {
        width: 140rpx;
        height: 58rpx;
        line-height: 58rpx;
        border: 2rpx solid #999999;
        text-align: center;
        font-size: 24rpx;
        color: #999999;
      }

      .orderBtn {
        margin-right: 30rpx;
      }

      .homeBtn {
        background: #333333;
        border: none;
        color: #FFEBC4;
      }
    }

    .orderPolite {
      display: flex;
      align-items: center;
      width: 670rpx;
      background: #FFF9F6;
      border: 2rpx solid #FBE9E6;
      margin: 50rpx auto 0 auto;
      padding: 0 30rpx;
      box-sizing: border-box;

      .politeImgBox {
        image {
          width: 186rpx;
          height: 186rpx;
        }
      }

      .rightInfo {
        flex: 1;
        font-size: 28rpx;
        color: #333333;

        .growthBox {
          margin-bottom: 30rpx;

          .growth {
            color: #C83732;
          }
        }

        .couponBox {
          margin-bottom: 30rpx;

          .coupon {
            color: #C83732;
          }

          &:last-child {
            margin-bottom: 0 !important;
          }
        }
      }
    }
  }
}
</style>
