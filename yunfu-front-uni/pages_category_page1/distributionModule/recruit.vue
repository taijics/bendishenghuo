<template>
	<view class="container">
		<!-- 申请分销员 -->
		<view class="topBackImg flex-items flex-column">
			<view class="content mar-top-36">
				<view class="topColor"></view>
				<view class="text-box mar-left-30">
					<label class="fs-bold">分销员是什么？</label>
					<view class="fs24 font-color-656 mar-top-20">分销员是我们为拥有推广能力的用户推出的运营计划。你只需将高品质商品分享推荐给他人，收获他人的感谢的同时，挣得属于自己的利润。</view>
				</view>
				<view class="text-box mar-top-20 mar-left-30">
					<label class="fs-bold">我该怎么成为分销员？</label>
					<view class="fs24 font-color-656 mar-top-20">
						<view>
							<label class="fs-bold"> · </label>
							<label class="mar-left-20">点击本页面的【我要成为分销员】，即可完成申请。</label>
						</view>
						<view class="flex-row-plus mar-top-20">
							<label class="fs-bold"> · </label>
							<label class="mar-left-20 textDes">点击拥有分销员活动标识的分享按钮，将商品分享给好友或朋友圈。</label>
						</view>
						<view class="mar-top-20">
							<label class="fs-bold"> · </label>
							<label class="mar-left-20">朋友通过您的链接进入并购买一件商品。</label>
						</view>
						<view class="flex-row-plus textDes mar-top-20">
							<label class="fs-bold"> · </label>
							<label class="mar-left-20">我们收到已完成的订单时，会将本订单的佣金结算给您。</label>
						</view>
						<view class="mar-top-20">
							<label class="fs-bold"> · </label>
							<label class="mar-left-20">返回个人中心-分销中心，查看您的。</label>
						</view>
					</view>
				</view>
				<view class="text-box mar-top-20 mar-left-30">
					<label class="fs-bold">其他说明</label>
					<view class="fs24 font-color-656 mar-top-20">
						<view>
							<label class="fs-bold"> · </label>
							<label class="mar-left-20">客户只有通过您的链接成交，才能返佣给您。</label>
						</view>
						<view class="flex-row-plus mar-top-20">
							<label class="fs-bold"> · </label>
							<label class="mar-left-20 textDes"> 若订单发生退款，我们将去除本订单的佣金。</label>
						</view>
						<view class="mar-top-20">
							<label class="fs-bold"> · </label>
							<label class="mar-left-20">商品的售后问题，由本商店处理。</label>
						</view>
						<view class="flex-row-plus textDes mar-top-20">
							<label class="fs-bold"> · </label>
							<label class="mar-left-20">不传播任何违法违规信息，一经发现，即被清退，本商城不负任何责任。</label>
						</view>
						<view class="mar-top-20">
							<label class="fs-bold"> · </label>
							<label class="mar-left-20">以上内容解释权归本商城所有。</label>
						</view>
					</view>
				</view>
			</view>

		</view>
		<view class="butBox flex-items-plus" :style="{'padding-bottom':(isIphone === true? 20:0)+'rpx'}" @click="informationShowClick">
			<view class="submitbut">我要成为分销员</view>
		</view>
		<!-- 填写信息弹窗 -->
		<u-popup v-model="informationShowFalg" mode="center" border-radius="14">
      <view class="informationShow-box">
        <view class="flex-items flex-column informationShow-centent">
          <view class="mar-top-60">
            <label class="fs-bold fs36">请填写相关信息</label>
          </view>
         <view class="flex-items flex-row mar-top-60">
            <view class="fs26 font-color-656">真实姓名<label class="font-color-red">*</label></view>
            <input class="recruitName mar-left-20 fs26" v-model="userName"/>
          </view>
          <view class="flex-items flex-row mar-top-30 phoneStyle">
            <label class="fs26 font-color-656">联系电话<label class="font-color-red">*</label></label>
            <input class="recruitIphone mar-left-20 fs26" disabled="disabled" type="number" v-model="mobile"/>
          </view>
          <view class="flex-items flex-row mar-top-30 mar-left-40">
            <label class="fs26 font-color-656">邀请码</label>
            <input class="recruitIphone mar-left-20 fs26" v-model="inviteId"/>
          </view>
          <view class="flex-row-plus massageDes-but fs28">
            <view class="exitBut" @click="exitButClick">取消</view>
            <view class="submitbut" @click="applyForRecruit">提交</view>
          </view>
        </view>
      </view>
		</u-popup>
	</view>
