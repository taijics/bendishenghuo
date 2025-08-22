<template>
  <div class="group-list" v-if="productData.products&&productData.products.length>0">
    <div class="group-warp">
      <div class="title">
        <label>
          <!-- #ifdef MP-WEIXIN -->
          <image class="title-img" :src="`${VUE_APP_STATIC_URL}static/canvas-images/group/img-title.png`" alt="拼团专区" mode="widthFix"/>
          <!-- #endif -->
          <!-- #ifdef H5 || APP-PLUS -->
          <image class="title-img" :src="`${VUE_APP_STATIC_URL}static/canvas-images/group/img-title.png`" alt="拼团专区" mode="widthFix"/>
          <!-- #endif -->
         </label>
         <a v-show="componentContent.showMore" class="btn-all a-link" @click="jumpGroupWorks(productData)">更多<i class="iconfont icon-arrow-right"></i></a>
       </div>
       <div>
       <swiper class="swiper pro-box" :disable-touch="productData.products.length < 3" :circular="true" :indicator-dots="false" :autoplay="true" :display-multiple-items="productData.products.length >= 3?3:productData.products.length" @change="swiperChange">
         <swiper-item class="swiper-slide pro-item-warp" v-for="(item,index) in productData.products" :key="index" @click="jumpProductDetail(item)">
          <div class="pro-item-inner">
            <div class="pro-item">
              <div class="pro-item-img">
                <image class="img default-img" :src="item.image" />
              </div>
              <div class="pro-item-info">
                <label class="name">{{item.productName}}</label>
                <div class="price">
                  <label class="unit">¥ </label>
                  <label class="val"> {{item.price}}</label>
                </div>
                <label class="buyCount">{{item.workUsers?item.workUsers:0}}人已拼</label>
              </div>
            </div>
          </div>
         </swiper-item>
<!--         &lt;!&ndash; #ifdef MP-WEIXIN &ndash;&gt;-->
<!--         <swiper-item v-if="productData.products.length" class="swiper-slide pro-item-warp" v-for="item in (3 - productData.products.length)">-->
<!--         </swiper-item>-->
<!--         &lt;!&ndash; #endif &ndash;&gt;-->
       </swiper>
         <view class="swiper-dots" v-if="productData.products && productData.products.length > 3">
           <text class="dot" :class="index - swiperCurrent <= 2 && index - swiperCurrent >=0  && 'dot-active'" v-for="(dot, index) in productData.products.length"
                 :key="index"></text>
         </view>
      </div>
    </div>
  </div>
</template>


<script setup>
import {ref, toRefs} from 'vue';
import groupMixin from '../mixin'
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
const { productData, jumpProductDetail, jumpGroupWorks } = groupMixin(componentContent, typeId, shopId)
const swiperCurrent = ref(0)

function swiperChange(e) {
  swiperCurrent.value = e.detail.current;
}
</script>

<style lang="scss" scoped>
  .group-list{
    padding: 30upx 20upx 60upx;
    .group-warp{
      width: 710upx;
      height: 528upx;
      padding: 0 2upx;
      background: #333333;
      box-shadow: 0px 20upx 30upx rgba(0, 0, 0, 0.3);
      opacity: 1;
      border-radius: 20upx;
      position: relative;
    }
    .title{
      display: flex;
      align-items:center;
      position: relative;
      padding: 40upx 0 25upx 20upx;
      .title-img{
        width: 189upx;
          height: 34rpx;
      }
      .btn-all{
        position: absolute;
        right: 8upx;
        top: 40upx;
        line-height: 33upx;
        padding-right: 25upx;
        font-size: 24upx;
        color: #FFEBC4;
        .iconfont{
          content: '';
          font-size: 26upx;
          position: absolute;
          right: 0;
          top: 0;
        }
      }
    }
    .pro-box{
      height: 390upx;
      display: flex;
      &.swiper-disabled{
        .uni-swiper-wrapper{
          position: static;
        }
      }
      .pro-item-warp{
        width: 236px;
      }
      .pro-item{
        width: 220upx;
        height: 382upx;
        background: #FFFFFF;
        .pro-item-img{
          .img{
            width: 100%;
            height: 220upx;
          }
        }
        &-inner{
          padding: 0 8upx;
        }
        .pro-item-info{
          text-align: center;
          padding: 0px 10upx 20upx;
          .name{
            font-size: 24upx;
            font-weight: normal;
            color: #FFEBC4;
            line-height: 50upx;
            background-color: #333333;
            text-align: center;
            margin-bottom: 18upx;
            padding: 0 5px;
            display: block;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
          }
          .price{
            color: #C83732;
            font-size: 28upx;
            font-weight: bold;
            line-height: 40upx;
          }
          .buyCount{
            font-size: 24upx;
            color: #ccc;
            line-height: 34upx;
            font-weight: normal;
          }
        }
      }
    }
    ::v-deep .uni-swiper-dots{
      display: flex;
      justify-content: center;
      bottom: 27px;
      .uni-swiper-dot{
        width: 24upx;
        height: 4upx;
        background: #fff;
        opacity: 0.5;
        border-radius: 2upx;
        margin: 0 5upx;
        &-active{
          opacity: 1;
        }
      }
    }

    //.pagination{
    //  display: flex;
    //  justify-content: center;
    //  ::v-deep .swiper-pagination-bullet{
    //    width: 24upx;
    //    height: 4upx;
    //    background: #fff;
    //    opacity: 0.5;
    //    border-radius: 2upx;
    //    margin: 0 5upx;
    //  }
    //  ::v-deep .swiper-pagination-bullet-active{
    //    opacity: 1;
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
        width: 24upx;
        height: 4upx;
        background: #fff;
        opacity: 0.5;
        border-radius: 2upx;
        margin: 0 10upx;
      }

      .dot-active {
        opacity: 1;
      }
    }
  }
</style>
