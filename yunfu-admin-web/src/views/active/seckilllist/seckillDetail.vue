<template>
  <el-dialog
    v-model="activityVisible"
    title="秒杀活动详情"
    width="74%"
    center
    :close-on-click-modal="false"
  >
    <div class="pending">
      <el-tabs v-model="tabs.activeName">
        <el-tab-pane label="活动信息" name="first">
          <div class="shop_info">
            <h3 class="detail_title">活动信息</h3>
            <div class="shopInfo_left">
              <p class="detail_text">
                <span>活动名称：</span>
                <span class="text">{{ activityForm.seckillName }}</span>
              </p>
              <p class="detail_text">
                <span>活动介绍：</span>
                <span class="text">{{ activityForm.remark }}</span>
              </p>
              <p class="detail_text">
                <span>报名时间：</span>
                <span class="text">{{ activityForm.signStartTime }}-{{ activityForm.signEndTime }}</span>
              </p>
              <p class="detail_text">
                <span>起止时间：</span>
                <span class="text">{{ activityForm.startTime }}-{{ activityForm.endTime }}</span>
              </p>
              <p class="detail_text">
                <span>活动保证金：</span>
                <span class="text textColor">
                  <el-radio-group v-model="activityForm.ifBond">
                    <el-radio :label="1" disabled>需要</el-radio>
                    <el-radio :label="0" disabled>不需要</el-radio>
                  </el-radio-group>
                </span>
              </p>
              <p v-if="activityForm.ifBond" class="detail_text">
                <span>保证金金额：</span>
                <span class="text">{{ activityForm.bondMoney }}</span>
              </p>
              <p class="detail_text">
                <span>活动状态：</span>
                <span class="text">{{ seckillTimeStatus(activityForm.state) }}</span>
              </p>
            </div>
          </div>
          <div class="shop_info">
            <h3 class="detail_title">优惠规则</h3>
            <p class="detail_text">
              <span>优惠方案：</span>
              <span class="text">直降{{ activityForm.seckillMoney }}元</span>
            </p>
            <p class="detail_text">
              <span>是否限购：</span>
              <span class="text textColor">
                <el-radio-group v-model="activityForm.ifLimit">
                  <el-radio :label="2" disabled>限购</el-radio>
                  <el-radio :label="1" disabled>不限购</el-radio>
                </el-radio-group>
              </span>
            </p>
            <p v-if="activityForm.ifLimit == 2" class="detail_text">
              <span>商品限购：</span>
              <span class="text">限购{{ activityForm.limitNumber || 0 }}人</span>
            </p>
            <p class="detail_text">
              <span>优惠券叠加：</span>
              <span class="text textColor">
                <el-radio-group v-model="activityForm.ifAdd">
                  <el-radio :label="1" disabled>叠加</el-radio>
                  <el-radio :label="0" disabled>不叠加</el-radio>
                </el-radio-group>
              </span>
            </p>
          </div>
        </el-tab-pane>
        <el-tab-pane label="参与店铺" name="second">
          <!-- 搜索 -->
          <div class="formSearch">
            <el-form
              :inline="true"
              :model="query"
            >
              <el-form-item label="店铺名称">
                <el-input
                  v-model="query.shopName"
                  maxlength="20"
                  placeholder="请输入店铺名称"
                />
              </el-form-item>
              <el-form-item label="店铺编码">
                <el-input
                  v-model="query.shopCode"
                  maxlength="20"
                  placeholder="请输入店铺编码"
                />
              </el-form-item>
              <el-form-item label="审核状态">
                <el-select
                  v-model="query.state"
                  clearable
                  placeholder="请选择审核状态"
                >
                  <el-option label="待审核" value="0" />
                  <el-option label="报名成功" value="1" />
                  <el-option label="报名失败" value="2" />
                  <el-option label="报名进行中" value="3" />
                </el-select>
              </el-form-item>

              <el-form-item>
                <el-button type="primary" plain @click="search">查询</el-button>
              </el-form-item>
            </el-form>
          </div>
          <!-- 表格 -->
          <div class="tableBox">
            <el-table
              :data="shopTableData"
              border
              :header-cell-style="{
                background: '#EEF3FF', color: '#333333'
              }"
              tooltip-effect="dark"
              style="width: 100%"
            >
              <el-table-column label="店铺名称" width="220">
                <template #default="scope">
                  {{ scope.row.shopName }}
                </template>
              </el-table-column>
              <el-table-column prop="shopCode" label="店铺编码" />
              <el-table-column prop="products" label="参与商品数" />
              <el-table-column prop="examines" label="审核次数" />
              <el-table-column label="审核状态">
                <template #default="scope">
                  <span v-if="scope.row.state == 0">待审核</span>
                  <span v-if="scope.row.state == 1">报名成功</span>
                  <span v-if="scope.row.state == 2">报名失败</span>
                </template>
              </el-table-column>
              <el-table-column label="操作" show-overflow-tooltip>
                <template #default="scope">
                  <div class="btnList">
                    <el-button
                      type="primary"
                      link
                      @click="seeMore(scope.row)"
                    >查看商品</el-button>
                    <el-button
                      type="primary"
                      link
                      @click="checkList(scope.row)"
                    >审核记录</el-button>
                    <el-button
                      v-if="scope.row.state === 0"
                      type="primary"
                      link
                      @click="examine(scope.row)"
                    >审核</el-button>

                    <el-button
                      v-if="scope.row.state === 1"
                      type="primary"
                      link
                      @click="liquidation(scope.row)"
                    >清退</el-button>
                  </div>
                </template>
              </el-table-column>
            </el-table>
            <el-pagination
              :current-page="page.page"
              :page-sizes="[10, 20, 50, 100]"
              :page-size="10"
              layout="total, sizes, prev, pager, next, jumper"
              :total="page.total"
              style="margin: 12px 0;"
              @size-change="handleSizeChange"
              @current-change="handleCurrentChange"
            />
          </div>
        </el-tab-pane>
        <el-tab-pane label="活动数据" name="chart">
          <!-- <List :listdata="chartData" /> -->
          <DetailComponent :info-list="infoList" @export="exportData">
            <template #table>
              <div class="table">
                <el-table
                  :data="activityTableData"
                  border
                  :header-cell-style="{
                    background: '#EEF3FF',
                    color: '#333333',
                  }"
                  style="width: 100%"
                >
                  >
                  <el-table-column prop="shopName" label="店铺名称" />
                  <el-table-column prop="shopCode" label="店铺编码" />
                  <el-table-column prop="products" label="参与商品数(件)" />
                  <el-table-column prop="persons" label="访客数" />
                  <el-table-column prop="orders" label="提交订单数" />
                  <el-table-column prop="finish" label="成交比数" />
                  <!-- <el-table-column prop="price" label="客单价(元)" /> -->
                  <el-table-column prop="total" label="成交总额" />
                </el-table>
                <el-pagination
                  :current-page="activityPage.page"
                  :page-sizes="[10, 20, 50, 100]"
                  :page-size="activityPage.pageSize"
                  layout="total, sizes, prev, pager, next, jumper"
                  :total="activityPage.total"
                  style="margin: 12px 0;"
                  @size-change="changePageChartSize"
                  @current-change="changeChartPage"
                />
              </div>
            </template>
          </DetailComponent>
        </el-tab-pane>
      </el-tabs>
    </div>

    <!-- ******************************************************弹框开始***************************************************************** -->
    <!-- 审核记录弹框 -->
    <el-dialog
      v-model="visible.check"
      title="审核记录"
      center
      width="30%"
      :close-on-click-modal="false"
      :modal-append-to-body="false"
      :modal="false"
    >
      <div class="diaddStyle">
        <el-table
          :data="checkTableData"
          border
          :header-cell-style="{ background: '#EEF3FF', color: '#333333' }"
          tooltip-effect="dark"
          style="width: 100%"
        >
          <el-table-column label="动态" width="220">
            <template #default="scope">{{
              scope.row.operationDescribtion
            }}</template>
          </el-table-column>
          <el-table-column prop="createTime" label="时间" />
          <el-table-column prop="name" label="操作人" />
          <el-table-column prop="remark" label="其他信息" />
        </el-table>
      </div>
      <template #footer>
        <span class="dialog-footer">
          <el-button type="primary" @click="visible.check = false">确定</el-button>
        </span>
      </template>
    </el-dialog>

    <!-- 活动商品记录弹框 -->
    <el-dialog
      v-model="visible.activityProduct"
      title="活动商品"
      center
      width="70%"
      :close-on-click-modal="false"
      :modal-append-to-body="false"
      :modal="false"
    >
      <el-table
        :data="shopRecordTableData"
        border
        :header-cell-style="{ background: '#EEF3FF', color: '#333333' }"
        tooltip-effect="dark"
        style="width: 100%"
      >
        <el-table-column label="产品主图" width="220">
          <template #default="scope">
            <img :src="scope.row.image" width="50" height="50" alt srcset />
          </template>
        </el-table-column>
        <el-table-column prop="productName" label="产品名称" />
        <el-table-column prop="productId" label="产品id" />
        <el-table-column prop="price" label="售价(元)" />
        <el-table-column prop="originalPrice" label="原价(元)" />
        <el-table-column prop="stockNumber" label="库存(件)" />
        <el-table-column prop="volume" label="累计销量(件)" />
        <el-table-column label="上架状态">
          <template #default="scope">
            <span v-if="scope.row.shelveState == 1">上架</span>
            <span v-if="scope.row.shelveState == 0">下架</span>
          </template>
        </el-table-column>
      </el-table>
      <el-pagination
        :current-page="shopPage.page"
        :page-sizes="[10, 20, 50, 100]"
        :page-size="shopPage.pageSize"
        layout="total, prev, pager, next, jumper"
        :total="shopPage.total"
        style="margin: 12px 0;"
        @size-change="handleSizeChanges"
        @current-change="handleCurrentChanges"
      />
      <template #footer>
        <span class="dialog-footer">
          <el-button type="primary" @click="visible.activityProduct = false">确定</el-button>
        </span>
      </template>
    </el-dialog>

    <!-- 审核清退 -->
    <el-dialog
      v-model="checkObj.show"
      append-to-body
      :title="checkObj.title"
      center
      width="30%"
      :close-on-click-modal="false"
    >
      <div v-if="checkObj.type === 1" class="diaddStyle">
        <el-form
          ref="form"
          :model="checkForm"
          label-width="80px"
        >
          <el-form-item label="审核状态">
            <el-radio-group v-model="checkForm.state">
              <el-radio label="1">报名成功</el-radio>
              <el-radio label="2">报名失败</el-radio>
            </el-radio-group>
          </el-form-item>
          <el-form-item label="备注">
            <el-input
              v-model="checkForm.remark"
              maxlength="200"
              type="textarea"
            />
          </el-form-item>
        </el-form>
      </div>
      <div v-else class="diaddStyle">
        <div class="text">确认要清退本商家吗？</div>
        <div class="text">清退后商家的所有商品将退出本次活动</div>
      </div>
      <template #footer>
        <span class="dialog-footer">
          <el-button type="primary" @click="enter">确定</el-button>
          <el-button @click="visible.check = checkObj.show = false">取消</el-button>
        </span>
      </template>
    </el-dialog>
  </el-dialog>
