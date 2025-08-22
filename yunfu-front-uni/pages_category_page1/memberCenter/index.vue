<template>
  <view>
    <view
        class="memberCenter"
        v-if="isShow"
    >
      <view
          class="memberBg"
          :style="{backgroundImage:'url('+memberListData[activeIndex].memberLevelBackground+')', 'padding-top': paddingTop + 'px'}"
      >
        <view
            class="member-top"
            :style="{'top': topHeight + 'px'}"
        >
          <view class="memberTopInfo">
            <view class="backBox">
              <image
                  :src="`${VUE_APP_STATIC_URL}static/images/back_img04.png`"
                  class="back"
                  @click="back"
              ></image>
            </view>
            <view class="memberTit fs30 font-color-FFF">会员中心</view>
          </view>
        </view>
        <view class="memberBox">
          <view class="posBox">
            <view class="memberBoxTop">
              <view class="memberTopPos">
                <swiper
                    class="swiper pro-box"
                    next-margin="30rpx"
                    previous-margin="30rpx"
                    :current="activeIndex"
                    :indicator-dots="false"
                    :autoplay="false"
                    @change="swiperChange"
                >
                  <swiper-item
                      class="pro-item-warp"
                      v-for="(item, index) in memberListData"
                      :key="index"
                  >
                    <view class="box">
                      <view
                          class="memberTopBg"
                          :style="{backgroundImage:'url('+item.memberLevelBackground+')'}"
                      >
                        <view class="flex-display flex-sp-between">
                          <view class="nameBox">
                            <view class="name fs36">{{ memberData.name }}</view>
                            <view class="level">
                              <image :src="item.memberLevelIcon"></image>
                            </view>
                          </view>
                          <view class="avatarBox">
                            <image :src="memberData.headImage"></image>
                          </view>
                        </view>
                        <view class="growing">
                          <view class="growingValue flex-display flex-sp-between">
                            <label class="fs24 fs-weight-400 font-color-333">当前会员成长值
                              {{ memberData.growth }}</label>
                            <label
                                class="fs24 fs-weight-400 font-color-333 mar-left-20"
                                v-if="nextGrowth !== 0 && nextGrowth !== item.growth"
                            >{{ nextGrowth }}</label>
                          </view>
                          <view
                              class="progressBar"
                              v-if="memberData.growth < nextGrowth"
                          >
                            <view style="width: 100%">
                              <progress
                                  activeColor="#FFEBC4"
                                  :percent="getPercent(memberData.growth, nextGrowth)"
                                  active
                                  stroke-width="2"
                              />
                            </view>
                          </view>
                          <view
                              class="currentName"
                              v-else
                          >
                            以超越该等级
                          </view>
                          <!--                      <view class="flex-display flex-sp-between">-->
                          <!--                        <label class="fs24 font-color-71521B">{{memberData.memberLevelName}}</label>-->
                          <!--                        <label class="fs24 font-color-71521B">{{memberData.nextLevelName}}</label>-->
                          <!--                      </view>-->
                        </view>
                      </view>
                    </view>
                  </swiper-item>
                </swiper>
              </view>
            </view>
          </view>
        </view>
        <view class="equity">
          <view class="equityBox">
            <view class="equityTit">我的权益</view>
            <view class="equityList">
              <view
                  class="equityItem"
                  v-for="item of equityList"
                  :key="item.memberId"
              >
                <image :src="item.memberIcon"></image>
                <view class="fs26">{{ item.memberName }}</view>
              </view>
            </view>
          </view>
        </view>
        <view class="signIn">
          <view class="signInList">
            <view class="signTit fs30 font-color-333">快速成长</view>
            <view class="signInBox">
              <view class="signItem flex-items flex-sp-between">
                <view class="itemLeft flex-items">
                  <view class="leftIcon">
                    <image :src="`${VUE_APP_STATIC_URL}static/img/member/memberList2.png`"></image>
                  </view>
                  <view class="leftInfo">
                    <label class="fs28 font-color-333">购物</label>
                    <view class="fs24 font-color-999">购买商品获取相应成长值</view>
                  </view>
                </view>
                <view
                    class="rightBtn"
                    @click="goToShopping"
                >去购物
                </view>
              </view>
            </view>
          </view>
        </view>
      </view>
    </view>
  </view>
