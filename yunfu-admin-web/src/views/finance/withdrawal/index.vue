<template>
  <div class="pdl">
    <!-- 搜索 -->
    <div class="formSearch">
      <el-form
        :inline="true"
        :model="formInline"
      >
        <el-form-item label="店铺名称">
          <el-input
            v-model="formInline.shopName"
            maxlength="20"
            placeholder="请输入店铺名称"
          />
        </el-form-item>
        <el-form-item label="店铺编码">
          <el-input
            v-model="formInline.shopCode"
            maxlength="20"
            placeholder="请输入店铺编码"
          />
        </el-form-item>

        <el-form-item label="提现日期">
          <el-date-picker
            v-model="formInline.startTime"
            type="date"
            value-format="yyyy-MM-dd"
            placeholder="选择日期"
          />
        </el-form-item>
        <el-form-item label="处理状态">
          <el-select
            v-model="formInline.state"
            placeholder="请选择"
          >
            <el-option
              label="已处理"
              value="1"
            />
            <el-option
              label="未处理"
              value="0"
            />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button
            type="primary"
            plain
            @click="search"
          >查询
          </el-button>
          <el-button
            type="success"
            plain
            @click="clear"
          >重置
          </el-button>
        </el-form-item>
      </el-form>
    </div>
    <!-- 表格 -->
    <div class="tableBox">
      <el-table
        v-loading="tableLoading"
        :data="tableData"
        border
        :header-cell-style="{ background: '#EEF3FF', color: '#333333' }"
        tooltip-effect="dark"
        style="width: 100%"
        class="dataTable"
      >
        <el-table-column
          label="店铺名称"
          width="220"
        >
          <template #default="scope">{{ scope.row.shopName }}</template>
        </el-table-column>
        <el-table-column
          prop="shopCode"
          label="店铺编码"
        />
        <el-table-column
          prop="withdrawalMoney"
          label="提现金额"
        />
        <el-table-column
          prop="state"
          label="处理状态"
        >
          <template #default="scope">
            <span v-if="scope.row.state == 1">已处理</span>
            <span v-if="scope.row.state == 0">未处理</span>
          </template>
        </el-table-column>
        <el-table-column
          label="操作"
        >
          <template #default="scope">
            <div class="btnList">
              <el-button
                type="primary"
                link
                @click="seeMore(scope.row)"
              >查看
              </el-button>
              <el-button
                v-if="scope.row.state == 0"
                type="primary"
                link
                @click="desh(scope.row)"
              >处理
              </el-button>
            </div>
          </template>
        </el-table-column>
      </el-table>
      <el-pagination
        :current-page="formInline.page"
        :page-sizes="[10, 20, 50, 100]"
        :page-size="formInline.pageSize"
        layout="total, sizes, prev, pager, next, jumper"
        background
        :total="total"
        style="margin: 12px 0;"
        @size-change="handleSizeChange"
        @current-change="handleCurrentChange"
      />
    </div>
    <!-- *************对话框开始************* -->
    <!-- 提现申请查询 -->
    <el-dialog
      v-model="addFormDialog"
      :title="useState ? '查看' : '提现'"
      width="800px"
      center
      :close-on-click-modal="false"
    >
      <div class="seeModel">
        <el-descriptions
          class="margin-top"
          title=""
          :column="2"
          border
        >
          <el-descriptions-item>
            <template slot="label"> 店铺名称：</template>
            {{ withDetails.shopName }}
          </el-descriptions-item>
          <el-descriptions-item>
            <template slot="label"> 店铺编码：</template>
            {{ withDetails.shopCode }}
          </el-descriptions-item>
          <el-descriptions-item>
            <template slot="label"> 银行名称：</template>
            {{ withDetails.bankName }}
          </el-descriptions-item>
          <el-descriptions-item>
            <template slot="label"> 银行卡号：</template>
            {{ withDetails.bankCard }}
          </el-descriptions-item>
          <el-descriptions-item>
            <template slot="label"> 收款人姓名：</template>
            {{ withDetails.collectionName }}
          </el-descriptions-item>
          <el-descriptions-item>
            <template slot="label"> 提现金额：</template>
            {{ withDetails.withdrawalMoney }}
          </el-descriptions-item>
          <el-descriptions-item>
            <template slot="label"> 申请时间：</template>
            {{ withDetails.applyTime }}
          </el-descriptions-item>
          <el-descriptions-item v-if="withDetails.handleTime">
            <template slot="label"> 处理时间：</template>
            {{ withDetails.handleTime }}
          </el-descriptions-item>
        </el-descriptions>
      </div>
      <div
        v-if="!useState"
        class="titleLIne"
      >
        * 请确认您已转账成功，再点击确认
      </div>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="addFormDialog = false">取 消</el-button>
          <el-button
            v-if="!useState"
            type="primary"
            @click="handle_save"
          >确认打款</el-button>
        </span>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
