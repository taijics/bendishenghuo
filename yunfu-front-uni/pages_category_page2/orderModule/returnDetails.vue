<!-- 退货详情 -->
<template>
	<view>
    <global-loading />
		<view class="">
			<view class="order-details-status">
				<view class="status-title-box" v-if='status == -1'>
					<view class="l">
						<text class="status">无退货</text>
						<!-- <text class="label" v-if="deliveryfalse">还剩1天22时30分</text> -->
					</view>
<!--					<image class='r' :src="`${VUE_APP_STATIC_URL}static/images/afterSaleDetailsTime.png`"></image>-->
				</view>
				<view class="status-title-box" v-if='status == 1'>
					<view class="l">
						<text class="status">退货审核中</text>
						<!-- <text class="label" v-if="deliveryfalse">还剩1天22时30分</text> -->
					</view>
<!--					<image class='r' :src="`${VUE_APP_STATIC_URL}static/images/afterSaleDetailsTime.png`"></image>-->
				</view>
				<!--  审核通过-->
				<view class="status-title-box" v-if="status == 10">
					<view class="l">
						<text class="status">审核通过</text>
						<!-- <text class="label" v-if="deliveryfalse">2020年4月24日 22:00:00</text> -->
					</view>
<!--					<image class='r' :src="`${VUE_APP_STATIC_URL}static/images/afterSaleDetailsSuccess.png`"></image>-->
				</view>
				<!--  审核通过-->
				<view class="status-title-box" v-if="status == 6">
					<view class="l">
						<text class="status">审核不通过</text>
						<!-- <text class="label" v-if="deliveryfalse">2020年4月24日 22:00:00</text> -->
					</view>
<!--					<image class='r' :src="`${VUE_APP_STATIC_URL}static/images/afterSaleDetailsSuccess.png`"></image>-->
				</view>
        <!--  审核中-->
        <view class="status-title-box" v-if="status == 7">
          <view class="l">
            <text class="status">退货中</text>
          </view>
<!--          <image class='r' :src="`${VUE_APP_STATIC_URL}static/images/afterSaleDetailsFalse.png`"></image>-->
        </view>
				<!--  退货中-->
				<view class="status-title-box" v-if="status == 3">
					<view class="l">
						<text class="status">退货中</text>
						<!-- <text class="label">2020年4月24日 22:00:00</text> -->
					</view>
<!--					<image class='r' :src="`${VUE_APP_STATIC_URL}static/images/afterSaleDetailsFalse.png`"></image>-->
				</view>
				<!--  退货完成拒绝退款-->
				<view class="status-title-box" v-if="status == 8">
					<view class="l">
						<text class="status">退货完成，拒绝退款</text>
						<!-- <text class="label">2020年4月24日 22:00:00</text> -->
					</view>
<!--					<image class='r' :src="`${VUE_APP_STATIC_URL}static/images/afterSaleDetailsFalse.png`"></image>-->
				</view>
				<!--  退款成功-->
				<view class="status-title-box" v-if="status == 4">
					<view class="l">
						<text class="status">已退款</text>
						<!-- <text class="label" v-if="deliveryfalse">2020年4月24日 22:00:00</text> -->
					</view>
<!--					<image class='r' :src="`${VUE_APP_STATIC_URL}static/images/afterSaleDetailsSuccess.png`"></image>-->
				</view>
				<!-- 退款中 -->
				<view class="status-title-box" v-if="status == 2">
					<view class="l">
						<text class="status">退款中</text>
						<!-- <text class="label" v-if="deliveryfalse">2020年4月24日 22:00:00</text> -->
					</view>
<!--					<image class='r' :src="`${VUE_APP_STATIC_URL}static/images/afterSaleDetailsSuccess.png`"></image>-->
				</view>
				<!-- 退款失败 -->
				<view class="status-title-box" v-if='status == 5'>
					<view class="l">
						<text class="status">退款失败</text>
						<!-- <text class="label" v-if="deliveryfalse">还剩1天22时30分</text> -->
					</view>
<!--					<image class='r' :src="`${VUE_APP_STATIC_URL}static/images/afterSaleDetailsTime.png`"></image>-->
				</view>
				<!-- 退款关闭 -->
				<view class="status-title-box" v-if='status == 9'>
					<view class="l">
						<text class="status">退货关闭</text>
						<!-- <text class="label" v-if="deliveryfalse">还剩1天22时30分</text> -->
					</view>
