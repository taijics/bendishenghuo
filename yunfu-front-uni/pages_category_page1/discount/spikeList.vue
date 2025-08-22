<template>
	<view class="spikeListBox">
<!--    <global-loading />-->
    <view v-if="!shopSeckillId" class="spike-top">
			<view class="spikeBg">
				<image :src="`${VUE_APP_STATIC_URL}static/images/spikelLogo.png`"></image>
			</view>
			<view class="tabs-nav-warp spikeNav">
				<scroll-view class="tabs-nav" scroll-x="true">
					<view class="ul">
						<view class="li" v-for="(item, index) in querySessionData" :key="index"
							:class="{active: index === active}" @click="changeTit(index, item)">
							<view class="timeItem">
								<view class="date" :class="{endCls: currentTime > item.endTime}">{{item.startTime}}</view>
								<view class="state fs24" v-if="currentTime > item.timestamp">抢购中</view>
								<view class="state" v-if="currentTime < item.timestamp">即将开始</view>
								<view class="state" v-if="currentTime > item.endTime">已结束</view>
							</view>
						</view>
					</view>
				</scroll-view>
			</view>
		</view>
		<view v-else class="shopStopTime spike-top">
			<view class="TimeBigBox" v-if="spikeLikeData.state === 1">
				<label>距离结束：</label>
				<view class="flex-row-plus fs34 flex-items-plus mar-top-10">
				  <view class="countdown-box flex-items-plus">{{ hou }}</view>
				  <view class="font-color-999">:</view>
				  <view class="countdown-box flex-items-plus">{{ min }}</view>
				  <view class="font-color-999">:</view>
				  <view class="countdown-box flex-items-plus">{{ sec }}</view>
				</view>
				<!-- <u-count-down :timestamp="spikeLikeData.time" fontSize="24rpx" separatorColor="#C83732"
				separatorSize="24rpx" bgColor="#C83732" color="#ffffff" height="200rpx"></u-count-down> -->
			</view>
			<view  v-else class="TimeBigBox">
				<label>距离开始：</label>
				<view class="flex-row-plus fs34 flex-items-plus mar-top-10">
				  <view class="countdown-box flex-items-plus">{{ hou }}</view>
				  <view class="font-color-999">:</view>
				  <view class="countdown-box flex-items-plus">{{ min }}</view>
				  <view class="font-color-999">:</view>
				  <view class="countdown-box flex-items-plus">{{ sec }}</view>
				</view>
				<!-- <u-count-down :timestamp="spikeLikeData.enableTime" fontSize="24rpx" separatorColor="#C83732"
				separatorSize="24rpx" bgColor="#C83732" color="#ffffff" height="200rpx"></u-count-down> -->
			</view>
		</view>
		<view class="spikeList mar-top-20 u-skeleton">
      <Skeleton
          el-color="#888888"
          bg-color="#333333"
          :loading="loading && isFirstComeIn"
          :animation="true"
      />
			<view class="listItem" v-for="(item,index) in spikeLikeList" :key="index">
				<view class="itemBox u-skeleton-rect">
					<image :src="item.productImage || item.image" class="pic-img default-img" />
				</view>
				<view class="itemInfo">
          <view class="u-skeleton-rect product-name">
            <p>{{ item.productName }}</p>
          </view>
					<view v-if="shopId" class="number u-skeleton-rect">限量件 {{item.discount}} / 剩余{{item.stockNumber}}件</view>
					<view v-else class="number u-skeleton-rect">限量件 {{item.discount}} / 剩余{{item.stockNumber}}件</view>
					<view class="originalPrice">
            <text class="u-skeleton-rect">原价: ¥{{item.originalPrice}}</text>
          </view>
					<view class="price">
						<view class="currentPrice flex-items font-color-FF7800 u-skeleton-rect">
							<view class="iconBox flex-items">
								<image :src="`${VUE_APP_STATIC_URL}static/images/spikeIcon.png`"></image>
							</view>
							<view class="flex-row-plus flex-items priceInfo">
								<label class="fs24">￥</label>
								<label class="fs36">{{item.price}}</label>
							</view>
						</view>
            <view class="u-skeleton-fillet btn-box">
              <view v-if="spikeLikeData.state === 1  || (platformSeckillList[platformIndex] && platformSeckillList[platformIndex].state === 3)"
                    class="snapUpBtn"
                    @click="gogoodsDetails(item.shopId,item.productId,item.skuId)">
                <view class="btnText">去抢购</view>
                <view class="progressBox">
                  <progress activeColor="#FFFFFF" :percent="getPercent(item.saleNumber||item.stockNumber, item.total)"
                            active stroke-width="5" />
                </view>
              </view>
              <view v-if="spikeLikeData.state === 0 || (platformSeckillList[platformIndex] && platformSeckillList[platformIndex].state === 2)"
                    class="snapUpBtn" :class="{btnStyle1: spikeLikeData.state === 0 || (platformSeckillList[platformIndex] && platformSeckillList[platformIndex].state === 2) }">
                <view class="btnText">即将开始</view>
                <view class="progressBox">
                  <progress activeColor="#FFFFFF" :percent="getPercent(item.saleNumber || item.stockNumber, item.total)"
                            active stroke-width="5" />
                </view>
              </view>
            </view>
						<!-- <view class="snapUpBtn" v-if="spikeLikeData.state === 0 || spikeLikeData.ifEnable === 2 || platformSeckillList[platformIndex].state===2" :class="{btnStyle1: spikeLikeData.state === 0 || spikeLikeData.ifEnable === 2 || platformSeckillList[platformIndex].state===2}">
							<view class="btnText">即将开始</view>
							<view class="progressBox">
								<progress activeColor="#FFFFFF" :percent="getPercent(item.saleNumber || item.stockNumber, item.total)"
									active stroke-width="5" />
							</view>
						</view> -->
					</view>
				</view>
			</view>
      <view
          v-if="ifEmpty"
          class="emptyOrder-box flex-items-plus flex-column"
      >
        <image
            class="emptyOrder-img"
            :src="`${VUE_APP_STATIC_URL}static/img/bgnull.png`"
        ></image>
        <label class="font-color-999 fs26 mar-top-30">暂无活动商品～</label>
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
      <!-- 回到顶部 -->
      <ReturnTop :returnTopFlag="returnTopFlag" />
		</view>
	</view>
