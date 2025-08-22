<template>
  <div class="custom_page">
    <div class="content">
      <!-- 顶部搜索 -->
      <div class="toolbar">
        <!-- 顶部搜索 -->
        <el-form :inline="true" :model="formInline">
          <el-form-item label="订单号">
            <el-input v-model="formInline.orderFormid" maxlength="20" placeholder="请输入订单号" />
          </el-form-item>
          <el-form-item label="分销员昵称">
            <el-input v-model="formInline.distributorName" maxlength="20" placeholder="请输入分销员昵称" />
          </el-form-item>
          <el-form-item label="分销员手机号">
            <el-input v-model="formInline.distributorPhone" maxlength="11" placeholder="请输入手机号" />
          </el-form-item>
          <el-form-item label="交易时间">
            <el-date-picker
              v-model="formInline.dates"
              type="daterange"
              range-separator="至"
              start-placeholder="开始时间"
              end-placeholder="结束时间"
              value-format="yyyy-MM-dd"
            />
          </el-form-item>
          <el-form-item label="结算状态">
            <el-select v-model="formInline.state" placeholder="请选择结算状态">
              <el-option label="全部" :value="null" />
              <el-option label="已结算" value="1" />
              <el-option label="未结算" value="0" />
            </el-select>
          </el-form-item>
          <el-form-item label-width="0">
            <el-button type="primary" plain @click="search">查询</el-button>
            <el-button plain @click="clear">重置</el-button>
          </el-form-item>
        </el-form>
      </div>
      <!--  表格 -->
      <div class="content_table">
        <div class="table">
          <el-table
            :data="tableData"
            border
            :header-cell-style="{ background: '#EEF3FF', color: '#333333' }"
            style="width: 100%"
            @selection-change="handleSelectionChange"
          >
            <el-table-column type="selection" width="55" :selectable="checkState" />
            <el-table-column prop="orderFormid" label="订单号" />
            <el-table-column prop="distributorName" label="分销员昵称" />
            <el-table-column prop="distributorPhone" label="分销员手机号" />
            <el-table-column prop="price" label="商品金额(元)" />
            <el-table-column prop="commission" label="佣金(元)" />
            <el-table-column label="结算状态">
              <template slot-scope="scope">
                <span v-if="scope.row.state == 0">未结算</span>
                <span v-if="scope.row.state == 1">已结算</span>
              </template>
            </el-table-column>
            <el-table-column prop="transactionTime" label="交易时间" />
          </el-table>
          <div class="tablefoot">
            <el-button plain :disabled="!multipleSelection.length" @click="getOrder">标记为已结算</el-button>
          </div>
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
import { tipsdistributorGetAll, settlement } from '@/api/distributor'
import { hidden } from '@/utils';
export default {
  data() {
    return {
      formInline: {
        orderFormid: '',
        distributorName: '',
        distributorPhone: '',
        dates: [],
        state: null,
        page: 1,
        pageSize: 10
      },
      total: 1,
      tableData: [],
      currentPage: 1,
      multipleSelection: []
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
    handleSelectionChange(val) {
      this.multipleSelection = val
    },
    // 查询
    search() {
      this.total = 1
      this.formInline.page = 1
      this.getAll(this.formInline)
    },
    // 清除
    clear() {
      this.formInline = {
        orderFormid: '',
        distributorName: '',
        distributorPhone: '',
        dates: [],
        state: '',
        page: 1,
        pageSize: 10
      }
      this.getAll(this.formInline)
    },
    // 标记为已结算
    async getOrder() {
      const arr = []
      this.multipleSelection.forEach(element => {
        arr.push(element.orderId)
      })
      const res = await settlement({ ids: arr })
      if (res.code === '') {
        if (res.code === '') {
          this.$message({
            message: '结算成功',
            type: 'success'
          })
          this.getAll(this.formInline)
        }
      }
    },
    // 初始化查询所有数据
    async getAll(formInline) {
      const res = await tipsdistributorGetAll(formInline)
      this.tableData = res.data.list
      this.tableData.forEach((item) => {
        item.distributorPhone = hidden(item.distributorPhone, 3, 3)
      })
      this.total = res.data.total
    },
    checkState(row, index) {
      if (row && row.state === 0) {
        return 1
      }
      return 0
    }
  }
}
</script>

<style lang='scss' scoped>
@import url("../../../styles/elDialog.scss");
.custom_page {
  padding: 20px;
}
.checkBoxStyle {
  margin-bottom: 20px;
}
.tablefoot {
  padding: 5px 10px;
  border: 1px solid #dfe6ec;
  border-top: 0;
}
</style>

