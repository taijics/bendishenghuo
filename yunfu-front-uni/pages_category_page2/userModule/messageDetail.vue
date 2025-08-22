<template>
	<view class="messageDetail">
		<h3 class="detailTit">{{messageDetails.noticeTitle}}</h3>
		<view class="detailTime" v-if="messageDetails.createTime">时间：{{messageDetails.createTime}}</view>
		<view class="detailInfo">
			<rich-text :nodes="htmlData"></rich-text>
			<img :src="messageDetails.image" alt="">
		</view>
	</view>
</template>

<script setup>
import {ref} from "vue";
// import parse from 'mini-html-parser2';
import {request} from "../../utils/request";
import API from "../../config/api";
import {onLoad, onShow} from "@dcloudio/uni-app";

const onlyid = ref(0); // 消息ID
const messageDetails = ref({}); // 消息详情数据
const htmlData = ref([]); // 富文本数据

onShow(() => {
  getNotice()
})

onLoad((options) => {
  onlyid.value = options.noticeId
  getNotice()
})
/**
 * 格式化文本
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
 * 获取消息通知的详情数据
 * @returns {Promise<void>}
 */
const getMessageDetails = async () => {
  try {
    const res = await request(API.getMessageDetails, {
      noticeId: onlyid.value
    }, 'GET')
    messageDetails.value = res.data
    messageDetails.value.noticeContent = formatRichText(messageDetails.value.noticeContent)
    /* parse(messageDetails.value.noticeContent, (err, data) => {
      htmlData.value = data
    }) */
    htmlData.value = messageDetails.value.noticeContent
    uni.hideLoading()
  } catch (err) {
    uni.hideLoading()
    uni.showToast({
      title: '失败',
      icon: "none"
    })
  }
}
/**
 * 已读该消息
 * @returns {Promise<void>}
 */
const getNotice = async () => {
  try {
    const res = await request(API.readNotice, {
      noticeId: onlyid.value
    }, 'POST')
    uni.hideLoading()
    getMessageDetails()
  } catch (err) {
    uni.hideLoading()
    uni.showToast({
      title: '失败',
      icon: "none"
    })
  }
}
</script>

<style lang="scss" scoped>
	.messageDetail {
		padding: 30upx;

		h3 {
			font-size: 36upx;
			color: #333333;
			margin-bottom: 40upx;
		}

		.detailTime {
			font-size: 28upx;
			color: #666666;
			margin-bottom: 50upx;
		}

		.detailInfo {
			word-wrap: break-word;

			p {
				font-size: 28upx;
				color: #333333;
				line-height: 48upx;
				text-indent: 1em;
				margin-bottom: 50upx;
			}

			img {
				width: 100%;
			}
		}
	}
</style>
