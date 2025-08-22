<template>
  <div class="brandListTool">
    <h3 class="toolTit">秒杀专区</h3>
    <div class="porListBox">
      <div class="addProduct">
        <div>
          <div
            v-for="(item, index) in activeComponent.componentContent
              .activityName"
            :key="index"
            class="categoryName"
          >
            <span>{{ item }}</span>
            <div class="operation">
              <span
                class="iconfont"
                @click="deleteActivity(index)"
              >&#xe633;</span>
            </div>
          </div>
        </div>
        <div class="addProBtn addImgBtn" @click="selectActivity">
          <span class="iconfont">&#xe685;</span>选择活动
        </div>
      </div>
    </div>
    <el-dialog v-model="showSkillActivity" title="选择活动" width="900px">
      <el-table
        :data="skillActivity"
        style="width: 100%"
        border
        highlight-current-row
        row-key="shopSeckillId"
        @row-click="rowClick"
        @selection-change="handleSelectionChange"
      >
        <el-table-column v-if="typeId == 1" type="selection" width="40" />
        <el-table-column v-if="typeId == 3" label width="35">
          <template #default="scope">
            <el-radio v-model="radioId" :label="scope.row.shopSeckillId">1</el-radio>
          </template>
        </el-table-column>
        <el-table-column prop="seckillName" label="标题" />
        <el-table-column :formatter="getDate" width="400" label="活动时间" />
        <el-table-column label="状态" :formatter="getState" />
      </el-table>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="cancelSkill">取 消</el-button>
          <el-button type="primary" @click="confirmActivity">确 定</el-button>
        </span>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref } from 'vue';
import Cookies from 'js-cookie'
import { sendReqMixin } from '@@/components/canvasShow/config/mixin'
import api from '@@/components/canvasShow/config/api'
import { canvasStore } from '@@/store/canvas';
import { storeToRefs } from 'pinia';
const canvasStoreObj = canvasStore();
const { activeComponent, typeId } = storeToRefs(canvasStoreObj);
const { setSpikeNum } = canvasStoreObj
const { sendReq } = sendReqMixin()
const radioId = ref('')
const skillActivity = ref([])
const selectSkill = ref({})
const showSkillActivity = ref(false)
const multipleSelection = ref([]) // 多选数据

// 时间变换
function getDate (row) {
  if (typeId.value === 1) {
    return `${row.startTime}至${row.endTime}`
  }
  if (typeId.value === 3) {
    return `${row.effectiveStart}至${row.effectiveEnd}`
  }
}
// 状态变换
function getState (row) {
  if (typeId.value === 1) {
    const opt = {
      0: '报名未开始',
      1: '报名进行中',
      2: '活动待开始',
      3: '活动进行中',
      4: '活动已结束',
    }
    return opt[row.state]
  }
  if (typeId.value === 3) {
    const opt = {
      0: '未开始',
      1: '进行中',
      2: '已结束',
    }
    return opt[row.state]
  }
}
// 点击选择活动
function selectActivity () {
  getActivity()
  showSkillActivity.value = true
  radioId.value = activeComponent.value.componentContent.shopSeckillId
}
// 获取活动数据
function getActivity () {
  let _url = ''
  if (typeId.value === 1) {
    _url = `${api.getPlatformSeckills}`
  } else if (typeId.value === 3) {
    _url = `${api.getSeckills}?shopId=${Cookies.get('cereShopId')}`
  }
  const params = {
    method: 'GET',
    url: _url,
  }
  sendReq(params, (res) => {
    skillActivity.value = res.data
  })
}
// 行点击
function rowClick (row) {
  selectSkill.value = row
  radioId.value = row.shopSeckillId
}
// 确认活动选择
function confirmActivity () {
  if (typeId.value === 1) {
    const shopSeckillIds = []
    const activityNames = []
    for (let i = 0; i < multipleSelection.value.length; i++) {
      shopSeckillIds.push(multipleSelection.value[i].seckillId)
      activityNames.push(multipleSelection.value[i].seckillName)
    }
    activeComponent.value.componentContent.shopSeckillId = shopSeckillIds
    activeComponent.value.componentContent.activityName = activityNames
  }
  if (typeId.value === 3) {
    activeComponent.value.componentContent.shopSeckillId = [
      selectSkill.value.shopSeckillId,
    ]
    activeComponent.value.componentContent.activityName = [
      selectSkill.value.seckillName,
    ]
  }
  showSkillActivity.value = false
  setSpikeNum()
}
// 取消活动选择
function cancelSkill () {
  showSkillActivity.value = false
  radioId.value = ''
}
// 删除已选活动
function deleteActivity (index) {
  activeComponent.value.componentContent.activityName.splice(index, 1)
  activeComponent.value.componentContent.shopSeckillId.splice(index, 1)
  // this.$forceUpdate()
  setSpikeNum()
}
// 多选改变
function handleSelectionChange (val) {
  multipleSelection.value = val
}

