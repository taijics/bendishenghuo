<template>
	<view class="memberCenter">
    <global-loading />

    <view class="avatarTop">
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
		<view class="signInfoBox">
			<view class="accumulate flex-items flex-sp-between">
				<view class="accumulateTit">
					<label class="fs6">已累计签到</label>
					<text class="fs6">{{signDate}}天</text>
				</view>
				<view class="toSignBtn fs24" :class="{active: currentData === upDate}" @click="signInFn">
					{{ currentData === upDate ? '已签到' : '立即签到'}}</view>
			</view>
			<view class="points">
				<label>{{currentData === upDate ? '明' : '今'}}日签到可获得<text>{{recordList.length === 0 ? '10积分' : ''}}</text></label>
				<text v-if="recordList.length === 1">20积分</text>
				<text v-if="recordList.length === 2">30积分</text>
				<text v-if="recordList.length === 3">40积分</text>
				<text v-if="recordList.length === 4">50积分</text>
				<text v-if="recordList.length === 5">60积分</text>
				<text v-if="recordList.length === 6">100积分</text>
			</view>
			<view class="signDateList">
				<view class="signItem" v-for="(item, index) of recordList" :key="item.signinId">
					<view class="topIcon">
						<image :src=" `${VUE_APP_STATIC_URL}static/img/member/signIcon.png`"></image>
					</view>
					<view class="dateInfo">{{ index + 1 }}天</view>
				</view>
				<view class="signItem" v-for="index of noSign" :key="index">
					<view class="topIcon">
						<image :src="`${VUE_APP_STATIC_URL}static/img/member/signIcon2.png`"></image>
					</view>
					<!-- #ifdef MP-WEIXIN -->
					<view class="dateInfo">{{recordList.length+index+1}}天</view>
					<!-- #endif -->

					<!-- #ifdef H5 -->
					<view class="dateInfo">{{recordList.length+index}}天</view>
					<!-- <view class="dateInfo">{{index+1}}天</view> -->
					<!-- #endif -->
				</view>
			</view>
			<view class="fs24 font-color-71521B">连续签到可获得超额奖励哦～</view>
		</view>
		<view class="signInList">
			<view class="signTit fs30 font-color-333">签到明细</view>
			<view class="signInBox" v-if="historyList.length !==0">
				<view class="signItem flex-items flex-sp-between" v-for="item of historyList" :key="item.signinId">
					<view class="itemLeft flex-items">
						<view class="leftInfo">
							<label class="fs28 font-color-333">签到</label>
							<view class="fs24 font-color-999">{{item.createTime}}</view>
						</view>
					</view>
					<view class="rightBtn">+{{item.growth}}</view>
				</view>
			</view>
			<view v-if="historyList.length === 0" class="fs24 noHistory">暂无签到记录~</view>
		</view>
	</view>
</template>

<script setup>
import {request} from "../../utils/request";
import API from "../../config/api";
import { ref } from 'vue';
import { onLoad, onReachBottom } from "@dcloudio/uni-app";
import { VUE_APP_STATIC_URL } from "@/config/api";

const growingValue = ref(80);
const growingMax = ref(3500);
const memberData = ref({});
const recordList = ref({});
const historyList = ref([]);
const page = ref(1);
const pageSize = ref(5);
const levelInfo = ref({});
const noSign = ref(7);
const signDate = ref(0);
const currentData = ref('');
const upDate = ref('');
const loadingType = ref(false); // 判断是否触发onReachBottom


onLoad(() => {
  getDate();
  memberData.value = uni.getStorageSync('storage_userInfo');
  levelInfo.value = uni.getStorageSync('storage_levelInfo');
  getSelectSigninRecordList()
  getSelectSigninHistory()
})

onReachBottom(() => {
  if(loadingType.value){
    uni.stopPullDownRefresh()
  }else{
    page.value = page.value + 1
    getSelectSigninHistory()
  }
})

