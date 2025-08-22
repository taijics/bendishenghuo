<template>
  <div class="tipStyle">
    <!-- 搜索 -->
    <div class="topSearch">
      <div class="formSearch">
        <el-form :inline="true" :model="formInline">
          <el-form-item label="标签名称">
            <el-input
              v-model="formInline.labelName"
              maxlength="20"
              placeholder="请输入标签名称"
            />
          </el-form-item>
          <el-form-item label="标签类型">
            <el-select
              v-model="formInline.labelType"
              placeholder="请选择标签类型"
            >
              <el-option label="手动标签" value="1" />
              <el-option label="自动标签" value="2" />
            </el-select>
          </el-form-item>
          <el-form-item>
            <el-button type="primary" plain @click="search">查询</el-button>
            <el-button plain @click="clear">重置</el-button>
          </el-form-item>
        </el-form>
      </div>
      <div class="rightBTn">
        <el-button type="primary" @click="addTips">新建标签</el-button>
        <el-button @click="exportTips">导出标签</el-button>
      </div>
    </div>
    <!-- 表格 -->
    <el-table
      v-loading="tableLoading"
      :data="tableData"
      border
      :header-cell-style="{ background: '#EEF3FF', color: '#333333' }"
      tooltip-effect="dark"
      style="width: 100%"
      class="dataTable"
      @selection-change="handleSelectionChange"
    >
      <el-table-column type="selection" />
      <el-table-column label="标签名" width="220">
        <template #default="scope">{{ scope.row.labelName }}</template>
      </el-table-column>
      <el-table-column prop="users" label="客户" />
      <el-table-column prop="labelType" label="标签类型">
        <template #default="scope">
          <span v-if="scope.row.labelType == 1">手动标签</span>
          <span v-else>自动标签</span>
        </template>
      </el-table-column>
      <el-table-column prop="conditions" label="达标条件">
        <template #default="scope">
          <div v-if="scope.row.labelType === 1">暂无标签</div>
          <div v-else @click="modelTouch(scope.row)">
            {{ scope.row.conditions.toString() }}
          </div>
        </template>
      </el-table-column>
      <el-table-column label="操作">
        <template #default="scope">
          <div class="btnList">
            <el-button type="primary" link @click="edit(scope.row)">编辑</el-button>
            <el-popconfirm title="确认删除？" @confirm="deleteTips(scope.row)">
              <template #reference>
                <el-button type="danger" link>删除</el-button>
              </template>
            </el-popconfirm>
          </div>
        </template>
      </el-table-column>
    </el-table>
    <!-- 批量删除 -->
    <div class="batch_btn">
      <el-button
        plain
        :disabled="!multipleSelection.length"
        @click="deleteTips"
      >批量删除</el-button>
    </div>
    <el-pagination
      :current-page="formInline.page"
      :page-sizes="[10, 20, 50, 100]"
      :page-size="formInline.pageSize"
      layout="total, sizes, prev, pager, next, jumper"
      background
      :total="total"
      style="margin: 12px 0;"
      @size-change="handleSizeChange"
      @current-change="handleCurrentChange"
    />
    <!-- ******************************************************弹框开始***************************************************************** -->
    <!-- 达标详情弹框 -->
    <el-dialog
      v-model="dialogVisible"
      title="达标详情"
      width="30%"
      center
      :close-on-click-modal="false"
    >
      <div class="diaddStyle">
        <h1>满足以下任意条件即可</h1>
        <div class="jiaoyi">
          <div class="leftJ">交易条件:</div>
          <div class="rightJ">
            <p v-for="(item, index) in text" :key="index">{{ item }}</p>
          </div>
        </div>
      </div>
      <template #footer>
        <span class="dialog-footer">
          <el-button type="primary" @click="dialogVisible = false">我知道了</el-button>
        </span>
      </template>
    </el-dialog>
    <tips-form ref="tipsFormRef" @reset="reset" />
  </div>
</template>

