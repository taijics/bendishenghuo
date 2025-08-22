<template>
	<view class="messageCenter">
    <global-loading />
		<view>
			<view v-if="messageList.length" class="flex-items flex-sp-between fs26 topTitBox">
				<view>
					未读消息{{num}}条
				</view>
				<view v-if="num!=0" class="allRead" @click="allMessage">
					全部已读
				</view>
			</view>
			<u-swipe-action class="u-swipe-action" :show="item.show" :index="index" v-for="(item, index) in messageList"
				:key="item.noticeId" @click="productClick(item)" :options="options">
				<view class="messageItem" @click="goToMesDetail(item,item.noticeId,item.only,item.jump)">
					<view class="messageBox">
						<view class="messageType">
							<view v-if="item.noticeType == 1" class="messageTypeL">
								<view class="iconBox">
									<image :src="`${VUE_APP_STATIC_URL}static/images/notice.png`" alt=""></image>
									<view class="redBox" v-if="item.ifRead ===0"></view>
								</view>
								<span>订单消息</span>
							</view>
							<view v-else class="messageTypeL">
								<view class="iconBox">
									<image :src="`${VUE_APP_STATIC_URL}static/images/notice.png`" alt=""></image>
								</view>
								<span>系统公告</span>
							</view>
							<view class="messageTypeR">{{item.createTime}}</view>
						</view>
						<view>
							<rich-text class="messageInfo" :nodes="item.htmlData"></rich-text>
						</view>
					</view>
					<!--					<view class="messageBtn">-->
					<!--						<span class="viewDetail">查看详情</span>-->
					<!--						<span class="arrow"></span>-->
					<!--					</view>-->
				</view>
			</u-swipe-action>
		</view>
		<view v-if="ifEmpty" class="empty-box">
			<image class="question-empty" :src="`${VUE_APP_STATIC_URL}static/img/bgnull.png`"></image>
			<view class="tohome-box flex-items-plus">暂无消息</view>
		</view>
	</view>
</template>

<script setup>
import { ref, onBeforeMount } from "vue";
// import parse from 'mini-html-parser2';
import {request} from "@/utils/request";
import API from "@/config/api";
import { onReachBottom } from "@dcloudio/uni-app";
import { VUE_APP_STATIC_URL } from "@/config/api";

const list = ref(3);
const messageList = ref([]); // 消息列表
const page = ref(1);
const pageSize = ref(10);
const loadingType = ref(0);
const num = ref(0); // 未读消息总数
const options = ref([{
  text: '删除',
  style: {
    backgroundColor: '#F15C48'
  }
}]);
const ifEmpty = ref(false);

onBeforeMount(() => {
  page.value = 1
  messageList.value = []
  getAllMessage()
  GetUser()
})

onReachBottom(() => {
  if (loadingType.value == 1) {
    uni.stopPullDownRefresh()
  } else {
    page.value = page.value + 1
    getAllMessage()
  }
})
/**
 * 获取未读消息总数
 * @returns {Promise<void>}
 * @constructor
 */
const GetUser = async () => {
  try {
    const res = await request(API.GetUser, {}, 'GET')
    num.value = res.data.notRead
  } catch (err) {}
}
/**
 * 格式化文本
 * @param html
 */
/* const parseText = (html) => {
  parse(html, (err, htmlData) => {
    return htmlData
  })
} */
/**
 * 格式化富文本方法
 * @param html
 * @returns {*}
 */
const formatRichText = (html) => {
  let newContent = html.replace(/<img[^>]*>/gi, function(match, capture) {
    match = match.replace(/style="[^"]+"/gi, '').replace(/style='[^']+'/gi, '');
    match = match.replace(/width="[^"]+"/gi, '').replace(/width='[^']+'/gi, '');
    match = match.replace(/height="[^"]+"/gi, '').replace(/height='[^']+'/gi, '');
    return match;
  });
  newContent = newContent.replace(/style="[^"]+"/gi, function(match, capture) {
    match = match.replace(/width:[^;]+;/gi, 'max-width:100%;').replace(/width:[^;]+;/gi,
        'max-width:100%;');
    return match;
  });
  newContent = newContent.replace(/<br[^>]*\/>/gi, '');
  newContent = newContent.replace(/\<img/gi,
      '<img style="max-width:100%;height:auto;display:block;margin-top:0;margin-bottom:0;"');
  return newContent;
}
/**
 * 获取消息列表数据
 * @returns {Promise<void>}
 */
const getAllMessage = async () => {
  try {
    const res = await request(API.getMessage, {
      'page': page.value,
      'pageSize': pageSize.value
    }, 'GET')
    uni.hideLoading()
    if (res.data.length == 0) {
      loadingType.value = 1
    } else {
      let _messageList = messageList.value.concat(res.data.list)
      messageList.value = _messageList.map((item) => {
        let newContent = item.noticeContent.replace(/<img[^>]*>/gi, function(match, capture) {
          match = match.replace(/style="[^"]+"/gi, '').replace(
              /style='[^']+'/gi, '');
          match = match.replace(/width="[^"]+"/gi, '').replace(
              /width='[^']+'/gi, '');
          match = match.replace(/height="[^"]+"/gi, '').replace(
              /height='[^']+'/gi, '');
          return match;
        });
        newContent = newContent.replace(/style="[^"]+"/gi, function(match, capture) {
          match = match.replace(/width:[^;]+;/gi, 'max-width:100%;').replace(
              /width:[^;]+;/gi,
              'max-width:100%;');
          return match;
        });
        newContent = newContent.replace(/<br[^>]*\/>/gi, '');
        newContent = newContent.replace(/\<img/gi,
            '<img style="max-width:100%;height:auto;display:block;margin-top:0;margin-bottom:0;"'
        );
        // return newContent;
        /* parse(newContent, (err, htmlData) => {
          item.htmlData = htmlData
        }) */
        return item
      })
      if (messageList.value.length === 0) {
        ifEmpty.value = true
      }
    }
  } catch (err) {
    uni.hideLoading()
    uni.showToast({
      title: '失败',
      icon: "none"
    })
  }
}

