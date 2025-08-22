<template>
  <ul class="ul image-text-nav" :class="'terminal' + terminal">
    <li class="li" v-for="(item,index) in componentContent.imgTextData" :key="index" :style="{'flex':'0 0 '+ getItemValue() + '%'}">
      <!--<router-link class="item" :to="jumpLink(item.linkObj)">-->
        <div class="img-box">
          <div class="img-box-inner">
            <el-image
              :src="item.img"
              fit="cover"></el-image>
          </div>
        </div>
        <h4 class="h4">{{item.title}}</h4>
      <!--</router-link>-->
    </li>
  </ul>
</template>

<script>
  import {funMixin} from '../config/mixin'
  export default {
    name: 'imageTextNav',
    mixins: [funMixin],
    props: {
      terminal: {
        type: Number,
        default: 4
      },
      componentContent: {
        type: Object
      }
    },
    methods: {
      // 计算生成格子百分比
      getItemValue (val) {
        const len = parseInt(this.componentContent.imgTextData.length)
        if (len === 0) {
          return 0
        } else {
          return (1 / len * 10000 / 100.00)
        }
      }
    }
  }
</script>

<style lang="scss" scoped>
  .image-text-nav{
    min-height: 100px;
    width: 690px;
    margin: 0 auto;
    display: flex;
    padding: 20px 0;
    .li{
      text-align: center;
      .img-box{
        .el-image{
          width: 100px;
          height: 100px;
        }
      }
      .h4{
        font-size: 26px;
        color: #333;
        line-height: 33px;
      }
    }
    &.terminal4{
      width: 1000px;
      .li{
        .img-box{
          display: inline-block;
          width: 100px;
          height: 100px;
          border: 2px solid #F3F4F5;
          border-radius: 10px;
          &-inner{
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100%;
          }
          .el-image{
            width: 60px;
            height: 60px;
          }
        }
        .h4{
          font-size: 18px;
          color: #ccc;
          line-height: 1em;
          padding-top: 20px;
        }
      }
    }
  }
</style>
