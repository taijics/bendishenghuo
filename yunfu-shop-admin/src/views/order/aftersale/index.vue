<!--  -->
<template>
  <div class="pending">
    <div class="tab_show">
      <el-tabs v-model="formInline.type" @tab-click="handleClick">
        <el-tab-pane label="全部" :name="null" />
        <el-tab-pane label="待商家处理" name="1" />
        <el-tab-pane label="待商家收货" name="2" />
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
                  <el-option label="售后id" value="1" />
                  <el-option label="买家账户" value="2" />
                  <el-option label="收件人姓名" value="3" />
                  <el-option label="收件人手机号" value="4" />
                  <el-option label="商品ID" value="5" />
                </el-select>
              </el-input>
            </div>
          </el-form-item>
          <el-form-item label="订单状态">
            <el-select v-model="formInline.state" placeholder="请选择订单状态">
              <el-option label="全部" :value="null" />
              <el-option label="待付款" value="1" />
              <el-option label="待发货" value="2" />
              <el-option label="已发货" value="3" />
              <el-option label="已完成" value="4" />
              <el-option label="已关闭" value="5" />
            </el-select>
          </el-form-item>
          <el-form-item label="售后状态">
            <el-select v-model="formInline.afterState" placeholder="请选择售后状态">
              <el-option label="全部" :value="null" />
              <!-- <el-option label="无售后" value="0" /> -->
              <el-option label="售后中" value="1" />
              <el-option label="售后成功" value="2" />
              <el-option label="售后关闭" value="3" />
            </el-select>
          </el-form-item>
          <el-form-item label="售后类型">
            <el-select v-model="formInline.afterType" placeholder="请选择售后类型">
              <el-option label="全部" :value="null" />
              <el-option label="仅退款" value="1" />
              <el-option label="退货退款" value="2" />
            </el-select>
          </el-form-item>
          <el-form-item>
            <el-button type="primary" plain @click="search">查询</el-button>
            <el-button type="success" plain @click="afterOrderDataExport">导出订单</el-button>
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
          <el-table-column label="售后id" width="220">
            <template slot-scope="scope">{{ scope.row.afterId }}</template>
          </el-table-column>
          <el-table-column prop="afterFormid" label="售后单号" width="220" />
          <el-table-column prop="afterId" label="售后类型" show-overflow-tooltip>
            <template slot-scope="scope">
              <span v-if="scope.row.afterType == 1">仅退款</span>
              <span v-if="scope.row.afterType == 2">退货退款</span>
            </template>
          </el-table-column>
          <el-table-column prop="price" label="退款金额(元)" show-overflow-tooltip />
          <el-table-column prop="afterStateName" label="售后状态" show-overflow-tooltip />
          <el-table-column prop="createTime" label="申请时间" show-overflow-tooltip />
          <el-table-column label="操作" show-overflow-tooltip>
            <template slot-scope="scope">
              <div class="btnList">
                <el-button type="text" @click="view(scope.row)">{{ scope.row.afterState == 1 ? '处理' : '查看' }}</el-button>
              </div>
            </template>
          </el-table-column>
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
    <after-details ref="afterDetails" />
  </div>
</template>

<script>
// 这里可以导入其他文件（比如：组件，工具js，第三方插件js，json文件，图片文件等等）
// 例如：import 《组件名称》 from '《组件路径》';
import { aftersaleGetAll, afterOrderExport } from '@/api/order'
import AfterDetails from './afterDetails';
import { type } from 'os';
export default {
  components: { AfterDetails },
  data() {
    // 这里存放数据
    return {
      loading: false,
      activeName: 'first',
      total: 1,
      tableData: [],
      currentPage: 1,
      formInline: {
        searchType: '1', // 搜索类型  1-订单ID 2-买家账户 3-收件人姓名 4-收件人手机号 5-商品ID
        search: '', // 搜索字段
        state: '', // 订单状态 1-待付款 2-待发货 3-已发货 4-已完成 5-已关闭
        afterState: '', // 售后状态 0-无售后 1-售后中 2-售后成功 3-售后关闭
        afterType: '', // 售后类型  1-仅退款  2-退货退款
        type: null, // 列表类型 1-待商家处理 2-待商家收货
        page: 1,
        pageSize: 10
      },

      multipleSelection: []
    }
  },
  // 监听属性 类似于data概念
  computed: {},
  // 监控data中的数据变化
  watch: {},
  // 生命周期 - 创建完成（可以访问当前this实例）
  created() {},
  // 生命周期 - 挂载完成（可以访问DOM元素）
  mounted() {
    this.getAll(this.formInline)
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
      this.formInline.type = tab.name
      this.getAll(this.formInline)
    },
    //  查询
    search() {
      this.total = 1
      this.formInline.page = 1
      this.getAll(this.formInline)
    },
    // 处理
    view(row) {
      this.$refs.afterDetails.show(row.afterId)
    },
    // 初始化查询所有数据
    async getAll(formInline) {
      this.loading = true
      try {
        const res = await aftersaleGetAll(formInline)
        this.total = res.data.total
        this.tableData = res.data.list
      } finally {
        this.loading = false
      }
    },
    // 导出订单
    async afterOrderDataExport() {
      this.$message({
        message: '数据导出中，请勿重复操作！',
        type: 'success'
      })
      console.log(this.formInline, 'this.formInline')
      const res = await afterOrderExport(this.formInline)
      if (!res) {
        return
      }
      const blob = new Blob([res], { type: 'application/vnd.ms-excel' }) // 把得到的结果用流对象转一下
      const fileName = '售后订单数据明细表.xls'
      if ('download' in document.createElement('a')) {
        // 非IE下载
        const elink = document.createElement('a')
        elink.download = fileName
        elink.href = URL.createObjectURL(blob) // 将流文件写入a标签的href属性值
        elink.style.display = 'none' // 障眼法藏起来a标签
        document.body.appendChild(elink) // 将a标签追加到文档对象中
        elink.click() // 模拟点击了a标签，会触发a标签的href的读取，浏览器就会自动下载了
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
