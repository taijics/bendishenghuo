<template>
	<view class="circle-page u-skeleton">
		<u-sticky offset-top="0" h5-nav-height="0" bg-color="#fff">
			<view class="tabs-nav-warp">
			  <scroll-view class="tabs-nav" scroll-x="true">
			    <view class="ul">
			      <view
					class="li"
					:class="{'on':circleData.categoryId===item.recommendTypeId}"
					v-for="item in categoryList"
					:key="item.recommendTypeId"
					@click="tabChange(item.recommendTypeId)"
				>
			        {{item.name}}
			      </view>
			    </view>
			  </scroll-view>
			</view>
		</u-sticky>
    <Skeleton
        el-color="#efefef"
        bg-color="#fff"
        :loading="loading && isFirstComeIn"
        :animation="true"
    />
		<view class="circle-list">
			<view class="list-box" v-for="it in cirCleList" :key="it.type">
				<view
					class="circle-item"
					v-for="item in it.list"
				>
					<view class="img-box u-skeleton-fillet" @click.stop="jumpTo(item, 'info')">
            <img class="item-img" :src="item.fileUrl || item.cover">
						<img
							v-if="item.fileType===2"
							class="play-icon"
							:src="`${VUE_APP_STATIC_URL}static/img/circle/play.png`"
						/>
					</view>
					<view class="t-box">
						<view class="t-title u-skeleton-rect" @click.stop="jumpTo(item, 'info')">{{item.remark}}</view>
						<view class="b-box">
							<view class="l-p u-skeleton-rect" @click.stop="jumpTo(item, 'shop')">
								<img class="shop-img" v-if="item.avatar" :src="item.avatar"/>
								<text>{{item.name}}</text>
							</view>
							<view class="r-p u-skeleton-rect">
								<image
									:src="`${VUE_APP_STATIC_URL}static/img/circle/like${item.likeStatus?'_active':''}.png`"
                  v-if="item.likeStatus >= 0"
									class="icon-img"
									@click="handleLike(item)"/>
								<text>{{item.likeCount}}</text>
							</view>
						</view>
					</view>
				</view>
			</view>
		</view>
    <slide-loading />
		<view class="reachBottom"  v-if="topLeft > 400 && circleData.total !== 0 && circleData.list.length >= circleData.total">
			<image class="reach-icon"
		        :src="`${VUE_APP_STATIC_URL}static/img/reachBottom.png`"
		        mode="widthFix">
		  </image>
		  <text class="reach-text">这里到底了哦~~</text>
		</view>
		<view v-if="isShow" class="emptyCart-box flex-items-plus flex-column">
		    <image class="emptyCart-img" :src="`${VUE_APP_STATIC_URL}static/img/bgnull.png`" mode="widthFix" />
		    <label class="font-color-999 fs26 mar-top-30">这里空空如也~</label>
		</view>
	</view>
</template>

<script setup>
import {ref, onMounted, toRefs, watch} from 'vue';
import { onLoad, onReachBottom, onShow, onPageScroll, onTabItemTap} from "@dcloudio/uni-app";
import API from "@/config/api";
import {request} from "@/utils/request"
import { VUE_APP_STATIC_URL } from "@/config/api";
import Skeleton from "@/components/Skeleton/index.vue";

const isFirstComeIn = ref(true)
const loading = ref(false)
const topHeight = ref(0)
const height = ref(0)
const topLeft = ref(0)
const isShow = ref(false);
const categoryList = ref([]);
const defaultCircle = {
	list: [],
	total: 0,
	categoryId: ''
}
const cirCleList = ref([
  {type: 'left', list: [{}, {}, {}, {}, {}, {}, {}]},
  {type: 'right', list: [{}, {}, {}, {}, {}, {}, {}]}
])
const circleData = ref({...defaultCircle});
const defaultPage = {
	page: 1,
	pageSize: 20
}
const pageInfo = ref({...defaultPage});
const tabClick = ref(false);

onTabItemTap(() => {
	if(tabClick.value) {
		init();
		uni.pageScrollTo({
		  scrollTop:0
		})
	}
	tabClick.value = true;
	setTimeout(() => {
		tabClick.value = false;
	}, 500)
})

const init = async() => {
	circleData.value =  {...defaultCircle};
	pageInfo.value = {...defaultPage};
  isShow.value = false
	const {code, data} = await request(API.CircleCategory, {}, 'GET');
	if(code==='', data) {
		categoryList.value = [
			{recommendTypeId: '', name: '推荐'},
			{recommendTypeId: '0', name: '关注'},
			...(data || [])
		];
		getCircle();
	}
}

// 圈子列表
const getCircle = async() => {
	if (circleData.value.total!=0&&circleData.value.list.length>=circleData.value.total){
	  return
	}
  loading.value = true
	const {code, data} = await await request(API.CirclePage, {
		...pageInfo.value,
		recommendType: circleData.value.categoryId
	}, 'GET');
	if(code==='') {
		let tData = data.list || [];
		tData.forEach(it => {
			it.fileUrl = it.fileUrl.split(',')[0];
			if(it.fileType===2) it.fileUrl = it.cover;
		})
		const list  = [...circleData.value.list, ...tData];
		let rList = [];
		let lList = [];
		list.forEach((it, i) => {
			if (i % 2 === 0) {
			    lList.push(it);
			  } else {
			    rList.push(it);
			  }
		})
		circleData.value = {
			...circleData.value,
			list: [...circleData.value.list, ...tData],
			total: data.total,
			lList,
			rList
		}
		cirCleList.value = [
			{type: 'left', list: lList},
			{type: 'right', list: rList}
		]
		if(circleData.value.list.length===0) isShow.value = true;
    loading.value = false
    isFirstComeIn.value = false
	}
}

