<template>
  <view class="tabs-nav-warp">
    <scroll-view class="tabs-nav" scroll-x="true">
      <view class="ul">
        <view class="li" :class="{'on':activeTab===0}" @click="tabChange(0)">首页</view>
        <view class="li" :class="{'on':activeTab===index+1}" v-for="(item,index) in categoryList" :key="index" @click="tabChange(index+1,item.classifyId)">
          {{item.classifyName}}
        </view>
      </view>
    </scroll-view>
  </view>
</template>

<script setup>
import { ref, onMounted} from 'vue';
import API from "@/config/api";
import {request} from "@/utils/request"
const activeTab = ref(0)
const categoryList = ref([])
const emit = defineEmits(['tabChange'])
onMounted(()=>{
  getCategoryData()
})

function tabChange (index, id) {
  activeTab.value = index
  emit('tabChange', index, id)
}
function getCategoryData(){
  // uni.showLoading({
  //   title:'加载中...'
  // })
  request(API.FindCategoryListByDepth, {
  }, 'GET').then(res => {
    categoryList.value = res.data
    // uni.hideLoading()
  }).catch(err => {
    // uni.hideLoading()
    throw Error(err)
  })
}
</script>
<style lang="scss" scoped>
.tabs-nav-warp{
  margin-top: 20rpx;
  padding:0 30rpx;
  .tabs-nav{
    .ul{
      display: flex;
      .li{
        flex: 1 0 auto;
        margin-left: 36rpx;
        font-size: 30rpx;
        color: #999999;
        position: relative;
        padding-bottom: 18rpx;
        &:first-child{
          margin-left: 0;
        }
        &.on{
          &:after{
            content: '';
            width: 100%;
            height: 4rpx;
            background: #C5AA7B;
            position: absolute;
            left: 0;
            bottom: 0;
          }
          font-weight:bold;
        }
      }
    }
  }
}

</style>
