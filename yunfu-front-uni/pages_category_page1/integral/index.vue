<template>
  <view class="memberCenter" v-if="ifShow">
    <global-loading />
    <view class="memberBox">
      <view class="posBox">
        <view class="memberBoxTop">
          <view class="memberTopPos" :style="{backgroundImage:'url('+levelInfo.memberLevelBackground+')'}">
            <view class="memberTopBg">
              <view class="flex-items">
                <view class="avatarBox">
                  <image :src="memberData.headImage"></image>
                </view>
                <view class="nameBox">
                  <view class="name fs36">{{memberData.name}}</view>
                  <view class="level">
                    <image :src="levelInfo.memberLevelIcon"></image>
                  </view>
                </view>
              </view>
              <view class="integralInfo flex-items flex-sp-between mar-top-20">
                <view class="itemBox">
                  <view class="integraNum fs32 font-color-333 fs-weight-400">{{ memberData.totalCredit }}</view>
                  <view class="fs24 font-color-333 fs-weight-400">累计积分</view>
                </view>
                <view class="itemBox">
                  <view class="integraNum fs32 font-color-333 fs-weight-400">{{ memberData.totalCredit - memberData.credit }}</view>
                  <view class="fs24 font-color-333 fs-weight-400">累计消费</view>
                </view>
                <view class="itemBox">
                  <view class="integraNum fs32 font-color-333 fs-weight-400">{{ memberData.credit }}</view>
                  <view class="fs24 font-color-333 fs-weight-400">剩余积分</view>
                </view>
              </view>
            </view>
          </view>
        </view>
      </view>
    </view>
    <view class="signBox flex-items flex-sp-between mar-top-30" @click="goToSign">
      <view class="signLeft flex-items flex-sp-between">
        <view class="signIcon"></view>
        <view class="signText fs28 font-color-C5AA7B">积分签到</view>
      </view>
      <view class="u-arrow u-arrow-right"></view>
    </view>
    <view class="signTabs mar-top-30 flex-items">
      <view :class="{active: tabActive === 1}" class="tabItem flex-items flex-center" @click="changeTab(1)">
        <view class="icon detailIcon"></view>
        <text>积分明细</text>
      </view>
      <view :class="{active: tabActive === 2}" class="tabItem flex-items flex-center" @click="changeTab(2)">
        <view class="icon exchangeIcon"></view>
        <text>积分兑换</text>
      </view>
    </view>
    <view class="signInfo mar-top-20" v-if="tabActive === 1">
      <view class="signInBox">
        <view class="signItem flex-items flex-sp-between" v-for="(item, index) of integralRecord" :key="index">
          <view class="leftBox flex-items">
            <image :src="`${VUE_APP_STATIC_URL}static/images/signIcon1.png`"></image>
            <view class="leftInfo">
              <label class="fs28 font-color-333">{{item.recordContent}}</label>
              <view class="fs24 font-color-999">{{item.createTime}}</view>
            </view>
          </view>
          <view class="rightBtn">{{item.recordType === 1 ? '+' : '-'}}{{item.credit}}</view>
        </view>
        <view class="emptyCart-box flex-items-plus flex-column" v-if="integralRecord.length === 0">
          <image class="emptyCart-img" :src="`${VUE_APP_STATIC_URL}static/images/searchEmpty.png`"></image>
          <label class="font-color-999 fs26 mar-top-30">暂无记录~</label>
        </view>
      </view>
    </view>
    <view class="signExchange mar-top-20" v-else>
      <view class="exchangeInfoBox">
        <view class="exchangeItem flex-items flex-sp-between" v-for="(item, index) of creditCouponList" :key="index" @click="goExchangeDetail(item)">
          <view class="exchangeLeft flex-items">
            <view class="discountBox mar-right-20">
              <view class="fs24" v-if="item.couponType === 1">{{item.fullMoney === 0 ? `无门槛减${item.reduceMoney}元` : `满${item.fullMoney}元减${item.reduceMoney}元`}}</view>
              <view class="fs24" v-else>{{item.fullMoney === 0 ? `无门槛打${item.reduceMoney}折` : `满${item.fullMoney}元打${item.reduceMoney}折`}}</view>
              <view class="fs30">{{item.couponType === 1 ? '满减券' : '折扣券'}}</view>
            </view>
            <view class="exchangeInfo">
              <view class="fs28 font-color-333" v-if="item.couponType === 1">{{item.fullMoney === 0 ? `无门槛减${item.reduceMoney}元` : `满${item.fullMoney}元减${item.reduceMoney}元`}}</view>
              <view class="fs28 font-color-333" v-else>{{item.fullMoney === 0 ? `无门槛打${item.reduceMoney}折` : `满${item.fullMoney}元打${item.reduceMoney}折`}}</view>
              <view class="fs24 state" v-if="item.stockNumber > 0">还剩{{item.stockNumber}}个</view>
              <view class="fs24 state finish" v-else>已兑完</view>
              <view class="integral fs32">{{ item.credit }}积分</view>
            </view>
          </view>
          <view class="exchangeRight">
            <view class="exchangeBtn fs28 font-color-FFF" v-if="item.state === 0 && item.stockNumber !== 0" @click="goExchangeDetail(item)">兑换</view>
            <view class="exchangeBtn available fs28 font-color-FFF" v-if="item.stockNumber === 0">已兑完</view>
            <view class="exchangeBtn available fs28 font-color-FFF" v-if="item.state === 1">已兑换</view>
          </view>
        </view>
        <view class="emptyCart-box flex-items-plus flex-column" v-if="creditCouponList.length === 0">
          <image class="emptyCart-img" :src="`${VUE_APP_STATIC_URL}static/images/searchEmpty.png`"></image>
          <label class="font-color-999 fs26 mar-top-30">暂无优惠券~</label>
        </view>
      </view>
    </view>
    <tui-modal :show="isConvertible" :custom="true" :fadein="true">
      <view class="Put-box1">
        <view class="text-align fs34 fs-bold">
          温馨提示
        </view>
        <view class="mar-top-40 text-align">
          您的积分不够哦，请获取更多的积分!
        </view>
        <view class="flex-display flex-sp-between">
          <view class="btn" @click="goToSign">
            去签到
          </view>
        </view>
        <view v-if="isConvertible" @click="isConvertible = false" class="cancelDel">
          <image :src="`${VUE_APP_STATIC_URL}static/images/cancelClose.png`" mode=""></image>
        </view>
      </view>
    </tui-modal>
  </view>