<script setup>
import { ref, onBeforeMount } from 'vue'
import {
  tipsGetAll,
  tipsDelete,
  excel_platform_label,
} from '@/api/customerMage'
import TipsForm from './tipsForm.vue'

const tipsFormRef = ref(null)
const tableLoading = ref(false)
const formInline = ref({
  labelName: '', // 标签名称
  labelType: '', // 标签类型 1-手动标签 2-自动标签
  page: 1,
  pageSize: 10
})
const total = ref(1)
const tableData = ref([])
const dialogVisible = ref(false)
const text = ref('')
const multipleSelection = ref([])

onBeforeMount(() => {
  getAll()
})

const handleSizeChange = (val) => {
  formInline.value.pageSize = val
  getAll()
}
const handleCurrentChange = (val) => {
  formInline.value.page = val
  getAll()
}
const handleSelectionChange = (val) => {
  multipleSelection.value = val
}
// 查询
const search = () => {
  total.value = 1
  formInline.value.page = 1
  getAll()
}
// 清楚
const clear = () => {
  formInline.value = {
    labelName: '', // 标签名称
    labelType: '', // 标签类型 1-手动标签 2-自动标签
    page: 1,
    pageSize: 10
  }
  getAll()
}
// 编辑
const edit = (row) => {
  tipsFormRef.value.show({ buyerLabelId: row.buyerLabelId })
}
// 初始化查询所有数据
const getAll = () => {
  tableLoading.value = true
  tipsGetAll(formInline.value).then(res => {
    tableData.value = res.data.list
    total.value = res.data.total
  }).finally(() => {
    tableLoading.value = false
  })
}
// 新建标签
const addTips = () => {
  tipsFormRef.value.show()
}
// 详情弹框
const modelTouch = (row) => {
  text.value = row.conditions
  dialogVisible.value = true
}
// 删除
const deleteTips = async (row) => {
  let ids = []
  if (multipleSelection.value.length === 0) {
    ids = [row.buyerLabelId]
  } else {
    multipleSelection.value.forEach((item) => {
      ids.push(item.buyerLabelId)
    })
  }
  const res = await tipsDelete({ ids })
  if (res.code === '') {
    ElMessage({
      message: '删除成功',
      type: 'success',
    })
    getAll()
  }
}
// 导出标签
const exportTips = () => {
  if (multipleSelection.value.length === 0) {
    ElMessage.error('请选择导出行')
    return
  }
  const ids = []
  multipleSelection.value.forEach((item) => {
    ids.push(item.buyerLabelId)
  })
  excel_platform_label({ ids }).then((res) => {
    const blob = new Blob([res])
    const fileName = '标签表.xlsx'
    if ('download' in document.createElement('a')) {
      // 非IE下载
      const elink = document.createElement('a')
      elink.download = fileName
      elink.style.display = 'none'
      elink.href = URL.createObjectURL(blob)
      document.body.appendChild(elink)
      elink.click()
      URL.revokeObjectURL(elink.href) // 释放URL 对象
      document.body.removeChild(elink)
    } else {
      // IE10+下载
      navigator.msSaveBlob(blob, fileName)
    }
  })
}
const reset = () => {
  getAll()
}
</script>

<style lang="scss" scoped>
.tipStyle {
  padding: 20px;
  margin-top: 20px;
  background-color: #FFFFFF;
  .topSearch {
    display: flex;
    justify-content: space-between;
    align-items: center;
    .rightBTn {
      .el-button {
        height: 38px;
        margin-bottom: 18px;
      }
    }
  }
}
.diaddStyle {
  h1 {
    text-align: center;
    font-size: 24px;
    color: #333333;
  }
  .jiaoyi {
    display: flex;
    justify-content: center;
  }
  .leftJ {
    margin: 15px;
  }
  .leftJ,
  .rightJ {
    font-size: 16px;
    color: #333333;
  }
}
.batch_btn {
  padding: 5px 10px;
  border: 1px solid #dfe6ec;
  background-color: #fff;
  border-top: 0;
}
</style>
