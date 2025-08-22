<template>
  <div class="custom_page">
    <div class="content">
      <!-- 顶部搜索 -->
      <div class="toolbar formSearch">
        <!-- 顶部搜索 -->
        <el-form :inline="true" :model="formInline">
          <el-form-item label="关键词">
            <el-input
              v-model="formInline.search"
              maxlength="20"
              placeholder="请输入关键词"
            />
          </el-form-item>
          <el-form-item>
            <el-button type="primary" plain @click="search">查询</el-button>
            <el-button plain @click="clear">重置</el-button>
            <el-button type="success" plain @click="add">新增关键词</el-button>
          </el-form-item>
        </el-form>
      </div>
      <div class="stateLabel">
        <span class="formItem">状态：</span>
        <el-switch
          v-model="value"
          active-color="#3A68F2"
          inactive-color="#dcdfe6"
          active-value="1"
          inactive-value="0"
          @change="changeState"
        />
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
            <el-table-column type="index" label="序号" width="50" />
            <el-table-column prop="keyWord" label="关键词" />
            <el-table-column prop="createTime" label="创建时间" />
            <el-table-column label="操作">
              <template #default="scope">
                <div class="btnList">
                  <el-button
                    type="primary"
                    link
                    @click="edit(scope.row)"
                  >修改</el-button>
                  <el-popconfirm title="确认删除？" @confirm="del(scope.row)">
                    <template #reference>
                      <el-button type="danger" link>删除</el-button>
                    </template>
                  </el-popconfirm>
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
    <!-- 关键词 -->
    <el-dialog
      v-model="isVisible.show"
      :title="isVisible.title"
      width="30%"
      center
      :close-on-click-modal="false"
    >
      <div>
        <el-form ref="formRef" :model="form" label-width="100px">
          <el-form-item label="关键词">
            <el-input
              v-model="form.keyWord"
              maxlength="20"
              placeholder="请输入关键词"
            />
          </el-form-item>
        </el-form>
      </div>
      <template #footer>
        <span class="dialog-footer">
          <el-button type="primary" @click="agreeEn">确定</el-button>
          <el-button @click="isVisible.show = false">取 消</el-button>
        </span>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { onMounted, ref } from 'vue';
import {
  wordStart,
  wordGetAll,
  wordAdd,
  wordGetById,
  wordUpdate,
  wordDelete,
} from '@/api/business'
let value = ref(0)
let formInline = ref({
  search: '',
  state: '',
  page: 1,
  pageSize: 10,
})
let form = ref({
  keyWord: '',
  state: 0 // 是否启用 1-是 0-否
})
let tableLoading = ref(false)
let isVisible = ref({})
let total = ref(1)
let tableData = ref([])

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

function changeState (index) {
  wordStart({ state: value.value }).then(res => {
    if (res.code === '') {
      // $message.success("成功");
    }
    console.log(index)
  })
}
function search () {
  total.value = 1
  formInline.value.page = 1
  getAll(formInline.value)
}
function add () {
  form.value.keyWord = ''
  isVisible.value = {
    show: true,
    title: '添加关键词',
    index: 1,
  }
}
// 编辑
function edit (row) {
  wordGetById({
    wordId: row.wordId,
  }).then(res => {
    if (res.code === '') {
      form.value = res.data
      isVisible.value = {
        show: true,
        title: '编辑关键词',
        index: 2,
      }
    }
  })
}
function agreeEn () {
  if (isVisible.value.index === 1 && (!form.value.keyWord && form.value.keyWord !== 0)) {
    return ElMessage.error('请输入关键词')
  }
  form.value.state = value.value
  const fn = isVisible.value.index === 1 ? wordAdd : wordUpdate
  fn(form.value).then(res => {
    if (res.code === '') {
      ElMessage.success('操作成功')
      getAll(formInline.value)
      isVisible.value.show = false
    }
  })
}
function del (row) {
  ElMessageBox.confirm('确定要删除该条关键词?', '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning',
  })
    .then(() => {
      wordDelete({ wordId: row.wordId }).then((res) => {
        if (res.code === '') {
          ElMessage({
            type: 'success',
            message: '删除成功!',
          })
        }
        getAll(formInline.value)
      })
    })
    .catch(() => {})
}
function clear () {
  formInline.value = {
    orderFormid: '',
    distributorName: '',
    distributorPhone: '',
    dates: [],
    page: 1,
    pageSize: 10,
  }
  getAll(formInline.value)
}
function getAll (formInline) {
  tableLoading.value = true
  wordGetAll(formInline).then(res => {
    tableData.value = res.data.list
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
.checkBoxStyle {
  margin-bottom: 20px;
}
.dialog_content {
  width: 275px;
  height: 46px;
  margin: auto;
  font-size: 16px;
  font-family: PingFang SC;
  font-weight: 400;
  color: #333333;
  line-height: 30px;
  margin-top: 25px;
}
.stateLabel {
  display: flex;
  justify-content: flex-start;
  align-items: center;
  margin-bottom: 20px;
  .formItem {
    float: left;
    font-size: 14px;
    color: #606266;
    padding: 0 12px 0 0;
    font-weight: 700;
  }
}
</style>
