<template>
  <view class="header">
    <view class="top-box">
      <image v-if="componentContent.logoType === 1" class="logo"
             :src="componentContent.imageUrl"
             mode="heightFix"></image>
      <view v-else class="h3" :style="{fontSize:componentContent.fontSizeNum+'px',fontWeight:componentContent.textFontW,color:componentContent.titColor}">{{componentContent.title}}</view>
      <view class="search-btn" @click="searchPro">
        <image class="search-icon"
               :src="`${VUE_APP_STATIC_URL}static/img/search.png`"
               mode="widthFix"></image>
      </view>
    </view>
    <view class="tabs-nav-warp">
      <scroll-view class="tabs-nav" scroll-x="true">
        <view class="ul">
          <view class="li" :class="{'on':activeTab===0}" @click="tabChange(0)">首页</view>
          <view class="li" :class="{'on':activeTab===index+1}" v-for="(item,index) in classifyData" :key="index" @click="tabChange(index+1,item.id)">
            {{item.categoryName}}
          </view>
        </view>
      </scroll-view>
    </view>
  </view>
</template>

<script setup>
import {ref, toRefs} from 'vue';
import headerMixin from '../mixin'
import { VUE_APP_STATIC_URL } from "@/config/api";

const emits = defineEmits(['tabChange'])
const props = defineProps({
  componentContent: {
    type: Object,
    default () {
      return {};
    },
  }
})
const { componentContent } = toRefs(props)
const { classifyData } = headerMixin()
const activeTab = ref(0)
function tabChange (index, id) {
  activeTab.value = index
  emits('tabChange', index, id)
}
function searchPro(key, type) {
  uni.navigateTo({
    url: `/pages_category_page1/search/index/index`
  })
}
</script>


<style lang="scss" scoped>
  .header {
    .top-box {
      display: flex;
      align-items: center;
      justify-content: space-between;
      padding-left: 30upx;
      width: 100%;
      .logo {
        // width: 280upx;
        height: 70upx;
        margin-top: 0upx;
      }

      .search-btn {
        height: 66upx;
        background: rgba(255, 255, 255, 1);
        border-radius: 33upx;
        display: flex;
        flex-direction: row;
        align-items: center;
        margin-right: 30upx;
        .search-icon {
          width: 60upx;
          height: 60upx;
        }
      }
    }
  }
  .tabs-nav-warp{
    margin-top: 20upx;
    padding:0 30upx;
    overflow: hidden;
    .tabs-nav{
      .ul{
        display: flex;
        flex-wrap: nowrap;
        justify-content: space-between;
        .li{
          flex: 1 0 auto;
          margin-left: 36upx;
          font-size: 30upx;
          color: #999999;
          position: relative;
          padding-bottom: 18upx;
          text-align: center;
          &:first-child{
            margin-left: 0;
          }
          &.on{
            &:after{
              content: '';
              width: 100%;
              height: 4upx;
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
