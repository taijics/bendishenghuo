<template>
  <view class="spikeListBox">
    <global-loading />

    <view class="spikeBgBox">
      <view class="discountBg">
      </view>
      <view class="countdown" v-if="shopShowType == false">
        距活动结束剩余<view class="endDate"><span>{{hou}}</span><i>:</i><span>{{min}}</span><i>:</i><span>{{sec}}</span></view>
      </view>
      <!--	  <view class="filterBox" v-else>-->
      <!--		<view class="item" :class="selectIndex == 0 ? 'selected' : ''" @click="synthesize"><span>综合</span></view>-->
      <!--		<view class="item" :class="selectIndex == 1 ? 'selected' : ''" @click="sales"><span>销量</span></view>-->
      <!--		<view class="item" :class="selectIndex == 2 ? 'selected' : ''" @click="priceClick"><span>价格</span></view>-->
      <!--	  </view>-->
      <view id="boxFixed" class="nav-warp">
        <view class="shop-list-nav" :class="{'is-fixed' : isFixed}">
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
      </view>
    </view>
    <view class="spikeList">
      <view class="listItem" v-for="(item,index) in getDiscount" :key="index">
        <view class="itemBox">
          <image :src="item.image" />
        </view>
        <view class="itemInfo">
          <p>{{item.productName}}</p>
          <view class="price">
            <view class="currentPrice">
              <view class="originalPrice">原价: ¥{{item.originalPrice}}</view>
              <view class="flex-row-plus flex-items-plus">
                <view class="iconBox">
                  <image :src="`${VUE_APP_STATIC_URL}static/images/memberCenterIcon.png`"></image>
                </view>
                <view class="flex-row-plus flex-items priceInfo">
                  <label class="fs24">￥</label>
                  <label class="fs36">{{item.price}}</label>
                </view>
              </view>
            </view>
            <view class="snapUpBtn" @click="gogoodsDetails(item.shopId,item.productId,item.skuId)">
              <view class="btnText">立即购买</view>
            </view>
          </view>
        </view>
      </view>
    </view>
  </view>
</template>

<script setup>
import {ref} from "vue";
import { request } from '../../utils/request'
import API from "../../config/api";
import {onPageScroll, onReady, onLoad, onShow, onReachBottom} from "@dcloudio/uni-app";
import { VUE_APP_STATIC_URL } from "@/config/api";

const pageType = ref(true);
const getDiscount = ref([]);
const getDiscountData = ref({});
const page = ref(1);
const pageSize = ref(10);
const loadingType = ref(0);
const days = ref('00');
const hou = ref('00');
const min = ref('00');
const sec = ref('00');
const shopId = ref(0);
const shopSeckillId = ref(0);
const type = ref(''); // 价格
const volume = ref(''); // 销量
const shopShowType = ref(false);
const selectIndex = ref(0);
const sortIndex = ref(1);
const isFixed = ref(false);
const boxFixedTop = ref(0);
const shopDiscountId = ref(0);

onPageScroll((res) => {
  let scrollTop = res.scrollTop // 滚动条偏移量
  let offsetTop = boxFixedTop.value // 要滚动到顶部吸附的元素的偏移量
  isFixed.value = scrollTop > offsetTop ? true : false; // 如果滚动到顶部了，this.isFixed就为true
})

onReady(() => {
  const query = uni.createSelectorQuery().in(this);
  query.select('#boxFixed').boundingClientRect(data => {
    console.log(data,'boxFixed')
    boxFixedTop.value = data.top
  }).exec()
})

onLoad((options) => {
  if(options.shopId && options.shopDiscountId){
    shopShowType.value = false
    shopId.value = options.shopId
    shopDiscountId.value = options.shopDiscountId
  }else{
    shopShowType.value = true
    shopId.value = 0
    shopDiscountId.value = 0
  }
})

onShow(() => {
  getMemberList()
})