const getSelectSigninRecordList = () => {
  noSign.value = 7
  signDate.value = 0
  // 获取签到
  // uni.showLoading({
  //   mask: true,
  // 	title: '加载中...',
  // })
  request(API.selectSigninRecordList, {}, 'GET').then(res => {
    uni.hideLoading()
    recordList.value = res.data
    noSign.value = noSign.value - recordList.value.length
    // this.signDate = this.recordList.length
    let newDate = recordList.value[recordList.value.length - 1]
    upDate.value = newDate.createTime.slice(0, 10)
  }).catch(res => {})
}

const getSelectSigninHistory = () => {
  // 获取签到历史
  let param = ''
  param = {
    page: page.value,
    pageSize: pageSize.value,
  }
  // uni.showLoading({
  //   mask: true,
  // 	title: '加载中...',
  // })
  request(API.selectSigninHistory, param, 'GET').then(res => {
    if(res.data.list.length === 0){
      loadingType.value = true
    }
    uni.hideLoading()
    historyList.value = historyList.value.concat(res.data.list);
    signDate.value = res.data.total
  }).catch(res => {
    uni.hideLoading()
  })
}

// 签到
const signInFn = () => {
  if (upDate.value !== currentData.value) {
    // uni.showLoading({
    //   mask: true,
    // 	title: '请稍等...',
    // })
    request(API.signIn, {}, 'POST').then(res => {
      uni.hideLoading()
      uni.showToast({
        title: '签到成功！',
        icon: 'none'
      })
      getSelectSigninRecordList()
      getSelectSigninHistory()
    }).catch(res => {})
  }
}

const getDate = () => {
  const year = new Date().getFullYear()
  const month = new Date().getMonth() + 1 < 10 ? '0' + (new Date().getMonth() + 1) : (new Date().getMonth() +
      1)
  const date = new Date().getDate() < 10 ? '0' + new Date().getDate() : new Date().getDate()
  currentData.value = year + '-' + month + '-' + date
}
</script>

<style lang="scss" scoped>
@import "../../style/images";
	page {
		background: #F8F8F8;
	}

	.memberCenter {
		border-top: 2rpx solid #4b4b4b;
		background: $memberCenterBg no-repeat left top;
		background-size: contain;
		min-height: 900rpx;
		padding: 0 20rpx;

		.avatarTop {
			text-align: center;
			margin-top: 30rpx;
		}

		.avatarBox {
			margin-bottom: 20rpx;

			image {
				width: 110rpx;
				height: 110rpx;
				border: 5rpx solid #FFFFFF;
				border-radius: 50%;
			}
		}

		.nameBox {
			.name {
				font-size: 36rpx;
				color: #FFFFFF;
				font-weight: bold;
			}

			.level {
				image {
					width: 172rpx;
					height: 50rpx;
				}
			}
		}

		.signInList {
			background: #FFFFFF;
			border-radius: 20rpx;
			padding: 30rpx;

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
					background: #F6EEDB;
					border-radius: 10rpx;
					color: #C5AA7B;
					text-align: center;
				}
			}
		}

		.signInfoBox {
			height: 366rpx;
			border: 2rpx solid rgba(0, 0, 0, 0);
			background: linear-gradient(88deg, #D8BD8D 0%, #EFD8AB 100%);
			border-radius: 10rpx;
			margin-top: 40rpx;
			padding: 30rpx 40rpx;
			box-sizing: border-box;

			.accumulate {
				.points {
					margin-top: 15rpx;
					margin-bottom: 30rpx;
				}

				label {
					color: #71521B;
				}

				text {
					color: #C83732;
					margin-left: 20rpx
				}

				.toSignBtn {
					width: 160rpx;
					height: 58rpx;
					line-height: 58rpx;
					background: #333333;
					border-radius: 10rpx;
					color: #FFEBC4;
					text-align: center;
				}

				.active {
					opacity: 0.8;
				}

				.accumulateTit {
					font-weight: bold;
				}
			}

			.signDateList {
				display: flex;
				flex-flow: wrap;
				justify-content: space-around;
				margin: 20rpx 0;

				.signItem {
					text-align: center;

					.topIcon {
						image {
							width: 60rpx;
							height: 60rpx;
						}
					}
				}

				.active {}
			}
		}

		.noHistory {
			color: #999999;
			height: 100rpx;
			line-height: 100rpx;
			border-top: 2rpx solid #F3F4F5;
		}
	}
</style>
