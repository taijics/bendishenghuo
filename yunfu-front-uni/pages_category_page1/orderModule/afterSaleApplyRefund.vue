<template>
  <view class="container">
    <view
        class="content"
        style="padding-bottom:200upx;"
    >
      <view
          class="order-list-box"
          v-for="(item,index) in list"
          :key="index"
      >
        <view class="item">
          <view class="order-info-box">
            <view class="order-info">
              <view class="order-info-item">
                <image
                    :src="item.image"
                    class="product-img"
                ></image>
                <view class="info-box">
                  <text class="product-name">{{ item.productName }}</text>
                  <view class="product-sku">{{ item.sku }} {{ item.value }}</view>
                  <view class="price-sku-box">
                    <text class="product-price">
                      <text class="fuhao">￥</text>
                      {{ item.price }}
                    </text>
                    <text class="product-num">x {{ item.number }}</text>
                  </view>
                </view>
              </view>
            </view>
          </view>
        </view>
      </view>
      <view class="afterSale-select-box">
        <view
            class="item"
            @click="refundType"
        >
          <view class="l">退款类型</view>
          <view
              class="r-box"
              v-if="afterType == 1"
          >
            <text>仅退款</text>
            <image
                :src="`${VUE_APP_STATIC_URL}static/images/arrowRight.png`"
                class="r"
            ></image>
          </view>
          <view
              class="r-box"
              v-if="afterType == 2"
          >
            <text>退货退款</text>
            <image
                :src="`${VUE_APP_STATIC_URL}static/images/arrowRight.png`"
                class="r"
            ></image>
          </view>
        </view>
        <view
            class="item"
            @click="openStatusSelect"
        >
          <view class="l">货物状态</view>
          <view
              class="r-box"
              v-if="ReturnMoneyQuery.goodsState == 0"
          >
            <text>未收到货</text>
            <image
                :src="`${VUE_APP_STATIC_URL}static/images/arrowRight.png`"
                class="r"
            ></image>
          </view>
          <view
              class="r-box"
              v-if="ReturnMoneyQuery.goodsState == 1"
          >
            <text>已收到货</text>
            <image
                :src="`${VUE_APP_STATIC_URL}static/images/arrowRight.png`"
                class="r"
            ></image>
          </view>
        </view>
        <view
            class="item"
            @click="openReasonSelect"
        >
          <view class="l">退款原因</view>
          <view class="r-box">
            <text >{{ liyoutext }}</text>
            <image
                :src="`${VUE_APP_STATIC_URL}static/images/arrowRight.png`"
                class="r"
            ></image>
          </view>
        </view>
      </view>

      <view class="afterSale-select-box mt20">
        <view class="item">
          <view class="l">退款金额：
            <text class="order-status">¥ {{ sellPriceitem.toFixed(2) }}</text>
          </view>
        </view>
        <view class="item item-start">
          <view class="l">退款说明：</view>
          <view class="r-box r-box2">
            <input
                v-model="ReturnMoneyQuery.returnDesc"
                type="text"
                placeholder="选填"
                class="r-box-input"
            />
          </view>
        </view>
      </view>

      <view class="afterSale-select-box mt20">
        <view class="upload-title">上传凭证</view>
        <view class="mar-left-10 mar-top-10">
          <Upload :limitType="['png', 'jpg', 'jpeg', 'webp', 'gif', 'image']"
                  :max-count="4"
                  :action="action"
                  ref="uUpload"
                  :header="headerToken"
                  @on-success="handleUploadSuccess"
                  @on-remove="handleUploadRemove"
                  :form-data="formData"></Upload>
