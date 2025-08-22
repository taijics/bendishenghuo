<template>
  <div class="refundPage">
    <div class="acTab">
      <el-tabs v-model="formInline.state" @tab-click="handleClick">
        <el-tab-pane label="待处理" name="0" />
        <el-tab-pane label="已处理" name="1" />
      </el-tabs>
    </div>
    <!-- 搜索 -->
    <div class="formSearch">
      <el-form :inline="true" :model="formInline">
        <el-form-item label="店铺名称/编号">
          <el-input
            v-model="formInline.shopName"
            maxlength="20"
            placeholder="请输入"
          />
        </el-form-item>
        <el-form-item label="订单id">
          <el-input
            v-model="formInline.orderFormid"
            maxlength="20"
            placeholder="请输入"
          />
        </el-form-item>
        <el-form-item label="申请时间">
          <el-date-picker
            v-model="formInline.dates"
            type="daterange"
            range-separator="至"
            start-placeholder="开始日期"
            end-placeholder="结束日期"
          />
        </el-form-item>

        <el-form-item>
          <el-button type="primary" plain @click="search">查询</el-button>
          <el-button
            type="success"
            plain
            @click="afterOrderDataExport"
          >导出订单</el-button>
        </el-form-item>
      </el-form>
    </div>
    <!-- 表格 -->
    <div class="tableBox">
      <el-table
        v-loading="tableLoading"
        :data="tableData"
        border
        :header-cell-style="{ background: '#EEF3FF', color: '#333333' }"
        tooltip-effect="dark"
        style="width: 100%"
        class="dataTable"
      >
        <el-table-column label="订单id" width="220">
          <template #default="scope">{{ scope.row.orderFormid }}</template>
        </el-table-column>
        <el-table-column
          prop="shopName"
          label="店铺名称"
          width="220"
          show-overflow-tooltip
        />
        <el-table-column prop="shopCode" label="店铺编码" width="220" />
        <el-table-column prop="number" label="退款商品数量" width="220" />
        <el-table-column
          prop="refundMoney"
          label="退款金额（元）"
          width="220"
        />
        <el-table-column label="操作">
          <template #default="scope">
            <div class="btnList">
              <el-button
                v-if="formInline.state === '0'"
                link
                type="primary"
                @click="seeMore(scope.row, 1)"
              >处理</el-button>
              <el-button
                v-else
                link
                type="primary"
                @click="seeMore(scope.row, 2)"
              >查看</el-button>
            </div>
          </template>
        </el-table-column>
      </el-table>
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
    </div>

    <el-dialog
      v-model="detailVisible"
      title="订单详情"
      width="75%"
      center
      top="10vh"
      :close-on-click-modal="false"
      :modal-append-to-body="false"
    >
      <OrderDetail class="detailDialog" :detail-row="form" @cancel="cancel" />
    </el-dialog>
  </div>
</template>

<script setup>
import OrderDetail from '@/views/order/after/details/index.vue'
import { afterGetAll, afterOrderExport } from '@/api/after'
import { onMounted, ref } from 'vue';
const formInline = ref({
  state: '0', // 处理状态 0-待处理 1-已处理
  shopName: '', // 店铺名称或编号
  orderFormid: '', // 订单编号
  dates: [], // 申请时间数组
  page: 1,
  pageSize: 10,
})
const total = ref(1)
const tableData = ref([])
const tableLoading = ref(false)
const detailVisible = ref(false)
const form = ref({})
onMounted(() => {
  getAll(formInline.value)
})

function handleSizeChange (val) {
  formInline.value.pageSize = val
  getAll(formInline.value)
}

function handleCurrentChange (val) {
  formInline.value.page = val
  getAll(formInline.value)
}
function handleClick (tab, event) {
  formInline.value.state = tab.paneName
  getAll(formInline.value)
}
function search () {
  total.value = 1
  formInline.value.page = 1
  getAll(formInline.value)
}
function seeMore (row, index) {
  row.type = index
  detailVisible.value = true
  form.value = row
}
function cancel () {
  detailVisible.value = false
}
async function getAll (formInline) {
  tableLoading.value = true
  const res = await afterGetAll(formInline)
  tableData.value = res.data.list
  total.value = res.data.total
  tableLoading.value = false
}
async function afterOrderDataExport () {
  ElMessage({
    message: '数据导出中，请勿重复操作！',
    type: 'success',
  })
  const res = await afterOrderExport(formInline.value)
  if (!res) {
    return
  }
  const blob = new Blob([res], { type: 'application/vnd.ms-excel' })
  const fileName = '售后订单数据明细表.xls'
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
}
</script>

<style lang="scss" scoped>
.refundPage {
  padding: 20px;
  margin-top: 20px;
  background-color: #FFFFFF;
  .detailDialog {
    height: 800px;
    overflow: auto;
  }
}
</style>
