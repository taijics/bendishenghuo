<!-- 退货/退款填写物流信息 -->
<template>
  <view>
    <global-loading />
    <view class="content">
      <view class="afterSale-select-box mt20">
        <view
            class="item"
            @click="openWaySelect"
        >
          <view class="l">物流公司</view>
          <view class="r-box">
            <text>{{ SendReturnQuery.logisticsName }}</text>
            <image
                :src="`${VUE_APP_STATIC_URL}static/images/arrowRight.png`"
                class="r"
            ></image>
          </view>
        </view>

        <view class="item item-start">
          <view class="l">物流编号：</view>
          <view class="r-box r-box2">
            <input
                v-model="SendReturnQuery.logisticsNum"
                type="text"
                placeholder-class="fs28"
                placeholder="请填写"
                class="r-box-input"
            />
          </view>
        </view>
      </view>
      <view class="afterSale-select-box mt20">
        <view class="item item-start">
          <view class="l">退款说明：</view>
          <view class="r-box r-box2">
           <input
                v-model="SendReturnQuery.returnGoodsDesc"
                type="text"
                placeholder-class="fs28"
                placeholder="选填"
                class="r-box-input"
            />
          </view>
        </view>
      </view>

      <view class="afterSale-select-box mt20">
        <view class="upload-title">上传凭证</view>
        <view class="mar-left-10 mar-top-10 evaluateImg">
          <view class="mar-left-10 mar-top-10">
            <Upload :limitType="['png', 'jpg', 'jpeg', 'webp', 'gif', 'image']"
                    :action="action"
                    ref="uUpload"
                    :header="headerToken"
                    @on-success="handleUploadSuccess"
                    @on-remove="handleUploadRemove"
                    :form-data="formData"></Upload>
          </view>
        </view>
      </view>
    </view>

    <view class="order-confirm-box">
      <text
          class="btn"
          @click="subimtTap"
      >提交
      </text>
    </view>
    <!-- 物流公司 -->
    <view>
      <lb-picker
          @confirm="change"
          ref="picker"
          :list="companyList"
      >
      </lb-picker>
    </view>
  </view>
</template>

<script setup>
import Upload from "@/uni_modules/vk-uview-ui/components/u-upload/u-upload.vue"
import API from "../../config/api";
import LbPicker from '@/components/lb-picker'
import {onMounted, ref} from "vue";
import { onLoad } from "@dcloudio/uni-app";
import { request } from "@/utils/request";
import { VUE_APP_STATIC_URL } from "@/config/api";

const item = ref({})
const shippinglist = ref([])
const shippingCompanyNamelist = ref([])
const shippingCompanyName = ref('')
const shippingitem = ref('')
const SendReturnQuery = ref({
  "goodsReturnId": 0,
  "logisticsId": 0,
  "logisticsName": "",
  "logisticsNum": "",
  "returnGoodsDesc": "",
  "returnImgs": "",
  "shipperCode": ""
})
const commentImgsFlag = ref(false)
const commentImgs = ref('')
const action = ref(API.UploadUrl)
const formData = ref({'folderId': -1})
const headerToken = ref({Authorization: ''})
const fileList = ref([])
const companyList = ref([])
const uUpload = ref()
onMounted(()=>{
  fileList.list = uUpload.value.lists
})
onLoad(options=> {
  item.value = uni.getStorageSync('itemLogistics')
  console.log(item.value, 'itemData')
  const res = uni.getStorageSync('storage_key');
  headerToken.value.Authorization = res.token
  getShippingCompany()
  uni.removeStorageSync('itemLogistics')
})

function getShippingCompany() {
  request(API.ShippingCompany, {}, "GET").then(res => {
    shippinglist.value = res.data
    shippinglist.value.forEach(el => {
      companyList.value.push({label: el.dictName, value: el.dictId, id: el.dictId})
    })
  })
}
function subimtTap() {
  if(fileList.value.length>0){
    commentImgsFlag.value = true
    for(let i=0;i<fileList.value.length;i++){
      commentImgs.value += fileList.value[i].data.url+','
    }
  }
  getSendReturnGoods()
}

