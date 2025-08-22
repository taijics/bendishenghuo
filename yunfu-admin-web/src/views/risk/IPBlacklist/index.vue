<template>
  <div class="userStyle">
    <!-- 搜索 -->
    <div class="topSearch">
      <div class="formSearch">
        <el-form
          :inline="true"
          :model="formInline"
        >
          <el-form-item label="ip">
            <el-input
              v-model="formInline.ip"
              maxlength="40"
              clearable
              placeholder="请输入"
              style="width: 200px"
              class="filter-item"
              @keyup.enter.native="search"
            />
          </el-form-item>
          <el-form-item label="状态">
            <el-select
              v-model="formInline.state"
              clearable
              placeholder="请选择"
              class="filter-item"
              style="width: 130px"
            >
              <el-option
                label="有效"
                :value="1"
              />
              <el-option
                label="无效"
                :value="0"
              />
            </el-select>
          </el-form-item>
          <el-form-item>
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
      <div class="rightBTn">
        <el-button
          type="primary"
          @click="add"
        >新增黑名单
        </el-button>
      </div>
    </div>
    <!-- 表格 -->
    <el-table
      v-loading="tableLoading"
      :data="tableData"
      border
      :header-cell-style="{ background: '#EEF3FF', color: '#333333' }"
      tooltip-effect="dark"
      style="width: 100%"
      class="dataTable"
    >
      <el-table-column
        prop="ip"
        label="IP"
      />
      <el-table-column
        prop="createTime"
        label="创建时间"
      >
        <template #default="scope">
          <span>{{ scope.row.createTime }}</span>
        </template>
      </el-table-column>
      <el-table-column
        prop="updateTime"
        label="更新时间"
      >
        <template #default="scope">
          <span>{{ scope.row.updateTime }}</span>
        </template>
      </el-table-column>
      <el-table-column
        label="发布状态"
        align="center"
      >
        <template #default="scope">
          <div @click="toggle(scope.row.id, scope.row.state)">
            <el-tag
              v-if="scope.row.state"
              style="cursor: pointer"
              :type="''"
            >有效
            </el-tag>
            <el-tag
              v-else
              style="cursor: pointer"
              :type="'info'"
            >失效
            </el-tag>
          </div>
        </template>
      </el-table-column>
      <el-table-column
        label="操作"
        width="300"
      >
        <template #default="scope">
          <div class="btnList">
            <el-button
              v-if="scope.row.state"
              size="small"
              type="primary"
              @click="toggle(scope.row.id, scope.row.state)"
            >
              点击无效
            </el-button>
            <el-button
              v-else
              size="small"
              type="primary"
              @click="toggle(scope.row.id, scope.row.state)"
            >
              点击生效
            </el-button>
            <el-popconfirm title="确认删除？" @confirm="del(scope.row.id)">
              <template #reference>
                <el-button type="danger" :icon="ElIconDelete" size="small">删除</el-button>
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
    <AdForm
      ref="adFormRef"
      @reset="getAll"
    />
  </div>
</template>

<script setup>
import { Delete as ElIconDelete } from '@element-plus/icons-vue'
import { delBlack, getIpBlackList, updateBlack } from '@/api/risk'
import AdForm from './form.vue'
import { onMounted, ref } from 'vue';

const formInline = ref({
  page: 1, // 当前页
  pageSize: 10, // 每页记录数
})
const tableLoading = ref(false)
const total = ref(1)
const tableData = ref([])

onMounted(() => {
  getAll()
})

function getAll () {
  tableLoading.value = true
  getIpBlackList(formInline.value).then(res => {
    tableData.value = res.data.list
    total.value = res.data.total
  }).finally(() => {
    tableLoading.value = false
  })
}

// 页码每页页数修改回调
function handleSizeChange (val) {
  formInline.value.pageSize = val
  getAll(formInline.value)
}

function handleCurrentChange (val) {
  formInline.value.page = val
  getAll()
}

// 查询
function search () {
  total.value = 1
  formInline.value.page = 1
  getAll()
}

function clear () {
  formInline.value = {
    ip: '', // 搜索字段
    state: '', // 是否启用 1-是 0-否
    page: 1, // 当前页
    pageSize: 10, // 每页记录数
  }
  getAll()
}

const adFormRef = ref()

function add () {
  adFormRef.value.show()
}

function edit (row) {
  adFormRef.value.show(row)
}

async function del (id) {
  ElMessageBox.confirm('是否确认删除该内容？', '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning',
  })
    .then(() => {
      delBlack({ id }).then((res) => {
        ElMessage({
          type: 'success',
          message: '删除成功!',
        })
        getAll()
      })
    })
    .catch(() => {
      return false
    })
}

function toggle (id, state) {
  ElMessageBox.confirm(
    `${state ? '确定让选择项失效？' : '确定让选择项生效？'}`,
    '提示',
    {
      confirmButtonText: '确认',
      cancelButtonText: '我再想想',
      type: 'warning',
    }
  )
    .then(() => {
      updateBlack({
        id,
        state: state ? 0 : 1,
      }).then(({ data }) => {
        ElMessage({
          type: 'success',
          message: '操作成功!',
        })
        getAll()
      })
    })
    .catch(() => {
    })
}

</script>

<style lang="scss" scoped>
.userStyle {
  padding: 20px;
  margin-top: 20px;
  background-color: #FFFFFF;

  .topSearch {
    display: flex;
    justify-content: space-between;
    //align-items: center;
    .rightBTn {
      .el-button {
        height: 38px;
        margin-bottom: 18px;
      }
    }
  }

  .btnList .el-popover__reference {
    margin-left: 10px;
  }
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
