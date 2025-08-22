<template>
  <view class="spikeListBox">
    <global-loading />

    <view class="discountBg">
      <view class="discountInfoBox">
        <view class="discountInfo">全场{{discountInfo.discount}}折</view>
      </view>
    </view>
	  <view class="countdown" v-if="shopShowType == false">
      距活动结束剩余<view class="endDate"><span>{{hou}}</span><i>:</i><span>{{min}}</span><i>:</i><span>{{sec}}</span></view>
	  </view>
<!--	  <view class="filterBox" v-else>-->
<!--		<view class="item" :class="selectIndex == 0 ? 'selected' : ''" @click="synthesize"><span>综合</span></view>-->
<!--		<view class="item" :class="selectIndex == 1 ? 'selected' : ''" @click="sales"><span>销量</span></view>-->
<!--		<view class="item" :class="selectIndex == 2 ? 'selected' : ''" @click="priceClick"><span>价格</span></view>-->
<!--	  </view>-->

    <view class="shop-list-nav">
      <view class="nav-item-sort" @click="sortTap(1)">
        <text class="nav-title" :class="{'active' : sortIndex == 1}">综合</text>
      </view>
      <view class="nav-item-sort" @click="sortTap(2)">
        <text class="nav-title" :class="{'active' : sortIndex == 2}">价格</text>
        <view class="r">
          <view class="arrowUp" :class="{activeUp: type == 1}"></view>
          <view class="arrowDown" :class="{activeDown: type == 2}"></view>
        </view>
      </view>
      <view class="nav-item-sort" @click="sortTap(3)">
        <text class="nav-title" :class="{'active' : sortIndex == 3}">销量</text>
        <view class="r">
          <view class="arrowUp" :class="{activeUp: volume == 1}"></view>
          <view class="arrowDown" :class="{activeDown: volume == 2}"></view>
        </view>
      </view>
    </view>

    <view class="spikeList mar-top-20">
      <view class="listItem" v-for="(item,index) in getDiscount" :key="index">
        <view class="itemBox">
          <image :src="item.productImage" />
        </view>
        <view class="itemInfo">
          <p>{{item.productName}}</p>
          <view class="number" v-if="item.limitNumber">限量{{item.limitNumber}}件 / 剩余{{item.limitStockNumber}}件</view>
          <view class="originalPrice">原价: ¥{{item.originalPrice}}</view>
          <view class="price">
            <view class="currentPrice flex-row-plus flex-items-plus font-color-FF7800">
              <view class="iconBox">
                <image :src="`${VUE_APP_STATIC_URL}static/images/discountListIcon.png`"></image>
              </view>
              <view class="flex-row-plus flex-items priceInfo">
                <label class="fs24">￥</label>
                <label class="fs36">{{item.price}}</label>
              </view>
            </view>
            <view class="snapUpBtn" @click="gogoodsDetails(item.shopId,item.productId,item.skuId)">
              <view class="btnText">去抢购</view>
              <view style="width: 82%;margin: 0 auto">
                <progress activeColor="#FFFFFF" :percent="getPercent(20, 100)" active stroke-width="5" />
              </view>
            </view>
          </view>
        </view>
      </view>
      <view v-if="ifEmpty" class="emptyOrder-box flex-items-plus flex-column">
        <image class="emptyOrder-img" :src="`${VUE_APP_STATIC_URL}static/img/bgnull.png`"></image>
        <label class="font-color-999 fs26 mar-top-30">暂无活动商品～</label>
      </view>
    </view>
  </view>
</template>

<script setup>
import { ref } from "vue";
import { request } from "../../utils/request";
import API from "../../config/api";
import {onLoad, onShow, onReachBottom} from "@dcloudio/uni-app";
import { VUE_APP_STATIC_URL } from "@/config/api";

const pageType = ref(true)
const getDiscount = ref([])
const getDiscountData = ref({})
const page = ref(1)
const pageSize = ref(5)
const loadingType = ref(0)
const days = ref('00')
const hou = ref('00')
const min = ref('00')
const sec = ref('00')
const shopId = ref(0)
const shopSeckillId = ref(0)
const type = ref(1)
const volume = ref(1)
const shopShowType = ref(false)
const selectIndex = ref(0)
const sortIndex = ref(0)
const discountInfo = ref({})
const time = ref('')
const discountId = ref('')
const ifEmpty = ref(false)

onLoad((options) => {
  discountId.value = options.discountId
})

onShow(() => {
  getDiscountInfo()
  getDiscountList()
})

