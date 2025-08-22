<template>
	<!-- 登录 -->
	<view class="container flex-items-plus flex-column">
    <global-loading />
    <view class="login-logoBox">
			<image class="login-logo" :src="`${VUE_APP_STATIC_URL}static/images/loginLogo.png`"></image>
		</view>
		<view class="iphoneNum-box flex-row-plus flex-items">
			<view style="margin-right: 30rpx">
				<image class="loginIcon" :src="`${VUE_APP_STATIC_URL}static/images/phone.png`"></image>
			</view>
			<view>
				<input v-model="userInfo.phone" placeholder-class="iphoneNum-input" type="number" disabled
					placeholder="请输入您的手机号" />
			</view>
		</view>
		<view class="flex-row-plus mar-top-20">
			<view class="code-box">
				<view style="margin-right: 30rpx">
					<image class="loginIcon" :src="`${VUE_APP_STATIC_URL}static/images/code.png`"></image>
				</view>
				<view>
					<input v-model="code" placeholder-class="codeNum-input" placeholder="请输入验证码" />
				</view>
			</view>
			<view :class="disabled === true ? 'on' : ''" :disabled="disabled" class="getcode" @click="codede">{{text}}
			</view>
		</view>
		<view class="mar-top-60">
			<view class="registerBut mar-top-100" @click="unsubscribe">立即注销</view>
		</view>
	</view>
</template>

<script setup>
// import sendVerifyCode from "@/mixins/SendVerifyCode";
// import { request } from "@/utils/request";
// import API from "@/config/api";
import { ref } from "vue";
import { request } from "../../utils/request";
import API from "../../config/api";
import {onLoad} from "@dcloudio/uni-app";
import { VUE_APP_STATIC_URL } from "@/config/api";

const disabled = ref(false)
const text = ref('获取验证码')
const code = ref('')
const userInfo = ref({})

onLoad(() => {
  userInfo.value = uni.getStorageSync('storage_userInfo')
})

/**
 * 获取验证码
 */
const codede = () => {
  getVerify()
}

const getVerify = async () => {
  try {
    const res = await request(API.Verify, {
      phone: userInfo.value.phone,
    }, 'GET')
    sendCode()
  } catch (err) {
    uni.showToast({
      title: err.data.message,
      duration: 1000,
      icon: 'none'
    });
  }
}
const sendCode = () => {
  if (disabled.value) return
  disabled.value = true
  let n = 60
  text.value = '剩余 ' + n + 's'
  const run = setInterval(() => {
    n = n - 1
    if (n < 0) {
      clearInterval(run)
    }
    text.value = '剩余 ' + n + 's'
    if (text.value < '剩余 ' + 0 + 's') {
      disabled.value = false
      text.value = '重新获取'
    }
  }, 1000)
}

/**
 * 账户注销
 */
const unsubscribe = async () => {
  try {
    const res = await request(API.delUser + code.value, {}, "delete")
    console.log(res)
    setTimeout(function() {
      uni.removeStorageSync('storage_key');
      uni.removeStorageSync('distributorId');
      uni.reLaunch({
        url: 'login',
        success() {
          // uni.hideLoading()
        }
      })
    }, 1000)
  } catch (err) {
    uni.showToast({
      title: err.data.message,
      duration: 1000,
      icon: 'none'
    });
  }
}
</script>

<style lang="scss">
	.container {
		background-color: #FFFFFF;
		height: 100vh;

		.login-logoBox {
			margin-top: -300rpx;

			.login-logo {
				width: 234rpx;
				height: 193rpx;
			}
		}

		.iphoneNum-box {
			margin-top: 100rpx;
			border-bottom: 1rpx solid #DDDDDD;
			height: 100rpx;
			width: 600rpx;

			.loginIcon {
				width: 40rpx;
				height: 53rpx;
			}

			.iphoneNum-input {
				color: #999999;
				font-size: 28rpx;
				font-weight: 400;
			}
		}

		.passwordNum-box {
			border-bottom: 1rpx solid #DDDDDD;
			height: 100rpx;
			width: 600rpx;

			.passwordNum-input {
				color: #999999;
				font-size: 28rpx;
				font-weight: 400;
				width: 346rpx;
			}
		}

		.code-box {
			border-bottom: 1rpx solid #DDDDDD;
			height: 100rpx;
			width: 360rpx;
			display: flex;
			flex-direction: row;
			justify-content: space-between;
			align-items: center;

			.loginIcon {
				width: 44rpx;
				height: 50rpx;
			}

			.code-lab {
				width: 200rpx;
			}

			.codeNum-input {
				color: #999999;
				font-size: 28rpx;
				font-weight: 400;
			}
		}

		.getcode {
			background-color: #C5AA7B;
			height: 100rpx;
			width: 230rpx;
			display: flex;
			flex-direction: row;
			justify-content: center;
			align-items: center;
			margin-left: 20rpx;
			color: #FFFFFF;
		}

		.registerBut {
			background: #333333;
			color: #FFEBC4;
			height: 100rpx;
			width: 600rpx;
			text-align: center;
			line-height: 100rpx;
			margin-top: 30rpx;
		}
	}
</style>
