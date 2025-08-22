 <!-- @auth kahu -->
<template>
  <view class="loading_box mask flex-center"
        @touchmove.stop.prevent="HandlePageMove">
    <!--  点动画  -->
    <view class="dot_box theOuterRotation"
          v-if="false">
      <view class="dot_item"
            v-for="item in 4"></view>
    </view>

    <!-- 进度条动画 -->
    <view class="progress_box" v-if="false">
      <view class="progress_item progress_roll_center"></view>
    </view>
    Loading....
  </view>
</template>

<script>
export default {
  name: "index",
  data() {
    return {}

  },
  onPageScroll(e) {
    return false
  },

  mounted() {
    console.log(getCurrentPages())
    //#ifdef H5
    //#endif
  },

  methods: {
    HandlePageMove() {
      return false
    }
  }
}
</script>

<style lang="scss"
       scoped>
.mask {
  width: 100vw;
  height: 100vh;
  background: rgba(0, 0, 0, 0.5);
  color: #fff;
}

.flex-center {
  display: flex;
  align-items: center;
  justify-content: center;
  flex-direction: column;
}

.loading_box {
  width: 100vw;
  height: 100vh;
  position: fixed;
  top: 0;
  bottom: 0;
  z-index: 9999;

  /** 点动画*/
  .theOuterRotation {
    animation: rotate 2s ease-in-out .5s infinite normal;
  }

  .dot_box {
    width: 80rpx;
    height: 80rpx;
    //background: #fff;
    border-radius: 20rpx;
    margin: 20rpx 0;
    position: relative;

    // 原始dot
    .dot_item {
      width: 30rpx;
      height: 30rpx;
      background: #fff;
      border-radius: 50%;
      position: absolute;
      transition: all .6s;
      box-shadow: 0 0 2rpx #b4b4b4;

      &:nth-child(1) {
        top: 0;
        left: 0;
      }

      &:nth-child(2) {
        top: 0;
        right: 0;
      }

      &:nth-child(3) {
        bottom: 0;
        right: 0;
      }

      &:nth-child(4) {
        bottom: 0;
        left: 0;
      }
    }

    // 单双放大动画
    .dot_scale {
      &:nth-child(1) {
        top: 0;
        left: 0;
        animation: magnify 2s ease-in-out 0s infinite alternate;
      }

      &:nth-child(2) {
        top: 0;
        right: 0;
        animation: magnify 2s ease-in-out 1s infinite alternate;
      }

      &:nth-child(3) {
        bottom: 0;
        right: 0;
        animation: magnify 2s ease-in-out 0s infinite alternate;
      }

      &:nth-child(4) {
        bottom: 0;
        left: 0;
        animation: magnify 2s ease-in-out 1s infinite alternate;
      }
    }

    // 单点移动动画
    .dot_move {
      &:nth-child(1) {
        z-index: 2;
        animation: moveDot 2s ease-in-out 0s infinite normal;
      }
    }

    // 单偶放大
    @keyframes magnify {
      0% {
        transform: scale(1);
        background: rgba(0, 255, 228, 0.82);
      }
      25% {
        background: #32b5cc;
      }
      50% {
        transform: scale(1.4);
        background: #73e34e;
      }
      75% {
        background: #0ec469;
      }
      100% {
        transform: scale(1);
        background: #868686;
      }
    }

    // 移动单点
    @keyframes moveDot {
      0% {
        top: 0;
        left: 0;
        background: #d0f598;
      }
      25% {
        top: 0;
        left: 100%;
        transform: translateX(-100%);
        background: #f5e298;
      }
      50% {
        top: 100%;
        left: 100%;
        transform: translate(-100%, -100%);
        background: #6bea91;
      }
      75% {
        top: 100%;
        left: 0;
        transform: translateY(-100%);
        background: #e84c7a;
      }
      100% {
        top: 0;
        left: 0;
      }

    }

    @keyframes rotate {
      0% {
        transform: rotate(0deg);
      }
      100% {
        transform: rotate(360deg);
      }
    }
  }


  /** 进度条动画*/
  .progress_box{
    width: 300rpx;
    height: 25rpx;
    margin: 20rpx 0;
    border-radius: 25rpx;
    background-color: #fff;
    position: relative;
    overflow: hidden;
    .progress_item{
      width: 0%;
      height: 100%;
      background: #f68686;
      border-radius: 25rpx;

    }
    .progress_roll{
      animation: roll 1s ease-in-out 0s infinite alternate-reverse;
    }
    .progress_roll_center{
      width: 5%;
      transition: all .6s;
      margin: 0 auto;
      animation: roll 1s cubic-bezier(.15,.2,.05,.4) 0s infinite alternate-reverse;
    }
  }

  @keyframes roll {
    from{
      width: 5%;
    }
    to{
      width: 100%;
    }
  }

}
</style>
