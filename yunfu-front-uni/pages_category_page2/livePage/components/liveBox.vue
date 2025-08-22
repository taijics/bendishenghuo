<template>
  <view class="live-box">
    <view class="live-ongoing" v-if="liveData.liveStatus === 101" @click="toLive">
      <image class="cover-img" :src="liveData.feedsImg" />
      <view class="status">
        <view class="status-state">
          <image class="img" :src="`${VUE_APP_STATIC_URL}static/img/live/icon-live-num.png`" />直播中
        </view>
        <!-- <view class="status-num">1000人</view> -->
      </view>
      <view class="user">
        <view class="user-pic">
          <image class="img" :src="liveData.anchorHeadImg" />
        </view>
        <view class="user-name">{{ liveData.anchorNickName }}</view>
      </view>
      <view class="products">
        <view class="uni-padding-wrap">
          <view class="page-section swiper">
            <view class="page-section-spacing">
              <swiper class="swiper"
                :indicator-dots="indicatorDots"
                :autoplay="autoplay"
                :interval="interval"
                :duration="duration"
                :vertical="true"
              >
                <swiper-item
                  v-for="item in liveData.goods"
                  :key="item.goods_id"
                >
                  <view class="swiper-item">{{ item.name }}</view>
                </swiper-item>
              </swiper>
            </view>
          </view>
        </view>
      </view>
    </view>
    <view class="live-other" v-else @click="toLive">
      <image class="cover-img" :src="liveData.feedsImg" />
      <div class="filter-box-warp">
        <div class="filter-box">
          <image class="cover-img" :src="liveData.feedsImg" />
        </div>
      </div>
      <view class="user">
        <view class="user-pic"><image class="img" :src="liveData.anchorHeadImg" /></view>
        <view class="user-name">{{ liveData.anchorNickName }}</view>
      </view>
      <view class="count-down" v-if="liveStatus === 102">
        <image v-if="isLate" class="img" src="../../../static/images/live/live-late.png"/>
        <view class="text">{{ liveTimeTitle }}</view>
        <view v-if="!isLate" class="time">
          <view class="time-item">{{times[0]}}</view>
          <view class="dot">:</view>
          <view class="time-item">{{times[1]}}</view>
          <view class="dot">:</view>
          <view class="time-item">{{times[2]}}</view>
        </view>
      </view>
      <!-- #ifdef MP-WEIXIN -->
      <view
        v-if="liveStatus === 102 && !isLate"
        class="btn-subscribe"
        :class="{subscribed : subscribeLive === '已预约'}"
        @click.stop="onSubscribe"
      >{{ subscribeLive }}</view>
      <!-- #endif -->
      <view class="endContainer" v-if="liveStatus === 103">
        <view class="endBox">
          <view></view>
          <view></view>
          <view></view>
          <view></view>
        </view>
        <view>直播已结束</view>
      </view>
    </view>
  </view>
</template>

<script setup>
// const NET = require('@/utils/request')
// const API = require('@/config/api')
import {onMounted, ref, onBeforeUnmount} from "vue";
import { request } from "../../../utils/request";
import API from "../../../config/api";
import { startLiveTemplate } from '@/config/subscribe.js'
import { liveAppid } from '@/config/live.js'
import { VUE_APP_STATIC_URL } from "@/config/api";

// #ifdef MP-WEIXIN
const livePlayer = requirePlugin('live-player-plugin')
// #endif

const props = defineProps({
  liveData: {
    type: Object,
    default: () => ({
      roomId: 0,
      anchorNickName: '',
      feedsImg: '' // 官方收录封面
    })
  }
})

const background = ref(['color1', 'color2', 'color3'])
const indicatorDots = ref(false)
const autoplay = ref(true)
const interval = ref(2000)
const duration = ref(500)
const d = ref(0)
const m = ref(0)
const s = ref(0)
const times = ref(['00', '00', '00'])
const liveStatus = ref(100)
const liveTimeTitle = ref('开播倒计时')
const subscribeLive = ref('立即预约')
const timer = ref(null)
const isLate = ref(false)

onMounted(() => {
  liveStatus.value = props.liveData.liveStatus
  subscribeLive.value = props.liveData.subscribeStatus === 0 ? '立即预约' : '已预约'
  getStatus()
  countTime()
})

onBeforeUnmount(() => {
  clearTimeout(timer.value)
})

