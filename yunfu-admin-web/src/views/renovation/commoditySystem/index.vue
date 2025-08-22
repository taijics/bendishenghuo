<template>
  <div>
    <div class="pending">
      <!-- 搜索 -->
      <div class="formSearch">
        <el-form :inline="true" :model="formInline">
          <el-form-item label="商品状态">
            <el-radio-group
              v-model="formInline.shelveState"
              @change="changeState"
            >
              <el-radio-button label="">全部</el-radio-button>
              <el-radio-button label="0">已下架</el-radio-button>
              <el-radio-button label="1">已上架</el-radio-button>
              <el-radio-button label="2">待审核</el-radio-button>
              <el-radio-button label="3">审核失败</el-radio-button>
            </el-radio-group>
          </el-form-item>
          <br />
          <el-form-item label="商品ID">
            <el-input
              v-model="formInline.productId"
              maxlength="20"
              placeholder="请输入商品ID"
            />
          </el-form-item>
          <el-form-item label="商品名称">
            <el-input
              v-model="formInline.productName"
              maxlength="20"
              placeholder="请输入商品名称"
            />
          </el-form-item>
          <el-form-item label="商户名称">
            <el-input
              v-model="formInline.shopName"
              maxlength="20"
              placeholder="请输入商户名称"
            />
          </el-form-item>
          <el-form-item>
            <el-button type="primary" plain @click="search">查询</el-button>
            <el-button plain @click="clear">重置</el-button>
            <el-button
              type="success"
              plain
              @click="productDataExport"
            >导出商品</el-button>
            <!-- <span
                v-for="(item, index) in btnList"
                :key="index"
                class="promissStyle"
              >
                <el-button type="success" plain @click="btnClick(item)">{{
                  item.permissionName
                }}</el-button>
              </span> -->
          </el-form-item>
        </el-form>
      </div>
      <!-- 表格 -->
      <el-table
        v-loading="loading.table"
        :data="tableData"
        border
        :header-cell-style="{ background: '#EEF3FF', color: '#333333' }"
        tooltip-effect="dark"
        style="width: 100%"
        class="dataTable"
      >
        <el-table-column
          prop="productId"
          label="商品id"
          show-overflow-tooltip
          width="80"
        />
        <el-table-column label="商品主图" width="150" align="center">
          <template #default="scope">
            <img height="80" width="80" :src="scope.row.image" alt srcset />
          </template>
        </el-table-column>
        <el-table-column prop="productName" label="商品名称" width="180" />
        <el-table-column prop="shopName" label="商家名称" width="180" />
        <el-table-column
          prop="sectionPrice"
          label="售价区间"
          show-overflow-tooltip
        />
        <!-- <el-table-column
              prop="memberSection"
              label="会员价"
              show-overflow-tooltip
            /> -->
        <el-table-column
          prop="stockNumber"
          label="库存"
          show-overflow-tooltip
        />
        <el-table-column
          prop="volume"
          label="实际销售"
          show-overflow-tooltip
        />
        <el-table-column
          prop="fictitiousNumber"
          label="虚拟销售"
          show-overflow-tooltip
        />
        <el-table-column prop="createTime" label="创建时间" width="180" />
        <el-table-column
          prop="shelveState"
          label="上架状态"
        >
          <template #default="scope">
            <span v-if="scope.row.shelveState == 0">已下架</span>
            <span v-if="scope.row.shelveState == 1">已上架</span>
            <span v-if="scope.row.shelveState == 2">待审核</span>
            <span v-if="scope.row.shelveState == 3">审核失败</span>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="200">
          <template #default="scope">
            <div class="btnList">
              <el-button
                v-if="scope.row.shelveState == 1"
                slot="reference"
                style="margin-right: 10px"
                type="primary"
                link
                @click="OutForced(scope.row)"
              >强制下架</el-button>
              <el-button
                v-if="scope.row.shelveState == 1"
                type="primary"
                link
                @click="handleSetFictitious(scope.row)"
              >虚拟销量</el-button>
              <el-button
                v-if="scope.row.shelveState == 2"
                type="primary"
                link
                @click="examineShow(scope.row)"
              >审核</el-button>
              <el-button
                type="primary"
                link
                @click="Godetails(scope.row)"
              >查看详情</el-button>
            </div>
          </template>
        </el-table-column>
      </el-table>
      <div class="fenye">
        <el-pagination
            :current-page="formInline.page"
            :page-sizes="[5, 10, 20, 50, 100]"
            :page-size="formInline.pageSize"
            layout="total, sizes, prev, pager, next, jumper"
            background
            :total="total"
            @size-change="handleSizeChange"
            @current-change="handleCurrentChange"
        />
      </div>
    </div>
    <!-- 设置虚拟销量 -->
    <el-dialog
      v-model="FictitiousVisible"
      title="自定义虚拟销量"
      width="460px"
    >
      <el-form :model="ForcedForm">
        <el-form-item label="" label-width="110px">
          <el-input-number
            v-model="ForcedForm.fictitiousNumber"
            :precision="0"
            :min="1"
            :max="999999999"
            label="请输入整数"
          />
        </el-form-item>
      </el-form>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="FictitiousVisible = false">取 消</el-button>
          <el-button type="primary" @click="FicSubmintUs">确 定</el-button>
        </span>
      </template>
    </el-dialog>
    <AddCommodity
      ref="commodityFormRef"
      :examine-show="examineShow"
      @reset="reset"
    />
    <ExamineForm
      ref="examineFormRef"
      @check="examineCheck"
    />
  </div>
