<template>
  <div class="gridMenuTool">
    <h3 class="toolTit">九宫格菜单</h3>
    <div class="toolBox">
      <div class="gridListBox">
        <VueDraggableNext v-model="activeComponent.componentContent.gridMenuData">
          <div v-for="(item, index) in activeComponent.componentContent.gridMenuData" :key="index" class="gridItem">
            <div class="listItemBox">
              <div class="addImgTit" @click="openAddImg(item, index)">
                <div class="titLeft">
                  <span class="iconfont">&#xe703;</span>
                  <span class="iconfont">&#xe64a;</span>
                  <span>图片</span>
                </div>
                <div class="titRight">
                  <span class="iconfont" @click.stop="deleteItem(item, index)">&#xe633;</span>
                  <span class="iconfont" v-html="imgCurrent === index ? '&#xe660;' : '&#xe695;'"/>
                </div>
              </div>
              <!-- 编辑区块 -->
              <div v-show="imgCurrent === index" class="addBox">
                <div class="addContent">
                  <tool-single-img v-model:imageUrl="item.img" tip="建议尺寸: 80*80px" />
                  <div class="itemImgTit itemBox">
                    <label>文字</label>
                    <el-input v-model="item.text" maxlength="8" placeholder="请输入菜单文字" />
                  </div>
                  <tool-select-link v-model:linkObj="item.linkObj" />
                </div>
                <div class="deleteItem" @click="deleteItem(item, index)">
                  <span class="iconfont">&#xe633;</span>删除菜单项
                </div>
              </div>
            </div>
          </div>
        </VueDraggableNext>
      </div>
    </div>
    <div v-if="activeComponent.componentContent.gridMenuData.length < 10" class="addImgBtn" @click="addMenuItem">
      <span class="iconfont">&#xe64a;</span>添加菜单项
    </div>
    <div v-else class="addImgBtn">
      <span class="iconfont">&#xe608;</span>最多只能添加10个
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { VueDraggableNext } from 'vue-draggable-next'
import ToolSingleImg from '../toolModule/tool-single-img.vue'
import ToolSelectLink from '../toolModule/tool-select-link.vue'
import { canvasStore } from '@@/store/canvas'
import { storeToRefs } from 'pinia'
const canvasStoreObj = canvasStore()
const { activeComponent } = storeToRefs(canvasStoreObj)
const imgCurrent = ref(null)
function openAddImg(item, index) {
  imgCurrent.value = imgCurrent.value === index ? null : index
}
function addMenuItem() {
  activeComponent.value.componentContent.gridMenuData.push({
    img: '',
    text: '',
    linkObj: {
      selectValue: '',
      selectName: '',
      typeText: '',
      url: ''
    }
  })
}
function deleteItem(item, index) {
  ElMessageBox.confirm('确定删除此项？')
    .then(() => {
      activeComponent.value.componentContent.gridMenuData.splice(index, 1)
    })
    .catch(() => {})
}
</script>

<style lang="scss" scoped>
.gridMenuTool {
  padding: 20px 20px 0px 20px;
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
    .gridListBox {
      margin-top: 28px;
      grid-template-columns: repeat(5, 1fr);
      grid-template-rows: repeat(2, 1fr);
      gap: 12px 0;
      .gridItem {
        border: 1px solid #e8eaec;
        border-radius: 10px;
        margin-bottom: 0;
        padding: 6px 0 0 0;
        background: #fff;
      }
      .listItemBox {
        .addImgTit {
          padding: 8px;
          display: flex;
          justify-content: space-between;
          align-items: center;
          background: #f6f7f9;
          cursor: pointer;
          .titLeft {
            display: flex;
            align-items: center;
            span {
              color: #7d7e80;
            }
            span:nth-child(1) {
              font-size: 26px;
            }
            span:nth-child(2) {
              font-size: 23px;
              margin: 0 6px;
            }
            span:nth-child(3) {
              font-size: 14px;
            }
          }
          .titRight {
            display: flex;
            align-items: center;
            span:nth-child(1) {
              width: 36px;
              text-align: center;
              display: block;
              height: 28px;
              line-height: 28px;
            }
          }
        }
        .addContent {
          padding: 5px 13px;
          .itemBox {
            margin-top: 12px;
          }
          .deleteItem {
            border-radius: 4px;
            background: $mainColor;
            text-align: center;
            height: 34px;
            color: #fff;
            font-size: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            margin-bottom: 8px;
            span {
              font-size: 18px;
              color: #fff;
              margin-right: 5px;
            }
          }
        }
        .deleteItem {
          padding: 8px;
          display: flex;
          align-items: center;
          justify-content: center;
          background: #f6f7f9;
          cursor: pointer;
          color: $mainColor;
          font-size: 14px;
          span {
            font-size: 16px;
            margin-right: 5px;
          }
        }
      }
    }
  }
  :deep(.el-select) {
    width: 100%;
  }
  .addImgBtn {
    border-radius: 4px;
    background: $mainColor;
    text-align: center;
    height: 36px;
    color: #fff;
    font-size: 14px;
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
    margin-top: 18px;
    span {
      font-size: 20px;
      margin-right: 5px;
    }
  }
}
</style>