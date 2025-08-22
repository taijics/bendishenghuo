<!--
    * @FileDescription: index.vue
    * @Author: kahu
    * @Date: 2022/11/21
    * @LastEditors: kahu
    * @LastEditTime: 2022/11/21
-->
<template>
  <view class="no-more-content" v-if="show">
    <view class="line" />
    <view class="text">
      <slot>没有更多了</slot>
    </view>
    <view class="line" />
  </view>
</template>

<script>
export default {
  name: "NoMore",
  data() {
    return {}
  },
  props:{
    show:{
      type:Boolean,
      default:false
    }
  },
  methods: {}
}
</script>

<style
    lang="scss"
    scoped
>
.no-more-content{
  margin-top: 35rpx;
  width: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  .line{
    width: 20vw;
    height: 2rpx;
    background-color: #808080;
  }
  .text{
    color: #808080;
    margin: 0 50rpx;
  }
}
</style>