</template>

<script setup>
import { ref, onMounted } from "vue"
import tuiModal from "@/components/modal/modal"
import { request } from "../../utils/request"
import API from "../../config/api"
import { onLoad } from "@dcloudio/uni-app"
import { VUE_APP_STATIC_URL } from "@/config/api";

const memberData = ref({})
const equityList = ref([])
const integralRecord = ref([])
const creditCouponList = ref([])
const levelInfo = ref({})
const tabActive = ref(1)
const isConvertible = ref(false)
const integralInfo = ref({
  page: 1,
  pageSize: 10,
  session: ""
})
const couponListInfo = ref({
  page: 1,
  pageSize: 10,
  session: ""
})
const ifShow = ref(false);

onLoad((option) => {
  memberData.value = uni.getStorageSync('storage_userInfo');
  GetUser()
  if (option.tabActive) {
    tabActive.value = parseInt(option.tabActive)
  }
  getIntegralList()
  getCreditCouponList()
  getMemberByMemberLevel()
})
const GetUser = async () => {
  try {
    const res = await request(API.GetUser, {}, 'GET')
    memberData.value = res.data
    uni.setStorageSync('storage_userInfo', memberData.value);
  } catch (err) {
  }
}
const getIntegralList = async () => {
  try {
    const res = await request(API.selectCreditRecord, integralInfo.value, 'POST')
    ifShow.value = true
    integralRecord.value = res.data.list
  } catch (err) {
    throw Error(err)
  }
}

// 获取可兑换优惠券列表
const getCreditCouponList = async () => {
  request(API.selectCreditCouponList, couponListInfo.value, 'POST').then(res => {
    creditCouponList.value = res.data.list
  }).catch(res => {
    throw Error(res)
  })
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
  return total <= 0? "0%" : Math.round((num / total) * 10000) / 100.0;
}
// 获取会员等级
const getMemberByMemberLevel = async () => {
  try {
    const res = await request(`${API.getMemberByMemberLevel}/${memberData.value.memberLevelId}`,{}, 'GET')
    levelInfo.value = res.data
    uni.setStorageSync('storage_levelInfo', levelInfo.value);
  } catch (err) {
  }
}

// 签到
const goToSign = () => {
  uni.navigateTo({
    url: '../../pages_category_page1/integral/sign'
  })
}
// 跳转到兑换优惠详情
const goExchangeDetail = (item) => {
  console.log(item, 'test')
  if (memberData.value.credit < item.credit) {
    isConvertible.value = true
  } else {
    uni.navigateTo({
      url: `../integral/exchangeDetail?data=${JSON.stringify(item)}`
    })
  }
}
// 切换tab
const changeTab = (type) => {
  tabActive.value = type
}
</script>

