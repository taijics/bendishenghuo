<!-- 地址列表 -->
<template>
	<view class="container">
		<view v-if="addresListlist.length" class="pad-bot-140 addAddress u-skeleton">
      <u-skeleton
          el-color="#efefef"
          bg-color="#ffffff"
          :loading="loading && isFirstComeIn"
          :animation="true"
      ></u-skeleton>
			<view class="addAddress-content flex-row-plus" v-for="(item, index) in addresListlist" :key="index">
				<!--				<view class="address-hesd">{{item.username1}}</view>-->
				<view class="address-detail" @click="itemTap(item)">
					<view class="userName">
						<text class="u-skeleton-rect receive-name">{{item.receiveName}}</text>
						<text class="font-color-999 mar-left-30 u-skeleton-rect receive-phone">{{item.receivePhone}}</text>
					</view>
					<view class="defaultAD-box flex-items">
            <view class="default-status u-skeleton-rect">
              <text class="def" v-if="item.ifDefault">默认</text>
              <text class="lable font-color-999" v-else-if="item.label!=''">{{item.label}}</text>
            </view>
						<text class="user-address font-color-999 u-skeleton-rect">{{item.receiveAdress}}{{item.address}}</text>
					</view>
				</view>
				<view class="editIcon u-skeleton-rect" @click="editAdress(index, item)"></view>
			</view>
      <slide-loading />
      <view
          class="reachBottom"
          v-if="noMore && topLeft > 300"
      >
        <image
            class="reach-icon"
            :src="`${VUE_APP_STATIC_URL}static/img/reachBottom.png`"
            mode="widthFix"
        ></image>
        <text class="reach-text">这里到底了哦~~</text>
      </view>
		</view>
		<view v-if="isEmpty" class="emptyAddress-box">
			<image class="emptyAddress" :src="`${VUE_APP_STATIC_URL}static/img/noAddress.png`"></image>
			<text>你还没有添加地址哦～</text>
		</view>
		<!-- #ifdef MP-WEIXIN -->
		<view class="wxAddressNBox">
			<view class="flex-items btnBox flex-sp-between">
				<view class="wxAddress btn flex-items flex-center" @click="wxAddFn">
					<image :src="`${VUE_APP_STATIC_URL}static/images/weixin2x.png`"></image>
					<text>微信导入</text>
				</view>
				<view class="addAddressBtn btn" @click="addAddressClick">添加新地址</view>
			</view>
		</view>
		<!-- #endif -->
		<!-- #ifdef H5 || APP-PLUS || MP-ALIPAY -->
		<view class="addAddress-box">
			<view class="addAddress" @click="addAddressClick">添加新地址</view>
		</view>
		<!-- #endif -->
    <!-- 回到顶部 -->
    <ReturnTop :returnTopFlag="returnTopFlag" />
	</view>
</template>

<script setup>
import { ref } from "vue";
import { hidden } from "../../utils/hidden";
import { request } from "../../utils/request";
import API from "../../config/api";
import {onLoad, onBackPress, onReachBottom, onShow, onPageScroll} from "@dcloudio/uni-app";
import { VUE_APP_STATIC_URL } from "@/config/api";
import Bankcard from "./bankcard.vue";

const loading = ref(false);
const isFirstComeIn = ref(true);
const addresList = ref([]);
const headWord = ref('');
const editAddress = ref([]);
const type = ref(0);
const addresListlist = ref();
const page = ref(1);
const pageSize = ref(20);
const loadingType = ref(0);
const addData = ref({});
const returnTopFlag = ref(false); // 返回顶部显示隐藏
const topLeft = ref(0); // 无更多数据显示距离
const noMore = ref(false); // 没有更多数据显示隐藏
const isEmpty = ref(false)

onLoad((options) => {
  type.value = options.type
  addresListlist.value = [{}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}]
  isFirstComeIn.value = true
  page.value = 1
  getAddressData()
})

// onShow(() => {
//
// })

onBackPress((e) => {
  if (e.from === 'navigateBack') {
    return false;
  }
  back();
  return true;
})

onReachBottom((e) => {
	if (!isEmpty.value && noMore.value) {
		uni.stopPullDownRefresh()
	} else {
		page.value = page.value + 1
		getAddressData()
	}
})

const back = () => {
  if (type.value == 1 || type.value == 2 ) {
    uni.navigateTo({
      url: '../../pages_category_page1/orderModule/orderConfirm?type=' + type.value
    })
  } else {
    uni.switchTab({
      url: '../../pages/tabbar/user/index'
    });
  }
}
const addAddressClick = () => {
  if (type.value ==  1 || type.value == 2) {
    uni.navigateTo({
      url: 'addAddress?type=1&ordertype=1'
    })
  } else {
    uni.navigateTo({
      url: 'addAddress?type=1'
    })
  }
}

const getAddressData = () => {
  loading.value = true
  request(API.QueryMemberAddres, {
    page: page.value,
    pageSize: pageSize.value
  }, "GET").then(res => {
    addresList.value = res.data
    for (let i = 0; i < res.data.list.length; i++) {
      addresList.value.list[i].username1 = addresList.value.list[i].receiveName.slice(0, 1)
    }
    addresListlist.value = addresListlist.value.concat(res.data.list).filter(item => JSON.stringify(item) !== '{}')
    addresListlist.value.forEach((item) => {
      item.receivePhone = hidden(item.receivePhone, 3, 4)
    })
    if (addresListlist.value.length === 0) {
      isEmpty.value = true
    }
    if (addresListlist.value.length >= res.data.total) {
      noMore.value = true
    }
  }).catch(err => {
    console.log(err)
  }).finally(() => {
    loading.value = false
    isFirstComeIn.value = false
  })
}

