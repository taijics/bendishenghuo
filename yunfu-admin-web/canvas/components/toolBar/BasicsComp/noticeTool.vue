<template>
  <div class="textTool">
    <h3 class="toolTit">公告设置</h3>
    <div class="operationBox">
      <div class="itemBox">
        <div class="Tit">标题颜色</div>
        <div class="Info">{{ activeComponent.componentContent.titColor }}</div>
        <div class="modifyBox">
          <div class="colorBox">
            <span @click="resetColor">重置</span>
            <div class="block">
              <el-color-picker
                v-model="activeComponent.componentContent.titColor"
              />
            </div>
          </div>
        </div>
      </div>
      <div class="itemBox">
        <div class="Tit">背景颜色</div>
        <div class="Info">{{ activeComponent.componentContent.bgColor }}</div>
        <div class="modifyBox">
          <div class="colorBox">
            <span @click="resetBgColor">重置</span>
            <div class="block">
              <el-color-picker
                v-model="activeComponent.componentContent.bgColor"
              />
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
<script setup>
import { canvasStore } from '@@/store/canvas';
import { storeToRefs } from 'pinia';
const canvasStoreObj = canvasStore();
const { activeComponent } = storeToRefs(canvasStoreObj);
// 重置文本颜色
function resetColor () {
  activeComponent.value.componentContent.titColor = '#333333'
}
// 重置背景颜色
function resetBgColor () {
  activeComponent.value.componentContent.bgColor = '#FFFFFF'
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
  .toolBox {
    padding-bottom: 10px;
    .itemBox {
      label {
        font-size: 14px;
        color: #666666;
        height: 40px;
        line-height: 40px;
      }
      margin-bottom: 15px;
    }
    border-bottom: 1px solid #eeeeee;
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
          border: 1px solid #e8eaec;
        }
        /*span:last-child {*/
        /*  border-right: 1px solid #E8EAEC;*/
        /*}*/
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
    .moreBox {
      border: 1px solid #e8eaec;
      border-radius: 4px;
      padding: 20px 10px;
      .radio {
        margin-bottom: 20px;
      }
      .el-radio {
        margin-right: 10px;
      }
      .link {
        display: flex;
        justify-content: space-between;
        align-items: center;
      }
    }
  }
  .block {
    height: 30px;
  }
  :deep(.el-color-picker__trigger) {
    width: 45px;
    height: 26px;
  }
  :deep(.el-icon-arrow-down:before) {
    display: none;
  }
}
</style>
