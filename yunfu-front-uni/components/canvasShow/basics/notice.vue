<template>
  <div class="notice-list" :class="'terminal'+terminal" :style="{backgroundColor:componentContent.bgColor}">
    <swiper class="swiper-wrapper" :circular="true" :indicator-dots="false" :autoplay="true" :vertical="true">
      <swiper-item class="swiper-slide" v-for="(item,index) in noticesList" :key="index">
        <div class="a-link" @click="jumpNoticeDetail(item)" :style="{color:componentContent.titColor}"><span>{{item.noticeTitle}}</span></div>
      </swiper-item>
    </swiper>
  </div>
</template>

<script setup>
import api from '../config/api'
import { ref, toRefs, onMounted } from 'vue';
import funMixin from '../config/mixin/funMixin.js'

const { jumpNoticeDetail, sendReq, beforeGetData, afterGetData } = funMixin()
const props = defineProps({
  terminal: {
    type: Number,
    default: 4,
  },
  componentContent: {
    type: Object,
    default () {
      return {};
    }
  }
})
const { terminal, componentContent } = toRefs(props)

const noticesList = ref([])

onMounted(() => {
  getData()
})

function getData() {
  let _url = `${api.getNotices}`
  const params = {
    method: 'GET',
    url: _url,
  }
  sendReq(params, (res) => {
    noticesList.value = res.data
  })
}
</script>

<style lang="scss" scoped>
@import "../../../style/images";
.notice-list{
  height: 60upx;
  line-height: 60upx;
  overflow: hidden;
  .a-link{
    // display: block;
    cursor: pointer;
    overflow: hidden;
    text-overflow:ellipsis;
    white-space: nowrap;
    margin: 0 20upx;
    span{
      display: inline-block;
      padding-left: 50upx;
      font-size: 24upx;
      background: $noticeIcon2 no-repeat left center;
      background-size: 30upx 30upx;
    }
  }
  &.terminal4{
    height: 50upx;
    line-height: 50upx;
    padding: 0;
    .swiper-container{
      height: 100%;
      width: 1200upx;
      max-width: 100%;
      margin: 0 auto;
    }
    .a-link{
      cursor: pointer;
      display: block;
      text-align: left;
      margin: 0 20upx;
      span{
        display: block;
        padding-left: 25upx;
        font-size: 14upx;
        background: $noticeIcon no-repeat left center;
      }
    }
  }
}
</style>
