<template>
  <div class="custom_page">
    <div class="content">
      <!-- 顶部搜索 -->
      <div class="toolbar">
        <!-- 顶部搜索 -->
        <el-form :inline="true" :model="formInline">
          <el-form-item label="保证金总额">
            <span class="bondClass">{{ allMoney }}</span>
          </el-form-item>
        </el-form>
      </div>
      <!--  表格 -->
      <div class="content_table">
        <div class="table">
          <div class="tableTop">
            <span>交易记录</span>
          </div>
          <el-table
            :data="tableData"
            border
            :header-cell-style="{ background: '#EEF3FF', color: '#333333' }"
            style="width: 100%"
          >
            >
            <el-table-column prop="bondType" label="保证金类型" />
            <el-table-column prop="activityName" label="活动名称" />
            <el-table-column prop="transactionId" label="交易流水号" />
            <el-table-column prop="bondMoney" label="保证金金额" />
            <el-table-column label="保证金状态">
              <template slot-scope="scope">
                <span v-if="scope.row.bondState == 0">待支付</span>
                <span v-if="scope.row.bondState == 1">冻结中</span>
                <span v-if="scope.row.bondState == 2">已退回</span>
              </template>
            </el-table-column>
            <el-table-column prop="time" label="交易时间" />
          </el-table>
          <div class="fenye">
            <el-pagination
              :current-page="currentPage"
              :page-sizes="[10, 20, 50, 100]"
              :page-size="10"
              layout="total, sizes, prev, pager, next, jumper"
              :total="total"
              @size-change="handleSizeChange"
              @current-change="handleCurrentChange"
            />
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { getAllBond } from '@/api/finance'
export default {
  data() {
    return {
      formInline: {
        page: 1,
        pageSize: 10
      },
      total: 1,
      allMoney: '',
      tableData: [],
      currentPage: 1
    }
  },
  created() {
    this.getAll(this.formInline)
  },
  methods: {
    handleSizeChange(val) {
      this.formInline.pageSize = val
      this.getAll(this.formInline)
    },
    handleCurrentChange(val) {
      this.formInline.page = val
      this.getAll(this.formInline)
    },
    // 初始化查询所有数据
    async getAll(formInline) {
      const res = await getAllBond(formInline)
      this.tableData = res.data.page.list
      this.total = res.data.page.total
      this.allMoney = res.data.total
    }
  }
}
</script>

<style lang='scss' scoped>
@import url("../../../styles/elDialog.scss");
.custom_page {
  padding: 20px;
}

.bondClass {
  font-size: 28px;
  color: #ffae11;
  margin-left: 20px;
}
.tableTop {
  background: #d7d7d7;
  margin: 0;
  padding: 10px;
}
</style>

