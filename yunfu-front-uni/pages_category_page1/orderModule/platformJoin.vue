<!-- 退货/退款上传凭证 -->
<template>
	<view>
    <global-loading />

    <view class="content">
			<view class="afterSale-select-box mt20">
				<view class="item item-start">
					<view class="l"><text class="font-color-C5AA7B">*</text>问题描述</view>
				</view>
		    <textarea v-model="reason" class="text-area" placeholder="填写相关问题" placeholder-style="color:#bbb;" bindinput="proofRemarkInput"></textarea>
			</view>

			<view class="afterSale-select-box mt20">
				<view class="upload-title">举证图片</view>
				<view class="upload-img-box">
          <view class="mar-left-10 mar-top-10 evaluateImg">
            <Upload :action="action" ref="uUpload" :limitType="['png', 'jpg', 'jpeg', 'webp', 'gif', 'image']" :header="headerToken" :form-data="formData"></Upload>
          </view>
				</view>
			</view>
		</view>

		<view class="order-confirm-box">
			<text class="btn" bindtap="subimtTap" @click="interventionFn">提交</text>
		</view>
	</view>
</template>

<script setup>
import { request } from '../../utils/request'
import API from "../../config/api";
import { onLoad, onReady } from "@dcloudio/uni-app";
import { ref } from "vue";
import Upload from '@/uni_modules/vk-uview-ui/components/u-upload/u-upload.vue'

    const returnImgsList=ref(1)
    const fileList=ref([])
    const commentImgs=ref('')
    const action=API.UploadUrl
    const formData=ref({'folderId': -1})
    const headerToken=ref({Authorization:''})
    const afterId=ref( '')
    const orderId=ref( '')
    const reason=ref( '')
onLoad(options=>{
  afterId.value = options.afterId
  orderId.value = options.orderId
})
const uUpload = ref()
onReady(()=> {
  fileList.value = uUpload.value.lists
})

function interventionFn() {
  if (reason.value === '') {
    uni.showToast({
      title:'请填写问题描述',
      icon:"none"
    })
    return false
  }
  if(fileList.value.length>0){
    for(let i=0;i<fileList.value.length;i++){
      commentImgs.value += fileList.value[i].response.data.url+','
    }
  }
  // uni.showLoading({
  //   mask: true,
  //   title:'正在申请介入...'
  // })
  request(API.platform, {
    afterId: afterId.value,
    orderId: orderId.value,
    image: commentImgs.value,
    reason: reason.value
  }, 'POST').then(res => {
    uni.hideLoading()
    uni.showToast({
      title:'申请成功',
    })
    uni.navigateBack({
      delta: 1
    });
  }).catch(res => {
    uni.hideLoading()
  })
}

</script>

<style>
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
.order-info-item:last-child{
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
  padding: 0 30upx 30upx 30upx;
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
  color: #C5AA7B;
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

.afterSale-status-box  .status-select-title {
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

.afterSale-status-box  .status-btn {
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
.text-area{
  width: 690upx;
  background: #F7F7F7;
  padding: 30upx;
  box-sizing: border-box;
  margin-bottom: 30upx;
}


</style>
<style lang="scss" scoped>
@import "../../style/images";
.evaluateImg ::v-deep .u-upload .u-list-item {
  background: none;
  border: 2rpx solid #E4E5E6;
  border-radius: 0;
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
