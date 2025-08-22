<template>
  <div>
    <u-popup v-model="shareShow" :round="10" mode="bottom" @close="cancel(1)">
      <view class="share">
        <!-- <u-mask :show="true" class="flex-items-plus flex-row"> -->
        <text class="h3">邀请好友</text>
        <view class="share-list">
          <view class="ul">
            <!-- #ifdef APP-PLUS -->
            <view class="li" @click="share('weixin')">
              <image class="icon" src="../static/images/share/weixin2x.png"></image>
              <label class="label">微信</label>
            </view>
            <view class="li" @click="share('weixinpyq')">
              <image class="icon" src="../static/images/share/pyq.png"></image>
              <label class="label">朋友圈</label>
            </view>
            <!-- #endif -->
            <!-- #ifdef MP-WEIXIN -->
            <view class="li">
              <button open-type="share" @share='onShareAppMessage' :data-obj="wxShareData" class="share-button">
                <image class="icon" src="../static/images/share/forward.png"></image>
                <label class="label">好友</label>
              </button>
            </view>
            <view class="li" @click="share('weixinpyq')">
              <image class="icon" src="../static/images/share/pyq.png"></image>
              <label class="label">朋友圈</label>
            </view>
            <!-- #endif -->
            <view class="li" @click="share('lianjie')">
              <image class="icon" src="../static/images/share/lianjie.png"></image>
              <label class="label">链接</label>
            </view>
          </view>
        </view>
        <view class="btn-close" @click="cancel(1)">取消</view>
      </view>
    </u-popup>
    <u-popup v-model="wapShow" :round="10" mode="bottom" :border-radius="10" @close="cancel(2)">
      <view class="share-h5">
        <view class="text">
          点击浏览器下方
          <view class="icon">
            <u-icon name="list" color="#fff" size="28"></u-icon>
          </view>
          即可进行分享
        </view>
      </view>
    </u-popup>
  </div>
</template>

<script setup>
// expose shareShow
import ClipboardJS from "clipboard"
import UImage from "../uni_modules/vk-uview-ui/components/u-image/u-image";
import API from "../config/api";
import { toRefs, defineProps, ref, onMounted, computed } from "vue";
import { onShareAppMessage } from "@dcloudio/uni-app";
const props = defineProps({
  img: {
    type: String,
    default: ""
  },
  url: {
    type: String,
    dafault: ''
  },
  title: {
    type: String,
    dafault: ''
  },
  urlParms: {
    type: String,
    default: ''
  }
})
const {img,url,title,urlParms} = toRefs(props)
onShareAppMessage((e)=>{
  // 获取按钮传进来的参数 data 中的item值
  let params = e.target.dataset.obj // 获取的为 data 中定义的item值
  return {
    path: `${params}`
  }
})
const shareShow = ref(false)
const wapShow = ref(false)
const wxShareData = ref({url:''})
onMounted(()=>{
  wxShareData.value = url.value
})
const longUrl = computed(()=>API.shareLink+'/#'+url.value)
const emit = defineEmits(['shareCancel'])
function cancel(key) {
  if (key === 1) {
    shareShow.value = false
    emit('shareCancel')
  } else if (key === 2) {
    wapShow.value = false
  }
}

function wxShare(type) {
  // #ifdef APP-PLUS
  uni.share({
    provider: "weixin",
    type: 0,
    title: title.value,
    scene: type,//WXSceneSession会话 WXSceneTimeline朋友圈
    imageUrl: img.value,
    href: longUrl.value,
    success: () => {
    },
    fail: (err) => {
      console.log("err",err)
    }
  })
  // #endif
  // #ifdef MP-WEIXIN
  uni.showToast({
    title:"请点击右上角打开菜单进行朋友圈分享",
    icon:"none"
  })
  // #endif
}

function share(key) {
  switch (key) {
    case 'weixin':
      wxShare("WXSceneSession")
      break
    case 'weixinpyq':
      wxShare("WXSceneTimeline")
      break
    case 'qq':
      break
    case 'weibo':
      break
    case 'lianjie':
      uni.setClipboardData({
        data: title.value + longUrl.value,
        success: () => {
          uni.showToast({
            title: '复制成功'
          })
        }
      })
      break
  }
}
defineExpose({shareShow})
</script>
<style lang="scss">
.share{
  background-color: #F8F8F8;
  text-align: center;
  .h3{
    font-size: 30rpx;
    color: #333333;
    line-height: 42rpx;
    padding: 30rpx 0;
    border-bottom: 2px solid #F0F0F0;
    display: block;
  }
  .share-list{
    padding: 40rpx 0 54rpx;
    .ul{
      display: flex;
      justify-content: space-around;
      .li{
        &::after {
          border: none;
        }
        .icon{
          display: block;
          width: 92rpx;
          height: 92rpx;
        }
        .label{
          padding-top: 22rpx;
          font-size: 24rpx;
          line-height: 34rpx;
          color: #333333;
          display: block;
        }
      }
    }
  }
  .btn-close{
    background-color: #fff;
    padding: 30rpx 0;
    font-size: 26rpx;
    color: #333;
  }
}

.share-h5{
  padding:0 20rpx;
  display: flex;
  justify-content: center;
  .text{
    line-height: 100rpx;
    font-size: 30px;
    .icon{
      background-color: #333;
      border-radius: 50%;
      display: inline-block;
      width: 40rpx;
      height: 40rpx;
      text-align: center;
      line-height: 40rpx;
      margin: 0 10rpx;
    }
  }
}
.share-button::after {
  border: none;
}
</style>
