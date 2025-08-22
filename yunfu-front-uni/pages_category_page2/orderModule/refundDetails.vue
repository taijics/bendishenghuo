<!-- 退货详情 -->
<template>
  <view>
    <view v-if="ifShow">
      <view>
        <view class="order-details-status">
          <view class="status-title-box" v-if='status == 1'>
            <view class="l">
              <text class="status">审核中</text>
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
          <!--  审核不通过-->
          <view class="status-title-box" v-if="status == 6">
            <view class="l">
              <text class="status">审核不通过</text>
              <!-- <text class="label" v-if="deliveryfalse">2020年4月24日 22:00:00</text> -->
            </view>
            <!--					<image class='r' :src="`${VUE_APP_STATIC_URL}static/images/afterSaleDetailsSuccess.png`"></image>-->
          </view>
          <view class="reason" v-if="status == 6">原因: {{ itemList.reason }}</view>
          <!--  退款中-->
          <view class="status-title-box" v-if="status == 2">
            <view class="l">
              <text class="status">退款中</text>
              <!-- <text class="label">2020年4月24日 22:00:00</text> -->
            </view>
            <!--					<image class='r' :src="`${VUE_APP_STATIC_URL}static/images/afterSaleDetailsFalse.png`"></image>-->
          </view>
          <!--  退款中-->
          <view class="status-title-box" v-if="status == 7">
            <view class="l">
              <text class="status">评审中</text>
            </view>
            <!--          <image class='r' :src="`${VUE_APP_STATIC_URL}static/images/afterSaleDetailsFalse.png`"></image>-->
          </view>
          <!--  退货完成待退款-->
          <view class="status-title-box" v-if="status == 4">
            <view class="l">
              <text class="status">退款成功</text>
              <!-- <text class="label">2020年4月24日 22:00:00</text> -->
            </view>
            <!--					<image class='r' :src="`${VUE_APP_STATIC_URL}static/images/afterSaleDetailsFalse.png`"></image>-->
          </view>
          <!--  退货完成拒绝退款-->
          <view class="status-title-box" v-if="status == 5">
            <view class="l">
              <text class="status">退款失败</text>
              <!-- <text class="label">2020年4月24日 22:00:00</text> -->
            </view>
            <!--					<image class='r' :src="`${VUE_APP_STATIC_URL}static/images/afterSaleDetailsFalse.png`"></image>-->
          </view>
          <!--  平台介入拒绝-->
          <view class="status-title-box" v-if="status == 9 && isPlaformState === 1">
            <view class="l">
              <text class="status">审核失败</text>
            </view>
          </view>
          <!--  退款成功-->
          <view class="status-title-box" v-if="status == 9">
            <view class="l">
              <text class="status">撤销申请</text>
              <!-- <text class="label" v-if="deliveryfalse">2020年4月24日 22:00:00</text> -->
            </view>
            <!--					<image class='r' :src="`${VUE_APP_STATIC_URL}static/images/afterSaleDetailsSuccess.png`"></image>-->
          </view>

        </view>

        <!-- 发起退款 -->
        <view class="order-details-info-box mt20" v-if='status == 0'>
          <view class="order-details-price" v-if='status != 0'>
            <text>退款总金额</text>
            <text class="price-box"><text class="fuhao">￥</text>{{itemList.price}}</text>
          </view>
          <view class="address-box return-explain-box">
            <view>您已成功发起退款申请，请耐心等待商家处理。</view>
            <view class="address-info-r mt20 mar-top-20">
              <view class="item fs24">
                <text class="circle"></text>
                <text class="">卖家同意或超时未处理，系统将退款给您</text>
              </view>
              <view class="item fs24">
                <text class="circle"></text>
                <text class="">如果卖家拒绝，您可以修改退款申请后再次发起，卖家会重新处理</text>
              </view>
            </view>
            <view class="return-explain-btn">
              <text class="btn" @click="cancelRefundTap">撤销申请</text>
              <text class="btn" @click="platform(itemList.afterId, itemList.orderId)" v-if="status==6 || status==8">平台介入</text>
            </view>
          </view>
        </view>
        <view class="order-details-info-box mt20" v-if="status==6 || status==8">
          <view class="return-explain-btn">
            <text class="btn" @click="cancelRefundTap">撤销申请</text>
            <text class="btn" @click="platform(itemList.afterId, itemList.orderId)">平台介入</text>
          </view>
        </view>
        <!-- 退款成功 -->
        <view class="order-details-info-box mt20" v-if="status == 4">
          <view class="order-details-price return-explain-box">
            <text>已原路退回金额</text>
            <text class="price-box"><text class="fuhao">￥</text>{{itemList.price}}</text>
          </view>
        </view>
        <!-- 平台介入关闭 -->
        <view class="order-details-info-box mt20" v-if="status == 9 && isPlaformState === 1">
          <view class="address-box return-explain-box">
            <view>平台介入申请失败</view>
          </view>
        </view>
        <!-- 退款关闭 -->
        <view class="order-details-info-box mt20" v-if="status == 9">
          <view class="address-box return-explain-box">
            <view>因您撤销退款申请，退款已关闭</view>
          </view>
        </view>

        <view class="order-list-box" >
          <view class="title">退款信息</view>
          <view class="item" >
            <view class="order-info-box">
              <view class="order-info" v-for="item in itemList.skus">
                <view class="order-info-item">
                  <image :src="item.image" class="product-img"></image>
                  <view class="info-box">
                    <text class="product-name">{{item.productName}}</text>
                    <view class="product-sku mt20">{{item.value}}</view>
                  </view>
                </view>
              </view>
              <view class="delivery-way-box">
                <view class="item" v-if="deliveryfalse">
                  <!-- <text class="way">退款原因：多拍/错拍/不想要</text> -->
                </view>
                <view class="item">
                  <text class="way">退款金额：￥{{itemList.price}}</text>
                </view>
                <view class="item">
                  <text class="way">退款编号：{{itemList.afterFormid}}</text>
                </view>
                <view class="item">
                  <text class="way">申请时间：{{itemList.createTime}}</text>
                </view>
              </view>
            </view>
          </view>
        </view>
        <view class="order-list-box negotiate">
          <view class="title">协商历史</view>
          <view class="orderLineBox">
            <u-time-line>
              <u-time-line-item v-if="itemList.afterHistory.length>0" v-for="item in itemList.afterHistory">
                <!-- 此处没有自定义左边的内容，会默认显示一个点 -->
                <template v-slot:content>
                  <view>
                    <view class="u-order-desc">{{item.title}}</view>
                    <view class="u-order-time">{{item.time}}</view>
                  </view>
                </template>
              </u-time-line-item>
            </u-time-line>
          </view>
        </view>
      </view>
      <u-popup v-model="intervention" mode="center" border-radius="14" close-icon-pos="top-right"
               close-icon-size="20">
        <view class="interventionBox">
          <view class="intTit">你已申请平台介入正在审核中...</view>
          <!--        <textarea class="textarea-text" v-model="reason" placeholder-style="color:#BBBBBB" placeholder="请输入介入原因"/>-->
          <!--        <view class="btnBox">-->
          <!--          <button @click="interventionFn" class="primary">确定</button>-->
          <!--          <button @click="closeInterventionFn">取消</button>-->
          <!--        </view>-->
        </view>
      </u-popup>
    </view>
  </view>
