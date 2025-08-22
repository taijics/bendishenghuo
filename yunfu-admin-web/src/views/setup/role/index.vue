<template>
  <div class="userStyle">
    <!-- 搜索 -->
    <div class="formSearch">
      <el-form :inline="true" :model="searchData">
        <el-form-item label="角色名">
          <el-input
            v-model="searchData.search"
            maxlength="20"
            placeholder="请输入角色名"
          />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" plain @click="search">查询</el-button>
          <el-button type="info" plain @click="clear">重置</el-button>
          <el-button type="success" plain @click="add">新增角色</el-button>
        </el-form-item>
      </el-form>
    </div>
    <!-- 表格 -->
    <div class="tableBox">
      <el-table
        v-loading="tableLoading"
        :data="tableData"
        border
        :header-cell-style="{ 'background': '#EEF3FF', 'color': '#333333' }"
        tooltip-effect="dark"
        :style="{ 'width': '100%' }"
        class="dataTable"
      >
        <el-table-column label="角色id" width="220">
          <template #default="scope">{{ scope.row.roleId }}</template>
        </el-table-column>
        <el-table-column prop="roleName" label="角色名称" />
        <el-table-column prop="roleDescribe" label="描述" />
        <el-table-column label="操作">
          <template #default="scope">
            <div class="btnList">
              <el-button link type="primary" @click="edit(scope.row)">编辑</el-button>
              <el-popconfirm title="确认删除？" @confirm="del(scope.row)">
                <template #reference>
                  <el-button type="danger" link>删除</el-button>
                </template>
              </el-popconfirm>
              <el-button link type="primary" @click="buss(scope.row)">分配权限</el-button>
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
    <!-- 新增角色 -->
    <el-dialog
      v-model="addFormDialog"
      :title="userState ? '新增角色' : '修改角色'"
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
          <el-form-item label="角色名称" prop="roleName">
            <el-input
              v-model="addForm.roleName"
              maxlength="20"
              placeholder="请输入角色名称"
            />
          </el-form-item>
          <el-form-item label="角色描述" prop="roleDescribe">
            <el-input
              v-model="addForm.roleDescribe"
              maxlength="60"
              placeholder="请输入角色描述"
            />
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
    <!-- 分配权限 -->
    <el-dialog
      v-model="dialogVisible"
      title="分配权限"
      center
      :close-on-click-modal="false"
    >
      <el-form :model="activityObj" label-width="80px" label-position="left">
        <el-form-item label="权限列表">
          <el-tree
            ref="permissionRef"
            :data="permissionsList"
            show-checkbox
            check-strictly
            render-after-expand
            default-expand-all
            node-key="permissionId"
            :props="props"
            @check="handleCheck"
          />
        </el-form-item>
      </el-form>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="dialogVisible = false">取消</el-button>
          <el-button type="primary" :loading="confirmLoading" @click="confirmRole">确认</el-button>
        </span>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, onBeforeMount } from 'vue'
import {
  roleAdd,
  roleGetall,
  roleGetById,
  roleUpdate,
  roleDelete,
  getRolePermission,
  distribution,
} from '@/api/setup'

const formRef = ref(null)
const permissionRef = ref(null)
const tableLoading = ref(false)
const submitLoading = ref(false)
const confirmLoading = ref(false)
const searchData = ref({
  search: '', // 搜索字段
  page: 1, // 当前页
  pageSize: 10, // 每页记录数
})
const total = ref(1)
const tableData = ref([])
const activityObj = ref({
  ids: [],
})
const props = ref({
  children: 'childs',
  label: 'permissionName',
})
const userState = ref(1)
const dialogVisible = ref(false)
const permissionsList = ref([])
const checkedIds = ref([])
const addForm = ref({
  roleName: '', // 角色名称
  roleDescribe: '', // 角色描述
})
const addFormDialog = ref(false)
const userRules = ref({
  roleName: [
    { required: true, message: '请输入角色名称', trigger: 'blur' },
  ],
})
const roleId = ref(null)

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
// 查询
const search = () => {
  total.value = 1
  searchData.value.page = 1
  getAll()
}
// 清除
const clear = () => {
  searchData.value = {
    search: '', // 搜索字段
    state: '', // 是否启用 1-是 0-否
    page: 1, // 当前页
    pageSize: 10, // 每页记录数
  }
  getAll()
}
// 新增角色
const add = () => {
  userState.value = 1
  addFormDialog.value = true
}
// 确认新增角色
const addForm_enter = async (formEl) => {
  if (!formEl) return
  await formEl.validate((valid, fields) => {
    if (valid) {
      submitLoading.value = true
      if (userState.value) {
        roleAdd(addForm.value).then((res) => {
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
        roleUpdate(addForm.value).then((res) => {
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
// 弹窗关闭
const onClosed = () => {
  formRef.value.resetFields()
}
// 编辑角色
const edit = (row) => {
  userState.value = 0
  addFormDialog.value = true
  roleGetById({ roleId: row.roleId }).then((res) => {
    addForm.value = res.data
    addForm.value.roleIds = res.data.ids
    // this.addForm.roleIds = [1];
  })
}
// 删除角色
const del = async (row) => {
  ElMessageBox.confirm(
    '此操作将永久删除该角色, 是否继续?',
    '提示',
    {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning',
    }
  )
    .then(() => {
      roleDelete({ roleId: row.roleId }).then((res) => {
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
// 分配权限
const buss = async (row) => {
  roleId.value = row.roleId
  dialogVisible.value = true
  const res = await getRolePermission({
    roleId: roleId.value,
  })
  if (res.code === '') {
    permissionsList.value = res.data.permissions
    permissionRef.value.setCheckedKeys(res.data.ids)
  }
}
// 提交
const confirmRole = async () => {
  confirmLoading.value = true
  try {
    const res = await distribution({
      roleId: roleId.value,
      permissionIds: checkedIds.value,
    })
    if (res.code === '') {
      ElMessage.success('分配成功')
      dialogVisible.value = false
      roleId.value = null
    }
  } finally {
    confirmLoading.value = false
  }
  // const loading = this.$loading({
  //   lock: true,
  //   text: '处理中请稍后...',
  //   spinner: 'el-icon-loading',
  //   background: 'rgba(0, 0, 0, 0.3)',
  // })
}
// 获取选中的ID
const handleCheck = (data, { checkedKeys }) => {
  checkedIds.value = checkedKeys
}
// 初始化查询所有数据
const getAll = async () => {
  tableLoading.value = true
  try {
    const res = await roleGetall(searchData.value)
    tableData.value = res.data.list
    total.value = res.data.total
  } finally {
    tableLoading.value = false
  }
}
</script>

<style lang="scss" scoped>
.userStyle {
  padding: 20px;
  margin-top: 20px;
  background-color: #FFFFFF;
}
.el-tree {
  width: 100%;
}
</style>