<!--          <u-upload-->
<!--              :limitType="['png', 'jpg', 'jpeg', 'webp', 'gif', 'image']"-->
<!--              max-count="4"-->
<!--              upload-text="上传凭证"-->
<!--              :action="action"-->
<!--              ref="uUpload"-->
<!--              :header="headerToken"-->
<!--              :form-data="formData"-->
<!--          ></u-upload>-->
        </view>
      </view>

      <view class="order-flow-box">
        <view class="flow-word">退款流程：</view>
        <view class="flow-word mt25">
          <text>1、退货说明并提交</text>
          <text>2、2天内等待卖家处理，超时默认同意退款</text>
          <text>3、卖家同意，退款金额原路退还</text>
        </view>
        <view class="flow-word mt50">注：退款金额以实际支付价格为准</view>
      </view>
    </view>

    <view
        class="order-confirm-box"
        style="padding-top:30upx;"
        :style="{'padding-bottom':(isIphone==true? 60:0)+'rpx'}"
    >
      <submit-button @submitEvent="confirmTap"></submit-button>
    </view>

    <!-- 货物状态弹框 -->
    <u-popup
        v-model="refundTypeShow"
        mode="bottom"
        border-radius="14"
    >
      <view class="alert-box">
        <view class="afterSale-status-box">
          <view class="status-title">退款类型</view>
          <view class="item-box">
            <view
                class="item"
                @click="afterType = 1"
            >
              <text class="status-select-title">仅退款</text>
              <image
                  mode="aspectFill"
                  :src="`${VUE_APP_STATIC_URL}static/images/selectActive.png`"
                  v-if="afterType == 1"
                  class="status-select-img"
              ></image>
              <image
                  mode="aspectFill"
                  :src="`${VUE_APP_STATIC_URL}static/images/selectEmpty.png`"
                  v-else
                  class="status-select-img"
              ></image>
            </view>
            <view
                class="item"
                @click="afterType = 2"
            >
              <text class="status-select-title">退货退款</text>
              <image
                  mode="aspectFill"
                  :src="`${VUE_APP_STATIC_URL}static/images/selectActive.png`"
                  v-if="afterType == 2"
                  class="status-select-img"
              ></image>
              <image
                  mode="aspectFill"
                  :src="`${VUE_APP_STATIC_URL}static/images/selectEmpty.png`"
                  v-else
                  class="status-select-img"
              ></image>
            </view>
          </view>
          <view
              class="status-btn"
              @click="closeAfterSelect"
          >确定
          </view>
        </view>
      </view>
    </u-popup>
    <u-popup
        v-model="cargoStatusShowFalg"
        mode="bottom"
        border-radius="14"
    >
      <view class="alert-box">
        <view class="afterSale-status-box">
          <view class="status-title">货物状态</view>
          <view class="item-box">
            <view
                class="item"
                @click="ReturnMoneyQuery.goodsState = 0"
            >
              <text class="status-select-title">未收到货</text>
              <image
                  mode="aspectFill"
                  :src="`${VUE_APP_STATIC_URL}static/images/selectActive.png`"
                  v-if="ReturnMoneyQuery.goodsState == 0"
                  class="status-select-img"
              ></image>
              <image
                  mode="aspectFill"
                  :src="`${VUE_APP_STATIC_URL}static/images/selectEmpty.png`"
                  v-else
                  class="status-select-img"
              ></image>
            </view>
            <view
                class="item"
                @click="ReturnMoneyQuery.goodsState = 1"
            >
              <text class="status-select-title">已收到货</text>
              <image
                  mode="aspectFill"
                  :src="`${VUE_APP_STATIC_URL}static/images/selectActive.png`"
                  v-if="ReturnMoneyQuery.goodsState == 1"
                  class="status-select-img"
              ></image>
              <image
                  mode="aspectFill"
                  :src="`${VUE_APP_STATIC_URL}static/images/selectEmpty.png`"
                  v-else
                  class="status-select-img"
              ></image>
            </view>
          </view>
          <view
              class="status-btn"
              @click="closeStatusSelect"
          >确定
          </view>
        </view>
      </view>
    </u-popup>
    <!-- 退款原因弹框 -->
    <u-popup
        v-model="reasonShowFalg"
        mode="bottom"
        border-radius="14"
    >
      <view class="alert-box">
        <view
            class="afterSale-status-box"
            scroll-y
            style="height:1000rpx;"
        >
          <view class="status-title">退款原因</view>
          <view class="item-box">
            <view
                class="item"
                @click="returnReasonTap(item,index)"
                v-for="(item,index) in liyouData"
                :key="index"
            >
              <text class="status-select-title">{{ item }}</text>
              <image
                  mode="aspectFill"
                  :src="`${VUE_APP_STATIC_URL}static/images/selectActive.png`"
                  v-if="ReturnMoneyQuery.returnReason == index"
                  class="status-select-img"
              ></image>
              <image
                  mode="aspectFill"
                  :src="`${VUE_APP_STATIC_URL}static/images/selectEmpty.png`"
                  v-else
                  class="status-select-img"
              ></image>
            </view>
          </view>
          <view
              class="status-btn"
              @click="closeReasonSelect"
          >确定
          </view>
        </view>
      </view>
    </u-popup>
  </view>
