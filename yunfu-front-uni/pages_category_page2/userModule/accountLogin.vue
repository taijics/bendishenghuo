<template>
  <!-- 登录 -->
  <view class="container flex-items-plus flex-column">
    <view class="login-logoBox">
      <image
          class="login-logo"
          :src="`${VUE_APP_STATIC_URL}static/images/loginLogo.png`"
      ></image>
    </view>
    <view class="iphoneNum-box flex-row-plus flex-items">
      <view style="margin-right: 30rpx">
        <image
            class="loginIcon"
            :src="`${VUE_APP_STATIC_URL}static/images/phone.png`"
        ></image>
      </view>
      <view>
        <input
            v-model="loginQuery.account"
            placeholder-class="iphoneNum-input"
            type="number"
            maxlength='11'
            placeholder="请输入您的手机号"
        />
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
        <view style="margin-right: 30rpx">
          <image
              class="loginIcon"
              :src="`${VUE_APP_STATIC_URL}static/images/code.png`"
          ></image>
        </view>
        <view>
          <input
              v-model="loginQuery.code"
              :maxlength="4"
              placeholder-class="codeNum-input"
              placeholder="请输入验证码"
          />
        </view>
      </view>
      <view
          :class="disabled === true ? 'on' : ''"
          :disabled="disabled"
          class="getcode"
          @click="codede"
      >{{ text }}
      </view>
    </view>
    <view class="mar-top-60">
<!--      <view-->
<!--          class="registerBut mar-top-100"-->
<!--          @click="login"-->
<!--      >登录-->
<!--      </view>-->
      <submit-button width="650rpx" class="mar-top-100" text="登录" @submitEvent="login"></submit-button>
    </view>
  </view>
</template>
<script setup>
import { VUE_APP_STATIC_URL } from "@/config/api";
import { ref } from 'vue';
import { request } from '../../utils/request';
import API from '../../config/api';
import { onLoad } from '@dcloudio/uni-app';
import { btnUseLoading } from '../../hooks/bntUseLoading'

const { btnShowLoading, btnHideLoading } = btnUseLoading()
const loginQuery = ref({
  account: '',
  code: '',
  salesId: '',
});

const VerifyQuery = ref({
  phone: '',
  code: ''
});

