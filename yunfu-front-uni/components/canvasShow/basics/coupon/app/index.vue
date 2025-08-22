<template>
  <div class="coupon">
    <div class="coupon-list">
      <div class="coupon-item" v-for="(item,index) in couponsData" :key="index" :class="item.state && item.state !== 3 && 'isReceive'">
        <!-- #ifdef MP-WEIXIN -->
        <image class="coupon-item-bg" :src="`${VUE_APP_STATIC_URL}static/canvas-images/coupon/bg-coupon.png`" v-if="item.state && item.state === 3" mode="widthFix" />
        <image class="coupon-item-bg" :src="`${VUE_APP_STATIC_URL}static/canvas-images/coupon/bg-coupon2.png`" v-else mode="widthFix" />
        <!-- #endif -->
        <!-- #ifdef H5 || APP-PLUS -->
<!--        <image class="coupon-item-bg" src="../../../static/images/coupon/bg-coupon.png`" v-if="item.state && item.state === 3" mode="widthFix">-->
<!--        <image class="coupon-item-bg" src="../../../static/images/coupon/bg-coupon2.png`" v-else mode="widthFix">-->
        <!-- #endif -->
        <div class="coupon-item-cont">
        <div class="coupon-item-content">
          <div class="coupon-item-price">
            <div class="span" v-if="item.couponType !== 2">￥</div>
            <div class="b" v-if="typeId !== 1">{{item.couponContent}}</div>
            <div class="b" v-else>{{item.reduceMoney}}</div>
            <div class="b" v-if="item.couponType == 2">折券</div>
          </div>
          <div class="coupon-item-date">{{item.startTime.split(' ')[0].replace(/-/g, '.')}}-{{item.endTime.split(' ')[0].replace(/-/g, '.')}}</div>
          <div class="coupon-item-text">{{item.content}}</div>
        </div>
        <button v-if="item.state === 0" class="coupon-item-btn">已领取</button>
        <button v-else-if="item.state === 1" class="coupon-item-btn">已使用</button>
        <button v-else-if="item.state === 2" class="coupon-item-btn">已过期</button>
        <button v-else @click="receiveCoupon(item)" class="coupon-item-btn">立即领取</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import couponMixin from '../mixin';
import { toRefs } from 'vue';
import { VUE_APP_STATIC_URL } from "@/config/api";

const props = defineProps({
  typeId: {
    type: Number,
    default: 1,
  },
  shopId: {
    type: Number,
    default: 0,
  },
  componentContent: {
    type: Object,
    default () {
      return {}
    },
  },
});
const { typeId, shopId, componentContent } = toRefs(props);
const { couponsData, receiveCoupon, jumpStore } = couponMixin(componentContent, typeId, shopId);
</script>

<style lang="scss" scoped>
.coupon {
  padding: 25upx;
  &-list{
    display: flex;
    flex-wrap: wrap;
  }
  &-item{
    width: 335upx;
    height: 292upx;
    margin-left: 28upx;
    text-align: center;
    position: relative;
    margin-bottom: 10upx;
    &-bg{
      width: 100%;
      height: 100%;
    }
    &-cont{
      position: absolute;
      width: 100%;
      height: 100%;
      left: 0;
      top: 0;
    }
    &:nth-child(2n+1){
      margin-left: 0;
    }
    &-content{
      text-align: center;
    }
    &-price{
      color: #C5AA7B;
      margin: 26upx 0 10upx;
      .span{
        display: inline;
        font-size: 36upx;
        line-height: 68upx;
      }
      .b{
        display: inline;
        font-size: 50upx;
        line-height: 68upx;
      }
    }
    &-date,&-text{
      font-size: 20upx;
      line-height: 28upx;
      color: #999999;
    }
    &-date{
      margin-bottom: 8upx;
    }
    &-btn{
      display: inline-block;
      margin: 60upx auto 0;
      height: 48upx;
      line-height: 48upx;
      background-color: #C5AA7B;
      color: #fff;
      font-size: 14upx
    }
    &.isReceive{
      &-price{
        color: #999;
      }
      &-btn{
        background-color: #ccc;
      }
    }
  }
}
</style>