<!--					<image class='r' :src="`${VUE_APP_STATIC_URL}static/images/afterSaleDetailsTime.png`"></image>-->
				</view>
			</view>

			<view class="order-details-info-box mt20">
				<view class="order-details-price" v-if='status == 1'>
					<text>退款总金额</text>
					<text class="price-box"><text class="fuhao">￥</text>{{itemlist.price}}</text>
				</view>
			    <view class="address-box" v-if='status == 10'>
			      <view>商家已同意退货申请，请尽早发货。</view>
			      <view class="address-info">
			        <image :src="`${VUE_APP_STATIC_URL}static/images/expressSiteIcon.png`" class="address-img"></image>
			        <view class="address-info-r">
			          <view class="item">
			            <view><text class="title">收货人</text>：</view>
			            <view class="r"><text>{{itemlist.returnPerson}}</text>
			            <text class="ml30">{{itemlist.returnPhone}}</text></view>
			          </view>
			          <view class="item">
			            <view><text class="title">地址</text>：</view>
			            <view class="r address-detail">{{itemlist.returnAdress}}</view>
			          </view>
			        </view>
			      </view>
			    </view>
			</view>
			<!-- 发起退货 -->
			<view class="order-details-info-box mt20" >
				<view class="address-box return-explain-box">
					<view>退货说明</view>
					<view class="address-info-r mt20 mar-top-20">
						<view class="item fs24">
							<text class="circle"></text>
							<text class="">未与商家协商一致，请勿使用到付或平邮，以免商家拒签</text>
						</view>
						<view class="item fs24">
							<text class="circle"></text>
							<text class="">交易栋钱款还在平台中间账户，确保您的资金安全</text>
						</view>
						<view class="item fs24">
							<text class="circle"></text>
							<text class="">填写物流写真实物流信息，逾期未填写退货申请将被取消</text>
						</view>
					</view>
					<view class="return-explain-btn">
						<text class="btn" v-if="status == 6 || status == 10" @click="cancelRefundTap">撤销申请</text>
						<text class="btn" @click="platform(itemlist.afterId, itemlist.orderId)" v-if="status==6 || status==8">平台介入</text>
						<text class="btn on" v-if="status == 10" @click="goAddLogistics">填写物流</text>
					</view>

				</view>
			</view>
			<!-- 退款成功 -->
			<view class="order-details-info-box mt20" v-if="itemlist.afterState != 6 && status == 6">
				<view class="order-details-price return-explain-box">
					<text>已原路退回金额 {{itemlist.afterState}}</text>
					<text class="price-box"><text class="fuhao">￥</text>{{itemlist.price}}</text>
				</view>
			</view>
			<!-- 退款关闭 -->
			<view class="order-details-info-box mt20" v-if="status == 9">
				<view class="address-box return-explain-box">
					<view>因您撤销退货申请，退货退款已关闭</view>
				</view>
			</view>

			<view class="order-list-box" >
				<view class="title">退货信息</view>
				<view class="item" >
					<view class="order-info-box">
						<view class="order-info" v-for="item in itemlist.skus">
							<view class="order-info-item">
								<image :src="item.image" class="product-img"></image>
								<view class="info-box">
									<text class="product-name">{{item.productName}}</text>
									<view class="product-sku mt20">{{item.value}}</view>
								</view>
							</view>
						</view>
						<view class="delivery-way-box">
							<view class="item">
								<!-- <text class="way">退款原因：多拍/错拍/不想要</text> -->
							</view>
							<view class="item">
								<text class="way">退款金额：￥{{itemlist.price}}</text>
							</view>
							<view class="item">
								<text class="way">退款编号：{{itemlist.afterFormid}}</text>
							</view>
							<view class="item">
								<text class="way">申请时间：{{itemlist.createTime}}</text>
							</view>
						</view>
					</view>
				</view>
			</view>
			<view class="order-list-box">
				<view class="title">协商历史</view>
				<view style="margin: 30rpx;padding: 30rpx;border-left: 1px solid #CCCCCC;" v-if="itemlist.afterHistory&&itemlist.afterHistory.length>0" v-for="item in itemlist.afterHistory">
					<text style="color: #999999;">{{item.title}}</text>
					<br>
					<br>
					<text style="color: #999999;">{{item.time}}</text>
				</view>
			</view>
		</view>
    <u-popup v-model="intervention" mode="center" border-radius="14" close-icon-pos="top-right" width="80%"
             close-icon-size="20">
      <view class="interventionBox">
        <view class="intTit">申请平台介入</view>
        <textarea class="textarea-text" v-model="reason" placeholder-style="color:#BBBBBB" placeholder="请输入介入原因"/>
        <view class="btnBox">
          <button @click="interventionFn" class="primary">确定</button>
          <button @click="closeInterventionFn">取消</button>
        </view>
      </view>
    </u-popup>
	</view>