</template>

<script setup>
import { ref, onMounted } from "vue";
import { onLoad } from '@dcloudio/uni-app';
import { request } from '../../utils/request'
import API from "../../config/api";
import { VUE_APP_STATIC_URL } from "@/config/api";

const memberData = ref({});
const equityList = ref([]);
const levelInfo = ref({});
const isShow = ref(false);
const memberListData = ref([]);
const nextGrowth = ref(0);
const activeIndex = ref(0);
const topHeight = ref(10);
const paddingTop = ref(50);

onMounted(() => {
// #ifdef MP-WEIXIN || MP-BAIDU || MP-TOUTIAO || MP-QQ
  let menuButtonInfo = uni.getMenuButtonBoundingClientRect()
  topHeight.value = menuButtonInfo.top
  paddingTop.value = paddingTop.value + topHeight.value
  // #endif
  // #ifdef APP
  topHeight.value = 50
  paddingTop.value = 100
  // #endif

  // 定时器防止app一开始进入时页面混乱问题
  setTimeout(() => {
    getMemberShipList()
  }, 200)
  memberData.value = uni.getStorageSync('storage_userInfo');
  getMemberByMemberLevel()
  getMemberList()
})

const swiperChange = (item) => {
  console.log(item.detail.current, 'index')
  activeIndex.value = item.detail.current
  console.log(typeof activeIndex.value, typeof (memberListData.value.length - 1))
  let num = 0
  num = activeIndex.value + 1
  if (num === memberListData.value.length) {
    nextGrowth.value = memberListData.value[activeIndex.value].growth
  } else {
    console.log('caonima')
    nextGrowth.value = memberListData.value[activeIndex.value + 1].growth
  }
  equityList.value = memberListData.value[activeIndex.value].membershipList
}

const getMemberList = () => {
  request(API.memberList, {}, 'GET').then(res => {
    memberListData.value = res.data
    memberListData.value.forEach((item, index) => {
      if (item.memberLevelId === memberData.value.memberLevelId) {
        activeIndex.value = index
        let num = 0
        num = activeIndex.value + 1
        if (num === memberListData.value.length) {
          nextGrowth.value = memberListData.value[activeIndex.value].growth
        } else {
          nextGrowth.value = memberListData.value[activeIndex.value + 1].growth
        }
        equityList.value = memberListData.value[activeIndex.value].membershipList
      }
    })
  }).catch(res => {
  })
}

const getMemberShipList = async () => {
  // 获取会员信息
  try {
    const res = await request(API.getMemberShipList, {}, 'GET')
    uni.hideLoading()
    equityList.value = res.data
    isShow.value = true
  } catch (err) {
  }
}
// 去首页
const goToShopping = () => {
  uni.switchTab({
    url: '../../pages/tabbar/index/index'
  })
}

const getPercent = (num, total) => {
  num = parseFloat(num);
  total = parseFloat(total);
  if (isNaN(num) || isNaN(total)) {
    return "-";
  }
  return total <= 0 ? "0%" : Math.round((num / total) * 10000) / 100.0;
}

// 获取会员等级
const getMemberByMemberLevel = async () => {
  try {
    const res = request(`${ API.getMemberByMemberLevel }/${ memberData.value.memberLevelId }`, {}, 'GET')
    levelInfo.value = res.data
    uni.setStorageSync('storage_levelInfo', levelInfo.value)
  } catch (err) {
  }
}
// 返回上一级
const back = () => {
  uni.navigateBack()
}
</script>

<style
    lang="scss"
    scoped