</template>

<script setup>
import { ref } from 'vue'
import { onLoad } from "@dcloudio/uni-app"
import { request } from '../../utils/request'
import API from '../../config/api'
import { VUE_APP_STATIC_URL } from "@/config/api";

const item = ref({})
const itemList = ref({})
const status = ref(0)
const deliveryfalse = ref(false)
const returnDetailData = ref([])
const images = ref("")
const intervention = ref(false)
const interventionText = ref("")
const afterId = ref("")
const orderId = ref("")
const ifShow = ref(false)
const isPlaformState = ref(null)

onLoad((options) => {
  console.log(options, 'test')
  item.value = JSON.parse(options.item)
  getReturnDetail()
})

const getReturnDetail = async () => {
  try {
    const res = await request(API.ReturnDetail, {
      afterId: item.value.afterId,
      orderId: item.value.orderId
    }, 'GET')
    status.value = res.data.afterState
    itemList.value = res.data
    ifShow.value = true
    isPlaformState.value = res.data.isPlaformState
  } catch (err) {}
}
const cancelRefundTap = async () => {
  try {
    await request(API.CancelReturnGoods, {
      afterId: item.value.afterId,
      orderId: item.value.orderId
    }, 'POST')
    uni.showToast({
      title: '撤销成功'
    })
    uni.switchTab({
      url: '../../pages/tabbar/user/index'
    })
  } catch (error) {}
}

const platform = (afterId, orderId) => {
  uni.navigateTo({
    url: `../../pages_category_page1/orderModule/Intervene?afterId=${afterId}&orderId=${orderId}`
  })
}

const closeInterventionFn = () => {
  intervention.value = false
}

</script>

<style lang="scss">
@import "../../style/images";
page {
  background: #f8f8f8;
}

.order-details-status {
  width: 100%;
  height: 302upx;
  background: $refundBg no-repeat left top;
  background-size: contain;
}

.status-title-box {
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: space-between;
  padding: 40upx 30upx 0;
  box-sizing: border-box;
}
.reason {
  padding-left: 32rpx;
  color: #FFFFFF;
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
  color: #C83732;
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

.negotiate {
  padding-bottom: 20rpx;
  background: #FFFFFF;
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
  color: #ff7911;
  border: 1px solid #ff7911;
}


.order-list-box {
  margin-top: 20upx;
}
.orderLineBox {
  padding: 0 30rpx;
  background: #FFFFFF;
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
  color: #F5DEB2;
  background: #333333;
}
.interventionBox .btnBox ::v-deep uni-button:after {
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
.interventionBox ::v-deep .uni-textarea-textarea {
  width: 100%;
}
.interventionBox ::v-deep .uni-textarea {
  width: 100%;
}
.u-node {
  width: 44rpx;
  height: 44rpx;
  border-radius: 100rpx;
  display: flex;
  justify-content: center;
  align-items: center;
  background: #d0d0d0;
}

.u-order-title {
  color: #333333;
  font-weight: bold;
  font-size: 32rpx;
}

.u-order-desc {
  color: rgb(150, 150, 150);
  font-size: 28rpx;
  margin-bottom: 6rpx;
}

.u-order-time {
  color: rgb(200, 200, 200);
  font-size: 26rpx;
}
</style>
