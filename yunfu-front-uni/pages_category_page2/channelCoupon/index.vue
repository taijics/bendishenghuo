<template>
  <view class="channel-coupon">
    <global-loading />
    <view class="details">
      <swiper class="swiper" :indicator-dots="true" :autoplay="true">
        <swiper-item v-for="(imgItem, index) in channelCouponData.productImageList" :key="index">
          <image class="swiper-img" :src='imgItem'></image>
        </swiper-item>
      </swiper>
      <view class="info">
        <view class="price-box">
          <view class="icon">
            <img class="icon-img" :src="`${VUE_APP_STATIC_URL}static/img/channelCoupon/icon-coupon.png`" alt="" mode="widthFix"/>
          </view>
          <label class="price">¥{{channelCouponData.price}}</label>
          <label class="original-price">¥{{channelCouponData.originalPrice}}</label>
          <label class="buy-count">{{channelCouponData.buyUserCount}}人付款</label>
        </view>
        <text class="name" @click="jumpProductDetail(channelCouponData)">{{channelCouponData.productName}}</text>
      </view>
      <view class="coupon">
        <view class="price">
          <text class="unit" v-if="channelCouponData.couponType === 1">¥</text>
          <text class="val">{{channelCouponData.reduceMoney}}</text>
          <text class="unit" v-if="channelCouponData.couponType === 2">折</text>
        </view>
        <view class="coupon-content">
          <view class="time">
            <text class="text">有效期</text>
            <text class="val">{{channelCouponData.startTime.slice(0,10)}} - {{channelCouponData.endTime.slice(0,10)}}</text>
          </view>
          <view v-if="channelCouponData.state === 3" class="btn" @click="receiveCoupon(channelCouponData)">立即领取</view>
          <view v-if="channelCouponData.state === 0" class="btn">已领取</view>
          <view v-if="channelCouponData.state === 1" class="btn">已使用</view>
          <view v-if="channelCouponData.state === 2" class="btn">已过期</view>
        </view>
      </view>
    </view>
    <div class="pro-list" v-if="productList && productList.length > 0">
      <div class="title">
        <img class="title-img" :src="`${VUE_APP_STATIC_URL}static/img/channelCoupon/img-title.png`" alt="商品推荐" mode="widthFix"/>
      </div>
      <div class="product-list">
        <div class="product-list-box" >
          <div class="product-list-item-warp" v-for="(item,index) in productList" :key="index" @click="jumpProductDetail(item)">
            <div class="product-list-item">
              <div class="product-list-img">
                <img v-show="item.image" class="img" :src="item.image">
              </div>
              <div class="product-list-info">
                <label class="product-name">{{item.productName}}</label>
                <div class="flex">
                  <div class="shop-box" @click.stop="jumpStore(item)">
                    <label class="shop-name">{{item.shopName}}</label>
                    <div class="shop-logo">
                      <image :src="item.shopLogo" />
                    </div>
                  </div>
                  <label class="buy-count">{{item.users?item.users: 0}}人付款</label>
                </div>
                <div class="price-warp">
                  <img class="iconImg" v-if="item.activityType == 1" :src="`${VUE_APP_STATIC_URL}static/images/groupBuyIcon.png`">
                  <img class="iconImg" v-if="item.activityType == 2" :src="`${VUE_APP_STATIC_URL}static/images/spikeIcon.png`">
                  <img class="iconImg" v-if="item.activityType == 4" :src="`${VUE_APP_STATIC_URL}static/images/spikeIcon.png`">
                  <img class="iconImg" v-if="item.activityType == 3" :src="`${VUE_APP_STATIC_URL}static/images/discountListIcon.png`">
                  <img class="iconImg" v-if="item.activityType == 5" :src="`${VUE_APP_STATIC_URL}static/images/discountListIcon.png`">
                  <img class="iconImg" v-if="item.activityType == 8" :src="`${VUE_APP_STATIC_URL}static/images/memberCenterIcon.png`">
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
    </div>
  </view>
</template>

<script setup>
import { request } from '../../utils/request'
import { ref } from 'vue';
import API from '../../config/api'
import {onLoad} from "@dcloudio/uni-app";
import { VUE_APP_STATIC_URL } from "@/config/api";

