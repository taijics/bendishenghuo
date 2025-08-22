<!-- 售后列表 -->
<template>
	<view class="u-skeleton">
    <Skeleton
        el-color="#efefef"
        bg-color="#fff"
        :loading="loading && isFirstComeIn"
        :animation="true"
    ></Skeleton>
    <view class="content">
			<view class="order-list-box">
				<view>
					<view class="item" v-for="item in FindReturnDatalist">
						<view class="order-list-top">
							<view class="top-l u-skeleton-rect" @click="goShop(item.shopId)">
								<image :src="item.shopLogo" class="shop-img"></image>
								<text class="shop-name">{{item.shopName}}</text>
								<image :src="`${VUE_APP_STATIC_URL}static/images/arrowRight.png`" class="arrow-img"></image>
							</view>
							<view class="top-r">
								<image :src="`${VUE_APP_STATIC_URL}static/images/afterSaleTuikuan.png`" class="order-status-img u-skeleton-rect"></image>
								<text class="order-status u-skeleton-rect">{{item.afterType==1?'退款':'退货'}}</text>
							</view>
						</view>
						<view class="order-info-box" v-for="(itemlist,index) in item.skus" :key="index">
							<view class="order-info" @click="goodsDetails(item.shopId,itemlist.productId,itemlist.skuId)">
								<view class="order-info-item">
									<image :src="itemlist.image" class="product-img u-skeleton-rect"></image>
									<view class="info-box">
										<text class="product-name u-skeleton-rect">{{itemlist.productName}}</text>
										<view class="product-sku">
                      <text class="u-skeleton-rect">{{itemlist.value}}</text>
                    </view>
										<view class="price-sku-box">
											<text class="product-price u-skeleton-rect">退款：<text class="fuhao">￥{{itemlist.total}}</text></text>
										</view>
									</view>
								</view>
							</view>
						</view>
						<view class="total-price-box u-skeleton-rect">
							<!-- 退款 -->
							<view v-if='item.afterType==1'>
								<text class="total-price-l" v-if="item.afterState == 1">审核中</text>
								<text class="total-price-l" v-if="item.afterState == 2">退款中</text>
								<text class="total-price-l" v-if="item.afterState == 4">退款完成</text>
								<text class="total-price-l" v-if="item.afterState == 5">退款失败</text>
								<text class="total-price-l" v-if="item.afterState == 6">审核不通过</text>
								<text class="total-price-l" v-if="item.afterState == 7">评审中</text>
								<text class="total-price-l" v-if="item.afterState == 9">撤销申请</text>
								<text class="total-price-l" v-if="item.afterState == 10">审核通过</text>
							</view>
							<!-- 退货 -->
							<view v-if='item.afterType==2'>
								<text class="total-price-l" v-if="item.afterState == 1">退货审核中</text>
								<text class="total-price-l" v-if="item.afterState == 3">退货中</text>
								<text class="total-price-l" v-if="item.afterState == 4">已退款</text>
								<text class="total-price-l" v-if="item.afterState == 2">退款中</text>
								<text class="total-price-l" v-if="item.afterState == 5">退款失败</text>
								<text class="total-price-l" v-if="item.afterState == 6">审核不通过</text>
								<text class="total-price-l" v-if="item.afterState == 7">评审中</text>
								<text class="total-price-l" v-if="item.afterState == 8">退货完成，拒绝退款</text>
								<text class="total-price-l" v-if="item.afterState == 9">撤销申请</text>
								<text class="total-price-l" v-if="item.afterState == 10">审核通过</text>
							</view>
							<text class="total-price-r mar-left-30 u-skeleton-rect" v-if="item.afterState != 0 || item.afterState != 6">退款金额 ¥ {{item.price}}</text>
						</view>
						<!-- 退款 -->
            <view class="order-btn-box">
              <text class="u-skeleton-rect btn l" @click="deleteRecord(item)">删除记录</text>
						  <view v-if='item.afterType==1'>
						  	<text class="u-skeleton-rect btn l" v-if="(item.afterType==1 && item.afterState == 1 || item.returnType==2 && item.afterState == 6)" @click="cancelRefundTap(item)">撤销退款</text>
						  </view>
						  <!-- 退货 -->
						  <view v-if='item.afterType==2'>
						  	<text class="u-skeleton-rect btn l" v-if="(item.afterType==2 && item.afterState == 1 || item.afterType==2 && item.afterState == 10 || item.afterState == 6)" @click="cancelRefundTaphuo(item)">撤销退货</text>
						  </view>
              <text class="u-skeleton-rect btn viewDetail l" @click="gotoDetails(item)">查看详情</text>
            </view>
					</view>
				</view>
				<view v-if="ifEmpty" class="emptyCart-box flex-items-plus flex-column">
					<image class="emptyCart-img" :src="`${VUE_APP_STATIC_URL}static/img/bgnull.png`"></image>
					<label class="font-color-999 fs26 mar-top-30">暂无售后记录~</label>
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
    <!-- 优惠券领取 -->
    <tui-modal :show="delRecord" :custom="true" :fadein="true">
      <view class="Put-box1">
        <view class="text-align fs34 fs-bold">
          是否删除此记录
        </view>
        <view class="flex-display flex-sp-between">
          <view class="btn" @click="delRecord = false">
            取消
          </view>
          <view class="btn submit" @click="delRecordFn">
            确定
          </view>
        </view>
      </view>
    </tui-modal>
    <!-- 回到顶部 -->
    <ReturnTop :returnTopFlag="returnTopFlag" />
	</view>
