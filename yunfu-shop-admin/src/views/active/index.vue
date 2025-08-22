<!--  -->
<template>
  <div class="commonActivityPage">
    <div class="acTab">
      <el-tabs v-model="activeName" @tab-click="handleClick">
        <el-tab-pane label="全部" name="1" />
        <el-tab-pane label="我参与的" name="2" />
      </el-tabs>
      <el-radio-group v-model="formInline.signType" @change="signTypeChange">
        <el-radio-button :label="1">平台优惠券</el-radio-button>
        <el-radio-button :label="2">平台秒杀</el-radio-button>
        <el-radio-button :label="3">平台限时折扣</el-radio-button>
      </el-radio-group>
    </div>
    <!-- 搜索 -->
    <FixedNav
      class="formSearch"
      :height="260"
    >
      <div class="searchItem">
        <span>活动名称：</span>
        <el-input v-model="formInline.activityName" maxlength="15" placeholder="请输入活动名称" />
      </div>
      <div class="searchItem">
        <span>活动状态：</span>
        <el-select v-model="formInline.state" placeholder="请选择活动状态" clearable>
          <el-option label="报名未开始" value="0" />
          <el-option label="报名进行中" value="1" />
          <el-option label="活动待开始" value="2" />
          <el-option label="活动进行中" value="3" />
          <el-option label="活动已结束" value="4" />
        </el-select>
      </div>
      <div class="searchItem">
        <span>审核状态：</span>
        <el-select v-model="formInline.examineState" placeholder="请选择审核状态" clearable>
          <el-option label="待审核" value="0" />
          <el-option label="报名成功" value="1" />
          <el-option label="报名失败" value="2" />
        </el-select>
      </div>
      <el-button type="primary" plain @click="search">查询</el-button>
      <el-button plain @click="clear">重置</el-button>
    </FixedNav>
    <!-- 表格 -->
    <div class="tableBox">
      <el-table
        ref="multipleTable"
        :data="tableData"
        border
        :header-cell-style="{ background: '#EEF3FF', color: '#333333' }"
        tooltip-effect="dark"
        style="width: 100%"
      >
        <el-table-column prop="activityName" label="活动名称" show-overflow-tooltip />
        <el-table-column prop="bondMoney" label="活动保证金" show-overflow-tooltip />
        <el-table-column prop="signTime" label="报名时间" width="170" />
        <el-table-column prop="activityTime" label="活动时间" width="170" />
        <el-table-column label="活动优惠" show-overflow-tooltip>
          <template slot-scope="scope">
            <div v-if="scope.row.discountProgramme == 1">满减</div>
            <div v-if="scope.row.discountProgramme == 2">优惠券</div>
            <div>{{ scope.row.details }}</div>
          </template>
        </el-table-column>
        <el-table-column prop="activityIntroduce" label="活动简介" show-overflow-tooltip />
        <el-table-column label="活动状态" show-overflow-tooltip>
          <template slot-scope="scope">
            <span v-if="scope.row.state == 0">报名未开始</span>
            <span v-if="scope.row.state == 1">报名进行中</span>
            <span v-if="scope.row.state == 2">活动待开始</span>
            <span v-if="scope.row.state == 3">活动进行中</span>
            <span v-if="scope.row.state == 4">活动已结束</span>
          </template>
        </el-table-column>
        <el-table-column label="报名状态" show-overflow-tooltip>
          <template slot-scope="scope">
            <span v-if="scope.row.signState == 0">待审核</span>
            <span v-if="scope.row.signState == 1">报名成功</span>
            <span v-if="scope.row.signState == 2">报名失败</span>
            <span v-if="scope.row.signState == null">未报名</span>
          </template>
        </el-table-column>
        <el-table-column label="操作" fixed="right" show-overflow-tooltip width="220">
          <template slot-scope="scope">
            <div class="btnList">
              <el-button
                v-if="scope.row.operation === 1"
                type="primary"
                @click="getTotal(scope.row,1)"
              >立即报名</el-button>
              <el-button
                v-if="scope.row.operation === 2"
                type="primary"
                disabled
                @click="getTotal(scope.row,1)"
              >立即报名</el-button>
              <el-button
                v-if="scope.row.operation === 4"
                type="primary"
                @click="getTotal(scope.row,1)"
              >重新报名</el-button>
              <el-button
                v-if="scope.row.operation === 5"
                type="primary"
                @click="getTotal(scope.row,1)"
              >继续报名</el-button>
              <el-button v-if="scope.row.operation === 3" @click="goActiveData(scope.row)">活动数据</el-button>
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

    <el-dialog
      title="活动报名"
      :visible.sync="signVisible"
      width="80%"
      center
      :close-on-click-modal="false"
      @close="closeDialog"
    >
      <SignActivity
        ref="signActivity"
        :form="form"
        @cancel="goList"
      />
    </el-dialog>

    <el-dialog
      title="活动报名"
      :visible.sync="detailVisible"
      width="80%"
      center
      :close-on-click-modal="false"
    >
      <DataActivity
        :form="form"
        @cancel="detailVisible = false"
      />
    </el-dialog>
  </div>
