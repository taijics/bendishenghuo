<template>
	<view class="container">
    <!-- 评论商品 -->
		<view class="addEvaluate-box flex-items-plus flex-column-plus">
			<view class="addEvaluate flex-column-plus">
				<view class="addEvaluateTitle-box flex-row-plus mar-top-20 mar-left-20">
					<image class="title-img" :src="commentData.image"></image>
					<view class="title-textbox overflow">
						<label class="fs24 title-text">{{commentData.productName}}</label>
						<view class="font-color-999 fs22 mar-top-10">
							{{commentData.value}}
						</view>
					</view>
				</view>
				<view class="fs26 mar-top-50 flex-display flex-sp-around">
					<label>宝贝描述</label>
					<u-rate v-model="commentStar" size="40" active-color="#C5AA7B" inactive-color="#b2b2b2" gutter="32" @change="onCommentStarChange"></u-rate>
					<label style="width: 80upx;" v-if="commentStar<2">差</label>
					<label style="width: 80upx;" v-else-if="commentStar<4">好</label>
					<label style="width: 80upx;" v-else>非常好</label>
				</view>
				<view class="textarea-box mar-top-40 mar-left-20">
					<textarea class="textarea-text" v-model="commentText" placeholder-style="color:#BBBBBB" placeholder="感谢您对宝贝的看法"/>
				</view>
				<view class="mar-left-10 evaluateImg">
          <Upload :action="action"
                    ref="uUpload"
                    :limitType="['png', 'jpg', 'jpeg', 'webp', 'gif', 'image']"
                    :header="headerToken"
                    :form-data="formData"
                    @on-success="handleUploadSuccess"
                    @on-remove="handleUploadRemove"
          >
          </Upload>
				</view>
<!--				 <view class="addPicture-box flex-column-plus">
					<label class="addPicture-icon">+</label>
					<label class="fs24 addPicture">图片</label>
				</view>-->
			</view>
		</view>
		<view class="storeEvaluate-box">
			<view class="storeEvaluate flex-start flex-column">
				<view class="fs26 mar-top-30 flex-display flex-sp-around">
					<label>描述相符</label>
					<u-rate v-model="descStar" size="40" @change="ondescStarChange" active-color="#C5AA7B" inactive-color="#b2b2b2" gutter="32"></u-rate>
					<label style="width: 80upx;" v-if="descStar<2">差</label>
					<label style="width: 80upx;" v-else-if="descStar<4">好</label>
					<label style="width: 80upx;" v-else>非常好</label>
				</view>
				<view class="fs26 mar-top-50 flex-display flex-sp-around">
					<label>物流服务</label>
					<u-rate v-model="logisticsStar" size="40" @click="onlogisticsStarChange" active-color="#C5AA7B" inactive-color="#b2b2b2" gutter="32"></u-rate>
					<label style="width: 80upx;" v-if="logisticsStar<2">差</label>
					<label style="width: 80upx;" v-else-if="logisticsStar<4">好</label>
					<label style="width: 80upx;" v-else>非常好</label>
				</view>
				<view class="fs26 mar-top-50 flex-display flex-sp-around">
					<label>服务态度</label>
					<u-rate v-model="serviceStar" size="40" @click="onserviceStarChange" active-color="#C5AA7B" inactive-color="#b2b2b2" gutter="32"></u-rate>
					<label style="width: 80upx;" v-if="serviceStar<2">差</label>
					<label style="width: 80upx;" v-else-if="serviceStar<4">好</label>
					<label style="width: 80upx;" v-else>非常好</label>
				</view>
			</view>
		</view>
		<view class="butBox flex-items-plus">
      <submit-button text="发表评论" @exchange="submitTap"></submit-button>
		</view>
	</view>
</template>

<script setup>
import Upload from "@/uni_modules/vk-uview-ui/components/u-upload/u-upload.vue"
import { request } from "@/utils/request";
import API from "@/config/api";
import { inject, onMounted, ref } from "vue";
import { onLoad, onReady } from "@dcloudio/uni-app";
import {btnUseLoading} from "../../hooks/bntUseLoading";

