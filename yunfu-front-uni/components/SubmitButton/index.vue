<template>
  <view class="submitButton flex-items" :class="{positionBottom: position === 'bottom'}" :style="{width: width, backgroundColor: bgColor}">
    <view class="submitBtn" @click="handleExchange" :style="{height: height}">
      <text>{{ text }}</text>
      <image v-if="btnLoadingFlag" src="@/static/images/loading/loading3.gif"></image>
    </view>
  </view>
</template>

<script>
import {mapGetters} from 'vuex'

export default {
  name: "submitButton",
  methods: {
    handleExchange() {
      // 将事件传递给父组件
      if (this.btnLoadingFlag) return;
      this.$emit('submitEvent');
    }
  },
  data(){
    return {
      flag:true
    }
  },
  props: {
    text: {
      type: String,
      default: '提交'
    },
    position: {
      type: String,
      default: 'liberty'
    },
    width: {
      type: String,
      default: '100%'
    },
    height: {
      type: String,
      default: '100rpx'
    },
    bgColor: {
      type: String,
      default: 'none'
    }
  },
  computed: {
    ...mapGetters(["btnLoadingFlag"])
  }
}
</script>

<style lang="scss" scoped>
.submitButton {
  width: 100%;
  height: 164rpx;
  .submitBtn {
    width: 100%;
    line-height: 100rpx;
    text-align: center;
    background: #333333;
    color: #FFEBC4;
    display: flex;
    align-items: center;
    justify-content: center;
  }
  image {
    width: 32rpx;
    height: 32rpx;
    margin-left: 10rpx;
  }
}
.positionBottom {
  position: fixed;
  left: 0;
  bottom: 0;
  box-shadow: 0 -1rpx 0rpx rgba(197, 202, 207, 0.5);
  background: #ffffff;
  padding: 0 32rpx;
}
</style>
