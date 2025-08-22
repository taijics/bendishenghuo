<template>
	<view class="container">
    <global-loading />

    <!-- 评论详情 -->
		<view class="evaluate-contentbox">
			<view class="evaluate-content flex-items flex-row flex-sp-between">
				<view class="flex-items">
					<image class="user-headSmallImg" v-if="commentVOList.headImage" :src="commentVOList.headImage"></image>
					<image class="user-headSmallImg" :src="`${VUE_APP_STATIC_URL}static/images/storeIcon.png`" v-else ></image>
					<label class="fs28 mar-left-20" v-if="commentVOList.name">{{commentVOList.name}}</label>
					<label class="fs28 mar-left-20" v-else>匿名</label>
				</view>
				<label class="font-color-999 fs22">{{commentVOList.createTime}}</label>
			</view>
			<view class="fs22 font-color-999 mar-top-10">
				{{commentVOList.value}}
			</view>
			<view class="fs26 pad-topbot-20">{{commentVOList.comment}}</view>
			<view class="evaluateImg-box" v-if="commentVOList.image">
				<view v-for="(cItem, index) in imageList" :key="index" @click="previewImg(1, index)">
					<image class="evaluate-Img" :src="cItem"></image>
				</view>
			</view>
			<view class="addComments-box flex-column-plus" v-if="commentVOList.addComment">
				<label class="font-color-C5AA7B mar-top-30">用户追评</label>
				<label class="mar-top-20">{{commentVOList.addComment}}</label>
				<view class="evaluateImg-box mar-top-20" v-if="commentVOList.addImage">
					<view v-for="(dItem, index) in imgDataResult" :key="index" @click="previewImg(2, index)">
						<image class="evaluate-Img" :src="dItem"></image>
					</view>
				</view>
			</view>
			<view class="goodsDes-box flex-column-plus mar-top-30">
				<view class="flex-row-plus" @click="goGoodsDetails">
					<image class="goodsDes-img" :src="commentVOList.productImage"></image>
					<view class="goodsDesText-box">
						<label class="fs26 goodsDes-text">{{commentVOList.productName}}</label>
						<view class="mar-top-70">
							<label>¥ {{commentVOList.productPrice}}</label>
						</view>
					</view>
				</view>
			</view>
		</view>
<!--    {{commentVOList}}-->
		<view class="linkBox">
			<view class="butBox flex-row-plus" v-if="commentVOList.addComment != ''">
				<view class="addPraise-box1 flex-items-plus" @click="zanTap">
          <image class="addPraise-icon" :src="`${VUE_APP_STATIC_URL}static/images/praiseIcon.png`" v-if="!commentVOList.ifLike"/>
          <image class="addPraise-icon" :src="`${VUE_APP_STATIC_URL}static/images/praiseActiveIcon2.png`" v-else/>
          <label :class="['mar-left-10',commentVOList.ifLike?'font-color-FFEBC4':'font-color-DDD']">点赞</label>
				</view>
			</view>
			<view class="butBox flex-row-plus" v-else>
				<view class="addComments-box flex-items-plus" @click="addCommentsClick()">
					<image class="addComments-cion" :src="`${VUE_APP_STATIC_URL}static/images/addCommentsIcon.png`"></image>
					<label class="mar-left-10 font-color-333">追加评价</label>
				</view>
				<view class="addPraise-box flex-items-plus" @click="zanTap">
					<image class="addPraise-icon" :src="`${VUE_APP_STATIC_URL}static/images/praiseIcon.png`" v-if="!commentVOList.ifLike"/>
          <image class="addPraise-icon" :src="`${VUE_APP_STATIC_URL}static/images/praiseActiveIcon2.png`" v-else/>
					<label :class="['mar-left-10',commentVOList.ifLike?'font-color-FFEBC4':'font-color-DDD']">点赞</label>
				</view>
			</view>
		</view>
	</view>
</template>

<script setup>
import { VUE_APP_STATIC_URL } from "@/config/api";
import { request } from "@/utils/request";
import API from "@/config/api";
import { ref } from "vue";
import { onBackPress, onLoad } from "@dcloudio/uni-app";
const commentVOList=ref({})
const actionType=ref(true)
const imgDataResult=ref( [])
const imageList=ref( [])

onLoad(()=> {
  commentVOList.value = uni.getStorageSync('commentVOList');
  uni.removeStorageSync('commentVOList')
  commentImgData(commentVOList.value.image)
  imgDataResultData(commentVOList.value.addImage)
})
// onBackPress(e=>{
//   if (e.from === 'navigateBack') {
//     return false;
//   }
//   back();
//   return true;
// })

