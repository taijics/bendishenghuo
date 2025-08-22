<template>
	<view class="page-notice">
		<viw class="list-box">
			<view
				class="l-item"
				v-for="it in list"
				:key="it.type"
				@click="jumpTo(it)"
			>
				<view class="l-p">
					<image :src="`${VUE_APP_STATIC_URL}static/img/circle/${it.type}.png`" class="img"/>
				</view>
				<view class="r-p">
					<view class="text">{{it.label}}</view>
					<view class="dot" v-if="it.count">
						<text>{{formatCount(it.count)}}</text>
					</view>
				</view>
			</view>
		</viw>
	</view>
</template>

<script setup>
import {ref, onBeforeMount} from 'vue';
import {VUE_APP_STATIC_URL} from "@/config/api";
import {request} from "@/utils/request";
import API from "@/config/api";
import { onShow } from "@dcloudio/uni-app";

const list = ref([
	{label: '系统消息', type: 'system'},
	{label: '互动消息', type: 'interaction'},
])

onShow(() => {
	getNoticeInfo();
})

const getNoticeInfo = async() => {
	const sRes = await request(API.GetUser, {}, 'GET');
	const res = await request(API.CircleNotice, {}, 'GET');
	list.value[0].count = sRes.data.notRead;
	list.value[1].count = res.data;
}

function formatCount(v) {
	if(!v) return 0;
	if(v>99) return '99+'
	return v
}

function jumpTo(it) {
	uni.navigateTo({
		url: `/pages_category_page2/notice/${it.type}`
	})
}
</script>

<style lang="scss" scoped>
.page-notice {
	padding-top: 32rpx;
	.list-box {
		box-sizing: border-box;
		.l-item {
			display: flex;
			align-items: center;
			padding-left: 32rpx;
			&:first-child {
				margin-bottom: 32rpx;
				.r-p {
					position: relative;
					&::after {
						content: '';
						position: absolute;
						display: block;
						height: 1rpx;
						width: 100%;
						background: #F3F4F6;
						left: 0;
						bottom: -50rpx;
					}
				}
			}
			.l-p {
				width: 96rpx;
				.img {
					width: 96rpx;
					height: 96rpx;
					vertical-align: middle;
				}
			}
			.r-p {
				flex: 1;
				display: flex;
				justify-content: space-between;
				padding-left:16rpx;
				.text {
					flex: 1;
					color: #292929;
					font-size: 28rpx;
				}
				.dot {
					flex: 1;
					padding-right: 32rpx;
					text {
						float: right;
						display: inline-block;
						height: 32rpx;
						line-height: 32rpx;
						border-radius: 16rpx;
						color: #ffffff;
						font-size: 20rpx;
						background: #FD2A53;
						padding: 0 10rpx;
					}
				}
			}
		}
	}
}
</style>