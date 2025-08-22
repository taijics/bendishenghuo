<!-- 修改个人信息 -->
<template>
  <view
      class="container fs28"
      :style="{height:screenHeight+'px'}"
  >
    <view class="headBox">
      <view class="personalHead-box flex-sp-between flex-display flex-items">
        <label>头像</label>
        <image
            class="user-headImg"
            v-if="item.headImage"
            :src="item.headImage"
        ></image>
        <image
            class="user-headImg"
            v-else
            :src="`${VUE_APP_STATIC_URL}static/img/user/morentouxiang.png`"
        >
        </image>
      </view>
    </view>
    <view class="personalBack-box flex-items-plus flex-column">
      <view class="personalHead-box flex-sp-between flex-display flex-items">
        <label>昵称</label>
        <!--				<label class="font-color-999" v-if="item.name">{{item.name}}</label>-->
        <!--        <label class="font-color-999" v-else>{{item.phone}}</label>-->
        <!-- <input class="nameInput" v-if="name" v-model="name" type="text" placeholder="请输入内容" @blur="changeName(1)" /> -->
        <!-- <input class="nameInput" v-else type="text" v-model="phone" placeholder="请输入内容" @blur="changeName(2)" /> -->
        <input
            class="nameInput"
            v-model="name"
            type="text"
            placeholder="请输入内容"
            @blur="changeName"
        />
      </view>
      <view
          class="personalHead-box flex-sp-between flex-display flex-items"
          @click="sexShowClick"
      >
        <label>性别</label>
        <label class="font-color-999">{{ item.sex }}</label>
      </view>
      <view
          class="personalHead-box1 flex-sp-between flex-display flex-items"
          @click="changeTime"
      >
        <label>生日</label>
        <label class="font-color-999">{{ parsebirthday(birthday) }}</label>
        <!-- <u-calendar v-model="birthdateShow" :mode="mode"></u-calendar> -->
      </view>
    </view>
    <view class="iphoneNumback-box  flex-items-plus">
      <view class="iphoneNum-box flex-row-plus flex-sp-between flex-items">
        <label style="width: 50%;">手机号</label>
        <label
            class="font-color-C5AA7B"
            v-if="phone"
        >{{ phone }}</label>
        <label
            class="font-color-C5AA7B"
            v-else
        >
          <!-- #ifdef MP-ALIPAY -->
          <button
              class="verifyPhone"
              open-type="getAuthorize"
              @getAuthorize="onGetAuthorize"
              @error="onAuthError"
              scope="phoneNumber"
          >去验证
          </button>
          <!-- #endif -->
          <!-- #ifndef MP-ALIPAY -->
          去验证
          <!-- #endif -->
        </label>
      </view>
    </view>
    <view class="agreement">
      <view
          class="agreement agreement_top"
          @click="protocol('app_privacy_agreement')"
      >
        <text>用户隐私协议</text>
        <image
            src="../../static/images/right.png"
            mode=""
        ></image>
      </view>
      <view
          class="agreement"
          @click="protocol('app_user_agreement')"
      >
        <text>用户服务协议</text>
        <image
            src="../../static/images/right.png"
            mode=""
        ></image>
      </view>
    </view>

    <view class="mar-top-100">
      <view
          class="exitLoginBut  flex-items-plus"
          @click="quit"
      >退出登录
      </view>
      <!-- #ifdef APP-PLUS -->
      <view
          class="cancellation"
          @click="cancellation"
      >注销账号
      </view>
      <!-- #endif -->
    </view>


    <!-- 修改性别弹窗 -->
    <u-select
        v-model="sexShow"
        title="修改性别"
        :list="sexList"
        @confirm="ConfirmSex"
    ></u-select>
    <!-- 修改生日弹窗 -->
    <u-picker
        v-model="timeShow"
        mode="time"
        title="修改生日"
        :params="params"
        start-year="1970"
        @confirm="ConfirmTime"
    >
    </u-picker>
    <!-- <view>
      <u-popup v-model="sexShow" mode="center" close-icon-size ="20" border-radius="10" :closeable='true' close-icon-pos = "top-right">
        <view class="flex-items-plus flex-column">
          <label class="mar-top-50 fs-bold">性别</label>
          <u-radio-group class="sexRadio-box flex-items-plus flex-column" v-model="item.sex" @change="sexRadioGroupChange">
            <u-radio class="sexRadio"
              v-for="(item, index) in sexList" :key="index"
              :name="item.id"
              :disabled="item.disabled"
              active-color="#C5AA7B"
            >
              {{item.name}}
            </u-radio>
          </u-radio-group>
        </view>
      </u-popup>
    </view> -->
  </view>