const channelCouponData = ref({
  startTime: '',
  endTime: ''
});
const productList = ref([]);
const isLogin = ref(false);
const params = ref({
  productId: 0,
  shopCouponId: 0,
  shopId: 0
});

onLoad((options) => {
  console.log(options,'options')
  params.value.productId = options.productId
  params.value.shopCouponId = options.shopCouponId
  params.value.shopId = options.shopId
  const res = uni.getStorageSync('storage_key'),token = res.token;
  isLogin.value = !!token
  getChannelCoupon()
  getProductList()
})

// 获取渠道优惠券
const getChannelCoupon = () => {
  // uni.showLoading({
  //   mask: true,
  //   title: '加载中...'
  // })
  request(API.getChannelCoupon, params.value, 'GET').then(res => {
    channelCouponData.value = res.data
    // uni.hideLoading()
  }).catch(res => {
    // uni.hideLoading()
    uni.showToast({
      title: '失败',
      icon: "none"
    })
    throw Error(res)
  })
}

// 获取推荐产品
const getProductList = () => {
  // uni.showLoading({
  //   mask: true,
  //   title: '加载中...'
  // })
  let params ={
    page: 1,
    pageSize: 10,
    timestamp: new Date().getTime()
  }
  request(API.getRandomProduct, params, 'GET').then(res => {
    productList.value = res.data.list
    // uni.hideLoading()
  }).catch(res => {
    // uni.hideLoading()
    throw Error(res)
  })
}

// 领取优惠券
const receiveCoupon = (item) => {
  if (isLogin.value) {
    let paramsData = {
      shopCouponId: item.shopCouponId,
      shopId: params.value.shopId
    }
    request(API.ReceiveCoupon, paramsData, 'POST').then(res => {
      uni.showToast({
        title:'领取成功',
        icon:"success"
      })
      let data = {
        shopId: channelCouponData.value.shopId,
        productId: channelCouponData.value.productId,
        skuId: channelCouponData.value.skuId,
      }
      setTimeout(()=>{
        jumpProductDetail(data)
      },2000)
    }).catch(res => {
      if(res.data.code !== '200'){
        uni.showToast({
          title:res.data.message,
          icon:"none"
        })
      }
      throw Error(res)
    })
  } else {
    uni.showToast({
      title:'请先登录',
      icon:"none"
    })
    uni.navigateTo({
      url:'/pages_category_page2/userModule/login'
    })
  }
}
// 跳转到店铺主页
const jumpStore = (item) => {
  uni.navigateTo({
    url: `/pages_category_page1/store/index?storeId=${item.shopId}`
  })
}
// 跳转到商品详情
const jumpProductDetail = (item) =>{
  uni.navigateTo({
    url: '/pages_category_page1/goodsModule/goodsDetails?shopId=' + item.shopId + '&productId=' + item.productId + '&skuId=' + item
        .skuId
  })
}
</script>

