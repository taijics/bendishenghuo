<template>
  <div class="record">
    <div class="content">
      <!-- 顶部搜索 -->
      <div class="toolbar formSearch">
        <el-form
          ref="formParamsRef"
          :inline="true"
          :model="formParams"
          :rules="rules"
        >
          <el-form-item
            label="用户ID/用户昵称"
            prop="search"
          >
            <el-input
              v-model="formParams.search"
              maxlength="20"
              placeholder="请输入用户ID/用户昵称"
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
      <div class="content_table">
        <div class="table">
          <el-table
            v-loading="loading"
            :data="list"
            border
            :header-cell-style="{ background: '#EEF3FF', color: '#333333' }"
            style="width: 100%"
            class="dataTable"
          >
            <el-table-column
              prop="buyerUserId"
              label="用户ID"
            />
            <el-table-column
              prop="name"
              label="用户昵称"
            />
            <el-table-column
              prop="phone"
              label="用户手机号"
            />
            <el-table-column
              prop="recordContent"
              label="账单标题"
            />
            <el-table-column
              prop="recordType"
              label="类型"
            >
              <template #default="scope">
                <span>{{
                  scope.row.recordType === 1
                    ? '收入'
                    : scope.row.recordType === 2
                      ? '支出'
                      : ''
                }}</span>
              </template>
            </el-table-column>
            <el-table-column
              prop="credit"
              label="数字明细"
            />
            <el-table-column
              prop="remainCredit"
              label="剩余积分"
            />
          </el-table>
        </div>
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
      </div>
    </div>
  </div>
</template>

<script setup>
import { recordGetAll } from '@/api/sign'
import { onMounted, ref } from 'vue';

const loading = ref(false)
const list = ref([])
const total = ref(1)
const formParams = ref({
  page: 1,
  pageSize: 10,
  search: '',
})
const rules = {
  noticeType: [
    { required: true, message: '请选择消息类型', trigger: 'change' },
  ],
}

onMounted(() => {
  getAll()
})

// 历史消息列表
function getAll () {
  loading.value = true
  recordGetAll(formParams.value).then(res => {
    list.value = res.data.list
    total.value = res.data.total
  }).finally(() => {
    loading.value = false
  })
}

const formParamsRef = ref()

// 查询
async function search () {
  formParamsRef.value.validate((valid) => {
    if (valid) {
      total.value = 1
      formParams.value.page = 1
      formParams.value.search = formParams.value.search.trim()
      getAll()
    } else {
      return false
    }
  })
}

// 重置表单
function clear () {
  formParamsRef.value.resetFields()
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
</script>

<style lang="scss" scoped>
.record {
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
