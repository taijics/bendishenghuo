<template>
	<view class="container">
		<!-- 查看全部评论 -->
    <view class="evaluateTag-box"  >
			<view class="evaluateTag-text">
				全部({{commentListLength}})
			</view>
		</view>
		<view class="flex-column-plus evaluateList-box">
			<view class="evaluate-contentbox mar-top-20" v-for="(item,index) in commentList" :key="index">
				<view class="evaluate-content flex-items flex-row flex-sp-between">
					<view class="flex-items">
						<image class="user-headSmallImg" :src="item.headImage"></image>
            <view class="">
              <text class="fs28 mar-left-20">{{item.name}}</text>
              <view class="mar-left-20 fs22 font-color-999 mar-top-10">
                <text>{{item.value}}</text>
              </view>
            </view>
					</view>
				</view>
				<view class="fs26 pad-topbot-20 font-color-333">{{item.comment}}</view>
				<view class="evaluateImg-box">
					<view v-for="(commentItemImg, cindex) in item.images" :key="cindex">
						<image @click="previewImg(commentItemImg)" class="img-item" :src="commentItemImg"></image>
					</view>
				</view>
        <view class="addEvaluate" v-if="item.addComment !== ''">
          <view class="fs26 font-color-C5AA7B">用户追加评价</view>
          <view class="addEvaluateText">{{item.addComment}}</view>
          <view class="item-image-box" v-if="item.addImages">
            <view v-for="(itemAddImg, imgIndex) in item.addImages" :key="imgIndex">
              <image @click='previewImg(itemAddImg)' class="img-item" :src="itemAddImg"></image>
            </view>
          </view>
        </view>
				<view class="praisebig-box flex-items mar-top-30 flex-sp-between">
          <text class="font-color-999 fs22">{{item.createTime}}</text>
					<view class="praise-box flex-items flex-row">
						<image class="praise-icon" @click="zanTap(index,item.commentId,0)" :src="`${VUE_APP_STATIC_URL}static/images/praiseActiveIcon.png`"
						 v-if="item.ifLike == 1"></image>
						<image class="praise-icon" @click="zanTap(index,item.commentId,1)" :src="`${VUE_APP_STATIC_URL}static/images/praiseIcon.png`" v-else></image>
						<text class="mar-left-10 font-color-999">{{item.likes}}</text>
					</view>
				</view>
			</view>
		</view>
	</view>
</template>

<script setup>
import { request } from "@/utils/request";
import API from "@/config/api";
import { inject, ref } from "vue";
import { onLoad } from "@dcloudio/uni-app";
import { VUE_APP_STATIC_URL } from "@/config/api";

const commentList = ref([])
const commentListLength = ref('')
const $getJumpParam = inject('$getJumpParam')
onLoad((list) => {
  if(list.detail){
    let detail = $getJumpParam(list)
    commentList.value = detail
    commentListLength.value = detail.length
  }else{
    commentList.value = JSON.parse(list).commentList
    commentListLength.value = commentList.value.length
  }
})


function previewImg(img){
  wx.previewImage({
    current: img, // 当前显示图片的http链接
    urls: [img] // 需要预览的图片http链接列表
  })
}
function commentImgData(imgData){
  let imgDataResult = []
  imgDataResult = imgData.split(",");
  return imgDataResult
}
//点赞
function zanTap(index, likeId, actionType) {
  request(API.LikeOrUnLikeComment, {
    commentId: likeId,
    ifLike: actionType
  }, 'POST').then(res => {
    uni.hideLoading()
    commentList.value[index].ifLike = !commentList.value[index].ifLike
    commentList.value[index].likes = commentList.value[index].ifLike ? commentList.value[index].likes + 1 :
        commentList.value[index].likes - 1
  }).catch(res => {
    uni.hideLoading()
  })
}
</script>


<style lang="scss">
	page{
		background-color: #FFFFFF;
	}
	.evaluateTag-box{
		margin-top: 10upx;
		margin-left: 10upx;
		padding-bottom: 10upx;
		display: flex;
		flex-wrap: wrap;
		.evaluateTag-text{
			background-color: #333333;
			padding: 16upx 14upx;
			color: #FFFFFF;
			margin-left: 20upx;
			margin-top: 20upx;
		}
	}
	.container{
		.img-item {
		  width: 223upx;
		  height: 223upx;
		  border-radius: 10upx;
		  margin-right: 10upx;
		  margin-top: 10upx;
		}
		.topLabbig-box{
			padding-bottom: 30upx;
			border-bottom: 1upx solid #EEEEEE;
			background-color: #FFFFFF;
			.topLab-box{
				display: flex;
				justify-content: flex-start;
				flex-wrap: wrap;
				.labtext{
					background-color: #FFE4CC;
					border-radius: 6upx;
					padding: 15upx 15upx;
					margin-left: 20upx;
					margin-top: 20upx;
				}
				.labtext-active{
					background-color: #C5AA7B;
					border-radius: 6upx;
					padding: 15upx 15upx;
					margin-left: 20upx;
					margin-top: 20upx;
				}
			}
		}
		.evaluateList-box{
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
						width: 60upx;
						height: 60upx;
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
        .addEvaluate {
          margin-top: 20upx;
          .addEvaluateText {
            margin: 25upx 0;
          }
        }
				.addCommentsBut{
					width: 150upx;
					height: 56upx;
					border: 1upx solid #C5AA7B;
					border-radius: 28upx;
					font-size: 26upx;
					line-height: 56upx;
					text-align: center;
					color: #C5AA7B;
				}
				.praisebig-box{
					border-top: 1upx solid #EEEEEE;
					padding-top: 30upx;
					.praise-box{
						.praise-icon{
							width: 60upx;
							height: 60upx;
						}

					}
				}
				.addComments-box{
					border-top: 1upx solid #EEEEEE;
					margin-top: 35upx;
				}
			}
		}

	}
</style>
