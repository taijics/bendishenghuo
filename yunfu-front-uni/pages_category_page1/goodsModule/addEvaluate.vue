<template>
  <view class="container">
    <!-- 追加评论 -->
    <view class="addEvaluate-box flex-items-plus flex-column-plus">
      <view class="addEvaluate flex-column-plus">
        <view class="addEvaluateTitle-box flex-row-plus mar-top-20 mar-left-20">
          <image
              class="title-img"
              :src="productImage"
          ></image>
          <view class="title-textbox overflow">
            <label class="fs28 title-text">{{ orderProductVO.productName }}</label>
            <view
                v-if="orderProductVO.value"
                class="fs24 mar-top-10 sukValue"
            >
              {{ orderProductVO.value }}
            </view>
            <view
                v-else
                class="font-color-999 fs24 mar-top-10"
            >
              默认规格
            </view>
          </view>
        </view>
        <view class="fs26 mar-top-40 mar-left-20 addEvaluateText">追加评价</view>
        <view class="textarea-box mar-top-20 mar-left-20">
          <textarea
              class="textarea-text"
              v-model="commentText"
              placeholder-style="color:#BBBBBB"
              placeholder="亲，有什么需要追加的吗"
          />
        </view>
        <view class="mar-left-10 mar-top-10 evaluateImg">
          <Upload
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
      <submit-button width="690rpx" text="追加评论" @submitEvent="submitTap"></submit-button>
    </view>
  </view>
</template>

<script setup>
import { request } from "@/utils/request";
import API from "@/config/api";
import { inject, ref } from "vue";
import { onLoad, onReady } from "@dcloudio/uni-app";
import Upload from '@/uni_modules/vk-uview-ui/components/u-upload/u-upload.vue'
import {btnUseLoading} from "../../hooks/bntUseLoading";

const { btnShowLoading } = btnUseLoading()
const addCommentVOList = ref({});
const orderProductVO = ref({});
const commentText = ref('');
const fileList = ref([]);
const commentImgsFlag = ref(false);
const commentImgs = ref('');
const action = ref(API.UploadUrl);
const formData = ref({'folderId': -1});
const headerToken = ref({Authorization: ''});
const productImage = ref('');
const commentId = ref('');
const type = ref(0);


const $getJumpParam = inject('$getJumpParam')
onLoad((options) => {
  type.value = options.type;
  if (options.detail) {
    const params = $getJumpParam(options)
    addCommentVOList.value = params.addCommentVOList
    orderProductVO.value = options.type === 1 ? addCommentVOList.value.skus[0] : addCommentVOList.value
    productImage.value = orderProductVO.value.image
  } else {
    if (options.type == 1) {
      addCommentVOList.value = uni.getStorageSync('addCommentVOList');
      orderProductVO.value = addCommentVOList.value.skus[0]
      productImage.value = orderProductVO.value.image
    } else {
      addCommentVOList.value = uni.getStorageSync('addCommentVOList');
      orderProductVO.value = addCommentVOList.value
      productImage.value = orderProductVO.value.productImage
    }
    uni.removeStorageSync('addCommentVOList')
  }
  if (options.commentId) {
    commentId.value = options.commentId
  }
  const res = uni.getStorageSync('storage_key');
  headerToken.value.Authorization = res.token
})
const uUpload = ref()
onReady(() => {
  fileList.value = uUpload.value.lists
})


const submitTap = () => {
  if (!commentText.value) {
    uni.showToast({
      title: '请先说点什么吧',
      icon: 'none'
    })
    return
  }
  if (fileList.value && fileList.value.length > 0) {
    commentImgsFlag.value = true
    for (let i = 0; i < fileList.value.length; i++) {
      commentImgs.value += fileList.value[i].response.data.url + ','
    }
  }
  let data = []
  if (type.value == 1) {
    data = [{
      commentId: commentId.value,
      image: commentImgs.value,
      comment: commentText.value
    }]
  } else if (type.value == 2) {
    data = [{
      commentId: addCommentVOList.value.commentId,
      image: commentImgs.value,
      comment: commentText.value
    }]
  }
  btnShowLoading()
  request(API.AdditionalComment, {params: data}, 'POST').then(res => {
    uni.hideLoading()
    uni.showToast({
      title: '追评成功',
    })
    setTimeout(() => {
      uni.redirectTo({
        url: 'userEvaluate'
      })
    }, 1500);
  }).catch(res => {
    uni.hideLoading()
    uni.showToast({
      title: res.message,
    })
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
        font-weight: bold;
      }

      .addEvaluateTitle-box {
        .title-img {
          width: 90upx;
          height: 90upx;
          border-radius: 4upx;
        }

        .title-textbox {
          width: 530upx;
          margin-left: 20upx;
          font-weight: bold;

          .sukValue {
            color: #CCCCCC;
            font-weight: 400;
          }
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
</style>
