<template>
  <view class="hotTemplate" v-if="productList.length">
    <view class="evaluateIcon flex-items">
      <image :src="`${VUE_APP_STATIC_URL}static/images/evaluateIcon.png`"></image>
      <text>热门推荐</text>
    </view>
    <view class="recommendList">
      <view
        class="itemBox"
        v-for="(item, index) of productList"
        @click="goodsDateils(item.shopId,item.productId,item.skuId)"
      >
        <view class="itemImg">
          <image :src="item.image" class="pic-img default-img"></image>
        </view>
        <view class="itemTit">{{item.productName}}</view>
        <view class="flex-items shopNameBox">
          <view class="shopName">{{item.shopName}}</view>
          <view class="paymentNum">{{item.users}}人付款</view>
        </view>
        <view class="itemPrice">
          <view class="price">￥{{item.price}}</view>
          <view class="originalPrice">￥{{item.originalPrice}}</view>
        </view>
      </view>
    </view>
  </view>
</template>

<script setup>
import API from "@/config/api";
import { request } from "@/utils/request";
import { onMounted, ref } from "vue";
import {VUE_APP_STATIC_URL} from "@/config/api";

const listQuery = ref({
  page: 1, pageSize: 6
})
const productList = ref([])

onMounted(()=>{
  GetremenList()
})

// 获取列表数据
function GetremenList() {
  listQuery.value.timestamp = new Date().getTime()
  request(API.GetremenList, listQuery.value, 'get').then(res => {
    uni.stopPullDownRefresh();
    if (res && res.code == 200) {
      productList.value = res.data.list
    } else {
      uni.showToast({
        title: res && res.message || '系统异常',
        icon: 'none'
      })
    }
  })
}
//商品详情
function goodsDateils(shopId, productId, skuId) {
  uni.navigateTo({
    url: '/pages_category_page1/goodsModule/goodsDetails?shopId=' + shopId + '&productId=' + productId + '&skuId=' +
        skuId
  })
}
</script>

<style lang="scss" scoped>
.hotTemplate{
  padding: 1rpx 0 50rpx 0;
  background: #efefef;
  .evaluateIcon {
    margin: 30rpx 0 20rpx 0;
    justify-content: center;
    image {
      width: 36rpx;
      height: 32rpx;
      margin-right: 20rpx;
    }
  }
  .recommendList {
    display: flex;
    flex-wrap: wrap;
    .itemBox {
      width: 47%;
      margin: 16rpx 1% 16rpx 2%;
      background: #FFFFFF;
      .itemImg {
        width: 100%;
        height: 314rpx;
        image {
          width: 100%;
          height: 100%;
        }
      }
      .itemTit {
        padding: 0 20rpx;
        height: 40rpx;
        width: 100%;
        overflow: hidden;
        white-space: nowrap;
        text-overflow:ellipsis;
      }
      .shopNameBox {
        padding: 0 20rpx;
        height: 40rpx;
        justify-content: space-between;
        margin-top: 20rpx;
        .shopName {
          color: #FFEBC4;
          font-size: 20rpx;
          width: 140rpx;
          height: 40rpx;
          line-height: 40rpx;
          border-radius: 0 20rpx 20rpx 0;
          background: #333333;
          padding-left: 10rpx;
          overflow: hidden;
          white-space: nowrap;
          text-overflow:ellipsis;
        }
        .paymentNum {
          border: 2rpx solid #E4E5E6;
          color: #C5AA7B;
          font-size: 20rpx;
          padding: 5rpx;
        }
      }
      .itemPrice {
        display: flex;
        align-items: center;
        padding: 0 20rpx 10rpx 20rpx;
        margin-top: 20rpx;
        .price {
          font-size: 40rpx;
          color: #C83732;
          margin-right: 10rpx;
        }
        .originalPrice {
          color: #CCCCCC;
          font-size: 24rpx;
          text-decoration: line-through;
        }
      }
    }
  }
}
</style>