</template>

<script setup>
import { ref, onBeforeUnmount } from "vue";
import { request } from "../../utils/request"
import API from "@/config/api";
import {onLoad, onShow, onReachBottom, onPageScroll} from "@dcloudio/uni-app";
import { VUE_APP_STATIC_URL } from "@/config/api";
import UCountDown from "../../uni_modules/vk-uview-ui/components/u-count-down/u-count-down";
import Skeleton from "../../components/Skeleton/index.vue";

const spikeLikeList = ref([{}, {}, {}, {}, {}, {}, {}, {}, {}]);
const spikeLikeData = ref({});
const page = ref(1);
const pageSize = ref(10);
const loadingType = ref(0);
const hou = ref("00");
const min = ref("00");
const sec = ref("00");
const timeOut = ref(undefined);
const shopId = ref(0);
const shopSeckillId = ref(0);
const type = ref(1); //价格
const volume = ref(1); //销量
const selectIndex = ref(0);
const list = ref([]);
const classList = ref([]);
const size = ref(10);
const nothing = ref(false);
const changeType = ref(0);
const querySessionData = ref([]);
const sessionPage = ref(1);
const sessionPageSize = ref(10);
const session = ref('');
const listData = ref([]);
const currentTime = ref('');
const active = ref(0);
const timestamp = ref(null);
const endTime = ref(null);
const platformSeckillId = ref(0);
const platformSeckillList = ref([]);
const platformIndex = ref(0);
const ticker = ref(null); //定时器
const topLeft = ref(0); // 无更多数据显示距离
const returnTopFlag = ref(false); // 返回顶部显示隐藏
const loading = ref(false);
const noMore = ref(false); // 没有更多数据显示隐藏
const isFirstComeIn = ref(true);
const total = ref(0); // 订单总数据
const ifEmpty = ref(false); // 是否为空

