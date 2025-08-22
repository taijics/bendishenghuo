<template>
  <view class="container">
    <global-loading />
    <view v-if="list.length>0" class="listBox">
      <view v-for="(item, index) in list" :key="index" class="goodsDetails-box flex-display flex-column" @click="goodsDateils(item.shopId,item.productId,item.skuId)">
        <view v-if="item.activityType === 0" class="goodsDetails flex-items-plus flex-row">
          <image class="goodsImg default-img" :src="item.image"></image>
          <view class="mar-left-30">
            <view class="goodsName-box overflowNoDot">
              <label class="goodsName fs26">{{item.productName}}</label>
            </view>
            <view class="usersBox">
              <label class="fs24 font-color-C5AA7B" v-if="item.users != null">{{item.users}}人付款</label>
              <label class="fs24 font-color-C5AA7B" v-else>0人付款</label>
            </view>
            <view class="priceBuyNum-box flex-items mar-top-20">
              <view>
                <label class="fs30 font-color-C83732">¥</label>
                <label class="fs36 font-color-C83732 mar-left-10">{{item.price}}</label>
              </view>
              <view style="margin-left: 20upx; color: #CCCCCC; text-decoration:line-through">
                <label class="fs24">¥{{item.originalPrice}}</label>
              </view>
            </view>
            <view class="flex-display flex-sp-between flex-row mar-top-10 flex-items shopName">
              <label class="fs22 font-color-FFEBC4">{{item.shopName}}</label>
            </view>
          </view>
        </view>
        <view v-else class="spikeList goodsDetails">
          <view class="listItem">
            <view class="itemBox">
              <img :src="item.image" class="pic-img default-img">
            </view>
            <view class="itemInfo mar-top-30">
              <p>{{item.productName}}</p>
              <view class="number" v-if="item.users != null">
                <view class="numText">{{item.users}}人付款</view>
                <!--                <view class="numText" v-if="item.total !=0">限量{{item.total}}件</view>-->
              </view>
              <view class="flex-row-plus flex-item mar-top-30">
                <image class="iconImg" v-if="item.activityType == 1" :src="`${VUE_APP_STATIC_URL}static/images/groupBuyIcon.png`"></image>
                <image class="iconImg" v-if="item.activityType == 2" :src="`${VUE_APP_STATIC_URL}static/images/spikeIcon.png`"></image>
                <image class="iconImg" v-if="item.activityType == 4" :src="`${VUE_APP_STATIC_URL}static/images/spikeIcon.png`"></image>
                <image class="iconImg" v-if="item.activityType == 3" :src="`${VUE_APP_STATIC_URL}static/images/discountListIcon.png`"></image>
                <image class="iconImg" v-if="item.activityType == 5" :src="`${VUE_APP_STATIC_URL}static/images/discountListIcon.png`"></image>
				<image class="iconImg" v-if="item.activityType == 9" :src="`${VUE_APP_STATIC_URL}static/images/memberCenterIcon.png`"></image>
                <image class="iconImg" v-if="item.activityType == 8" :src="`${VUE_APP_STATIC_URL}static/images/holidaySaleIcon.png`"></image>
                <view class="font-color-C83732 flex-row-plus">
                  <b>￥</b>
                  <label class="fs28">{{item.price}}</label>
                </view>
                <view class="mar-left-30 discountsPriceLine font-color-999">¥{{item.originalPrice}}</view>
              </view>
              <view class="flex-display flex-sp-between flex-row mar-top-10 flex-items shopName">
                <label class="fs22 font-color-FFEBC4">{{item.shopName}}</label>
              </view>
            </view>
          </view>
        </view>
      </view>
    </view>

    <!-- 搜索为空 -->
    <view v-if="ifEmpty" class="emptyCart-box flex-items-plus flex-column">
      <image class="emptyCart-img" :src="`${VUE_APP_STATIC_URL}static/images/searchEmpty.png`"></image>
      <label class="font-color-999 fs26 mar-top-30">搜索不到你要找的宝贝呢</label>
      <label class="font-color-999 fs26 mar-top-10">换个词试试吧～</label>
    </view>
  </view>
</template>

<script setup>
import { request } from "@/utils/request";
import { onLoad, onReachBottom } from "@dcloudio/uni-app";
import API from "@/config/api";
import { ref } from "vue";
import { VUE_APP_STATIC_URL } from "@/config/api";

