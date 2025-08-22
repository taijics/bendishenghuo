<template>
	<view class="container flex-items-plus flex-column">
		<view class="login-logoBox">
			<image class="login-logo" :src="`${VUE_APP_STATIC_URL}static/images/loginLogo.png`"></image>
		</view>
		<view class="loginTitle-text flex-column-plus flex-items font-color-666 fs26">
			<label>为了给您提供更好的服务</label>
			<label>我们需要您的授权哦~</label>
		</view>
		<view>
			<button class="loginWxBut fs28 mar-top-100" open-type="getPhoneNumber" @getphonenumber="getPhoneNumber">微信手机号授权</button>
		</view>
	</view>
</template>

<script setup>
import {ref} from "vue";
import { request } from "../../utils/request";
import API from "../../config/api";
import {onBackPress, onLoad} from "@dcloudio/uni-app";
import { VUE_APP_STATIC_URL } from "@/config/api";

const avatarUrl = ref('')

onLoad((options) => {
  avatarUrl.value = uni.getStorageSync('avatarUrl')
})
//
// onBackPress((options) => {
//   back();
//   return true;
// })

const back = () => {
  uni.switchTab({
    url: 'login'
  });
}

const getPhoneNumber = (e) => {
  if(e.detail.errMsg === "getPhoneNumber:ok"){
    // const that = this
    uni.login({
      provider: 'weixin',
      success: (res) => {
        code.value = res.code
        request(API.GetSessionKey,{
          code: code.value,
        },'POST').then(res1 => {
          request(API.SetWxPhone,{
            wechatOpenId:res1.data.wechatOpenId,
            sessionKey:res1.data.sessionKey,
            encryptedData:e.detail.encryptedData,
            iv:e.detail.iv,
            headImage: avatarUrl.value
          },'POST').then(res2 => {
            const item = res2.data
            uni.setStorageSync('storage_key', item);
            console.log(uni.getStorageSync('storage_key'))
            setTimeout(function(){
              uni.switchTab({
                url:'../../pages/tabbar/user/index',
                success() {
                  uni.hideLoading()
                }
              })
            },1000)
          }).catch(res => {
          })
        }).catch(err => {
          console.log(err,22222)
        })
      },
      fail: () => {
        uni.showToast({
          title: "微信登录授权失败",
          icon: "none"
        });
      }
    })
  }else{
    uni.showToast({
      title: "获取手机授权失败",
      icon: "none"
    });
  }
}
</script>

<style lang="scss">
	.container {
		.login-logoBox {
			margin-top: 154upx;

			.login-logo {
				width: 250upx;
				height: 250upx;
			}
		}

		.loginTitle-text {
			margin-top: 222upx;
		}

		.loginWxBut {
			background-image: linear-gradient(135deg, #FFA100 10%, #FF7911 100%);
			color: #FFFFFF;
			height: 88upx;
			width: 600upx;
			text-align: center;
			line-height: 88upx;
			border-radius: 88upx;
			margin-top: 49upx;
		}

		.loginBut {
			background-color: #FFFFFF;
			color: #C5AA7B;
			height: 88upx;
			width: 600upx;
			text-align: center;
			line-height: 88upx;
			border-radius: 88upx;
			border: 2upx solid #C5AA7B;
			margin-top: 30upx;
		}

		.register-text {
			color: #47A7EE;
		}
	}
</style>
