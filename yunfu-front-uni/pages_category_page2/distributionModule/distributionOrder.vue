<template>
	<view>
    <global-loading />
    <view v-if="FindMySalesData.total>0">
			<view  class="flex-center clientList-box" v-for="(item, index) in FindMySalesDatalist" :key="index">
				<view class="directAward-box font-color-656 fs26">
					<view class="directAward-icon flex-row-plus flex-items flex-sp-between" @click="arrowTypeChange(index)">
						<view class="flex-column-plus font-color-333 fs30">
							<label class="orderId-box">订单号：{{item.orderId}}</label>
							<view class="orderId-box mar-top-20">
								佣金：<label class="font-color-C5AA7B">¥{{item.commission}}</label>
							</view>
						</view>
            <view>
              <image v-if="item.ifOpen  == false" class="arrow-down" :src="`${VUE_APP_STATIC_URL}static/images/arrowDownIcon.png`"></image>
              <image v-if="item.ifOpen  == true" class="arrow-down" :src="`${VUE_APP_STATIC_URL}static/images/arrowUpIcon.png`"></image>
            </view>
					</view>
					<view class="upBox" v-if="item.ifOpen == true">
						<view class="flex-row-plus flex-items mar-top-30 flex-sp-between">
							<label class="orderId-box font-color-999 fs26">商品数：{{item.products}}</label>
							<label class="orderId-box font-color-999 fs26">实付金额：¥{{item.price}}</label>
						</view>
						<view class="flex-row-plus flex-items mar-top-30 flex-sp-between">
							<label class="orderId-box font-color-999 fs26">下单人：{{item.customerName}}</label>
							<label class="commission-box mar-left-70 font-color-999 fs26">状态：<text class="state" :class="{current: item.state==0}">{{item.state==0?'未结算':'已结算'}}</text></label>
						</view>
					</view>
				</view>
			</view>
		</view>
		<view v-else class="emptyCart-box flex-items-plus flex-column">
			<image class="emptyCart-img" :src="`${VUE_APP_STATIC_URL}static/img/bgnull.png`"></image>
			<label class="font-color-999 fs26 mar-top-30">这里空空如也~</label>
		</view>
	</view>
</template>

<script setup>
import {ref} from "vue";
import { request } from '../../utils/request'
import API from '../../config/api'
import {onLoad, onReachBottom} from "@dcloudio/uni-app";
import { VUE_APP_STATIC_URL } from "@/config/api";

const shopId = ref(0)
const distributorId = ref(0)
const page = ref(1)
const pageSize = ref(20)
const FindMySalesData = ref([])
const FindMySalesDatalist = ref([])

onLoad((options) => {
  shopId.value = options.shopId
  distributorId.value = options.distributorId
  getSalesOrderPage()
})

onReachBottom(() => {
  if(loadingType.value == 1){
    uni.stopPullDownRefresh()
  } else {
    page.value = page.value + 1
    getSalesOrderPage()
  }
})

const getSalesOrderPage = async () => {
  try {
    const res = await request(API.FindMySalesPage, {
      shopId: shopId.value,
      distributorId: distributorId.value,
      page: page.value,
      pageSize: pageSize.value,
    }, 'GET')
    if(res.data.list.length == 0){
      loadingType.value = 1
      page.value = page.value
    }
    FindMySalesDatalist.value = FindMySalesDatalist.value.concat(res.data.list)
    FindMySalesData.value = res.data
  } catch (err) {}
}

arrowTypeChange(arrowTypeId) {
  FindMySalesData.value.list[arrowTypeId].ifOpen = FindMySalesData.value.list[arrowTypeId].ifOpen == true ? false : true
}
</script>

<style lang="scss">
page {
  background: #F8F8F8;
}
	.emptyCart-box{
		margin-top: 70upx;
    .emptyCart-img{
      width: 216rpx;
      height: 156rpx;
    }
	}
	.directAward-box {
		width: 95%;
		display: flex;
		justify-content: flex-start;
		flex-direction: column;
		background-color: #FFFFFF;
		padding: 40upx 20upx;
		margin-top: 30upx;
		.orderId-box {
			width: 320upx;

		}

		.commission-box {
			width: 340upx;
		}
    .state {
      color: #16BB89;
    }
    .current {
      color: #C83732 !important;
    }
		.arrow-down {
			width: 24upx;
			height: 24upx;
		}

		.upBox {
			border-top: 1upx solid #EDEDED;
			margin-top: 30upx;
		}
	}
</style>