>
.memberCenter {
  background-size: contain;
  min-height: 800rpx;

  .memberBg {
    background-repeat: no-repeat;
    padding-top: 50rpx;
  }

  .memberBox {
    width: 100%;
    //background: #523e3a;
    border-radius: 25rpx;
    background-size: contain;
    position: relative;
    box-sizing: border-box;

    .memberBoxTop {
      position: relative;

      .memberTopPos {
        overflow: hidden;

        .pro-box {
          height: 300rpx;
        }

        .swiper {
          .box {
            height: 300rpx;
            padding: 4rpx 10rpx;
          }
        }
      }

      .memberTopBg {
        background-size: cover;
        background-repeat: no-repeat;
        border-radius: 30rpx;
        padding: 40rpx 30rpx 30rpx 30rpx;
        box-shadow: 0 0 5rpx rgba(90, 90, 90, .5);
        height: 290rpx;

        .currentName {
          font-size: 26rpx;
          margin-top: 50rpx;
          color: #71521B;
        }
      }
    }

    .avatarBox {
      image {
        width: 110rpx;
        height: 110rpx;
        border: 5rpx solid #FFFFFF;
        border-radius: 50%;
      }
    }

    .nameBox {
      .name {
        color: #333333;
        margin-right: 30rpx;
        margin-bottom: 10rpx;
      }

      .level {
        image {
          width: 172rpx;
          height: 50rpx;
        }
      }
    }

    .growing {
      .growingValue {
        margin-top: 30rpx;
      }

      .progressBar {
        height: 20rpx;
        width: 100%;
        margin: 20rpx 0;
      }
    }
  }

  .equity {
    border-radius: 25rpx 25rpx 0 0;
    padding: 30rpx;
    background: #F8F8F8;
    margin-top: 50rpx;

    .equityBox {
      background: #FFFFFF;
      min-height: 326rpx;
      border-radius: 20rpx;
      padding: 10rpx 30rpx 30rpx 30rpx;

      .equityTit {
        font-weight: bold;
        height: 92rpx;
        line-height: 92rpx;
      }

      .equityList {
        border-top: 2rpx solid #F3F4F5;
        display: flex;
        flex-flow: wrap;
        padding-top: 30rpx;
        text-align: center;

        .equityItem {
          width: 25%;
          color: #666666;

          image {
            width: 92rpx;
            height: 92rpx;
          }
        }
      }
    }
  }

  .signIn {
    padding: 0 30rpx 30rpx 30rpx;
    background: #F8F8F8;

    .signInList {
      background: #FFFFFF;
      border-radius: 20rpx;
      padding: 0 30rpx 30rpx 30rpx;

      .signTit {
        font-weight: bold;
        height: 92rpx;
        line-height: 92rpx;
      }

      .signInBox {
        .signItem {
          border-top: 2rpx solid #F3F4F5;
          padding: 30rpx 0;

          .itemLeft {
            image {
              width: 92rpx;
              height: 92rpx;
              margin-right: 30rpx;
            }
          }
        }

        .rightBtn {
          width: 160rpx;
          height: 58rpx;
          line-height: 58rpx;
          background: #333333;
          border-radius: 10rpx;
          color: #FFEBC4;
          text-align: center;
        }
      }
    }
  }

  .member-top {
    width: 100%;
    position: fixed;
    z-index: 99;
    left: 0;

    .memberTopInfo {
      position: relative;
      width: 100%;
      height: 60rpx;
      display: flex;
      align-items: center;
      justify-content: center;
    }

    .backBox {
      position: absolute;
      left: 10rpx;
      top: 0rpx;

      .back {
        width: 50rpx;
        height: 50rpx;
        padding: 0rpx 10rpx;
      }
    }
  }
}
</style>
<style>
page {
  background: #F8F8F8;
}

.progressBar /deep/ .uni-progress-bar {
  background-color: rgb(235, 235, 235, 0.6) !important;
  height: 5rpx !important;
  border-radius: 22rpx;
}

.progressBar /deep/ .uni-progress-bar .uni-progress-inner-bar {
  border-radius: 22rpx;
}
</style>
