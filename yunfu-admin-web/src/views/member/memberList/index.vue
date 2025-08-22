<template>
  <div class="custom_page">
    <div class="content">
      <!-- 顶部搜索 -->
      <el-form :inline="true" :model="formParams">
        <el-form-item label="客户昵称">
          <el-input
            v-model="formParams.name"
            maxlength="20"
            placeholder="请输入客户昵称"
          />
        </el-form-item>
        <el-form-item label="手机号">
          <el-input
            v-model="formParams.phone"
            maxlength="11"
            placeholder="请输入手机号"
          />
        </el-form-item>
        <el-form-item label="标签">
          <el-select v-model="formParams.labelId" placeholder="请选择">
            <el-option
              v-for="(item, index) in tipsList"
              :key="index"
              :label="item.labelName"
              :value="item.buyerLabelId"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="最近消费时间">
          <el-date-picker
            v-model="formParams.dates"
            type="daterange"
            range-separator="至"
            start-placeholder="开始时间"
            end-placeholder="结束时间"
            value-format="yyyy-MM-dd"
          />
        </el-form-item>
        <el-form-item>
          <el-form-item label="累计消费金额">
            <el-input
              v-model="formParams.minMoney"
              maxlength="9"
              placeholder="请输入最小值"
            />
          </el-form-item>
          <el-form-item label="-">
            <el-input
              v-model="formParams.maxMoney"
              maxlength="9"
              placeholder="请输入最大值"
            />
          </el-form-item>
        </el-form-item>
        <el-form-item>
          <el-form-item label="购买次数">
            <el-input
              v-model="formParams.minBuyers"
              maxlength="9"
              oninput="value=value.replace(/[^\d]/g,'')"
              placeholder="请输入最小值"
            />
          </el-form-item>
          <el-form-item label="-">
            <el-input
              v-model="formParams.maxBuyers"
              maxlength="9"
              oninput="value=value.replace(/[^\d]/g,'')"
              placeholder="请输入最大值"
            />
          </el-form-item>
        </el-form-item>

        <el-form-item label-width="0">
          <el-button type="primary" plain @click="search">查询</el-button>
          <el-button plain @click="clear">重置</el-button>
          <el-button
            type="primary"
            plain
            :loading="loading.export"
            @click="handleExport"
          >导出</el-button>
        </el-form-item>
      </el-form>
      <!--  表格 -->
      <div class="content_table">
        <div class="table">
          <el-table
            v-loading="loading.table"
            :data="tableData"
            border
            :header-cell-style="{ background: '#EEF3FF', color: '#333333' }"
            style="width: 100%"
            class="dataTable"
          >
            <el-table-column prop="name" label="客户昵称" />
            <el-table-column prop="phone" label="手机号" />
            <el-table-column prop="memberLevelName" label="会员等级" />
            <el-table-column prop="total" label="消费总额" />
            <el-table-column prop="buyers" label="购买次数" />
            <el-table-column prop="credit" label="剩余积分" />
            <el-table-column prop="time" label="最近消费时间" />
            <el-table-column prop="createTime" label="注册时间" />
            <el-table-column
              :formatter="(row) => (row.registerIp ? row.registerIp : '-')"
              label="注册IP"
              show-overflow-tooltip
            />
            <el-table-column
              :formatter="(row) => (row.lastLoginIp ? row.lastLoginIp : '-')"
              prop="time"
              label="最后登录IP"
              show-overflow-tooltip
            />
            <el-table-column label="操作" fixed="right">
              <template #default="scope">
                <el-button
                  type="primary"
                  link
                  @click.native.prevent="details(scope.row)"
                >详情</el-button>
                <el-button
                  type="primary"
                  link
                  @click.native.prevent="setIntegral(scope.row)"
                >设置积分</el-button>
                <el-button
                  type="primary"
                  link
                  @click.native.prevent="makeTag(scope.row.buyerUserId)"
                >打标签</el-button>
                <el-button
                  type="primary"
                  link
                  @click.native.prevent="addBlackList(scope.row)"
                >
                  {{ scope.row.ifBlack ? '取消黑名单' : '加入黑名单' }}
                </el-button>
              </template>
            </el-table-column>
          </el-table>
          <div class="fenye">
            <el-pagination
              :current-page="formParams.page"
              :page-sizes="[10, 20, 50, 100]"
              :page-size="formParams.pageSize"
              layout="total, sizes, prev, pager, next, jumper"
              background
              :total="total"
              @size-change="handleSizeChange"
              @current-change="handleCurrentChange"
            />
          </div>
        </div>
      </div>
    </div>
    <!-- *************对话框开始************* -->
    <!-- 打标签 -->
    <el-dialog
      v-model="addFormDialog"
      title="选择标签"
      width="30%"
      center
      :close-on-click-modal="false"
    >
      <div>
        <!-- 表单搜索 -->
        <el-form :inline="true" :model="tipsForm">
          <el-form-item label="标签名称">
            <el-input
              v-model="tipsForm.labelName"
              maxlength="20"
              placeholder="请输入标签名称"
            />
          </el-form-item>
          <el-form-item>
            <el-button @click="searchTips">查询</el-button>
          </el-form-item>
          <el-form-item>
            <el-button type="primary" link @click="runTips">管理标签</el-button>
          </el-form-item>
        </el-form>
        <!-- 多选 -->
        <el-checkbox-group v-model="checkList">
          <el-checkbox
            v-for="(item, index) in tipsList"
            :key="index"
            class="checkBoxStyle"
            :label="item.buyerLabelId"
          >{{ item.labelName }}</el-checkbox>
        </el-checkbox-group>
      </div>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="addFormDialog = false">取 消</el-button>
          <el-button type="primary" @click="saveTips">确定</el-button>
        </span>
      </template>
    </el-dialog>
    <el-dialog
      v-model="editIntegral"
      title="修改会员积分"
      width="30%"
      center
      :close-on-click-modal="false"
      @close="credit = 0"
    >
      <el-form label-width="100px">
        <el-form-item label="修改积分">
          <el-radio-group v-model="updateWay" @change="changeWayRadio">
            <el-radio :label="true">增加</el-radio>
            <el-radio :label="false">减少</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="积分">
          <el-input-number
            v-if="updateWay"
            v-model="credit"
            :min="0"
            :max="9999999"
          />
          <el-input-number v-if="!updateWay" v-model="credit" :max="0" />
        </el-form-item>
        <el-form-item style="margin-top: -18px; color: #999999">
          <span>提示 : 在原有积分上增加或减少</span>
        </el-form-item>
      </el-form>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="editIntegral = false">取 消</el-button>
          <el-button type="primary" @click="saveIntegral">确定</el-button>
        </span>
      </template>
    </el-dialog>
    <member-details ref="memberDetailsRef" @reset="reset" />
  </div>
