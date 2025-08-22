<template>
  <div class="custom_page">
    <el-card>
      <div class="cardList">
        <div
          v-for="(item, index) in cardList"
          :key="index"
          class="cardItem"
        >
          <div class="cardDetal">
            <div class="cardMoney">{{ item.money }}</div>
            <div
              class="cardText"
              :title="item.title"
            >
              <span>{{ item.name }}</span>
              <img src="../../../assets/images/shuoming.png" />
            </div>
          </div>
        </div>
      </div>
    </el-card>
    <div class="content">
      <!-- 顶部搜索 -->
      <div class="toolbar formSearch">
        <!-- 顶部搜索 -->
        <el-form
          :inline="true"
          :model="formInline"
        >
          <el-form-item label="商家名称">
            <el-input
              v-model="formInline.shopName"
              maxlength="20"
              placeholder="请输入商家名称"
            />
          </el-form-item>
          <el-form-item label="商家编码">
            <el-input
              v-model="formInline.shopCode"
              maxlength="20"
              placeholder="请输入商家编码"
            />
          </el-form-item>
          <el-form-item label-width="0">
            <el-button
              type="primary"
              plain
              @click="search"
            >查询
            </el-button>
            <el-button
              plain
              @click="clear"
            >重置
            </el-button>
          </el-form-item>
        </el-form>
      </div>
      <!--  表格 -->
      <el-table
        v-loading="tableLoading"
        :data="tableData"
        border
        :header-cell-style="{ background: '#EEF3FF', color: '#333333' }"
        style="width: 100%"
        class="dataTable"
      >
        <el-table-column
          prop="shopName"
          label="商家名称"
        />
        <el-table-column
          prop="shopCode"
          label="商家编码"
        />
        <el-table-column
          prop="revenue"
          label="营收总额"
        />
        <el-table-column
          prop="frozen"
          label="冻结金额"
        />
        <el-table-column
          prop="withdrawable"
          label="可提现金额"
        />
        <el-table-column
          prop="haveWithdrawable"
          label="已提现金额"
        />
        <el-table-column
          prop="refund"
          label="已退款金额"
        />
      </el-table>
      <el-pagination
        v-model:current-page="formInline.page"
        v-model:page-size="formInline.pageSize"
        :page-sizes="[10, 20, 50, 100]"
        layout="total, sizes, prev, pager, next, jumper"
        background
        :total="total"
        style="margin: 20px 0;"
        @size-change="handleSizeChange"
        @current-change="handleCurrentChange"
      />
    </div>
  </div>
</template>

<script setup>
// import { getShopId } from '@/utils/auth'
import { overviewGetall } from '@/api/overview'
import { onMounted, ref } from 'vue';

const cardList = ref([
  {
    name: '营收总额',
    money: '0.00',
    field: 'revenue',
    title: '所有订单状态为待发货、待收货、交易成功的订单金额之和'
  },
  {
    name: '冻结总金额',
    money: '0.00',
    field: 'frozen',
    title: '用户确认收货后，金额将会解冻'
  },
  {
    name: '可提现金额',
    money: '0.00',
    field: 'withdrawable',
    title: ''
  },
  {
    name: '提现中',
    money: '0.00',
    field: 'withdrawableStayMoney',
    title: ''
  },
  {
    name: '已提金额',
    money: '0.00',
    field: 'haveWithdrawable',
    title: ''
  },
  {
    name: '已退款金额',
    money: '0.00',
    field: 'refund',
    title: ''
  },
])
const tableLoading = ref(false)
const formInline = ref({
  shopName: '', // 商家名称
  shopCode: '', // 商家编码
  page: 1,
  pageSize: 10,
})
const total = ref(1)
const tableData = ref([])
onMounted(() => {
  getAll(formInline.value)
})
function handleSizeChange (val) {
  formInline.value.pageSize = val
  getAll(formInline.value)
}

function handleCurrentChange (val) {
  formInline.value.page = val
  getAll(formInline.value)
}
// 查询
function search () {
  total.value = 1
  formInline.value.page = 1
  getAll(formInline.value)
}
// 清除
function clear () {
  formInline.value = {
    shopName: '', // 商家名称
    shopCode: '', // 商家编码
    page: 1,
    pageSize: 10,
  }
  getAll(formInline.value)
}
function getTopList (o) {
  cardList.value.map((item) => {
    item.money = o[item.field]
  })
}
// 初始化查询所有数据
function getAll (formInline) {
  tableLoading.value = true
  overviewGetall(formInline).then(res => {
    tableData.value = res.data.page.list
    total.value = res.data.page.total
    getTopList(res.data)
  }).finally(() => {
    tableLoading.value = false
  })
}

</script>

<style lang="scss" scoped>
.custom_page {
  .el-card {
    margin: 20px;
  }
  .content {
    padding: 20px;
    background-color: #FFFFFF;
  }
}

.cardList {
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
        margin-left: 5px;
      }
    }
  }
}
</style>
