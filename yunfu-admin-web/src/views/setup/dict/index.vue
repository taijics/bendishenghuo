<template>
  <div class="dictStyle">
    <!-- 左侧列表 -->
    <div class="leftTable">
      <el-card class="box-card">
        <!-- 顶部搜索框 -->
        <el-form :inline="true" :model="searchData">
          <el-form-item label="字典名称">
            <el-input
              v-model="searchData.search"
              maxlength="20"
              placeholder="请输入字典名称"
            />
          </el-form-item>
          <el-form-item>
            <el-button type="primary" plain @click="search">查询</el-button>
            <el-button type="info" plain @click="reset">重置</el-button>
            <el-button type="success" plain @click="add">新建</el-button>
          </el-form-item>
        </el-form>
        <!-- 表格 -->
        <el-table
          ref="singleTable"
          v-loading="tableLoading"
          :data="tableData"
          border
          highlight-current-row
          style="width: 100%"
          class="dataTable"
          @current-change="getSubData"
        >
          <el-table-column type="index" width="50" />
          <el-table-column
            property="dictName"
            label="字典名称"
            width="220"
          />
          <el-table-column
            property="dictDescribe"
            label="字典描述"
            width="120"
          />
          <el-table-column property="createTime" label="创建时间" />
          <el-table-column label="操作">
            <template #default="scope">
              <div class="btnList">
                <el-button link type="primary" @click="edit(scope.row)">编辑</el-button>
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
          v-model:current-page="searchData.page"
          :page-sizes="[10, 20, 50, 100]"
          :page-size="searchData.pageSize"
          layout="total, sizes, prev, pager, next, jumper"
          background
          :total="total"
          style="margin: 12px 0;"
          @size-change="handleSizeChange"
          @current-change="handleCurrentChange"
        />
      </el-card>
    </div>
    <!-- 右侧列表 -->
    <div class="rightTable">
      <el-card class="box-card">
        <span class="cardSpan">字典详情</span>
        <el-button style="float: right; padding: 3px 0" link type="primary" @click="addNewDict">新增</el-button>
        <el-table ref="singleTable" v-loading="subTableLoading" :data="anothTable" style="width: 100%">
          <el-table-column type="index" width="50" />
          <el-table-column
            property="dictName"
            label="字典名称"
            width="120"
          />
          <el-table-column
            property="dictDescribe"
            label="字典描述"
            width="120"
          />
          <el-table-column property="createTime" label="创建时间" />
          <el-table-column label="操作" show-overflow-tooltip>
            <template #default="scope">
              <div class="btnList">
                <el-button link type="primary" @click="edit(scope.row)">编辑</el-button>
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
          v-model:current-page="sonInline.page"
          :page-sizes="[10, 20, 50, 100]"
          :page-size="sonInline.pageSize"
          layout="total, sizes, prev, pager, next, jumper"
          background
          :total="antotal"
          style="margin: 12px 0;"
          @size-change="handleSizeChanges"
          @current-change="handleCurrentChanges"
        />
      </el-card>
    </div>
    <!-- *************对话框开始************* -->
    <el-dialog
      v-model="addFormDialog"
      :title="userState ? '新增字典' : '修改字典'"
      width="30%"
      center
      :close-on-click-modal="false"
      @closed="onClosed"
    >
      <!-- 新增角色 -->
      <el-form
        ref="formRef"
        :model="addForm"
        label-width="80px"
        :rules="userRules"
      >
        <el-form-item label="字典名称" prop="dictName">
          <el-input
            v-model="addForm.dictName"
            maxlength="20"
            placeholder="请输入字典名称"
          />
        </el-form-item>
        <el-form-item label="字典描述" prop="dictDescribe">
          <el-input
            v-model="addForm.dictDescribe"
            maxlength="60"
            placeholder="请输入字典描述"
          />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="addFormDialog = false">取 消</el-button>
        <el-button type="primary" :loading="submitLoading" @click="addForm_enter(formRef)">确 定</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, onBeforeMount } from 'vue'
