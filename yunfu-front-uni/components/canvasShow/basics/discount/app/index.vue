<template>
  <div class="hom-pro-list" v-if="productData.products.length">
    <div class="title">
      <!-- #ifdef MP-WEIXIN -->
      <image class="title-img" :src="`${VUE_APP_STATIC_URL}static/canvas-images/discount/img-title.png`" alt="限时折扣" mode="widthFix"/>
      <!-- #endif -->
      <!-- #ifdef H5 || APP-PLUS -->
      <image class="title-img" :src="`${VUE_APP_STATIC_URL}static/canvas-images/discount/img-title.png`" alt="限时折扣" mode="widthFix"/>
      <!-- #endif -->
    </div>
    <div v-if="componentContent.arrangeType == '横向滑动' && productData.products.length > 2" class="product-list">
      <swiper ref="mySwiper" class="swiper product-list-box" :circular="true" :indicator-dots="false" :autoplay="true" :disable-touch="productData.products.length < 2" :display-multiple-items="productData.products.length >= 2?2:productData.products.length" @change="swiperChange">
        <swiper-item class="swiper-slide product-list-item-warp" v-for="(item,index) in productData.products.slice(0, 10)" :key="index" @click="jumpProductDetail(item)">
          <div class="product-list-item">
          <div class="product-list-img">
            <image class="img default-img" :src="item.image" />
          </div>
          <div class="product-list-info">
            <label class="product-name">{{item.productName}}</label>
            <div>
              <div class="flag">
                <!-- #ifdef MP-WEIXIN -->
                <image class="icon" :src="`${VUE_APP_STATIC_URL}static/canvas-images/discount/flag-discount2.png`" alt="限时折扣" mode="widthFix"/>
                <!-- #endif -->
                <!-- #ifdef H5 || APP-PLUS -->
                <image class="icon" :src="`${VUE_APP_STATIC_URL}static/canvas-images/discount/flag-discount2.png`" alt="限时折扣" mode="widthFix"/>
                <!-- #endif -->
              </div>
              <label class="buy-count">剩余{{item.stockNumber}}件</label>
            </div>
            <div class="price-warp">
              <div class="price">
                ¥ {{item.price}}
              </div>
              <div class="original-price">
                ¥ {{item.originalPrice}}
              </div>
            </div>
          </div>
          </div>
        </swiper-item>
      </swiper>
      <view class="swiper-dots" v-if="productData.products && productData.products.length > 2">
        <text class="dot" :class="index - swiperCurrent <= 1 && index - swiperCurrent >=0  && 'dot-active'" v-for="(dot, index) in productData.products.length"
              :key="index"></text>
      </view>
<!--      <div class="pagination discount-pagination" slot="pagination"></div>-->
    </div>
    <div v-else class="product-list">
      <div class="product-list-box" >
        <div class="product-list-item-warp" v-for="(item,index) in productData.products" :key="index" @click="jumpProductDetail(item)">
          <div class="product-list-item">
          <div class="product-list-img">
            <image class="img default-img" :src="item.image" />
          </div>
          <div class="product-list-info">
            <label class="product-name">{{item.productName}}</label>
            <div>
              <div class="flag">
                <!-- #ifdef MP-WEIXIN -->
                <image class="icon" :src="`${VUE_APP_STATIC_URL}static/canvas-images/discount/flag-discount2.png`" alt="限时折扣" mode="widthFix"/>
                <!-- #endif -->
                <!-- #ifdef H5 || APP-PLUS -->
                <image class="icon" :src="`${VUE_APP_STATIC_URL}static/canvas-images/discount/flag-discount2.png`" alt="限时折扣" mode="widthFix"/>
                <!-- #endif -->
              </div>
              <label class="buy-count">剩余{{item.stockNumber}}件</label>
            </div>
            <div class="price-warp">
              <div class="price">
                ¥ {{item.price}}
              </div>
              <div class="original-price">
                ¥ {{item.originalPrice}}
              </div>
            </div>
          </div>
          </div>
        </div>
      </div>
    </div>
    <button v-show="componentContent.showMore" class="btn-more" @click="jumpDiscount(productData)">查看全部 <span class="icon iconfont icon-arrow-right"></span></button>
  </div>
</template>

<script setup>
import { ref, toRefs } from 'vue';
import discountMixin from '../mixin'
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
    },
  }
})
const { typeId, shopId, componentContent } = toRefs(props)
const { productData, jumpProductDetail, jumpGroupWorks,jumpDiscount } = discountMixin(componentContent, typeId, shopId)

const swiperCurrent = ref(0)

function swiperChange(e) {
  swiperCurrent.value = e.detail.current;
}
</script>

