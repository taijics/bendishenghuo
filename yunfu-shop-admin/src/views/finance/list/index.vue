<template>
  <div class="finance_page">
    <!-- 顶部卡片 -->
    <div class="topCard">
      <el-card class="topCard">
        <div slot="header" class="clearfix">
          <span class="leftText">财务数据</span>
          <span class="leftTip">所有交易成功的金额，微信侧将收取6‰的交易手续费</span>
          <el-button class="rightBtn" type="primary" @click="getMoney">提现</el-button>
        </div>
        <div class="cardLIst">
          <div v-for="(item, index) in cardList" :key="index" class="cardItem">
            <div class="cardDetal">
              <div class="cardMoney">{{ item.money }}</div>
              <div class="cardText">
                <span>{{ item.name }}</span>
                <img src="@/assets/images/shuoming.png">
              </div>
            </div>
          </div>
        </div>
      </el-card>
    </div>
    <!-- 选项卡 -->
    <div class="cardList">
      <div class="rightSearch">
        <el-date-picker
          v-model="formInline.time"
          type="month"
          placeholder="选择日期"
          value-format="yyyy-MM"
          @change="changeDate"
        />
      </div>
      <el-tabs v-model="formInline.condition" @tab-click="handleClick">
        <el-tab-pane label="日汇款" name="1" />
        <el-tab-pane label="月汇款" name="2" />
      </el-tabs>
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
          <el-table-column label="日期" width="220">
            <template slot-scope="scope">{{ scope.row.time }}</template>
          </el-table-column>
          <el-table-column prop="income" label="收入（元）" width="220" />
          <el-table-column prop="expenditure" label="支出（元）" show-overflow-tooltip />
          <el-table-column label="操作" show-overflow-tooltip>
            <template slot-scope="scope">
              <div class="btnList">
                <el-button type="text" @click="seeMore(scope.row)">查看</el-button>
              </div>
            </template>
          </el-table-column>
        </el-table>
      </div>
    </div>
    <!-- *****************弹框开始***************** -->
    <el-dialog title="提现" :visible.sync="isVisible" width="30%">
      <el-form v-if="show" ref="form" :model="form" label-width="120px" size="small" :rules="rules">
        <p class="text_tip">
          <span>提现至:</span>
          <span v-if="Number(privacyTime)===0">{{ hidden(getDetails.bankCard,3,4) }}</span>
          <span v-else>{{ getDetails.bankCard }}</span>
          <span style="margin-left: 40px;">{{ getDetails.bankName }}</span>
        </p>
        <el-form-item label="提现金额" prop="amount">
          <el-col :span="16">
            <el-input v-model="form.amount" maxlength="9" :placeholder="'可提现金额:' + cardList[2].money" />
          </el-col>
          <el-col :span="6" style="text-align:center">
            <span class="sub_text" @click="getAllAmount">全部提现</span>
          </el-col>
        </el-form-item>
      </el-form>
      <p v-else class="tips">您的账户尚未绑定银行卡，无法提现</p>
      <p slot="footer" class="dialog-footer">
        <el-button type="primary" @click="confirm()">确定</el-button>
        <el-button @click="isVisible = false">取消</el-button>
      </p>
    </el-dialog>

    <el-dialog title="账单详情" :visible.sync="moneydio" width="80%">
      <div class="content">
        <!-- 顶部搜索 -->
        <div class="toolbar">
          <!-- 顶部搜索 -->
          <el-form :inline="true" :model="moneyForm">
            <el-form-item label="汇总日期时间">
              <el-date-picker
                v-model="moneyForm.time"
                value-format="yyyy-MM-dd"
                type="date"
                placeholder="选择日期"
              />
            </el-form-item>
            <el-form-item label="收支类型">
              <el-select v-model="moneyForm.income" placeholder="请选择">
                <el-option label="全部" :value="null" />
                <el-option label="收入" value="1" />
                <el-option label="支出" value="2" />
              </el-select>
            </el-form-item>
            <el-form-item label="流水类型">
              <el-select v-model="moneyForm.state" placeholder="请选择">
                <el-option label="全部" :value="null" />
                <el-option label="支付" value="支付" />
                <el-option label="退款" value="退款" />
                <el-option label="提现" value="提现" />
              </el-select>
            </el-form-item>
            <el-form-item label-width="0">
              <el-button type="primary" plain @click="search">查询</el-button>
            </el-form-item>
          </el-form>
        </div>
        <!--  表格 -->
        <div class="content_table">
          <div class="table">
            <el-table
              :data="tableDatas"
              border
              :header-cell-style="{ background: '#EEF3FF', color: '#333333' }"
              style="width: 100%"
            >
              >
              <el-table-column prop="waterType" label="流水类型" />
              <el-table-column prop="orderFormid" label="订单ID" />
              <el-table-column prop="incomeType" label="收支类型" />
              <el-table-column prop="money" label="金额(元)" />
              <el-table-column prop="balance" label="余额(元)" />
              <el-table-column prop="time" label="入账时间" />
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
      <p slot="footer" class="dialog-footer">
        <el-button type="primary" @click="moneydio = false">确定</el-button>
      </p>
    </el-dialog>
  </div>
</template>

