<template>
  <div class="userStyle">
    <!-- 搜索 -->
    <div class="topSearch">
      <div class="formSearch">
        <el-form :inline="true" :model="formInline">
          <el-form-item label="广告名称">
            <el-input
              v-model="formInline.name"
              maxlength="20"
              placeholder="请输入广告名称"
            />
          </el-form-item>
          <el-form-item label="广告状态">
            <el-select v-model="formInline.state" placeholder="请选择广告状态">
              <el-option label="有效" :value="1" />
              <el-option label="无效" :value="0" />
            </el-select>
          </el-form-item>
          <el-form-item>
            <el-button type="primary" plain @click="search">查询</el-button>
            <el-button plain @click="clear">重置</el-button>
          </el-form-item>
        </el-form>
      </div>
      <div class="rightBTn">
        <el-button type="primary" @click="add">新增广告</el-button>
      </div>
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
        <el-table-column prop="id" label="广告id" />
        <el-table-column prop="popupImg" label="广告图片">
          <template #default="scope">
            <a
              :href="scope.row.popupImg"
              style="color: #42b983"
              target="_blank"
            ><img
              :src="scope.row.popupImg"
              alt="点击打开"
              class="el-avatar"
            /></a>
          </template>
        </el-table-column>
        <el-table-column prop="name" label="广告名称" />
        <el-table-column label="跳转类型" align="center">
          <template #default="scope">
            <span v-if="scope.row.jumpType === 0">不跳转</span>
            <span v-if="scope.row.jumpType === 1">商品</span>
            <span v-if="scope.row.jumpType === 2">分类</span>
            <span v-if="scope.row.jumpType === 3">平台券</span>
            <span v-if="scope.row.jumpType === 4">跳转小程序</span>
            <span v-if="scope.row.jumpType === 5">公众号文章</span>
          </template>
        </el-table-column>
        <el-table-column prop="startTime" label="启用时间">
          <template #default="scope">
            <span>{{ scope.row.startTime }}</span>
          </template>
        </el-table-column>
        <el-table-column prop="endTime" label="结束时间">
          <template #default="scope">
            <span>{{ scope.row.endTime }}</span>
          </template>
        </el-table-column>
        <el-table-column label="发布状态" align="center">
          <template #default="scope">
            <div @click="onSale(scope.row.id, scope.row.status)">
              <el-tag
                v-if="scope.row.state === 1"
                style="cursor: pointer"
                :type="''"
              >有效</el-tag>
              <el-tag
                v-else
                style="cursor: pointer"
                :type="'info'"
              >无效</el-tag>
            </div>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="300">
          <template #default="scope">
            <div class="btnList">
              <el-button
                v-if="scope.row.state === 1"
                size="small"
                type="primary"
                @click="onSale(scope.row.id, scope.row.state)"
              >
                下架
              </el-button>
              <el-button
                v-else
                size="small"
                type="primary"
                @click="onSale(scope.row.id, scope.row.state)"
              >
                上架
              </el-button>
              <!-- <el-button
                v-if="scope.row.state === 1"
                size="small"
                type="primary"
                :icon="View"
                @click="view(scope.row)"
              >
                查看
              </el-button> -->
              <el-button
                size="small"
                type="primary"
                :icon="Edit"
                @click="edit(scope.row)"
              >
                编辑
              </el-button>
              <el-popconfirm title="确认删除？" @confirm="handleDel(scope.row.id)">
                <template #reference>
                  <el-button type="danger" :icon="Delete">删除</el-button>
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
    <AdForm ref="adForm" @reset="getAll" />
    <AdDetail ref="adDetail" />
  </div>
</template>

<script setup>
import { Delete, Edit } from '@element-plus/icons-vue'
import { getList, del, toggle } from '@/api/advert'

import AdForm from './form.vue'
import AdDetail from './detail.vue'
import { onMounted, ref } from 'vue'
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
// 初始化查询列表数据
function getAll () {
  tableLoading.value = true
  getList(formInline.value).then(res => {
    tableData.value = res.data.list
    total.value = res.data.total
  }).finally(() => {
    tableLoading.value = false
  })
}
function handleSizeChange (val) {
  formInline.value.pageSize = val
  getAll(formInline.value)
}
function handleCurrentChange (val) {
  formInline.value.page = val
  getAll()
}
function search () {
  total.value = 1
  formInline.value.page = 1
  getAll()
}
function clear () {
  formInline.value = {
    name: '', // 搜索字段
    state: '', // 是否启用 1-是 0-否
    page: 1, // 当前页
    pageSize: 10, // 每页记录数
  }
  getAll()
}
const adForm = ref()
function add () {
  adForm.value.show()
}
function edit (row) {
  adForm.value.show(row)
}
const adDetail = ref()
function view (row) {
  adDetail.value.show(row)
}
async function handleDel (id) {
  ElMessageBox.confirm('是否确认删除该内容？', '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning',
  })
    .then(() => {
      del({ id }).then((res) => {
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
function onSale (id, state) {
  ElMessageBox.confirm(
    `${state ? '确定让选择广告失效？' : '确定让选择广告生效？'}`,
    '提示',
    {
      confirmButtonText: '确认',
      cancelButtonText: '我再想想',
      type: 'warning',
    }
  )
    .then(() => {
      toggle({
        id,
        state: state === 0 ? 1 : 0,
      }).then(({ data }) => {
        ElMessage({
          type: 'success',
          message: '操作成功!',
        })
        getAll()
      })
    })
    .catch(() => {})
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
