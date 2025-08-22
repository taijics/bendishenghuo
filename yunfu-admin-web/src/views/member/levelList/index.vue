<template>
  <div class="userStyle">
    <!-- 搜索 -->
    <div class="formSearch">
      <el-form :inline="true" :model="formInline">
        <el-form-item>
          <el-button type="primary" @click="add">新增会员等级</el-button>
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
        <el-table-column prop="memberLevelName" label="会员等级" />
        <el-table-column prop="growth" label="成长值" />
        <el-table-column label="等级图标" width="140" align="center">
          <template #default="scope">
            <el-image
              style="width: 80px; height: 80px"
              :src="scope.row.memberLevelIcon"
              fit="contain"
            />
          </template>
        </el-table-column>
        <el-table-column label="等级背景" width="140" align="center">
          <template #default="scope">
            <el-image
              style="width: 80px; height: 80px"
              :src="scope.row.memberLevelBackground"
              fit="contain"
            />
          </template>
        </el-table-column>
        <el-table-column prop="memberLevelReason" label="等级说明" />
        <el-table-column prop="memberIds" label="等级权益" />
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
      <div class="fenye">
        <el-pagination
          :current-page="formInline.page"
          :page-sizes="[10, 20, 50, 100]"
          :page-size="formInline.pageSize"
          layout="total, sizes, prev, pager, next, jumper"
          background
          :total="total"
          @size-change="handleSizeChange"
          @current-change="handleCurrentChange"
        />
      </div>
    </div>

    <!-- *************对话框开始************* -->
    <!-- 新增权益 -->
    <el-dialog
      v-model="addFormDialog"
      :title="userState ? '新增会员等级' : '修改会员等级'"
      width="30%"
      center
      :close-on-click-modal="false"
    >
      <!-- 新增权益 -->
      <div>
        <el-form
          ref="formRef"
          :model="addForm"
          label-width="80px"
          :rules="levelRules"
        >
          <el-form-item label="等级名称" prop="memberLevelName">
            <el-input
              v-model="addForm.memberLevelName"
              maxlength="20"
              placeholder="请输入会员等级名称"
            />
          </el-form-item>
          <el-form-item label="成长值" prop="growth">
            <el-input
              v-model="addForm.growth"
              maxlength="9"
              placeholder="请输入会员成长值"
              oninput="value=value.replace(/[^\d]/g,'')"
            />
          </el-form-item>
          <el-form-item label="等级图标" prop="memberLevelIcon">
            <el-upload
              class="avatar-uploader"
              :action="action"
              :show-file-list="false"
              :on-success="handleIconSuccess"
            >
              <img
                v-if="addForm.memberLevelIcon"
                :src="addForm.memberLevelIcon"
                class="avatar"
              />
              <el-icon v-else class="avatar-uploader-icon"><Plus /></el-icon>
            </el-upload>
            <p class="formInfo">建议尺寸：100*100像素，jpg、png图片类型</p>
          </el-form-item>
          <el-form-item label="等级背景" prop="memberLevelBackground">
            <el-upload
              class="avatar-uploader"
              :action="action"
              :show-file-list="false"
              :on-success="handleBgSuccess"
            >
              <img
                v-if="addForm.memberLevelBackground"
                :src="addForm.memberLevelBackground"
                class="avatar"
              />
              <el-icon v-else class="avatar-uploader-icon"><Plus /></el-icon>
            </el-upload>
            <p class="formInfo">建议尺寸：100*100像素，jpg、png图片类型</p>
          </el-form-item>
          <el-form-item class="inputWide" label="等级权益" prop="ids">
            <el-select
              v-model="addForm.ids"
              multiple
              collapse-tags
              placeholder="请选择"
            >
              <el-option
                v-for="item in tagList"
                :key="item.memberId"
                :label="item.memberName"
                :value="item.memberId"
              />
            </el-select>
          </el-form-item>
          <el-form-item label="等级说明" prop="memberLevelReason">
            <el-input
              v-model="addForm.memberLevelReason"
              maxlength="200"
              type="textarea"
              placeholder="请输入等级说明"
            />
          </el-form-item>
        </el-form>
      </div>
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
  getMembership,
  // delMembership,
  getMemberlevel,
  getLevelInfo,
  updateLevel,
  addLevel,
  deleteLevel,
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
const checkStrictly = ref(true)
const action = ref(uploadUrl)
const addForm = ref({
  growth: null,
  ids: [],
  memberLevelBackground: '',
  memberLevelIcon: '',
  memberLevelName: '',
  memberLevelReason: ''
})
const equity = ref({
  page: 1, // 当前页
  pageSize: 1000 // 每页记录数
})
const tagList = ref([])
const addFormDialog = ref(false)
const levelRules = ref({
  memberLevelName: [
    { required: true, message: '请输入权益名称', trigger: 'blur' }
  ],
  memberLevelReason: [
    { required: true, message: '请输等级说明', trigger: 'blur' }
  ],
  growth: [
    { required: true, message: '请输入会员成长值', trigger: 'blur' }
  ],
  memberLevelIcon: [{ required: true }],
  memberLevelBackground: [{ required: true }],
  ids: [{ required: true }]
})
const roleId = ref(null)
const imageUrl = ref('')

onBeforeMount(() => {
  getAll()
  getTagList()
})

// 获取权益
const getTagList = async () => {
  const res = await getMembership(equity.value)
  if (res.code === '') {
    tagList.value = res.data.list
  } else {
    ElMessage({
      message: res.message,
      type: 'error',
    })
  }
}
const handleIconSuccess = (response) => {
  const { url } = response.data
  addForm.value.memberLevelIcon = url
}
const handleBgSuccess = (response) => {
  const { url } = response.data
  addForm.value.memberLevelBackground = url
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
    pageSize: 10, // 每页记录数
  }
  getAll()
}
// 新增会员等级
const add = () => {
  userState.value = 1
  addFormDialog.value = true
  addForm.value = {
    growth: null,
    ids: [],
    memberLevelBackground: '',
    memberLevelIcon: '',
    memberLevelName: '',
    memberLevelReason: ''
  }
}
// 确认新增会员
const addForm_enter = async (formEl) => {
  if (!formEl) return
  await formEl.validate((valid) => {
    if (valid) {
      // 修改
      if (userState.value === 2) {
        updateLevel(addForm.value).then((res) => {
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
        addForm.value.growth = parseInt(addForm.value.growth)
        addLevel(addForm.value).then((res) => {
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
// 编辑等级信息
const edit = (row) => {
  addFormDialog.value = true
  userState.value = 2
  getLevelInfo({ memberLevelId: row.memberLevelId }).then((res) => {
    addForm.value = res.data
    delete addForm.value.memberIds
    addForm.value.ids = addForm.value.ids.map((v) => parseInt(v))
  })
}
// 删除该等级
const del = async (row) => {
  ElMessageBox.confirm('是否继续删除此等级?', '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning',
  })
    .then(() => {
      deleteLevel({ memberLevelId: row.memberLevelId }).then((res) => {
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
  getMemberlevel(formInline.value).then(res => {
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
.formInfo {
  line-height: 0px;
  color: #999999;
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
  width: 100px;
  height: 100px;
  line-height: 100px;
  text-align: center;
}
.avatar {
  width: 100px;
  height: 100px;
  display: block;
}
</style>