const { btnShowLoading } = btnUseLoading()
const commentData=ref( {});
const orderId=ref(0);
const commentStar=ref(5);
const descStar=ref(5);
const logisticsStar=ref(5);
const serviceStar=ref(5);
const fileList=ref([]);
const action=ref(API.UploadUrl);
const formData=ref({'folderId': -1});
const commentText=ref('');
const commentImgsFlag=ref(false);
const commentImgs=ref('');
const headerToken=ref({Authorization:''})

const $getJumpParam = inject('$getJumpParam')
onLoad((options=>{
  if(options.detail){
    const params = $getJumpParam(options)
    console.log(params)
    commentData.value = params.commentData
    orderId.value = params.orderId
  }else{
    commentData.value = uni.getStorageSync('evaluateItem')
    orderId.value = uni.getStorageSync('orderId')
    uni.removeStorageSync('evaluateItem')
    uni.removeStorageSync('orderId')
  }
  const res = uni.getStorageSync('storage_key');
  headerToken.value.Authorization = res.token
}))
const uUpload = ref()
onMounted(()=>{
  fileList.list =uUpload.value.lists
})

function onCommentStarChange(e){
  // commentStar.value = e
}
function ondescStarChange(e){
  // descStar.value = e
}
function onlogisticsStarChange(e){
  // logisticsStar.value = e
}
function onserviceStarChange(e){
  // console.log(serviceStar.value )
}
function handleUploadSuccess(data){
  fileList.value.push(data)
}
function handleUploadRemove(index){
  fileList.value.splice(index,1)
}
function submitTap(){
  if (!commentText.value) {
    uni.showToast({
      title: '请先说点什么吧',
      icon: 'none'
    })
    return
  }
  // uni.showLoading({
  //   mask: true,
  //     title: '提交中...',
  // })
  if(fileList.value.length>0){
    commentImgsFlag.value = true
    for(let i=0;i<fileList.value.length;i++){
      commentImgs.value += fileList.value[i].data.url+','
    }
  }
  let data = [{
    orderId:orderId.value,
    skuId:commentData.value.skuId,
    productId:commentData.value.productId,
    image:commentImgs.value,
    comment:commentText.value,
    star:commentStar.value,
    des:descStar.value,
    delivery:logisticsStar.value,
    attitude:serviceStar.value
  }]
  btnShowLoading()
  request(API.Comment, {
    params:data
  }, 'POST').then(res => {
    uni.hideLoading()
    uni.showToast({
      title: '评价成功',
    })
    setTimeout(() => {
      uni.redirectTo({
        url: '../goodsModule/evaSuccessful'
      })
    }, 1500);
  }).catch(err => {
    uni.hideLoading()
    uni.showToast({
      title: res.message,
    })
    throw Error(err)
  })
}
</script>
<style lang="scss">
	page{
		background-color: #F7F7F7;
	}
	.container{
		.addEvaluate-box{
			margin-top: 20upx;
			.addEvaluate{
				width: 690upx;
				height: auto;
				background-color: #FFFFFF;
				border-radius: 10upx;
				padding-bottom: 30upx;
				.addEvaluateTitle-box{
					.title-img{
						width: 90upx;
						height: 90upx;
						border-radius: 4upx;
					}
					.title-textbox{
						width: 530upx;
						margin-left: 20upx;
					}

				}
			}
			.textarea-box{
				.textarea-text{
					width: 610upx;
					height: 200upx;
					font-size: 26upx;
					padding: 20upx 20upx;
          border: 2rpx solid #E4E5E6;
				}
			}
			.addPicture-box{
				background-color: #F5F5F5;
				width: 150upx;
				height: 150upx;
				margin-top: 40upx;
				margin-left: 20upx;
				border-radius: 10upx;
				display: flex;
				justify-content: center;
				align-items: center;
				color: #BBBBBB;
				.addPicture-icon{
					font-size: 100upx;
					font-weight: 300;
					margin-top: -30upx;
				}
				.addPicture{
					margin-top: -20upx;
				}
			}
		}
		.storeEvaluate-box{
			margin-top: 20upx;
			margin-left: 30upx;
      height: 440upx;
			.storeEvaluate{
				background-color: #FFFFFF;
				width: 690upx;
				height: 270upx;
				border-radius: 10upx;
			}
		}
		.butBox{
      z-index: 999;
			position: fixed;
			bottom: 0;
      width: 100%;
      padding: 0 32rpx;
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