<script>
import {
  getFinanceCount,
  getBank,
  withdrawal,
  getDetails
} from '@/api/finance'
export default {
  data() {
    return {
      moneydio: false,
      cardList: [
        {
          name: '累计营业额（元）',
          money: '0.00'
        },
        {
          name: '冻结金额（元）',
          money: '0.00'
        },
        {
          name: '可提现金额（元）',
          money: '0.00'
        },
        {
          name: '提现中（元）',
          money: '0.00'
        }
      ],
      form: {
        amount: ''
      },
      moneyForm: {
        time: '',
        income: '',
        state: '',
        page: 1,
        pageSize: 10
      },
      total: 1,
      currentPage: 1,
      rules: {
        amount: [{ required: true, message: '请输入提现金额', trigger: 'blur' }]
      },
      formInline: {
        condition: '1', // 时间条件 1-日汇总 2-月汇总
        time: '' // 时间值
      },
      tableData: [],
      tableDatas: [],
      isVisible: false,
      getDetails: [{}],
      show: false,
      privacyTime: 0
    }
  },
  created() {
    this.getAll(this.formInline)
    this.getBankType()
    this.privacyTime = localStorage.getItem("privacyTime");
  },
  methods: {
    handleSizeChange(val) {
      this.moneyForm.pageSize = val
      this.getAlls()
    },
    handleCurrentChange(val) {
      this.moneyForm.page = val
      this.getAlls()
    },
    handleClick(tab, event) {
      console.log(tab, event)
      this.formInline.type = tab.name
      this.getAll(this.formInline)
    },
    changeDate() {
      this.getAll(this.formInline)
    },
    search() {
      this.total = 1
      this.formInline.page = 1
      this.getAlls()
    },
    // 查看
    seeMore(row) {
      this.moneydio = true
      this.moneyForm.time = row.time
      this.moneyForm.page = 1
      this.tableDatas = []
      this.total = 1
      this.getAlls()
    },
    // 提现
    async getMoney() {
      this.isVisible = true
      this.form.amount = ''
      // const res = await getWithdrawalDetails(this.formInline);
      const res = await getBank({ })
      console.log(res.data)
      if (JSON.stringify(res.data) === '{}') {
        this.show = false
      } else {
        this.show = true
        this.getDetails = res.data
      }
    },
    // 提现确定
    async confirm() {
      if (this.show) {
        if (this.form.amount <= 0) {
          this.$message({
            message: '请输入正确的提现金额',
            type: 'warning'
          })
          return false
        }
        const res = await withdrawal({
          shopName: this.getDetails.shopName, // 店铺名称
          shopCode: this.getDetails.shopCode, // 店铺编码
          bankName: this.getDetails.bankName, // 银行名称
          bankCard: this.getDetails.bankCard, // 银行卡号
          collectionName: this.getDetails.collectionName, // 收款人姓名
          withdrawalMoney: this.form.amount // 提现金额
        })
        if (res.code === '') {
          this.$message({
            message: '成功',
            type: 'success'
          })
          this.isVisible = false
        }
      } else {
        this.isVisible = false
        this.$router.push({
          path: 'account'
        })
      }
    },
    // 全部提现
    getAllAmount() {
      this.form.amount = this.cardList[2].money
    },
    // 初始化查询所有数据
    async getAll(formInline) {
      const res = await getFinanceCount(formInline)
      if (res.code === '') {
        this.tableData = res.data.finances
        this.cardList[0].money = res.data.turnover
        this.cardList[1].money = res.data.frozenMoney
        this.cardList[2].money = res.data.withdrawableMoney
        this.cardList[3].money = res.data.withdrawableStayMoney
      }
    },
    // 查询明细
    async getAlls() {
      const res = await getDetails(this.moneyForm)
      if (res.code === '') {
        this.tableDatas = res.data.list
        this.total = res.data.total
      }
    },
    // 查询是否绑定银行卡
    async getBankType() {},
    // 中间部分
    hidden(str, frontLen, endLen) {
      let endLenData = 0
      if (str.length !== 2) {
        endLenData = endLen
      }
      const len = str.length - frontLen - endLenData;
      let xing = '';
      for (let i = 0; i < len; i++) {
        xing += '*';
      }
      return (
        str.substring(0, frontLen) + xing + str.substring(str.length - endLenData)
      );
      // return str
    }
  }
}
</script>

<style scoped lang='scss'>
@import url("../../../styles/elDialog.scss");
.finance_page {
  width: 100%;
  height: 100%;
  .leftText {
    font-size: 24px;
    font-weight: bold;
    color: #333333;
  }
  .leftTip {
    font-size: 14px;
    color: #999999;
    margin-left: 20px;
  }
  .rightBtn {
    width: 100px;
    height: 48px;
    background: #3a68f2;
    border-radius: 4px;
    color: #ffffff;
    float: right;
  }
  .cardLIst {
    padding: 10px;
    display: flex;
    justify-content: space-around;
    align-items: center;
    .cardItem {
      padding: 20px;
    }
    .cardDetal {
      .cardMoney {
        font-size: 40px;
        font-weight: bold;
        color: #ffae11;
        margin-bottom: 20px;
        text-align: center;
      }
      .cardText {
        font-size: 18px;
        display: flex;
        color: #333333;
        img {
          width: 20px;
          height: 20px;
          margin-left: -7px;
        }
      }
    }
  }
}
.tableBox {
  padding: 20px;
}
.cardList {
  padding-left: 30px;
}
.rightSearch {
  position: absolute;
  right: 20px;
  z-index: 999;
}
.text_tip {
  margin-left: 50px;
}
.sub_text {
  cursor: pointer;
}
</style>
