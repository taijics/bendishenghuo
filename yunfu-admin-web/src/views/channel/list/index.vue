<template>
  <div class="content">
    <div class="formSearch">
      <el-button
        type="primary"
        @click="handleEditForm"
      >新增
      </el-button>
    </div>
    <el-table
      v-loading="tableLoading"
      class="table dataTable"
      stripe
      border
      :header-cell-style="tableOptions.headStyle"
      :data="list"
    >
      <el-table-column
        type="selection"
        align="center"
        width="55"
      />
      <el-table-column
        prop="id"
        align="center"
        label="渠道ID"
        show-overflow-tooltip
      />
      <el-table-column
        prop="channelName"
        align="center"
        label="渠道名称"
        show-overflow-tooltip
      />
      <el-table-column
        prop="registerUrl"
        align="center"
        label="渠道注册链接"
        show-overflow-tooltip
      >
        <template #default="scope">
          <span v-if="scope.row.registerUrl">{{ scope.row.registerUrl }} </span>
          <span v-else>-</span>
        </template>
      </el-table-column>
      <el-table-column
        prop="channelCode"
        align="center"
        label="渠道码"
        width="130"
        show-overflow-tooltip
      />
      <el-table-column
        prop="registerCount"
        label="渠道注册人数"
        align="center"
        width="130"
        show-overflow-tooltip
      />
      <el-table-column
        prop="orderUserCount"
        label="渠道下单人数"
        width="130"
        align="center"
        show-overflow-tooltip
      />
      <el-table-column
        prop="orderCount"
        label="渠道下单笔数"
        width="130"
        align="center"
        show-overflow-tooltip
      />
      <el-table-column
        prop="orderAmount"
        align="center"
        label="渠道下单总金额"
        width="130"
        show-overflow-tooltip
      />
      <el-table-column
        align="center"
        label="操作"
        width="260"
        fixed="right"
      >
        <template #default="scope">
          <el-button
            size="small"
            type="primary"
            @click="handleCopeLink(scope.row)"
          >复制链接
          </el-button>
          <el-button
            size="small"
            type="warning"
            @click="handleEditForm(scope.row)"
          >编辑
          </el-button>
          <el-popconfirm title="确认删除？" @confirm="handleDelete(scope.row)">
            <template #reference>
              <el-button type="danger" :icon="ElIconDelete" size="small">删除</el-button>
            </template>
          </el-popconfirm>
        </template>
      </el-table-column>
    </el-table>
    <!-- 分页 -->
    <el-pagination
      background
      layout="total, sizes, prev, pager, next, jumper"
      :current-page="queryOptions.page"
      :page-size="queryOptions.pageSize"
      :page-sizes="tableOptions.pageSizes"
      :total="tableOptions.total"
      @size-change="(val) => handlePageChange(val, 1)"
      @current-change="(val) => handlePageChange(val, 2)"
    />
    <!--  表单  -->
    <ChannelForm
      v-model:show="showForm"
      :item="formItem"
      @confirm="handleResetTable"
      @cancel="handleResetTable"
    />
  </div>
</template>

<script setup>
import ChannelForm from './form.vue'
import { del, getList } from '@/api/channel'
import { onMounted, ref } from 'vue';

const showForm = ref(false)
const formItem = ref({})
const tableLoading = ref(false)
const list = ref([])
const queryOptions = ref({
  page: 1,
  pageSize: 10,
})
const tableOptions = ref({
  headStyle: { background: '#EEF3FF', color: '#333333' },
  pageSizes: [5, 10, 30, 50, 100],
  total: 0,
})

onMounted(() => {
  handleGetTable()
})

function handleResetTable () {
  queryOptions.value.page = 1
  handleGetTable()
}

function handleGetTable () {
  tableLoading.value = true
  getList(queryOptions.value).then(res => {
    list.value = res.data.list
    tableOptions.value.total = res.data.total
  }).finally(() => {
    tableLoading.value = false
  })
}

/**
 * 分页
 * @param val
 * @param type 1page 2pageSize
 */
function handlePageChange (val, type) {
  type === 1
    ? (queryOptions.value.page = val)
    : (queryOptions.value.pageSize = val)
  handleGetTable()
}

function handleEditForm (item) {
  if (!item) {
    formItem.value = {}
  } else {
    formItem.value = item
  }
  showForm.value = true
}

function handleCopeLink (item) {
  const htmlInputElement = document.createElement('input')
  htmlInputElement.value = item.registerUrl
  document.body.appendChild(htmlInputElement)
  htmlInputElement.select()
  document.execCommand('copy')
  document.body.removeChild(htmlInputElement)
  ElMessage.success('复制成功')
}

function handleDelete (item) {
  ElMessageBox.confirm(
    `是否删除渠道${item.channelName}`,
    '警告',
    {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning',
    }
  )
    .then(async () => {
      // 删除逻辑
      try {
        await del({ id: item.id, channelName: item.channelName })
        ElMessage({
          type: 'success',
          message: '删除成功!',
        })
      } catch (e) {
        console.log(e)
      }
    })
    .catch(() => {
    })
    .finally(() => {
      handleGetTable()
    })
}

</script>

<style lang="scss" scoped>
.content {
  padding: 20px;
  margin-top: 20px;
  box-sizing: border-box;
  background-color: #FFFFFF;
  .table {
    margin: 20px 0;
  }
}
</style>