</template>

<script setup>
import { request } from "@/utils/request";
import API from "@/config/api";
import { onMounted, ref } from "vue";
import { onLoad } from "@dcloudio/uni-app";
import { VUE_APP_STATIC_URL } from "@/config/api";

const screenHeight = ref(0)
const birthdateShow = ref(false)
const mode = ref('date')
const birthday = ref('')
const sexShow = ref(false)
const timeShow = ref(false)
const item = ref({})
const code = ref('')
const phone = ref('')
const name = ref('')
const sexList = ref([{
  value: '1',
  label: '男'
},
  {
    value: '2',
    label: '女'
  }
])
const UpdateInfoQuery = ref({
  headimg: '',
  sex: '',
  nickname: ''
})
const params = ref( { // 日期
  year: true,
  month: true,
  day: true,
  hour: false,
  minute: false,
  second: false
})

onLoad(()=>{
  GetUser()
})
onMounted(()=>{
  // 获取手机的屏幕高度
  uni.getSystemInfo({
    success: (res) => {
      screenHeight.value = res.screenHeight
    }
  })
})



// 多商户用户协议
const protocol = (type) => {
  uni.navigateTo({
    url: 'protocol?type=' + type
  })
}
const cancellation = ()=> {
  uni.showModal({
    title: "温馨提示",
    content: "是否注销此账号！",
    confirmText:"前往注销",
    success(res) {
      if (res.cancel) {
        uni.showToast({
          icon: 'none',
          title: '已取消'
        })
      } else if (res.confirm) {
        uni.navigateTo({
          url: 'unsubscribe'
        })
      }
    }
  })
}
// 修改生日
const changeTime = ()=> {
  if (birthday.value == '1970-01-01' || birthday.value == '') {
    timeShow.value = true
  }
}
// 修改昵称
const changeName = ()=> {
  const newName = name.value || phone.value
  if (!newName) {
    uni.showToast({
      title: '请输入新的内容',
      icon: "none"
    })
    return false
  }
  // uni.showLoading({
  // 	mask: true,
  // 	title: "正在加载中"
  // })
  request(API.UpdateUser, {
    name: newName
  }, 'POST').then(res => {
    GetUser()
    uni.hideLoading()
    uni.showToast({
      title: '修改成功',
      icon: "success"
    })
  }).catch(res => {
    uni.hideLoading()
    throw new Error(res)
  })
}
// 提交修改生日
const ConfirmTime = (content)=>{
  if (birthday.value == '1970-01-01' || birthday.value == '') {
    let birthday = content.year + '-' + content.month + '-' + content.day

    request(API.UpdateUser, {
      birthday
    }, 'POST').then(res => {
      GetUser()
      uni.hideLoading()
      uni.showToast({
        title: '修改成功',
        icon: "success"
      })
    }).catch(res => {
      uni.hideLoading()
      throw new Error(res)
    })
  }
}
// 点击弹窗修改性别
const sexShowClick = ()=> {
  sexShow.value = true
}
// 提交修改性别
const ConfirmSex = (content)=>{
  let sex = content[0].label
  request(API.UpdateUser, {
    sex
  }, 'POST').then(res => {
    GetUser()
    uni.hideLoading()
    uni.showToast({
      title: '修改成功',
      icon: "success"
    })
  }).catch(res => {
    uni.hideLoading()
    throw new Error(res)
  })
}

// 获取用户信息
const GetUser = ()=>{
  request(API.GetUser, {}, 'GET').then(res => {
    item.value = res.data
    phone.value = res.data.phone
    name.value = res.data.name
    birthday.value = res.data.birthday
  }).catch(res => {
    throw new Error(res)
  })
}