onLoad((options) => {
	console.log(options,'options有没有999')
	currentTime.value = new Date().getTime();
	console.log(currentTime.value, 'current')
	if (options.shopId && options.shopSeckillId) {
		shopId.value = options.shopId
		shopSeckillId.value = options.shopSeckillId
	} else {
		shopId.value = 0
		shopSeckillId.value = 0
	}
  page.value = 1
  pageSize.value = 10
  querySessionData.value = []
  spikeLikeList.value = [{}, {}, {}, {}, {}, {}, {}, {}, {}]
  if(!shopId.value){
    getQuerySession()
    getQueryPlatformSeckillData()
  } else {
    getShopSeckillList()
  }
})

onReachBottom(() => {
	if (noMore.value) {
		uni.stopPullDownRefresh()
	} else {
		if(shopId.value){
			page.value = page.value + 1
			getShopSeckillList()
		}
	}
})

onPageScroll(e => {
  returnTopFlag.value = e.scrollTop > 600;
  topLeft.value = e.scrollTop
})

onBeforeUnmount(() => {
	clearInterval(ticker.value)
	console.log('销毁前清楚定时器')
})

const changeTit = (index, item) => {
	if (active.value === index) {
		return false
	} else {
		active.value = index
		page.value = 1
		pageSize.value = 10
		session.value = item.time.substring(0, 16)
		spikeLikeList.value = []
		platformSeckillId.value = platformSeckillList.value[index].seckillId
		platformIndex.value = index
		getPlatformSeckillsData(index)
		timestamp.value = item.timestamp
		endTime.value = item.endTime
	}
}

/**
 * 查询秒杀列表
 */
const getQueryPlatformSeckillData = async () => {
	try {
		const res = await request(API.getQueryPlatformSeckillList,'GET')
		platformSeckillList.value = res.data
		platformSeckillId.value = res.data[0].seckillId
		getPlatformSeckillsData(0)
	} catch (err){
		uni.showToast({
			title:'失败',
			icon:'none'
		})
    throw new Error(err)
  }
}

/**
 * 平台首页根据seckillId查询对应的秒杀商品列表
 */
const getPlatformSeckillsData = async (index) => {
  loading.value = true
	// uni.showLoading()
	try {
		const res = await request(API.getPlatformSeckills,{ seckillId: platformSeckillId.value},'GET')
		uni.hideLoading()
    spikeLikeList.value = res.data[index].products.filter(item => JSON.stringify(item) !== '{}')
    if (spikeLikeList.value.length === 0) {
      ifEmpty.value = true
    }
    total.value = res.data[index].products.length
    if (spikeLikeList.value.length >= total.value) {
      noMore.value = true
    }
	} catch (err) {
		uni.hideLoading()
		uni.showToast({
			title:'失败',
			icon:'none'
		})
    throw new Error(err)
  } finally {
    loading.value = false
    isFirstComeIn.value = false
  }
}

/**
 * 平台秒杀头部时间
 */
const getQuerySession = async () => {
	try {
		const res = await request(API.querySession, {}, 'GET')
		let arr = []
		arr = res.data || []
    console.log(arr)
		arr.forEach(item => {
			let obj = {}
			obj["time"] = item
			let date = new Date(getCaption(item, 0).replace(/-/g, '/'))
			let endDate = new Date(getCaption(item, 1).replace(/-/g, '/'))
			obj["timestamp"] = date.getTime()
			obj["endTime"] = endDate.getTime()
			obj["startTime"] = item.substring(5, 16)
			console.log(obj)
			querySessionData.value.push(obj)
		})
		session.value = querySessionData.value[0]?.time.substring(0, 16)
		timestamp.value = querySessionData.value[0]?.timestamp
		endTime.value = querySessionData.value[0]?.endTime
	} catch (err) {
		uni.showToast({
			title: '失败',
			icon: "none"
		})
    throw new Error(err)
  }
}

