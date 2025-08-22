<template>
  <div class="operate padding">
    <div class="formSearch">
      <el-form :inline="true" :model="formInline" class="demo-form-inline">
        <el-form-item label="计划名称">
          <el-input v-model="formInline.operateName" maxlength="20" />
        </el-form-item>
        <el-form-item label="运营人群">
          <el-input v-model="formInline.crowdName" maxlength="20" />
        </el-form-item>
        <el-form-item label="计划方式">
          <el-select v-model="formInline.planMode" placeholder="请选择">
            <el-option
              v-for="item in planSelect"
              :key="item.value"
              :label="item.label"
              :value="item.value"
            />
          </el-select>
        </el-form-item>
        <el-form-item class="tagCustomer" label="计划时间">
          <div class="dateBox">
            <el-form-item>
              <el-date-picker
                v-model="formInline.dates"
                type="datetimerange"
                range-separator="至"
                start-placeholder="开始日期"
                end-placeholder="结束日期"
                value-format="yyyy-MM-dd HH:mm:ss"
              />
            </el-form-item>
          </div>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" plain @click="search">查询</el-button>
          <el-button plain @click="clearData">重置</el-button>
          <el-button plain @click="addOperate">新增</el-button>
          <el-button plain @click="delData(id = null)">删除</el-button>
        </el-form-item>
      </el-form>
    </div>
    <div class="tableBox">
      <el-table
        ref="multipleTable"
        :data="planListData"
        border
        :header-cell-style="{ background: '#EEF3FF', color: '#333333' }"
        tooltip-effect="dark"
        style="width: 100%"
        @selection-change="handleSelectionChange"
      >
        <el-table-column
          type="selection"
          width="55"
        />
        <el-table-column prop="operateName" label="计划名称" width="220" align="center" />
        <el-table-column prop="crowdName" label="运营人群" align="center" show-overflow-tooltip />
        <el-table-column label="计划方式" align="center" show-overflow-tooltip>
          <template slot-scope="scope">
            <span v-if="scope.row.planMode === 1">自动长期计划</span>
            <span v-if="scope.row.planMode === 2">手动定时计划</span>
          </template>
        </el-table-column>
        <el-table-column width="400" label="时间" align="center" how-overflow-tooltip>
          <template slot-scope="scope">
            <span v-if="scope.row.planMode === 1">{{ scope.row.planStart }} 至 {{ scope.row.planEnd }}</span>
            <span v-else>{{ scope.row.manualTime }}</span>
          </template>
        </el-table-column>
        <el-table-column label="状态" align="center" show-overflow-tooltip>
          <template slot-scope="scope">
            <span v-if="scope.row.state === 0">未开始</span>
            <span v-if="scope.row.state === 1">进行中</span>
            <span v-if="scope.row.state === 2">已结束</span>
          </template>
        </el-table-column>
        <el-table-column label="操作" show-overflow-tooltip align="center">
          <template slot-scope="scope">
            <div class="btnList">
              <el-button v-if="scope.row.state === 0" type="text" @click="edit(scope.row.shopOperateId)">编辑</el-button>
              <el-button type="text" @click="showData(scope.row.shopOperateId)">数据</el-button>
              <el-button v-if="scope.row.state === 0 || scope.row.state === 2" type="text" @click="delData(scope.row.shopOperateId)">删除</el-button>
            </div>
          </template>
        </el-table-column>
      </el-table>
      <div class="fenye">
        <el-pagination
          :current-page="shopPage"
          :page-sizes="[10, 20, 50, 100]"
          :page-size="10"
          layout="total, sizes, prev, pager, next, jumper"
          :total="planListTotal"
          @size-change="handleSizeChange"
          @current-change="handleCurrentChange"
        />
      </div>
    </div>
    <!-- 新建分组弹框 -->
    <el-dialog
      :close-on-click-modal="false"
      title="数据效果"
      :visible.sync="isDataVisible"
      width="55%"
      top="50px"
      class="group-dialog"
    >
      <!-- 表格 -->
      <div class="dataEffect">
        <!--        <h3>实时统计</h3>-->
        <div class="tableBox">
          <el-table
            ref="multipleTable"
            :data="dataInfo"
            border
            height="500"
            :header-cell-style="{ background: '#EEF3FF', color: '#333333' }"
            tooltip-effect="dark"
            style="width: 100%"
          >
            <el-table-column align="center" prop="time" label="日期" show-overflow-tooltip />
            <el-table-column align="center" prop="person" label="发券人数" show-overflow-tooltip />
            <el-table-column align="center" prop="users" label="下单人数" show-overflow-tooltip />
            <el-table-column align="center" prop="orders" label="下单笔数" show-overflow-tooltip />
            <el-table-column align="center" prop="total" label="下单金额" show-overflow-tooltip />
            <el-table-column align="center" prop="pays" label="支付人数" show-overflow-tooltip />
            <el-table-column align="center" prop="payOrders" label="支付订单数" show-overflow-tooltip />
          </el-table>
        </div>
      </div>
    </el-dialog>
    <add-operate ref="addOperate"></add-operate>
  </div>
