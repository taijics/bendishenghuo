<template>
  <view class="loading-content" v-if="loadingFlag"  @touchmove.stop.prevent="moveHandle"
              @click.stop.prevent="moveHandle">
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
  name: "slideLoading",
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
  width: 150rpx;
  height: 150rpx;
  margin:  0 auto;
  .loading-gif {
    z-index: 99;
    position: relative;
    width: 100%;
    height: 100%;
    .flex {
      width: 150rpx;
      height: 150rpx;
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
        width: 80rpx;
        height: 80rpx;
      }
      p {
        color: #fff;
      }
    }
  }
}
</style>
