<template>
  <div class="custom_page">
    <div class="content">
      <!-- 顶部搜索 -->
      <div class="toolbar formSearch">
        <!-- 顶部搜索 -->
        <el-form
          :inline="true"
          :model="formInline"
        >
          <el-form-item label="用户名称">
            <el-input
              v-model="formInline.name"
              maxlength="20"
              placeholder="请输入"
            />
          </el-form-item>
          <el-form-item label="手机号">
            <el-input
              v-model="formInline.phone"
              maxlength="11"
              placeholder="请输入"
            />
          </el-form-item>
          <el-form-item label="提现状态">
            <el-select
              v-model="formInline.state"
              placeholder="请选择"
            >
              <el-option
                label="全部"
                value="null"
              />
              <el-option
                label="待审核"
                value="0"
              />
              <el-option
                label="通过"
                value="1"
              />
              <el-option
                label="拒绝"
                value="2"
              />
            </el-select>
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
      <div class="content_table">
        <div class="table">
          <el-table
            v-loading="tableLoading"
            :data="tableData"
            border
            :header-cell-style="{ background: '#EEF3FF', color: '#333333' }"
            style="width: 100%"
            class="dataTable"
          >
            >
            <el-table-column
              prop="name"
              label="用户名称"
            />
            <el-table-column
              prop="phone"
              label="手机号码"
            />
            <el-table-column
              prop="withdrawalMoney"
              label="提现金额"
            />
            <el-table-column label="处理状态">
              <template #default="scope">
                <span v-if="scope.row.state == 0">审核中</span>
                <span v-if="scope.row.state == 1">通过</span>
                <span v-if="scope.row.state == 2">拒绝</span>
              </template>
            </el-table-column>
            <el-table-column
              label="操作"
            >
              <template #default="scope">
                <div class="btnList">
                  <el-button
                    v-if="scope.row.state !== 0"
                    type="primary"
                    link
                    @click="seeMore(scope.row)"
                  >查看
                  </el-button>
                  <el-button
                    v-else
                    type="primary"
                    link
                    @click="del(scope.row)"
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
      </div>
    </div>
    <!-- *****************弹框开始***************** -->
    <!-- 详情弹框 -->
    <el-dialog
      v-model="dioObj.show"
      :title="dioObj.title"
      width="40%"
      center
      :close-on-click-modal="false"
    >
      <div class="box">
        <div class="dioBox">
          <div
            v-for="(item, index) in infoList"
            :key="index"
            class="inner"
          >
            {{ item.name }}:{{ item.value }}
          </div>
        </div>
        <div
          v-if="dioObj.type === 2"
          class="botTitle"
        >
          *请确认您已转账成功，再点击确认
        </div>
      </div>
      <template #footer>
        <span class="dialog-footer">
          <el-button
            v-if="dioObj.type === 2"
            type="primary"
            @click="agreeEn(1)"
          >确认打款</el-button>
          <el-button
            v-if="dioObj.type === 2"
            type="danger"
            @click="agreeEn(2)"
          >拒绝打款</el-button>
          <el-button
            v-if="dioObj.type === 1"
            @click="dioObj.show = false"
          >关 闭</el-button>
        </span>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { hidden } from '@/utils/index'
import { applicationGetAll, applicationGetById, applicationHandle, } from '@/api/application'
import { onMounted, ref } from 'vue';

let formInline = ref({
  name: '', // 用户名称
  phone: '', // 手机号码
  state: null, // 提现状态 空-全部 0-待审核 1-通过 2-拒绝
  page: 1,
  pageSize: 10,
})
let tableLoading = ref(false)
let total = ref(1)
let tableData = ref([])
let infoList = ref([
  { name: '手机号码', value: '', fields: 'phone' },
  { name: '银行名称', value: '', fields: 'bankName' },
  { name: '银行卡号', value: '', fields: 'bankCard' },
  { name: '收款人姓名', value: '', fields: 'name' },
  { name: '提现金额', value: '', fields: 'withdrawalMoney' },
  { name: '申请时间', value: '', fields: 'applyTime' },
  { name: '处理时间', value: '', fields: 'handleTime' },
])
let multipleSelection = ref([])
let dioObj = ref({})
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

function handleSelectionChange (val) {
  multipleSelection.value = val
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
    name: '', // 用户名称
    phone: '', // 手机号码
    state: null, // 提现状态 空-全部 0-待审核 1-通过 2-拒绝
    page: 1,
    pageSize: 10,
  }
  getAll(formInline.value)
}
function getTopList (o) {
  infoList.value.map((item) => {
    item.value = o[item.fields]
  })
}
// 查看
function seeMore (row) {
  dioObj.value = {
    title: '查看',
    show: true,
    arr: row,
    type: 1
  }
  getDetails(row.withdrawalId)
}
// 处理
function del (row) {
  dioObj.value = {
    title: '处理',
    show: true,
    arr: row,
    type: 2,
  }
  getDetails(row.withdrawalId)
}
// 确认
function agreeEn (index) {
  if (![1, 2].includes(index)) { return }
  applicationHandle({
    withdrawalId: dioObj.value.arr.withdrawalId,
    state: index,
  }).then(res => {
    if (res.code === '') {
      ElMessage.success(index === 1 ? '成功确认打款' : '成功拒绝打款')
      dioObj.value.show = false
      getAll(formInline.value)
    }
  })
}

// 查询详情
function getDetails (withdrawalId) {
  applicationGetById({ withdrawalId }).then(res => {
    if (res.code === '') {
      getTopList(res.data)
    }
  })
}
// 初始化查询所有数据
function getAll (formInline) {
  tableLoading.value = true
  applicationGetAll(formInline).then(res => {
    tableData.value = res.data.list
    tableData.value.forEach((item) => {
      item.phone = hidden(item.phone, 3, 4)
    })
    total.value = res.data.total
  }).finally(() => {
    tableLoading.value = false
  })
}
</script>

<style lang="scss" scoped>
.custom_page {
  padding: 20px;
  margin-top: 20px;
  background-color: #FFFFFF;
}

.box {
  .dioBox {
    display: flex;
    justify-content: flex-start;
    align-items: center;
    flex-wrap: wrap;

    .inner {
      width: 50%;
      padding: 20px;
    }
  }

  .botTitle {
    color: red;
    text-align: center;
  }
}
</style>