</template>

<script setup>
import {ref} from "vue";
import { request } from '../../utils/request'
import API from "../../config/api";
import {onLoad} from "@dcloudio/uni-app";

const informationShowFalg = ref(false);
const item = ref('');
const userName = ref('');
const mobile = ref('');
const inviteId = ref('');
const shopId = ref(0);
const isIphone = ref(false);

onLoad((options) => {
  isIphone.value = getApp().globalData.isIphone;
  if (getApp().globalData.distributeRecruitItem) {
    const item = getApp().globalData.distributeRecruitItem
    shopId.value = parseInt(item.shopId)
    getApp().globalData.distributeRecruitItem = undefined
  } else {
    shopId.value = parseInt(options.shopId)
  }
  isIphone.value = getApp().globalData.isIphone;
})
/**
 * 显示分销员申请弹窗
 */
const informationShowClick = () => {
  informationShowFalg.value = true
  const res = uni.getStorageSync('storage_key');
  mobile.value = res.phone
  if (!mobile.value) {
    uni.showToast({
      title:'请先登录!',
      icon:'none'
    })
    uni.navigateTo({
      url: '../../../pages_category_page2/userModule/login'
    })
  }
}
const exitButClick = () => {
  informationShowFalg.value = false
}

/**
 * 申请为分销员
 */
const applyForRecruit = async () => {
  var regphone = /^1(3\d|4[5-9]|5[0-35-9]|6[2567]|7[0-8]|8\d|9[0-35-9])\d{8}$/;
  if(userName.value == ''){
    uni.showToast({
      title:'真实姓名不能为空',
      icon:'none'
    })
  }else if (mobile.value == '') {
    uni.showToast({
      title:'手机号不能为空',
      icon:'none'
    })
  }else if (!regphone.test(mobile.value)) {
    uni.showToast({
      title:'手机格式不正确',
      icon:'none'
    })
  }else{
    try {
      const res = await request(API.Apply,{
        shopId:shopId.value,
        distributorPhone: mobile.value,
        distributorName: userName.value,
        invitationCode: inviteId.value
      },'POST')
      informationShowFalg.value = false
      uni.showToast({
        title:'请等候审核...',
      })
      setTimeout(() => {
        uni.navigateBack({
          delta: 1
        });
      }, 1500);
    } catch (err) {
      uni.showToast({
        title:'申请失败',
        icon:'none'
      })
    }
  }
}
</script>

<style lang="scss">
@import '../../style/images';
	.container {
		.topBackImg {
			width: 100%;
			height: 260upx;
			background: $storeTopBg no-repeat;
			background-size: 100% 260upx;

			.content {
				width: 690upx;
				background-color: #FFFFFF;

				.topColor {
					height: 60upx;
				}

				.text-box {
					width: 622upx;

					.textDes {
						width: 598upx;
						line-height: 40upx;
					}
				}
			}

		}

		.butBox {
			height: 130upx;
			width: 100%;
			position: absolute;
			bottom: 0upx;
			left: 0upx;
			background-color: #FFFFFF;
			box-shadow: 0upx 3upx 12upx #999999;

			.submitbut {
				height: 80upx;
				width: 690upx;
				background: #333333;
				font-size: 28upx;
				text-align: center;
				line-height: 80upx;
        color: #FFEBC4;
			}
		}

		.informationShow-box {
      .flex-items {
        input {
          padding-left: 16upx;
        }
      }
      .phoneStyle {
        input {
          background: #EEEEEE;
          color: #999999;
        }
      }
			.informationShow-centent {
				width: 520upx;
				height: 550upx;
				.recruitName {
					border: 2upx solid #DDDDDD;
					width: 300upx;
					height: 48upx;
				}

				.recruitIphone {
					border: 2upx solid #DDDDDD;
					width: 300upx;
					height: 48upx;
				}

				.massageDes-but {
					position: absolute;
					bottom: 0;
				}

				.exitBut {
					border: 1upx solid #E5E5E5;
					width: 260upx;
					height: 90upx;
					text-align: center;
					line-height: 90upx;
				}

				.submitbut {
					background-color: #333333;
					width: 260upx;
					height: 90upx;
					text-align: center;
					line-height: 90upx;
					color: #FFFFFF;
				}
			}
		}
	}
</style>
