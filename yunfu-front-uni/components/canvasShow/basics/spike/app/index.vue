<template>
  <div class="spike">
    <div class="spike-card" v-if="productData.products && productData.products.length>0">
      <div class="spike-card-top">
        <h2 class="spike-card-top-title">
          <!-- #ifdef MP-WEIXIN -->
          <image class="title-img" :src="`${VUE_APP_STATIC_URL}static/canvas-images/spike/img-title.png`" alt="秒杀专区" mode="aspectFit"/>
          <!-- #endif -->
          <!-- #ifdef H5 || APP-PLUS -->
          <image class="title-img" :src="`${VUE_APP_STATIC_URL}static/canvas-images/spike/img-title.png`" alt="秒杀专区" mode="aspectFit" />
          <!-- #endif -->
        </h2>
        <div class="spike-card-top-time" v-if="state===2">
          活动已结束
        </div>
        <div class="spike-card-top-time" v-if="state !==2 && count.length">
          距离{{count[0]}}还有 <div class="span">{{count[1]}}:{{count[2]}}:{{count[3]}}</div>
        </div>
        <a class="btn-more" @click="jumpSeckills(productData)">更多<i class="iconfont icon-arrow-right"></i></a>
      </div>
      <div class="spike-card-list">
        <div class="spike-card-item"  v-for='item in productData.products.slice(0,4)' :key='item.productId' @click="jumpProductDetail(item)">
          <div class="spike-card-item-img">
            <image :src="item.image" alt="" />
          </div>
          <div class="spike-card-item-info">
            <h3 class="name">
              {{item.productName}}
            </h3>
            <div class="stock">
              还剩{{item.stockNumber}}件
            </div>
            <div class="price-warp">
              <div class="price">
                ¥ {{item.price}}
              </div>
              <!-- <div class="original-price">
                ¥ {{item.originalPrice}}
              </div> -->
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import commonMixin from '../mixin'
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
      return {};
    }
  }
})
const { typeId, shopId, componentContent } = toRefs(props)
const { state, productData, count, jumpProductDetail, jumpSeckills } = commonMixin(componentContent, typeId, shopId)
</script>

<style lang="scss" scoped>
.spike{
  background: #F8F8F8;
  padding: 20rpx;
  &-card{
    height: 430rpx;
    background: #FFFFFF;
    border-radius: 20rpx;
    &-top{
      position: relative;
      padding: 32rpx 0 22rpx;
      display: flex;
      &-title{
        padding: 9rpx 20rpx 9rpx 30rpx;
        .title-img{
          width: 204rpx;
          height: 36rpx;
          display: block;
        }
      }
      &-time{
        padding: 0 18rpx;
        height: 50rpx;
        background: linear-gradient(90deg, #C83732 0%, #E25C44 100%);
        box-shadow: 0px 6rpx 12rpx rgba(233, 0, 0, 0.3);
        opacity: 1;
        border-radius: 26rpx;
        font-size: 24rpx;
        line-height: 50rpx;
        color: #fff;
        text-align: center;
        .span{
          display: inline;
        }
      }
      .btn-more{
        position: absolute;
        right: 8rpx;
        top: 40rpx;
        line-height: 33rpx;
        padding-right: 25rpx;
        font-size: 24rpx;
        color: #333;
        .iconfont{
          content: '';
          font-size: 26rpx;
          position: absolute;
          right: 0;
          top: 0;
        }
      }
    }
    &-list{

    }
    &-item{
      width: 50%;
      border-top: 1px solid  #F3F4F5;
      border-left: 1px solid  #F3F4F5;
      float: left;
      align-items: center;
      box-sizing: border-box;
      &:nth-child(2n+1){
        border-left: 0px;
      }
      &-img{
        width: 162rpx;
        height: 162rpx;
        margin-right: 10rpx;
        float: left;
        image{
          width: 100%;
          height: 100%;
          object-fit: contain;
        }
      }
      &-info{
        height: 100%;
        margin-left: 172rpx;
        width: 168rpx;
        .name{
          font-size: 24rpx;
          line-height: 40rpx;
          color: #333333;
          overflow: hidden;
          text-overflow:ellipsis;
          white-space: nowrap;
        }
        .stock{
          padding: 0 8rpx;
          height: 40rpx;
          border: 2rpx solid #E4E5E6;
          line-height: 40rpx;
          margin: 10rpx 0;
          display: inline-block;
          font-size: 20rpx;
          color: #C5AA7B;
        }
        .price{
          font-size: 32rpx;
          font-weight: bold;
          line-height: 44rpx;
          color: #C83732;
          padding-right: 10rpx;
          display: inline-block;
        }
        .original-price{
          font-size: 20rpx;
          line-height: 28rpx;
          color: #CCCCCC;
          display: inline-block;
        }
      }
    }
  }
}
</style>