const getStatus = () => {
  if (!props.liveData.roomId) { return }
  // let _this = this
  // #ifdef MP-WEIXIN
  livePlayer.getLiveStatus({ room_id: props.liveData.roomId })
    .then(res => {
      // 101: 直播中, 102: 未开始, 103: 已结束, 104: 禁播, 105: 暂停中, 106: 异常，107：已过期
      // _this.liveData.liveStatus = res.liveStatus
      liveStatus.value = res.liveStatus
    })
    .catch(err => {
      console.log('get live status', err)
    })
  timer.value = setInterval(() => {
    livePlayer.getLiveStatus({ room_id: props.liveData.roomId })
      .then(res => {
        // 101: 直播中, 102: 未开始, 103: 已结束, 104: 禁播, 105: 暂停中, 106: 异常，107：已过期
        liveStatus.value = res.liveStatus
        countTime()
        console.log('get live status', res.liveStatus)
      })
      .catch(err => {
        console.log('get live status', err)
      })
  }, 60000)
  // #endif
}

const changeIndicatorDots = (e) => {
  indicatorDots.value = !indicatorDots.value
}
const changeAutoplay = (e) => {
  autoplay.value = !autoplay.value
}
const intervalChange = (e) => {
  interval.value = e.target.value
}
const durationChange = (e) => {
  duration.value = e.target.value
}

const countTime = () => {
  const nowtime = new Date().getTime()  //获取当前时间
  const starttime = new Date(props.liveData.startTime).getTime()
  if(liveStatus.value === 102){
    if(starttime > nowtime){
      var lefttime = starttime - nowtime  //距离结束时间的毫秒数
      var leftd = Math.floor(lefttime/(1000*60*60)),  //计算小时数
          leftm = Math.floor(lefttime/(1000*60)%60),  //计算分钟数
          lefts = Math.floor(lefttime/1000%60);  //计算秒数
      times.value = [leftd < 10?'0'+ leftd:leftd,leftm < 10?'0'+ leftm:leftm,lefts < 10?'0'+ lefts:lefts]
      liveTimeTitle.value = '开播倒计时'
      setTimeout(() => {
        countTime()
      },1000)
    } else {
      times.value = ['00', '00', '00']
      isLate.value = true
      liveTimeTitle.value = '正在赶来的路上...'
    }
  }
}

const toLive = () => {
  if (!liveAppid || !props.liveData) { return }
  // 跳转直播间携带路由参数
  // let customParams = encodeURIComponent(JSON.stringify({ path: 'livePage/index', pid: 1 }))
  // #ifdef MP-WEIXIN
  wx.navigateTo({
    url: `plugin-private://${liveAppid}/pages/live-player-plugin?room_id=${props.liveData.roomId}`
    // url: `plugin-private://${liveAppid}/pages/live-player-plugin?room_id=${this.liveData.roomId}&custom_params=${customParams}`
  })
  // #endif
}
const onSubscribe = () => {
  if (subscribeLive.value === '立即预约') {
    // const _this = this
    // #ifdef MP-WEIXIN
    uni.requestSubscribeMessage({
      tmplIds: [startLiveTemplate],
      success (res) {
        if (res[startLiveTemplate] === "accept") {
          request(API.SubScribeLive, {id: props.liveData.id }, 'post')
            .then(res => {
              if (res.data) {
                subscribeLive.value = '已预约'
              } else {
                uni.showToast({
                  title: res.message || '订阅失败，请稍后再试！',
                  icon: "none"
                })
              }
            })
            .catch(err => {
              console.log(err)
              uni.showToast({
                title: res.message || '订阅失败，请稍后再试！',
                icon: "none"
              })
            })
        }
      }
    })
    // #endif
  }
}

