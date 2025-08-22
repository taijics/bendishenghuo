<template>
	<view class="page-img-circle">
		<view class="circle-top" :style="{'padding-top': topHeight + height + 'px'}">
			<view class="l-p">
				<image :src="`${VUE_APP_STATIC_URL}static/images/back.png`" class="back" @click="back"/>
				<image :src="info.avatar" class="avatar" @click="toShop"/>
				<view class="u-box">
					<view class="text">{{info.name}}</view>
					<view class="text">{{info.day}}</view>
				</view>
			</view>
			<view class="r-p" @click="collectShop">{{!info.isCollect ? '关注ta' : '取消关注'}}</view>
		</view>
		<view class="info-box">
			<view class="circle-swiper">
				<swiper
					class="swiper"
					:current="imgIndex"
					@change="changeSwiper"
				>
					<swiper-item
						v-for="(item, i) in info.fileUrl"
						:key="i"
					>
						<image :src="item" class="circle-img"/>
					</swiper-item>
				</swiper>
				<view class="dot-box">
					{{imgIndex+1}}/{{info.fileUrl.length}}
				</view>
				<view class="img-tab">
					<image
						v-for="(item, i) in info.fileUrl"
						:key="i"
						:src="item"
						:class="['img-tab-item', i===imgIndex?'img-active':'']"
						@click="changeSwiper({detail:{current: i}})"
					/>
				</view>
			</view>
			<view class="remark">
				<view class="remark-text">{{info.remark}}</view>
				<scroll-view class="tabs-nav" scroll-x="true" v-if="info.products.length">
					<view class="ul">
						<view
							class="li"
							v-for="item in info.products"
							:key="item.productId"
							@click="productDetail(item)"
						>
							<image class="product-img" :src="item.images"/>
							<view class="n-text">
								{{item.productName}}
							</view>
						</view>
					</view>
				</scroll-view>
			</view>
			<view class="comment-list">
				<view class="title">评论	</view>
				<view class="list-box">
					<view
						class="list-item"
						v-for="it in commentData.list || []"
						:key="it.recommendCommentId"
					>
						<view class="l-item">
							<image class="user-avatar" :src="it.avatar"/>
						</view>
						<view class="r-item">
							<view class="first-com">
								<view class="name">{{it.userName}}</view>
								<view class="content">{{it.content}}</view>
								<view class="time-reply">
									<text class="time">{{formatDate(it.createTime)}}</text>
									<text class="reply" @click="replyComment(it.recommendCommentId)">回复</text>
									<text class="del" v-if="it.isSelf" @click="delComment(it.recommendCommentId)">删除</text>
								</view>
							</view>
							<view class="recommend-box" v-if="it.children?.list?.length">
								<view
									v-for="child in it.children.list"
									:key="child.recommendCommentId"
									class="recommend-item"
								>
									<image :src="child.avatar" class="child-avatar"/>
									<view class="child-r-item">
										<view class="reply-content">
											<text>
												{{child.userName}}
											</text>
											<text v-if="child.targetUserName">
												▶
												{{child.targetUserName}}
											</text>
											: {{child.content}}
										</view>
										<view class="time-reply">
											<text class="time">{{formatDate(child.createTime)}}</text>
											<text class="reply" @click="replyComment(child.recommendCommentId, it.recommendCommentId)">回复</text>
											<text class="del" v-if="child.isSelf" @click="delComment(child.recommendCommentId, it.recommendCommentId)">删除</text>
										</view>
									</view>
								</view>
							</view>
							<view class="fun-list" v-if="it.replyCount">
								<view class="fun-text" v-if="!it.show" @click="getReplyComment(it)">
									—— 展开{{it.replyCount}}条回复
									<image :src="`${VUE_APP_STATIC_URL}static/images/arrowDownIcon.png`" class="arrow"/>
								</view>
								<view
									class="fun-text more"
									@click="getReplyComment(it)"
									v-if="it.show&&it.children&&it.children.total>it.children.list.length"
								>
									—— 查看更多
									<image :src="`${VUE_APP_STATIC_URL}static/images/arrowDownIcon.png`" class="arrow"/>
								</view>
								<view class="fun-text" v-if="it.show" @click="closeRecommend(it)">
									—— 收起全部回复
									<image :src="`${VUE_APP_STATIC_URL}static/images/arrowUpIcon.png`" class="arrow"/>
								</view>
							</view>
						</view>
					</view>
				</view>
			</view>
			<view class="comment-btn">
				<view class="btn-cell">
					<view class="input-btn" @click="()=>{handleComment()}">发布评论</view>
					<view class="icon-box">
						<view class="icon-item">
							<image
								:src="`${VUE_APP_STATIC_URL}static/img/circle/like${info.likeStatus?'_active':''}.png`"
								class="icon-img"
								@click="handleLike"/>
							<view class="count">{{info.likeCount}}</view>
						</view>
						<view class="icon-item">
							<image :src="`${VUE_APP_STATIC_URL}static/img/circle/share.png`" class="icon-img" @click="share"/>
							<!-- <view class="count">{{info.shareCount}}</view> -->
						</view>
					</view>
				</view>
			</view>
		</view>
		<view v-if="popInfo.visible" class="mask" @click="close">
			<view class="pop-box" @click.stop="() => {}">
				<textarea placeholder="发布评论" class="textarea" v-model.trim="popInfo.content"/>
        <submit-button v-if="popInfo.content" text="发送" @submitEvent="addComment"></submit-button>
			</view>
		</view>
		<ShareSpell
		    ref="shareSpell"
		    :url="shareObj.url"
		    :img="shareObj.image"
		    :title="shareObj.title"
		    @shareCancel="shareCancel"
		/>
	</view>
