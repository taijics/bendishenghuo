<template>
  <view class="couponProduct">
    <global-loading />

    <view class="productList">
      <view class="couponTit flex-items">
        <image :src="`${VUE_APP_STATIC_URL}static/images/counponTitIcon.png`"></image>
        <text class="fs24 font-color-C83732" v-if="currentCoupon.discountMode === 1">以下商品使用满{{currentCoupon.fullMoney}}元减{{currentCoupon.reduceMoney}}元的优惠券</text>
        <text class="fs24 font-color-C83732" v-else>以下商品使用满{{currentCoupon.fullMoney}}打{{currentCoupon.reduceMoney}}折</text>
      </view>
      <view class="productListBox">
        <view v-if="!ifEmpty" class="productItemBox mar-top-30">
          <view class="productItem"
            v-for="(item, index) of productList"
            :key="item.productId"
            @click="goodsDateils(item.shopId,item.productId,item.skuId)"
          >
            <view class="productImg">
              <image :src="item.image"></image>
            </view>
            <view class="productTit fs28 font-color-333">{{item.productName}}</view>
            <view class="productPrice font-color-C83732 fs40">￥{{item.price}}</view>
          </view>
        </view>
        <view v-if="ifEmpty" class="emptyOrder-box flex-items-plus flex-column">
          <image class="emptyOrder-img" :src="`${VUE_APP_STATIC_URL}static/img/bgnull.png`"></image>
          <label class="font-color-999 fs26 mar-top-30">暂无可用商品～</label>
        </view>
      </view>
    </view>
  </view>
</template>
<script setup>
import { ref } from "vue";
import { request } from "../../utils/request";
import { onLoad, onReachBottom } from "@dcloudio/uni-app";
import API from "../../config/api";
import { VUE_APP_STATIC_URL } from "@/config/api";

const productList = ref([])
const page = ref(1)
const pageSize = ref(10)
const loadingType = ref(0)
const currentCoupon = ref({fullMoney: 0, reduceMoney: 0})
const cid = ref(0)
const ifEmpty = ref(false)

onReachBottom(() => {
  if(loadingType.value == 1){
    uni.stopPullDownRefresh()
  }else{
    page.value = page.value + 1
    getProductList()
  }
})

onLoad((options) => {
  console.log(options,'options')
  if (options.id) {
    cid.value = options.id
    getCoupon()
    getProductList()
  }
})

const getCoupon = () => {
  request(API.getCoupons, {
    page: 1,
    pageSize: 1,
    ids: cid.value
  },'GET').then(res => {
    if (res.data) {
      currentCoupon.value = res.data.list[0]
    }
  }).catch(err => {
    throw Error(err)
  })
}
/**
 * 获取券可使用产品列表
 * @returns {Promise<void>}
 */
const getProductList = async () => {
  try {
    const res = await request(API.getCouponProducts, {
      activityId: cid.value,
      page: page.value,
      pageSize: pageSize.value
    }, 'GET')
    uni.hideLoading()
    if (res.data.list.length === 0) {
      loadingType.value = 1
    } else {
      productList.value = productList.value.concat(res.data.list)
    }
    if (productList.value.length === 0) {
      ifEmpty.value = true
    }
  } catch (err) {}
}

/**
 * 商品详情
 * @param shopId 店铺ID
 * @param productId 商品ID
 * @param skuId
 */
const goodsDateils = (shopId, productId, skuId) => {
  uni.navigateTo({
    url: '/pages_category_page1/goodsModule/goodsDetails?shopId='+shopId + '&productId='+productId +'&skuId='+skuId
  })
}

</script>

<style lang="scss" scoped>
page {
  background: #FFFFFF;
}
.couponProduct {
  padding: 0 20rpx;
  .productList {
    .couponTit {
      padding: 0 20rpx;
      height: 86rpx;
      background: #F9F6F1;
      image {
        width: 66rpx;
        height: 46rpx;
        margin-right: 15rpx;
      }
    }
  }
}
.productListBox{
  .productItemBox {
    display: flex;
    flex-wrap: wrap;
    justify-content: flex-start;
    width: 100%;
    .productItem {
      padding: 0 20rpx;
      height: 420rpx;
      flex: 1;
      margin: 0 20rpx 20rpx 0;
      width: calc((100% - 20rpx) / 2);
      min-width: calc((100% - 20rpx) / 2);
      max-width: calc((100% - 20rpx) / 2);
      &:nth-child(2n) {
        margin-right: 0;
      }
      .productImg {
        width: 325rpx;
        height: 325rpx;
        image {
          width: 100%;
          height: 100%;
        }
      }
      .productTit {
        overflow:hidden;
        text-overflow:ellipsis;
        white-space:nowrap;
      }
      .productPrice {
        margin-top: 15rpx;
      }
    }
  }
  .emptyOrder-box{
    position: absolute;
    top: 0;
    bottom: 0;
    left: 0;
    right: 0;
    margin: auto;
    .emptyOrder-img{
      width: 325rpx;
      height: 325rpx;
      image {
        width: 100%;
        height: 100%;
      }
    }
  }
}
</style>
