<template>
  <div class="ul image-text-nav" :class="'terminal' + terminal">
    <div class="li" v-for="(item,index) in componentContent.imgTextData" :key="index" :style="{'flex':'0 0 '+ getItemValue() + '%'}" @click="jumpLink(item.linkObj)">
      <!--<router-link class="item" :to="jumpLink(item.linkObj)">-->
        <div class="img-box">
          <div class="img-box-inner">
			  <div class="imgBox">
			    <image class="img" :src="item.img" />
			  </div>
          </div>
        </div>
        <h4 class="h4">{{item.title}}</h4>
      <!--</router-link>-->
    </div>
  </div>
</template>

<script setup>
import { toRefs } from 'vue';
import { funMixin } from '../config/mixin'
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
// 计算生成格子百分比
function getItemValue () {
  const len = parseInt(componentContent.value.imgTextData.length)
  if (len === 0) {
    return 0
  } else {
    return ((1 / len) * 10000) / 100.0
  }
}
</script>

<style lang="scss" scoped>
  .image-text-nav{
    min-height: 100upx;
    width: 710upx;
    margin: 0 auto;
    display: flex;
    padding: 20upx 0;
    .li{
      text-align: center;
      .img-box{
        .imgBox{
          width: 100upx;
          height: 100upx;
		  display: inline-block;
		  .img{
			  width: 100%;
			  height: 100%;
			  object-fit: cover;
		  }
        }
      }
      .h4{
        font-size: 26upx;
        color: #333;
        line-height: 33upx;
      }
    }
    &.terminal4{
      width: 1000upx;
      .li{
        .img-box{
          display: inline-block;
          width: 100upx;
          height: 100upx;
          box-shadow: 0 10upx 30upx rgba(51, 51, 51, 0.15);
          &-inner{
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100%;
          }
          .imgBox{
            width: 60upx;
            height: 60upx;
          }
        }
        .h4{
          font-size: 18upx;
          color: #ccc;
          line-height: 1em;
          padding-top: 20upx;
        }
      }
    }
  }
</style>
