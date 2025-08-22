<template>
  <div class="userStyle">
    <!-- 搜索 -->
    <div class="formSearch">
      <el-form :inline="true" :model="formInline">
        <el-form-item>
          <el-button type="primary" @click="add">新增权益</el-button>
        </el-form-item>
      </el-form>
    </div>
    <!-- 表格 -->
    <div class="tableBox">
      <el-table
        v-loading="tableLoading"
        :data="tableData"
        border
        :header-cell-style="{ background: '#EEF3FF', color: '#333333' }"
        tooltip-effect="dark"
        style="width: 100%"
        class="dataTable"
      >
        <el-table-column prop="memberName" label="权益名称" />
        <el-table-column label="权益图标" width="180" align="center">
          <template #default="scope">
            <el-image
              style="width: 80px; height: 80px"
              :src="scope.row.memberIcon"
              fit="contain"
            />
          </template>
        </el-table-column>
        <el-table-column prop="memberReason" label="权益说明" />
        <el-table-column label="操作">
          <template #default="scope">
            <div class="btnList">
              <el-button type="primary" link @click="edit(scope.row)">编辑</el-button>
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

    <!-- *************对话框开始************* -->
    <!-- 新增权益 -->
    <el-dialog
      v-model="addFormDialog"
      :title="userState ? '新增权益' : '修改权益'"
      width="30%"
      center
      :close-on-click-modal="false"
    >
      <!-- 新增权益 -->
      <el-form
        ref="formRef"
        :model="addForm"
        label-width="80px"
        :rules="equityRules"
      >
        <el-form-item label="权益名称" prop="memberName">
          <el-input
            v-model="addForm.memberName"
            maxlength="20"
            placeholder="请输入角色名称"
          />
        </el-form-item>
        <el-form-item label="权益图标">
          <el-upload
            class="avatar-uploader"
            :action="action"
            :show-file-list="false"
            :on-success="handleAvatarSuccess"
          >
            <img
              v-if="addForm.memberIcon"
              :src="addForm.memberIcon"
              class="avatar"
            />
            <el-icon v-else class="avatar-uploader-icon"><Plus /></el-icon>
          </el-upload>
        </el-form-item>
        <el-form-item label="权益说明" prop="memberReason">
          <el-input
            v-model="addForm.memberReason"
            maxlength="200"
            type="textarea"
            placeholder="请输入角色描述"
          />
        </el-form-item>
      </el-form>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="addFormDialog = false">取 消</el-button>
          <el-button type="primary" @click="addForm_enter(formRef)">确 定</el-button>
        </span>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
// 这里可以导入其他文件（比如：组件，工具js，第三方插件js，json文件，图片文件等等）
// 例如：import 《组件名称》 from '《组件路径》';
import { ref, onBeforeMount } from 'vue'
import {
  addMembership,
  getMembership,
  getMembershipInfo,
  delMembership,
  changeMembership,
} from '@/api/member'
import { uploadUrl } from '@/utils/request'

const formRef = ref(null)
const formInline = ref({
  page: 1, // 当前页
  pageSize: 10 // 每页记录数
})
const tableLoading = ref(false)
const total = ref(1)
const tableData = ref([])
const multipleSelection = ref([])
const userState = ref(1)
const isChange = ref(false)
const checkStrictly = ref(true)
const action = uploadUrl
const addForm = ref({
  memberId: null,
  memberIcon: '', // 权益图标
  memberName: '', // 权益名称
  memberReason: '' // 权益描述
})
const addFormDialog = ref(false)
const equityRules = ref({
  memberName: [
    { required: true, message: '请输入权益名称', trigger: 'blur' }
  ],
  memberReason: [
    { required: true, message: '请输权益描述', trigger: 'blur' }
  ]
})
const roleId = ref(null)
const imageUrl = ref('')

onBeforeMount(() => {
  getAll()
})

// 方法集合
const handleAvatarSuccess = (response) => {
  const { url } = response.data
  addForm.value.memberIcon = url
}
const handleSizeChange = (val) => {
  formInline.value.pageSize = val
  getAll()
}
const handleCurrentChange = (val) => {
  formInline.value.page = val
  getAll()
}
const removeTag = (index) => {
  console.log(index)
}
const tagChange = (index) => {
  console.log(index)
}
// 查询
const search = () => {
  total.value = 1
  formInline.value.page = 1
  getAll()
}
// 清除
const clear = () => {
  formInline.value = {
    search: '', // 搜索字段
    state: '', // 是否启用 1-是 0-否
    page: 1, // 当前页
    pageSize: 10 // 每页记录数
  }
  getAll()
}
// 新增角色
const add = () => {
  userState.value = 1
  addFormDialog.value = true
  isChange.value = true
  addForm.value = {
    memberId: null,
    memberIcon: '', // 权益图标
    memberName: '', // 权益名称
    memberReason: '' // 权益描述
  }
}
// 确认新增角色
const addForm_enter = (formEl) => {
  if (!formEl) return
  formEl.validate((valid) => {
    if (valid) {
      // 修改
      if (!isChange.value) {
        changeMembership(addForm.value).then((res) => {
          if (res.code === '') {
            ElMessage({
              message: '修改成功',
              type: 'success',
            })
          }
          getAll()
          addFormDialog.value = false
        })
      } else {
        // 新增
        addMembership(addForm.value).then((res) => {
          if (res.code === '') {
            ElMessage({
              message: '新增成功',
              type: 'success',
            })
          }
          getAll()
          addFormDialog.value = false
        })
      }
    } else {
      return false
    }
  })
}
// 编辑角色
const edit = (row) => {
  addFormDialog.value = true
  isChange.value = false
  getMembershipInfo({ memberId: row.memberId }).then((res) => {
    addForm.value = res.data
  })
}
// 删除权益
const del = async (row) => {
  ElMessageBox.confirm('是否继续删除此权益?', '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning',
  })
    .then(() => {
      delMembership({ memberId: row.memberId }).then((res) => {
        if (res.code === '') {
          ElMessage({
            type: 'success',
            message: '删除成功!',
          })
        }
        getAll()
      })
    })
    .catch(() => {
      return false
    })
}
// 初始化查询所有数据
const getAll = () => {
  tableLoading.value = true
  getMembership(formInline.value).then(res => {
    tableData.value = res.data.list
    total.value = res.data.total
  }).finally(() => {
    tableLoading.value = false
  })
}
</script>

<style lang="scss" scoped>
.userStyle {
  padding: 20px;
  margin-top: 20px;
  background-color: #FFFFFF;
}
</style>

<style>
.avatar-uploader .el-upload {
  border: 1px dashed #d9d9d9;
  border-radius: 6px;
  cursor: pointer;
  position: relative;
  overflow: hidden;
}
.avatar-uploader .el-upload:hover {
  border-color: #409eff;
}
.avatar-uploader-icon {
  font-size: 28px;
  color: #8c939d;
  width: 120px;
  height: 120px;
  line-height: 120px;
  text-align: center;
}
.avatar {
  width: 120px;
  height: 120px;
  display: block;
}
</style>
