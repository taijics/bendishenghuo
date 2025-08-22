<template>
    <div class="textTool">
      <h3 class="toolTit">辅助分割</h3>
      <div class="operationBox">
        <div class="itemBox">
          <div class="Tit">背景颜色</div>
          <div class="Info">{{activeComponent.componentContent.bgColor}}</div>
          <div class="modifyBox">
            <div class="colorBox">
              <span @click="resetBgColor">重置</span>
              <div class="block">
                <el-color-picker v-model="activeComponent.componentContent.bgColor"></el-color-picker>
              </div>
            </div>
          </div>
        </div>
        <div class="itemBox flexStyle">
          <div class="Tit">图片间隙</div>
          <div class="block">
            <el-slider
              :show-input-controls=false
              input-size="mini"
              v-model="activeComponent.componentContent.height"
              :max="1000"
              show-input>
            </el-slider>
          </div>
        </div>
      </div>
    </div>
</template>

<script>
  import {toolMixin} from '@@/config/mixin'
  export default {
    name: 'assistDivTool',
    mixins: [toolMixin],
    data () {
      return {
      }
    },
    methods: {
      // 重置背景颜色
      resetBgColor () {
        this.activeComponent.componentContent.bgColor = '#FFFFFF'
      }
    }
  }
</script>

<style lang="scss" scoped>
  .textTool {
    padding: 20px 20px 0 20px;
    h3 {
      font-size: 18px;
      font-weight: 500;
      height: 35px;
      line-height: 35px;
      color: #333333;
      margin-bottom: 20px;
    }
    .operationBox {
      margin-top: 30px;
      .itemBox {
        font-size: 14px;
        display: flex;
        margin-bottom: 20px;
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
      }
      .flexStyle {
        display: flex;
        align-items: center;
        height: 40px;
        label {
          margin-right: 20px;
        }
        .block {
          flex: 1;
          height: 40px;
        }
         ::v-deep .el-slider__input {
          width: 50px;
        }
         ::v-deep .el-slider__runway {
          height: 4px;
          margin: 18px 65px 18px 0;
        }
         ::v-deep .el-slider__bar {
          height: 4px;
        }
         ::v-deep .el-slider__button-wrapper {
          top: -17px;
        }
         ::v-deep .el-slider__button {
          width: 12px;
          height: 12px;
        }
         ::v-deep .el-input-number.is-without-controls .el-input__inner {
          padding: 10px;
        }
      }
    }
    .block {
      height: 30px;
    }
     ::v-deep .el-color-picker__trigger {
      width: 45px;
      height: 26px;
    }
     ::v-deep .el-icon-arrow-down:before {
      display: none;
    }
  }
</style>