onReachBottom(() => {
  if(loadingType.value == 1){
    uni.stopPullDownRefresh()
  }else{
    page.value = page.value + 1
    getDiscountList()
  }
})
/**
 * 获取折扣信息
 * @returns {Promise<void>}
 */
const getDiscountInfo = async () => {
  try {
    const res = await request(API.queryPlatformDiscount,{
      discountId: discountId.value
    },'GET')
    discountInfo.value = res.data
    time.value = new Date(discountInfo.value.endTime).getTime() - new Date().getTime()
    dateformat(time.value)
    countDown()
  } catch (err) {
    // uni.showToast({
    //   title:'失败',
    //   icon:"none"
    // })
  }
}
/**
 * 数据进度条
 * @param num 当前数量
 * @param total 总数
 * @returns {string|number|string}
 */
const getPercent = (num, total) => {
  num = parseFloat(num);
  total = parseFloat(total);
  if (isNaN(num) || isNaN(total)) {
    return "-";
  }
  return total <= 0? "0%" : Math.round((num / total) * 10000) / 100.0;
}
/**
 * 排序
 * @param index
 */
const sortTap = (index) =>{
  page.value = 1
  getDiscount.value = []
  if ( index == 1 ) {
    type.value = 1
    volume.value = 1
    sortIndex.value = index
  } else if (index == 2) {
    type.value = type.value != 1 ? 1:2
    sortIndex.value = index
  } else if (index == 3) {
    volume.value = volume.value != 1 ? 1:2
    sortIndex.value = index
  }
  getDiscountList()
}

// const synthesize = () => {
//   volume.value =1//销量
//   type.value = 1//价格
//   page.value = 1
//   selectIndex.value = 0
//   getDiscount.value = []
//   getDiscountList()
// }

const sales = () => {
  //销量
  if(volume.value == 1){
    volume.value = 2
  }else{
    volume.value = 1
  }
  type.value = 1//价格
  page.value = 1
  selectIndex.value = 1
  getDiscount.value = []
  getDiscountList()
}

const priceClick = () => {
  volume.value = 1//销量
  //价格
  if (type.value == 1) {
    type.value = 2
  } else {
    type.value = 1
  }
  page.value = 1
  selectIndex.value = 2
  getDiscount.value = []
  getDiscountList()
}
/**
 * 跳转商品详情
 * @param shopId 店铺ID
 * @param productId 商品ID
 * @param skuId 规格ID
 */
const gogoodsDetails = (shopId,productId,skuId) => {
  uni.navigateTo({
    url:'../goodsModule/goodsDetails?shopId='+shopId + '&productId='+productId +'&skuId='+skuId
  })
}
/**
 * 获取折扣列表数据
 * @returns {Promise<void>}
 */
const getDiscountList = async () => {
  let param = {
    page: page.value,
    pageSize: pageSize.value,
    discountId: discountId.value,
    type: '',
    volume: ''
  }
  try {
    const res = await request(API.queryPlatformDiscountProductList,param,'POST')
    uni.hideLoading()
    if(res.data.list.length == 0){
      loadingType.value = 1
      page.value = page.value
    }else{
      getDiscount.value = getDiscount.value.concat(res.data.list)
      if (getDiscount.value.length === 0) {
        ifEmpty.value = true
      }
    }
  } catch (err) {
    uni.showToast({
      title:'失败',
      icon:"none"
    })
  }
}

/**
 * 时分秒换算
 * @param micro_second
 */
const dateformat = (micro_second) => {
  // 总秒数
  let second = Math.floor(micro_second / 1000);
  // 天数
  let day = Math.floor(second / 3600 / 24);
  // 小时
  let hr = Math.floor(second / 3600 % 24);
  // 分钟
  let mins = Math.floor(second / 60 % 60);
  // 秒
  let secs = Math.floor(second % 60);
  hou.value = hr + day * 24
  min.value = mins
  sec.value = secs
}

const countDown = () => {
  let timeOut = setTimeout(() => {
    let hous = parseInt(hou.value + days.value * 24);
    let mins = parseInt(min.value);
    let secs = parseInt(sec.value);

    let netxSec = secs - 1;
    let netxMin = mins
    let netxHou = hous;

    if (netxHou == 0 && netxMin == 0 && netxSec == -1) {
      clearTimeout(timeOut)
      uni.switchTab({
        url:'../../pages/tabbar/index/index'
      })
      uni.showToast({
        title:"活动结束",
        duration: 2000,
        icon:'none'
      })
    } else {
      if (netxSec == -1) {
        netxSec = 59
        netxMin = netxMin - 1;
      }
      if (netxMin == -1) {
        netxMin = 59
        netxHou = netxHou - 1
      }
      hou.value = timeFormat(netxHou)
      min.value = timeFormat(netxMin)
      sec.value = timeFormat(netxSec)
      countDown();
    }
  }, 1000)
}
/**
 * 小于10的格式化函数
 */