/**
 * 时间处理
 */
const getCaption = (obj, state) => {
	var index = obj.lastIndexOf("\|");
	if (state == 0) {
		obj = obj.substring(0, index);
	} else {
		obj = obj.substring(index + 1, obj.length);
	}
	return obj;
}
/**
 * 跳转商品详情页
 */
const gogoodsDetails = (shopId, productId, skuId) => {
	uni.navigateTo({
		url: '../goodsModule/goodsDetails?shopId=' + shopId + '&productId=' + productId + '&skuId=' +
				skuId
	})
}

/**
 * 按钮进度条
 */
const getPercent = (num, total) => {
	num = parseFloat(num);
	total = parseFloat(total);
	if (isNaN(num) || isNaN(total)) {
		return "-";
	}
	return total <= 0 ? "0%" : Math.round((num / total) * 10000) / 100.0;
}


/**
 * 获取店铺更多秒杀
 */
const getShopSeckillList = async () => {
  loading.value = true
	let param = ''
	param = {
		page: page.value,
		pageSize: pageSize.value,
		shopId: shopId.value,
		shopSeckillId: shopSeckillId.value,
	}
	try {
		const res = await request(API.getShopSeckillIndex, param, 'GET')
		uni.hideLoading()
		spikeLikeData.value = res.data
		if (ticker.value) { //这一段是防止进入页面出去后再进来计时器重复启动
			clearInterval(ticker.value);
		}
		ticker.value = setInterval(()=>{
			if(spikeLikeData.value.time > 0){
				shopCountDown(spikeLikeData.value.time)
				spikeLikeData.value.time -= 1000
			}
			if(spikeLikeData.value.enableTime > 0){
				shopCountDown(spikeLikeData.value.enableTime)
				spikeLikeData.value.enableTime -= 1000
			}
		},1000)
    spikeLikeList.value = spikeLikeList.value.concat(res.data.page.list).filter(item => JSON.stringify(item) !== '{}')
    if (spikeLikeList.value.length === 0) {
      ifEmpty.value = true
    }
    total.value = res.data.page.total
    if (spikeLikeList.value.length >= total.value) {
      noMore.value = true
    }
	} catch (err) {
		uni.showToast({
			title: '失败',
			icon: "none"
		})
    throw new Error(err)
  } finally {
    loading.value = false
    isFirstComeIn.value = false
  }
}
/**
 * 处理店铺秒杀倒计时
 */
const shopCountDown = (timeAll) => {
	let msec = timeAll
	let hous = parseInt(msec / 3600000)
	let mins = parseInt((msec % 3600000) / 60000)
	let secs = parseInt(((msec % 3600000) % 60000) / 1000)
	if(hous < 10){
		hous = '0' + hous
	}
	if(mins < 10){
		mins = '0' + mins
	}
	if(secs < 10){
		secs = '0' + secs
	}
	hou.value = hous
	min.value = mins
	sec.value = secs
}
</script>
<style>
	page {
		background: #333333;
	}