/**
 * 删除消息删除消息
 * @param item 当前选择数据
 * @returns {Promise<void>}
 */
const productClick = async (item) => {
  try {
    const res = await request(API.delMessage, {
      noticeId: item.noticeId
    }, 'post')
    uni.hideLoading()
    if (res.code == 200) {
      page.value = 1
      messageList.value = []
      getAllMessage()
      GetUser()
    } else {
      uni.showToast({
        title: res.errMsg,
        icon: 'none'
      })
    }
  } catch (err) {}
}
/**
 * 点击读取全部消息
 * @returns {Promise<void>}
 */
const allMessage = async () => {
  try {
    const res = await request(API.allMessage, {}, "post")
    if (res.code == 200) {
      uni.showToast({
        title: '全部已读',
        icon: 'none'
      })
      page.value = 1
      messageList.value = []
      getAllMessage()
      GetUser()
    } else {
      uni.showToast({
        title: res.errMsg,
        icon: 'none'
      })
    }
  } catch (err) {}
}
/**
 * 跳转消息详情
 * @param noticeId 通知消息id
 * @param only 订单ID
 * @param jump 2 为订单跳转订单详情
 * @returns {Promise<void>}
 */
const goToMesDetail = async (item,noticeId, only, jump) => {
  try {
    const res = await request(API.readNotice, {
      noticeId: noticeId
    }, "post")
    if (res.code == 200) {
      item.ifRead = 1
      if (jump == 2) {
        uni.navigateTo({
          url: "../../pages_category_page1/orderModule/orderDetails?orderId=" +
              only + '&noticeId=' +
              noticeId
        })
      } else {
        uni.navigateTo({
          url: 'messageDetail?noticeId=' + noticeId
        })
      }
    } else {
      uni.showToast({
        title: res.errMsg,
        icon: 'none'
      })
    }
  } catch (err) {}
}
</script>


<style lang="scss" scoped>
@import "../../style/images";
	page {
		background: #FFFFFF;
	}

	.messageCenter {
		height: 100%;
		width: 100%;

		.topTitBox {
			height: 100rpx;
			padding: 0 20rpx;
			background: #f7f7f7;

			.allRead {
				width: 144rpx;
				height: 56rpx;
				line-height: 56rpx;
				text-align: center;
				color: #333333;
				background: #FFFFFF;
			}
		}
		.empty-box {
			display: flex;
			justify-content: center;
			flex-direction: column;
			align-items: center;
			padding-top: 50% ;
			.tohome-box {
				color: #999999;
				margin-top: 50rpx;
			}
			.question-empty {
				width: 113rpx;
				height: 98rpx;
			}
		}
		.u-swipe-action {
			margin-bottom: 20upx !important;
		}
		.messageItem {
			width: 100%;
			background: #FFFFFF;
			border-bottom: 2rpx solid #F8F8F8;
			.messageBox {
				.messageType {
					padding: 30upx;
					display: flex;
					align-items: center;
					justify-content: space-between;
					.iconBox {
						border-radius: 50%;
						background: #C5AA7B;
						width: 60rpx;
						height: 60rpx;
						display: flex;
						align-items: center;
						justify-content: center;
						margin-right: 20upx;
						position: relative;
						.redBox {
							width: 20upx;
							height: 20upx;
							background-color: red;
							border-radius: 50%;
							position: absolute;
							right: 0upx;
							top: 0upx;
						}
					}
					.messageTypeL {
						display: flex;
						align-items: center;
						image {
							width: 50upx;
							height: 50upx;
							border-radius: 50%;
						}
						span {
							font-size: 32upx;
							color: #333333;
						}
					}
					.messageTypeR {
						color: #CCCCCC;
						font-size: 24upx;
					}
				}
				.messageInfo {
					width: 670upx;
					display: block;
					overflow: hidden;
					text-overflow:ellipsis;
					white-space: nowrap;
					margin: 20upx 40upx 20upx;
					img {
						width: 100%;
						margin-bottom: 25upx;
					}
					p {
						padding: 0 40upx;
						color: #999999;
						font-size: 28upx;
					}
				}
			}
			.messageBtn {
				margin-top: 20upx;
				border-top: 1upx solid #EEEEEE;
				height: 88upx;
				display: flex;
				justify-content: space-between;
				align-items: center;
				padding: 0 40upx;
				.viewDetail {
					color: #333333;
					font-size: 28upx;
				}
				.arrow {
					display: block;
					width: 28upx;
					height: 28upx;
					background: $arrowRight no-repeat center center;
					background-size: contain;
				}
			}
		}
	}
</style>
