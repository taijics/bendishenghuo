<template>
  <div class="pending">
    <div class="tab_show">
      <el-tabs v-model="formInline.state" @tab-click="handleClick">
        <el-tab-pane label="全部" :name="''" />
        <el-tab-pane label="待付款" name="1" />
        <el-tab-pane label="待发货" name="2" />
        <el-tab-pane label="已发货" name="3" />
        <el-tab-pane label="已完成" name="4" />
        <el-tab-pane label="已关闭" name="5" />
      </el-tabs>
      <!-- 搜索 -->
      <div class="formSearch">
        <el-form :inline="true" :model="formInline" class="demo-form-inline">
          <el-form-item>
            <div>
              <el-input v-model="formInline.search" maxlength="20" placeholder="请输入内容">
                <el-select
                  slot="prepend"
                  v-model="formInline.searchType"
                  style="width:130px"
                  placeholder="请选择"
                >
                  <el-option label="订单id" value="1" />
                  <el-option label="买家账户" value="2" />
                  <el-option label="收件人姓名" value="3" />
                  <el-option label="收件人手机号" value="4" />
                  <!-- <el-option label="商品ID" value="5" /> -->
                </el-select>
              </el-input>
            </div>
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
            <el-button type="primary" plain @click="search">查询</el-button>
            <el-button type="success" plain @click="orderDataExport">导出订单</el-button>

          </el-form-item>
        </el-form>
      </div>
      <!-- 表格 -->
      <div class="tableBox">
        <el-table
          ref="multipleTable"
          v-loading="loading"
          :data="tableData"
          border
          :header-cell-style="{ background: '#EEF3FF', color: '#333333' }"
          tooltip-effect="dark"
          style="width: 100%"
        >
          <el-table-column label="订单id" width="220">
            <template slot-scope="scope">{{ scope.row.orderId }}</template>
          </el-table-column>
          <el-table-column prop="price" label="支付金额（元）" width="220" />
          <el-table-column prop="number" label="商品数量（件）" show-overflow-tooltip />
          <el-table-column label="订单状态" show-overflow-tooltip>
            <template slot-scope="scope">
              <span v-if="scope.row.state == 1">待付款</span>
              <span v-if="scope.row.state == 2">待发货</span>
              <span v-if="scope.row.state == 3">已发货</span>
              <span v-if="scope.row.state == 4">已完成</span>
              <span v-if="scope.row.state == 5">已关闭</span>
              <span v-if="scope.row.state == 6">待成团</span>
            </template>
          </el-table-column>
          <el-table-column prop="customerName" label="下单账户" show-overflow-tooltip />
          <el-table-column prop="createTime" label="下单时间" show-overflow-tooltip />
          <el-table-column label="操作" show-overflow-tooltip>
            <template slot-scope="scope">
              <div class="btnList">
                <el-button v-if="scope.row.state === 1" type="text" @click="changePrice(scope.row)">改价</el-button>
                <el-button v-if="scope.row.state == 2" type="text" @click="view(scope.row)">发货</el-button>
                <el-button v-else type="text" @click="view(scope.row)">查看</el-button>
              </div>
            </template>
          </el-table-column>
        </el-table>
        <div class="fenye">
          <el-pagination
            :current-page="formInline.page"
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
    <pend-details ref="pendDetails" />
    <ChangePrice ref="changePrice" @success="getAll(formInline)" />
  </div>
</template>

<script>
import { orderGetAll, orderExport } from '@/api/order'
import PendDetails from './pendDetails';
import ChangePrice from './components/changePrice.vue'
export default {
  components: {
    PendDetails,
    ChangePrice
  },
  data() {
    // 这里存放数据
    return {
      loading: false,
      activeName: 'first',
      formInline: {
        searchType: '1',
        search: '', // 搜索字段
        state: '',
        afterState: '', // 售后状态 0-无售后 1-售后中 2-售后成功 3-售后关闭
        dates: [], // 下单时间数组
        page: 1,
        pageSize: 10
      },
      total: 1,
      tableData: [],
      currentPage: 1
    }
  },
  mounted() {
    this.getAll(this.formInline)
    this.handleClick({ name: '' })
  },
  // 方法集合
  methods: {
    handleSizeChange(val) {
      this.formInline.pageSize = val
      this.getAll(this.formInline)
    },
    handleCurrentChange(val) {
      this.formInline.page = val
      this.getAll(this.formInline)
    },
    handleClick(tab, event) {
      console.log(tab)
      this.formInline.page = 1
      this.formInline.state = tab.name
      this.getAll(this.formInline)
    },
    //  查询
    search() {
      this.total = 1
      this.formInline.page = 1
      this.getAll(this.formInline)
    },
    view(row) {
      this.$refs.pendDetails.show(row.orderId)
    },
    changePrice(row) {
      this.$refs.changePrice.show(row)
    },
    // 初始化查询所有数据
    async getAll(formInline) {
      try {
        this.loading = true
        console.log(formInline, 'formInline')
        const res = await orderGetAll(formInline)
        console.log(res, '初始化')
        this.total = res.data.total
        this.tableData = res.data.list
      } finally {
        this.loading = false
      }
    },
    // 导出订单
    async orderDataExport() {
      this.$message({
        message: '数据导出中，请勿重复操作！',
        type: 'success'
      })
      console.log(this.formInline, 'this.formInline')
      const res = await orderExport(this.formInline)
      if (!res) {
        return
      }
      const blob = new Blob([res], { type: 'application/vnd.ms-excel' })
      const fileName = '订单数据明细表.xls'
      if ('download' in document.createElement('a')) {
        // 非IE下载
        const elink = document.createElement('a')
        elink.download = fileName
        elink.href = URL.createObjectURL(blob)
        elink.style.display = 'none'
        document.body.appendChild(elink)
        elink.click()
        URL.revokeObjectURL(elink.href) // 释放URL 对象
        document.body.removeChild(elink)
      } else {
        // IE10+下载
        navigator.msSaveBlob(blob, fileName)
      }
    },

  }
}
</script>
<style lang='scss' scoped>
//@import url(); 引入公共css类
@import url("../../../styles/elDialog.scss");
.tab_show {
  padding-left: 30px;
}
</style>
