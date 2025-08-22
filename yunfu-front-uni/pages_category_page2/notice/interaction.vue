<template>
	<view class="page-interaction u-skeleton">
    <Skeleton
        el-color="#efefef"
        bg-color="#fff"
        :loading="loading && isFirstComeIn"
        :animation="true"
    />
		<view
			class="list-item"
			v-for="(it, i) in dataOb.list"
			:key="i"
		>
			<view class="l-p">
				<image :src="it.avatar" class="avatar u-skeleton-circle"/>
			</view>
			<view class="r-p">
				<viwe class="info">
					<view class="user">
            <text class="u-skeleton-rect">{{it.userName}}</text>
          </view>
					<view class="time">
						<text class="u-skeleton-rect">{{formatDate(it.createTime)}}</text>
					</view>
					<view class="content u-skeleton-rect" @click="jumpTo(it)">
						回复了你: {{it.content}}
					</view>
					<view class="reply" @click.stop="replyCom(it)">
						<image :src="it.myAvatar" class="myAvatar u-skeleton-circle"/>
						<text class="u-skeleton-rect">回复评论</text>
					</view>
				</viwe>
				<view class="file u-skeleton-fillet">
					<view class="img-box" @click="jumpTo(it)">
						<image :src="it.fileUrl" class="file-item"/>
						<img
							v-if="it.fileType===2"
							class="play-icon"
							:src="`${VUE_APP_STATIC_URL}static/img/circle/play.png`"
						/>
					</view>
				</view>
			</view>
		</view>
    <slide-loading />
    <view
        class="reachBottom"
        v-if="noMore && topLeft > 400"
    >
      <image
          class="reach-icon"
          :src="`${VUE_APP_STATIC_URL}static/img/reachBottom.png`"
          mode="widthFix"
      ></image>
      <text class="reach-text">这里到底了哦~~</text>
    </view>
		<view v-if="ifEmpty" class="empty-box">
			<image class="question-empty" :src="`${VUE_APP_STATIC_URL}static/img/bgnull.png`"></image>
			<view class="tohome-box flex-items-plus">暂无消息</view>
		</view>
		<view v-if="popInfo.visible" class="mask" @click="close">
			<view class="pop-box" @click.stop="() => {}">
				<textarea placeholder="发布评论" class="textarea" v-model.trim="popInfo.content"/>
				<view class="send" @click="addComment" v-if="popInfo.content">发送</view>
			</view>
		</view>
    <!-- 回到顶部 -->
    <ReturnTop :returnTopFlag="returnTopFlag" />
	</view>
</template>

<script setup>
import {ref, onBeforeMount} from 'vue';
import {request} from "@/utils/request";
import API from "@/config/api";
import {onPageScroll, onReachBottom} from "@dcloudio/uni-app";
import { VUE_APP_STATIC_URL } from "@/config/api";
import Skeleton from "../../components/Skeleton/index.vue";

const dataOb = ref({list:[{}, {}, {}, {}, {}, {}, {}, {}, {}]});
const page = ref(1);
const pageSize = ref(20);
const loading = ref(false)
const isFirstComeIn = ref(true)
const returnTopFlag = ref(false); // 返回顶部显示隐藏
const topLeft = ref(0); // 无更多数据显示距离
const noMore = ref(false); // 没有更多数据显示隐藏
const ifEmpty = ref(false);
const defaultPopup = {
	visible: false,
	content: ''
}
const popInfo = ref({...defaultPopup});

onBeforeMount(() => {
	init();
})

onReachBottom(() => {
  if (!ifEmpty.value && noMore.value) {
    uni.stopPullDownRefresh()
  } else {
    page.value = page.value + 1
    init()
  }
})