</style>
<style lang="scss" scoped>
	page {
		background: #333333;
	}

	.spikeListBox {
		padding: 20rpx;
    .spike-top {
      position: relative;
      z-index: 997;
    }
        .shopStopTime{
					text-align: center;
					color: #FFFFFF;
					.TimeBigBox{
						display: flex;
						align-items: center;
						justify-content: center;
					}
					.countdown-box {
					    padding: 0 8rpx;
					    height: 48rpx;
					    color: #FFFFFF;
					    background: linear-gradient(90deg, #C83732 0%, #E25C44 100%);
					    margin: 10rpx;
				  }
				}
		.spikeBg {
			text-align: center;
			margin: 50rpx auto;

			image {
				width: 262rpx;
				height: 52rpx;
			}
		}

		.selected {
			color: #FE6F52;
		}

		.shopShowTypebox {
			height: 80rpx;
			background-color: #FFFFFF;
			z-index: 9999;
		}

		.countdown {
			display: flex;
			justify-content: center;
			height: 80upx;
			align-items: center;
			background: #F7F7F7;
			width: 100%;
			z-index: 999;

			.endDate {
				display: flex;
				align-items: center;
				margin-left: 20upx;

				span {
					min-width: 48upx;
					height: 36upx;
					padding: 0upx 8upx;
					background: linear-gradient(90deg, #C83732 0%, #E25C44 100%);
					box-shadow: 0rpx 6rpx 12rpx rgba(233, 0, 0, 0.3);
					display: block;
					font-size: 28rpx;
					color: #FFFFFF;
					text-align: center;
				}

				// #ifdef MP-ALIPAY
				span {
					height: min-48upx;
				}

				// #endif
				i {
					font-size: 28upx;
					color: #FF736C;
					font-style: normal;
					margin: 0 8upx;
				}
			}
		}

		.spikeList {
			.listItem {
				display: flex;
				padding: 20upx;
				margin-bottom: 20upx;
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
						line-height: 35upx;
						height: 70rpx;
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
            .btn-box {
              min-width: 160rpx;
              min-height: 84rpx;
            }
						.snapUpBtn {
							width: 160upx;
							height: 84upx;
							text-align: center;
							background: linear-gradient(90deg, #C83732 0%, #E25C44 100%);
							box-shadow: 0rpx 6rpx 12rpx rgba(233, 0, 0, 0.3);
							opacity: 1;
							border-radius: 10rpx;

							.progressBox {
								width: 82%;
								margin: 0 auto;
								border-radius: 10rpx;
								overflow: hidden
							}

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

						.btnStyle1 {
							background: linear-gradient(90deg, #29C790 0%, #75D98C 100%);
							box-shadow: 0 6rpx 12rpx rgba(52, 203, 144, 0.3);
						}

						.btnStyle2 {
							background: #999999;

							.btnText {
								opacity: 0.8;
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

		.tabs-nav {
			margin-top: 20rpx;

			.ul {
				white-space: nowrap;

				.li {
					display: inline-block;
					margin-left: 60rpx;
					font-size: 32rpx;
					color: #9499a8;
					position: relative;
					padding-bottom: 18rpx;

					.timeItem {
						text-align: center;

						.date {
							font-size: 24rpx;
							color: #FFFFFF;
							width: 150rpx;
							white-space: normal;
						}

						.state {
							font-size: 24rpx;
							color: #999999;
							display: inline-block;
						}

						.endCls {
							color: #999999;
						}
					}

					//&.on {
					//  color: #FFFFFF;
					//  &:after {
					//    content: '';
					//    width: 100%;
					//    height: 4rpx;
					//    position: absolute;
					//    left: 0;
					//    bottom: 0;
					//    background: #0F6AFB;
					//  }
					//  font-weight:bold;
					//}
				}

				.active {
					.timeItem {
						.date {
							color: #C83732;
							width: 150rpx;
							white-space: normal;
						}

						.state {
							display: inline-block;
							padding: 0 10rpx;
							color: #FFFFFF;
							background: #C83732;
						}
					}
				}
			}
		}
	}
</style>
<style scoped>
	.snapUpBtn /deep/ .uni-progress-bar {
		border-radius: 10rpx;
		height: 8rpx;
		background-color: #deabab !important;
	}

	.btnStyle1 /deep/ .uni-progress-bar {
		background-color: #ace8c5 !important;
	}

	.btnStyle2 /deep/ .uni-progress-bar {
		background-color: #cccccc !important;
	}

	.snapUpBtn /deep/ .uni-progress-inner-bar {
		border-radius: 10rpx;
	}

	.spikeNav /deep/ .tabs-nav {}
</style>