</template>

<script setup>
import { ref, onBeforeMount, reactive } from 'vue'
import { useRouter } from 'vue-router'
import {
  customerMageGetAll,
  getLabels,
  customerSaveUserLabel,
  customerBlacklist,
  updateBuyerCredit,
  exportBuyerUser,
} from '@/api/customerMage'
// import { getSelect } from '../../../api/renovation'
import memberDetails from './details.vue'
// import { constants } from 'fs';

const router = useRouter()
const memberDetailsRef = ref(null)
let loading = reactive({
  table: false,
  export: false,
})
const formParams = ref({
  name: '', // 用户昵称
  phone: '', // 手机号
  labelId: '', // 标签id
  dates: [], // 最近消费时间日期数组
  minMoney: '', // 累计消费金额最小值
  maxMoney: '', // 累计消费金额最大值
  minBuyers: '', // 购买次数最小值
  maxBuyers: '', // 购买次数最大值
  startTime: '', // 申请开始时间
  endTime: '', // 申请结束时间
  page: 1,
  pageSize: 10
})
const tipsForm = ref({
  labelName: ''
})
const total = ref(1)
const tableData = ref([])
const tipsList = ref([])
const checkList = ref([])
const addFormDialog = ref(false)
const editIntegral = ref(false)
const buyerUserId = ref('') // 用户id
const credit = ref(0) // 积分值 扣减积分则传负数
const updateWay = ref(true) // 修改积分单选绑定

onBeforeMount(() => {
  getAll()
  getSelect({ labelName: '' })
})

/**
 * 导出
 */