onReachBottom(() => {
  if(loadingType.value == 1){
    uni.stopPullDownRefresh()
  }else{
    page.value = page.value + 1
    getMemberList()
  }
})

const getPercent = (num, total) => {
  num = parseFloat(num);
  total = parseFloat(total);
  if (isNaN(num) || isNaN(total)) {
    return "-";
  }
  return total <= 0? "0%" : Math.round((num / total) * 10000) / 100.0;
}

const sortTap = (index) => {
  page.value = 1
  getDiscount.value = []
  if(index == 1){
    type.value = null
    volume.value = null
    sortIndex.value = index
  }else if(index == 2){
    type.value = type.value != 1 ? 1:2
    volume.value = null
    sortIndex.value = index
  }else if(index == 3){
    type.value = null
    volume.value = volume.value != 1 ? 1:2
    sortIndex.value = index
  }
  getMemberList()
}

const gogoodsDetails = (shopId,productId,skuId) => {
  uni.navigateTo({
    url:'../goodsModule/goodsDetails?shopId='+shopId + '&productId='+productId +'&skuId='+skuId
  })
}

const getMemberList = async () => {
  // uni.showLoading({
  //   mask: true,
  //   title: '加载中...',
  // })
  let param = ''
  const storageKey = uni.getStorageSync('storage_key');
  if(storageKey){
    param = {
      page: page.value,
      pageSize: pageSize.value,
      memberLevelId: storageKey.memberLevelId
    }
    if(type.value) {
      param.type = type.value
    }
    if(volume.value) {
      param.volume = volume.value
    }
    try {
      const res = await request(API.getMemberProducts,param,'GET')
      uni.hideLoading()
      if(res.data.list.length == 0){
        loadingType.value = 1
      }else{
        getDiscount.value = getDiscount.value.concat(res.data.list)
      }
    } catch (err) {
      uni.showToast({
        title:'请求失败',
        icon:"none"
      })
    }
  } else {
    uni.showToast({
      title:'请先登录',
      icon:"none"
    })
    uni.navigateTo({
      url: '/pages_category_page2/userModule/login'
    })
  }
}

/**
 * 时分秒换算
 */
const dateformat = (micro_second) => {
  // 总秒数
  let second = Math.floor(micro_second / 1000);
  // 天数
  let day = Math.floor(second / 3600 / 24);
  // 小时
  let hr = Math.floor(second / 3600 % 24);
  // 分钟
  let min = Math.floor(second / 60 % 60);
  // 秒
  let sec = Math.floor(second % 60);
  hou.value = hr+day*24
  min.value = min
  sec.value = sec
}
</script>
<style>
page {
  background: #333333;
}
</style>
<style lang="scss" scoped>
@import "../../style/images";
.spikeListBox {
  .discountBg {
    width: 100%;
    height: 440rpx;
    background: $memberCenterBg no-repeat center center;
    background-size: contain;
    position: relative;
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
          height: 115rpx;
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
          margin: 20upx 0;
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
            margin-top: 20rpx;
            width: 140upx;
            height: 84upx;
            line-height: 84rpx;
            text-align: center;
            background: #333333;
            opacity: 1;
            border-radius: 10rpx;
            .btnText {
              color: #FFEBC4;
              font-weight: 400;
              font-size: 24rpx;
            }
            .uni-progress {
              border-radius: 10rpx;
            }
          }
        }
      }
    }
  }
 /* #ifdef MP-WEIXIN */
 .spikeList{
	 /*margin-top: 530rpx;*/
 }
 /* #endif */
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
.nav-warp{
  height: 80rpx;
}
.shop-list-nav {
  display: flex;
  flex-direction: row;
  align-items: center;
  height: 80rpx;
  line-height: 76rpx;
  background-color: #333;
  &.is-fixed{
    position: fixed;
    top: 70rpx;
    left: 0;
    width: 100%;
    z-index: 999;
  }
    /* #ifdef MP-WEIXIN */
    &.is-fixed{
        top: 0px;
    }
    /* #endif */
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