const inviteSpell = ref({});
const inviteSpelltype = ref(false);
const beforePage = ref(undefined);
const doubleBeforePage = ref(undefined);
const disabled = ref(false)
const text = ref('获取验证码')
let captcha = ref('')
onLoad((options) => {
  if (options.inviteSpell == 1) {
    inviteSpelltype.value = true;
    inviteSpell.value = uni.getStorageSync('inviteSpell');
  }
  loginQuery.value.salesId = uni.getStorageSync('salesId');
  const pages = getCurrentPages();
  if (pages.length >= 2) {
    beforePage.value = pages[pages.length - 2];
  }
  if (pages.length >= 3) {
    doubleBeforePage.value = pages[pages.length - 3];
  }
  captcha.value = API.GetCaptcha
})
const loadImage = () =>{
	captcha.value = API.GetCaptcha + '?' + Math.random()
}
const login = async () => {
  let phoneCodeVerification = /^[1][3-9][0-9]{9}$/;
  if (loginQuery.value.account == '') {
    uni.showToast({
      title: '请输入手机号！',
      duration: 2000,
      icon: 'none'
    });
  } else if (!phoneCodeVerification.test(loginQuery.value.account)) {
    uni.showToast({
      title: '请输入正确的手机号！',
      duration: 2000,
      icon: 'none'
    });
  } else {
    btnShowLoading()
    try {
      const res = await request(API.Login, {
        type: 2,
        phone: loginQuery.value.account,
        verificationCode: loginQuery.value.code
      }, 'POST')
      uni.hideLoading()
      const item = res.data
      uni.setStorageSync('storage_key', item);
      if (uni.getStorageSync("salesId")) {
        let salesId = uni.getStorageSync("salesId")
        let shopId = uni.getStorageSync("shopId")
        bindSalesCustomer(salesId, shopId)
        uni.removeStorageSync('salesId');
        uni.removeStorageSync('shopId');
      }
      // 购物车右上角数量
      request(API.ShoppingCart, {}, 'GET').then(resCart => {
        let cartNum = 0
        resCart.data.forEach(shopItem => {
          shopItem.skus.forEach(goodsItem => {
            cartNum += goodsItem.number
          })
        })
        if (cartNum > 0) {
          uni.setTabBarBadge({
            index: 3,
            text: cartNum.toString()
          })
        }
        uni.setStorageSync('allCartNum', cartNum)
      })
      if (inviteSpelltype.value == true) {
        setTimeout(function () {
          uni.reLaunch({
            url: '../../pages_category_page1/goodsModule/inviteSpell?collageId=' +
              inviteSpell.value.collageId + '&orderId=' + inviteSpell.value
                .orderId + '&type=0' + '&productId=' + inviteSpell.value
                .productId + '&skuId=' + inviteSpell.value.skuId
          })
          uni.removeStorageSync('inviteSpell');
        }, 2000)
      } else {
        if (beforePage.value && beforePage.value.route !==
          'pages_category_page2/userModule/accountLogin' &&
          beforePage.value.route !== 'pages_category_page2/userModule/login' &&
          beforePage.value.route !== 'pages_category_page2/userModule/register') {
          uni.navigateBack({
            delta: 1
          })
        } else if (doubleBeforePage.value && doubleBeforePage.value.route !==
          'pages_category_page2/userModule/accountLogin' &&
          doubleBeforePage.value.route !== 'pages_category_page2/userModule/login' &&
          doubleBeforePage.value.route !== 'pages_category_page2/userModule/register') {
          uni.navigateBack({
            delta: 2
          })
        } else {
          setTimeout(function () {
            uni.switchTab({
              url: '../../pages/tabbar/user/index'
            })
          }, 600)
        }
      }
    } catch (error) {
      uni.hideLoading()
      uni.showToast({
        title: res.data.message,
        duration: 2000,
        icon: 'none',
      });
      throw new Error(error)
    } finally {
      btnHideLoading()
    }
  }
}

// 获取验证码
const codede = () => {
  if(disabled.value)return
  getVerify()
}
const getVerify = async () => {
  let phoneCodeVerification = /^[1][3-9][0-9]{9}$/;
  if (loginQuery.value.account == '') {
    uni.showToast({
      title: '请输入手机号！',
      duration: 2000,
      icon: 'none'
    });
  } else if (!phoneCodeVerification.test(loginQuery.value.account)) {
    uni.showToast({
      title: '请输入正确的手机号！',
      duration: 2000,
      icon: 'none'
    });
  } else {
	  if(!VerifyQuery.value.code) return uni.showToast({
		  title: '请输入图片验证码！',
		  duration: 2000,
		  icon: 'none'
		});
    VerifyQuery.value.phone = loginQuery.value.account
    try {
      const res = await request(API.Verify, {
		code: VerifyQuery.value.code,
        phone: VerifyQuery.value.phone,
      }, 'GET');
      sendCode();
    } catch (error) {
      uni.showToast({
        title: error.data.message,
        duration: 1000,
        icon: 'none'
      });
    }
  }
}
// 绑定关系
const bindSalesCustomer = async (salesId, storeId) => {
  if (salesId && storeId) {
    try {
      const response = await request(API.BindSalesCustomer, {
        shopId: storeId,
        distributorId: salesId
      }, 'POST');
      uni.showToast({
        title: "绑定成功",
        icon: "none"
      });
    } catch (error) {
      uni.showToast({
        title: error.data.message,
        icon: "none"
      });
    }
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
	image{
		width: 100%;
		height: 100%;
	}
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
