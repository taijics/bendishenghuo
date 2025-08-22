<template>
  <div class="hom-pro-list warp" :class="'terminal'+terminal">
    <div class="title">
      <h2 class="h2" :style="{textAlign:componentContent.textAlign}">{{componentContent.title}}</h2>
    </div>
    <div class="ul clearfix" :class="{imgTextNum4: componentContent.imgTextData.length === 4, imgTextNum5: componentContent.imgTextData.length === 5, imgTextStyle: componentContent.imgTextData.length >= 6 || componentContent.imgTextData.length === 3}">
      <div class="li" v-for="(item,index) in componentContent.imgTextData" :key="index">
        <a class="item a-link" @click="jumpLink(item.linkObj)">
          <div class="itemImgBox" v-show="item.isShow">
            <div class="imgBox">
              <image class="img" ref="getHeight" :src="item.imgData" v-show="item.imgData" :alt="item.title"/>
            </div>
          </div>
          <div class="text">
            <h4 class="h4">{{item.title}}</h4>
            <p class="p">{{item.describe}}</p>
          </div>
        </a>
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
  .hom-pro-list{
    min-height: 450upx;
    padding: 20upx 0;
    .title{
      margin-bottom: 23upx;
      position: relative;
      .h2{
        font-size: 22upx;
        color: #333;
        line-height: 1em;
        font-weight: bold;
      }
    }
    .ul{
      margin: -15upx 0 0 -15upx;
      display: flex;
      flex-wrap: wrap;
      .li{
        flex: 0 0 50%;
        padding: 15upx 0 0 15upx;
        box-sizing: border-box;
        .item{
          .itemImgBox {
            height: auto;
            display: flex;
            flex-direction: column;
            justify-content: center;
            .imgBox {
              padding-bottom: 80%;
              background-color: #cacaca;
              position: relative;
              .img {
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
          .text{
            padding:16upx 20upx;
            text-align: center;
            .h4{
              line-height: 25upx;
              overflow: hidden;
              color: #333333;
            }
            .p{
              color: #666666;
              padding: 5upx 0 10upx;
            }
          }
        }
      }
    }
    .imgTextNum4 {
      .li {
        flex: 0 0 50%;
      }
    }
    .imgTextNum5 {
      .li {
        flex: 0 0 33.33%;
      }
      .li:nth-child(1) {
        flex: 0 0 50%;
      }
      .li:nth-child(2) {
        flex: 0 0 50%;
      }
    }
    .imgTextStyle {
      .li {
        flex: 0 0 33.33%;
      }
    }
  }
  @media screen and (max-width: 768px) {
    .hom-pro-list .ul .li{
      flex: 0 0 50%;
    }
  }
  .terminal1,.terminal2,.terminal3{
    width: 710upx;
    margin: 0 auto;
    &.hom-pro-list .ul .li{
      flex: 0 0 50%;
    }
  }
</style>