</template>

<script>
import { getOperateList, deleteOperate, getDatasInfo } from '@/api/customer'
import AddOperate from '@/views/customer/addOperate';
export default {
  name: 'Operate',
  components: { AddOperate },
  data() {
    return {
      formInline: {
        planMode: null, // 计划方式
        dates: [], // 计划时间数组
        page: 1, // 当前页
        operateName: '', // 计划名称
        pageSize: 10, // 每页记录数
        crowdName: '', // 人群名称
        endTime: '',
        startTime: ''

      },
      dataInfo: [], // 效果数据
      planListData: [],
      planListTotal: 0,
      multipleSelection: [],
      shopTotal: 1,
      shopPage: 1,
      planSelect: [{
        value: 1,
        label: '自动长期计划'
      }, {
        value: 2,
        label: '手动定时计划'
      }],
      planValue: '',
      isDataVisible: false // 展示数据
    }
  },
  mounted() {
    this.getAll(this.formInline)
  },
  methods: {
    // 手动查询商品
    search() {
      this.getAll(this.formInline)
    },
    // 初始化查询所有数据
    async getAll(formInline) {
      const res = await getOperateList(formInline)
      this.planListTotal = res.data.total
      this.planListData = res.data.list
    },
    addOperate() {
      this.$refs.addOperate.show()
    },
    clearData() {
      this.formInline = {
        maxPrice: null, // 价格最大值
        maxStock: null, // 库存数量最大值
        minPrice: null, // 价格最小值
        minStock: null, // 库存数量最小值
        page: 1, // 当前页
        pageSize: 10, // 每页记录数
        search: '' // 搜索字段
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
    handleSelectionChange(val) {
      this.multipleSelection = val
      console.log(this.multipleSelection)
    },
    // 编辑
    edit(id) {
      this.$refs.addOperate.show(id)
    },
    showData(id) {
      getDatasInfo({ shopOperateId: id }).then(res => {
        if (res.code === '') {
          this.dataInfo = res.data
          this.isDataVisible = true
        } else {
          this.$message({
            message: res.message,
            type: 'error'
          })
        }
      })
    },
    delData(id) {
      var ids = []
      if (id) {
        ids.push(id)
      } else {
        this.multipleSelection.forEach(item => {
          ids.push(item.shopOperateId)
        })
        if (ids.length === 0) {
          this.$message({
            message: '请选择要删除的运营计划',
            type: 'warning'
          })
          return false
        }
      }
      console.log(ids, 'ids')
      deleteOperate({ ids }).then(res => {
        if (res.code === '') {
          this.$message({
            message: '删除成功',
            type: 'success'
          })
          this.formInline.page = 1
          this.getAll(this.formInline)
        } else {
          this.$message({
            message: res.message,
            type: 'error'
          })
        }
      })
    }
  }
}
</script>

<style lang="scss" scoped>
.padding {
  padding: 30px;
}
.operate {
}
</style>
<style scoped>
.fenye {
  margin-top: 30px;
}
.formSearch /deep/ .el-form {
  display: flex;
  flex-wrap: wrap;
}
.btnBox /deep/ .el-radio {
  margin-right: 8px;
}
.btnBox /deep/ .el-radio__label {
  display: none;
}
.fenye /deep/ .dialog-footer {
  margin: 30px auto 0 auto;
  display: flex;
  justify-content: center;
}
</style>