</template>

<script setup>
import { ref } from "vue"
import tuiModal from "@/components/modal/modal"
import { request } from '../../utils/request'
import API from '../../config/api'
import {onLoad, onUnload, onBackPress, onReachBottom, onPageScroll} from "@dcloudio/uni-app"
import Skeleton from "@/components/Skeleton/index.vue";
import { VUE_APP_STATIC_URL } from "@/config/api";

const loading = ref(false);
const isFirstComeIn = ref(true);
const topLeft = ref(0); // 无更多数据显示距离
const returnTopFlag = ref(false); // 返回顶部显示隐藏
const noMore = ref(false); // 没有更多数据显示隐藏
const FindReturnData = ref([])
const sellPriceitem = ref('')
const FindReturnDatalist = ref([{skus:[{}]}, {skus:[{}]}, {skus:[{}]}, {skus:[{}]}, {skus:[{}]}, {skus:[{}]}])
const page = ref(1)
const pageSize = ref(10); // 每页记录
const loadingType = ref(0)
const delRecord = ref(false)
const currentAfterId = ref('')
const ifEmpty = ref(false)
const listTotal = ref(0)

onLoad(() => {
	getFindReturn()
})

// onUnload(() => {
// 	back()
// })

onBackPress((e) => {
	if (e.from === 'navigateBack') {
		return false;
	}
	back();
	return true;
})
onUnload(() => {
	// #ifdef MP-WEIXIN
	back()
	// #endif
})

onReachBottom(() => {
	if(noMore.value){
		uni.stopPullDownRefresh()
	}else{
		page.value = page.value + 1
		getFindReturn()
	}
})

const goodsDetails = (shopId,productId,skuId) => {
	console.log(shopId, '-', productId, '-', skuId)
	uni.navigateTo({
		url:'../../pages_category_page1/goodsModule/goodsDetails?shopId='+shopId + '&productId='+productId +'&skuId='+skuId
	})
}

const goShop = (shopId) => {
	uni.navigateTo({
		url: '../store/index?storeId=' + shopId
	})
}

const back = () => {
	uni.switchTab({
		url:'../../pages/tabbar/user/index'
	})
}

/**
 * 获取售后列表数据
 * @returns {Promise<void>}
 */
