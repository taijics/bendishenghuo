<template>
  <div class="pending">
    <div class="formSearch">
      <el-form :inline="true" :model="formInline" class="demo-form-inline">
        <el-form-item label="活动名称">
          <el-input v-model="formInline.seckillName" maxlength="15" placeholder="请输入内容" />
        </el-form-item>
        <el-form-item label="状态">
          <el-select v-model="formInline.state" placeholder="请选择状态">
            <el-option label="全部" :value="null" />
            <el-option label="未开始" value="0" />
            <el-option label="进行中" value="1" />
            <el-option label="已结束" value="2" />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" plain @click="search">查询</el-button>
          <el-button type="primary" plain @click="clear">重置</el-button>
          <el-button type="primary" plain @click="addActivity">新增</el-button>
        </el-form-item>
      </el-form>
    </div>
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
        <el-table-column label="活动名称" width="220">
          <template slot-scope="scope">{{ scope.row.seckillName }}</template>
        </el-table-column>
        <el-table-column label="状态" show-overflow-tooltip>
          <template slot-scope="scope">
            <span v-if="scope.row.state === 0">未开始</span>
            <span v-if="scope.row.state === 1">进行中</span>
            <span v-if="scope.row.state === 2">已结束</span>
          </template>
        </el-table-column>
        <el-table-column prop="content" label="活动内容" show-overflow-tooltip />
        <el-table-column prop="effectiveStart" label="活动开始时间" show-overflow-tooltip />
        <el-table-column prop="effectiveEnd" label="活动结束时间" show-overflow-tooltip />
        <el-table-column label="操作" show-overflow-tooltip>
          <template slot-scope="scope">
            <div class="btnList">
              <el-button v-if="scope.row.state === 0" type="text" @click="editActivity(scope.row.shopSeckillId)">编辑</el-button>
              <el-button v-if="scope.row.state !== 0" type="text" @click="visitActivity(scope.row.shopSeckillId)">详情</el-button>
              <el-button v-if="scope.row.state !== 0" type="text" @click="showData(scope.row)">数据</el-button>
              <el-popconfirm v-if="scope.row.state === 0 || scope.row.state === 2" title="确定删除此活动？" @onConfirm="deleteSeckillFn(scope.row)">
                <el-button slot="reference" class="delCls" type="text">删除</el-button>
              </el-popconfirm>
              <el-popconfirm v-if="scope.row.state === 1" title="确定停止此活动？" @onConfirm="stopFn(scope.row.shopSeckillId)">
                <el-button slot="reference" class="delCls" type="text">停止</el-button>
              </el-popconfirm>
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

    <!-- 新增活动 -->
    <el-dialog
      :title="activityId ? (visitDetail ? '查看秒杀活动' : '修改秒杀活动') : '新增秒杀活动'"
      :visible.sync="activityVisible"
      width="700px"
      center
      top="10vh"
      :close-on-click-modal="false"
      @close="colseModal"
    >
      <AddSpike
        ref="AddSpikeData"
        :spike-id="activityId"
        :visit-detail="visitDetail"
        @reset="reset"
      />
    </el-dialog>
    <!-- 数据效果（秒杀） -->
    <el-dialog
      :close-on-click-modal="false"
      title="数据效果（秒杀）"
      :visible.sync="isDataVisible"
      width="55%"
      top="50px"
      class="group-dialog"
    >
      <!-- 表格 -->
      <div class="dataEffect">
        <h3>实时统计</h3>
        <div class="couponTit">活动名称：{{ dataInfo.seckillName }}</div>
        <div class="dataListBox">
          <div class="dataItem">
            <span>{{ dataInfo.visit }}</span>
            <p>浏览量</p>
          </div>
          <div class="dataItem">
            <span>{{ dataInfo.pays }}</span>
            <p>支付买家数</p>
          </div>
          <div class="dataItem">
            <span>{{ dataInfo.conversion }}</span>
            <p>支付转化率</p>
          </div>
          <div class="dataItem">
            <span>￥{{ dataInfo.total }}</span>
            <p>活动成交金额</p>
          </div>
        </div>
        <div class="tabListInfo">活动成交的商品</div>
        <div class="tableBox">
          <el-table
            ref="multipleTable"
            :data="dataInfo.products"
            border
            height="150"
            :header-cell-style="{ background: '#EEF3FF', color: '#333333' }"
            tooltip-effect="dark"
            style="width: 100%"
          >
            <el-table-column prop="productName" label="商品名称" show-overflow-tooltip />
            <el-table-column prop="number" label="付款件数" show-overflow-tooltip />
            <el-table-column prop="users" label="付款人数" show-overflow-tooltip />
          </el-table>
          <div class="pagination">
            <el-pagination
              :current-page="activeDataParams.page"
              :page-sizes="[10, 20, 50, 100]"
              :page-size="10"
              layout="total, sizes, prev, pager, next, jumper"
              :total="activeDataTotal"
              @size-change="activeDataSizeChange"
              @current-change="activeDataCurrentChange"
            />
          </div>
        </div>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import AddSpike from '@/views/marketing/spike/add.vue'

