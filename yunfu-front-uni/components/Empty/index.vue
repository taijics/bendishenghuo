<!--
    * @FileDescription: index
    * @Author: kahu
    * @Date: 2022/11/11
    * @LastEditors: kahu
    * @LastEditTime: 2022/11/11
-->
<template>
  <view v-if="show" class="empty-content" :style="{
        paddingTop: this.paddingTop+'rpx',
        background: this.background
      }">
    <image :src="iconUrl" />
    <p class="tips">
      <slot>
        暂无数据~
      </slot>
    </p>
  </view>
</template>

<script>
import {VUE_APP_STATIC_URL} from "../../config/api";
export default {
  name: "empty",
  data() {
    return {}
  },
  props:{
    show:{
      type:Boolean,
      default:false
    },
    paddingTop:{
        type:Number,
        default:()=>500
    },
    background:{
      type:String,
      default:()=>'#f8f8f8'
    },
    iconUrl:{
      type:String,
      default:()=>`${VUE_APP_STATIC_URL}static/images/searchEmpty.png`
    }
  },
  computed:{

  },
  methods: {}
}
</script>

<style
    lang="scss"
    scoped
>
.empty-content{
  display: flex;
  justify-content: center;
  flex-direction: column;
  align-items: center;
  image{
    width:150rpx;
    height: 150rpx;
  }
  .tips{
    margin-top: 25rpx;
    font-weight: bolder;
  }
}

</style>