<style lang="scss" scoped>
@import "../../style/images";
.channel-coupon{
  .details{
    background-color: #fff;
    padding-bottom: 48rpx;
    .swiper{
      height: 750rpx;
      &-img{
        width: 100%;
        height: 100%;
      }
    }
    .info{
      padding: 0 20rpx;
      margin-top: 20rpx;
      .price-box{
        display: flex;
        align-items: center;
        position: relative;
        .icon{
          padding-right: 8rpx;
          width: 66rpx;
          height: 46rpx;
          &-img{
            width: 100%;
            height: 100%;
          }
        }
        .price{
          color: #C83732;
          font-weight: bold;
          font-size: 60rpx;
          margin-right: 10rpx;
        }
        .original-price{
          padding-top: 20rpx;
          font-size: 24px;
          color: #CCCCCC;
          text-decoration:line-through;
        }
        .buy-count{
          position: absolute;
          right: 0;
          font-size: 26rpx;
          color: #CCCCCC;
        }
      }
      .name{
        margin-top: 20rpx;
        font-size: 32rpx;
        line-height: 48rpx;
        color: #333333;
      }
    }
    .coupon{
      margin: 32rpx 20rpx;
      height: 140rpx;
      background: #333333 $borderCoupon no-repeat right center / auto 140rpx;
      display: flex;
      .price{
        position: relative;
        width: 204rpx;
        display: flex;
        justify-content: center;
        align-items: baseline;
        height: 100%;
        border-right: 2rpx solid #666666;
        line-height: 140rpx;
        .unit{
          font-size: 36rpx;
          color: #FFEBC4;
        }
        .val{
          font-size: 70rpx;
          color: #FFEBC4;
        }
        &:before,&:after{
          content: '';
          width: 24rpx;
          height: 24rpx;
          background: #fff;
          border-radius: 50%;
          position: absolute;
          right: -12rpx;
        }
        &:before{
          top: -12rpx;
        }
        &:after{
          bottom: -12rpx;
        }
      }
      &-content{
        flex: 1;
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 0 50rpx;
        .time{
          .text{
            font-size: 32rpx;
            color: #FFFFFF;
            line-height: 44rpx;
            display: block;
          }
          .val{
            font-size: 20rpx;
            color: #999999;
            line-height: 28rpx;
          }
        }
        .btn{
          width: 122rpx;
          height: 52rpx;
          line-height: 52rpx;
          border: 2rpx solid #999999;
          font-size: 24rpx;
          text-align: center;
          color: #FFFFFF;
        }
      }
    }
  }
}
.pro-list{
  background: #F8F8F8;
  padding: 42upx 13upx 20upx;
  .title{
    text-align: center;
    margin-bottom: 36upx;
    .title-img{
      width: 211upx;
    }
  }
  /**多行多列**/
  .product-list {
    position: relative;
    &-box {
      display: flex;
      flex-wrap: wrap;
      flex-direction: row;
      &.swiper{
        height: 620upx;
      }
    }
    &.product-swiper .product-list-box{
      padding-left: 0;
    }
    &-item-warp{
      margin: 0 0 20upx 0;
    }
    &-item {
      width: 348upx;
      padding: 0 7upx;
      box-sizing: content-box;
    }
    &-img {
      width: 348upx;
      height: 348upx;
      background-color: #f5f5f5;
      border-radius: 10upx 10upx 0 0;
      .img {
        width: 100%;
        height: 100%;
        object-fit: contain;
      }
    }
    &-info {
      background-color: #FFFFFF;
      //box-shadow: 0px 0px 15px 0px rgba(52, 52, 52, 0.15);
      border-radius: 0 0 10upx 10upx;
      padding: 20upx;
      label{
        font-weight: normal;
      }
      .product-name{
        font-size: 28upx;
        color: #333;
        display: block;
        overflow: hidden;
        text-overflow:ellipsis;
        white-space: nowrap;
        margin-bottom: 18upx;
        line-height: 40upx;
      }
      .flex{
        display: flex;
        align-items: center;
      }
      .shop-box{
        background-color: #333333;
        border-radius: 0upx 20upx 20upx 0upx;
        line-height: 40upx;
        display: flex;
        align-items: center;
        height: 40upx;
        margin-right: 10upx;
        .shop-name{
          font-size: 20upx;
          color: #FFEBC4;
          padding: 0 8upx 0 12upx;
        }
        .shop-logo{
          border: 2upx solid #707070;
          border-radius: 50%;
          overflow: hidden;
          float: right;
          image{
            width: 34upx;
            height: 34upx;
            display: block;
          }
        }
      }
      .buy-count{
        color: #C5AA7B;
        font-size: 20upx;
        border: 2upx solid #E4E5E6;
        line-height: 40upx;
        padding: 0 5upx;
      }
      .price-warp{
        display: flex;
        align-items: baseline;
        line-height: 56upx;
        .iconImg {
          width: 58rpx;
          height: 36rpx;
          margin-right: 10rpx;
        }
        .price{
          color: #C83732;
          font-size: 40upx;
          margin-right: 20upx;
        }
        .original-price{
          font-size: 24upx;
          color: #ccc;
          text-decoration: line-through;
        }
      }
    }
  }
}

.swiper-dots {
  display: flex;
  position: absolute;
  left: 50%;
  transform: translateX(-50%);
  bottom: 15rpx;
  z-index: 66;
  .dot {
    width: 10upx;
    height: 10upx;
    background: #333333;
    opacity: 0.3;
    border-radius: 5upx;
    margin: 0 10upx;
  }

  .dot-active {
    width: 20upx;
    opacity: 1;
  }
}
</style>
