<template>
  <view class="goodRecommend">
    <!-- 骨架屏 -->
    <view class="product-list">
      <view class="product-list-box" >
        <view class="product-list-item-warp" v-for="(item,index) in productList" :key="index">
          <view class="product-list-item" v-if="JSON.stringify(item)!=='{}'">
            <view class="product-list-img" @click="jumpProductDetail(item)">
              <img v-show="item.image" class="img" :src="item.image">
            </view>
            <view class="product-list-info u-skeleton-fillet">
              <view class="product-name">{{item.productName}}</view>
              <view class="flex">
                <view class="shop-box" @click.stop="jumpStore(item)">
                  <view class="shop-name" @click="jumpProductDetail(item)">{{item.shopName}}</view>
                  <view class="shop-logo">
                    <image :src="item.shopLogo" />
                  </view>
                </view>
                <view class="buy-count">{{item.users?item.users: 0}}人付款</view>
              </view>
              <div class="price-warp">
                <!-- #ifdef MP-WEIXIN -->
                <img class="iconImg" v-if="item.activityType == 1" :src="`${VUE_APP_STATIC_URL}static/canvas-images/groupBuyIcon.png`">
                <img class="iconImg" v-if="item.activityType == 2" :src="`${VUE_APP_STATIC_URL}static/canvas-images/spikeIcon.png`">
                <img class="iconImg" v-if="item.activityType == 4" :src="`${VUE_APP_STATIC_URL}static/canvas-images/spikeIcon.png`">
                <img class="iconImg" v-if="item.activityType == 3" :src="`${VUE_APP_STATIC_URL}static/canvas-images/discountListIcon.png`">
                <img class="iconImg" v-if="item.activityType == 5" :src="`${VUE_APP_STATIC_URL}static/canvas-images/discountListIcon.png`">
                <img class="iconImg" v-if="item.activityType == 8" :src="`${VUE_APP_STATIC_URL}static/canvas-images/memberCenterIcon.png`">
                <!-- #endif -->
                <!-- #ifdef H5 || APP-PLUS -->
                <image class="iconImg" v-if="item.activityType == 1" :src="`${VUE_APP_STATIC_URL}static/canvas-images/groupBuyIcon.png`"></image>
                <image class="iconImg" v-if="item.activityType == 2" :src="`${VUE_APP_STATIC_URL}static/canvas-images/spikeIcon.png`"></image>
                <image class="iconImg" v-if="item.activityType == 4" :src="`${VUE_APP_STATIC_URL}static/canvas-images/spikeIcon.png`"></image>
                <image class="iconImg" v-if="item.activityType == 3" :src="`${VUE_APP_STATIC_URL}static/canvas-images/discountListIcon.png`"></image>
                <image class="iconImg" v-if="item.activityType == 5" :src="`${VUE_APP_STATIC_URL}static/canvas-images/discountListIcon.png`"></image>
                <image class="iconImg" v-if="item.activityType == 8" :src="`${VUE_APP_STATIC_URL}static/canvas-images/memberCenterIcon.png`"></image>
                <!-- #endif -->
                <div class="price">
                  ¥ {{item.price}}
                </div>
                <div class="original-price">
                  ¥ {{item.originalPrice}}
                </div>
              </div>
            </view>
          </view>
          <view class="product-list-item ske-loading" v-else>
            <view class="product-list-img child-loading">
              <img v-show="item.image" class="img" :src="item.image">
            </view>
            <view class="product-list-info">
              <view class="product-name child-loading" style="border-radius: 5rpx; margin-top: 10rpx;width: 100%;padding: 20rpx 0"></view>
              <view class="product-name child-loading" style="border-radius: 5rpx; margin-top: 10rpx;width: 100%;padding: 20rpx 0"></view>
            </view>
          </view>

        </view>
      </view>
    </view>
    <view v-if="isShow" class="emptyCart-box flex-items-plus flex-column">
        <image class="emptyCart-img" :src="`${VUE_APP_STATIC_URL}static/img/bgnull.png`" mode="widthFix" />
        <label class="font-color-999 fs26 mar-top-30">这里空空如也~</label>
    </view>
  </view>
</template>

<script setup>
import {ref, onMounted, toRefs, watch} from 'vue';
import API from "@/config/api";
import {request} from "@/utils/request"
import { VUE_APP_STATIC_URL } from "@/config/api";

const props = defineProps({
  categoryid: {
    type: Number,
    default: 0
  }
})
const { categoryid } = toRefs(props)
const activeTab = ref(0)
const page = ref(1)
const pageSize = ref(10)
const total = ref(0)
const productList = ref([])
const isShow = ref(false)

watch(categoryid,()=>{
  isShow.value=false
})

onMounted(()=>{
  productList.value = [{},{},{},{},{},{},{},{}]
  getData();
})

function getData(classifyLevel){
  console.log('加载了getData')
  // uni.showLoading({
  //   mask: true,
  //   title:'加载中...'
  // })
  if (total.value!=0&&productList.value.length>=total.value){
    console.log("加载完了")
    return
  }
  request(API.getProductsV2, {
    classifyId: categoryid.value,
    page:page.value,
    pageSize:pageSize.value,
    // classifyLevel: classifyLevel || undefined
  }, 'GET').then(res => {
    productList.value = [...productList.value,...res.data.list]
    productList.value = productList.value.filter(item=>JSON.stringify(item)!=='{}')
    total.value = res.data.total
    uni.hideLoading()
    if (productList.value.length ===0) {
      isShow.value = true
    }

  }).catch(err => {
    uni.hideLoading()
    throw Error(err)
  })
}
// 跳转到店铺主页
function jumpStore(item){
  uni.navigateTo({
    url: `/pages_category_page1/store/index?storeId=${item.shopId}`
  })
}
// 跳转到商品详情
function jumpProductDetail(item){
  uni.navigateTo({
    url: '/pages_category_page1/goodsModule/goodsDetails?shopId=' + item.shopId + '&productId=' + item.productId + '&skuId=' + item
        .skuId
  })
}

watch(()=>categoryid,(val)=>{
  isShow.value = false
  getData()
})

defineExpose({
  page,
  total,
  productList,
  getData
})
</script>

<style lang="scss" scoped>
.goodRecommend {
  padding-top: 20rpx;
  .product-list {
    position: relative;
    padding: 0 13upx;
    width: 100%;
    //min-height: 60vh;
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
      background-color: #d0d0d0;
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
        float: left;
        .shop-name{
          font-size: 20upx;
          color: #FFEBC4;
          padding: 0 8upx 0 12upx;
          line-height: 40upx;
          display: inline-block;
          float: left;
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
        line-height: 36upx;
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
  .emptyCart-box {
    margin-top: 70rpx;
    .emptyCart-img {
      width: 216rpx;
      height: 156rpx;
    }
  }
}

</style>
