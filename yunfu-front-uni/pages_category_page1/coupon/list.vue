<template>
  <view class="couponList u-skeleton">
    <Skeleton
        el-color="#efefef"
        bg-color="#fff"
        :loading="loading && isFirstComeIn"
        :animation="true"
    />
    <template v-if="couponList.length>0">
      <view
          class="couponItem u-skeleton-rect flex-items"
          v-for="item of couponList"
          :key="item.couponId"
      >
        <view
            class="itemLeft u-skeleton-rect"
            @click="goProductList(item)"
        >
          <view class="topIcon"></view>
          <view class="bottomIcon"></view>
          <view class="price flex-items">
            <view
                class="flex-column flex-end unitBox"
                v-if="item.discountMode === 1"
            >
              <view class="unit">￥</view>
            </view>
            <view class="priceValue">{{ item.reduceMoney }}{{ item.discountMode === 1 ? '' : '折' }}</view>
          </view>
          <text class="fs24 font-color-999">满{{ item.fullMoney }}元可用</text>
        </view>
        <view class="itemRight u-skeleton-rect">
          <view class="topInfo flex-items flex-sp-between">
            <view @click="goProductList(item)">
              <view class="couponTit fs32 font-color-FFF">{{ item.activityName }}</view>
              <view class="couponDate fs24 font-color-999">{{ item.endTime }}到期</view>
            </view>
            <view class="exchangeBtnBox flex-column flex-end">
              <view
                  class="exchangeBtn fs24 font-color-FFF"
                  v-if="item.state === 0"
              >已领取
              </view>
              <wx-send-coupon
                  v-else
                  @success="success"
                  :couponList="[item]"
              >
                <view class="exchangeBtn fs24 font-color-FFF">{{ item.ifCredit ? '立即兑换' : '立即领取' }}</view>
              </wx-send-coupon>
            </view>
          </view>
          <view
              @click="goProductList(item)"
              class="couponType fs28 font-color-FFF"
          >{{ item.discountMode === 1 ? '满减券' : '折扣券' }}
          </view>
        </view>
      </view>
      <!-- 触底 -->
      <view
          class="reachBottom"
          v-if="topLeft > 400 && couponList.length>0"
      >
        <image
            class="reach-icon"
            :src="`${VUE_APP_STATIC_URL}static/img/reachBottom.png`"
            mode="widthFix"
        ></image>
        <text class="reach-text">这里到底了哦~~</text>
      </view>
    </template>
    <Empty :show="couponList.length<=0" />
  </view>
</template>

<script setup>
import { ref } from "vue";
import { onLoad, onReachBottom, onPageScroll } from "@dcloudio/uni-app";
import Skeleton from "../../components/Skeleton";
import Empty from "../../components/Empty";
import WxSendCoupon from "../../components/wx/wxSendCoupon";
import { request } from "../../utils/request"
import API from "@/config/api";
import { VUE_APP_STATIC_URL } from "@/config/api";

const loading = ref(false)
const isFirstComeIn = ref(true)
const couponList = ref([{},{},{},{},{},{}])
const page = ref(1)
const pageSize = ref(20)
const loadingType = ref(0)
const topLeft = ref(0)

onLoad(() => {
  getCouponList()
})

onReachBottom(() => {
  if (loadingType.value == 1) {
    uni.stopPullDownRefresh()
  } else {
    page.value = page.value + 1
    getCouponList()
  }
})

onPageScroll((e) => {
  topLeft.value = e.scrollTop
})
/**
 * 获取券列表
 * @returns {Promise<void>}
 */
const getCouponList = async () => {
  loading.value = true
  try {
    const res = await request(API.getCoupons, {
      page: page.value,
      pageSize: pageSize.value
    }, 'GET')
    if (res.data.list.length === 0) {
      loadingType.value = 1
    } else {
      couponList.value = couponList.value.concat(res.data.list)
      // this.$forceUpdate()
    }
    couponList.value= couponList.value.filter(item => JSON.stringify(item) !== '{}')
    loading.value = false
    isFirstComeIn.value = false
  } catch (err) {
    throw Error(err)
  }
}

/**
 * 跳转到可用商品列表
 * @param item
 */
const goProductList = (item) => {
  uni.navigateTo({
    url: `../coupon/product?id=${ item.couponId }`
  })
}
/**
 * 领取优惠券
 */
const success = () => {
  page.value = 1
  couponList.value = []
  getCouponList()
}
</script>

<style
    lang="scss"
    scoped
>
@import "../../style/images";
page {
  background: #F8F8F8 !important;

  .couponList {
    padding: 0 20rpx 40upx;
    margin-top: 30rpx;

    .couponItem {
      background: #333333;
      margin-top: 40rpx;
      padding: 25rpx 35rpx;
      overflow: hidden;
      background-image: $borderIcon;
      background-repeat: no-repeat;
      background-size: contain;
      background-position: right top;

      .itemLeft {
        padding-right: 10rpx;
        position: relative;
        border-right: 2rpx dashed #666666;
        width: 170rpx;

        .topIcon {
          position: absolute;
          right: -16rpx;
          top: -50rpx;
          width: 32rpx;
          height: 32rpx;
          background: #FFFFFF;
          border-radius: 50%;
        }

        .bottomIcon {
          position: absolute;
          right: -16rpx;
          bottom: -50rpx;
          width: 32rpx;
          height: 32rpx;
          background: #FFFFFF;
          border-radius: 50%;
        }

        //.price {
        //  width: 100rpx;
        //}
        .unitBox {
          height: 70rpx;
        }

        .unit {
          color: #FFEBC4;
          font-size: 36rpx;
        }

        .priceValue {
          font-size: 52rpx;
          color: #FFEBC4;
        }
      }

      .itemRight {
        padding-left: 45rpx;
        flex: 1;

        .topInfo {
          padding-bottom: 10rpx;
          border-bottom: 2rpx solid #444444;
          margin-bottom: 10rpx;

          .couponDate {
            width: 300rpx;
          }

          .exchangeBtnBox {
            width: 110rpx;
            height: 70rpx;
            text-align: center;

            .exchangeBtn {
              padding: 5rpx;
              border: 2rpx solid #999999;
            }
          }
        }
      }
    }
  }

  .Put-box1 {
    .btn {
      text-align: center;
      margin-top: 40rpx;
      border: 2rpx solid #333333;
      height: 80upx;
      line-height: 80upx;
      width: 100%;
      color: #333333;
    }

    .submit {
      background-color: #333333;
      color: #FFEBC4;
      margin-left: 20rpx;
    }
  }
}

// 触底样式
.reachBottom {
  margin-top: 30rpx;
  display: flex;
  flex-direction: column;
  align-items: center;

  .reach-icon {
    width: 150rpx;
    height: 150rpx;
  }

  .reach-text {
    margin: 20rpx 0;
    color: #CCCCCC;
  }
}
</style>
