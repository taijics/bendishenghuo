<template>
  <div class="custom_page">
    <div class="content">
      <div class="toolbar">
        <div class="label">保证金总额</div>
        <div class="bondClass">{{ allMoney }}</div>
      </div>
      <!--  表格 -->
      <div class="content_table">
        <div class="table">
          <!-- <div class="tableTop">
            <span>交易记录</span>
          </div> -->
          <div class="formSearch">
            <!-- 查询 -->
            <el-form
              :inline="true"
              :model="formInline"
            >
              <el-form-item label="店铺名称">
                <el-input
                  v-model="formInline.shopName"
                  maxlength="20"
                  placeholder="请输入店铺名称"
                />
              </el-form-item>
              <el-form-item label="保证金状态">
                <el-select
                  v-model="formInline.bondState"
                  placeholder="请选择状态"
                >
                  <el-option
                    label="全部"
                    value="null"
                  />
                  <el-option
                    label="待支付"
                    value="0"
                  />
                  <el-option
                    label="冻结中"
                    value="1"
                  />
                  <el-option
                    label="已退回"
                    value="2"
                  />
                </el-select>
              </el-form-item>
              <el-form-item label="缴纳时间">
                <el-date-picker
                  v-model="formInline.dates"
                  type="datetimerange"
                  value-format="YYYY-MM-DD"
                  range-separator="至"
                  start-placeholder="开始日期"
                  end-placeholder="结束日期"
                />
              </el-form-item>
              <el-form-item label-width="0">
                <el-button
                  type="primary"
                  plain
                  @click="search"
                >查询
                </el-button>
                <el-button
                  plain
                  @click="clear"
                >重置
                </el-button>
              </el-form-item>
            </el-form>
          </div>
          <el-table
            v-loading="tableLoading"
            :data="tableData"
            border
            :header-cell-style="{ background: '#EEF3FF', color: '#333333' }"
            style="width: 100%"
            class="dataTable"
          >
            >
            <el-table-column
              prop="shopName"
              label="店铺名称"
            />
            <el-table-column
              prop="bondType"
              label="保证金类型"
            />
            <el-table-column
              prop="activityName"
              label="活动名称"
            />
            <el-table-column
              prop="transactionId"
              label="交易流水号"
            />
            <el-table-column
              prop="bondMoney"
              label="保证金金额"
            />
            <el-table-column label="保证金状态">
              <template #default="scope">
                <span v-if="scope.row.bondState == 0">待支付</span>
                <span v-if="scope.row.bondState == 1">冻结中</span>
                <span v-if="scope.row.bondState == 2">已退回</span>
              </template>
            </el-table-column>
            <el-table-column
              prop="time"
              label="缴纳/退保时间"
            />
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
      </div>
    </div>
  </div>
</template>

<script setup>
import { getAllBond } from '@/api/overview'
import { ref, onMounted } from 'vue';

let total = ref(1)
let allMoney = ref('')
let tableData = ref([])
let formInline = ref({
  shopName: '', // 商家名称
  bondState: null, // 保证金状态 空-全部 0-待支付 1-冻结中 2-已退回
  dates: [],
  page: 1,
  pageSize: 10,
})
let tableLoading = ref(false)
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
// 查询
function search () {
  total.value = 1
  formInline.value.page = 1
  getAll(formInline.value)
}
// 清除
function clear () {
  formInline.value = {
    shopName: '', // 商家名称
    bondState: null, // 保证金状态 空-全部 0-待支付 1-冻结中 2-已退回
    dates: [],
    page: 1,
    pageSize: 10,
  }
  getAll(formInline.value)
}
// 初始化查询所有数据
function getAll (formInline) {
  tableLoading.value = true
  getAllBond(formInline).then(res => {
    tableData.value = res.data.page.list
    total.value = res.data.page.total
    allMoney.value = res.data.total
  }).finally(() => {
    tableLoading.value = false
  })
}
</script>

<style lang="scss" scoped>
.custom_page {
  padding: 20px;
  margin-top: 20px;
  background-color: #FFFFFF;
  .toolbar {
    display: flex;
    align-items: center;
    height: 40px;
    margin-bottom: 20px;
    .label {
      font-size: 18px;
      font-weight: bold;
    }
    .bondClass {
      font-size: 28px;
      color: #ffae11;
      margin-left: 20px;
    }
  }
}

.tableTop {
  background: #d7d7d7;
  margin: 0;
  padding: 10px;
}
</style>
