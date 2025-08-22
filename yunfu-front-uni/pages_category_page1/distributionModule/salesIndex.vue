<template>
	<view class="container">
    <view class="salesIndex-topBackImg">
			<view class="topStoreTag flex-row-plus">
				<view class="storeName overflow font-color-FFF">
          <image class="storeLogoImg" :src="item.shopLogo"></image>
					<label class=" fs24">{{item.shopName}}</label>
				</view>
			</view>
			<view class="flex-items flex-column">
				<image class="salesHeadImg" :src="SalesMainItem.headImage"></image>
				<view class="font-color-FFF fs36 mar-top-10">{{SalesMainItem.name}}</view>
				<view class="gradeText">{{item.levelName}}</view>
			</view>
      <view class="flex-items-plus awardTopInfo">
        <view class="flex-row-plus award-box flex-items flex-sp-around">
          <view class="flex-column-plus flex-items" @click="gototalAward">
            <label class="fs50">{{SalesMainItem.cumulative}}</label>
            <label class="fs26 award">累计奖励(元）</label>
          </view>
          <view class="flex-column-plus flex-items" @click="gounliquidated">
            <label class="fs50">{{SalesMainItem.unsettled}}</label>
            <label class="fs26 award">未结算奖励(元）</label>
          </view>
        </view>
      </view>
		</view>
		<view class="flex-items-plus awardInfo">
			<view class="flex-row-plus award-box flex-items flex-sp-around">
				<view class="flex-column-plus flex-items" @click="gototalClient">
					<label class="fs44 font-color-C5AA7B">{{SalesMainItem.users}}</label>
					<label class="fs24 font-color-333">累计客户(人）</label>
				</view>
				<view class="borRig-line-E5E5E5 lineRight" style="height: 44upx;"></view>
				<view class="flex-column-plus flex-items" @click="gototalPersonnel">
					<label class="fs44 font-color-C5AA7B">{{SalesMainItem.distributors}}</label>
					<label class="fs24 font-color-333">累计分销员(人）</label>
				</view>
			</view>
		</view>
		<view class="btnList">
			<view class="btnListBox flex-row-plus flex-items flex-sp-around">
				<view class="flex-column-plus flex-items"  @click="gopromotion(1)">
					<image class="salesIcon" :src="`${VUE_APP_STATIC_URL}static/images/salesStoreIcon.png`"></image>
					<label class="fs26 font-color-333">推广店铺</label>
				</view>
				<view class="flex-column-plus flex-items" @click="storeindex">
					<image class="salesIcon" :src="`${VUE_APP_STATIC_URL}static/images/salesOrderIcon.png`"></image>
					<label class="fs26 font-color-333">推广商品</label>
				</view>
				<view class="flex-column-plus flex-items" @click="godistributionOrder">
					<image class="salesIcon" :src="`${VUE_APP_STATIC_URL}static/images/extendGoodsIcon.png`"></image>
					<label class="fs26 font-color-333">分销订单</label>
				</view>
				<view class="flex-column-plus flex-items" @click="gopromotion(2)">
					<image class="salesIcon" :src="`${VUE_APP_STATIC_URL}static/images/inviteLowerIcon.png`"></image>
					<label class="fs26 font-color-333">邀请下级</label>
				</view>
			</view>
		</view>
	</view>
</template>

<script setup>
import { ref } from 'vue'
import { request } from '../../utils/request'
import API from "../../config/api";
import { onLoad } from "@dcloudio/uni-app";
import { VUE_APP_STATIC_URL } from "@/config/api";

const item = ref({})
const SalesMainItem = ref({}) // 页面信息数据

onLoad((options) => {
  item.value = JSON.parse(options.distributeInfo)
  uni.setStorageSync("salesId", item.distributorId)
  getSalesMainInfo()
})
/**
 * 获取页面信息数据
 * @returns {Promise<void>}
 */
const getSalesMainInfo = async () => {
  try {
    const res = await request(API.QuerySalesMainInfo, {
      distributorId: item.value.distributorId,
      shopId: item.value.shopId
    }, 'GET')
    uni.hideLoading()
    SalesMainItem.value = res.data
  } catch (err) {
    uni.hideLoading()
  }
}

/**
 * 跳转累计奖励
 */
const gototalAward = () => {
  uni.navigateTo({
    url: 'totalAward?shopId=' + item.value.shopId + '&distributorId=' + item.value.distributorId
  });
}

/**
 * 跳转未结算奖励
 */
const gounliquidated = () => {
  uni.navigateTo({
    url: 'unliquidated?shopId=' + item.value.shopId + '&distributorId=' + item.value.distributorId
  });
}

/**
 * 跳转累计客户
 */
const gototalClient = () => {
  uni.navigateTo({
    url: 'totalClient?shopId=' + item.value.shopId + '&distributorId=' + item.value.distributorId
  });
}

/**
 * 跳转累计分销员
 */
const gototalPersonnel = () => {
  uni.navigateTo({
    url: 'totalPersonnel?shopId=' + item.value.shopId + '&distributorId=' + item.value.distributorId
  });
}

/**
 * 推广店铺
 * @param promoteType 推广店铺 1 | 邀请下级 2
 */
const gopromotion = async (promoteType) => {
  // #ifdef APP-PLUS
  var system = 1
  // #endif

  // #ifdef H5
  var system = 3
  // #endif

  // #ifdef MP-WEIXIN
  var system = 2
  // #endif

  // #ifdef MP-ALIPAY
  var system = 4
  // #endif

  /* const res = {'data':'https://cereshop.oss-cn-shenzhen.aliyuncs.com/test/2021-06-10/64223b9f0eef41abbb5d4056b9a40e2a08441534-3cbe-47af-8134-fc74635e069f.png'}
  uni.hideLoading()
  uni.navigateTo({
    url: `../../pages_category_page1/distributionModule/shareProduct?shareImg=${res.data}&shopId=${this.item.shopId}`
  }); */
  try {
    const res = await request(API.shopGetSharePic, {
      type: promoteType,
      shopId: item.value.shopId,
      distributorId: item.value.distributorId,
      terminal: system
    }, 'GET')
    uni.hideLoading()
    uni.navigateTo({
      url: `../../pages_category_page1/distributionModule/shareProduct?shareType=1&shareImg=${res.data}&shopId=${item.value.shopId}&salesId=${item.value.distributorId}`
    });
  } catch (err) {
    uni.hideLoading()
  }
}

/**
 * 跳转推广商品
 */
const storeindex = () => {
  uni.navigateTo({
    url: 'commodity?shopId=' + item.value.shopId + '&distributorId=' + item.value.distributorId + '&headimg=' + SalesMainItem.value.headImage + '&username=' + SalesMainItem.value.name
  });
}
/**
 * 跳转分销订单
 */
const godistributionOrder = () => {
  uni.navigateTo({
    url: `distributionOrder?shopId=${item.value.shopId}&distributorId=${item.value.distributorId}`
  });
}
/**
 * 邀请下级
 */
const goinvite = () => {
  uni.navigateTo({
    url: 'invite?tenantCode=' + JSON.stringify(SalesMainItem.value) + '&shopId=' + item.value.shopId + '&distributorId=' + item.value.distributorId
  });
}
</script>

<style lang="scss">
	page {
		background-color: #F7F7F7;
	}

	.container {
		.salesIndex-topBackImg {
			width: 100%;
			background: #333333;
			padding-top: 10upx;
      position: relative;
			.topStoreTag {
				background: #717171;
				height: 50upx;
				width: 180upx;
				border-radius: 20rpx 0 0 20rpx;
        position: absolute;
        right: 0;
        top: 50rpx;
				.storeName {
          height: 50upx;
          display: flex;
          align-items: center;
          margin-left: 5rpx;
				}
				.storeLogoImg {
					width: 40upx;
					height: 40upx;
					border-radius: 50%;
          margin-right: 10rpx;
				}
			}

			.salesHeadImg {
				width: 100upx;
				height: 100upx;
				border-radius: 50%;
        border: 10rpx solid #717171;
			}

			.gradeText {
				font-size: 26rpx;
				color: #FFFFFF;
				font-weight: 400;
				line-height: 36rpx;
				text-align: center;
				margin-top: 15upx;
				padding: 5upx 10upx;
        opacity: 0.7;
			}
		}
    .awardTopInfo {
      .award-box {
        height: 158upx;
        width: 690upx;
        margin-top: 30upx;
        label {
          color: #FDEDD3;
        }
        .award {
          color: #8A734A;
          width: 222rpx;
          height: 78rpx;
          line-height: 78rpx;
          background: linear-gradient(90deg, #FDEDD3 0%, #EDDABA 100%);
          text-align: center;
          margin-bottom: 28rpx;
        }
        .salesIcon {
          width: 60upx;
          height: 56upx;
        }
      }
    }
    .awardInfo {
      .award-box {
        height: 158upx;
        width: 690upx;
        margin-top: 30upx;
        background: #FFFFFF;
        .salesIcon {
          width: 60upx;
          height: 56upx;
        }
      }
    }
    .btnList {
      display: flex;
      width: 100%;
      margin-top: 30upx;
      flex-flow: wrap;
      justify-content: center;
      .btnListBox {
        background: #FFFFFF;
        height: 196upx;
        width: 690upx;
      }
      .salesIcon {
        width: 90rpx;
        height: 90rpx;
      }
    }
	}
</style>
