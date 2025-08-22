<template>
  <view v-if="visible">
    <view v-if="adInfo.jumpType === 3 && couponList && couponList.length> 0"
          class="mask mask-coupon ad-coupons"
          @touchmove.stop.prevent="moveHandle">
      <view class="ad-box-warp">
        <view class="ad-boxs">
          <image class="img"
                 :src="adInfo.popupImg"
                 ></image>
          <view class="coupon-list">
            <scroll-view :scroll-top="0"
                         class="scrollBox"
                         scroll-y="true">
              <view class="item"
                    v-for="(item, index) in couponList"
                    :key="index">
                <view class="leftBox borderBox">
                  <view class="boxTop"></view>
                  <view class="boxCent"></view>
                  <view class="boxBottom"></view>
                </view>
                <view class="centerBox">
                  <view class="money">
                    <text class="num"
                          :class="[item.discountMode ===1?'num-minus':'num-discount']">{{ item.reduceMoney }}
                    </text>
                    <text class="text">
                      满{{ item.fullMoney }}元可用
                    </text>
                  </view>
                  <view class="text">
                    <text>
                      {{ item.activityName }}
                    </text>
                  </view>
                </view>
                <view class="rightBox borderBox">
                  <view class="boxTop"></view>
                  <view class="boxCent"></view>
                  <view class="boxBottom"></view>
                </view>
              </view>
            </scroll-view>
          </view>
          <WxSendCoupon v-if="couponList && couponList.length > 0"
                        :couponList="couponList"
                        @closeAd="close">
            <view class="btn-receive">一键领取</view>
          </WxSendCoupon>
        </view>
        <view class="close-btn">
          <image :src="adInfo.closeImg"
                 class='btn'
                 mode="widthFix"
                 @click="close()"></image>
        </view>
      </view>
    </view>
    <view v-else-if="adInfo.jumpType !== 3"
          class="mask mask-coupon ad-link">
      <view class="ad-box-warp">
        <view class="ad-boxs"
              @click="goRoll()">
          <image class="img"
                 :src="adInfo.popupImg"
                 mode="widthFix"></image>
        </view>
        <view class="close-btn">
          <image :src="adInfo.closeImg"
                 class='btn'
                 mode="widthFix"
                 @click="close()"></image>
        </view>
      </view>
    </view>
  </view>
</template>

<script setup>
import { ref, toRefs} from 'vue';
import WxSendCoupon from "./wx/wxSendCoupon";
import API from "@/config/api";
import {request} from "@/utils/request"
const props = defineProps({
  triggerCondition: {
    type: Number,
    default: 1
  }
})
const { triggerCondition } = toRefs(props)
const visible = ref(false)
const adInfo = ref({})
const jumpContent = ref({})
const couponList = ref([])
const isLogin = ref(false)
const buyerUserId = ref(0)
const cParams = ref({})

// 阻止滑动
function moveHandle() {
  return
}
// 获取广告信息
function getAd() {
  console.log(triggerCondition.value,'triggerCondition000000')
  const res = uni.getStorageSync('storage_key'),
      token = res.token;
  setTimeout(() => {
    buyerUserId.value = res.buyerUserId
    isLogin.value = !!token
    console.log(buyerUserId.value,isLogin.value,triggerCondition.value)
    request(API.GetAd, {
      triggerCondition: triggerCondition.value
    }, 'POST').then(res => {
      console.log('广告数据', res)
      if (res.data?.length > 0) {
        adInfo.value = res.data[0]
        if (adInfo.value.jumpContent) {
          jumpContent.value = JSON.parse(adInfo.value.jumpContent)
        }
        visible.value = true
        if (adInfo.value.jumpType === 3) {
          getCoupons()
        }
      }
    }).catch(res => {
      throw Error(res)
    })
  }, 500)
}
// 查询优惠券
function getCoupons() {
  if (isLogin.value) {
    const _items = jumpContent.value.items
    if (_items) {
      request(API.getCoupons, {
        page: 1,
        pageSize: 99,
        ids: _items
      }, 'GET').then(res => {
        if (res.data) {
          couponList.value = res.data.list
        }
      }).catch(err => {
        throw Error(err)
      })
    }
  } else {
    uni.showToast({
      title: '登录之后领取更多优惠',
      icon: "none"
    })
    // uni.navigateTo({
    // 	url: '/pages_category_page2/userModule/login'
    // })
  }
}
// 关闭弹窗
function close() {
  visible.value = false
  var params = {}
  if (isLogin.value) {
    params.buyerUserId = buyerUserId.value
  } else {
    uni.getSystemInfo({
      success: function (res) {
        params.deviceId = res.deviceId
      }
    })
  }
  request(API.adClose, params, 'POST').then(res => {
  }).catch(err => {
    throw Error(err)
  })
}
function goRoll() {
  visible.value = false
  console.log(jumpContent.value, 'this.jumpContent')
  switch (adInfo.value.jumpType) {
    case 1:
      uni.navigateTo({
        url: '/pages_category_page1/goodsModule/goodsDetails?shopId=' + jumpContent.value
            .shopId + '&productId=' + jumpContent.value.id + '&skuId=' + jumpContent.value
            .skuId
      })
      break
    case 2:
      let _id = jumpContent.value.id[jumpContent.value.id.length - 1]
      let _depth = jumpContent.value.depth
      uni.navigateTo({
        url: `/pages_category_page1/goodsModule/goodsList?category3Id=${_id}&classifyLevel=${_depth}`
      })
      break
    case 4:
      uni.navigateToMiniProgram({
        appId: jumpContent.value.appId,
        path: jumpContent.value.link,
        success(res) {
          // 打开成功
        }
      })
    case 5:
      uni.navigateTo({
        path: jumpContent.value.link
      })
      break
  }
}
defineExpose({
  getAd
})
</script>

