<template>
    <view class="content u-skeleton">
        <!-- 骨架屏 -->
        <Skeleton
                el-color="#efefef"
                bg-color="#fff"
                :loading="loading && isFirstComeIn"
                :animation="true"
        ></Skeleton>
        <!-- 我的 -->
        <image
                class="top-bg"
                :src="`${VUE_APP_STATIC_URL}static/img/user/topBg.png`"
        ></image>
        <view class="page-content" >
            <!-- 用户未登录 -->
            <view
                    class="user-info-box"
                    @click="jumpLogin"
                    v-if="userItem.name===undefined "
            >
                <image
                        class="user-image u-skeleton-circle"
                        :src="`${VUE_APP_STATIC_URL}static/img/user/morentouxiang.png`"
                        mode="widthFix"
                ></image>
                <view class="user-info">
                    <view class="user-logoin-title">
                      <text class="u-skeleton-rect">点击登录</text>
                    </view>
                    <view class="user-logoin-lable">
                      <text class="u-skeleton-rect">登录后享受更多权益~</text>
                    </view>
                </view>
                <image
                        class="user-info-right"
                        :src="`${VUE_APP_STATIC_URL}static/img/user/back.png`"
                ></image>
                <view class="notice u-skeleton-circle">
                    <view
                            class="messNum"
                            v-if="userItem.notRead>0"
                    >{{ userItem.notRead }}
                    </view>
                </view>
            </view>
            <!-- 用户已登陆 -->
            <view
                    class="user-info-box "
                    v-else
            >
                <image
                        class="user-image u-skeleton-rect"
                        @click="handleJump('../../../pages_category_page2/userModule/personalDetails')"
                        v-if="userItem.headImage"
                        :src="userItem.headImage"
                        mode="widthFix"
                        style="border-radius: 50%;"
                ></image>
                <image
                        class="user-image"
                        v-else
                        :src="`${VUE_APP_STATIC_URL}static/img/user/morentouxiang.png`"
                        mode="widthFix"
                >
                </image>
                <view class="user-info">
                    <view
                            class="user-logoin-title"
                            v-if="userItem.name"
                    >{{ userItem.name }}
                    </view>
                    <view
                            class="experience flex-items"
                            @click="handleJump('../../../pages_category_page1/memberCenter/index')"
                    >
                        <label class="growth-value">成长值</label>
                        <view class="experienceValue">{{ userItem.growth || 0 }} / {{ userItem.nextLevelGrowth || 0 }}</view>
                    </view>
                </view>
                <view
                        class="notice u-skeleton-circle"
                        @click="handleJump('../../../pages_category_page2/notice/index')"
                >
                    <view
                            class="messNum"
                            v-if="userItem.notRead+userItem.unreadReply>0"
                    >{{ userItem.notRead + userItem.unreadReply > 99 ? '99+' : userItem.notRead + userItem.unreadReply }}
                    </view>
                </view>
            </view>
            <!-- 订单卡片 -->
            <view class="order-box">
                <view
                        class="order-item"
                        v-for="orderCardItem in orderCardListRef"
                        :key="orderCardItem.id"
                        @click="handleJump(orderCardItem.jumpUrl)"
                >
                    <image
                            class="order-item-image  u-skeleton-circle"
                            :src="orderCardItem.icon"
                            mode="widthFix"
                    >
                    </image>
                    <view class="order-item-text u-skeleton-rect">{{ orderCardItem.label }}</view>
                    <view
                            class="quan"
                            v-if="userItem[orderCardItem.key]>0"
                    >
                        {{ userItem[orderCardItem.key] }}
                    </view>
                </view>
            </view>
            <!-- 第一个卡片 -->
            <view class="itemBox">
                <view
                        class="item-btn"
                        v-for="item in fastCardOneListRef"
                        :key="item.id"
                        @click="handleJump(item.jumpUrl)"
                >
                    <image
                            class="item-btn-icon u-skeleton-circle"
                            :src="item.icon"
                            mode="widthFix"
                    >
                    </image>
                    <view class="item-btn-text u-skeleton-rect">{{ item.label }}</view>
                </view>
            </view>
            <!-- 第二个卡片 -->
            <view class="itemBox">
                <view
                        class="item-btn"
                        v-for="item in fastCardTwoListRef"
                        :key="item.id"
                        @click="handleJump(item.jumpUrl)"
                >
                    <image
                            class="item-btn-icon u-skeleton-circle"
                            :src="item.icon"
                            mode="widthFix"
                    ></image>
                    <view class="item-btn-text u-skeleton-rect">{{ item.label }}</view>
                </view>
                <!--        <button open-type="contact"
                                class="item-btn btnNone">
                          <image class="item-btn-icon"
                                 :src="`${VUE_APP_STATIC_URL}static/img/user/service.png`"
                                 mode="widthFix"></image>
                          <view class="item-btn-text">平台客服</view>
                        </button>-->
            </view>
        </view>
        <view class="copyright">
            <text >中科鑫智 版权所有</text>
            <text >粤ICP备19086489号-3</text>
        </view>
    </view>