function goGoodsDetails(){
  let shopId = commentVOList.value.shopId
  let productId = commentVOList.value.productId
  let skuId = commentVOList.value.skuId
  uni.navigateTo({
    url:'goodsDetails?shopId='+shopId+'&productId='+productId+'&skuId='+skuId
  })
}

function back(){
  uni.navigateTo({
    url:'userEvaluate'
  })
}

function commentImgData(imgData){
  imageList.value = imgData.split(",");
}

function imgDataResultData(imgData){
  imgDataResult.value = imgData.split(",");
}

//点赞
function zanTap(){
  // uni.showLoading({
  //   title:''
  // })
  actionType.value = commentVOList.value.ifLike == 1 ?0:1
  request(API.LikeOrUnLikeComment,{
    commentId: commentVOList.value.commentId,
    ifLike: actionType.value
  },'POST').then(res => {
    commentVOList.value.ifLike =  !commentVOList.value.ifLike
    commentVOList.value.likes = commentVOList.value.ifLike ? commentVOList.value.likes + 1 : commentVOList.value.likes - 1
    if(actionTyp.value == 1){
      uni.showToast({
        title: '点赞成功',
      })
    }else{
      uni.showToast({
        title: '已取消点赞',
        icon:"none"
      })
    }
  }).catch(res => {
    uni.hideLoading()
  }).finally(()=>{uni.hideLoading()})
}

//追加评论
function addCommentsClick(){
  uni.setStorageSync('addCommentVOList', commentVOList.value);
  uni.navigateTo({
    url:'addEvaluate?type=2'
  })
}

// 预览图片多张
function previewImg(type, index) {
  let imgsArray = [];
  if (type === 1) {
    for (let i = 0; i < imageList.value.length - 1; i++) {
      imgsArray.push(imageList[i]);
    }
  } else {
    for (let i = 0; i < imgDataResult.value.length - 1; i++) {
      imgsArray.push(imgDataResult.value[i]);
    }
  }
  uni.previewImage({
    current: index,
    urls: imgsArray,
  });
}
</script>

<style lang="scss">
	.container{
		padding-bottom: 30upx;
		.evaluate-contentbox{
			display: flex;
			justify-content: center;
			flex-direction: column;
			padding: 30upx 30upx;
			background-color: #FFFFFF;
			.evaluate-content{
				width: 670upx;
				display: flex;
				justify-content: space-between;
				.user-headSmallImg{
					width: 46upx;
					height: 46upx;
					border-radius: 50%;
				}
			}
			.evaluateImg-box{
				display: flex;
				flex-direction: row;
				flex-wrap: wrap;
				margin-left: -9upx;
				.evaluate-Img{
					width: 224upx;
					height: 224upx;
					border-radius: 10upx;
					margin-left: 9upx;
					margin-top: 9upx;
				}
			}
			.goodsDes-box{
				background-color: #F7F7F7;
				padding: 20upx 44upx 20upx 20upx;
				.goodsDes-img{
					width: 180upx;
					height: 180upx;
					border-radius: 10upx;
				}
				.goodsDesText-box{
					width: 416upx;
					margin-left: 30upx;
				}
				.addCommentsBut{
					width: 150upx;
					height: 56upx;
					border: 1upx solid #FF7800;
					border-radius: 28upx;
					font-size: 26upx;
					line-height: 56upx;
					text-align: center;
					color: #FF7800;
				}
				.praise-box{
					.praise-icon{
						width: 36upx;
						height: 36upx;
					}

				}
			}
			.addComments-box{
				border-top: 1upx solid #EEEEEE;
				margin-top: 35upx;
			}
		}
		.butBox{
      padding: 0 30rpx;
      display: flex;
      justify-content: space-between;
			.addComments-box{
				height: 100upx;
				width: 330upx;
				background-color: #FFFFFF;
				color: #333333;
        border: 2rpx solid #333333;
				.addComments-cion{
					width: 50upx;
					height: 50upx;
				}
			}
			.addPraise-box{
				height: 100upx;
				width: 330upx;
				background: #333333;
				color: #FFFFFF;
				.addPraise-icon{
					width: 50upx;
					height: 50upx;
				}
			}
			.addPraise-box1{
				height: 100upx;
				width: 690upx;
				background: #333333;
				color: #FFFFFF;
				.addPraise-icon{
					width: 50upx;
					height: 50upx;
				}
			}

		}
	}
	.linkBox{
		position: absolute;
		bottom: 20upx;
    width: 100%;
	}
</style>