import {
  dictGetAll,
  dictAdd,
  dictGetById,
  dictUpdate,
  dictGetChilds,
  dictDelete,
} from '@/api/setup'
const formRef = ref(null)
const submitLoading = ref(false)
const searchData = ref({
  search: '',
  page: 1,
  pageSize: 10,
})
const sonInline = ref({
  dictPid: '',
  page: 1,
  pageSize: 10,
})
const total = ref(1)
const antotal = ref(1)
const tableLoading = ref(false)
const subTableLoading = ref(false)
const tableData = ref([])
const anothTable = ref([])
const addFormDialog = ref(false)
const addForm = ref({
  dictId: '', // 字典id
  dictPid: '', // 字典父id
  dictName: '', // 字典名称
  dictDescribe: '', // 字典描述
  createTime: '', // 创建时间
})
const userState = ref(1)
const userRules = ref({
  dictName: [
    { required: true, message: '请输入字典名称', trigger: 'blur' },
  ],
})

onBeforeMount(() => {
  getAll()
})

// 方法集合
const handleSizeChange = (val) => {
  searchData.value.pageSize = val
  getAll()
}
const handleCurrentChange = (val) => {
  searchData.value.page = val
  getAll()
}
const handleSizeChanges = (val) => {
  sonInline.value.pageSize = val
  getSubData()
}
const handleCurrentChanges = (val) => {
  sonInline.value.page = val
  getSubData()
}
// 查询子数据
const getSubData = (val) => {
  subTableLoading.value = true
  if (val) {
    sonInline.value.dictPid = val.dictId
  }
  dictGetChilds(sonInline.value).then(res => {
    anothTable.value = res.data.list
    antotal.value = res.data.total
  }).finally(() => {
    subTableLoading.value = false
  })
}
// 查询
const search = () => {
  // total.value = 1
  searchData.value.page = 1
  getAll()
}
// 新增
const add = () => {
  userState.value = 1
  addFormDialog.value = true
  addForm.value = {
    dictId: '', // 字典id
    dictPid: '', // 字典父id
    dictName: '', // 字典名称
    dictDescribe: '', // 字典描述
    createTime: '', // 创建时间
  }
}
// 新增子字典
const addNewDict = () => {
  userState.value = 1
  addFormDialog.value = true
  addForm.value = {
    dictId: '', // 字典id
    dictPid: '', // 字典父id
    dictName: '', // 字典名称
    dictDescribe: '', // 字典描述
    createTime: '', // 创建时间
  }
  addForm.value.dictPid = sonInline.value.dictPid
}
// 编辑
const edit = (row) => {
  userState.value = 0
  addFormDialog.value = true
  dictGetById({ dictId: row.dictId }).then((res) => {
    addForm.value = res.data
    // this.addForm.roleIds = [1];
  })
}
// 删除角色
const del = async (row) => {
  ElMessageBox.confirm(
    '此操作将永久删除, 是否继续?',
    '提示',
    {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning',
    }
  )
    .then(() => {
      dictDelete({ dictId: row.dictId }).then((res) => {
        if (res.code === '') {
          ElMessage({
            type: 'success',
            message: '删除成功!',
          })
        }
        getAll()
        getSubData()
      })
    })
    .catch(() => {})
}
// 确认新增字典
const addForm_enter = async (formEl) => {
  if (!formEl) return
  await formEl.validate((valid, fields) => {
    if (valid) {
      submitLoading.value = true
      if (userState.value) {
        dictAdd(addForm.value).then((res) => {
          if (res.code === '') {
            ElMessage({
              message: '新增成功',
              type: 'success',
            })
          }
          getAll()
          getSubData()
          addFormDialog.value = false
        }).finally(() => {
          submitLoading.value = false
        })
      } else {
        dictUpdate(addForm.value).then((res) => {
          if (res.code === '') {
            ElMessage({
              message: '修改成功',
              type: 'success',
            })
          }
          getAll()
          getSubData()
          addFormDialog.value = false
        }).finally(() => {
          submitLoading.value = false
        })
      }
    } else {
      return false
    }
  })
}
const onClosed = () => {
  formRef.value.resetFields()
}
const reset = () => {
  searchData.value = {
    search: '', // 搜索字段
    page: 1, // 当前页
    pageSize: 10, // 每页记录数
  }
  getAll()
}
// 初始化查询所有数据
const getAll = () => {
  tableLoading.value = true
  dictGetAll(searchData.value).then(res => {
    tableData.value = res.data.list
    total.value = res.data.total
  }).finally(() => {
    tableLoading.value = false
  })
}
</script>

<style lang="scss" scoped>
.dictStyle {
  display: flex;
  padding: 20px;
  justify-content: space-between;
  align-items: flex-start;
  .leftTable {
  width: 49%;
  }
  .rightTable {
    width: 49%;
  }
  .cardSpan {
    font-size: 15px;
    color: #606266;
    font-weight: bold;
  }
}
</style>
