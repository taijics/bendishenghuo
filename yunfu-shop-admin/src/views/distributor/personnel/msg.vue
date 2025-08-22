<template>
  <div class="custom_page">
    <div class="content">
      <!-- 顶部搜索 -->
      <div class="toolbar">
        <!-- 顶部搜索 -->
        <el-form :inline="true" :model="formInline">
          <el-form-item label="分销员昵称">
            <el-input v-model="formInline.distributorName" maxlength="20" placeholder="请输入分销员昵称" />
          </el-form-item>
          <el-form-item label="分销员手机号">
            <el-input v-model="formInline.distributorPhone" maxlength="11" placeholder="请输入手机号" />
          </el-form-item>
          <el-form-item label="申请时间">
            <el-date-picker
              v-model="formInline.dates"
              type="daterange"
              range-separator="至"
              start-placeholder="开始时间"
              end-placeholder="结束时间"
              value-format="yyyy-MM-dd"
            />
          </el-form-item>
          <el-form-item label="审核状态">
            <el-select v-model="formInline.state" placeholder="请选择审核状态">
              <el-option label="全部" :value="null" />
              <el-option label="待处理" :value="0" />
              <el-option label="审核通过" :value="1" />
              <el-option label="审核不通过" :value="2" />
            </el-select>
          </el-form-item>
          <el-form-item>
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
          >
            >
            <el-table-column prop="distributorName" label="分销员昵称" />
            <el-table-column prop="distributorPhone" label="分销员手机号" />
            <el-table-column prop="inviteesName" label="邀请人" />
            <el-table-column prop="orderTotal" label="累计下单数" />
            <el-table-column prop="orderMoney" label="累计消费金额" />
            <el-table-column label="审核状态">
              <template slot-scope="scope">
                <span v-if="scope.row.state == 0">待处理</span>
                <span v-if="scope.row.state == 1">审核通过</span>
                <span v-if="scope.row.state == 2">审核不通过</span>
              </template>
            </el-table-column>
            <el-table-column prop="money" label="审核时间" />
            <el-table-column label="操作" show-overflow-tooltip>
              <template slot-scope="scope">
                <div class="btnList">
                  <el-button type="text" @click="del(scope.row)">处理</el-button>
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
    </div>

    <!-- 清退弹框 -->
    <el-dialog
      :visible.sync="isVisible.show"
      :title="isVisible.title"
      center
      :close-on-click-modal="false"
      width="30%"
    >
      <div style="text-align: center;">
        <div class="unbindimg">
          <img src="../../../assets/images/tixing.png" alt srcset>
        </div>
        <div class="dialog_content">请确认好分销员得信息再进行操作</div>
      </div>
      <span slot="footer" class="dialog-footer">
        <el-button @click="agreeEn(2)">审核不通过</el-button>
        <el-button type="primary" @click="agreeEn(1)">审核通过</el-button>
      </span>
    </el-dialog>
  </div>
</template>

<script>
import { getStayExamineAll, handle } from '@/api/distributor'
export default {
  data() {
    return {
      formInline: {
        distributorName: '',
        distributorPhone: '',
        dates: [],
        state: 0,
        page: 1,
        pageSize: 10
      },
      isVisible: {},
      total: 1,
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
    // 查询
    search() {
      this.total = 1
      this.formInline.page = 1
      this.getAll(this.formInline)
    },
    async agreeEn(index) {
      if (index === 1) {
        const res = await handle({
          distributorId: this.isVisible.distributorId,
          state: 1
        })
        if (res.code === '') {
          this.$message.success('成功')
          this.getAll(this.formInline)
          this.isVisible.show = false
        }
      } else if (index === 2) {
        const res = await handle({
          distributorId: this.isVisible.distributorId,
          state: 2
        })
        if (res.code === '') {
          this.$message.success('成功')
          this.getAll(this.formInline)
          this.isVisible.show = false
        }
      }
    },
    // 清退
    del(row) {
      this.isVisible = {
        show: true,
        title: '清退',
        index: 3,
        distributorId: row.distributorId
      }
    },
    // 清除
    clear() {
      this.formInline = {
        distributorName: '',
        distributorPhone: '',
        dates: [],
        state: 0,
        page: 1,
        pageSize: 10
      }
      this.getAll(this.formInline)
    },
    // 初始化查询所有数据
    async getAll(formInline) {
      const res = await getStayExamineAll(formInline)
      this.tableData = res.data.list
      this.total = res.data.total
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
.dialog_content {
  width: 275px;
  height: 46px;
  margin: auto;
  font-size: 16px;
  font-family: PingFang SC;
  font-weight: 400;
  color: #333333;
  line-height: 30px;
  margin-top: 25px;
}
</style>