</template>

<script setup>
import {ref, onMounted, inject, nextTick} from 'vue';
import Skeleton from "../../../components/Skeleton";
import { fastCardOneList, fastCardTwoList, orderCardList } from "./index.data";
import { Services } from '@/utils/services'
// import { Encrypt } from '@/utils/secret'
import {request} from "@/utils/request";
import API from "../../../config/api";
import { Encrypt } from "@/utils/secret";
import {onShow} from "@dcloudio/uni-app";
import { VUE_APP_STATIC_URL } from "@/config/api";

const isFirstComeIn = ref(true);
const loading = ref(true);
const orderCardListRef = ref(orderCardList);
const fastCardOneListRef = ref(fastCardOneList);
const fastCardTwoListRef = ref(fastCardTwoList);
const cacheUserItem = ref({});
const userItem = ref({
  headImage: '',
  name: undefined
});
const $jump = inject('$jump')

onShow(() => {
  nextTick(() => {
    if (uni.getStorageSync('storage_key')) {
      cacheUserItem.value = uni.getStorageSync('storage_key');
    } else {
      isFirstComeIn.value = true;
    }
    handleGetUser();
  })
})

const handleJump = (url) => {
  if (JSON.stringify(cacheUserItem.value) === '{}') {
    return true
  }
  if (url.startsWith('function')) {
    const [key, funcName] = url.split(':')
    functionObj[funcName]()
  } else {
      $jump(url)
  }
}
const handleGetUser = () => {
  loading.value = true
  request(API.GetUser, {}, 'GET').then(res => {
    userItem.value = res.data
    uni.setStorageSync('storage_userInfo', userItem.value);
    isFirstComeIn.value = false
    loading.value = true
  })
}

const jumpLogin = () => {
  uni.navigateTo({
    url: '../../../pages_category_page2/userModule/login'
  })
}

const flyToService = async () => {
  (await Services()).flyToService();
}

const handleApplySettle = () => {
  const res = uni.getStorageSync('storage_key');
  let token = Encrypt(res.token)
  let username = userItem.value.name
  let url = null
  // #ifdef H5
  console.log('h5 test')
  window.location.href = API.SettledMerchantPrefix + `/#/?username=${ username }&user=${ token }`
  // #endif
  // #ifdef APP-PLUS
  plus.runtime.openURL(API.SettledMerchantPrefix + `/#/?username=${ username }&user=${ token }`, function (e) {
    console.log(e);
  })
  // #endif
  // #ifdef MP-WEIXIN
  url = API.SettledMerchantPrefix
  uni.navigateTo({
    url: `../../../pages_category_page1/linkOthers/index?url=${ url }&username=${ username }&user=${ token }`
    // 此处的链接为小程序上面新建的webview页面路径，参数url为要跳转外链的地址
    // url: '../../../pages_category_page1/linkOthers/index?url=' + encodeURIComponent(url)
    // url:'../../../pages_category_page2/userModule/coupon'
  })
  // #endif
  // #ifdef MP-ALIPAY
  url = API.SettledMerchantPrefix
  uni.navigateTo({
    url: `../../../pages_category_page1/linkOthers/index?url=${ url }&username=${ username }&user=${ token }`
    // 此处的链接为小程序上面新建的webview页面路径，参数url为要跳转外链的地址
    // url: '../../../pages_category_page1/linkOthers/index?url=' + encodeURIComponent(url)
    // url:'../../../pages_category_page2/userModule/coupon'
  })
  // #endif
}
const functionObj={
  handleApplySettle,
  flyToService
}
</script>

<style lang="scss">
@import "../../../style/images";
page {
  background: #f8f8f8;
}

