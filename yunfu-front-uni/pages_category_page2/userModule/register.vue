<!-- 注册 -->
<template>
	<view class="container flex-items flex-column">
		<view class="login-logoBox">
			<image class="login-logo" :src="`${VUE_APP_STATIC_URL}static/images/loginLogo.png`"></image>
		</view>
		<view>
			<view class="iphoneNum-box flex-row-plus flex-items">
				<view>
					<image class="loginIcon" :src="`${VUE_APP_STATIC_URL}static/images/phone.png`"></image>
				</view>
				<view style="margin-left: 40rpx;">
					<input v-model="phone" class="iphoneNum-inputbox" placeholder-class="iphoneNum-input" type="number"
						maxlength="11" placeholder="请输入您的手机号" />
				</view>
			</view>
			<view class="flex-row-plus mar-top-20">
			  <view class="code-box">
			    <view style="margin-right: 30rpx">
			      <image
			          class="loginIcon"
			          :src="`${VUE_APP_STATIC_URL}static/images/code.png`"
			      ></image>
			    </view>
			    <view>
			      <input
			          v-model="VerifyQuery.code"
			          :maxlength="4"
			          placeholder-class="codeNum-input"
			          placeholder="请输入图片验证码"
			      />
			    </view>
			  </view>
			  <view class="getcode">
				<image v-if="captcha" :src="captcha" mode="" @click="loadImage"></image>
			  </view>
			</view>
			<view class="flex-row-plus mar-top-20">
				<view class="code-box">
					<view>
						<image class="loginIcon" :src="`${VUE_APP_STATIC_URL}static/images/code.png`"></image>
					</view>
					<view style="margin-left: 40rpx;">
						<input v-model="RegisterQuery.code" :maxlength="4" class="codeNum-inputbox" placeholder-class="codeNum-input"
							placeholder="请输入验证码" />
					</view>
				</view>
				<view :class="disabled === true ? 'on' : ''" :disabled="disabled" class="getcode" @click="codede">
					{{text}}
				</view>
			</view>
		</view>
    <submit-button width="650rpx" class="mar-top-100" text="注册" @submitEvent="onregister"></submit-button>
		<view class="flex-row-plus mar-top-30">
			<text class="font-color-C5AA7B">已有账号，</text>
			<view class="font-color-C5AA7B" @click="gologin">去登录</view>
		</view>
		<view class="agreement">
			<image v-if="!agreement" src="../../static/images/none.png" mode="" @click="agreement=true"></image>
			<image v-else src="../../static/images/solid.png" mode="" @click="agreement=false"></image>
			<text class="font-color-999">注册即代表同意</text>
			<text class="font-color-C5AA7B" @click="protocol('app_user_agreement')">《APP用户服务协议》</text>和
			<text class="font-color-C5AA7B" @click="protocol('app_privacy_agreement')">《APP个人隐私协议》</text>
		</view>

	</view>
</template>
<script setup>
import { ref, reactive } from 'vue';
import { request } from "../../utils/request";
import API from "../../config/api";
import { VUE_APP_STATIC_URL } from "@/config/api";
import { onLoad } from '@dcloudio/uni-app';
import { btnUseLoading } from '../../hooks/bntUseLoading'

const { btnShowLoading, btnHideLoading } = btnUseLoading()
const getCodeisWaiting = ref(false);
const phone = ref('');
const RegisterQuery = reactive({
	account: '',
	code: '',
});
const VerifyQuery = reactive({
	phone: '',
	type: '',
	code: ''
});
const agreement = ref(false);
const disabled = ref(false)
const text = ref('获取验证码')
let captcha = ref('')
onLoad(() => {
  captcha.value = API.GetCaptcha
})
const loadImage = () =>{
	captcha.value = API.GetCaptcha + '?' + Math.random()
}
/**
 * 注册账号
 */
const getRegister = async () => {
	let phoneCodeVerification = /^1(3\d|4[5-9]|5[0-35-9]|6[2567]|7[0-8]|8\d|9[0-35-9])\d{8}$/;
	if (phone.value == '') {
		uni.showToast({
			title: '请输入手机号！',
			duration: 2000,
			icon: 'none'
		});
	} else if (!phoneCodeVerification.test(phone.value)) {
		uni.showToast({
			title: '请输入正确的手机号！',
			duration: 2000,
			icon: 'none'
		});
	} else if (RegisterQuery.code == '') {
		uni.showToast({
			title: '请获取验证码！',
			duration: 2000,
			icon: 'none'
		});
	} else if(!agreement.value){
		uni.showToast({
			title: '请先阅读并同意《用户服务协议和个人隐私协议》',
			duration: 2000,
			icon: 'none'
		});
	} else {
    btnShowLoading()
		try {
			const res = await request(API.Login, {
				type: 1,
				phone: phone.value,
				verificationCode: RegisterQuery.code,
			}, 'POST')
			// uni.hideLoading()
			uni.showToast({
				title: '注册成功！',
				duration: 2000,
				icon: 'none'
			});
			const item = res.data
			uni.setStorageSync('storage_key', item);
      btnHideLoading()
			setTimeout(function() {
				uni.switchTab({
					url: '../../pages/tabbar/user/index'
				})
			}, 600)
		} catch (err) {
      btnHideLoading()
			uni.showToast({
				title: err.data.message,
				duration: 2000,
				icon: 'none',
			});
		}
	}
}
/**
 * 获取验证码
 */
