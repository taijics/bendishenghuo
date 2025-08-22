<template>
  <div class="history">
    <el-button
      type="primary"
      @click="add"
    >新建
    </el-button>
    <div style="margin-bottom: 20px;"></div>
    <el-table
      v-loading="loading"
      :data="list"
      border
      :header-cell-style="{ background: '#EEF3FF', color: '#333333' }"
      style="width: 100%"
      class="dataTable"
    >
      <el-table-column
        prop="id"
        label="ID"
      />
      <el-table-column
        prop="day"
        label="第几天"
      />
      <el-table-column
        prop="credit"
        label="获取积分"
      />
      <el-table-column
        prop="sort"
        label="排序"
      />
      <el-table-column label="操作">
        <template #default="scope">
          <el-button
            type="primary"
            link
            @click.native.prevent="details(scope.row)"
          >编辑
          </el-button>
          <el-popconfirm title="确认删除？" @confirm="delMsg(scope.row)">
            <template #reference>
              <el-button type="danger" link>删除</el-button>
            </template>
          </el-popconfirm>
        </template>
      </el-table-column>
    </el-table>
    <!-- 分页 -->
    <div class="fenye">
      <el-pagination
          :current-page="formParams.page"
          :page-sizes="[10, 20, 50, 100]"
          :page-size="formParams.pageSize"
          layout="total, sizes, prev, pager, next, jumper"
          background
          :total="total"
          @size-change="handleSizeChange"
          @current-change="handleCurrentChange"
      />
    </div>
    <!-- 消息详情弹窗 -->
    <el-dialog
      v-model="dialogVisible"
      title="新增"
      width="30%"
      :before-close="handleClose"
      modal
    >
      <el-form
        ref="signFormRef"
        :model="signForm"
        :rules="signRules"
        label-width="100px"
      >
        <el-form-item
          label="第几天"
          prop="day"
        >
          <el-input
            v-model="signForm.day"
            maxlength="9"
          />
        </el-form-item>
        <el-form-item
          label="获取积分"
          prop="credit"
        >
          <el-input
            v-model="signForm.credit"
            maxlength="9"
          />
        </el-form-item>
        <el-form-item
          label="排序"
          prop="sort"
        >
          <el-input
            v-model="signForm.sort"
            maxlength="9"
          />
        </el-form-item>
        <el-form-item
          label="是否显示"
          prop="display"
        >
          <el-radio-group v-model="signForm.display">
            <el-radio :label="1">是</el-radio>
            <el-radio :label="0">否</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item>
          <el-button
            type="primary"
            @click="submitForm('signForm')"
          >确定
          </el-button>
          <el-button @click="close">取消</el-button>
        </el-form-item>
      </el-form>
    </el-dialog>
  </div>
</template>

<script setup>
import { creditSignGetAll, creditSignSave, creditSignUpdate, deleteCreditSign, } from '@/api/sign'
import { onMounted, ref } from 'vue';

const loading = ref(false)
const list = ref([])
const total = ref(1)
const formParams = ref({
  page: 1,
  pageSize: 10,
})
const tipsList = ref([
  {
    id: 1,
    name: '系统消息',
  },
  {
    id: 2,
    name: '公告',
  },
  {
    id: 3,
    name: '站内信',
  },
])
const signForm = ref({
  day: 1,
  credit: 1,
  sort: 1,
  display: 1,
})
const signRules = {
  day: [{ required: true, message: '请输入第几天', trigger: 'blur' }],
  credit: [
    { required: true, message: '请输入获取积分', trigger: 'blur' },
  ],
  sort: [{ required: true, message: '请输入活动名称', trigger: 'blur' }],
  display: [
    { required: true, message: '请选择是否显示', trigger: 'change' },
  ],
}
const dialogVisible = ref(false)
onMounted(() => {
  getAll()
})
// 新增
function add () {
  dialogVisible.value = true
}
// 历史消息列表
function getAll () {
  loading.value = true
  creditSignGetAll(formParams.value).then(res => {
    list.value = res.data.list
    total.value = res.data.total
  }).finally(() => {
    loading.value = false
  })
}

// 消息详情
async function details (item) {
  signForm.value = Object.assign({}, item)
  dialogVisible.value = true
}

// 删除消息提示
async function delMsg (id) {
  ElMessageBox.confirm('此操作将永久删除该消息, 是否继续?', '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning',
  })
    .then(() => {
      del(id)
    })
    .catch(() => {})
}
// 删除积分配置
async function del (id) {
  const res = await deleteCreditSign({ id })
  if (res.code === '') {
    ElMessage({
      message: '删除成功',
      type: 'success',
    })
    getAll()
  }
}
// 查询
async function search () {
  signFormRef.value.validate((valid) => {
    if (valid) {
      total.value = 1
      formParams.value.page = 1
      getAll()
    } else {
      return false
    }
  })
}

// 重置表单
function clear () {
  signFormRef.value.resetFields()
  getAll()
}
// 更改页数
function handleSizeChange (val) {
  formParams.value.pageSize = val
  getAll()
}
// 翻页
function handleCurrentChange (val) {
  formParams.value.page = val
  getAll()
}

// 关闭消息详情
async function handleClose () {
  dialogVisible.value = false
}
const signFormRef = ref()
function submitForm () {
  signFormRef.value.validate((valid) => {
    if (valid) {
      if (signForm.value.id) {
        creditSignUpdate(signForm.value).then((res) => {
          if (res.code === '') {
            ElMessage({
              message: '修改成功',
              type: 'success',
            })
            getAll()
            dialogVisible.value = false
          }
        })
      } else {
        creditSignSave(signForm.value).then((res) => {
          if (res.code === '') {
            ElMessage({
              message: '新增成功',
              type: 'success',
            })
            getAll()
            dialogVisible.value = false
          }
        })
      }
    } else {
      return false
    }
  })
}

function close () {
  dialogVisible.value = false
  signForm.value = {
    day: 1,
    credit: 1,
    sort: 1,
    display: 1,
  }
}

</script>
<style lang="scss" scoped>
.history {
  padding: 20px;
  margin-top: 20px;
  background-color: #FFFFFF;
  :deep(.el-table) {
    .cell.el-tooltip img {
      max-height: 100px;

    }
  }
  .fenye {
    margin-top: 20px;
  }
}
</style>