</template>

<script setup>
import { ref } from "vue"
import { request } from '../../utils/request'
import API from '../../config/api'
import { onLoad } from "@dcloudio/uni-app";
import { VUE_APP_STATIC_URL } from "@/config/api";

const item = ref({})
const itemlist = ref({})
const status = ref(0)
const ReturnDetailData = ref([])
const reason = ref('')
const images = ref('')
const intervention = ref(false)
const interventionText = ref('')
const afterId = ref('')
const orderId = ref('')
const isLoading = ref(false)

onLoad((options) => {
	item.value = JSON.parse(options.item)
	getReturnDetail()
})

const getReturnDetail = async () => {
		const res = await request(API.ReturnDetail,{
			afterId: item.value.afterId,
			orderId: item.value.orderId
		},'GET')
		status.value = res.data.afterState
		itemlist.value = res.data
}
/**
 * 撤销售后
 */
const cancelRefundTap = () => {
	request(API.CancelReturnGoods, {
		afterId: item.value.afterId,
		orderId: item.value.orderId
	}, 'POST').then(res => {
		uni.showToast({
			title:'撤销成功',
		})
		uni.switchTab({
			url:'../../pages/tabbar/user/index'
		})
	}).catch(res => {
    throw Error(res)
	})
}

const goAddLogistics = () => {
	uni.setStorageSync("itemLogistics", item.value)
	uni.navigateTo({
		url:'../../pages_category_page1/orderModule/addLogistics'
	})
}

/**
 * 平台介入
 * @param afterId
 * @param orderId
 */
const platform = (afterId, orderId) => {
	uni.navigateTo({
		url: `../../pages_category_page1/orderModule/platformJoin?afterId=${afterId}&orderId=${orderId}`
	})
}

/**
 * 申请介入
 */
const interventionFn = async () => {
	try {
		const res = request(API.platform, {
			afterId: afterId.value,
			orderId: orderId.value,
			image: images.value,
			reason: reason.value
		}, 'POST')
		intervention.value = false
		uni.showToast({
			title:'申请成功',
		})
	} catch (err){
    throw Error(err)
  }
}

const closeInterventionFn = () => {
	intervention.value = false
}
</script>

<style>
page {
  background: #f7f7f7;
}

.order-details-status {
  width: 750upx;
  height: 180upx;
  background: #333333;
}

.status-title-box {
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: space-between;
  padding: 40upx 30upx 0;
  box-sizing: border-box;
}

.status-title-box2 {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 40upx 30upx 0;
  box-sizing: border-box;
}

.status-title-box .l {
  display: flex;
  flex-direction: column;
}

.status-title-box .l .status, .status-title-box2 .status {
  font-size: 30upx;
  color: #fff;
}

.status-title-box .l .label, .status-title-box2 .label {
  font-size: 24upx;
  color: #fff;
  margin-top: 14upx;
}

.status-title-box .r {
  width: 80upx;
  height: 80upx;
}

.order-details-info-box {
  padding: 0 30upx;
  box-sizing: border-box;
  background: #fff;
}

.order-details-info-box.mt20 {
  margin-top: 20upx;
}

.order-details-price {
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: space-between;
  height: 100upx;
  border-bottom: 1px solid #e5e5e5;
  font-size: 30upx;
  color: #333;
}

.order-details-price .price-box {
  font-size: 36upx;
  color: #ff7911;
}

.order-details-price .fuhao {
  font-size: 24upx;
}

.address-box {
  background: #fff;
  padding: 30upx 0;
  box-sizing: border-box;
  display: flex;
  flex-direction: column;
  font-size: 28upx;
  color: #333;
  border-bottom: 1px solid #e5e5e5;
}

.address-info {
  display: flex;
  flex-direction: row;
  align-items: center;
  margin-top: 20upx;
}

.address-box .address-img {
  width: 45upx;
  height: 45upx;
  margin-right: 40upx;
}