</template>

<script setup>
import { ref } from "vue"
import { request } from '../../utils/request'
import API from "../../config/api";
import Upload from '@/uni_modules/vk-uview-ui/components/u-upload/u-upload.vue'
import { onReady, onLoad } from "@dcloudio/uni-app";
import { VUE_APP_STATIC_URL } from "@/config/api";
import {btnUseLoading} from "../../hooks/bntUseLoading";

const { btnShowLoading } = btnUseLoading()
const returnImgsList = ref(1);
const cargoStatusShowFalg = ref(false);
const refundTypeShow = ref(false);
const reasonShowFalg = ref(false);
const returnReasonIndex = ref(1);
const list = ref([]);
const ReturnMoneyQuery = ref({
  goodsState: 0,
  orderCode: '',
  orderProductIds: '',
  refundFee: 0,
  returnDesc: '',
  returnImgs: '',
  returnReason: 0
});
const action = ref(API.UploadUrl);
const formData = ref({'folderId': -1});
const headerToken = ref({Authorization: ''});
const fileList = ref([]);
const sellPriceitem = ref(0);
const orderCode = ref('');
const liyouData = ref([]);
const liyoutext = ref('');
const liyouindex = ref('');
const afterRefund = ref('');
const orderId = ref(0);
const isIphone = ref(false);
const commentImgs = ref('');
const afterType = ref(1);
const isAllSelect = ref(0);
// const uUpload = ref(null)

onReady(() => {
  isIphone.value = getApp().globalData.isIphone;
  // fileList.value = uUpload.value.lists
})

onLoad(async (options) => {
  if (uni.getStorageSync('applyItem')) {
    afterRefund.value = uni.getStorageSync('applyItem')
    list.value.push(afterRefund.value)
  } else if (uni.getStorageSync('afterSaleApplyRefund')) {
    list.value = uni.getStorageSync('afterSaleApplyRefund')
  }
  console.log(list.value, 'this.list')
  orderId.value = parseInt(options.orderId)
  isAllSelect.value = options.isAllSelect
  console.log(isAllSelect.value, 'this.isAllSelect')
  const res = uni.getStorageSync('storage_key');
  headerToken.value.Authorization = res.token
  list.value.forEach(el => {
    if (isAllSelect.value > 0) {
      sellPriceitem.value = sellPriceitem.value + (el.number * el.price) + el.logisticsPrice
    } else {
      sellPriceitem.value = sellPriceitem.value + (el.number * el.price)
    }

  })
  getReasonEnums()
  uni.removeStorageSync('applyItem')
  uni.removeStorageSync('afterSaleApplyRefund')
  sellPriceitem.value = await HandleGetRefundMoney()
})

/**
 * 算钱
 */
const HandleGetRefundMoney = () => {
  return new Promise((resolve, reject) => {
    let postData = {
      orderId: orderId.value,
      isAllSelect: isAllSelect.value == 1 ? 1 : 0,
      skus: list.value,
      afterType: 2,
      goodsState: ReturnMoneyQuery.value.goodsState
    }
    request(API.GetRefundMoney, postData, "POST").then(res => {
      uni.hideLoading()
      resolve(parseFloat(res.json))
    }).catch(err => {
      uni.hideLoading()
      throw Error(err)
    })
  })
}

function handleUploadSuccess(data){
  fileList.value.push(data)
}
function handleUploadRemove(index){
  fileList.value.splice(index,1)
}