const timeFormat = (param) => {
  return param < 10 ? '0' + param : param;
}
</script>
<style>
page {
  background: #333333;
}
</style>
<style lang="scss" scoped>
@import "../../style/images";
page {
  background: #333333;
}
  .spikeListBox {
    .discountBg {
      width: 100%;
      height: 480rpx;
      background: $discountBg no-repeat left top;
      background-size: contain;
      position: relative;
      .discountInfoBox {
        position: absolute;
        width: 100%;
        bottom: 0;
        .discountInfo {
          width: 250rpx;
          height: 99rpx;
          line-height: 91rpx;
          text-align: center;
          background: $discountText no-repeat center center;
          font-size: 28rpx;
          color: #FFFFFF;
          background-size: contain;
          margin: 0 auto;
        }
      }
    }
	  .selected{
		  color: #FE6F52;
	  }
	  .shopShowTypebox{
		  height: 80rpx;
		  background-color: #FFFFFF;
		  z-index: 9999;
	  }
    .countdown {
      display: flex;
      justify-content: center;
      height: 80upx;
      align-items: center;
      width: 100%;
      color: #CCCCCC;
      .endDate {
        display: flex;
        align-items: center;
        margin-left: 20upx;
        span {
          min-width: 44rpx;
          padding: 0 8rpx;
          height: 52upx;
          line-height: 52upx;
          background: #999999;
          display: block;
          font-size: 26upx;
          color: #FFEBC4;
          text-align: center;
        }
        i {
          font-size: 26upx;
          color: #999999;
          font-style: normal;
          margin: 0 8upx;
        }
      }
    }
    .spikeList {
      padding: 20upx 30upx 20upx 30upx;
      .listItem {
        display: flex;
        padding: 30rpx;
        margin-bottom: 30upx;
        background: #FFFFFF;
        &:last-child {
          border-bottom: none;
        }
        .itemBox {
          width: 260upx;
          height: 260upx;
          margin-right: 30upx;
          image {
            width: 100%;
            height: 100%;
          }
        }
        .itemInfo {
          flex: 1;
          .iconBox {
            image {
              width: 58rpx;
              height: 36rpx;
            }
          }
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
            color: #C5AA7B;
            font-size: 26rpx;
            height: 40rpx;
            background: #FFFFFF;
            border: 2rpx solid #E4E5E6;
            font-weight: 400;
            display: inline;
            padding: 0 5rpx;
          }
          .originalPrice {
            font-size: 24upx;
            margin-top: 20upx;
            text-decoration: line-through;
            color: #CCCCCC;
          }
          .price {
            display: flex;
            justify-content: space-between;
            align-items: center;
            .priceInfo {
              font-size: 40rpx;
              color: #C83732;
            }
            .snapUpBtn {
              width: 160upx;
              height: 84upx;
              text-align: center;
              background: linear-gradient(90deg, #C83732 0%, #E25C44 100%);
              box-shadow: 0rpx 6rpx 12rpx rgba(233, 0, 0, 0.3);
              opacity: 1;
              border-radius: 10rpx;
              .btnText {
                color: #FFFFFF;
                font-weight: 400;
                opacity: 0.5;
                margin: 10rpx 0;
              }
              .uni-progress {
                border-radius: 10rpx;
              }
            }
          }
        }
      }
    }
    .filterBox {
      display: flex;
      height: 80upx;
      align-items: center;
      width: 100%;
      background: #FFFFFF;
      left: 0;
      .item {
        flex: 0 0 33.33%;
        text-align: center;
      }
    }
  }

.shop-list-nav {
  display: flex;
  flex-direction: row;
  align-items: center;
  height: 80rpx;
  line-height: 76rpx;
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
.emptyOrder-box {
  margin-top: 70upx;

  .emptyOrder-img {
    margin-top: 30%;
    width: 216upx;
    height: 152upx;
  }
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
  color: #999999;
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
</style>
<style scoped>
.snapUpBtn /deep/ .uni-progress-bar {
  border-radius: 10rpx;
  height: 8rpx;
  background-color: #deabab !important;
}
.snapUpBtn /deep/ .uni-progress-inner-bar {
  border-radius: 10rpx;
}
.spikeNav /deep/ .tabs-nav {
}
</style>