// 这里可以导
// 入其他文件（比如：组件，工具js，第三方插件js，json文件，图片文件等等）
// 例如：import 《组件名称》 from '《组件路径》';
import { withdrawalGetAll, withdrawalGetById, withdrawalHandle, } from '@/api/withdrawal'
import { hidden } from '@/utils/index'
import { onMounted, ref } from 'vue';

const total = ref(1)
const tableData = ref([])
const tableLoading = ref(false)
const addFormDialog = ref(false)
const useState = ref(1)
const withDetails = ref('')
const formInline = ref({
  shopName: '', // 店铺名称
  shopCode: '', // 店铺编号
  startTime: '', // 申请时间数组
  state: '', // 处理状态 1-已处理 0-未处理
  page: 1,
  pageSize: 10,
})
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

function search () {
  total.value = 1
  formInline.value.page = 1
  getAll(formInline.value)
}

// 清除
function clear () {
  formInline.value = {
    shopName: '', // 店铺名称
    shopCode: '', // 店铺编号
    dates: [], // 申请时间数组
    state: '', // 处理状态 1-已处理 0-未处理
    page: 1,
    pageSize: 10,
  }
  getAll(formInline.value)
}

// 查看
async function seeMore (row) {
  useState.value = 1
  addFormDialog.value = true
  const res = await withdrawalGetById({ withdrawalId: row.withdrawalId })
  withDetails.value = res.data
  withDetails.value.bankCard = hidden(withDetails.value.bankCard, 3, 3)
  withDetails.value.collectionName = hidden(
    withDetails.value.collectionName,
    1,
    1
  )
}

// 处理
async function desh (row) {
  useState.value = 0
  addFormDialog.value = true
  const res = await withdrawalGetById({ withdrawalId: row.withdrawalId })
  withDetails.value = res.data
  withDetails.value.bankCard = hidden(withDetails.value.bankCard, 3, 3)
  withDetails.value.collectionName = hidden(
    withDetails.value.collectionName,
    1,
    1
  )
}

async function handle_save () {
  const res = await withdrawalHandle({
    withdrawalId: withDetails.value.withdrawalId,
  })
  if (res.code === '') {
    ElMessage({
      message: '新增成功',
      type: 'success',
    })
    addFormDialog.value = false
    getAll(formInline.value)
  }
}

// 初始化查询所有数据
function getAll (formInline) {
  tableLoading.value = true
  withdrawalGetAll(formInline).then(res => {
    tableData.value = res.data.list
    total.value = res.data.total
  }).finally(() => {
    tableLoading.value = false
  })
}

</script>

<style lang="scss" scoped>
.pdl {
  padding: 20px;
  margin-top: 20px;
  background-color: #FFFFFF;
}

.seeModel {
  padding: 20px;
  display: flex;
  justify-content: center;
  align-items: center;
  color: #000;
  font-size: 16px;

  .leftBox {
    padding: 20px;
  }

  .rightBox {
    padding: 20px;
  }

  .line {
    padding: 10px;
  }
}

.titleLIne {
  color: red;
  font-size: 16px;
  text-align: center;
}

.el-descriptions {
  width: 100%;
}
</style>
