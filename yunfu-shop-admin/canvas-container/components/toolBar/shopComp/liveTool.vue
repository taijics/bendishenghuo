<template>
  <div class="brandListTool">
    <h3 class="toolTit">直播</h3>

    <div class="itemChoice">
      <div class="Tit">查看更多</div>
      <div class="Info" v-text="activeComponent.componentContent.showMore ? '显示' : '隐藏'"></div>
      <div class="modifyBox">
        <el-checkbox v-model="activeComponent.componentContent.showMore"></el-checkbox>
      </div>
    </div>
  </div>
</template>

<script>
import {toolMixin} from '@@/config/mixin'
import {sendReqMixin} from '@@/components/canvasShow/config/mixin'
export default {
  mixins: [toolMixin, sendReqMixin],
  name: 'groupTool',
  data () {
    return {
    }
  },
}
</script>

<style lang="scss" scoped>
.brandListTool {
  padding: 20px 20px 0px 20px;
  h3 {
    font-size: 18px;
    font-weight: 500;
    height: 35px;
    line-height: 35px;
    color: #333333;
    margin-bottom: 20px;
  }

  .itemChoice {
    font-size: 14px;
    display: flex;
    margin: 20px 0;
    align-items: center;
    .Tit {
      color: #888888;
      margin-right: 10px;
      width: 70px;
    }
    .Info {
      color: #222222;
    }
    .modifyBox {
      text-align: right;
      margin-left: auto;
      span {
        height: 26px;
        line-height: 26px;
        float: left;
        display: block;
        text-align: center;
        cursor: pointer;
        width: 30px;
        border: 1px solid #E8EAEC;
      }
      .textActive {
        border: 1px solid $mainColor;
        color: $mainColor;
      }
      .colorBox {
        display: flex;
        align-items: center;
        justify-content: flex-end;
        span {
          margin-right: 10px;
          cursor: pointer;
          border: none;
          color: $mainColor;
        }
      }
    }
    .fontSize {
      span:nth-child(1) {
        font-size: 16px;
      }
      span:nth-child(2) {
        font-size: 14px;
      }
      span:nth-child(3) {
        font-size: 12px;
      }
    }
  }
}
</style>
