<template>
  <view class="loading-content" v-if="loadingFlag"  @touchmove.stop.prevent="moveHandle"
              @click.stop.prevent="moveHandle">
    <!-- 遮罩 -->
    <view catchtouchmove="true" class="full-mask" v-if="false"/>
    <!-- loading -->
    <view class="loading-gif">
      <view class="flex mask">
        <image src="@/static/images/loading/loading2.gif"></image>
<!--        <p> {{ loadingInfo }} </p>-->
      </view>
    </view>
  </view>
</template>

<script>
import {mapGetters} from 'vuex'

export default {
  name: "GlobalLoading",
  methods: {
    moveHandle() {
      return;
    }
  },
  data(){
    return {
      flag:true
    }
  },
  mounted() {
  },
  computed: {
    ...mapGetters(["loadingFlag", "loadingInfo"])
  }
}
</script>

<style lang="scss" scoped>
.loading-content {
  position: fixed;
  top: 0;
  left: 0;
  width: 100vw;
  height: 100vh;
  z-index: 9999;
  //pointer-events: none;

  .mask {
    //background-color: rgba(75, 53, 53, 0.52);
  }

  .full-mask {
    position: absolute;
    width: 100vw;
    height: 100vh;
    background-color: rgba(0, 0, 0, 0.52);
    z-index: 9998;
    pointer-events: none;
  }

  .loading-gif {
    z-index: 9999;
    position: relative;
    width: 100%;
    height: 100%;

    .flex {
      width: 110rpx;
      height: 110rpx;
      position: absolute;
      border-radius: 15rpx;
      top: 50%;
      left: 50%;
      transform: translate(-50%, -50%);
      display: flex;
      align-items: center;
      justify-content: center;
      flex-direction: column;

      image {
        width: 70rpx;
        height: 70rpx;
      }

      p {
        color: #fff;
      }
    }
  }
}
</style>
