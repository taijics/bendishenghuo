<template>
  <div class="userStyle">
    <!-- 搜索 -->
    <div class="formSearch">
      <el-form ref="searchRef" :inline="true" :model="searchData">
        <el-form-item label="用户名" prop="search">
          <el-input
            v-model="searchData.search"
            maxlength="20"
            placeholder="请输入用户名"
          />
        </el-form-item>
        <el-form-item label="是否启用" prop="state">
          <el-select v-model="searchData.state" placeholder="请选择">
            <el-option label="是" value="1" />
            <el-option label="否" value="0" />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" plain @click="search">查询</el-button>
          <el-button type="success" plain @click="add">新增用户</el-button>
          <el-button type="info" plain @click="reset">重置</el-button>
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
        <el-table-column label="用户名" width="220">
          <template #default="scope">{{ scope.row.username }}</template>
        </el-table-column>
        <el-table-column prop="name" label="姓名" />
        <el-table-column prop="sex" label="性别" />
        <el-table-column prop="phone" label="电话" />
        <el-table-column prop="email" label="邮箱" />
        <el-table-column prop="state" label="是否启用">
          <template #default="scope">
            <span v-if="scope.row.state == 0">停用</span>
            <span v-if="scope.row.state == 1">启用</span>
          </template>
        </el-table-column>
        <el-table-column prop="createTime" label="创建时间" />
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
      :title="userState ? '新增用户' : '修改用户'"
      width="30%"
      center
      :close-on-click-modal="false"
      @closed="onClosed"
    >
      <!-- 新增用户 -->
      <div>
        <el-form
          ref="formRef"
          :model="formData"
          label-width="80px"
          :rules="rules"
        >
          <el-form-item label="用户名" prop="username">
            <el-input
              v-model="formData.username"
              maxlength="20"
              placeholder="请输入用户名"
            />
          </el-form-item>
          <el-form-item label="姓名" prop="name">
            <el-input
              v-model="formData.name"
              maxlength="20"
              placeholder="请输入姓名"
            />
          </el-form-item>
          <el-form-item label="手机号" prop="phone">
            <el-input
              v-if="phoneShow"
              :model-value="hidden(formData.phone, 3, 4)"
              maxlength="11"
              placeholder="请输入手机号"
              @focus="focusPhoneInput"
            />
            <el-input
              v-else
              ref="phoneCls"
              v-model="formData.phone"
              maxlength="11"
              clearable
              placeholder="请输入手机号"
            />
            <!-- <div @click="inputPhone" v-else class="newPhone">
                <span>{{ hidePhone(formData.phone) }}</span>
              </div> -->
          </el-form-item>
          <el-form-item label="密码" prop="password">
            <el-input
              v-model="formData.password"
              maxlength="16"
              placeholder="请输入密码"
              show-password
            />
          </el-form-item>
          <el-form-item label="邮箱" prop="email">
            <el-input
              v-if="emailShow"
              :model-value="hidden(formData.email, 3, 4)"
              maxlength="40"
              placeholder="请输入邮箱"
              @focus="focusEmailInput"
            />
            <el-input
              v-else
              ref="emailCls"
              v-model="formData.email"
              maxlength="40"
              clearable
              placeholder="请输入邮箱"
            />
            <!-- <el-input v-model="formData.email" placeholder="请输入邮箱" /> -->
          </el-form-item>
          <el-form-item label="性别" prop="sex">
            <el-radio-group v-model="formData.sex">
              <el-radio label="男" />
              <el-radio label="女" />
            </el-radio-group>
          </el-form-item>
          <el-form-item label="是否启用" prop="state">
            <el-select v-model="formData.state" placeholder="请选择">
              <el-option label="是" :value="1" />
              <el-option label="否" :value="0" />
            </el-select>
          </el-form-item>
          <el-form-item label="选择角色" prop="roleIds">
            <el-select
              v-model="formData.roleIds"
              multiple
              placeholder="请选择"
            >
              <el-option
                v-for="item in roleList"
                :key="item.roleId"
                :label="item.roleName"
                :value="item.roleId"
              />
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
  </div>
</template>

<script setup>
import { ref, onBeforeMount, nextTick } from 'vue'
import {
  getList,
  userAdd,
  roleGetall,
  userGetById,
  userUpdate,
  userDelete,
} from '@/api/setup'

// const PhoneRule = /^1(3\d|4[5-9]|5[0-35-9]|6[567]|7[0-8]|8\d|9[0-35-9])\d{8}$/
const searchRef = ref(null)
const searchData = ref({
  search: '', // 搜索字段
  state: '', // 是否启用 1-是 0-否
  page: 1, // 当前页
  pageSize: 10 // 每页记录数
})
const total = ref(1)
const tableLoading = ref(false)
const submitLoading = ref(false)
const tableData = ref([])
const userState = ref(1)
const formRef = ref(null)
const phoneCls = ref(null)
const emailCls = ref(null)
const formData = ref({
  name: '', // 昵称
  phone: '', // 电话
  password: '', // 密码
  email: '', // 邮箱
  sex: '男', // 性别
  state: 1, // 是否启用 1-是 0-否
  roleIds: [], // 角色id
})
const addFormDialog = ref(false)
const rules = ref({
  username: [
    { required: true, message: '请输入用户名', trigger: 'blur' },
  ],
  name: [
    { required: true, message: '请输入姓名', trigger: 'blur' }
  ],
  phone: [
    { required: true, message: '请输入手机号', trigger: 'blur' },
    { pattern: /^1[3456789]\d{9}$/, message: '手机号格式错误', trigger: 'blur' }
  ]
})
const roleList = ref([])
// const newPhone = ref('')
// const showPhone = ref(false)
const privacyTime = ref(0)
const phoneShow = ref(false) // 显示脱敏手机号
const emailShow = ref(false) // 显示脱敏邮箱