const init = async() => {
  loading.value = true
	const {data, code} = await request(API.CircleMyNotice, {
		pageSize: pageSize.value,
		page: page.value
	}, 'GET');
	if(code==='') {
		const {total, list} = data
		if(!total) ifEmpty.value = true;
		list.forEach(it => {
			it.fileUrl = it.fileUrl.split(',')[0];
			if(it.fileType===2) it.fileUrl = it.cover;
		})
		Object.assign(dataOb.value, {
			total,
			list: [...(dataOb.value.list||[]), ...list]
		})
    console.log(dataOb.value.list, 'test')
    dataOb.value.list = dataOb.value.list.filter(item => Object.keys(item).length > 0);
    if (dataOb.value.list.length === 0) {
      ifEmpty.value = true
    }
    if (dataOb.value.list.length >= total) {
      noMore.value = true
    }
    loading.value = false
    isFirstComeIn.value = false
	}
}
function formatDate(date) {
	const s = (new Date().getTime() - new Date(date).getTime()) / 1000;
	const h = parseInt(s/3600);
	let y = 0;
	let m = 0;
	let d = 0;
	if(h>=24) d = parseInt(h/24);
	if(d>=31) m = parseInt(d/31);
	if(m>=12) y = parseInt(m/12);
	if(y) return y+'年前';
	if(m) return m+'月前';
	if(d) return d+'天前';
	if(h) return h+'小时前'
	return '刚刚'
}
function jumpTo(it) {
	const {fileType} = it;
	uni.navigateTo({
		url: `/pages_category_page2/circle/${fileType===1?'img':'video'}Circle?recommendId=${it.recommendId}&replyCommentId=${it.recommendCommentId}`
	})
}
const replyCom = async(it) => {
	const {code, data} = await request(API.ReplyStatus, {recommendCommentId: it.recommendCommentId}, 'GET');
	if(code==='') {
		if(!data) {
			uni.showToast({
			  title: '该评论不存在',
			  icon: "none"
			})
			return
		}
		Object.assign(popInfo.value, {
			visible: true,
			recommendCommentId: it.recommendCommentId,
			recommendId: it.recommendId
		})

	}
}
function close() {
	popInfo.value = {...defaultPopup};
}
const addComment = async() => {
	const {content, recommendCommentId, recommendId} = popInfo.value;
	const params = {
		recommendCommentId,
		content,
		recommendId
	}
	const {code, data} = await request(API.CircleCommentAdd, params, "POST");
	if(code==='') {
		close();
	}
}

onPageScroll(e => {
  returnTopFlag.value = e.scrollTop > 600;
  topLeft.value = e.scrollTop
})

</script>

<style lang="scss" scoped>
.page-interaction {
	padding-top: 24rpx;
	.list-item {
		display: flex;
		padding-left: 32rpx;
		.l-p {
			width: 96rpx;
			.avatar {
				width: 96rpx;
				height: 96rpx;
				border-radius: 50%;
			}
		}
		.r-p {
			padding:0 32rpx 32rpx 16rpx;
			display: flex;
			flex: 1;
			margin-bottom: 32rpx;
			border-bottom: 1rpx solid #F3F4F6;
			.info {
				flex: 1;
				padding-right: 16rpx;
				.user {
					font-size: 28rpx;
					color: #666666;
					margin-bottom: 8rpx;
          text {
            min-width: 140rpx;
            min-height: 34rpx;
            display: inline-block;
          }
				}
				.time {
					color: #999999;
					font-size: 24rpx;
					margin-bottom: 8rpx;
          text {
            min-width: 80rpx;
            min-height: 34rpx;
            display: inline-block;
          }
				}
				.content {
					color: #333333;
					font-size: 28rpx;
					margin-bottom: 16rpx;
					word-break: break-word;
				}
				.reply {
					display: inline-block;
					.myAvatar {
						height: 100%;
						width: 40rpx;
						border-radius: 50%;
						margin-right: 8rpx;
						vertical-align: middle;
					}
					color: #666666;
					font-size: 24rpx;
					padding-right: 16rpx;
					border-radius: 20rpx;
					background: #F5F5F5;
					height: 40rpx;
					line-height: 40rpx;
				}
			}
			.file {
				width: 120rpx;
				.img-box {
					height: 160rpx;
					position: relative;
					.file-item {
						width: 100%;
						height: 100%;
					}
					.play-icon {
						position: absolute;
						width: 20rpx;
						height: 20rpx;
						top: 70rpx;
						left: calc(50% - 10rpx);
					}
				}

			}
		}
		&:nth-last-child(-n+1) {
			.r-p {
				border: none;
			}
		}
	}

	.empty-box {
		display: flex;
		justify-content: center;
		flex-direction: column;
		align-items: center;
		padding-top: 50% ;
		.tohome-box {
			color: #999999;
			margin-top: 50rpx;
		}
		.question-empty {
			width: 113rpx;
			height: 98rpx;
		}
	}
	.mask {
		position: fixed;
		top: 0;
		left: 0;
		right: 0;
		bottom: 0;
		z-index: 55;
		background-color: rgba(0, 0, 0, 0.7);
		z-index: 999;
		.pop-box {
			width: 100%;
			background: #ffffff;
			position: fixed;
			bottom: 0;
			padding: 32rpx;
			.textarea {
				height: 200rpx;
				width: 100%;
				background: #F5F5F5;
				border-radius: 16rpx;
				margin-bottom:24rpx;
				padding:24rpx;
				box-sizing: border-box;
			}
			.send {
				height: 88rpx;
				border-radius: 44rpx;
				background: #333333;
				line-height: 88rpx;
				text-align: center;
				font-size:28rpx;
				color: #ffffff;
			}
		}
	}
}
</style>