<style lang="scss" scoped>
@import "../../style/images";
page {
  background: #F8F8F8;
}
.memberCenter {
  border-top: 2rpx solid #4b4b4b;
  background: $addBankBg no-repeat left top;
  background-size: contain;
  min-height: 800rpx;
  padding: 0 20rpx;
  .memberBox {
    min-height: 230rpx;
    margin-top: 120rpx;
    width: 100%;
    border-radius: 25rpx;
    background-size: contain;
    position: relative;
    box-sizing: border-box;
    .posBox {
      position: absolute;
      width: 100%;
      left: 0;
      top: -80rpx;
    }
    .memberBoxTop {
      position: relative;
      .memberTopPos{
        background-size: cover;
        height: 302rpx;
        border-radius: 24rpx;
        box-shadow: 0 0 20rpx rgba(0, 0, 0, 0.05);
        .memberTopBg {
          padding: 40rpx 30rpx;
          .integralInfo {
            padding: 0 50rpx;
            .itemBox {
              text-align: center;
            }
          }
        }
      }
    }
    .avatarBox {
      margin-left: 30rpx;
      image {
        width: 110rpx;
        height: 110rpx;
        border: 5rpx solid #FFFFFF;
        border-radius: 50%;
      }
    }
    .nameBox {
      margin-left: 20rpx;
      .name {
        color: #333333;
        margin-right: 30rpx;
      }
      .level {
        image {
          width: 172rpx;
          height: 50rpx;
        }
      }
    }
  }
  .signBox {
    background: #f9f6ed;
    height: 96rpx;
    border-radius: 24rpx;
    padding: 0 20rpx;
    .signLeft {
      .signIcon {
        background: $signIcon no-repeat center left;
        background-size: contain;
        height: 120rpx;
        width: 96rpx;
        margin-right: 20rpx;
      }
    }
    .u-arrow {
      width: 24rpx;
      height: 24rpx;
      border-top: 3rpx solid #C5AA7B;
      border-right: 3rpx solid #C5AA7B;
    }
  }
  .signTabs {
    .tabItem {
      width: 50%;
      height: 96rpx;
      border-radius: 16rpx;
      text {
        color: #999999;
        font-size: 28rpx;
      }
      .icon {
        width: 40rpx;
        height: 40rpx;
        margin-right: 15rpx;
      }
      .detailIcon {
        background: $detailIcon no-repeat center center;
        background-size: contain;
      }
      .exchangeIcon {
        background:$exchangeIcon no-repeat center center;
        background-size: contain;
      }
    }
    .active {
      background: #333333;
      .detailIcon {
        background: $detailIcon1 no-repeat center center;
        background-size: contain;
      }
      .exchangeIcon {
        background: $exchangeIcon1 no-repeat center center;
        background-size: contain;
      }
      text {
        color: #FFEBC4;
      }
    }
  }
  .signInfo {
    background: #FFFFFF;
    border-radius: 16rpx;
    box-shadow: 0 0 20rpx rgba(0, 0, 0, 0.05);
    padding: 30rpx;
    .signInBox {
      .signItem {
        border-top: 2rpx solid #F3F4F5;
        padding: 30rpx 0;
        .leftBox {
          image {
            width: 90rpx;
            height: 90rpx;
            margin-right: 30rpx;
          }
        }
      }
      .signItem:first-child {
        border-top: none;
      }
      .rightBtn {
        width: 160rpx;
        height: 58rpx;
        line-height: 58rpx;
        background: #FFF9F6;
        border-radius: 10rpx;
        color: #C83732;
        text-align: center;
        font-weight: 300;
        font-size: 24rpx;
      }
    }
  }
  .signExchange {
    box-shadow: 0 0 20rpx rgba(0, 0, 0, 0.05);
    background: #FFFFFF;
    border-radius: 16rpx;
    padding: 40rpx 30rpx;
    .exchangeInfoBox {
      .exchangeItem {
        padding-bottom: 20rpx;
        margin-bottom: 20rpx;
        border-bottom: 2rpx #F3F4F5 solid;
        .exchangeLeft {
          .discountBox {
            color: #FDFED6;
            width: 300rpx;
            height: 146rpx;
            background: $exchangeItem no-repeat left top;
            background-size: contain;
            padding: 30rpx 25rpx;
          }
          .exchangeInfo {
            .state {
              text-align: center;
              background: #333333;
              color: #FFEBC4;
              font-size: 24rpx;
              margin: 8rpx 0 4rpx 0;
              padding: 8rpx 14rpx;
              border-radius: 8rpx;
            }
            .finish {
              color: #CCCCCC;
              border: 2rpx solid #CCCCCC;
              background: none;
            }
            .integral {
              color: #D72E2E;
            }
          }
        }
        .exchangeRight {
          height: 146rpx;
          display: flex;
          flex-direction: column;
          justify-content: flex-end;
          .exchangeBtn {
            width: 120rpx;
            height: 48rpx;
            line-height: 48rpx;
            text-align: center;
            background: linear-gradient(90deg, #C83732 0%, #E25C44 100%);
            box-shadow: 0 6rpx 12rpx rgba(233, 0, 0, 0.3);
            border-radius: 24rpx;
          }
          .available {
            background: linear-gradient(90deg, #C83732 0%, #E25C44 100%);
            box-shadow: 0 6rpx 12rpx rgba(233, 0, 0, 0.3);
          }
        }
      }
      .exchangeItem:last-child {
        border-bottom: none;
      }
    }
  }
  .cancelDel {
    position: absolute;
    bottom: -100rpx;
    left: 45%;

    image {
      width: 60upx;
      height: 60upx;

    }
  }
  .Put-box1 {
    .btn {
      margin-top: 50rpx;
      width: 100%;
      height: 84rpx;
      line-height: 84rpx;
      text-align: center;
      background: #333333;
      color: #FFEBC4;
    }
  }
  .emptyCart-box{
    margin: 60upx 0;
    .emptyCart-img{
      width: 113upx;
      height: 98upx;
    }
  }
}
</style>