</template>

<script setup>
import API from "@/config/api";
import { ref } from "vue";
import {onLoad, onReachBottom, onShow} from "@dcloudio/uni-app";
import {VUE_APP_STATIC_URL} from "@/config/api";
import { request } from "@/utils/request";
import ShareSpell from '@/component/share.vue'
import { btnUseLoading } from '../../hooks/bntUseLoading'

const { btnShowLoading } = btnUseLoading()
const topHeight = ref(10);
const height = ref(0);
const info = ref({
	fileUrl: [],
	products: []
});
const commentData = ref({});
const recommendId = ref('');
const imgIndex = ref(0);
const defaultPopup = {
	isReply: false,
	visible: false,
	content: ''
}
const popInfo = ref({...defaultPopup});
// 分享
const shareSpell = ref();
const shareObj = ref({});

onLoad(async(options)=>{
    // // #ifdef MP-WEIXIN || MP-BAIDU || MP-TOUTIAO || MP-QQ
    // let menuButtonInfo = uni.getMenuButtonBoundingClientRect()
    // topHeight.value = menuButtonInfo.top
    // // #endif
    // // #ifdef APP
    // topHeight.value = 50
    // // #endif
	recommendId.value = options.recommendId;
	getRecommendInfo();
	getComment(options.replyCommentId);
})

function productDetail(item) {
	uni.navigateTo({
		url: `/pages_category_page1/goodsModule/goodsDetails?shopId=${info.value.shopId}&productId=${item.productId}&skuId=${item.skuId}`
	});
}
function toShop() {
	uni.navigateTo({
		url: `/pages_category_page2/circle/shopCircle?recommendId=${recommendId.value}&shopId=${info.value.shopId}`
	})
}

// 关注店铺
const collectShop = async() => {
	const {code} = await request(API.CollectShop, {shopId: info.value.shopId}, 'POST');
	if(code) getRecommendInfo();
}

const getRecommendInfo = async() => {
	const {code, data} = await request(API.CircleInfo, {recommendId: recommendId.value}, 'GET');
	if(code==='') {
		data.fileUrl = data.fileUrl.split(',');
		info.value = data;
	}
}

