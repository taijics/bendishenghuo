<template>
  <div class="coupon">
    <div class="coupon-list">
      <div class="coupon-item" v-for="(item,index) in couponsData" :key="index" :class="item.state && item.state !== 3 && 'isReceive'">
        <div class="coupon-item-content">
          <div class="coupon-item-price">
            <span v-if="item.couponType !== 2">￥</span>
            <b v-if="typeId !== 1">{{item.couponContent}}</b>
            <b v-else>{{item.reduceMoney}}</b>
            <b v-if="item.couponType == 2">折券</b>
          </div>
          <div class="coupon-item-date">{{item.effectiveStart.split(' ')[0]}} - {{item.effectiveEnd.split(' ')[0]}}</div>
          <div class="coupon-item-text">{{item.content}}</div>
        </div>
        <button v-if="item.state === 0" class="coupon-item-btn" @click="jumpStore(item)">立即使用</button>
        <button v-else-if="item.state === 1" class="coupon-item-btn">已使用</button>
        <button v-else-if="item.state === 2" class="coupon-item-btn">已过期</button>
        <button v-else @click="receiveCoupon(item)" class="coupon-item-btn">立即领取</button>
      </div>
    </div>
  </div>
</template>

<script>
import {commonMixin} from '../mixin'
export default {
  mixins: [commonMixin]
}
</script>

<style lang="scss" scoped>
.coupon {
  padding: 25px;
  &-list{
    display: flex;
    flex-wrap: wrap;
  }
  &-item{
    width: 335px;
    height: 292px;
    background: url("../../../static/images/coupon/bg-coupon.png") no-repeat;
    margin-left: 28px;
    &:nth-child(2n+1){
      margin-left: 0;
    }
    &-content{
      text-align: center;
    }
    &-price{
      color: #C5AA7B;
      margin: 26px 0 10px;
      span{
        font-size: 36px;
        line-height: 68px;
      }
      b{
        font-size: 50px;
        line-height: 68px;
      }
    }
    &-date,&-text{
      font-size: 20px;
      line-height: 28px;
      color: #999999;
    }
    &-date{
      margin-bottom: 8px;
    }
    &-btn{
      display: block;
      margin: 60px auto 0;
      width: 112px;
      height: 48px;
      background-color: #C5AA7B;
      color: #fff;
    }
    &.isReceive{
      background-image: url("../../../static/images/coupon/bg-coupon2.png");
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
