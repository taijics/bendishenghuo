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
          <el-form-item label="起止时间">
            <el-date-picker
              v-model="formInline.dates"
              type="daterange"
              range-separator="至"
              start-placeholder="开始时间"
              end-placeholder="结束时间"
              value-format="yyyy-MM-dd"
            />
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
            <el-table-column prop="distributorName" label="分销员昵称" />
            <el-table-column prop="distributorPhone" label="分销员手机号" />
            <el-table-column label="订单数">
              <template slot-scope="scope">
                <span>{{ scope.row.orders }}</span>
                <el-button type="text" @click="detals(1,scope.row)">详情</el-button>
              </template>
            </el-table-column>
            <el-table-column label="成交金额(元)">
              <template slot-scope="scope">
                <span>{{ scope.row.dealMoney }}</span>
                <el-button type="text" @click="detals(2,scope.row)">详情</el-button>
              </template>
            </el-table-column>
            <el-table-column label="总佣金(元)">
              <template slot-scope="scope">
                <span>{{ scope.row.commissionMoney }}</span>
                <el-button type="text" @click="detals(3,scope.row)">详情</el-button>
              </template>
            </el-table-column>
            <el-table-column label="未结算佣金(元)">
              <template slot-scope="scope">
                <span>{{ scope.row.unsettledMoney }}</span>
                <el-button type="text" @click="detals(4,scope.row)">详情</el-button>
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
    <!-- *****************弹框开始***************** -->
    <!-- 详情弹框 -->
    <el-dialog :title="isVisible.text" :visible.sync="isVisible.show" width="30%">
      <div class="modelStyle">
        <div class="leftmodel">
          <div class="textTop">{{ isVisible.numberOne }}</div>
          <div class="textbot">{{ isVisible.textOne }}</div>
        </div>
        <div class="line" />
        <div class="rightmodel">
          <div class="textTops">{{ isVisible.numberTWo }}</div>
          <div class="textbot">{{ isVisible.textTwo }}</div>
        </div>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import {
  getAllAchievement,
  getOrderDetail,
  getDealMoneyDetail,
  getCommissionMoneyDetail,
  getNotCommissionMoneyDetail
} from '@/api/distributor'
import { hidden } from '@/utils';
export default {
  data() {
    return {
      formInline: {
        distributorName: '',
        distributorPhone: '',
        dates: [],
        page: 1,
        pageSize: 10
      },
      total: 1,
      tableData: [],
      currentPage: 1,
      multipleSelection: [],
      isVisible: {}
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
    // 详情
    async detals(index, row) {
      console.log(row)
      if (index === 1) {
        const res = await getOrderDetail({ distributorId: row.distributorId })
        if (res.code === '') {
          this.isVisible = {
            show: true,
            text: '订单数详情',
            textOne: '直接分销订单',
            textTwo: '间接分销订单',
            numberOne: res.data.directOrders,
            numberTWo: res.data.indirectOrders
          }
        }
      } else if (index === 2) {
        const res = await getDealMoneyDetail({ distributorId: row.distributorId })
        if (res.code === '') {
          this.isVisible = {
            show: true,
            text: '成交金额详情',
            textOne: '直接分销金额',
            textTwo: '间接分销金额',
            numberOne: res.data.directMoney ? res.data.directMoney : 0,
            numberTWo: res.data.indirectMoney ? res.data.indirectMoney : 0
          }
        }
      } else if (index === 3) {
        const res = await getCommissionMoneyDetail({
          distributorId: row.distributorId
        })
        if (res.code === '') {
          this.isVisible = {
            show: true,
            text: '总佣金详情',
            textOne: '直接佣金',
            textTwo: '间接佣金',
            numberOne: res.data.directMoney ? res.data.directMoney : 0,
            numberTWo: res.data.indirectMoney ? res.data.indirectMoney : 0
          }
        }
      } else if (index === 4) {
        const res = await getNotCommissionMoneyDetail({
          distributorId: row.distributorId
        })
        if (res.code === '') {
          this.isVisible = {
            show: true,
            text: '未结算佣金详情',
            textOne: '直接未结算佣金',
            textTwo: '间接未结算佣金',
            numberOne: res.data.directMoney ? res.data.directMoney : 0,
            numberTWo: res.data.indirectMoney ? res.data.indirectMoney : 0
          }
        }
      }
    },
    // 初始化查询所有数据
    async getAll(formInline) {
      const res = await getAllAchievement(formInline)
      this.tableData = res.data.list
      this.tableData.forEach((item) => {
        item.distributorPhone = hidden(item.distributorPhone, 3, 3)
      })
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
.modelStyle {
  display: flex;
  align-items: center;
  justify-content: space-around;
  height: 170px;
  .leftmodel {
    text-align: center;
    .textTop {
      color: #3a68f2;
      font-size: 48px;
      margin-bottom: 20px;
    }
    .textbot {
      color: #333333;
      font-size: 24px;
    }
  }
  .line {
    width: 2px;
    height: 60px;
    background: #e0e5eb;
  }
  .rightmodel {
    text-align: center;
    .textTops {
      color: #06c6cd;
      font-size: 48px;
      margin-bottom: 20px;
    }
    .textbot {
      color: #333333;
      font-size: 24px;
    }
  }
}
</style>