function getSendReturnGoods() {
  // uni.showLoading({
  //   mask: true,
  // 	url:'物流信息提交中...'
  // })

  request(API.SendReturnGoods, {
    orderId: item.value.orderId,
    afterId: item.value.afterId,
    express: SendReturnQuery.value.logisticsId,
    deliverFormid: SendReturnQuery.value.logisticsNum,
    reason: SendReturnQuery.value.returnGoodsDesc,
    image: commentImgs.value
  }, 'POST').then(res => {
    uni.hideLoading()
    if (res.code == 200) {
      uni.showToast({
        title: '提交成功',
        icon: 'success'
      })
      uni.navigateTo({
        url: '../../pages_category_page2/orderModule/afterSale'
      })
    }
  }).catch(err => {
    uni.hideLoading()
    throw Error(err)
  })
}

const picker = ref()
function openWaySelect() {
  picker.value.show()
}
function change(e) {
  SendReturnQuery.value.logisticsId = e.item.id
  SendReturnQuery.value.logisticsName = e.item.label
  SendReturnQuery.value.shipperCode = e.item.value

}
function handleUploadSuccess(data){
  fileList.value.push(data)
}
function handleUploadRemove(index){
  fileList.value.splice(index,1)
}

</script>

<style>
page {
  background-color: #F7F7F7;
}

.content {
  padding: 0 0 120upx;
  box-sizing: border-box;
}

.order-list-box {
  padding: 20upx 30upx;
  box-sizing: border-box;
}

.order-list-box .item {
  /* margin-bottom: 20upx; */
  background: #fff;
  border-radius: 10upx;
}

.order-list-top {
  height: 96upx;
  padding: 0 30upx;
  box-sizing: border-box;
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: space-between;
  border-bottom: 1px solid #eee;
}

.top-l {
  display: flex;
  flex-direction: row;
  align-items: center;
}

.shop-img {
  width: 36upx;
  height: 36upx;
  margin-right: 10upx;
}

.shop-name {
  font-size: 30upx;
  color: #333;
  font-weight: bold;
}

.arrow-img {
  margin-left: 15upx;
  width: 24upx;
  height: 24upx;
}

.order-status {
  font-size: 28upx;
  color: #ff7911;
  font-weight: 500;
}

.order-info-box {
  padding: 0 30upx;
  box-sizing: border-box;
}

.order-info {
  /* border-bottom: 1px solid #eee; */
}

.order-info-item {
  display: flex;
  flex-direction: row;
  padding: 20upx 0;
  border-bottom: solid 1px #eee;
}