.address-box .address-info-r {
  flex: 1;
  display: flex;
  flex-direction: column;
  font-size: 28upx;
  color: #999;
}
.address-detail {
  word-break: break-all;
}

.ml30 {
  margin-left: 30upx;
}

.address-box .address-info-r .item {
  display: flex;
  flex-direction: row;
}

.address-box .address-info-r .title {
  display: inline-block;
  width: 100upx;
  text-align: justify;
  text-justify: distribute-all-lines;
  text-align-last: justify;
}

.address-box .address-info-r .item .r {
  flex: 1;
  line-height: 40upx;
}

.return-explain-box {
  border-bottom: none;
}

.return-explain-box .address-info-r .item {
  display: flex;
  flex-direction: row;
  align-items: center;
  line-height: 40upx;
}

.address-info-r .item .circle {
  width: 8upx;
  height: 8upx;
  border-radius: 50%;
  background: #bbb;
  margin-right: 10upx;
}

.return-explain-btn {
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: flex-end;
  margin-top: 20upx;
}

.return-explain-btn .btn {
  width: 130upx;
  height: 56upx;
  background: #fff;
  border: 1px solid #bbb;
  border-radius: 4upx;
  text-align: center;
  line-height: 56upx;
  margin-left: 20upx;
  color: #333;
  font-size: 26upx;
}

.return-explain-btn .btn.on {
  color: #333333;
  border: 2rpx solid #333333;
}


.order-list-box {
  margin-top: 20upx;
}
.order-list-box .title{
  padding: 30upx;
  box-sizing: border-box;
  font-size: 30upx;
  color:#333;
  background: #fff;
}
.order-list-box .item {
  margin-bottom: 20upx;
  background: #fff;
  border-radius: 10upx;
}

.order-info-box {
  padding: 0 30upx;
  box-sizing: border-box;
}

.order-info {
  border-bottom: 1px solid #eee;
}

.order-info-item {
  display: flex;
  flex-direction: row;
  padding: 20upx 0;
}

.product-img {
  width: 180upx;
  height: 180upx;
  border-radius: 10upx;
  margin-right: 30upx;
}

.info-box {
  flex: 1;
  display: flex;
  flex-direction: column;
  /* justify-content: space-between; */
}

.product-name {
  font-size: 26upx;
  color: #333;
  height: 68upx;
  line-height: 34upx;
  display: -webkit-box;
  overflow: hidden;
  text-overflow: ellipsis;
  word-break: break-all;
  -webkit-box-orient: vertical;
  -webkit-line-clamp: 2;
}

.price-sku-box {
  display: flex;
  flex-direction: row;
  justify-content: space-between;
}

.product-sku {
  font-size: 24upx;
  color: #999;
}

.product-price {
  font-size: 28upx;
  color: #333;
  font-weight: 400;
}

.product-price .fuhao {
  font-size: 28upx;
}

.product-num {
  font-size: 28upx;
  color: #999;
}
.delivery-way-box{
  display: flex;
  flex-direction: column;
  margin: 30upx 0 10upx;
}
.delivery-way-box .item {
  display: flex;
  flex-direction: row;
  align-items: center;
  font-size: 26upx;
  color: #333;
}
.delivery-way-box .item .way {
  color: #999;
}
.interventionBox .btnBox {
  display: flex;
}
.interventionBox .btnBox button {
  width: 50%;
  border-radius: 0;
}
.interventionBox .btnBox .primary {
  color: #FFFFFF;
  background: #FF7700;
}
.interventionBox .btnBox /deep/ uni-button:after {
  border-radius: 0;
}
.interventionBox .intTit{
  height: 100upx;
  line-height: 100upx;
  text-align: center;
  border-bottom: 1upx solid #EEE;
  font-size: 32upx;
}
.interventionBox .btnBox .u-btn {
  width: 50%;
  margin: 0;
  border-radius: 0 !important;
}
.interventionBox .btnBox .u-btn:after {
  border-radius: 0;
  border-color: #CCCCCC;
}
.interventionBox .btnBox .u-btn--primary {
  background: #FF7700;
}
.interventionBox .textarea-text {
  padding: 20upx;
  font-size: 20upx;
  height: 200rpx;
}
.interventionBox /deep/ .uni-textarea-textarea {
  width: 100%;
}
.interventionBox /deep/ .uni-textarea {
  width: 100%;
}
</style>
