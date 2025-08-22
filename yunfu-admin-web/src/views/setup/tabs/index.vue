<template>
  <div class="userStyleMenus">
    <!-- 搜索 -->
    <div class="formSearch">
      <el-form :inline="true" :model="searchData">
        <el-form-item label="菜单名">
          <el-input v-model="searchData.permissionName" maxlength="20" placeholder="请输入菜单名" />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" plain @click="search">查询</el-button>
          <el-button type="info" plain @click="clear">重置</el-button>
          <el-button type="success" plain @click="add(1)">新增父级目录</el-button>
          <el-button type="success" plain @click="add(2)">新增子级菜单</el-button>
          <el-button type="success" plain @click="add(3)">新增子级按钮</el-button>
        </el-form-item>
      </el-form>
    </div>
    <!-- 表格 -->
    <div class="tableBox">
      <el-table
        ref="tableRef"
        v-loading="tableLoading"
        :data="tableData"
        row-key="permissionId"
        border
        :header-cell-style="{ 'background': '#EEF3FF', 'color': '#333333' }"
        :style="{ 'width': '100%' }"
        :tree-props="{ children: 'childs', hasChildren: 'hasChildren' }"
        class="dataTable"
        @selection-change="handleSelectionChange"
        @select="handleSelection"
      >
        <el-table-column type="selection" width="55" />
        <el-table-column prop="permissionName" label="菜单名称" />
        <el-table-column label="图标">
          <template #default="scope">
            <div>
              <icon :icon="scope.row.icon" />
            </div>
          </template>
        </el-table-column>
        <el-table-column prop="permission" label="菜单标识" />
        <el-table-column prop="createTime" label="创建时间" />
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
      <div class="fenye">
        <el-pagination
          v-model:current-page="searchData.page"
          :page-sizes="[10, 20, 50, 100]"
          :page-size="searchData.pageSize"
          layout="total, sizes, prev, pager, next, jumper"
          background
          :total="total"
          @size-change="handleSizeChange"
          @current-change="handleCurrentChange"
        />
      </div>
    </div>

    <!-- *************对话框开始************* -->
    <el-dialog
      v-model="addFormDialog"
      :title="userState ? '新增菜单' : '修改菜单'"
      width="30%"
      center
      :close-on-click-modal="false"
      @closed="onClosed"
    >
      <!-- 新增角色 -->
      <div>
        <el-form
          ref="formRef"
          :model="addForm"
          label-width="80px"
          :rules="userRules"
        >
          <el-form-item label="父节点ID" prop="permissionPid">
            <el-input
              v-model="addForm.permissionPid"
              maxlength="20"
              :disabled="true"
              placeholder="请输入角色名称"
            />
          </el-form-item>
          <el-form-item label="菜单名称" prop="permissionName">
            <el-input
              v-model="addForm.permissionName"
              maxlength="20"
              placeholder="请输入菜单名称"
            />
          </el-form-item>
          <el-form-item label="菜单路径" prop="permission">
            <el-input
              v-model="addForm.permission"
              maxlength="100"
              placeholder="请输入菜单路径"
            />
          </el-form-item>
          <el-form-item label="图标" prop="icon">
            <el-input
              :class="{placeholder: !addForm.icon}"
              type="button"
              :model-value="addForm.icon || '点击选择图标'"
              @click="openIcons(addForm.icon)"
            >
              <template #prepend>
                <icon :icon="addForm.icon" />
              </template>
            </el-input>
          </el-form-item>
          <el-form-item label="菜单描述" prop="describe">
            <el-input
              v-model="addForm.describe"
              maxlength="60"
              placeholder="请输入菜单描述"
            />
          </el-form-item>
          <el-form-item label="排序值" prop="sort">
            <el-input
              v-model="addForm.sort"
              maxlength="9"
              placeholder="请输入排序值"
              oninput="value=value.replace(/[^\d]/g,'')"
            />
          </el-form-item>
          <el-form-item label="权限类型" prop="resourceType">
            <el-select
              v-model="addForm.resourceType"
              placeholder="请选择权限类型"
            >
              <el-option label="菜单" value="menu" />
              <el-option label="按钮" value="button" />
              <el-option label="目录" value="catalog" />
            </el-select>
          </el-form-item>
        </el-form>
      </div>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="addFormDialog = false">取 消</el-button>
          <el-button type="primary" :loading="submitLoading" @click="addForm_enter(formRef)">确 定</el-button>
        </span>
      </template>
    </el-dialog>

    <Icons
      ref="iconsRef"
      @choose="chooseIcon"
    />
  </div>
</template>

<script setup>
import { ref, onBeforeMount } from 'vue'
import {
  tabsGetAll,
  tabsAdd,
  tabsGetById,
  tabsUpdate,
  tabsDelete,
  getMaxSort,
} from '@/api/setup'
import Icons from '@/components/Icons/index.vue'