const userHeadTap = ()=> {
  return
/*  uni.chooseImage({
    count: 1,
    sizeType: ['compressed'],
    success: (res) => {}
  })*/
}
//生日
const birthdateChange = (e)=> {
  return
  // item.birth = e.result
}
// 性别
const sexRadioGroupChange =(e)=> {
  return
}

const quit = ()=> {
  // uni.showLoading({
  // 	mask: true,
  // 	title: '正在退出...',
  // 	duration: 2000,
  // });
  setTimeout(function() {
    uni.removeStorageSync('storage_key');
    uni.removeStorageSync('distributorId');
    uni.removeStorageSync("allCartNum")
    uni.reLaunch({
      url: 'login',
      success() {
        uni.hideLoading()
      }
    })
  }, 1000)
}

const onGetAuthorize=()=>{
  // uni.showLoading({
  // 	mask: true,
  // 	title: '验证中...',
  // })
  my.getPhoneNumber({
    success: (res) => {
      let encryptedData = res.response;
      console.log('encryptedData:', encryptedData)
      request(API.UpdateAliPhone, {
        'phone': encryptedData
      }, 'POST').then(res => {
        const item = res.data
        uni.setStorageSync('storage_key', item);
        phone.value = item.phone
        // uni.hideLoading()
      }).finally(res => {
      })
    },
    fail: (res) => {
      console.log('getPhoneNumber failed', res);
      uni.hideLoading()
      uni.showToast({
        title: '验证失败',
        icon: 'none'
      })
    }
  });
}

const parsebirthday = (birthday)=> {
  return birthday == ''?'1970-01-01':birthday
}

</script>

<style lang="scss">
.agreement {
  width: 710rpx;
  margin: 20rpx auto 0;
  background-color: #fff;

  .agreement_top {
    &::after {
      content: "";
      display: block;
      position: absolute;
      left: 32rpx;
      bottom: 0;
      width: 646rpx;
      height: 4rpx;
      background: #F5F7FA;
    }
  }

  .agreement {
    width: 100%;
    height: 108rpx;
    display: flex;
    justify-content: space-between;
    align-items: center;
    font-size: 28rpx;
    color: #333;
    padding: 0 10rpx 0 32rpx;
    box-sizing: border-box;
    position: relative;

    image {
      width: 60rpx;
      height: 60rpx;
    }
  }
}

.phoneWxBut {
  width: 160rpx;
  height: 60rpx;
  border: 1rpx solid #FF7800;
  border-radius: 44rpx;
  font-size: 28rpx;
  line-height: 60rpx;
}

.container {
  width: 100%;
  background-color: #F7F7F7;
  padding: 20rpx;

  .personalBack-box {
    width: 100%;
    background-color: #FFFFFF;

    .personalHead-box {
      width: 90%;
      border-bottom: 1upx solid #E5E5E5;
      padding-bottom: 20upx;
      margin-top: 36upx;

      .nameInput {
        text-align: right;
      }
    }

    .personalHead-box1 {
      width: 90%;
      margin-top: 36upx;
      padding-bottom: 20upx;

      .user-headImg {
        width: 120upx;
        height: 112upx;
        border-radius: 50%;
      }
    }
  }

  .iphoneNumback-box {
    width: 100%;
    background-color: #FFFFFF;
    height: 100upx;
    margin-top: 20upx;

    .iphoneNum-box {
      width: 90%;

      .verifyPhone {
        color: #C5AA7B;
        font-size: 30upx;
        border: 0;
      }
    }
  }

  .exitLoginBut {
    height: 100upx;
    background: #333333;
    color: #FFEBC4;
  }

  .cancellation {
    height: 100rpx;
    margin: 24rpx auto 0;
    display: flex;
    align-items: center;
    justify-content: center;
    color: #C5AA7B;
    font-size: 28rpx;
    background: #FFFFFF;
    border: 3rpx solid #F3F4F5;
  }

  .sexRadio-box {
    width: 520upx;
    height: 328upx;

    .sexRadio {
      margin-top: 30upx;
      padding-bottom: 44upx;
    }
  }

  .headBox {
    margin-bottom: 20rpx;
    background: #FFFFFF;
    padding: 25rpx 0;

    .personalHead-box {
      width: 90%;
      margin: 0 auto;
    }

    .user-headImg {
      width: 120upx;
      height: 112upx;
      border-radius: 50%;
    }
  }
}
</style>
