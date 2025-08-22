<template>
  <div class="videoBox warp" :class="'terminal' + terminal">
    <div class="videoLeftBox">
      <h3>{{componentContent.title}}</h3>
      <div v-html="componentContent.mainBody"></div>
    </div>
    <div class="videoRightBox" v-if="componentContent.coverImg && isPlay">
      <video class="myVideo" id="myVideo" :src="componentContent.videoUrl" enable-danmu danmu-btn controls></video>
    </div>
    <div class="videoCoverBox" v-if="componentContent.coverImg && !isPlay" @click="handlePlayVideo">
      <image :src="componentContent.coverImg" ></image>
    </div>
    <div class="videoRightBox" v-if="!componentContent.coverImg">
      <video class="myVideo" id="myVideo" :src="componentContent.videoUrl" enable-danmu danmu-btn controls></video>
    </div>
    <div class="clear"></div>
  </div>
</template>

<script setup>
import { toRefs, ref, onMounted } from 'vue';
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
  },
})
const { terminal, componentContent } = toRefs(props)
const isPlay = ref(false)
const videoContext = ref(null)

onMounted(()=>{
  videoContext.value = uni.createVideoContext('myVideo',this)
})

function handlePlayVideo(){
  isPlay.value = true
  setTimeout(()=>{
    videoContext.value.play()
  },500)
}
</script>

<style lang="scss" scoped>
 .videoBox {
   padding: 20upx 0;
   display: flex;
   justify-content: flex-start;
   align-items: center;
   .videoLeftBox {
     width: 50%;
     padding-right: 10%;
     h3 {
       font-size: 28upx;
       color: #333333;
       margin-bottom: 30upx;
     }
     p {
       color: #333333;
       font-size: 14upx;
       line-height: 30upx;
     }
   }
   .videoRightBox {
     width: 50%;
     video {
       width: 100%;
     }
   }
   .clear {
     clear: both;
   }
 }
 .terminal1,.terminal2,.terminal3{
   &.videoBox{
     display: block;
     .videoLeftBox{
       width: 100%;
       text-align: center;
       margin-bottom: 20upx;
     }
     .videoRightBox {
       width: 100%;
     }
   }
 }
 .videoCoverBox{
   aspect-ratio: 16/9;
   position: relative;
   &:before{
     content: '';
     width: 0rpx;
     height: 0rpx;
     border-left:80rpx solid #fff;
     border-right:50rpx solid transparent;
     border-top:50rpx solid transparent;
     border-bottom:50rpx solid transparent;
    position: absolute;
     top: 50%;
     left: 50%;
     transform: translate(-30%,-50%);
     z-index: 99;
   }
   image{
     width: 100%;
     height: 100%;
   }
 }
</style>