</template>

<script setup>
import { onMounted, ref, shallowRef, shallowReactive } from 'vue';

import {
  getClassifyGetAll,
  Forced,
  setFictitious,
  productExport,
} from '@/api/commodity'
import AddCommodity from './addCommodity.vue'
import ExamineForm from './examine.vue'

let loading = shallowReactive({
  table: false,
  export: false,
})
let formInline = ref({
  shelveState: '', // 商品状态 0-已下架 1-已上架 2-待审核 3-审核失败
  productName: '', // 商品名称
  productId: '', // 商品ID
  shopName: '', // 商户名称
  page: 1, // 当前页
  pageSize: 5,
})
let total = shallowRef(1)
let tableData = ref([])
let FictitiousVisible = shallowRef(false)
let ForcedForm = ref({
  fictitiousNumber: 0,
  productId: '',
  reject: '',
  shelveState: 1,
})
let isDetail = shallowRef(false)

onMounted(() => {
  getAll(formInline.value)
})

const commodityFormRef = ref()
// 查看详情
function Godetails (row) {
  commodityFormRef.value.show(row.productId)
}
// 设置虚拟销量
function handleSetFictitious (row) {
  FictitiousVisible.value = true
  ForcedForm.value.productId = row.productId
  ForcedForm.value.fictitiousNumber = row.fictitiousNumber
}

function FicSubmintUs () {
  setFictitious(ForcedForm.value).then(res => {
    if (res.code === '') {
      FictitiousVisible.value = false
      ElMessage.success(
        '虚拟销量已设置：' + ForcedForm.value.fictitiousNumber
      )
      search()
    }
  })
}
// 强制下架
function OutForced (row) {
  ElMessageBox.alert('确定下架此商品吗？', '提示', {
    confirmButtonText: '确定',
    callback: (action) => {
      if (action === 'confirm') {
        ForcedForm.value.productId = row.productId
        Forced(ForcedForm.value).then((res) => {
          if (res.code === '') {
            ElMessage.success('下架成功')
            search()
          }
        })
      }
    },
  })
}

// 审核弹窗
const examineFormRef = ref();

function examineShow (row) {
  if (row.isDetail) {
    isDetail.value = row.isDetail
  }
  examineFormRef.value.open({
    id: row.productId
  })
}
function examineCheck () {
  search()
  if (isDetail.value) {
    commodityFormRef.value.details()
  }
}

function handleSizeChange (val) {
  formInline.value.pageSize = val
  getAll(formInline.value)
}
function handleCurrentChange (val) {
  formInline.value.page = val
  getAll(formInline.value)
}
//  查询
function search () {
  total.value = 1
  formInline.value.page = 1
  getAll(formInline.value)
}
// 商品状态查询
function changeState (e) {
  formInline.value.shelveState = e
  getAll(formInline.value)
}
function clear () {
  formInline.value = {
    shelveState: '', // 商品状态 0-已下架 1-已上架 2-待审核 3-审核失败
    productName: '', // 商品名称
    productId: '', // 商品ID
    shopName: '', // 商户名称
    page: 1, // 当前页
    pageSize: 5,
  }
  getAll(formInline.value)
}
// 导出商品
async function productDataExport () {
  ElMessage({
    message: '数据导出中，请勿重复操作！',
    type: 'success',
  })
  const res = await productExport(formInline.value)
  if (!res) {
    return
  }
  const blob = new Blob([res], { type: 'application/vnd.ms-excel' })
  const fileName = '商品数据明细表.xls'
  if ('download' in document.createElement('a')) {
    // 非IE下载
    const elink = document.createElement('a')
    elink.download = fileName
    elink.style.display = 'none'
    elink.href = URL.createObjectURL(blob)
    document.body.appendChild(elink)
    elink.click()
    URL.revokeObjectURL(elink.href) // 释放URL 对象
    document.body.removeChild(elink)
  } else {
    // IE10+下载
    navigator.msSaveBlob(blob, fileName)
  }
}
// 初始化查询所有数据
function getAll (formInline) {
  loading.table = true
  getClassifyGetAll(formInline).then(res => {
    total.value = res.data.total
    tableData.value = res.data.list
  }).finally(() => {
    loading.table = false
  })
}
function reset () {
  getAll(formInline.value)
}
</script>

<style lang="scss" scoped>
.pending {
  padding: 20px;
  margin-top: 20px;
  background-color: #FFFFFF;
}
.fenye {
  margin-top: 20px;
}
.clickMe {
  color: #3a68f2;
  cursor: pointer;
}
.vipDialog {
  .priceTable {
    table {
      width: 100%;
      text-align: center;
      border-left: 1px solid #ebeef5;
      border-bottom: 1px solid #ebeef5;
      font-size: 14px;
      color: #606266;
      border-collapse: collapse;
      tr {
        border-top: 1px solid #ebeef5;
        th {
          padding: 12px 0;
          background: #eef3ff;
          color: #333;
          border-right: 1px solid #ebeef5;
        }
        td {
          padding: 12px 0;
          border-right: 1px solid #ebeef5;
          &:nth-child(1),
          &:nth-child(2) {
            width: 80px;
          }
          .el-input {
            width: 100px;
            margin-right: 10px;
          }
        }
      }
    }
  }
}
.fenye {
  margin-top: 20px;
}
</style>