<style scoped
       lang="scss">
.mask {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  z-index: 55;
  background-color: rgba(0, 0, 0, 0.7);
}


.mask-coupon {
  z-index: 9999;
  /*background: rgba(39, 38, 39, .15);*/
  display: flex;
  justify-content: center;
  align-items: center;

  .ad-box-warp {
    width: 100%;
    position: relative;
  }

  flex-direction: column;

  .ad-boxs {
    position: relative;
    width: 100%;
    text-align: center;

    .img {
      width: 70%;
    }
  }

  .btn-receive {
    width: 446rpx;
    height: 84rpx;
    background: #EC6F43;
    border-radius: 42rpx;
    display: block;
    text-align: center;
    font-size: 28rpx;
    line-height: 84rpx;
    color: #fff;
    position: absolute;
    bottom: 32rpx;
    left: 50%;
    margin-left: -223rpx;
  }

  .close-btn {
    position: absolute;
    bottom: -70rpx;
    left: 50%;
    margin-left: -25rpx;

    .btn {
      width: 50rpx;
      height: 50rpx;
    }
  }
}

.ad-coupons {
  .ad-box-warp {
    width: 510rpx;
    position: relative;

    .ad-boxs {
      min-height: 700rpx;
      .img {
        position: absolute;
        top:0;
        left:0;
        width: 100%;
        height: 100%;
      }
    }
  }

  .coupon-list {
    width: 446rpx;
    height: 40%;
    overflow: auto;
    position: absolute;
    top: 40%;
    left: 50%;
    margin-left: -223rpx;

    .scrollBox {
      height: 450upx;
    }

    .item {
      width: 100%;
      height: 140rpx;
      margin-top: 15rpx;
      border-radius: 8rpx;
      display: flex;
      position: relative;
      align-items: center;
      overflow: hidden;

      &:first-child {
        margin-top: 0px;
      }

      .borderBox {
        width: 32rpx;
        height: 140rpx;
        overflow: hidden;

        .boxTop {
          width: 32rpx;
          height: 54rpx;
          background: #FFFFFF;
        }

        .boxCent {
          height: 36rpx;
          overflow: hidden;
          position: relative;

          &:after {
            content: '';
            width: 32rpx;
            height: 32rpx;
            border-radius: 50%;
            display: block;
            position: absolute;
            top: 50%;
            margin-top: -47rpx;
            left: -15rpx;
            border: 32rpx solid #FFFFFF;
          }
        }

        .boxBottom {
          width: 32rpx;
          height: 54rpx;
          background: #FFFFFF;
        }
      }

      .leftBox {
        .boxCent {
          &:after {
            left: -50rpx;
          }
        }
      }

      .rightBox {
      }

      .centerBox {
        display: flex;
        align-items: center;
        height: 140rpx;
        background: #FFFFFF;
        flex: 1;
      }

      .money {
        width: 190rpx;
        text-align: center;

        .num {
          font-size: 48rpx;
          color: #EC6F43;
          display: block;

          &.num-minus::before {
            content: '¥';
            font-size: 36rpx;
          }

          &.num-discount::after {
            content: '折';
            font-size: 36rpx;
          }
        }

        .text {
          font-size: 24rpx;
          color: #999;
        }
      }

      .text {
        flex: 1;
        padding-right: 16rpx;
        width: 0;

        text {
          font-size: 32rpx;
          color: #333;
          display: block;
          overflow: hidden;
          text-overflow: ellipsis;
          white-space: nowrap;
        }
      }
    }
  }
}
</style>
