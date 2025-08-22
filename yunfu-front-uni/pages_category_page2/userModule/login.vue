<template>
	<view class="container flex-items-plus flex-column">
    <global-loading />
		<view class="login-logoBox">
			<image class="login-logo" :src="`${VUE_APP_STATIC_URL}static/images/loginLogo.png`"></image>
		</view>
		<view class="loginTitle-text flex-column-plus flex-items font-color-666 fs26">
			<text>为了给您提供更好的服务</text>
			<text>我们需要您的授权哦~</text>
		</view>
		<view>
			<!-- #ifdef MP-WEIXIN -->
			<button class="loginWxBut fs28" @click="GetUserInfo">手机号快捷登录</button>
			<button class="goToHome fs28" @click="goToHome">去首页逛逛</button>
			<!-- #endif -->
			<!-- #ifdef MP-ALIPAY -->
			<button class="loginWxBut fs28" @click="GetAliPayUserInfo">支付宝登录</button>
			<!-- #endif -->
			<!-- #ifndef MP-ALIPAY -->
			<view class="loginBut" v-if="noMp" @click="goLogin">手机号登录</view>
			<!-- #endif -->
		</view>
		<view class="flex-row-plus mar-top-30" v-if="noMp">
			<text class="font-color-C5AA7B">还没有账号，</text>
			<view class="register-text" @click="goRegister">去注册</view>
		</view>
	</view>
</template>
<script setup>
import { ref } from 'vue';
import { request } from "../../utils/request";
import API from "../../config/api";
import { onShow, onLoad, onBackPress } from '@dcloudio/uni-app';
import { VUE_APP_STATIC_URL } from "@/config/api";

const WXloginQuery = ref({
	"code": "",
	"salesId": 0,
	"headImage": '',
	"terminal":1
})
const noMp = ref(false)
onLoad((options) => {
	// #ifndef MP
	noMp.value = true
	// #endif
	// const pages = getCurrentPages()
	// console.log(pages.length, 'pages-test')
	// uni.setStorageSync('last_page', pages[pages.length - 1].route);
	// if (pages[pages.length - 1].options) {
	// 	uni.setStorageSync('last_page_options', pages[pages.length - 1].options);
	// }
})
onShow(() => {
	// 所有需要授权页面进登录页面取消loading
	uni.hideLoading()
})
onBackPress(() => {
	uni.switchTab({
		url: '../../pages/tabbar/index/index'
	})
	return true;
})
const back = () => {
	uni.switchTab({
		url: '../../pages/tabbar/index/index'
	});
}
const goLogin = () => {
	uni.navigateTo({
		url: 'accountLogin'
	})
}
const goRegister = () => {
	uni.navigateTo({
		url: 'register'
	})
}
// 微信登录
const GetUserInfo = async () => {
	// #ifdef MP-WEIXIN
	uni.login({
		provider: 'weixin',
		success: (res2) => {
			uni.hideLoading()
			WXloginQuery.value.code = res2.code
		},
		fail: () => {
			uni.showToast({
				title: "微信登录授权失败",
				icon: "none"
			});
		}
	})
	uni.getUserProfile({
		desc: '正在获取', // 不写不弹提示框
		success: async function (res) {
			WXloginQuery.value.headImage = res.userInfo.avatarUrl
			try {
				const res = await request(API.WxLogin, WXloginQuery.value, 'POST')
				let data = {
					wechatOpenId: res.data.wechatOpenId,
					headImage: res.data.headImage
				}
				loginSuc(res.data, data)
			} catch (erorr) {
				console.log('wxLogin failed', err)
			}
		},
		fail: function (err) {
			uni.showToast({
				title: "微信登录授权失败",
				icon: "none"
			});
		},
	});
	// #endif
}
const GetAliPayUserInfo = () => {
	uni.login({
		provider: 'alipay',
		scopes: 'auth_user',
		success: function(loginRes) {
			alipayLogin(loginRes.authCode)
		}
	});
}
const alipayLogin = async (authCode) => {
	try {
		const response = await request(API.AlipayLogin, {
			'code': authCode
		}, 'POST');
		loginSuc(response.data, {
			'buyerUserId': response.data.buyerUserId
		});
	} catch (error) {
		console.log('alipayLogin failed', error);
	}
}
const goToHome = () => {
	uni.switchTab({
		url: '/pages/tabbar/index/index'
	});
}
const loginSuc = (buyerUser, data) => {
	if (buyerUser.ifFirst == 0) {
		uni.setStorageSync('storage_key', buyerUser);
		bindSalesCustomer()
		const last_page = uni.getStorageSync('last_page') || ''
		if (last_page) {
      if(last_page==='pages_category_page2/userModule/login'){
        // 如果最后一个是登录
        uni.switchTab({
          url:'/pages/tabbar/index/index'
        })
        return;
      }
			const last_page_options = uni.getStorageSync('last_page_options') || ''
      const str = JSON.stringify(last_page_options).replace(/[{}"]/g, '')
          .replace(/:/g, '=')
          .replace(/,/g, '&');
			// 清空其他路由，直接跳转最后登录页面
			uni.reLaunch({
				url: `/${last_page}?${str}`,
				// url: `/${last_page}?` + str
			})
		} else {
			// #ifdef MP-ALIPAY
			uni.navigateTo({
				url: '/pages/tabbar/user/index'
			})
			// #endif
			// #ifndef MP-ALIPAY
			uni.switchTab({
				url: '/pages/tabbar/user/index'
			})
			// #endif
		}
	} else { // 第一次登录，绑定手机号
		uni.redirectTo({
			url: 'bindPhone?data=' + JSON.stringify(data)
		})
	}
}


const bindSalesCustomer = async () => {
	const shopId = uni.getStorageSync('shopId');
	const salesId = uni.getStorageSync('salesId');
	if (shopId && salesId && shopId !== '' && salesId !== '') {
		try {
			const response = await request(API.BindSalesCustomer, {
				shopId: shopId,
				distributorId: salesId
			}, 'POST');
			uni.removeStorageSync('salesId');
			uni.removeStorageSync('shopId');
		} catch (error) {
			console.log('login bindSalesCustomer error');
			console.dir(error);
		}
	}
}
</script>

<style lang="scss">
	.container {
		background-color: #FFFFFF;
		height: 100vh;

		.login-logoBox {
			margin-top: -200rpx;

			.login-logo {
				width: 200rpx;
				height: 167rpx;
			}
		}

		.loginTitle-text {
			margin-top: 100rpx;
		}

		.goToHome {
			background: none;
			border: none;
			width: auto;
			margin-top: 50rpx;
			color: #999999;
			text-decoration: underline;

			&:after {
				display: none;
			}
		}

		.loginWxBut {
			background: #333333;
			color: #FFEBC4;
			height: 88rpx;
			width: 600rpx;
			text-align: center;
			line-height: 88rpx;
			margin-top: 49rpx;
		}

		.loginBut {
			background-color: #333333;
			color: #FFEBC4;
			height: 88rpx;
			width: 600rpx;
			text-align: center;
			line-height: 88rpx;
			margin-top: 30rpx;
		}

		.register-text {
			color: #C5AA7B;
		}
	}
</style>
<style scoped>
	.loginWxBut::after {
		border-radius: 0 !important;
	}
</style>
