<template>
  <div class="live-list-page" v-if="roomList && roomList.length > 0">
    <div class="title">
      <!-- #ifdef MP-WEIXIN -->
      <image class="title-img" :src="`${VUE_APP_STATIC_URL}static/canvas-images/live/img-title.png`" alt="直播"  mode="widthFix"/>
      <!-- #endif -->
      <!-- #ifdef H5 || APP-PLUS -->
      <image class="title-img" :src="`${VUE_APP_STATIC_URL}static/canvas-images/live/img-title.png`" alt="直播"  mode="widthFix"/>
      <!-- #endif -->
    </div>
    <div class="live-list">
      <LiveBox class="live-item"
        v-for="item in roomList"
        :key="item.roomid"
        :liveData.sync="item"
        @click="toLiveRoom(item)"
      />
    </div>
    <button v-show="componentContent.showMore" class="btn-more" @click="jumpLive()">查看全部 <span class="icon iconfont icon-arrow-right"></span></button>
  </div>
</template>

<script setup>
import commonMixin from '../mixin';
import LiveBox from './item.vue';
import { toRefs } from 'vue';
import {VUE_APP_STATIC_URL} from "@/config/api";

const { roomList, toLiveRoom, jumpLive } = commonMixin();
const props = defineProps({
  componentContent: {
    type: Object,
    default () {
      return {};
    },
  },
});
const { componentContent } = toRefs(props);
</script>



<style lang="scss" scoped>
.live-list-page{
  .title{
    text-align: center;
    margin-bottom: 20rpx;
    .title-img{
      width: 211rpx;
      height: 32rpx;
    }
  }
  .live-list{
    padding-left: 20rpx;
    width: 100%;
    display: flex;
    flex-wrap: wrap;
    .live-item{
      margin:0 14rpx 14rpx 0;
      width: 348rpx;
      height: 464rpx;
      border-radius: 8rpx;
      overflow: hidden;
    }
  }
  .btn-more {
    width: 170rpx;
    height: 54rpx;
    border: 2rpx solid #C5AA7B;
    color: #C5AA7B;
    font-size: 24rpx;
    background-color: transparent;
    margin: 20rpx auto 0;
    display: flex;
    align-items: center;
  }
}
</style>