.order-info-item:last-child {
  border-bottom: none;
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
  margin-top: 30upx;
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

.afterSale-select-box {
  width: 100%;
  background: #fff;
  padding: 0 30upx;
  box-sizing: border-box;
}

.afterSale-select-box .item {
  height: 100upx;
  border-bottom: 1px solid #e5e5e5;
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: space-between;
  font-size: 28upx;
  color: #333;
}

.afterSale-select-box .item:last-of-type {
  border-bottom: none;
}

.afterSale-select-box .item.item-start {
  justify-content: flex-start;
}

.afterSale-select-box .item .l {
  display: flex;
  flex-direction: row;
  align-items: center;
}

.afterSale-select-box .item .afterSale-img {
  width: 26upx;
  height: 26upx;
  margin-right: 20upx;
}

.afterSale-select-box .item .r-box {
  display: flex;
  flex-direction: row;
  align-items: center;
  color: #999;
}

.afterSale-select-box .item .r-box2 {
  width: 100%;
  flex: 1;
}

.afterSale-select-box .item .r {
  width: 24upx;
  height: 24upx;
  margin-left: 10upx;
}

.afterSale-select-box .line {
  border-bottom: 1px solid #e5e5e5;
}

.mt20 {
  margin-top: 20upx;
}

.r-box-input {
  text-align: left;
  flex: 1;
  z-index: 0;
}

.upload-title {
  font-size: 28upx;
  color: #333;
  padding: 30upx 0;
}

.upload-img-box {
  display: flex;
  flex-direction: row;
  flex-wrap: wrap;
  padding: 0 0 30upx;
  align-items: flex-start;
}

.upload-img-box .single {
  display: flex;
  flex-direction: row;
  align-items: flex-end;
}

.upload-img-box .upload-img-item-box {
  position: relative;
}

.upload-img-box .upload-img-item {
  width: 150upx;
  height: 150upx;
  border-radius: 8upx;
  margin: 0 50upx 30upx 0;
}

.upload-img-box .upload-img-item:nth-of-type(3n) {
  margin-right: 0;
}

.upload-img-box .afterSale-close-img {
  position: absolute;
  top: -20upx;
  left: 110upx;
  width: 50upx;
  height: 50upx;
  border: 5upx solid #fff;
  border-radius: 50%;
}

.upload-img-box .single .jiahao {
  font-size: 70upx;
  color: #999;
  font-weight: 100;
}

.upload-img-box .single .upload-word {
  font-size: 24upx;
  color: #999;
}

.upload-img-box .single-kuang {
  width: 150upx;
  height: 150upx;
  background: #f5f5f5;
  border-radius: 8upx;
  display: flex;
  flex-direction: column;
  align-items: center;
}

.upload-img-box .single-num {
  margin-left: 10upx;
  font-size: 24upx;
  color: #999;
}

.order-flow-box {
  display: flex;
  flex-direction: column;
  padding: 30upx;
  box-sizing: border-box;
}

.flow-word {
  font-size: 24upx;
  color: #999;
  display: flex;
  flex-direction: column;
}

.mt25 {
  margin-top: 20upx;
}

.mt50 {
  margin-top: 30upx;
  margin-bottom: 20upx;
}

.order-confirm-box {
  position: fixed;
  bottom: 0;
  left: 0;
  width: 100%;
  height: 120upx;
  background: #fff;
  box-shadow: 0px 0px 10px 0px rgba(87, 69, 9, 0.3);
  padding: 0 30upx;
  box-sizing: border-box;
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: center;
}

.order-confirm-box .btn {
  width: 100%;
  height: 80upx;
  line-height: 80upx;
  background: #333333;
  font-size: 28upx;
  color: #F5DEB2;
  text-align: center;
}

.alert-box {
  width: 100%;
  height: 100%;
  background: rgba(0, 0, 0, 0.5);
  position: fixed;
  top: 0;
  left: 0;
}

.afterSale-status-box {
  width: 100%;
  background: #fff;
  border-radius: 15upx 15upx 0 0;
  position: fixed;
  bottom: 0;
  left: 0;
}

.status-title {
  width: 100%;
  height: 140upx;
  background: #fff;
  border-radius: 15upx 15upx 0 0;
  font-size: 34upx;
  color: #333;
  text-align: center;
  line-height: 140upx;
  position: fixed;
  left: 0;
}

.afterSale-status-box .item {
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: space-between;
  border-bottom: 1px solid #e5e5e5;
}

.afterSale-status-box .item:last-of-type {
  border-bottom: none;
}

.afterSale-status-box .item-box {
  padding: 140upx 0;
}

.afterSale-status-box .status-select-title {
  padding: 0 0 0 30upx;
  box-sizing: border-box;
  font-size: 28upx;
  color: #333;
}

.afterSale-status-box .status-select-img {
  width: 104upx;
  height: 100upx;
  padding: 28upx 30upx;
  box-sizing: border-box;
}

.afterSale-status-box .status-btn {
  width: 100%;
  height: 100upx;
  line-height: 100upx;
  background: #ff7911;
  font-size: 28upx;
  color: #fff;
  text-align: center;
  position: fixed;
  bottom: 0;
  left: 0;
}
</style>
<style lang="scss" scoped>
@import "../../style/images";
.evaluateImg ::v-deep .u-upload .u-list-item {
  background: none;
  border: 2rpx solid #E4E5E6;
  border-radius: 0;
  margin-bottom: 20rpx;
}

.evaluateImg ::v-deep .u-upload .u-list-item .uicon-plus:before {
  content: '';
  height: 71rpx;
  width: 71rpx;
  background: $addImgIcon no-repeat center center;
  display: block;
  background-size: contain;
}
</style>
