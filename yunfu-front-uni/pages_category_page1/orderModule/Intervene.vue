<template>
  <view class="container">
    <global-loading />

    <!-- 平台介入 -->
    <view class="addEvaluate-box flex-items-plus flex-column-plus">
      <view class="addEvaluate flex-column-plus">
        <view class="fs26 mar-top-40 mar-left-20 addEvaluateText"><label>*</label>问题描述</view>
        <view class="textarea-box mar-top-20 mar-left-20">
          <textarea
              class="textarea-text"
              v-model="commentText"
              placeholder-style="color:#BBBBBB"
              placeholder="填写相关问题"
          />
        </view>
        <view class="fs26 mar-top-40 mar-left-20 addEvaluateText"><label>*</label>举证照片</view>
        <view class="mar-left-10 mar-top-10 evaluateImg">
          <Upload
              upload-text="上传凭证"
              :action="action"
              ref="uUpload"
              :limitType="['png', 'jpg', 'jpeg', 'webp', 'gif', 'image']"
              :header="headerToken"
              :form-data="formData"
          ></Upload>
        </view>
      </view>
    </view>
    <view class="butBox flex-items-plus mar-left-30">
      <view
          class="submitbut"
          @click="submitTap"
      >提交
      </view>
    </view>
  </view>
</template>

<script setup>
import API from "../../config/api";
import { ref } from "vue";
import { onLoad, onReady } from "@dcloudio/uni-app";
import { request } from "@/utils/request";
import Upload from '@/uni_modules/vk-uview-ui/components/u-upload/u-upload.vue'

const addCommentVOList = ref({})
const orderProductVO = ref({})
const commentText = ref('')
const fileList = ref([])
const commentImgsFlag = ref(false)
const commentImgs = ref('')
const action = ref(API.UploadUrl)
const formData = ref({'folderId': -1})
const headerToken = ref({Authorization: ''})
const productImage = ref('')
const afterId = ref(0)
const orderId = ref(0)
onLoad(options=>{
  afterId.value = options.afterId;
  orderId.value = options.orderId;
})
const uUpload = ref()
onReady(()=>{
  fileList.value = uUpload.value.lists
})

function submitTap() {
  if (!commentText.value) {
    uni.showToast({
      title: '请先说点什么吧',
      icon: 'none'
    })
    return false
  }
  if (fileList.value.length > 0) {
    commentImgsFlag.value = true
    for (let i = 0; i < fileList.value.length; i++) {
      commentImgs.value += fileList.value[i].response.data.url + ','
    }
  } else {
    uni.showToast({
      title: '请上传举证图片',
    })
    return false
  }
  // uni.showLoading({
  //   title:'正在申请介入...'
  // })
  request(API.platform, {
    afterId: afterId.value,
    orderId: orderId.value,
    image: commentImgs.value,
    reason: commentText.value
  }, 'POST').then(res => {
    uni.hideLoading()
    uni.showToast({
      title: '申请成功',
    })
    setTimeout(() => {
      uni.navigateTo({
        url: `../../pages_category_page2/orderModule/afterSale`
      })
    }, 2000)
  }).catch(res => {
    uni.hideLoading()
  })
}

</script>

<style lang="scss">
page {
  background-color: #F7F7F7;
}

.container {
  .addEvaluate-box {
    margin-top: 20upx;

    .addEvaluate {
      width: 690upx;
      background-color: #FFFFFF;
      border-radius: 10upx;
      padding-bottom: 30upx;

      .addEvaluateText {
        font-weight: 400;

        label {
          color: #C5AA7B;
          margin-right: 10rpx;
        }
      }
    }

    .textarea-box {
      .textarea-text {
        width: 610upx;
        height: 200upx;
        background-color: #FFFFFF;
        font-size: 26upx;
        padding: 20upx 20upx;
        border: 2rpx solid #E4E5E6;
      }
    }

    .addPicture-box {
      background-color: #F5F5F5;
      width: 40upx;
      height: 40upx;
      margin-top: 100upx;
      margin-left: 100upx;
      border-radius: 10upx;
      display: flex;
      justify-content: center;
      align-items: center;
      color: #BBBBBB;
    }
  }

  .butBox {
    position: absolute;
    bottom: 40upx;

    .submitbut {
      height: 100upx;
      width: 690upx;
      background: #333333;
      color: #FFEBC4;
      font-size: 28upx;
      text-align: center;
      line-height: 100upx;
    }
  }
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

.evaluateImg ::v-deep .u-add-tips {
  color: #999999 !important;
}
</style>