function handleExport () {
  ElMessage({
    message: '数据导出中，请勿重复操作！',
    type: 'success',
  })
  loading.export = true
  exportBuyerUser(formParams.value).then(res => {
    const blob = new Blob([res], { type: 'application/vnd.ms-excel' })
    const fileName = '用户列表.xls'
    if ('download' in document.createElement('a')) {
      // 非IE下载
      const elink = document.createElement('a')
      elink.download = fileName
      elink.href = URL.createObjectURL(blob)
      elink.style.display = 'none'
      document.body.appendChild(elink)
      elink.click()
      URL.revokeObjectURL(elink.href) // 释放URL 对象
      document.body.removeChild(elink)
    } else {
      // IE10+下载
      navigator.msSaveBlob(blob, fileName)
    }
  }).finally(() => {
    loading.export = false
  })
}
const handleSizeChange = (val) => {
  formParams.value.pageSize = val
  getAll()
}
const handleCurrentChange = (val) => {
  formParams.value.page = val
  getAll()
}
// 查询
const search = () => {
  total.value = 1
  formParams.value.page = 1
  getAll()
}
// 查询标签
const searchTips = () => {
  getSelect({ labelName: tipsForm.value.labelName })
}
const changeWayRadio = (val) => {
  updateWay.value = val
}
// 设置积分（更新积分）
const setIntegral = (row) => {
  editIntegral.value = true
  buyerUserId.value = row.buyerUserId
}
function saveIntegral () {
  if (credit.value === '' || credit.value === undefined) {
    return ElMessage('积分不能为空！')
  } else if (credit.value === 0) {
    return ElMessage('请输入修改积分')
  } else {
    updateBuyerCredit({
      buyerUserId: buyerUserId.value,
      credit: credit.value,
    }).then(res => {
      if (res.code === '') {
        getAll()
        editIntegral.value = false
        ElMessage.success('修改积分成功')
      }
    })
  }
}
// 打标签
function saveTips (row) {
  customerSaveUserLabel({
    buyerUserId: buyerUserId.value,
    buyerLabelIds: checkList.value,
  }).then(res => {
    if (res.code === '') {
      ElMessage.success('成功')
      checkList.value = []
      tipsForm.value.labelName = ''
      addFormDialog.value = false
    }
  })
}
// 加入黑名单
const addBlackList = (row) => {
  //  "ifBlack": "是否加入黑名单 1-是 0-否"
  ElMessageBox.confirm(
    `${
      row.ifBlack
        ? '确认是否取消黑名单'
        : '加入黑名单后，对方将无法登录商城'
    }`,
    `${row.ifBlack ? '取消黑名单' : '加入黑名单'}`,
    {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning',
    }
  )
    .then(() => {
      customerBlacklist({
        buyerUserId: row.buyerUserId,
        ifBlack: row.ifBlack ? 0 : 1,
      }).then((res) => {
        if (res.code === '') {
          ElMessage.success('成功!')
          getAll()
        }
      })
    })
    .catch(() => {})
}
// 跳转标签页面
const runTips = () => {
  router.push({
    path: '/member/tips',
  })
}
// 清除
const clear = () => {
  formParams.value = {
    name: '', // 用户昵称
    phone: '', // 手机号
    labelId: '', // 标签id
    dates: [], // 最近消费时间日期数组
    minMoney: '', // 累计消费金额最小值
    maxMoney: '', // 累计消费金额最大值
    minBuyers: '', // 购买次数最小值
    maxBuyers: '', // 购买次数最大值
    page: 1,
    pageSize: 10
  }
  getAll()
}
// 打标签
const makeTag = (id) => {
  checkList.value = []
  tipsForm.value.labelName = ''
  addFormDialog.value = true
  buyerUserId.value = id
}
const details = (row) => {
  // this.$router.push({
  //   name: 'customerDetails',
  //   params: { buyerUserId: row.buyerUserId, orderFormid: row.orderFormid }
  // })
  memberDetailsRef.value.getUser({
    buyerUserId: row.buyerUserId,
    orderFormid: row.orderFormid,
  })
}
// 初始化查询所有数据
function getAll () {
  loading.table = true
  customerMageGetAll(formParams.value).then(res => {
    tableData.value = res.data && res.data.list || []
    total.value = res.data && res.data.total || 0
  }).finally(() => {
    loading.table = false
  })
}
// 初始化查询所有标签
function getSelect (name) {
  getLabels(name).then(res => {
    tipsList.value = res.data || []
  })
}
const reset = () => {
  getAll()
}
</script>

<style lang="scss" scoped>
.custom_page {
  padding: 20px;
  margin-top: 20px;
  background-color: #FFFFFF;
}
.checkBoxStyle {
  margin-bottom: 20px;
}
</style>