</template>

<script setup>
import { defineComponent, onBeforeMount, reactive, ref, shallowRef, toRefs, watch, computed } from 'vue'
import { seckillTimeStatus } from './formate.js'
import {
  activeGetExamines,
  activeGetProducts,
  activeLiquidation,
  activExamine,
} from '@/api/active'
import {
  getSeckillDetail,
  getSeckillShop,
  getSeckillChart,
  exportSeckillData,
} from '@/api/active/active_seckill.js'
// import List from '../component'
import DetailComponent from '@/views/active/component/detail.vue'

defineComponent({
  name: 'SeckillDetail'
})

let activityVisible = ref(false)
let tabs = reactive({
  activeName: 'first'
})
let activityForm = ref({});
let visible = reactive({
  check: false,
  activityProduct: false,
})
let seckillId = ref(null)
let signId = shallowRef('');

/**
 * ****************************** 参与店铺 ***************************
 */
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
// 店铺
const shopTableData = ref([]);

function open (id) {
  seckillId.value = id
  loadData()
  activityVisible.value = true
}
defineExpose({ open })

function getShopsData () {
  getSeckillShop(Object.assign({}, query, page)).then(res => {
    shopTableData.value = res.data && res.data.list
    page.total = res.data.total
  })
}
function loadData () {
  getDetails()
  getChartData()
  query.seckillId = seckillId.value
  getShopsData()
}
function handleSizeChange (val) {
  page.pageSize = val
  getShopsData()
}
function handleCurrentChange (val) {
  page.page = val
  getShopsData()
}
// 查询
function search () {
  page.page = 1
  getShopsData()
}