function changeSwiper(item) {
	imgIndex.value = item.detail.current;
}
function back() {
	uni.navigateBack()
}
// 对象数组去重
function uniqueByKey(array, key) {
  return array.reduce((acc, current) => {
    const x = acc.find((item) => item[key] === current[key]);
    if (!x) {
      return acc.concat([current]);
    } else {
      return acc;
    }
  }, []);
}
// 获取首评数据
const getComment = async(replyCommentId) => {
	const params = {
		pageSize: 20,
		page: commentData.value.page || 1,
		recommendId: recommendId.value
	}
	if(replyCommentId) params.replyCommentId = replyCommentId;
	const {code, data} = await request(API.CircleCommentPage, params, "GET");
	if(code==="") {
		const {total, list} = data;
		const rList = [...(commentData.value.list || []), ...list]
		Object.assign(commentData.value, {
			page: commentData.value.page?2:commentData.value.page+1,
			list: uniqueByKey(rList, 'recommendCommentId'),
			total
		})
	}
}
// 触底加载首评分页数据
onReachBottom((e) => {
	const {list,  total} = commentData.value;
	if(total>list.length&&total) getComment()
})
// 展开评论和展开更多
const getReplyComment = async(parentItem={}) => {
	const {show, children} = parentItem;
	const params = {
		pageSize: 20,
		page: show?children.page:1,
		recommendId: recommendId.value,
		recommendCommentId: parentItem.recommendCommentId
	}
	const {code, data} = await request(API.CircleCommentPage, params, "GET");
	if(code==='') {
		const {total, list} = data;
		const index = commentData.value.list.findIndex(it => it.recommendCommentId===parentItem.recommendCommentId);
		const rList = show?[...(children.list || []), ...list]:list;
		Object.assign(commentData.value.list[index], {
			show: true,
			replyCount: total, // 删除或新增回复后，重置回复数
			children: {
				total,
				list: uniqueByKey(rList, 'recommendCommentId'),
				page: show?children.page+1:2
			}
		})
	}
}
// 收起所有回复
function closeRecommend(parentItem) {
	const index = commentData.value.list.findIndex(it => it.recommendCommentId===parentItem.recommendCommentId)
	// 重置回复状态
	Object.assign(commentData.value.list[index], {
		show: false,
		children: {
			total: 0,
			list: [],
			page: 1
		}
	})
}

// 评论弹框
function handleComment() {
	popInfo.value.visible = true;
}
function close() {
	popInfo.value = {...defaultPopup};
}
// 回复评论
function replyComment(targetId='', parentId='') {
	Object.assign(popInfo.value, {
		visible: true,
		isReply: true,
		targetId,
		parentId
	})
}
// 新增评论
const addComment = async() => {
  btnShowLoading()
	const {content, isReply, targetId, parentId} = popInfo.value;
	const params = {
		recommendId: recommendId.value,
		content
	}
	if(isReply) params.recommendCommentId = targetId;
	const {code, data} = await request(API.CircleCommentAdd, params, "POST");
	if(code==='') {
		close();
		if(isReply) {
			// 首评标记
			const preId = parentId || targetId;
			const index = commentData.value.list.findIndex(it => it.recommendCommentId===preId);
			const {children, show} = commentData.value.list[index];
			commentData.value.list[index].replyCount++;
			if(show) {
				children.list.push(data);
				children.total++;
			}
		} else {
			// 首评
			commentData.value.list.push(data);
			commentData.value.total++;
		}
	}
}
// 删除评论
const delComment = async(targetId='', parentId='') => {
	const {code} = await request(`${API.CircleCommentDel}?recommendCommentId=${targetId}`, {}, "DELETE");
	if(code==='') {
		// 操作的首次评论标记
		const preId = parentId || targetId;
		const index = commentData.value.list.findIndex(it => it.recommendCommentId === preId);
		if(parentId) {
			// 删某条回复评论
			const {children} = commentData.value.list[index];
			const childIndex = children.list.findIndex(it => it.recommendCommentId === targetId);
			children.list.splice(childIndex, 1);
			children.total--;
			commentData.value.list[index].replyCount--;
		} else {
			//  删首评
			commentData.value.list.splice(index, 1);
			commentData.value.total--;
		}
	}
}
// 点赞
const handleLike = async() => {
	const {code} = await request(API.CircleLike, {
		recommendId: recommendId.value,
		type: info.value.likeStatus?2:1
	}, "POST");
	if(code==='') getRecommendInfo();
}
// 计算回复时间
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
	if(h) return h+'小时前';
	return '刚刚';
}

