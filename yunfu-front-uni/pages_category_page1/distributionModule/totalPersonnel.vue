<template>
	<view>
    <global-loading />
    <view class="totalClient-topBackImg flex-items flex-column">
      <view class="topBg">
        <view class="font-color-8A734A mar-top-30 fs60">{{SubordinateSalesData.total}}</view>
        <view class="font-color-C5AA7B">累计分销员(人）</view>
      </view>
		</view>
    <view class="content directAwardInfo">
      <view class="directAwardTit fs32 font-color-333">我的客户信息</view>
      <view class="flex-center clientList-box mar-top-30" v-for="(item, index) in SubordinateSalesDatalist"
            :key="index">
        <view class="directAward-box font-color-656 fs26" @click="arrowTypeChange(index)">
          <view class="directAward-icon flex-row-plus flex-items flex-sp-between">
            <view>
              <label class="orderId-box name font-color-333 fs28">分销员昵称：{{item.distributorName}}</label>
              <view class="flex-row-plus flex-items mar-top-30 flex-sp-between">
                <label class="orderId-box font-color-999">手机号：{{item.distributorPhone}}</label>
              </view>
            </view>
            <image v-if="item.ifOpen == false" class="arrow-down" :src="`${VUE_APP_STATIC_URL}static/images/arrowDownIcon.png`"></image>
            <image v-if="item.ifOpen == true" class="arrow-down" :src="`${VUE_APP_STATIC_URL}static/images/arrowUpIcon.png`"></image>
          </view>
          <view v-if="item.ifOpen == true">
            <view class="flex-row-plus flex-itdistributionOrderems mar-top-30 flex-sp-between">
              <label class="orderId-box font-color-999">累计下单数：{{item.orders}}</label>
              <label class="commission-box mar-left-70 font-color-999">累计分佣：¥{{item.price}}</label>
            </view>
          </view>
        </view>
      </view>
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
      <view v-if="ifEmpty" class="emptyCart-box flex-items-plus flex-column">
        <image class="emptyCart-img" :src="`${VUE_APP_STATIC_URL}static/img/bgnull.png`"></image>
        <label class="font-color-999 fs26 mar-top-30 font-color-999">这里空空如也~</label>
      </view>
    </view>
    <!-- 回到顶部 -->
    <ReturnTop :returnTopFlag="returnTopFlag" />
	</view>
</template>

<script setup>
import {ref} from "vue";
import { request } from '../../utils/request'
import API from "../../config/api";
import {onLoad, onPageScroll, onReachBottom} from "@dcloudio/uni-app";
import { VUE_APP_STATIC_URL } from "@/config/api";

const item = ref({})
const SubordinateSalesQuery = ref({
  model: {
    tenantCode: '',
  },
})
const topLeft = ref(0); // 无更多数据显示距离
const returnTopFlag = ref(false); // 返回顶部显示隐藏
const noMore = ref(false); // 没有更多数据显示隐藏
const SalesCustomerData = ref([]) // 累计客户数据
const ifEmpty = ref(false)
const SubordinateSalesData = ref([]) // 分销员数据
const shopId = ref(0)
const distributorId = ref(0)
const page = ref(1) // 当前页
const pageSize = ref(10) // 每页记录数
const loadingType = ref(0)
const SubordinateSalesDatalist = ref([]) // 我的客户信息列表

onLoad((options) => {
  shopId.value = options.shopId
  distributorId.value = options.distributorId
  getSubordinateSales()
})

onReachBottom(() => {
  if (noMore.value) {
    uni.stopPullDownRefresh()
  } else {
    pageSize.value = pageSize.value + 10
    getSubordinateSales()
  }
})

/**
 * 获取我的客户信息列表
 * @param shopId 店铺Id
 */
const getSubordinateSales = async () => {
  try {
    const res = await request(API.FindSubordinateSalesList, {
      shopId: shopId.value,
      distributorId: distributorId.value,
      page: page.value,
      pageSize: pageSize.value,
    }, 'GET')
    uni.hideLoading()
    SubordinateSalesDatalist.value = res.data.list
    SubordinateSalesData.value = res.data
    if (SubordinateSalesDatalist.value.length === 0) {
      ifEmpty.value = true
    }
    if (SubordinateSalesDatalist.value.length >= res.data.total) {
      noMore.value = true
    }
  } catch (err) {
    uni.hideLoading()
  }
}
/**
 * 展开当前客户信息数据
 * @param arrowTypeId 当前索引
 */
const arrowTypeChange = (arrowTypeId) => {
  SubordinateSalesData.value.list[arrowTypeId].ifOpen = SubordinateSalesData.value.list[arrowTypeId].ifOpen == false ? true : false
}
onPageScroll(e => {
  returnTopFlag.value = e.scrollTop > 600;
  topLeft.value = e.scrollTop
})
</script>

<style lang="scss">
@import "../../style/images";
page {
  background: #333333;
}
	.emptyCart-box {
		margin-top: 300rpx;

		.emptyCart-img {
			width: 216rpx;
			height: 156rpx;
		}
	}

	.totalClient-topBackImg {
		width: 100%;
    padding: 0 20rpx;
    .topBg {
      width: 100%;
      height: 196rpx;
      background: $totalPersonnelTopBackImg no-repeat;
      margin-top: 50rpx;
      text-align: center;
      background-size: contain;
    }
		.content {
			width: 690rpx;
			background-color: #FFFFFF;
			.totalClient-left {
				width: 170rpx;
				height: 20rpx;
			}

			.massage-text {
				padding: 0 20rpx;
			}
		}
	}

	.top {
		height: 50rpx;
		background-image: linear-gradient(#FF8E14, #FFFFFF);
	}
.directAwardInfo {
  width: 100%;
  height: 100vh;
  background: #F8F8F8;
  padding: 0 20rpx;
  .directAwardTit {
    height: 88rpx;
    line-height: 88rpx;
    font-size: 32rpx;
    color: #333333;
    text-align: center;
    padding-bottom: 20rpx;
    border-bottom: 2rpx solid #EEEEEE;
    font-weight: bold;
  }
}
	.uni-collapse-cell[data-v-8f47561c] {
		-webkit-box-orient: vertical;
		-webkit-box-direction: normal;
		-webkit-flex-direction: column;
		flex-direction: column;
		border-color: #c8c7cc;
		border-bottom-width: 1px;
		border-bottom-style: none;
	}

	.directAward-box {
		width: 100%;
		display: flex;
		justify-content: flex-start;
		flex-direction: column;
		background-color: #FFFFFF;
		padding: 50rpx 20rpx;
		.orderId-box {
			width: 320rpx;
			display: flex;
			justify-content: flex-start;
			flex-direction: row;
		}
    label.name {
      font-weight: bold;
    }
		.commission-box {
      text-align: right;
		}

		.arrow-down {
			width: 24rpx;
			height: 24rpx;
		}

		.upBox {
			border-top: 1rpx solid #EDEDED;
			margin-top: 30rpx;
		}
	}
</style>