const confirmTap = () => {
  console.log(fileList.value, 'commentImgs')
  if (fileList.value.length > 0) {
    // commentImgsFlag.value = true
    for (let i = 0; i < fileList.value.length; i++) {
      commentImgs.value += fileList.value[i].data.url + ','
    }
  }
  ReturnMoney()
}

const getReasonEnums = () => {
  request(API.ReasonEnums, 'GET').then(res => {
    liyouData.value = res.data
    liyoutext.value = liyouData.value[0]
  }).catch(err => {
    throw Error(err)
  })
}

const ReturnMoney = async () => {
  if (ReturnMoneyQuery.value.goodsState === '') {
    uni.showToast({
      title: '请选择货物状态！',
      duration: 2000,
      icon: 'none'
    });
  } else if (liyoutext.value == '') {
    uni.showToast({
      title: '请选择退款原因！',
      duration: 2000,
      icon: 'none'
    });
  } else {
    let skusobjdata = [];
    list.value.forEach((i) => {
      let skusobj = {}
      skusobj["skuId"] = i.skuId
      skusobj["number"] = i.number
      skusobjdata.push(skusobj)
    })
    try {
      btnShowLoading()
      const res = request(API.ApplyReturnMoney, {
        orderId: orderId.value,
        afterType: afterType.value,
        goodsState: ReturnMoneyQuery.value.goodsState,
        price: sellPriceitem.value,
        returnReason: liyoutext.value,
        explain: ReturnMoneyQuery.value.returnDesc,
        image: commentImgs.value,
        skus: skusobjdata,
        isAllSelect: isAllSelect.value
      }, 'POST')
      uni.showToast({
        title: '提交成功'
      })
      setTimeout(() => {
        uni.navigateTo({
          url: '../../pages_category_page2/orderModule/afterSale'
        })
      }, 2000)
    } catch (err) {
      throw Error(err)
    }
  }
}

// 理由
const returnReasonTap = (item, index) => {
  ReturnMoneyQuery.value.returnReason = index
  liyoutext.value = item
}

const openStatusSelect = () => {
  cargoStatusShowFalg.value = true
}

const refundType = () => {
  refundTypeShow.value = true
}
const openReasonSelect = () => {
  reasonShowFalg.value = true
}

const closeStatusSelect = async () => {
  cargoStatusShowFalg.value = false
  sellPriceitem.value = await HandleGetRefundMoney()

}

const closeAfterSelect = () => {
  refundTypeShow.value = false
}

const closeReasonSelect = () => {
  reasonShowFalg.value = false
}
</script>

<style lang="scss">
.u-active {
  display: none !important;
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
  color: #C83732;
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
  height: 180upx;
  background: #fff;
  padding: 0 30rpx 10rpx 30rpx;
  box-sizing: border-box;
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: center;
}

.order-confirm-box .btn {
  width: 100%;
  height: 100upx;
  line-height: 100upx;
  background: #333333;
  font-size: 28upx;
  color: #fff;
  text-align: center;
}

.alert-box {
  width: 100%;
  height: 100%;
}

.afterSale-status-box {
  width: 100%;
  background: #fff;
  border-radius: 15upx 15upx 0upx 0upx;
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
  z-index: 99;
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
  width: 40upx;
  height: 40upx;
  margin: 30upx;
  box-sizing: border-box;
}

.afterSale-status-box .status-btn {
  width: 100%;
  height: 100upx;
  line-height: 100upx;
  background: #333333;
  font-size: 28upx;
  color: #F5DEB2;
  text-align: center;
  position: fixed;
  bottom: 0;
  left: 0;
}
</style>
<style lang="scss" scoped>
@import "../../style/images";
.afterSale-select-box ::v-deep .u-upload .u-list-item {
  background: #FFFFFF;
  border: 2rpx solid #E4E5E6;
}

.afterSale-select-box ::v-deep .u-upload .uicon-plus:before {
  content: '';
  width: 80rpx;
  height: 80rpx;
  background: $addImgIcon center center;
  background-size: contain;
}

.afterSale-select-box ::v-deep .u-add-tips {
  color: #999999 !important;
}
</style>