const keyWord = ref('')
const category3Id = ref('')
const page = ref(1)
const pageSize = ref(20)
const source = ref(2)
const list = ref([])
const loadingType = ref(0)
const sortIndex = ref(0)
const ifNew = ref(0) // 是否新品
const type = ref(1) // 价格排序条件
const volume = ref(1) // 销量排序条件
const sourceType = ref('')
const ids = ref([])
const classifyId = ref(0)
const ifEmpty = ref(false)

onLoad((option) => {
  if(option.sourceType){
    sourceType.value = option.sourceType
    if(option.sourceType === '1'){
      ids.value = option.ids
    } else if(option.sourceType === '2'){
      classifyId.value = option.classifyId
    }
  }
  searchList(1)
})

onReachBottom(() => {
  if(loadingType.value == 1){
    uni.stopPullDownRefresh()
  }else{
    page.value = page.value + 1
    searchList(0)
  }
})

const sortTap = () => {
  page.value = 1
  list.value = []
  if(index == 1){
    type.value = 1
    volume.value = 1
    sortIndex.value = index
  }else if(index == 2){
    type.value = type.value != 1 ? 1:2
    sortIndex.value = index
  }else if(index == 3){
    volume.value = volume.value != 1 ? 1:2
    sortIndex.value = index
  }
  searchList()
}

const searchList = (type) => {
  if(type == 1){
    list.value = []
    page.value = 1
  }
  let params = {
    page: page.value,
    pageSize: pageSize.value
  }
  if (sourceType.value === '1') {
    if(ids.value && ids.value.length>0){
      params.ids = ids.value
    } else {
      list.value = []
    }
  } else if(sourceType.value === '2'){
    if(classifyId.value) {
      params.classifyId = classifyId.value
    } else {
      list.value = []
    }
  }
  if(params.ids || params.classifyId){
    request(API.getProducts, params, 'GET').then(res => {
      uni.hideLoading()
      list.value = list.value.concat(res.data.list)
      if (list.value.length === 0) {
        ifEmpty.value = true
      }
    }).catch(res => {
      uni.hideLoading()
    })
  }
}

//商品详情
const goodsDateils = (shopId,productId,skuId) => {
  uni.navigateTo({
    url: 'goodsDetails?shopId='+shopId + '&productId='+productId +'&skuId='+skuId
  })
}
</script>