const getFindReturn = async () => {
  loading.value = true
	try {
		const res = await request(API.FindReturnList, {
			page: page.value,
			pageSize: pageSize.value,
		}, 'GET')
		if(res.data.list.length == 0){
			loadingType.value = 1
			page.value = page.value
		}
    listTotal.value = res.data.total
		// FindReturnDatalist.value = FindReturnDatalist.value.concat(res.data.list)
    // FindReturnDatalist.value = FindReturnDatalist.value.filter(item => JSON.stringify(item) !== '{skus:[{}]}')

    FindReturnDatalist.value = FindReturnDatalist.value.concat(res.data.list).filter(item => JSON.stringify(item) !== '{"skus":[{}]}')
		if (FindReturnDatalist.value.length === 0) {
			ifEmpty.value = true
		}
		FindReturnData.value = res.data
    if (FindReturnDatalist.value.length >= listTotal.value) {
      noMore.value = true
    }
	} catch (err) {
	} finally {
    loading.value = false
    isFirstComeIn.value = false
  }
}

/**
 * 删除记录
 */
const deleteRecord = (item) => {
	currentAfterId.value = item.afterId
	delRecord.value = true
}
const delRecordFn = async () => {
	delRecord.value = false
	try {
		const res = await request(API.deleteAfter, {
			id: currentAfterId.value
		}, 'POST', false)
		uni.showToast({
			title:'删除成功',
			icon:'none',
			duration:1500
		})
		currentAfterId.value = ''
		setTimeout(() => {
			page.value = 1
			FindReturnDatalist.value = []
      isFirstComeIn.value = true
			getFindReturn()
		}, 2000)
	} catch (err) {
	}
}
/**
 * 撤销申请
 */
const cancelRefundTap = (item) => {
	Delete(item)
}

// 退款
const Delete = async (item) => {
	try {
		const res = await request(API.CancelRefund, {
			afterId:item.afterId,
			orderId:item.orderId
		}, 'POST', false)
		uni.showToast({
			title:'撤销成功',
			icon:'none',
			duration:2000
		})
		setTimeout(() => {
			page.value = 1
			FindReturnDatalist.value = []
      isFirstComeIn.value = true
			getFindReturn()
		}, 2500);
	} catch (err) {
	}
}

/**
 * 撤销退货
 */
const cancelRefundTaphuo = (item) => {
	Deletehuo(item)
}
/**
 * 退货
 * @param item
 * @constructor
 */
const Deletehuo = async (item) => {
	try {
		const res = await request(API.CancelReturnGoods, {
			afterId:item.afterId,
			orderId:item.orderId
		}, 'POST')
		uni.showToast({
			title:'撤销成功',
			icon:'none',
			duration:2000
		})
		setTimeout(() => {
			page.value = 1
			FindReturnDatalist.value = []
			getFindReturn()
		}, 2500)
	} catch (err) {
	}
}

// 退款查看详情
const gotoDetails = (item) => {
	uni.navigateTo({
		url:'refundDetails?item=' + JSON.stringify(item)
	})
}

// 退货查看详情
const gotoDetailshuo = (item) => {
	uni.navigateTo({
		url:'returnDetails?item=' + JSON.stringify(item)
	})
}
onPageScroll(e => {
  returnTopFlag.value = e.scrollTop > 600;
  topLeft.value = e.scrollTop
})
</script>