/**
 * ****************************** 活动商品 ***************************
 */
let shopPage = reactive({
  page: 1,
  pageSize: 10,
  total: 0,
})
// let shopQuery = reactive({
//   seckillId: 0, // 平台秒杀活动id
//   shopCode: '', // 店铺编码
//   shopName: '', // 店铺名称
//   state: '', // 审核状态 0-待审核 1-报名成功 2-报名失败 3-报名进行中(未支付)
//   signType: 2, // 1-平台优惠券 2-平台秒杀 3-平台限时折扣
// })
let shopRecordTableData = ref([]);
// 初始化查询所有活动商品
function getProducts () {
  activeGetProducts({
    signId: signId.value,
    page: shopPage.page,
    pageSize: shopPage.pageSize
  }).then(res => {
    shopRecordTableData.value = res.data && res.data.list || []
    shopPage.total = res.data.total
  })
}

// 查看活动商品
function seeMore (row) {
  visible.activityProduct = true
  signId.value = row.signId
  getProducts()
}
function handleCurrentChanges (val) {
  shopPage.page = val;
  getProducts()
}
function handleSizeChanges (val) {
  shopPage.page = 1;
  shopPage.pageSize = val;
  getProducts()
}

/**
 * *********************  审核记录 ************************
 */
let checkTableData = ref([]);
let checkForm = reactive({
  signId: '', // 报名id
  state: '1', // 审核状态 1-报名成功 2-报名失败
  remark: '', // 备注
})
let checkObj = ref({});

