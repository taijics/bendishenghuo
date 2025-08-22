<template>
  <div class="miaoshaPage">
    <!-- 搜索 -->
    <div class="formSearch">
      <!-- 搜索条件 -->
      <el-form :inline="true" :model="query">
        <el-form-item label="活动名称">
          <el-input
            v-model="query.seckillName"
            maxlength="20"
            placeholder="请输入活动名称"
          />
        </el-form-item>
        <el-form-item label="活动状态">
          <el-select v-model="query.state" placeholder="请选择活动状态">
            <el-option
              v-for="item in activityStatusSelect"
              :key="item.index"
              :label="item.label"
              :value="item.value"
            />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" plain @click="search">查询</el-button>
          <el-button plain @click="clear">重置</el-button>
          <el-button
            type="primary"
            plain
            @click="addActivity"
          >新建活动</el-button>
        </el-form-item>
      </el-form>
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
      <el-table-column prop="seckillName" label="活动名称" width="220" />
      <el-table-column prop="content" label="活动内容" align="center" />
      <!-- <el-table-column label="营销方式">
            <template #default="scope">
              <span v-if="scope.row.discountMode == 1">满减</span>
              <span v-if="scope.row.discountMode == 2">优惠券</span>
            </template>
          </el-table-column> -->
      <el-table-column label="报名时间" align="center">
        <template #default="scope">
          <span>{{ scope.row.signTime }}</span>
        </template>
      </el-table-column>
      <el-table-column label="起止时间" align="center">
        <template #default="scope">
          <span>{{ scope.row.time }}</span>
        </template>
      </el-table-column>
      <el-table-column prop="shops" label="商家数" align="center" />
      <el-table-column prop="products" label="商品数量" align="center" />
      <el-table-column label="活动状态" align="center">
        <template #default="scope">
          <span>{{ seckillTimeStatus(scope.row.state) }}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center">
        <template #default="scope">
          <div class="btnList">
            <el-button
              type="primary"
              link
              @click="handleDetail(scope.row)"
            >详情</el-button>
            <el-button
              v-if="scope.row.state != 4"
              type="primary"
              link
              @click="editActivity(scope.row)"
            >编辑</el-button>
            <el-popconfirm v-if="scope.row.state !== 4" title="确认结束？" @confirm="endActivity(scope.row)">
              <template #reference>
                <el-button type="danger" link>结束</el-button>
              </template>
            </el-popconfirm>
            <el-popconfirm v-if="scope.row.state === 4" title="确认删除？" @confirm="delActivity(scope.row)">
              <template #reference>
                <el-button type="danger" link>删除</el-button>
              </template>
            </el-popconfirm>
          </div>
        </template>
      </el-table-column>
    </el-table>
    <el-pagination
      :hide-on-single-page="true"
      :current-page="page.page"
      :page-sizes="[10, 20, 50, 100]"
      :page-size="page.pageSize"
      layout="total, sizes, prev, pager, next, jumper"
      background
      :total="page.total"
      style="margin: 12px 0"
      @size-change="handleSizeChange"
      @current-change="handleCurrentChange"
    />
    <AddActive ref="addActiveRef" @refersh="refersh" />
    <ActivityDetail ref="activityDetailRef" />
  </div>
</template>

<script setup>
import { activityStatusSelect, seckillTimeStatus } from './formate.js'
import AddActive from '@/views/active/seckilllist/seckillAdd.vue'
import ActivityDetail from '@/views/active/seckilllist/seckillDetail.vue'
import {
  getSeckillData,
  endSeckillData,
  delSeckillData,
} from '@/api/active/active_seckill.js'
import { onBeforeMount, reactive, ref } from 'vue'

let tableLoading = ref(false)
let page = reactive({
  page: 1,
  pageSize: 10,
  total: 0
})
let query = reactive({
  seckillName: '', // 活动名称
  // 活动状态 0-报名未开始 1-报名进行中 2-活动待开始 3-活动进行中 4-活动已结束
  state: '',
})
let tableData = ref([])
const addActiveRef = ref(null)
const activityDetailRef = ref(null)

function getAll () {
  tableLoading.value = true
  getSeckillData({
    page: page.page,
    pageSize: page.pageSize,
    seckillName: query.seckillName,
    state: query.state
  }).then(res => {
    tableData.value = res.data.list
    page.total = res.data.total
  }).finally(() => {
    tableLoading.value = false
  })
}
function handleSizeChange (val) {
  page.pageSize = val
  getAll()
}
function handleCurrentChange (val) {
  page.page = val
  getAll()
}
function search () {
  page.page = 1
  getAll()
}
function clear () {
  query.seckillName = ''
  query.state = ''
  page.page = 1
  page.pageSize = 10
  getAll()
}
function handleDetail (row) {
  activityDetailRef.value.open(row.seckillId)
}
// 添加活动
function addActivity () {
  addActiveRef.value.open()
}
// 编辑活动
function editActivity (row) {
  addActiveRef.value.open(row)
}
function endActivity (row) {
  endSeckillData({ seckillId: row.seckillId }).then(res => {
    if (res.code === '') {
      ElMessage.success('结束成功')
      getAll()
    }
  })
}
function delActivity (row) {
  delSeckillData({ seckillId: row.seckillId }).then(res => {
    if (res.code === '') {
      ElMessage.success('删除成功')
      getAll()
    }
  })
}
function refersh () {
  getAll()
}
onBeforeMount(() => {
  getAll()
})
</script>
<style lang="scss" scoped>
.miaoshaPage {
  padding: 20px;
  margin-top: 20px;
  background-color: #FFFFFF;
}
</style>
