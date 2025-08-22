<template>
	<view class="notice">
		<view class="content">
			<image :src="`${VUE_APP_STATIC_URL}static/assets/images/cereshop/notice.png`" mode=""></image>
			<swiper class="swiper" :circular="true" :autoplay="true" :vertical="true" :interval="3000" :duration="500">
			    <swiper-item v-for="(item,index) in list" :key="item.noticeId">
			        <view class="swiper-item uni-bg-red fs26 font-color-333 overflow" @tap="goToMesDetail(item)">{{item.noticeTitle}}</view>
			    </swiper-item>
			</swiper>
		</view>
	</view>
</template>

<script setup>
import {VUE_APP_STATIC_URL} from "@/config/api";
// props
const props = defineProps({
  list: {
    type: Array
  }
});

// methods
const goToMesDetail = (item) => {
  uni.navigateTo({
    url: '/pages_category_page2/userModule/messageDetail?noticeId='+item.noticeId,
    success: res => {}, fail: (err) => {console.log(err,'1')}, complete: () => {}
  })
}
</script>

<style lang="scss">
.notice{
	width: 100%;
	height: 60rpx;
	padding: 0 5%;
	box-sizing: border-box;
	margin-top: 20rpx;
	.content{
		width: 100%;
		height: 100%;
		border-radius: 30rpx;
		background: #F5F7FA;
		display: flex;
		align-items: center;
		padding: 0 30rpx;
		image{
			width: 38rpx;
			height: 38rpx;
			margin-right: 20rpx;
		}
		.swiper{
			flex: 1;
			height: 60rpx;
			.swiper-item{
				line-height: 60rpx;
			}
		}
	}
}
</style>
