<!--
    @name: ProductSkeleton
    @author: kahu4
    @date: 2024-01-08 14:35
    @description：ProductSkeleton
    @update: 2024-01-08 14:35
-->
<script setup>
</script>

<template>
<view class="product-skeleton">
  <view class="box animation img"></view>
  <view class="box animation activity"></view>
  <view class="box animation product-info"></view>
  <view class="box animation product-info"></view>
  <view class="box animation product-info"></view>
  <view class="box animation product-info"></view>
  <view class="box animation detail-info"></view>
</view>
</template>

<style
    scoped
    lang="scss"
>
.product-skeleton{
  width: 100vw;
  height: 100vh;
  background: #f7f7f7;
  overflow: hidden;
  padding: 20rpx;
  box-sizing: border-box;
  .img{
    width: 100%;
    height: 30vh;
    background: #fff;
    margin-bottom: 15rpx;
  }
  .activity{
    width: 100%;
    height: 200rpx;
    background: #fff;
    margin-bottom: 15rpx;
  }
  .product-info{
    width: 100%;
    height: 100rpx;
    background: #fff;
    margin-bottom: 15rpx;
  }

  .detail-info{
    width: 100%;
    height: 100vh;
    background: #fff;
    margin-bottom: 15rpx;
  }
}

.animation{
  animation: bg 500ms linear 0s infinite alternate ;
}

.box{
  border-radius: 4rpx;
}

@keyframes bg {
  from{
    background: #f8f8f8;
  }
  to{
    background: #fff;
  }
}
</style>