onBeforeMount(() => {
  getAll(searchData.value)
  getRoleAll()
  privacyTime.value = localStorage.getItem('privacyTime')
})
// 方法集合
const focusEmailInput = () => {
  emailShow.value = false
  formData.value.email = ''
  // 自动获取焦点
  nextTick(() => {
    emailCls.value.focus()
  })
}
const focusPhoneInput = () => {
  phoneShow.value = false
  formData.value.phone = ''
  // 自动获取焦点
  nextTick(() => {
    phoneCls.value.focus()
  })
}
const handleSizeChange = (val) => {
  searchData.value.pageSize = val
  getAll(searchData.value)
}
const handleCurrentChange = (val) => {
  searchData.value.page = val
  getAll(searchData.value)
}
// 查询
const search = () => {
  total.value = 1
  searchData.value.page = 1
  getAll(searchData.value)
}
// 重置
const reset = () => {
  searchData.value = {
    search: '', // 搜索字段
    state: '', // 是否启用 1-是 0-否
    page: 1, // 当前页
    pageSize: 10, // 每页记录数
  }
  getAll(searchData.value)
}
// 新增用户
const add = () => {
  userState.value = 1
  // showPhone.value = true
  addFormDialog.value = true
  // formData.value = {
  //   name: '', // 昵称
  //   phone: '', // 电话
  //   password: '', // 密码
  //   email: '', // 邮箱
  //   sex: '男', // 性别
  //   state: 1, // 是否启用 1-是 0-否
  //   roleIds: [], // 角色id
  // }
}
// 确认新增用户
const addForm_enter = async (formEl) => {
  if (!formEl) return
  await formEl.validate((valid, fields) => {
    if (valid) {
      submitLoading.value = true
      if (userState.value) {
        userAdd(formData.value).then((res) => {
          if (res.code === '') {
            ElMessage({
              message: '新增成功',
              type: 'success',
            })
          }
          getAll(searchData.value)
          addFormDialog.value = false
        }).finally(() => {
          submitLoading.value = false
        })
      } else {
        userUpdate(formData.value).then((res) => {
          if (res.code === '') {
            ElMessage({
              message: '修改成功',
              type: 'success',
            })
          }
          getAll(searchData.value)
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
// 编辑用户
const edit = (row) => {
  userState.value = 0
  // showPhone.value = false
  phoneShow.value = true
  emailShow.value = true
  addFormDialog.value = true
  userGetById({ platformUserId: row.platformUserId }).then((res) => {
    formData.value = res.data
    formData.value.roleIds = res.data.ids
  })
}
// 删除用户
const del = async (row) => {
  ElMessageBox.confirm(
    '此操作将永久删除该用户, 是否继续?',
    '提示',
    {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning',
    }
  )
    .then(() => {
      userDelete({ platformUserId: row.platformUserId }).then((res) => {
        if (res.code === '') {
          ElMessage({
            type: 'success',
            message: '删除成功!',
          })
        }
        getAll(searchData.value)
      })
    })
    .catch(() => {})
}
// 初始化查询所有数据
const getAll = async (data) => {
  tableLoading.value = true
  try {
    const res = await getList(data)
    tableData.value = res.data.list
    total.value = res.data.total
  } finally {
    tableLoading.value = false
  }
}
const getRoleAll = async () => {
  const res = await roleGetall({ search: '', page: 1, pageSize: 10 })
  roleList.value = res.data.list
}
// 隐藏中间号码
// const hidePhone = (phone) => {
//   // const reg = /^(\d{3})\d{4}(\d{4})$/
//   // phone = phone.replace(reg, '$1****$2')
//   return phone
// }
// 中间部分
const hidden = (str, frontLen, endLen) => {
  let endLenData = 0
  if (str && str.length !== 2) {
    endLenData = endLen
  }
  const len = str.length - frontLen - endLenData
  let xing = ''
  for (let i = 0; i < len; i++) {
    xing += '*'
  }
  return (
    str.substring(0, frontLen) +
    xing +
    str.substring(str.length - endLenData)
  )
}
// const inputPhone = () => {
//   showPhone.value = true
//   newPhone.value = ''
//   nextTick(() => {
//     phoneCls.value.focus()
//   })
// }
const onClosed = () => {
  emailShow.value = false
  phoneShow.value = false
  formRef.value.resetFields()
}

</script>

<style lang="scss" scoped>
.userStyle {
  padding: 20px;
  margin-top: 20px;
  background-color: #FFFFFF;
  .newPhone {
    width: 100%;
    height: 40px;
    line-height: 40px;
    padding: 0 15px;
    border-radius: 4px;
    border: 1px solid #dcdfe6;
    cursor: text;
  }
}
</style>
