<template>
  <div class="textTool">
    <h3 class="toolTit">头部设置</h3>
    <div class="operationBox">
      <div class="itemBox">
        <div class="Tit">LOGO类型</div>
        <el-radio-group v-model="activeComponent.componentContent.logoType">
          <el-radio :label="1">图片</el-radio>
          <el-radio :label="2">文本</el-radio>
        </el-radio-group>
      </div>
      <div v-if="activeComponent.componentContent.logoType === 1">
        <tool-single-img
          v-model:imageUrl="activeComponent.componentContent.imageUrl"
          tip="建议尺寸: 高度100px, 宽度自适应"
        />
      </div>
      <div v-else>
        <div class="itemBox">
          <div class="Tit">LOGO文本</div>
          <el-input
            v-model="activeComponent.componentContent.title"
            class="item-input"
            maxlength="20"
            placeholder="请输入内容"
          />
        </div>
        <div class="itemBox">
          <div class="Tit">文本大小</div>
          <div class="modifyBox fontSize">
            <font-size-select
              v-model:fontSize="activeComponent.componentContent.fontSizeNum"
            />
          </div>
        </div>
        <div class="itemBox">
          <div class="Tit">文本粗细</div>
          <div
            class="Info"
            v-text="
              activeComponent.componentContent.textFontW === 'bold'
                ? '加粗体'
                : '常规体'
            "
          />
          <div class="modifyBox fontSize">
            <span
              class="iconfont"
              :class="{
                textActive:
                  activeComponent.componentContent.textFontW === 'bold',
              }"
              @click="changeFontW((type = 'bold'))"
            >&#xe649;</span>
            <span
              class="iconfont"
              :class="{
                textActive:
                  activeComponent.componentContent.textFontW === 'normal',
              }"
              @click="changeFontW((type = 'normal'))"
            >&#xe8c2;</span>
          </div>
        </div>
        <div class="itemBox">
          <div class="Tit">文本颜色</div>
          <div class="Info">
            {{ activeComponent.componentContent.titColor }}
          </div>
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
      </div>
    </div>
  </div>
</template>
<script setup>
import FontSizeSelect from '../toolModule/font-size-select.vue'
import ToolSingleImg from '../toolModule/tool-single-img.vue'
import { canvasStore } from '@@/store/canvas';
import { storeToRefs } from 'pinia';
const canvasStoreObj = canvasStore();
const { activeComponent } = storeToRefs(canvasStoreObj);
function changeFontW (type) {
  activeComponent.value.componentContent.textFontW = type
}
function resetColor () {
  activeComponent.value.componentContent.titColor = '#333333'
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
      .item-input {
        flex: 1;
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