.content {
  height: 100%;
  position: relative;
  padding-bottom: 150rpx;
  width: 100%;
  .itemBox {
    display: flex;
    flex-flow: wrap;
    padding-top: 30rpx;
    background: #FFFFFF;
    width: 690rpx;
    margin: 30rpx auto 0 auto;
  }

  /* background-color: #f8f8f8; */
  .top-bg {
    width: 100%;
    height: 400rpx;
    margin-top: -50rpx;
  }

  .page-content {
    width: 100%;
    height: 100%;
    display: flex;
    flex-direction: column;
    z-index: 10;
    margin-top: -320upx;

    .user-info-box {
      width: 100%;
      box-sizing: border-box;
      padding: 30upx;
      display: flex;
      flex-direction: row;
      align-items: center;
      position: relative;

      .notice {
        width: 60rpx;
        height: 60rpx;
        position: absolute;
        top: 0;
        right: 50rpx;
        background: $notice no-repeat center center;
        background-size: contain;

        .messNum {
          background: #C83732;
          border-radius: 50%;
          color: #FFFFFF;
          text-align: center;
          margin: 0rpx 0 0 30rpx;
          width: 30rpx;
          height: 30rpx;
          line-height: 30rpx;
          font-size: 20rpx;
        }
      }

      .user-image {
        width: 126upx;
        height: 126upx;
      }

      .user-info {
        flex: 1;
        display: flex;
        flex-direction: column;
        padding-left: 20upx;
        box-sizing: border-box;
        z-index: 10;

        .user-logoin-title {
          font-size: 36upx;
          font-weight: 500;
          color: rgba(255, 255, 255, 1);
        }

        .user-logoin-lable {
          font-size: 24upx;
          font-weight: 400;
          color: rgba(255, 255, 255, 1);
          margin-top: 20upx;
        }

        .experience {
          label {
            font-size: 26rpx;
            color: #FFFFFF;
            opacity: 0.7;
          }

          .experienceValue {
            width: auto;
            padding: 0 28rpx;
            height: 40rpx;
            font-weight: 400;
            color: #FFFFFF;
            border-radius: 25rpx;
            line-height: 40rpx;
            border: 2rpx solid rgba(0, 0, 0, 0);
            background: linear-gradient(88deg, #C5AA7B 0%, #F5DEB2 100%);
            font-size: 20rpx;
            margin-left: 20rpx;
          }
        }
      }

      .user-info-right {
        width: 30upx;
        height: 30upx;
      }
    }

    .order-box {
      width: 690upx;
      height: 196upx !important;
      background: rgba(255, 255, 255, 1);
      box-shadow: 0px 0px 10upx 0px rgba(51, 51, 51, 0.1);
      display: flex;
      flex-direction: row;
      align-items: center;
      margin-left: 30upx;
      z-index: 10;

      .order-item {
        flex: 1;
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        position: relative;

        .quan {
          position: absolute;
          right: 40upx;
          top: 10upx;
          border: 1px solid red;
          color: #FFFFFF;
          background-color: red;
          border-radius: 50%;
          font-size: 16rpx;
          width: 30upx;
          height: 30upx;
          line-height: 30upx;
          text-align: center;
        }

        .order-item-image {
          width: 90upx;
          height: 90upx;
        }

        .order-item-text {
          font-size: 28upx;
          margin-top: 10upx;
          font-weight: 500;
          color: rgba(102, 102, 102, 1);
        }
      }
    }

    .item-btn {
      width: 25%;
      box-sizing: border-box;
      background-color: #fff;
      text-align: center;
      margin-bottom: 40rpx;

      .item-btn-icon {
        width: 90upx;
        height: 90upx !important;
        display: block;
        margin: 0 auto;
      }

      .item-btn-text {
        font-size: 28upx;
        font-weight: 500;
        flex: 1;
        color: rgba(102, 102, 102, 1);
        display: inline-block;
        min-width: 120rpx;
        margin-top: 10rpx;
      }

      .messNum {
        margin-left: 10rpx;
        font-size: 16rpx;
        background-color: red;
        color: #FFFFFF;
        width: 30rpx;
        height: 30rpx;
        border-radius: 50%;
        margin-top: -5rpx;
        line-height: 30rpx;
        text-align: center;
      }

      .item-btn-right {
        width: 24upx;
        height: 24upx;
      }

    }

    .btnNone {
      margin: 0;
      padding: 0;
      line-height: normal;

      &::after {
        display: none;
      }
    }

    .mt20 {
      margin-top: 20upx;
    }

    .mt1 {
      margin-top: 1upx;
    }
  }

  .copyright {
    text-align: center;
    padding: 30rpx 0 20rpx;
    position: absolute;
    bottom: 0;
    left: 0;
    width: 100%;

    text {
      display: block;
      font-size: 20rpx;
      line-height: 30rpx;
      color: #C5CACF;
    }
  }
}
</style>