// export default {
//   props: {
//     liveData: {
//       type: Object,
//       default: () => ({
//         roomId: 0,
//         anchorNickName: '',
//         feedsImg: '' // 官方收录封面
//       })
//     }
//   },
//   data () {
//     return {
//       background: ['color1', 'color2', 'color3'],
//       indicatorDots: false,
//       autoplay: true,
//       interval: 2000, // 自动播放间隔时长
//       duration: 500, // 幻灯片切换时长(ms)
//       d: 0,
//       m: 0,
//       s: 0,
//       times: ['00', '00', '00'],
//       liveStatus: 100,
//       liveTimeTitle: '开播倒计时',
//       subscribeLive: '立即预约',
//       timer: null,
//       isLate: false,
//     }
//   },
//   created() {
//     this.liveStatus = this.liveData.liveStatus
//     this.subscribeLive = this.liveData.subscribeStatus === 0 ? '立即预约' : '已预约'
//     this.getStatus()
//     this.countTime()
//     // this.getSubscribeStatus()
//   },
//   destroyed() {
//     clearTimeout(this.timer)
//   },
//   methods: {
//     getStatus() {
//       if (!this.liveData.roomId) { return }
//       let _this = this
//       // #ifdef MP-WEIXIN
//       livePlayer.getLiveStatus({ room_id: this.liveData.roomId })
//       .then(res => {
//         // 101: 直播中, 102: 未开始, 103: 已结束, 104: 禁播, 105: 暂停中, 106: 异常，107：已过期
//         // _this.liveData.liveStatus = res.liveStatus
//         _this.liveStatus = res.liveStatus
//       })
//       .catch(err => {
//           console.log('get live status', err)
//       })
//       this.timer = setInterval(() => {
//         livePlayer.getLiveStatus({ room_id: this.liveData.roomId })
//           .then(res => {
//             // 101: 直播中, 102: 未开始, 103: 已结束, 104: 禁播, 105: 暂停中, 106: 异常，107：已过期
//             _this.liveStatus = res.liveStatus
//             this.countTime()
//             console.log('get live status', res.liveStatus)
//           })
//           .catch(err => {
//             console.log('get live status', err)
//           })
//       }, 60000)
//       // #endif
//     },
//     changeIndicatorDots(e) {
//         this.indicatorDots = !this.indicatorDots
//     },
//     changeAutoplay(e) {
//         this.autoplay = !this.autoplay
//     },
//     intervalChange(e) {
//         this.interval = e.target.value
//     },
//     durationChange(e) {
//         this.duration = e.target.value
//     },
//     countTime(){
//       const nowtime = new Date().getTime()  //获取当前时间
//       const starttime = new Date(this.liveData.startTime).getTime()
//       if(this.liveStatus === 102){
//         if(starttime > nowtime){
//           var lefttime = starttime - nowtime  //距离结束时间的毫秒数
//           var leftd = Math.floor(lefttime/(1000*60*60)),  //计算小时数
//               leftm = Math.floor(lefttime/(1000*60)%60),  //计算分钟数
//               lefts = Math.floor(lefttime/1000%60);  //计算秒数
//           this.times = [leftd < 10?'0'+ leftd:leftd,leftm < 10?'0'+ leftm:leftm,lefts < 10?'0'+ lefts:lefts]
//           this.liveTimeTitle = '开播倒计时'
//           setTimeout(() => {
//             this.countTime()
//           },1000)
//         } else {
//           this.times = ['00', '00', '00']
//           this.isLate = true
//           this.liveTimeTitle = '正在赶来的路上...'
//         }
//       }
//     },
//     toLive() {
// 			if (!liveAppid || !this.liveData) { return }
// 			// 跳转直播间携带路由参数
// 			// let customParams = encodeURIComponent(JSON.stringify({ path: 'livePage/index', pid: 1 }))
// 			// #ifdef MP-WEIXIN
// 			wx.navigateTo({
//         url: `plugin-private://${liveAppid}/pages/live-player-plugin?room_id=${this.liveData.roomId}`
// 				// url: `plugin-private://${liveAppid}/pages/live-player-plugin?room_id=${this.liveData.roomId}&custom_params=${customParams}`
// 			})
// 			// #endif
//     },
//     onSubscribe() {
//       if (this.subscribeLive === '立即预约') {
//         const _this = this
//         // #ifdef MP-WEIXIN
//         uni.requestSubscribeMessage({
//           tmplIds: [startLiveTemplate],
//           success (res) {
//             if (res[startLiveTemplate] === "accept") {
//               request(API.SubScribeLive, {id: _this.liveData.id }, 'post')
//               .then(res => {
//                 if (res.data) {
//                   _this.subscribeLive = '已预约'
//                 } else {
//                   uni.showToast({
//                     title: res.message || '订阅失败，请稍后再试！',
//                     icon: "none"
//                   })
//                 }
//               })
//               .catch(err => {
//                 console.log(err)
//                 uni.showToast({
//                   title: res.message || '订阅失败，请稍后再试！',
//                   icon: "none"
//                 })
//               })
//             }
//           }
//         })
//         // #endif
//       }
//     }
//   }
// }
</script>

