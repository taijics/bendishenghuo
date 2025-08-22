<template>
  <view class="coupon-popup" :class="showActivity && 'show'" >
    <global-loading />
    <view class="mask" @click="closePopup"></view>
    <view class="couponShow-box" id="popupInner">
        <view class="tabsbox">
            <u-tabs
              :list="activeTypeList"
              bar-width="0"
              bar-height="0"
              :bold="false"
              active-color="#C5AA7B"
              inactive-color="#999999"
              :is-scroll="false"
              :current="activeTypeFlag"
              @change="activeTypeActive"
            ></u-tabs>
        </view>
        <view v-show="activeTypeFlag === 0">
          <view class="couponShow">
            <view class="title-box">
              <image class="close-btn" @click="onActivityClose" :src="`${VUE_APP_STATIC_URL}static/images/close.png`"></image>
            </view>
            <view class="shopCouponBox" :class="markTools.length === 0 && 'flex'">
              <view class="list" v-if="markTools.length > 0">
                <view class="item"
                      v-for="(item, index) in markTools"
                      :key="index"
                      :class="{received: item.state === 1}"
                >
                  <view class="info-box">
                    <view class="discoun" v-if="item.couponType == 1"><text style="font-size: 28rpx">￥</text>{{item.reduceMoney}}</view>
                    <view class="discoun" v-if="item.couponType == 2">{{item.reduceMoney}}折</view>
                    <view class="info-date">{{getDate(item.startTime)}}-{{getDate(item.endTime)}}</view>
                    <view class="info-condition mar-top-30">{{item.content}}</view>
                    <!--                  <view class="info-condition" v-if="item.couponType == 2">{{item.reduceMoney}}折优惠</view>-->
                    <wx-send-coupon @success="success" v-if="item.state === 3" :couponList="[item]">
                      <view class="use-btn mar-top-10"
                            v-if="item.state === 3">
                        立即领取
                      </view>
                    </wx-send-coupon>
                    <view class="use-btn mar-top-10" v-if="item.state === 0">已领取</view>
                    <view class="use-btn mar-top-10" v-if="item.state === 1">已使用</view>
                  </view>
                </view>
              </view>
              <view v-else class="emptyOrder-box flex-items-plus flex-column">
                <image class="emptyOrder-img" :src="`${VUE_APP_STATIC_URL}static/img/bgnull.png`"></image>
                <label class="font-color-999 fs26 mar-top-30">你还没有优惠券哦～</label>
              </view>
            </view>
          </view>
        </view>
        <view v-show="activeTypeFlag === 1">
          <view class="couponShow">
            <view class="title-box">
              <image class="close-btn" @click="onActivityClose" :src="`${VUE_APP_STATIC_URL}static/images/close.png`"></image>
            </view>
            <view class="shopCouponBox" :class="shopMarkTools.length === 0 && 'flex'">
              <view class="list" v-if="shopMarkTools.length > 0">
                <view
                    class="item"
                    v-for="(item, index) in shopMarkTools"
                    :key="index"
                    :class="{received: item.state === 1}"
                >
                  <view class="info-box">
                    <view class="discoun" v-if="item.couponType === 1"><text
                        style="font-size: 28rpx">￥</text>{{item.reduceMoney}}</view>
                    <view class="discoun" v-if="item.couponType === 2">{{item.reduceMoney}}折</view>
                    <view class="info-date">{{getDate(item.startTime)}}-{{getDate(item.endTime)}}</view>
                    <view class="info-condition" v-if="item.couponType === 1">
                      满{{item.fullMoney}}元减{{item.reduceMoney}}元</view>
                    <view class="info-condition" v-if="item.couponType === 2">{{item.reduceMoney}}折优惠
                    </view>
                    <view class="use-btn" @click="receiveTap(item,1)" v-if="item.state === 3">立即领取
                    </view>
                    <view class="use-btn" v-if="item.state === 0">已领取</view>
                  </view>
                </view>
              </view>
              <view v-else class="emptyOrder-box flex-items-plus flex-column">
                <image class="emptyOrder-img" :src="`${VUE_APP_STATIC_URL}static/img/bgnull.png`"></image>
                <label class="font-color-999 fs26 mar-top-30">你还没有优惠券哦～</label>
              </view>
            </view>
          </view>
        </view>
        <view class="receive-success" v-if="isShowSuccess">
            <view class="success-box">
                <image class="success-img" :src="`${VUE_APP_STATIC_URL}static/images/success_tu.png`"></image>
                <view class="text">领取成功</view>
            </view>
        </view>
    </view>
  </view>
</template>

<script setup>
import WxSendCoupon from "@/components/wx/wxSendCoupon";
import { request } from "@/utils/request";
import API from "@/config/api";
import { ref, toRefs } from "vue";
import { VUE_APP_STATIC_URL } from "@/config/api";

const props = defineProps({
  markTools: {
    type: Array,
    default: ()=>[]
  },
  shopMarkTools: {
    type: Array,
    default: ()=>[]
  },
  setTop: {
    type: Number,
    default: 0,
  },
  currentActive: {
    type: Number,
    default: 0
  }
})
const {markTools,shopMarkTools,setTop,currentActive} = toRefs(props)

const showActivity = ref(false)
const isShowSuccess = ref(false)
const activeTypeFlag = ref(currentActive.value)
const activeTypeList = ref([{
  name: '平台活动'
}, {
  name: '店铺活动'
}])

function activeTypeActive(index) {
  activeTypeFlag.value = index
}
//关闭优惠券弹窗
function onActivityClose() {
  showActivity.value = false
}
// 时间格式化
function getDate(time) {
  if (!time) return '';
  return time.split(' ')[0].split('-').join('.');
}