// 分享
function shareCancel() {
  shareSpell.value.shareShow = false
}

function share() {
	const {fileUrl, remark} = info.value;
	console.log(remark, info)
	let title = remark.length>20?remark.slice(0, 20)+'...':remark;
	shareObj.value.url = `/pages_category_page2/circle/imgCircle?recommendId=${recommendId.value}`;
	shareObj.value.image = fileUrl[0];
	shareObj.value.title = title;
	shareSpell.value.shareShow = true;
}
onShow(()=>{
  // #ifdef MP-WEIXIN || MP-BAIDU || MP-TOUTIAO || MP-QQ
  let menuButtonInfo = uni.getMenuButtonBoundingClientRect()
  topHeight.value = menuButtonInfo.top
  height.value = menuButtonInfo.height
  // #endif
  // init();
})
</script>

<style lang="scss" scoped>
page {
	background: #F8F8F8;
}
.page-img-circle {
  background: #ffffff;
	.circle-top {
		display: flex;
		align-items: center;
		justify-content: space-between;
		width: 100%;
		position: fixed;
		z-index: 99;
		padding: 18rpx 32rpx 18rpx 24rpx;
		background: #ffffff;
		.l-p {
			display: flex;
			align-items: center;
			flex: 1;
			.back {
				width: 48rpx;
				height: 48rpx;
				margin-right: 16rpx;
			}
			.avatar {
				width: 64rpx;
				height: 64rpx;
				border-radius: 50%;
				margin-right: 16rpx;
			}
			.u-box {
				flex: 1;
				.text {
					color: #A9A9B2;
					font-size: 24rpx;
					&:first-child {
						color: #292929;
						font-size: 28rpx;
					}
				}
			}
		}
		.r-p {
			width: 118rpx;
			height: 52rpx;
			background: #292932;
			border-radius: 4rpx;
			font-size: 24rpx;
			text-align: center;
			line-height: 52rpx;
			color: #ffffff;
		}
	}

	// #ifdef APP-PLUS
	.circle-top {
		padding-top: 80rpx;
	}
	// #endif
	.info-box {
		padding-top: 100rpx;
		.circle-swiper {
			width:100%;
			position: relative;
			margin-bottom: 10rpx;
			background: #ffffff;
			.dot-box {
				width: 80rpx;
				height: 36rpx;
				font-size: 20rpx;
				line-height: 36rpx;
				text-align: center;
				color: #ffffff;
				background: rgba(41,41,50,0.2);
				border-radius: 18rpx;
				position: absolute;
				top: 700rpx;
				right: 24rpx;
			}
			.swiper {
				height: 750rpx;
				.circle-img {
					width: 750upx;
					height: 750upx;
				}
			}
			.img-tab {
				height: 96rpx;
				line-height: 96rpx;
				text-align: center;
				.img-tab-item {
					width: 44rpx;
					height: 44rpx;
					border-radius: 8rpx;
					border: 2rpx solid #F7F7F7;
					&.img-active {
						border: 2rpx solid #B24C49;
					}
				}
			}
		}
		.remark {
			padding: 24rpx 32rpx 32rpx;
			background: #ffffff;
			.remark-text {
				font-size: 28rpx;
				line-height: 33rpx;
				color: #292929;
				margin-bottom: 24rpx;
				word-break: break-word;
			}
			.tabs-nav{
				.ul{
					display: flex;
					.li{
						flex: 1 0 auto;
						display: flex;
						width: 348rpx;
						padding: 8rpx 36rpx 8rpx 8rpx;
						border-radius: 8rpx;
						border: 2rpx solid #F7F7F7;
						margin-right: 20rpx;
						.product-img {
							height: 80rpx;
							width: 80rpx;
						}
						.n-text {
							flex: 1;
							overflow: hidden;
							text-overflow: ellipsis;
							display: -webkit-box;
							-webkit-line-clamp: 2;
							-webkit-box-orient: vertical;
							word-break: break-all;
							font-size: 20rpx;
							color: #666666;
							padding-left: 8rpx;
						}
					}
				}
			}
		}
		.comment-list {
			padding: 24rpx 32rpx 160rpx;
			background: #FFFFFF;
			.title {
				color: #333333;
				font-size: 28rpx;
				position: relative;
				padding-bottom: 10rpx;
				margin-bottom:32rpx;
				&:after{
					content: '';
					width: 48rpx;
					height: 4rpx;
					background: #333333;
					position: absolute;
					left: 4rpx;
					bottom: 0;
				}
			}
			.list-box {
				.list-item {
					display: flex;
					align-items: flex-start;
					margin-bottom: 32rpx;
					.l-item {
						padding: 10rpx 0;
						width: 64rpx;
						.user-avatar {
							width: 64rpx;
							height: 64rpx;
							border-radius: 50%;
						}
					}
					.r-item {
						flex: 1;
						padding-left: 16rpx;
						position: relative;
						padding-bottom: 32rpx;
						border-bottom: 1rpx solid #F3F4F6;
						.time-reply {
							margin-bottom: 16rpx;
							text {
								font-size: 24rpx;
								display: inline-block;
								margin-right: 16rpx;
							}
							.time {
								color: #999999;
							}
							.reply {
								color: #666666;
							}
							.del {
								color: #F72F2F;
							}
						}
						.first-com {
							.name {
								font-size: 28rpx;
								color: #666666;
								margin-bottom: 8rpx;
							}
							.content {
								color: #333333;
								font-size: 28rpx;
								margin-bottom: 16rpx;
								word-break:break-word;
							}
						}
						.recommend-box {
							.recommend-item {
								display: flex;
								align-items: flex-start;
								margin-bottom: 16rpx;
								.child-avatar {
									width: 48rpx;
									height: 48rpx;
									border-radius: 50%;
								}
								.child-r-item {
									flex: 1;
									padding-left: 16rpx;
									.reply-content {
										word-break:break-word;
										font-size: 28rpx;
										margin-bottom: 16rpx;
										color: #333333;
										vertical-align: middle;
										text {
											color: #999999;
											margin-right: 10rpx;
										}
									}
								}
							}
						}
						.fun-list {
							text-align: center;
							.fun-text {
								color: #999999;
								font-size: 24rpx;
								display: inline-block;
								margin-right: 40rpx;
								.arrow {
									width:26rpx;
									height:26rpx;
									vertical-align: middle;
								}
							}
						}
					}
					&:last-child {
						.r-item {
							border-bottom: none;
						}
					}
				}
			}
		}
		.comment-btn {
			background: #FFFFFF;
			height: 154rpx;
			border-top: 1rpx solid #F3F4F6;
			position: fixed;
			bottom: 0;
			width:100%;
			.btn-cell {
				display: flex;
				padding: 32rpx;
				box-sizing: border-box;
				.input-btn {
					flex: 1;
					height: 88rpx;
					line-height: 88rpx;
					background: #F5F5F5;
					color: #999999;
					text-indent: 48rpx;
					font-size: 28rpx;
					margin-right:48rpx;
				}
				.icon-box {
					display: flex;
					width: 150rpx;
					.icon-item {
						flex: 1;
						&:first-child {
							margin-right: 48rpx;
						}
						.icon-img {
							width:48rpx;
							height:48rpx;
						}
						.count {
							color: #666666;
							font-size:24rpx;
							text-align: center;
						}
					}
				}
			}
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