<style lang="scss" scoped>
	page {
		background-color: #F7F7F7;
	}
  .Put-box1 {
    .btn {
      text-align: center;
      margin-top: 40rpx;
      border: 2rpx solid #333333;
      height: 80upx;
      line-height: 80upx;
      width: 100%;
      color: #333333;
    }
    .submit {
      background-color: #333333;
      color: #FFEBC4;
      margin-left: 20rpx;
    }
  }
	.emptyCart-box {
		margin-top: 70upx;

		.emptyCart-img {
			margin-top: 45%;
			width: 113upx;
			height: 98upx;
		}
	}

	.order-list-box {
		padding: 20upx 30upx 0;
		box-sizing: border-box;
	}

	.order-list-box .item {
    min-height: 500rpx;
		margin-bottom: 20upx;
		background: #fff;
		border-radius: 10upx;
	}

	.order-list-top {
		height: 96upx;
		padding: 0 30upx;
		box-sizing: border-box;
		display: flex;
		flex-direction: row;
		align-items: center;
		justify-content: space-between;
		border-bottom: 1px solid #eee;
	}

	.top-l {
		display: flex;
		flex-direction: row;
		align-items: center;
    min-width: 180rpx;
    min-height: 44rpx;
	}

	.shop-img {
		width: 36upx;
		height: 36upx;
		margin-right: 10upx;
	}

	.shop-name {
		font-size: 30upx;
		color: #333;
		font-weight: bold;
	}

	.arrow-img {
		margin-left: 15upx;
		width: 24upx;
		height: 24upx;
	}

	.top-r {
		display: flex;
		flex-direction: row;
		align-items: center;
	}

	.order-status-img {
		width: 50rpx;
		height: 50rpx;
		margin-right: 8upx;
	}

	.order-status {
		font-size: 32rpx;
		color: #C5AA7B;
	}

	.order-info-box {
		padding: 0 30upx;
		box-sizing: border-box;
	}

	.order-info {}

	.order-info-item {
		display: flex;
		flex-direction: row;
		padding: 20upx 0;
	}

	.product-img {
		width: 180upx;
		height: 180upx;
		border-radius: 10upx;
		margin-right: 30upx;
	}

	.info-box {
		flex: 1;
		display: flex;
		flex-direction: column;
		justify-content: space-between;
	}

	.product-name {
		font-size: 26upx;
		color: #333;
		height: 68upx;
		line-height: 34upx;
		display: -webkit-box;
		overflow: hidden;
		text-overflow: ellipsis;
		word-break: break-all;
		-webkit-box-orient: vertical;
		-webkit-line-clamp: 2;
	}

	.price-sku-box {
		display: flex;
		flex-direction: row;
		justify-content: space-between;
	}

	.product-sku {
		font-size: 24upx;
		color: #999;
    text {
      display: inline-block;
      min-height: 38rpx;
      min-width: 120rpx;
    }
	}

	.product-price {
		font-size: 28upx;
		color: #333;
		font-weight: 400;
    min-height: 50rpx;
    min-width: 280rpx;
	}

	.product-price .fuhao {
		font-size: 32upx;
    color: #C83732;
    font-weight: bold;
	}

	.product-num {
		font-size: 28upx;
		color: #999;
	}

	.total-price-box {
		font-size: 26upx;
		color: #333;
    border: 2rpx solid #E4E5E6;
		display: flex;
		flex-direction: row;
		align-items: center;
		height: 70upx;
		line-height: 70upx;
    margin: 0 30rpx;
	}

	.total-price-l {
		width: 170upx;
		margin-left: 40upx;
		font-size: 30upx;
		color: #333;
	}

	.total-price-r {
		text-align: left;
	}

	.order-btn-box {
		padding: 30upx;
		display: flex;
		flex-direction: row;
		justify-content: flex-end;
	}

	.order-btn-box .btn {
		display: inline-block;
		width: 140upx;
		height: 58upx;
		text-align: center;
		line-height: 58upx;
		font-size: 26upx;
		color: #333;
		margin-left: 20upx;
	}

	.order-btn-box .btn.l {
		color: #333;
    border: 2rpx solid #333333;
	}
  .order-btn-box .viewDetail {
    background: #333333;
    border: none;
    color: #FFEBC4 !important;
  }
	/* .order-btn-box .btn.r {
  border: 1px solid #ff7911;
  color: #ff7911;
} */
</style>
