<template>
  <view class="returnTopService-box">
    <view
        class="returnTop-box flex-items-plus flex-column"
        @click="handleReturnTop"
        :style="{'display': returnTopFlag ? 'flex' : 'none' }"
    >
      <image class="returnTopImg" :src="backTopImgSrc" />
    </view>
  </view>
</template>

<script setup>
import { toRefs } from 'vue';
import { VUE_APP_STATIC_URL } from "@/config/api";

const props = defineProps({
  returnTopFlag: {
    type: Boolean
  }
});

const { returnTopFlag } = toRefs(props);

const backTopImgSrc = `${VUE_APP_STATIC_URL}/static/images/backTop.png`; // 回到顶部图片

/**
 * 返回头部
 */
const handleReturnTop = () => {
  uni.pageScrollTo({
    scrollTop: 0,
    duration: 300
  });
}
</script>

<style scoped>
.returnTopService-box {
  position: fixed;
  bottom: 160rpx;
  right: 30rpx;
}

.returnTop-box {
  width: 88rpx;
  height: 88rpx;
  border-radius: 50%;
  background: #FFFFFF;
  opacity: 0.8;
}

.returnTopImg {
  width: 58rpx;
  height: 58rpx;
}
</style>