<style lang="scss" scoped>
.live-box{
  position: relative;
  color: #fff;
  width: 100%;
  height: 100%;
  .cover-img{
    width: 100%;
    height: 100%;
    position: absolute;
    z-index: 0;
  }
  .user{
    display: flex;
    line-height: 60rpx;
    height: 64rpx;
    &-pic{
      .img{
        width: 60rpx;
        height: 60rpx;
        border: 2px solid rgba(255, 255, 255, 0.5019607843137255);
        border-radius: 50%;
        overflow: hidden;
      }
    }
    &-name{
      font-size: 28rpx;
      margin-left: 16rpx;
      overflow: hidden;
      text-overflow: ellipsis;
      white-space: nowrap;
      width: 245rpx;
    }
  }
  .live-ongoing{
    width: 100%;
    height: 100%;
    position: relative;
    .status{
      position: absolute;
      top: 22rpx;
      left: 22rpx;
      //width: 212upx;
      height: 48rpx;
      // background: rgba(0,0,0,0.3);
      // border: 2rpx solid rgba(255,255,255,0.3);
      border-radius: 24rpx;
      font-size: 20rpx;
      line-height: 44rpx;
      display: flex;
      // padding-right: 8rpx;
      &-state{
        width: 118rpx;
        height: 44rpx;
        background: linear-gradient(90deg, #C83732 0%, #E25C44 100%);
        opacity: 1;
        border-radius: 26rpx;
        display: flex;
        align-items: center;
        justify-content: center;
        .img{
          width: 20rpx;
          height: 20rpx;
          margin-right: 6rpx;
        }
      }
      &-num{
        min-width: 80rpx;
        padding: 0 8rpx;
      }
    }
    .user{
      position: absolute;
      bottom: 62rpx;
      left: 20rpx;
    }
    .products{
      position: absolute;
      left: 0rpx;
      bottom: 20rpx;
      width: 100%;
      padding:0 20rpx;
      .swiper{
        height: 34rpx;
        line-height: 34rpx;
        font-size: 24rpx;
        overflow: hidden;
        text-overflow:ellipsis;
        white-space: nowrap;
      }
    }
  }
  .live-other{
    position: relative;
    height: 100%;
    display: flex;
    align-items: center;
    justify-content: center;
    .filter-box-warp{
      background-color: #000000;
      position: absolute;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      .filter-box{
        position: absolute;
        top: -30rpx;
        left: -30rpx;
        width: 348rpx;
        height: 464rpx;
        display: flex;
        align-items: center;
        justify-content: center;
        -webkit-filter: blur(20px);
        -moz-filter: blur(21px);
        -ms-filter: blur(20px);
        -o-filter: blur(20px);
        padding: 30rpx;
        box-sizing: content-box;
      }
    }
    .user{
      position: absolute;
      top: 20rpx;
      left: 20rpx;
    }
    .count-down{
      position: relative;
      .text{
        font-size: 26rpx;
        line-height: 36rpx;
        margin-bottom: 16rpx;
        opacity: 0.5;
        text-align: center;
      }
      .img{
        display: block;
        width: 80rpx;
        height: 80rpx;
        margin: 16rpx auto;
      }
      .time{
        display: flex;
        justify-content: space-around;
        align-items: center;
        &-item{
          min-width: 52rpx;
          padding: 0 5rpx;
          height: 52rpx;
          line-height: 52rpx;
          background: #FFFFFF;
          opacity: 1;
          border-radius: 6rpx;
          font-size: 26rpx;
          color: #C83732;
          text-align: center;
          .dot{
            line-height: 52rpx;
          }
        }
      }
    }
    .btn-subscribe{
      width: 200rpx;
      height: 64rpx;
      line-height: 64rpx;
      background: linear-gradient(90deg, #C83732 0%, #E25C44 100%);
      box-shadow: 0rpx 6rpx 12rpx rgba(233, 0, 0, 0.3);
      opacity: 1;
      border-radius: 6rpx;
      color: #fff;
      font-size: 24rpx;
      text-align: center;
      position: absolute;
      bottom: 60rpx;
      left: 50%;
      margin-left: -100rpx;
      &.subscribed{
        background: #FFFFFF;
        color: #999999;
        box-shadow: none;
      }
    }
    .endContainer{
      position: relative;
      .endBox{
        width: 40%;
        height: 60rpx;
        margin: 20rpx auto;
        display: flex;
        justify-content: space-between;
        align-items: flex-end;
        view{
          width: 0;
          border: 2rpx solid #FFF;
        }
        view:nth-of-type(1){
          height: 20%;
        }
        view:nth-of-type(2){
          height: 50%;
        }
        view:nth-of-type(3){
          height: 30%;
        }
        view:nth-of-type(4){
          height: 70%;
        }
      }
    }
  }
}
</style>
