<template>
  <div class="couponPage">
    <!-- 搜索 -->
    <div class="formSearch">
      <!-- 搜索条件 -->
      <el-form
        :inline="true"
        :model="query"
      >
        <el-form-item label="活动名称">
          <el-input
            v-model="query.activityName"
            maxlength="20"
            placeholder="请输入活动名称"
          />
        </el-form-item>
        <el-form-item label="活动状态">
          <el-select
            v-model="query.state"
            placeholder="请选择活动状态"
          >
            <el-option
              v-for="item in activityStatusSelect"
              :key="item.index"
              :label="item.label"
              :value="item.value"
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
          <el-button
            type="primary"
            plain
            @click="addActivity"
          >新建活动
          </el-button>
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
        <el-table-column
          label="活动名称"
          width="220"
        >
          <template #default="scope">{{ scope.row.activityName }}</template>
        </el-table-column>
        <el-table-column label="活动状态">
          <template #default="scope">
            <span v-if="scope.row.state == 0">报名未开始</span>
            <span v-if="scope.row.state == 1">报名进行中</span>
            <span v-if="scope.row.state == 2">活动待开始</span>
            <span v-if="scope.row.state == 3">活动进行中</span>
            <span v-if="scope.row.state == 4">活动已结束</span>
          </template>
        </el-table-column>
        <el-table-column
          prop="discountMode"
          label="营销方式"
        >
          <template #default="scope">
            <span v-if="scope.row.discountMode == 1">满减</span>
            <span v-if="scope.row.discountMode == 2">优惠券</span>
          </template>
        </el-table-column>
        <el-table-column
          prop="discountMode"
          label="启动积分兑换"
        >
          <template #default="scope">
            <span v-if="scope.row.ifCredit == 1">是</span>
            <span v-if="scope.row.ifCredit == 0">否</span>
          </template>
        </el-table-column>
        <el-table-column
          prop="credit"
          label="所需积分"
        />
        <el-table-column
          prop="shopNumber"
          label="商家数"
        />
        <el-table-column
          prop="productNumber"
          label="商品数量"
        />
        <el-table-column
          label="操作"
        >
          <template #default="scope">
            <div class="btnList">
              <el-button
                type="primary"
                link
                @click="details(scope.row)"
              >详情
              </el-button>
              <el-button
                v-if="scope.row.state != 4"
                type="primary"
                link
                @click="editActivity(scope.row)"
              >编辑
              </el-button>
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
      <div class="fenye">
        <el-pagination
          :current-page="page.page"
          :page-sizes="[10, 20, 50, 100]"
          :page-size="page.pageSize"
          layout="total, sizes, prev, pager, next, jumper"
          background
          :total="page.total"
          @size-change="handleSizeChange"
          @current-change="handleCurrentChange"
        />
      </div>
    </div>

    <AddActive ref="addActiveRef" @refersh="refersh" />
    <ActivityDetail ref="activityDetailRef" />
  </div>
</template>

<script setup>
import { defineComponent, onBeforeMount, reactive, ref } from 'vue'
import AddActive from '@/views/active/couponlist/couponAdd.vue'
import ActivityDetail from '@/views/active/couponlist/couponDetail.vue'
import { delCoupon, endCoupon, getCouponData, } from '@/api/active/active_coupon.js'

import { activityStatusSelect } from './formate.js'

defineComponent({
  name: 'CouponList'
})

const tableLoading = ref(false)
let query = reactive({
  activityName: '', // 活动名称
  // 活动状态 0-报名未开始 1-报名进行中 2-活动待开始 3-活动进行中 4-活动已结束
  state: '',
})
let page = reactive({
  page: 1,
  pageSize: 10,
  total: 0
})
let tableData = ref([]);
const addActiveRef = ref(false)
const activityDetailRef = ref(false)

function getAll () {
  tableLoading.value = true
  getCouponData(Object.assign({},
    page,
    query,
  )).then(res => {
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

// 重置
function clear () {
  query.activityName = ''
  query.state = ''
  page.page = 1
  page.pageSize = 10
  getAll()
}

// 活动详情
function details (row) {
  activityDetailRef.value.open(row.activityId)
}

// 添加活动
function addActivity () {
  addActiveRef.value.open()
}

// 编辑
function editActivity (row) {
  addActiveRef.value.open(row)
}

function endActivity (row) {
  endCoupon({ activityId: row.activityId }).then(res => {
    if (res.code === '') {
      ElMessage.success('结束成功')
    }
  }).catch(err => {
    ElMessage.error(err.message)
  })
    .finally(() => {
      getAll()
    })
}

function delActivity (row) {
  delCoupon({ activityId: row.activityId }).then(res => {
    if (res.code === '') {
      ElMessage.success('删除成功')
    }
  }).catch(err => {
    ElMessage.error(err.message)
  }).finally(() => {
    getAll()
  })
}

function refersh () {
  getAll()
}

onBeforeMount(() => {
  getAll()
})
</script>

<style
    lang="scss"
    scoped
>
.couponPage {
  padding: 20px;
  margin-top: 20px;
  background-color: #FFFFFF;

  .tableBox {
    .fenye {
      margin-top: 20px;
    }
  }
}

.couponDialogBox {
  max-height: 600px;
  overflow-y: auto;
}
</style>