// 审核记录
function checkList (row) {
  visible.check = true
  activeGetExamines({
    only: `${row.shopId}-${row.activityId}-${row.signId}`,
  }).then(res => {
    checkTableData.value = res.data
  })
}

// 处理
function examine (row) {
  checkForm.signId = row.signId
  checkObj.value = {
    title: '审核',
    show: true,
    arr: row,
    type: 1,
  }
}
// 清退
function liquidation (row) {
  checkObj.value = {
    title: '清退',
    show: true,
    arr: row,
    type: 2,
  }
}
// 确定
function enter () {
  if (checkObj.value.type === 1) {
    activExamine(checkForm).then(res => {
      if (res.code === '') {
        ElMessage.success('处理成功')
        checkObj.value.show = false
        getShopsData()
      }
    })
  } else {
    activeLiquidation({
      signId: checkObj.value.arr.signId,
    }).then(res => {
      if (res.code === '') {
        ElMessage.success('清退成功')
        checkObj.value.show = false
        getShopsData()
      }
    })
  }
}

/*
*************************活动数据 *********************
*/
const activityPage = reactive({
  page: 1,
  pageSize: 10,
  total: 0
})
const activityTableData = ref([]);
const infoList = ref([{ name: '', value: '', fields: 'money' }]);

// 活动信息查询
function getDetails () {
  getSeckillDetail({ seckillId: seckillId.value }).then(res => {
    activityForm.value = res.data
  })
}

function getChartData () {
  getSeckillChart(Object.assign(
    {},
    { seckillId: seckillId.value },
    activityPage
  )).then(res => {
    activityTableData.value = formateTableList(res.data.shopDataDetails.list)
    activityPage.total = res.data.shopDataDetails.total
    infoList.value = formateInfoList(res)
  })
}
function changeChartPage (val) {
  activityPage.page = val
  getChartData()
}
function changePageChartSize (val) {
  activityPage.pageSize = val
  getChartData()
}
// 格式化卡片统计渲染
function formateInfoList (res) {
  return [
    {
      name: '浏览量',
      value: res.data.visit || 0,
    },
    {
      name: '支付订单数',
      value: res.data.orders || 0,
    },
    {
      name: '	支付买家数',
      value: res.data.pays || 0,
    },
    {
      name: '支付转化率',
      value: res.data.conversion || 0,
    },
    {
      name: '参与商家数',
      value: res.data.shops || 0,
    },
    {
      name: '参与商品数',
      value: res.data.products || 0,
    },
    {
      name: '活动成交金额',
      value: res.data.total || 0,
    },
  ]
}
function formateTableList (res) {
  if (!Array.isArray(res)) {
    return res
  }
  return res.map((item) => {
    return {
      shopName: item.shopName,
      shopCode: item.shopCode,
      products: item.products,
      persons: item.persons,
      orders: item.orders,
      finish: item.finish,
      total: item.total,
    }
  })
}
function exportData () {
  exportSeckillData({ seckillId: seckillId.value })
    .then(res => {
      if (!res) {
        return
      }
      const blob = new Blob([res])
      const fileName = '商家数据明细表.xlsx'
      if ('download' in document.createElement('a')) {
        // 非IE下载
        const elink = document.createElement('a')
        elink.download = fileName
        elink.style.display = 'none'
        elink.href = URL.createObjectURL(blob)
        document.body.appendChild(elink)
        elink.click()
        URL.revokeObjectURL(elink.href) // 释放URL 对象
        document.body.removeChild(elink)
      } else {
        // IE10+下载
        navigator.msSaveBlob(blob, fileName)
      }
    })
}
</script>

<style lang="scss" scoped>
.pending {
  padding: 30px;
}
.diaddStyle {
  .text {
    text-align: center;
  }
}
.detail_title {
  font-size: 22px;
  color: #333333;
  position: relative;
  margin: 50px 20px 20px;
  &:before {
    content: '';
    display: block;
    position: absolute;
    top: 5px;
    left: -20px;
    width: 4px;
    height: 24px;
    background-color: #3a68f2;
  }
}
.detail_text {
  padding: 0 120px;
  //  font-size: 16px;
  &>span:first-child {
    font-weight: bold;
  }
  .text {
    color: #666666;
    line-height: 40px;
    margin-left: 20px;
  }
  .Margin {
    margin-left: 90px;
  }
}
.shop_info {
  overflow: hidden;
  .shopInfo_left {
    float: left;
  }
}
.mf {
  margin-left: 20px;
  .el-tag {
    margin-bottom: 20px;
  }
}
// radio默认选中修改颜色
.el-radio__input.is-disabled + span.el-radio__label {
  color: #409eff !important;
}
</style>
