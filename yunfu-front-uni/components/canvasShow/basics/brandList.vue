<template>
  <div class="brand-list warp" :class="'terminal' + terminal">
    <h2 class="hom-title" :style="{textAlign:componentContent.textAlign}">{{componentContent.title}}</h2>
    <div class="content-warp">
      <div class="ul clearfix">
        <div class="li" v-for="(item, index) in componentContent.imgList" :key="index">
          <a class="item a-link" @click="jumpLink(item.linkObj)">
            <div class="imgBox">
              <image :src="item.imgData" v-show="item.imgData" :alt="item.title"/>
            </div>
            <h4 class="h4">{{item.title}}</h4>
          </a>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { toRefs } from 'vue';
import funMixin from '../config/mixin/funMixin.js'
const { jumpLink } = funMixin()
const props = defineProps({
  terminal: {
    type: Number,
    default: 4,
  },
  componentContent: {
    type: Object,
    default () {
      return {};
    }
  }
})
const { terminal, componentContent } = toRefs(props)
</script>
<style lang="scss" scoped>
  .brand-list{
    color: #fff;
    padding: 20upx 0;
    .hom-title{
      font-size: 22upx;
      color: #333;
      line-height: 1em;
      margin-bottom: 23upx;
      font-weight: bold;
    }
    .content-warp{
      display: flex;
    }
    .first{
      width: 24%;
      padding-top: 10upx;
      .item{
        background-color: #7A8594;
        height: 336upx;
        display: flex;
        flex-direction: column;
        justify-content: center;
        .h3{
          font-size: 30upx;
          line-height: 46upx;
          margin-bottom: 10upx;
        }
      }
    }
    .ul{
      width: 100%;
      .li{
        width: 25%;
        float: left;
        padding: 10upx 0 0 10upx;
        box-sizing: border-box;
        .item{
          height: auto;
          display: flex;
          flex-direction: column;
          justify-content: center;
          .imgBox {
            padding-bottom: 80%;
            background-color: #cacaca;
            position: relative;
          }
          .h4{
            font-size: 18upx;
            color: #333333;
            text-align: center;
            height: 40upx;
            line-height: 40upx;
          }
          .p{
            font-size: 12upx;
            margin: 7upx 0 12upx;
          }
          image {
            max-width: 100%;
            height: 100%;
            max-height: 100%;
            position: absolute;
            margin: auto;
            top: 0;
            right: 0;
            bottom: 0;
            left: 0;
          }
        }
      }
    }
  }
  .terminal1,.terminal2,.terminal3{
    &.brand-list{
      width: 710upx;
      margin: 0 auto;
      .content-warp{
        display: block;
      }
      .first{
        width: 100%;
      }
      .ul{
        width: auto;
        margin-left: -15upx;
        .li{
          width: 50%;
          padding: 15upx 0 0 15upx;
          .item {
            padding-left: 0;
          }
        }
      }
    }
  }
</style>