</script>

<style lang="scss" scoped>
.config-content {
  .item {
    padding: 12px 0;
    border-bottom: 1px #ddd solid;
    &:nth-child(1) {
      border-top: 1px #ddd solid;
    }
  }
  .label-text {
    color: #666;
    span {
      color: hsl(357, 97%, 49%);
      font-size: 20px;
      vertical-align: middle;
      display: inline-block;
      margin-right: 5px;
    }
  }

  .add {
    margin-top: 10px;
    width: 50px;
    height: 50px;
    text-align: center;
    line-height: 50px;
    border: 1px #ddd solid;
    box-shadow: 0 0 10px #ddd;
    .el-icon-plus {
      color: blue !important;
    }
    &:hover {
      cursor: pointer;
    }
  }
}

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
    .textTit {
      height: 35px;
      line-height: 35px;
      font-size: 14px;
      color: #333333;
      display: flex;
      justify-content: space-between;
      span {
        font-weight: normal;
        font-size: 14px;
        color: #666666;
      }
    }
    .productTit {
      margin-top: 20px;
      color: #666666;
      height: 35px;
      display: flex;
      align-items: center;
      justify-content: space-between;
      span {
        font-size: 14px;
        color: #666666;
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
    color: #ffffff;
    font-size: 14px;
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
    span {
      font-size: 20px;
      margin-right: 5px;
    }
  }
  .labelLisTit {
    display: flex;
    justify-content: space-between;
    margin-bottom: 10px;
  }
  .labelListWarp {
    padding-bottom: 20px;
    .imgListBox {
      margin-top: 20px;
      .item {
        border: 1px solid #e8eaec;
        border-radius: 4px;
        margin-bottom: 10px;
      }
      .listItemBox {
        .addImgTit {
          padding: 10px;
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
              font-size: 28px;
            }
            span:nth-child(2) {
              font-size: 25px;
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
              width: 40px;
              text-align: center;
              display: block;
              height: 30px;
              line-height: 30px;
            }
          }
        }
        .addLabelBox {
          padding: 0 10px 10px;
          .itemBox {
            margin-bottom: 20px;
            label {
              font-size: 14px;
              color: #666666;
              height: 40px;
              line-height: 40px;
            }
          }
          :deep(.module-box) {
            margin-bottom: 10px;
          }
        }
        .deleteItem {
          padding: 10px;
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
}

.styleSelectLine {
  margin-top: 30px;
  .blockTit {
    span {
      margin-right: 16px;
      &:last-child {
        color: $mainColor;
      }
    }
  }
  .composeList {
    display: flex;
    flex-wrap: wrap;
    padding-top: 20px;
    .item {
      width: 50px;
      height: 30px;
      display: flex;
      align-items: center;
      justify-content: center;
      border: 1px solid #e8eaec;
      color: #999999;
      font-size: 18px;
      text-align: center;
      cursor: pointer;
      &:hover,
      &.active {
        color: #ff7800;
        border: 1px solid #ff7800;
      }
    }
  }
}

.porListBox {
  padding: 10px;
  background: #f0f3f4;
  .addProduct {
    .categoryName {
      height: 35px;
      display: flex;
      align-items: center;
      background: #e9e9e9;
      border-radius: 4px;
      padding: 0 10px;
      justify-content: space-between;
      margin-bottom: 10px;
      span {
        color: #333333;
      }
      span {
        color: #333333;
      }
      .operation {
        display: flex;
        span {
          width: 35px;
          display: block;
          height: 35px;
          line-height: 35px;
          text-align: center;
          cursor: pointer;
        }
      }
    }
  }
}
</style>
