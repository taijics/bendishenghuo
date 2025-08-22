<template>
	<view class="content">
		<view class="topbg">
		</view>
		<view class="content-text">
			<view class="text-align fs32 fs-bold">
				账户注销重要提醒
			</view>
			<view class="font-color-C5AA7B fs30 mar-top-20">
				在您确认注销平台账户之前，请您充分阅读、理解并同意下列事项：
			</view>
			<view class="mar-top-20">
				如您不同意下列任一内容，请不要进行账户注销操作。您通过网络页面确认申请注销，视为您同意接受本提醒所有内容）
			</view>
			<p class="mar-top-20">1. 本帐号的个人资料和历史信息（包括头像、用户、订单记录、浏览记录、收藏等）都将无法找回</p>
			<p class="mar-top-20">2. 你将无法登录、使用本帐号</p>
			<p class="mar-top-20">3. 通过本帐号使用、授权登录或绑定本帐号后使用的相关记录将无法找回。你将无法再登录，使用上述服务，你曾获得的虚拟权益等财产性利益视为你自动放弃，将无法继续使用。</p>
		</view>
		<view class="content-text">
			<view class="fs32 fs-bold">
				注销后，您将放弃以下权限
			</view>
			<p class="mar-top-20">1. 您的所有交易记录将被清空，请确保所有交易已完结且无纠纷，账户注销后因历史交易可能产生的退换货、维权相关的资金退回等权益将视作自动放弃。</p>
			<p class="mar-top-20">2. 您的身份信息、账户信息、积分、会员权益等将被清空且无法恢复。</p>
		</view>
		<view class="content-text">
			<view class="fs32 fs-bold">
				注销，您需要满足以下条件
			</view>
			<p class="mar-top-20">1. 账户近期不存在交易：您的账户无未完成订单、无已完成但未满15天订单。</p>
			<p class="mar-top-20">2. 账户相关财产权益已结清：您的账户不存在可提现的余额。</p>
		</view>
		<view class="content-text">
			<view class="agreement">
				<image v-if="!agreement" src="../../static/images/none.png" mode="" @click="agreement=true"></image>
				<image v-else src="../../static/images/solid.png" mode="" @click="agreement=false"></image>
				<text class="font-color-999">我已阅读并同意</text>
				<text class="font-color-C5AA7B" @click="protocol('app_user_agreement')">《账户注销重要提醒》</text>
			</view>
			<view class="btn" @click="consent">同意注销</view>
		</view>
	</view>
</template>

<script setup>
import {ref} from "vue";

const agreement = ref(false)

const consent = () => {
  if(!agreement.value){
    uni.showToast({
      title: '请先阅读并同意《账户注销重要提醒》',
      duration: 2000,
      icon: 'none'
    });
  } else {
    uni.navigateTo({
      url:'unsubscribeCode'
    })
  }
}
</script>

<style lang="scss" scoped>
	.content {
		background-color: #F5F5F5;
		.topbg {
			width: 100%;
			height: 400rpx;

			image {
				width: 100%;
				height: 100%;
			}
		}

		.content-text {
			position: relative;
			top: -340rpx;
			margin: 30rpx;
			border-radius: 5rpx;
			padding: 30rpx;
			background-color: #FFFFFF;
			.btn{
				background: #333333;
				color: #FFFFFF;
				height: 88rpx;
				width: 600rpx;
				text-align: center;
				line-height: 88rpx;
				margin-top: 40rpx;
			}
			.agreement {
				line-height: 50rpx;
				image{
					width: 34rpx;
					height: 34rpx;
					margin-right: 15upx;
				}
			}
		}
	}
</style>