const getVerify = async () => {
	let phoneCodeVerification = /^1(3\d|4[5-9]|5[0-35-9]|6[2567]|7[0-8]|8\d|9[0-35-9])\d{8}$/;
	if (phone.value == '') {
		uni.showToast({
			title: '请输入手机号！',
			duration: 2000,
			icon: 'none'
		});
	} else if (!phoneCodeVerification.test(phone.value)) {
		uni.showToast({
			title: '请输入正确的手机号！',
			duration: 2000,
			icon: 'none'
		});
	} else {
		if(!VerifyQuery.code) return uni.showToast({
				  title: '请输入图片验证码！',
				  duration: 2000,
				  icon: 'none'
				});
		VerifyQuery.phone = phone.value
		try {
			const res = request(API.Verify, {
				code: VerifyQuery.code,
				phone: VerifyQuery.phone,
			}, 'GET')
			sendCode()
		} catch (err) {
			uni.showToast({
				title: err.data.message,
				icon: 'none',
				duration: 1000
			});
		}
	}
}
// 注册
const onregister = () => {
	getRegister()
}
// 获取验证码
const codede = () => {
  if(disabled.value)return
	getVerify()
}
const getCode = () => {
	uni.hideKeyboard()
	if (getCodeisWaiting.value) {
		return;
	}
	if (phone.value == "" || phone.value == null) {
		uni.showToast({
			title: '手机号不能为空',
			icon: 'none'
		})
		return false;
	} else if (!(/^1(3\d|4[5-9]|5[0-35-9]|6[2567]|7[0-8]|8\d|9[0-35-9])\d{8}$/.test(phone.value))) {
		uni.showToast({
			title: '输入的手机号错误',
			icon: 'none'
		})
		return false;
	}
	getCodeisWaiting.value = true;
}
/**
 * 跳转登录
 */
const gologin = () => {
	uni.navigateTo({
		url: 'login'
	})
}
/**
 * 多商户用户协议
 * @param type
 */
const protocol = (type) => {
	uni.navigateTo({
		url: 'protocol?type=' + type
	})
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
</script>
<style lang="scss" scoped>
	.container {
		background-color: #FFFFFF;

		.login-logoBox {
			margin: 100rpx 0;

			.login-logo {
				width: 200rpx;
				height: 166rpx;
			}
		}

		.iphoneNum-box {
			border-bottom: 1rpx solid #F3F4F5;
			height: 100rpx;
			width: 600rpx;

			.loginIcon {
				width: 40rpx;
				height: 53rpx;
			}

			input {
				font-size: 28rpx;
			}

			.iphoneNum-input {
				color: #999999;
				font-size: 28rpx;
				font-weight: 400;
			}

			.iphoneNum-inputbox {
				width: 400rpx;
			}
		}

		.code-box {
			border-bottom: 1rpx solid #F3F4F5;
			height: 100rpx;
			width: 350rpx;
			display: flex;
			flex-direction: row;
			justify-content: space-between;
			align-items: center;

			.loginIcon {
				width: 44rpx;
				height: 50rpx;
			}

			input {
				font-size: 28rpx;
			}

			.code-lab {
				width: 200rpx;
			}

			.codeNum-input {
				color: #999999;
				font-size: 28rpx;
				font-weight: 400;
				width: 300rpx;
			}

			.codeNum-inputbox {
				width: 300rpx;
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
			image{
				width: 100%;
				height: 100%;
			}
		}

		.getcodeActive {
			background-color: #DDDDDD;
			height: 100rpx;
			width: 220rpx;
			border-radius: 44rpx;
			display: flex;
			flex-direction: row;
			justify-content: center;
			align-items: center;
			margin-left: 20rpx;
			color: #333333;
		}

		.agreement {
			margin: 100rpx 50rpx;
			line-height: 50rpx;
			image{
				width: 34rpx;
				height: 34rpx;
				margin-right: 15upx;
			}
		}
	}
</style>