const iconsRef = ref(null)
const formRef = ref(null)
const tableRef = ref(null)
const tableLoading = ref(false)
const submitLoading = ref(false)
const searchData = ref({
  permissionName: '', // 搜索字段
  page: 1, // 当前页
  pageSize: 10 // 每页记录数
})
const total = ref(1)
const tableData = ref([])
const userState = ref(1)
const addForm = ref({
  permissionPid: '', // 父节点id
  permissionName: '', // 权限名称
  permissionUri: '', // URI
  permission: '', // 组件
  icon: '', // 图标地址
  describe: '', // 描述
  resourceType: 'menu', // 权限类型 menu-菜单 button-按钮 catalog-目录
  sort: '', // 排序值
})
const addFormDialog = ref(false)
const userRules = ref({
  permissionName: [
    { required: true, message: '请输入权限名称', trigger: 'blur' },
  ],
  permission: [
    { required: true, message: '请输入菜单路径', trigger: 'blur' },
  ],
  resourceType: [
    { required: true, message: '请选择权限类型', trigger: 'change' },
  ],
  sort: [{ required: true, message: '请输入菜单路径', trigger: 'blur' }],
  icon: [{ required: true, message: '请输入图标地址', trigger: 'change' }],
})
const multipleSelection = ref([])

// 全选改成单选
const handleSelection = (selection, row) => {
  if (selection.length > 1) {
    const del_row = selection.shift()
    tableRef.value.toggleRowSelection(del_row, false)
  }
}
const handleSelectionChange = (val) => {
  multipleSelection.value = val
}
const handleSizeChange = (val) => {
  searchData.value.pageSize = val
  getAll()
}
const handleCurrentChange = (val) => {
  searchData.value.page = val
  getAll()
}
// 查询
const search = () => {
  total.value = 1
  searchData.value.page = 1
  getAll()
}
// 清除
const clear = () => {
  searchData.value = {
    permissionName: '', // 搜索字段
    page: 1, // 当前页
    pageSize: 10, // 每页记录数
  }
  getAll()
}
// 新增角色
const add = (index) => {
  userState.value = 1
  getMaxSort().then((res) => {
    addForm.value.sort = parseInt(res.data)
    if (index === 1) {
      if (multipleSelection.value.length >= 1) {
        return ElMessage({
          message: '请勿选择节点进行操作',
        })
      }
      addForm.value.resourceType = 'catalog'
      addForm.value.sort = parseInt(res.data)
      addFormDialog.value = true
    } else if (index === 2) {
      if (multipleSelection.value.length === 0) {
        return ElMessage({
          message: '请选择父节点',
        })
      }
      if (multipleSelection.value[0].permissionPid !== 0) {
        return ElMessage({
          message: '请选择父节点进行操作',
        })
      }
      addForm.value.permissionPid = multipleSelection.value[0].permissionId
      addForm.value.resourceType = 'menu'
      addForm.value.sort = parseInt(res.data)
      addFormDialog.value = true
    } else if (index === 3) {
      if (multipleSelection.value.length === 0) {
        return ElMessage({
          message: '请选择子节点',
        })
      }
      if (
        multipleSelection.value[0].permissionPid === 0 &&
        multipleSelection.value[0].childs.length !== 0
      ) {
        return ElMessage({
          message: '请勿选择父节点进行操作',
        })
      }
      addForm.value.permissionPid = multipleSelection.value[0].permissionId
      addForm.value.resourceType = 'button'
      addForm.value.sort = parseInt(res.data)
      addFormDialog.value = true
    }
  })
}
// 确认新增角色
const addForm_enter = async (formEl) => {
  if (!formEl) return
  await formEl.validate((valid, fields) => {
    if (valid) {
      submitLoading.value = true
      if (userState.value) {
        tabsAdd(addForm.value).then((res) => {
          if (res.code === '') {
            ElMessage({
              message: '新增成功',
              type: 'success',
            })
          }
          getAll()
          addFormDialog.value = false
        }).finally(() => {
          submitLoading.value = false
        })
      } else {
        tabsUpdate(addForm.value).then((res) => {
          if (res.code === '') {
            ElMessage({
              message: '修改成功',
              type: 'success',
            })
          }
          getAll()
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
// 弹窗关闭时重置form表单
const onClosed = () => {
  formRef.value.resetFields()
}
// 编辑角色
const edit = (row) => {
  userState.value = 0
  addFormDialog.value = true
  tabsGetById({ permissionId: row.permissionId }).then((res) => {
    addForm.value = res.data
    // this.addForm.roleIds = [1];
  })
}
// 删除角色
const del = (row) => {
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
      tabsDelete({ permissionId: row.permissionId }).then((res) => {
        if (res.code === '') {
          ElMessage({
            type: 'success',
            message: '删除成功!',
          })
        }
        getAll()
      })
    })
    .catch(() => {})
}
// 组件传回值
const chooseIcon = (icon) => {
  addForm.value.icon = icon
}
const openIcons = (icon) => {
  iconsRef.value.open(icon)
}
// 初始化查询所有数据
const getAll = async () => {
  try {
    tableLoading.value = true
    const res = await tabsGetAll(searchData.value)
    tableData.value = res.data.list
    total.value = res.data.total
  } finally {
    tableLoading.value = false
  }
}

onBeforeMount(() => {
  getAll()
})
</script>

<style lang="scss" scoped>
.userStyleMenus {
  padding: 20px;
  margin-top: 20px;
  background-color: #FFFFFF;
  .formSearch {
    display: flex;
    .searchInput {
      margin-right: 20px;
      display: flex;
      align-items: center;
      span {
        min-width: 70px;
        font-weight: bold;
      }
    }
  }
  :deep(.el-table) {
    th.el-table__cell:nth-child(1) {
      .cell {
        visibility: hidden;
      }
    }
  }
  :deep(.placeholder) {
    .el-input__inner {
      color: var(--el-text-color-placeholder);
    }
  }
  // .tableBox {
  //   margin: 0 20px 20px;
  // }
}
</style>
