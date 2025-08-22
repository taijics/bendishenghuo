<template>
  <div class="classification-page">
    <div class="toolbar formSearch">
      <el-button type="success" @click="addBar">添加一级类别</el-button>
    </div>
    <el-table
      v-loading="tableLoading"
      :data="tableData"
      style="width: 100%"
      border
      row-key="id"
      :header-cell-style="{ background: '#EEF3FF', color: '#333333' }"
      :tree-props="{ children: 'childs' }"
      class="dataTable"
    >
      <el-table-column prop="classifyName" label="商品类别" />
      <el-table-column prop="status" label="操作">
        <template #default="scope">
          <el-button
            type="primary"
            link
            @click.native.prevent="checkRow(scope.row)"
          >查看</el-button>
          <el-button
            type="primary"
            link
            @click.native.prevent="updateRow(scope.row)"
          >编辑</el-button>
          <el-popconfirm title="确认删除？" @confirm="deleteRow(scope.row)">
            <template #reference>
              <el-button type="danger" link>删除</el-button>
            </template>
          </el-popconfirm>
        </template>
      </el-table-column>
    </el-table>
    <el-pagination
      :current-page="formParams.page"
      :page-sizes="[10, 20, 50, 100]"
      :page-size="formParams.pageSize"
      layout="total, sizes, prev, pager, next, jumper"
      background
      :total="total"
      style="margin: 12px 0;"
      @size-change="handleSizeChange"
      @current-change="handleCurrentChange"
    />
    <edit-dialog
      ref="edit"
      :dialog-visible="dialog.isVisible"
      :type="dialog.type"
      @close="editClose"
      @success="getProductCategory"
    />
  </div>
</template>

<script setup>
import { commdityClassGetAll, commdityClassDelete } from '@/api/renovation'
import EditDialog from './Edit.vue'
import { onMounted, ref } from 'vue';
const tableLoading = ref(false)
const formParams = ref({
  page: 1,
  pageSize: 10,
})
const total = ref(1)
const tableData = ref([])
const dialog = ref({
  type: 'add',
  isVisible: false,
})
onMounted(() => {
  getProductCategory()
  getAll(formParams.value)
})

function handleSizeChange (val) {
  formParams.value.pageSize = val
  getAll(formParams.value)
}
function handleCurrentChange (val) {
  formParams.value.page = val
  getAll(formParams.value)
}
function fetch (config) {
  const { limit, page } = config
  formParams.value.pageIndex = page || 1
  formParams.value.pageSize = limit || 10
  getProductCategory()
}
const edit = ref()
function addBar () {
  dialog.value = {
    type: 'add',
    isVisible: true,
  }
  edit.value.setParams({ treeData: [] })
}
function editClose () {
  dialog.value.isVisible = false
}
// 编辑
function updateRow (row) {
  const id = row.classifyId
  dialog.value = {
    type: 'edit',
    isVisible: true,
  }
  edit.value.setParams({
    id: id,
  })
}
// 查看
function checkRow (row) {
  const id = row.classifyId
  dialog.value = {
    type: 'check',
    isVisible: true,
  }
  edit.value.setParams({
    id
  })
}
// 删除
async function deleteRow (row) {
  ElMessageBox.confirm('此操作将永久删除该类别, 是否继续?', '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning',
  })
    .then(() => {
      commdityClassDelete({ oneClassifyId: row.classifyId }).then((res) => {
        if (res.code === '') {
          ElMessage({
            type: 'success',
            message: '删除成功!',
          })
        }
        getAll(formParams.value)
      })
    })
    .catch(() => {})
}
async function getProductCategory () {
  getAll(formParams.value)
}
function getAll (formParams) {
  tableLoading.value = true
  commdityClassGetAll(formParams).then(res => {
    tableData.value = res.data.list
    total.value = res.data.total
  }).finally(() => {
    tableLoading.value = false
  })
}
</script>

<style lang="scss" scoped>
.classification-page {
  padding: 20px;
  margin-top: 20px;
  background-color: #FFFFFF;
  .toolbar {
    margin-bottom: 15px;
    text-align: right;
  }
}
</style>