</template>

<script>
import FixedNav from '@/components/FixedNav/index.vue'
import SignActivity from '@/views/active/getActive.vue'
import DataActivity from '@/views/active/activeData.vue'

import { activityGetAll } from '@/api/active'
export default {
  components: {
    FixedNav,
    SignActivity,
    DataActivity
  },
  data() {
    return {
      activeName: '1',
      formInline: {
        type: 1, // 查询类型 1-全部 2-我参与的
        activityName: '', // 活动名称
        state: '',
        examineState: '',
        page: 1,
        pageSize: 10,
        signType: 1
      },
      total: 1,
      tableData: [],
      signVisible: false,
      form: {},
      detailVisible: false,
      active: 1
    }
  },
  mounted() {
    this.getAll(this.formInline)
  },
  methods: {
    closeDialog() {
      console.log(this.$refs.signActivity, 'this.$refs.signActivity')
      this.$refs.signActivity.reset()
    },
    goList() {
      console.log('122121212')
      this.signVisible = false
      this.getAll(this.formInline)
    },
    //
    signTypeChange() {
      this.getAll(this.formInline)
    },
    handleSizeChange(val) {
      this.formInline.pageSize = val
      this.getAll(this.formInline)
    },
    handleCurrentChange(val) {
      this.formInline.page = val
      this.getAll(this.formInline)
    },
    // 活动切换
    handleClick(tab, event) {
      this.formInline.type = parseInt(tab.name)
      if (tab.name === '2') {
        this.getAll(this.formInline)
      } else {
        this.getAll(this.formInline)
      }
    },
    // 查询
    search() {
      this.total = 1
      this.formInline.page = 1
      this.getAll(this.formInline)
    },
    // 清除
    clear() {
      this.activeName = '1'
      this.formInline = {
        activityName: '', // 活动名称
        state: '',
        examineState: '',
        page: 1,
        pageSize: 10
      }
      this.getAll(this.formInline)
    },
    // 立即报名
    getTotal(row, index) {
      this.active = 1
      this.signVisible = true
      this.form = {
        activityId: row.activityId,
        bondMoney: row.bondMoney,
        type: index,
        ifBond: row.ifBond,
        signType: row.signType
      }
    },
    // 活动数据
    goActiveData(row) {
      this.form = {
        activityName: row.activityName,
        activityId: row.activityId,
        signId: row.signId
      }
      this.detailVisible = true
    },
    // 初始化查询所有数据
    async getAll(formInline) {
      const res = await activityGetAll(formInline)
      this.tableData = res.data.list
      this.total = res.data.total
    },
    // 查看
    seeMore() {},
    // 编辑
    edit() {},
    // 删除
    del() {}
  }
}
</script>
<style lang='scss' scoped>
//@import url(); 引入公共css类
@import url("../../styles/elDialog.scss");
.commonActivityPage{
  // padding: 20px;
  $bothSides: 20px;
  .acTab{
    margin: 0 $bothSides;
  }
  .formSearch{
    padding: 12px $bothSides;
    display: flex;
    .searchItem{
      margin-right: 20px;
      display: flex;
      line-height: 40px;
      span{
        min-width: 80px;
      }
    }
  }
  .tableBox{
    margin: 10px $bothSides;
  }
}
</style>