const editAdress = (id, item) => {
  uni.setStorageSync("editAddress", JSON.stringify(addresList.value.list[id]))
  uni.navigateTo({
    url: 'addAddress?type=2&receiveId=' + item.receiveId
  })
}
const itemTap = (item) => {
  if (type.value == 1 || type.value == 2) {
    uni.setStorageSync('receiveItem', item)
    uni.navigateTo({
      url: '../../pages_category_page1/orderModule/orderConfirm?receiveId=' + item
          .receiveId +'&type='+ type.value
    })
  }
}

// 微信导入
const wxAddFn = () => {
  uni.chooseAddress({
    success(res) {
      addData.value['username'] = res.userName
      addData.value['phone'] = res.telNumber
      addData.value['ssqText'] = `${res.provinceName}-${res.cityName}-${res.countyName}`
      addData.value['defaultRegion'] = addData.value['ssqText'].split("-")
      addData.value['address'] = res.detailInfo
      addData.value['province'] = res.provinceName
      addData.value['city'] = res.cityName
      setTimeout(() => {
        uni.hideLoading();
        uni.navigateTo({
          url: 'addAddress?type=3&wxAddressData=' + JSON.stringify(addData.value)
        })
      }, 500);
    },
    fail:(res)=>{
      console.log('err---选择地址',res)
    }
  })
}

onPageScroll(e => {
  returnTopFlag.value = e.scrollTop > 600;
  topLeft.value = e.scrollTop
})
</script>

<style lang="scss">
@import '../../style/images';
	.container {
		padding: 0 24rpx;

		.addAddress {
			border-top: 2rpx solid #F3F4F5;
			padding-top: 30rpx;
		}

		.emptyAddress-box {
			display: flex;
			justify-content: center;
			flex-direction: column;
			align-items: center;
			margin-top: 50%;

			.emptyAddress {
				width: 186upx;
				height: 150upx;
			}

			text {
				margin-top: 40upx;
				color: #999999;
			}
		}

		.addAddress-box {
			position: fixed;
			bottom: 0rpx;
			left: 0upx;
      width: 100%;
      padding: 20rpx 10rpx;
      background: #ffffff;
			.addAddress {
				width: 690upx;
				height: 100upx;
				color: #FFEBC4;
				text-align: center;
				background: #333333;
        margin: 0 auto;
			}
		}

		.wxAddressNBox {
			position: fixed;
			bottom: 0rpx;
			width: 100%;
			left: 0;

			.btnBox {
				width: 100%;
				background: #FFFFFF;
				height: 120rpx;
				padding: 0 50rpx;

				.btn {
					width: 300rpx;
					background: #FFFFFF;
					height: 90rpx;
					line-height: 90rpx;
					border: 2rpx solid #E4E5E6;
					text-align: center;
				}

				.addAddressBtn {
					color: #FFEBC4;
					background: #333333;
					border: 2rpx solid #333333;
				}

				.wxAddress {
					image {
						width: 45rpx;
						height: 37rpx;
						margin-right: 20rpx;
					}
				}
			}
		}

		.addAddress-content {
			display: flex;
			align-items: center;
			justify-content: space-between;
			padding-bottom: 40rpx;
			margin-bottom: 40rpx;
			border-bottom: 2rpx solid #F3F4F5;

			.address-detail {
        flex: 1;
				.userName {
					margin-bottom: 15rpx;
          .receive-name {
            min-width: 50rpx;
            min-height: 40rpx;
            display: inline-block;
          }
          .receive-phone {
            min-width: 200rpx;
            min-height: 40rpx;
            display: inline-block;
          }
				}
			}

			.lable {
				padding: 3rpx 10rpx;
				background: rgba(153, 153, 153, 0.2);
				border-radius: 4rpx;
				font-size: 24rpx;
				font-weight: 500;
				color: rgba(102, 102, 102, 1);
			}

			.def {
				padding: 3rpx 10rpx;
				font-size: 20rpx;
				font-weight: 400;
				color: #C5AA7B !important;
				background: rgba(197, 170, 123, 0.2) !important;
			}

			.user-address {
				font-size: 28rpx;
				margin-left: 10rpx;
        min-width: 300rpx;
        min-height: 44rpx;

			}

			.address-hesd {
				height: 70upx;
				width: 70upx;
				background-color: #BBBBBB;
				color: #FFFFFF;
				border-radius: 50%;
				line-height: 70upx;
				text-align: center;
			}

			.defaultAD-box {
        width: 100%;
        .default-status {
          min-width: 70rpx;
          min-height: 44rpx;
        }
				.default-textBox {
					padding-right: 20upx;
					width: 80upx;
				}

				.default-content {
					width: 435upx;
				}

				.default-text {
					color: #C5AA7B;
					background-color: #FFE4CC;
					height: 36upx;
					width: 60upx;
					font-size: 26upx;
					border-radius: 4upx;
					align-items: center;
					line-height: 36upx;
				}
			}

			.editIcon {
				width: 50rpx;
				height: 50rpx;
				display: block;
				background: $addEdit no-repeat center center;
				background-size: contain;
			}
		}
	}
</style>