import { getSeckillList, deleteSeckill, seckillStop, getSeckillData } from '@/api/marketing'
import activityMixin from '@/views/marketing/mixin/index.js'
export default {
  name: 'Coupon',
  components: {
    AddSpike
  },
  mixins: [activityMixin],
  data() {
    return {
      formInline: {
        seckillName: '', // 秒杀名称
        page: 1, // 当前页
        pageSize: 10, // 每页记录数
        state: null // 秒杀状态
      },
      isDataVisible: false, // 数据效果展示
      total: 1,
      tableData: [],
      currentPage: 1,
      dataInfo: [], // 数据详情
      activeDataParams: {
        shopSeckillId: '', // 活动id
        page: 1, // 当前页
        pageSize: 10 // 每页记录数
      },
      activeDataTotal: 0,
    }
  },
  mounted() {
    this.getAll(this.formInline)
  },
  methods: {
    colseModal() {
      this.$refs.AddSpikeData.resetData()
    },
    //  查询
    search() {
      this.total = 1
      this.formInline.page = 1
      this.getAll(this.formInline)
    },
    // 清除
    clear() {
      this.formInline = {
        couponName: '', // 秒杀名称
        couponType: null, // 秒杀类型
        dates: [], // 创建时间数组
        endTime: '', // 创建时间结束时间
        page: 1, // 当前页
        pageSize: 10, // 每页记录数
        startTime: '', // 创建时间开始时间
        state: null // 秒杀状态
      }
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
    // 停止秒杀活动
    stopFn(id) {
      seckillStop({ shopSeckillId: id }).then(res => {
        if (res.code === '') {
          this.$message.success('停止成功')
          this.formInline.page = 1
          this.getAll(this.formInline)
        } else {
          this.$message.error(res.message)
        }
      })
    },
    // 初始化查询所有数据
    async getAll(formInline) {
      const res = await getSeckillList(formInline)
      this.total = res.data.total
      this.tableData = res.data.list
    },
    // 删除秒杀
    deleteSeckillFn(data) {
      deleteSeckill({ shopSeckillId: data.shopSeckillId }).then(res => {
        if (res.code === '') {
          this.$message.success('删除成功')
          this.formInline.page = 1
          this.getAll(this.formInline)
        } else {
          this.$message.error(res.message)
        }
      })
    },
    // 显示数据效果
    showData(row) {
      this.getActiveData(row.shopSeckillId)
      this.isDataVisible = true
    },
    // 获取活动数据
    getActiveData(id) {
      if (id) {
        this.activeDataParams.shopSeckillId = id
      }
      getSeckillData(this.activeDataParams).then(res => {
        if (res.code === '') {
          this.dataInfo = res.data
        } else {
          this.$message.error(res.message)
        }
      })
    },
    activeDataSizeChange(val) {
      this.activeDataParams.pageSize = val
      this.getActiveData()
    },
    activeDataCurrentChange(val) {
      this.activeDataParams.page = val
      this.getActiveData()
    }
  }
}
</script>

<style lang='scss' scoped>
//@import url(); 引入公共css类
@import url("../../../styles/elDialog.scss");

.pending {
  padding: 30px;
}
.fenye {
  margin-top: 20px;
}
.dataEffect {
  .couponTit {
    margin: 20px 0;
  }
  .dataListBox {
    display: flex;
    justify-content: center;
    margin: 30px 0;
    .dataItem {
      width: 220px;
      height: 120px;
      border-radius: 8px;
      border: 1px solid #999999;
      text-align: center;
      margin: 0 10px;
      span {
        display: block;
        margin-top: 35px;
      }
    }
  }
  .tabListInfo {
    margin: 20px 0;
  }
}
.pagination{
  padding-top: 20px;
}
</style>
<style scoped>
.btnList /deep/ .delCls {
  margin-left: 10px;
}
.group-dialog /deep/ .el-dialog__headerbtn .el-dialog__close {
  color: #FFFFFF;
}
</style>
