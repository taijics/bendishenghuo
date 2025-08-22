<template>
  <div class="history">
    <div class="content">
      <!-- 顶部搜索 -->
      <div class="toolbar formSearch">
        <el-form
          ref="formParamsRef"
          :inline="true"
          :model="formParams"
        >
          <el-form-item label="标题" prop="noticeTitle">
            <el-input
              v-model="formParams.noticeTitle"
              maxlength="20"
              placeholder="请输入标题"
            />
          </el-form-item>
          <el-form-item label="消息类型" prop="noticeType">
            <el-select
              v-model="formParams.noticeType"
              placeholder="请选择消息类型"
            >
              <el-option
                v-for="(item, index) in tipsList"
                :key="index"
                :label="item.name"
                :value="item.id"
              />
            </el-select>
          </el-form-item>
          <el-form-item label="发送时间" prop="dates">
            <el-date-picker
              v-model="formParams.dates"
              type="daterange"
              range-separator="至"
              start-placeholder="开始时间"
              end-placeholder="结束时间"
              value-format="YYYY-MM-DD"
            />
          </el-form-item>

          <el-form-item label-width="0">
            <el-button
              type="primary"
              plain
              @click="search"
            >查询
            </el-button>
            <el-button
              plain
              @click="clear"
            >重置
            </el-button>
          </el-form-item>
        </el-form>
      </div>
      <!-- 表格 -->
      <el-table
        v-loading="tableLoading"
        :data="list"
        border
        :header-cell-style="{ background: '#EEF3FF', color: '#333333' }"
        style="width: 100%"
        class="dataTable"
      >
        <el-table-column
          prop="noticeTitle"
          label="标题"
        />
        <el-table-column
          label="内容"
          :show-overflow-tooltip="true"
        >
          <template #default="scope">
            <span v-html="scope.row.noticeContent"></span>
          </template>
        </el-table-column>
        <el-table-column
          prop="noticeType"
          label="消息类型"
        >
          <template #default="scope">
            <span>{{
              scope.row.noticeType === 1
                ? '系统通知'
                : scope.row.noticeType === 2
                  ? '公告'
                  : scope.row.noticeType === 3
                    ? '站内信'
                    : ''
            }}</span>
          </template>
        </el-table-column>
        <el-table-column
          prop="createTime"
          label="发送时间"
        />
        <el-table-column label="操作">
          <template #default="scope">
            <el-button
              type="primary"
              link
              @click.native.prevent="details(scope.row.noticeId)"
            >详情
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
    </div>
    <!-- 消息详情弹窗 -->
    <el-dialog
      v-model="dialogVisible"
      title="消息详情"
      width="60%"
      :before-close="handleClose"
      modal
    >
      <div>
        <h2 style="text-align: center; font-weight: bold">
          {{ noticeDetails.noticeTitle }}
        </h2>
        <span style="float: right">{{ noticeDetails.createTime }}</span>
        <el-divider />
        <div v-html="noticeDetails.noticeContent"></div>
      </div>
    </el-dialog>
  </div>
</template>

<script setup>
import { noticeDelete, noticeGetAll, noticeGetById } from '@/api/notice'
import { onMounted, ref } from 'vue';

const tableLoading = ref(false)
const list = ref([])
const total = ref(1)
const dialogVisible = ref(false)
const formParams = ref({
  noticeTitle: null,
  noticeType: null,
  dates: [],
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
  }
])
const rules = {
  noticeTitle: [
    { required: true, message: '请输入标题', trigger: 'blur' },
    { min: 1, message: '请输入标题', trigger: 'blur' },
  ],
  noticeType: [
    { required: true, message: '请选择消息类型', trigger: 'change' },
  ]
}
const noticeDetails = ref({
  noticeTitle: '',
  createTime: '',
  noticeContent: '',
})
onMounted(() => {
  getAll()
})

// 历史消息列表
function getAll () {
  tableLoading.value = true
  noticeGetAll(formParams.value).then(res => {
    list.value = res.data.list
    total.value = res.data.total
  }).finally(() => {
    tableLoading.value = false
  })
}

// 消息详情
async function details (id) {
  const res = await noticeGetById({ noticeId: id })
  noticeDetails.value = res.data
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

// 删除消息
async function del (id) {
  const res = await noticeDelete({ noticeId: id })
  if (res.code === '') {
    ElMessage({
      message: '删除成功',
      type: 'success',
    })
    await getAll()
  }
}

// 查询
const formParamsRef = ref()

async function search () {
  formParamsRef.value.validate((valid) => {
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
  formParamsRef.value.resetFields()
  formParams.value.page = 1
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
function handleClose () {
  dialogVisible.value = false
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
}
</style>
<style>
.el-tooltip__popper {
  max-width: 50%;
}
</style>