<style lang="scss" scoped>
.hom-pro-list{
  padding: 20px 0;
  .title{
    text-align: center;
    margin-bottom: 20rpx;
    .title-img{
      width: 203rpx;
    }
  }
  /**多行多列**/
  .product-list {
    position: relative;
    &-box {
      display: flex;
      flex-wrap: wrap;
      flex-direction: row;
      padding-left: 20rpx;
      &.swiper{
        height: 620rpx;
      }
    }
    &.product-swiper .product-list-box{
      margin: 0 20rpx;
      padding-left: 0;
    }
    &-item-warp{
      margin: 0 0 20rpx 0;
    }
    &-item {
      width: 348rpx;
      padding: 0 7rpx;
      box-sizing: content-box;
    }
    &-img {
      width: 348rpx;
      height: 348rpx;
      background-color: #f5f5f5;
      border-radius: 10rpx 10rpx 0 0;
      .img {
        width: 100%;
        height: 100%;
        object-fit: contain;
      }
    }
    &-info {
      background-color: #FFFFFF;
      //box-shadow: 0px 0px 15px 0px rgba(52, 52, 52, 0.15);
      border-radius: 0 0 10rpx 10rpx;
      padding: 20rpx;
      label{
        font-weight: normal;
      }
      .product-name{
        font-size: 28rpx;
        color: #333;
        display: block;
        overflow: hidden;
        text-overflow:ellipsis;
        white-space: nowrap;
        margin-bottom: 18rpx;
        line-height: 40rpx;
      }
      .shop-box{
        background-color: #333333;
        border-radius: 0px 20rpx 20rpx 0rpx;
        line-height: 40rpx;
        display: inline-block;
        height: 40rpx;
        margin-right: 10rpx;
        .shop-name{
          font-size: 20rpx;
          color: #FFEBC4;
          padding: 0 8px 0 12rpx;
        }
        .shop-logo{
          border: 2px solid #707070;
          border-radius: 50%;
          overflow: hidden;
          float: right;
          img{
            width: 34rpx;
            height: 34rpx;
            display: block;
          }
        }
      }
      .flag{
        float: left;
        margin-right: 20rpx;
        .icon{
          width: 100rpx;
          height: 40rpx;
          display: block;
        }
      }
      .buy-count{
        color: #C5AA7B;
        font-size: 20rpx;
        border: 2rpx solid #E4E5E6;
        line-height: 40rpx;
        padding: 0 5rpx;
        display: inline-block;
      }
      .price-warp{
        display: flex;
        align-items: baseline;
        line-height: 56rpx;
        margin-top: 16rpx;
        .price{
          color: #C83732;
          font-size: 40rpx;
          margin-right: 20rpx;
        }
        .original-price{
          font-size: 24rpx;
          color: #ccc;
          text-decoration: line-through;
        }
      }
    }
    //::v-deep .swiper-pagination-bullet{
    //  display: none;
    //}
  }
}

//::v-deep .uni-swiper-dots{
//  display: flex;
//  justify-content: center;
//  padding: 10rpx 0;
//  .uni-swiper-dot{
//    width: 10rpx;
//    height: 10rpx;
//    background: #333333;
//    opacity: 0.3;
//    border-radius: 5rpx;
//    margin: 0 5rpx;
//    &-active{
//      width: 20rpx;
//      height: 10rpx;
//      opacity: 1;
//    }
//  }
//}
.swiper-dots {
  display: flex;
  position: absolute;
  left: 50%;
  transform: translateX(-50%);
  bottom: 15rpx;
  z-index: 66;
  .dot {
    width: 10rpx;
    height: 10rpx;
    background: #333333;
    opacity: 0.3;
    border-radius: 5rpx;
    margin: 0 10rpx;
  }

  .dot-active {
    width: 20rpx;
    opacity: 1;
  }
}
//.pagination{
//  display: flex;
//  justify-content: center;
//  padding: 20rpx 0;
//  ::v-deep .swiper-pagination-bullet{
//    width: 10rpx;
//    height: 10rpx;
//    background: #333333;
//    opacity: 0.3;
//    border-radius: 5rpx;
//    margin: 0 5rpx;
//  }
//  ::v-deep .swiper-pagination-bullet-active{
//    width: 20rpx;
//    height: 10rpx;
//    opacity: 1;
//  }
//}
.btn-more {
  width: 170rpx;
  height: 54rpx;
  line-height: 54rpx;
  border: 2rpx solid #C5AA7B;
  color: #C5AA7B;
  font-size: 24rpx;
  background-color: transparent;
  margin: 20rpx auto 0;
  display: flex;
  align-items: center;
}

</style>