// 切换分类
function tabChange(categoryId='') {
  isFirstComeIn.value = true
  loading.value = true
  cirCleList.value = []
	isShow.value = false;
	topLeft.value = 0;
  pageInfo.value.page = 1;
	circleData.value =  {...defaultCircle, categoryId, list: []};
	getCircle();

};

//跳转店铺动态主页、图文或视频详情
function jumpTo(item, type) {
	let url = '';
	if(type==='shop') {
    url = `/pages_category_page2/circle/shopCircle?recommendId=${item.recommendId}&shopId=${item.shopId}`;
  }
	if(type==='info') {
		url = `/pages_category_page2/circle/${item.fileType===1?'img':'video'}Circle?recommendId=${item.recommendId}`;
	}
	uni.navigateTo({url});
}

// 点赞
const handleLike = async(item) => {
	const {recommendId, likeStatus} = item;
	const {code} = await request(API.CircleLike, {
		recommendId,
		type: likeStatus?2:1
	}, "POST");
	if(code==='') {
		circleData.value.list.forEach(it => {
			if(it.recommendId===recommendId) {
				it.likeStatus = likeStatus?0:1;
				likeStatus?it.likeCount--:it.likeCount++;
			}
		})
	}
}


onLoad(()=>{
  isFirstComeIn.value = true
  init();
})

onShow(()=>{
  // #ifdef MP-WEIXIN || MP-BAIDU || MP-TOUTIAO || MP-QQ
  let menuButtonInfo = uni.getMenuButtonBoundingClientRect()
  topHeight.value = menuButtonInfo.top
  height.value = menuButtonInfo.height
  // #endif
})

onPageScroll((e)=>{
  topLeft.value = e.scrollTop
})

onReachBottom(() => {
  if (circleData.value.total !== 0 && circleData.value.list.length < circleData.value.total) {
    pageInfo.value.page++;
    getCircle();
  }
})
</script>

<style lang="scss" scoped>
page {
	background: #fff;
}
.circle-page {
	.tabs-nav-warp{
		background: #fff;
		padding:0 30rpx;
    min-height: 62rpx;
    width: 100%;
    position: relative;
    z-index: 99999;
		.tabs-nav{
			.ul{
				display: flex;
				.li{
					flex: 1 0 auto;
					margin-left: 36rpx;
					font-size: 30rpx;
					color: #999999;
					position: relative;
					padding-bottom: 18rpx;
          text-align: center;
					&:first-child{
					  margin-left: 0;
					}
					&.on{
					  &:after{
						content: '';
						width: 100%;
						height: 4rpx;
						background: #333333;
						position: absolute;
						left: 0;
						bottom: 0;
					  }
					  color: #333333;
					  font-weight:bold;
					}
				}
			}
		}
	}
	.circle-list {
		padding: 12rpx 20rpx;
		overflow: hidden;
		/* column-count: 2;
		column-gap: 14rpx; */
		display: flex;
		.list-box {
			display:flex;
			width: calc(50% - 7rpx);
			flex-direction:column;
			align-items:flex-start;
			&:first-child {
				margin-right: 14rpx;
			}
		}
		.circle-item {
			/* -moz-page-break-inside:avoid;
			-webkit-column-break-inside:avoid;
			break-inside:avoid; */
			background: #FFFFFF;
			border-radius: 8rpx;
      width: 100%;
			min-height: 300rpx;
			break-inside: avoid; // 不被截断
			margin-bottom: 14rpx;
			.img-box {
        width: 100%;
				height: 348rpx;
				position: relative;
        text-align: center;
				.item-img {
          background-color: #f3f3f3;
					height: 100%;
					max-width: 100%;
					border-radius: 8rpx 8rpx 0 0;
				}
				.play-icon {
					position: absolute;
					width: 48rpx;
					height: 48rpx;
					top: 150rpx;
					left: calc(50% - 24rpx);
				}
			}
			.video {
				border-radius: 8rpx 8rpx 0 0;
				height: 348rpx;
				width: 100%;
				// max-width: 100%;
			}
			.t-box {
				padding: 20rpx;
				.t-title {
					font-size: 28rpx;
					color: #333333;
					margin-bottom: 16rpx;
					overflow: hidden;
					text-overflow: ellipsis;
					display: -webkit-box;
					-webkit-line-clamp: 2;
					-webkit-box-orient: vertical;
					word-break: break-all;
          min-width: 100rpx;
          min-height: 40rpx;
				}
			}
			.b-box {
				display: flex;
				justify-content: space-between;
				align-items: center;
				text {
          min-height: 34rpx;
          min-width: 100rpx;
					font-size: 24rpx;
					color: #666666;
				}
				.l-p {
          min-width: 160rpx;
          min-height: 50rpx;
					.shop-img {
						width: 48rpx;
						height: 48rpx;
						border-radius: 50%;
						vertical-align: middle;
						margin-right: 8rpx;
					}
				}
				.r-p {
          min-height: 50rpx;
          min-width: 50rpx;
					.icon-img {
						width: 32rpx;
						height: 32rpx;
						margin-right: 8rpx;
						vertical-align: middle;
					}
				}
			}
		}
	}
	// 触底样式
	.reachBottom {
		margin-top: 30rpx;
		display: flex;
		flex-direction: column;
		align-items: center;
		.reach-icon {
			width: 150rpx;
			height: 150rpx;
		}

		.reach-text {
			margin: 20rpx 0;
			color: #CCCCCC;
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
