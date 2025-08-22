<template>
  <div class="content">
    <el-row :gutter="10" class="padding-bottom">
      <el-col :span="24">
        <el-button
          type="primary"
          @click="handleAdd"
        >新增</el-button>
      </el-col>
    </el-row>
    <el-table
      v-loading="tableLoading"
      :data="list"
      border
      style="width: 100%"
      :header-cell-style="{
        background: '#EEF3FF',
        color: '#333333'
      }"
    >
      <el-table-column
        header-align="center"
        align="center"
        prop="brandName"
        label="品牌名称"
        width="180"
      />
      <el-table-column
        header-align="center"
        align="center"
        prop="brandLogo"
        label="Logo"
      >
        <template #default="scope">
          <el-image
            :src="scope.row.brandLogo"
            :preview-src-list="[scope.row.brandLogo]"
            style="width: 100px; height: 100px"
            :preview-teleported="true"
          />
        </template>
      </el-table-column>
      <el-table-column align="center" label="相关操作" header-align="center">
        <template #default="scope">
          <el-button
            style="margin-right: 10px"
            type="warning"
            @click="handleUpdate(scope.row)"
          >修改</el-button>
          <el-popconfirm title="确认删除？" @confirm="handleDelete(scope.row)">
            <template #reference>
              <el-button type="danger">删除</el-button>
            </template>
          </el-popconfirm>
        </template>
      </el-table-column>
    </el-table>
    <el-pagination
      :current-page="query.page"
      :page-sizes="tableOptions.pageSizes"
      :page-size="query.pageSize"
      :layout="tableOptions.layout"
      :total="tableOptions.total"
      background
      style="margin: 12px 0;"
      @size-change="handleSizeChange"
      @current-change="handleCurrentChange"
    />
    <Form
      ref="brandFormRef"
      :item="formOption"
      @confirm="getList"
    />
  </div>
</template>

<script setup>
import { getBrandAll, deleteBrand } from '@/api/renovation'
import Form from './form.vue'
import { onMounted, ref } from 'vue';

const tableLoading = ref(true)
const brandFormRef = ref(null)
const list = ref([])
const query = ref({
  page: 1,
  pageSize: 10,
})
const tableOptions = ref({
  total: 0,
  layout: 'total, sizes, prev, pager, next, jumper',
  pageSizes: [10, 30, 50, 100, 200],
})
const formOption = ref(null)

onMounted(() => {
  getList()
})
function getList () {
  tableLoading.value = true
  getBrandAll(query.value).then(res => {
    list.value = res.data.list
    tableOptions.value.total = res.data.total
  }).finally(() => {
    tableLoading.value = false
  })
}
function handleSizeChange (val) {
  query.value.pageSize = val
  getList()
}
function handleCurrentChange (val) {
  query.value.page = val
  getList()
}
function handleAdd () {
  formOption.value = {
    id: null
  }
  brandFormRef.value.open()
}
function handleUpdate (item) {
  formOption.value = item
  brandFormRef.value.open()
}
function handleDelete (item) {
  ElMessageBox.confirm(
    '是否确认删除?',
    'Warning',
    {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning',
    }
  )
    .then(() => {
      deleteBrand(item).then(res => {
        if (res.code === '') {
          ElMessage.success('删除成功')
          getList()
        } else {
          ElMessage.error(res.message)
        }
      })
    })
    .catch(() => {})
}
</script>

<style lang="scss" scoped>
.content {
  padding: 20px;
  margin-top: 20px;
  background-color: #FFFFFF;
  .fenye {
    margin-top: 20px;
  }
}
.padding-bottom {
  padding-bottom: 30px;
}
</style>
