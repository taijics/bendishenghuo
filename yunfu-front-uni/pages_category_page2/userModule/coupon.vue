<!-- 优惠券列表 -->
<template>
	<view class="container">
<!--    <global-loading />-->
    <!-- 骨架屏 -->
    <u-skeleton
        el-color="#efefef"
        bg-color="#f7f7f7"
        :loading="loading && isFirstComeIn"
        :animation="true"
    ></u-skeleton>
		<view class="list u-skeleton">
			<view
				class="item u-skeleton-fillet"
				v-for="(item, index) in list"
			>
				<view class="info-box" v-if="item.state === 0">
          <view class="discoun" v-if="item.couponType == 1"><text style="font-size: 28rpx">￥</text>{{item.reduceMoney}}</view>
          <view class="discoun" v-if="item.couponType == 2">{{item.reduceMoney}}折</view>
				  <view class="info-date">{{getDate(item.startTime)}}-{{getDate(item.endTime)}}</view>
          <view class="info-condition" v-if="item.couponType == 1">满{{item.fullMoney}}元减{{item.reduceMoney}}元</view>
          <view class="info-condition" v-if="item.couponType == 2">{{item.reduceMoney}}折优惠</view>
          <view class="use-btn" @click="useTap(item)">立即使用</view>
				</view>
			</view>
      <view v-if="ifEmpty" class="emptyOrder-box flex-items-plus flex-column">
        <image class="emptyOrder-img" :src="`${VUE_APP_STATIC_URL}static/img/bgnull.png`"></image>
        <label class="font-color-999 fs26 mar-top-30">你还没有优惠券哦～</label>
      </view>
		</view>
		<!-- 触底 -->
    <view class="reachBottom" v-if="topLeft > 400 && list.length > 0">
			<image class="reach-icon" :src="`${VUE_APP_STATIC_URL}static/img/reachBottom.png`" mode="widthFix"></image>
			<text class="reach-text">这里到底了哦~~</text>
		</view>
	</view>
</template>

<script setup>
	import { request } from "@/utils/request";
	import API from "@/config/api";
  import { ref } from "vue";
  import {onLoad, onPageScroll, onShow} from "@dcloudio/uni-app";
  import { VUE_APP_STATIC_URL } from "@/config/api";

  const list = ref([{}, {}, {}, {}, {}, {}, {}, {}, {}, {}])
  const total = ref(0)
  const availableList = ref([])
  const topLeft = ref(0)
  const ifEmpty = ref(false)
  const loading = ref(false);
  const isFirstComeIn = ref(true);

  onLoad(()=>{
    getFindCouponList()
  })
  onPageScroll(e=>{
    topLeft.value = e.scrollTop
  })

  function getFindCouponList(){
    loading.value = true
    request(API.FindCouponList,"GET").then(res => {
      list.value = res.data
      if (list.value.length === 0) {
        ifEmpty.value = true
      }
      list.value.forEach((item => {
        if (item.state === 0) {
          availableList.value.push(item)
        }
      }))
    }).catch(res => {
      // uni.hideLoading()
    }).finally(()=>{
      loading.value = false
      isFirstComeIn.value = false
    })
  }
  function getDate(time) {
    if (!time) return '';
    return time.split(' ')[0].split('-').join('.');
  }
  function useTap(item){
    uni.navigateTo({
      url: `../../pages_category_page1/goodsModule/couponShopList?activityId=${item.activityId}&shopCouponId=${item.shopCouponId}`
    })
  }
</script>

<style lang="scss" scoped>
@import '../../style/images';
.container {
  padding: 0 24rpx;
}
.emptyOrder-box{
	margin: 70upx auto 0 auto;
	.emptyOrder-img{
		margin-top: 45%;
		width: 113upx;
		height: 98upx;
	}
}
.list {
  display: flex;
  flex-wrap: wrap;
}

.item {
  width: 48%;
  height: 291rpx;
  background: $couponsIcon no-repeat center top;
  border-radius: 10rpx;
  margin-top: 20rpx;
  display: flex;
  flex-direction: row;
  position: relative;
  background-size: contain;
  padding: 0 56rpx;
  margin-bottom: 30rpx;
  margin: 1%;
}

.discoun {
  display: flex;
  flex-direction: row;
  align-items: baseline;
  font-size: 40rpx;
  color: #C5AA7B;
  margin: 0 auto;
  padding-top: 50rpx;
}

.discoun text {
  display: inline-block;
}

.info-box {
  width: 100%;
  display: flex;
  flex-direction: column;
  align-items: flex-start;
}

.info-condition {
  font-size: 20rpx;
  font-weight: 400;
  color: #999999;
  margin: 0 auto;
}

.info-date {
  font-size: 20rpx;
  font-family: PingFang SC;
  font-weight: 400;
  color: #999999;
  margin: 0 auto;
}

.use-btn {
  height: 48rpx;
  border: 2rpx solid #C5AA7B;
  line-height: 48rpx;
  text-align: center;
  font-size: 24rpx;
  font-weight: 500;
  background-color: #C5AA7B;
  color: #FFFFFF;
  margin: 50rpx auto 0 auto;
  padding: 0 5rpx;
}

// 触底样式
.reachBottom{
	margin-top: 30rpx;
	display: flex;
	flex-direction: column;
	align-items: center;
	.reach-icon{
		width: 150rpx;
		height: 150rpx;
	}
	.reach-text{
		margin: 20rpx 0;
		color: #CCCCCC;
	}
}
</style>