const shopId = ref('')
// 领取优惠券
function receiveTap(couponItemInfo, type) {
  let ReceiveCoupon
  if (type === 0) {
    ReceiveCoupon = {
      couponId: couponItemInfo.couponId,
    }
  } else {
    ReceiveCoupon = {
      shopCouponId: couponItemInfo.shopCouponId,
    }
  }
  request(API.ReceiveCoupon, ReceiveCoupon, 'POST').then(res => {
    // uni.hideLoading()
    isShowSuccess.value = true
    setTimeout(() => {
      isShowSuccess.value = false
      // showActivity = false;
      // queryProductDetail()
    }, 1500);
    // setTimeout(() => {
    // 	showActivity = false
    // }, 3000);
  }).catch(res => {
    // uni.hideLoading()
    uni.showToast({
      title: res.msg,
      icon: 'none'
    })
    throw Error(res)
  })
}

function success(){
  isShowSuccess.value = true
  setTimeout(() => {
    isShowSuccess.value = false
  }, 1500);
}
function closePopup(){
  showActivity.value = false;
}

defineExpose({showActivity})
</script>

<style lang="scss" scoped>
@import "../../style/images";
.coupon-popup{
    display: block;
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    overflow: hidden;
    // background-color: rgba(0, 0, 0, 0.6);
    z-index: -1;
    opacity: 0;
    &.show{
        z-index: 1000;
        opacity: 1;
        .couponShow-box{
            /*transform: translate3D(0px, 0px, 0px);*/
            bottom: 0;
        }
    }
	.mask{
		display: block;
		position: fixed;
		width: 100%;
		height: 100%;
		top: 0;
		left: 0;
		right: 0;
		bottom: 0;
		overflow: hidden;
		background-color: rgba(0, 0, 0, 0.6);
		z-index:1001;
	}
    .couponShow-box{
      .couponShow {
        height: 1000rpx;
        z-index: 333;
      }
        width: 100%;
        height: auto;
        /*transform: translate3d(0px, 100%, 0px);*/
        transition: all 0.3s ease-in-out 0s;
        background-color: #fff;
        position: absolute;
        left: 0;
        right: 0;
        bottom: -100%;
		z-index: 1002;
        .tabsbox{
            padding:0 20rpx;
            :deep(.u-tab-item){
                height: 100rpx !important;
                line-height: 100rpx !important;
            }
        }
        .title-box .close-btn {
            width: 50upx;
            height: 50upx;
            box-sizing: border-box;
            position: absolute;
            top: 20upx;
            right: 20upx;
        }

        // #ifdef MP-ALIPAY
        .title-box .close-btn {
            width: 30upx;
            height: 30upx;
            top: 10upx;
            right: 10upx;
        }
        // #endif
        .shopCouponBox {
            height: 100%;
            overflow: auto;
            position: relative;
            &.flex{
                display: flex;
                justify-content: center;
                align-items: center;
            }
            .emptyOrder-box {
                position: absolute;
                top: 0;
                bottom: 0;
                right: 0;
                left: 0;
                margin: auto;
                // padding-top: 80upx;
                .emptyOrder-img {
                    width: 225upx;
                    height: 196upx;
                }
            }
            .list {
                display: flex;
                flex-wrap: wrap;
            }
            .item {
                width: 50%;
                height: 291rpx;
                background: $couponsIcon no-repeat center top;
                border-radius: 10rpx;
                margin-top: 20rpx;
                display: flex;
                flex-direction: row;
                position: relative;
                background-size: contain;
                padding: 0 50rpx;
                margin-bottom: 30rpx;
            }
            .received {
                background: $couponsIcon1 no-repeat center top;
                background-size: contain;
                .discoun {
                    color: #999999;
                    padding-top: 35rpx;
                }
                .use-btn {
                    height: 48rpx;
                    border: 2rpx solid #CCCCCC;
                    line-height: 48rpx;
                    text-align: center;
                    font-size: 24rpx;
                    font-weight: 400;
                    background-color: #CCCCCC;
                    color: #FFFFFF;
                    margin: 50rpx auto 0 auto;
                    padding: 0 10rpx;
                }
            }

            /*.item:last-child {*/
                /*margin-bottom: 100rpx;*/
            /*}*/

            .discoun {
                display: flex;
                flex-direction: row;
                align-items: baseline;
                font-size: 40rpx;
                color: #C5AA7B;
                margin: 0 auto;
                padding-top: 40rpx;
            }
            .discoun text {
                display: inline-block;
            }
            .info-box {
                width: 100%;
                display: flex;
                flex-direction: column;
                align-items: center;
            }
            .info-condition {
                font-size: 20rpx;
                font-weight: 400;
                color: #999999;
                margin:0 auto;
            }
            .info-date {
                font-size: 20rpx;
                font-family: PingFang SC;
                font-weight: 400;
                color: #999999;
                margin: 10rpx auto;
                line-height: 20rpx;
            }
            .use-btn {
                height: 48rpx;
                border: 2rpx solid #C5AA7B;
                line-height: 48rpx;
                text-align: center;
                font-size: 24rpx;
                font-weight: 400;
                background-color: #C5AA7B;
                color: #FFFFFF;
                margin: 50rpx auto 0 auto;
                padding: 0 10rpx;
            }
        }
    }
}
.receive-success {
    width: 100%;
    position: fixed;
    top: 0;
    bottom: 0;
    left: 0;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    z-index: 8888;
    .success-box {
        width: 380upx;
        height: 280upx;
        background: rgba(0, 0, 0, 0.5);
        border-radius: 10upx;
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        .success-img {
            width: 200upx;
            height: 130upx;
        }
        .text {
            font-size: 28upx;
            margin-top: 50upx;
            font-weight: 400;
            color: rgba(255, 255, 255, 1);
        }
    }
}
</style>