<style lang="scss">
page {
  background: #f8f8f8;
}
input{padding-left: 80upx;}
.container{
  height: 100%;
  background: #f8f8f8;
  .search {
    padding: 20rpx;
    background: #FFFFFF;
    border-top: 2rpx solid #F3F4F5;
  }
  .searchImg-box {
    position: relative;
  }
  .emptyCart-box{
    margin-top: 70upx;
    .emptyCart-img{
      width: 113upx;
      height: 98upx;
    }
  }
  .searchBg {
    width: 100%;
    display: flex;
    background-color: #F7F7F7;
    align-items: center;
    height: 78rpx;
    justify-content: space-between;
    padding: 0 20rpx;
    label {
      font-weight: 400;
      color: #333333;
    }
  }
  .searchImg{
    width: 50upx;
    height: 50upx;
    position: absolute;
    left: 0upx;
  }
  .search-box{
    width: 400upx;
    height: 66upx;
  }
  .searchboxPlace{
    font-size: 26upx;
    color: #A9A9A9;
    padding-right: 30upx;
  }
  .searchClose-icon{
    z-index: 999;
    width: 40upx;
    height: 40upx;
    margin-left: -50upx;
  }
  .promotion618{
    width: 130upx;
    height: 30upx;
  }
  .goodsDetails-box{
    background: #FFFFFF;
    margin-top: 20rpx;
    box-sizing: border-box;
    .goodsDetails{
      border-bottom: 1upx solid #EDEDED;
      padding-top: 30rpx;
      padding-bottom: 30upx;
      position: relative;
      .goodsName-box{
        width: 389upx;
        height: 85upx;
        .img618-cion{
          width:70upx;
          height:36upx;
        }
        .goodsName {
          overflow: hidden;
          text-overflow: ellipsis;
          display: -webkit-box;
          -webkit-line-clamp: 2;
          line-clamp: 2;
          -webkit-box-orient: vertical;
        }
      }
      .shopName {
        position: absolute;
        left: 0;
        top: 0;
        height: 50rpx;
        background: #333333;
        opacity: 1;
        border-radius: 0 20rpx 20rpx 0;
        padding: 10rpx 15rpx;
      }
      .goodsImg{
        width: 260upx;
        height: 260upx;
      }
      .discounts-box{
        margin-left: -10upx;
        margin-top: 20upx;
        .discounts-text{
          margin-left: 10upx;
          color: #C5AA7B;
          background-color: #FFE4CC;
          padding: 6upx 12upx;
          border-radius: 4upx;
        }
      }
      .arrowImg{
        width: 20upx;
        height: 20upx;
      }
    }


  }
  .spikeList {
    .arrowImg{
      width: 20upx;
      height: 20upx;
    }
    // padding: 108upx 30upx 20upx 30upx;
    padding-top: 30rpx;
    border-bottom: 1upx solid #EDEDED;
    .listItem {
      display: flex;
      // padding-bottom: 10upx;
      border-bottom: 1upx solid #EEEEEE;
      margin-bottom: 30upx;
      .iconImg {
        width: 58rpx;
        height: 36rpx;
      }
      &:last-child {
        border-bottom: none;
      }
      .itemBox {
        width: 260upx;
        height: 260upx;
        margin-right: 30upx;
        img {
          width: 100%;
          height: 100%;
        }
      }
      .itemInfo {
        flex: 1;
        p {
          font-size: 26upx;
          color: #333333;
          line-height: 40upx;
          margin-bottom: 20upx;
          text-overflow: -o-ellipsis-lastline;
          overflow: hidden;
          text-overflow: ellipsis;
          display: -webkit-box;
          -webkit-line-clamp: 2;
          line-clamp: 2;
          -webkit-box-orient: vertical;
        }
        .number {
          color: #999999;
          font-size: 26upx;
          display: flex;
          align-items: center;
          .numText {
            padding: 0 10rpx;
            height: 40rpx;
            line-height: 40rpx;
            border: 2rpx solid #E4E5E6;
            color: #C5AA7B;
            font-size: 20rpx;
            margin-right: 10rpx;
          }
        }
      }
    }
  }
  .listBox {
    padding: 0 24rpx;
    box-sizing: border-box;
    .usersBox {
      margin-top: 20rpx;
      label {
        padding: 10rpx;
        border: 2rpx solid #E4E5E6;
      }
    }
  }
}
.shop-list-nav {
  display: flex;
  flex-direction: row;
  align-items: center;
  height: 80rpx;
  line-height: 76rpx;
  background: #fff;
}

.nav-item {
  flex: 1;
  font-size: 30rpx;
  color: #666;
  display: flex;
  flex-direction: column;
  align-items: center;
  height: 80rpx;
  line-height: 76rpx;
}

.nav-title {
}

.nav-item.active {
  color: #C5AA7B;
}

.nav-item .line {
  display: inline-block;
  width: 80rpx;
  height: 4rpx;
  background: #fff;
  border-radius: 2rpx;
}

.nav-item.active .line {
  background: #C5AA7B;
}

.nav-item.padd-l {
  padding-left: 20%;
  box-sizing: border-box;
}
.active{
  color: #C5AA7B;
}
.nav-item.padd-r {
  padding-right: 20%;
  box-sizing: border-box;
}

.nav-item-sort {
  flex: 1;
  font-size: 24rpx;
  color: #222;
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: center;
  height: 80rpx;
  line-height: 80rpx;
}

.nav-item-sort .r {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  margin-left: 5rpx;
  .arrowDown {
    width: 0;
    height: 0;
    border-width: 10rpx;
    border-style: solid;
    border-color: #CCCCCC transparent transparent transparent;
    margin-top: 2rpx;
  }
  .arrowUp {
    margin-bottom: 2rpx;
    width: 0;
    height: 0;
    border-width: 10rpx;
    border-style: solid;
    border-color: transparent transparent #CCCCCC transparent;
  }
  .activeDown {
    border-color: #C5AA7B transparent transparent transparent;
  }
  .activeUp {
    border-color: transparent transparent #C5AA7B transparent;
  }
}

//.nav-item-sort .r .arrow-img {
//  width: 32rpx;
//  height: 32rpx;
//  padding: 7rpx;
//  box-sizing: border-box;
//}
//// #ifdef MP-ALIPAY
//.nav-item-sort .r .arrow-img {
//  width: 16rpx;
//  height: 16rpx;
//  padding: 4rpx;
//  box-sizing: border-box;
//}
.search {
  padding-top: 20rpx;
}
// #endif
</style>
