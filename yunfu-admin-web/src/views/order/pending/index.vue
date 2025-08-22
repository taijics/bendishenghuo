<template>
  <div class="pending">
    <div class="tab_show">
      <el-tabs
        v-model="formInline.state"
        @tab-click="handleClick"
      >
        <el-tab-pane
          label="全部"
          :name="''"
        />
        <el-tab-pane
          label="待付款"
          name="1"
        />
        <el-tab-pane
          label="待发货"
          name="2"
        />
        <el-tab-pane
          label="已发货"
          name="3"
        />
        <el-tab-pane
          label="已完成"
          name="4"
        />
        <el-tab-pane
          label="已关闭"
          name="5"
        />
      </el-tabs>
      <!-- 搜索 -->
      <el-form
        :inline="true"
        :model="formInline"
      >
        <el-form-item>
          <el-input
            v-model="formInline.search"
            placeholder="请输入内容"
          >
            <template #prepend>
              <el-select
                v-model="formInline.searchType"
                style="width: 130px"
                placeholder="请选择"
              >
                <el-option
                  label="订单id"
                  value="1"
                />
                <el-option
                  label="买家账户"
                  value="2"
                />
                <el-option
                  label="收件人姓名"
                  value="3"
                />
                <el-option
                  label="收件人手机号"
                  value="4"
                />
                <!-- <el-option label="商品ID" value="5" /> -->
              </el-select>
            </template>
          </el-input>
        </el-form-item>
        <el-form-item label="商户名称">
          <el-input
            v-model="formInline.shopName"
            maxlength="20"
            placeholder="请输入"
          />
        </el-form-item>
        <!-- <el-form-item label="售后状态">
            <el-select v-model="formInline.afterState" placeholder="请选择售后状态">
              <el-option label="全部" :value="null" />
              <el-option label="无售后" value="0" />
              <el-option label="售后中" value="1" />
              <el-option label="售后成功" value="2" />
              <el-option label="售后关闭" value="3" />
            </el-select>
          </el-form-item> -->
        <el-form-item label="下单时间">
          <el-date-picker
            v-model="formInline.dates"
            type="daterange"
            range-separator="至"
            start-placeholder="开始日期"
            end-placeholder="结束日期"
          />
        </el-form-item>
        <el-form-item>
          <el-button
            type="primary"
            plain
            @click="search"
          >查询
          </el-button>
          <el-button
            type="success"
            plain
            @click="orderDataExport"
          >导出订单
          </el-button>
        </el-form-item>
      </el-form>
      <!-- 表格 -->
      <el-table
        v-loading="tableLoading"
        :data="tableData"
        border
        stripe
        :header-cell-style="{ background: '#EEF3FF', color: '#333333' }"
        tooltip-effect="dark"
        style="width: 100%"
        class="dataTable"
      >
        <el-table-column
          label="订单id"
          width="150"
        >
          <template #default="scope">{{ scope.row.orderId }}</template>
        </el-table-column>
        <el-table-column
          prop="number"
          label="商品数量"
          width="100"
        />
        <el-table-column
          prop="shopName"
          label="商户名称"
          width="220"
          show-overflow-tooltip
        />
        <el-table-column
          prop="customerName"
          label="下单账户"
          show-overflow-tooltip
        />
        <el-table-column
          prop="receiveName"
          label="收件人"
          show-overflow-tooltip
        />
        <el-table-column
          prop="receivePhone"
          label="手机号"
          show-overflow-tooltip
        />
        <el-table-column
          prop="price"
          label="支付金额（元）"
          width="120"
        />
        <el-table-column
          prop="createTime"
          label="下单时间"
          show-overflow-tooltip
        />
        <el-table-column
          label="订单状态"
        >
          <template #default="scope">
            <span
              v-if="scope.row.state == 1"
              :style="{ color: '#E6A23C' }"
            >待付款</span>
            <span
              v-if="scope.row.state == 2"
              :style="{ color: '#F56C6C' }"
            >待发货</span>
            <span
              v-if="scope.row.state == 3"
              :style="{ color: '#409EFF' }"
            >已发货</span>
            <span
              v-if="scope.row.state == 4"
              :style="{ color: '#67C23A' }"
            >已完成</span>
            <span
              v-if="scope.row.state == 5"
              :style="{ color: '#909399' }"
            >已关闭</span>
          </template>
        </el-table-column>

        <el-table-column
          label="操作"
        >
          <template #default="scope">
            <div class="btnList">
              <el-button
                link
                type="primary"
                @click="seeMore(scope.row)"
              >查看
              </el-button>
            </div>
          </template>
        </el-table-column>
      </el-table>
      <div class="fenye">
        <el-pagination
            :current-page="formInline.page"
            :page-sizes="[10, 20, 50, 100]"
            :page-size="formInline.pageSize"
            layout="total, sizes, prev, pager, next, jumper"
            background
            :total="total"
            @size-change="handleSizeChange"
            @current-change="handleCurrentChange"
        />
      </div>
    </div>
    <el-dialog
      v-model="detailVisible"
      title="订单详情"
      width="74%"
      center
      :close-on-click-modal="false"
    >
      <OrderDetail
        :detail-row="form"
        @cancel="cancel"
      />
    </el-dialog>
  </div>
</template>

<script setup>
import OrderDetail from '@/views/order/pending/pendDetails.vue'
import { orderExport, orderGetAll } from '@/api/order'
import { onMounted, ref } from 'vue';

const formInline = ref({
  searchType: '1',
  search: '', // 搜索字段
  state: '',
  // afterState: '', // 售后状态 0-无售后 1-售后中 2-售后成功 3-售后关闭
  dates: [], // 下单时间数组
  page: 1,
  shopName: '',
  pageSize: 10,
})
const total = ref(1)
const tableData = ref([])
const tableLoading = ref(false)
const detailVisible = ref(false)
const form = ref({})
onMounted(() => {
  getAll(formInline.value)
  handleClick({ name: '' })
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
  formInline.value.page = 1
  getAll(formInline.value)
}

//  查询
function search () {
  total.value = 1
  formInline.value.page = 1
  getAll(formInline.value)
}

// 详情
function seeMore (row) {
  detailVisible.value = true
  form.value = row
  // $router.push({
  //   name: 'pendDetails',
  //   params: { orderId: row.orderId }
  // })
}

function cancel () {
  detailVisible.value = false
}

// 初始化查询所有数据
async function getAll (formInline) {
  tableLoading.value = true
  const res = await orderGetAll(formInline)
  tableData.value = res.data.list
  total.value = res.data.total
  tableLoading.value = false
}

// 导出订单
async function orderDataExport () {
  ElMessage({
    message: '数据导出中，请勿重复操作！',
    type: 'success',
  })
  const res = await orderExport(formInline.value)
  if (!res) {
    return
  }
  const blob = new Blob([res], { type: 'application/vnd.ms-excel' })
  const fileName = '订单数据明细表.xls'
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
.pending {
  padding: 20px;
  margin-top: 20px;
  background-color: #FFFFFF;
}
.fenye {
  margin-top: 20px;
}
// .tab_show {
//   padding-left: 30px;
// }
</style>
