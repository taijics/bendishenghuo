<!-- 我的账户 -->
<template>
  <view>
<!--    <global-loading />-->
	<view class="container" v-if="ifShow">
		<view class="balance">
		</view>
    <view class="balanceInfo">
      <view class="infoBox">
        <view v-if="accountInfo.price != null " class="cur-balance">{{accountInfo.price}}</view>
        <view v-else class="cur-balance">0.00</view>
        <view class="mar-top-20">余额</view>
      </view>
    </view>
		<view class="balance-operation">
			<view class="item-btn" @click="memberAccountWithdraw">
				<image class="item-btn-icon" :src="`${VUE_APP_STATIC_URL}static/images/withdraw.png`" mode="widthFix"></image>
				<view class="item-btn-text">提现</view>
				<image class="item-btn-right" :src="`${VUE_APP_STATIC_URL}static/images/greyArrow.png`" mode="widthFix"></image>
			</view>
		</view>
	</view>
  </view>
</template>

<script setup>
import { ref, onMounted, computed } from "vue";
import { onBackPress } from '@dcloudio/uni-app';
import { request } from "@/utils/request";
import API from "@/config/api";
import { VUE_APP_STATIC_URL } from "@/config/api";


const accountInfo = ref([])
const ifShow = ref(false)

onMounted(() => {
	getBalance()
})

// onBackPress((e) => {
// 	if (e.from === 'navigateBack') {
// 		return false;
// 	}
// 	back();
// 	return true;
// })

const back = () => {
	uni.switchTab({
		url:'../../pages/tabbar/user/index'
	});
}

const getBalance = async () => {
	try {
		const res = await request(API.GetDistributor,{},"GET")
		uni.hideLoading()
		ifShow.value = true
		accountInfo.value = res.data
	} catch (err) {
	}
}

const memberAccountWithdraw = async () => {
	if(accountInfo.value.price <= 0 ){
		uni.showToast({
			title: "您暂时没有余额，不能提现",
			duration: 2000,
			icon: 'none'
		})
	}else{
		uni.navigateTo({
			url:'withdraw'
		})
	}
}

const parseMoney = computed(() => {
	return parseFloat(accountInfo.value.price / 100).toFixed(2);
})
</script>

<style lang="scss">
@import "../../style/images";
page {
  background: #F8F8F8;
}
	.container{
		background: #f8f8f8;
		.balance{
			display: block;
			height: 400rpx;
			background: $bankBg no-repeat left top;
      background-size: cover;
			text-align:center;
      padding: 100rpx 20rpx 0 20rpx;
		}
    .balanceInfo {
      width: 712rpx;
      background: $accountBg no-repeat left top;
      height: 342rpx;
      background-size: cover;
      margin: -300rpx auto 0 auto;
      display: flex;
      justify-content: center;
      align-items: center;
      border-radius: 20rpx;
      .infoBox {
        text-align: center;
        .cur-balance{
          font-size:60rpx;
          color: #71521B;
        }
      }
    }
    .balance-operation {
      margin-top: 38rpx;
      padding: 0 24rpx;
      .item-btn {

      }
    }
	}
	.item-btn{
		width: 100%;
		height: 100upx;
		display: flex;
		flex-direction: row;
		align-items: center;
		box-sizing: border-box;
		background-color: #fff;
		padding: 0 30upx;
		.item-btn-icon{
			width: 90upx;
			height: 90upx;
		}
		.item-btn-text{
			font-size:28upx;
			margin-left: 20upx;
			font-weight:500;
			flex: 1;
			color:rgba(102,102,102,1);
		}
		.item-btn-right{
			width: 60upx;
			height: 60upx;
		}

	}
	.mt20{
		margin-top: 20upx;
	}
	.mt1{
		margin-top: 1upx;
	}
</style>
