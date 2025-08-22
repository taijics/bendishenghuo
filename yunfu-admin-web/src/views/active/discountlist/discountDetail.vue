<template>
  <el-dialog
    v-model="visible"
    title="限时折扣活动详情"
    width="74%"
    center
    :close-on-click-modal="false"
  >
    <div class="pending">
      <el-tabs v-model="activeName">
        <el-tab-pane label="活动信息" name="first">
          <div class="shop_info">
            <h3 class="detail_title">店铺信息</h3>
            <div class="shopInfo_left">
              <p class="detail_text">
                <span>活动名称：</span>
                <span class="text">{{ form.discountName }}</span>
              </p>
              <p class="detail_text">
                <span>活动介绍：</span>
                <span class="text">{{ form.remark }}</span>
              </p>
              <p class="detail_text">
                <span>报名时间：</span>
                <span class="text">{{ form.signStartTime }}-{{ form.signEndTime }}</span>
              </p>
              <p class="detail_text">
                <span>起止时间：</span>
                <span class="text">{{ form.startTime }}-{{ form.endTime }}</span>
              </p>
              <p class="detail_text">
                <span>活动保证金：</span>
                <span class="text textColor">
                  <el-radio-group v-model="form.ifBond">
                    <el-radio :label="1" disabled>需要</el-radio>
                    <el-radio :label="0" disabled>不需要</el-radio>
                  </el-radio-group>
                </span>
              </p>
              <p v-if="form.ifBond" class="detail_text">
                <span>保证金金额：</span>
                <span class="text">{{ form.bondMoney }}</span>
              </p>
            </div>
          </div>
          <div class="shop_info">
            <h3 class="detail_title">优惠规则</h3>
            <p class="detail_text">
              <span>全场折扣：</span>
              <span class="text"> {{ form.discount }}折 </span>
            </p>
            <p class="detail_text">
              <span>是否限购：</span>
              <span v-if="form.ifLimit === 2" class="text">
                限购， {{ form.limitNumber }} 人/件
              </span>
              <span v-if="form.ifLimit === 1" class="text"> 不限购 </span>
            </p>
            <p class="detail_text">
              <span>优惠券叠加：</span>
              <span v-if="form.ifAdd === 1" class="text"> 叠加 </span>
              <span v-if="form.ifAdd === 0" class="text"> 不叠加 </span>
            </p>
          </div>
        </el-tab-pane>
        <el-tab-pane label="参与店铺" name="second">
          <!-- 搜索 -->
          <div class="formSearch">
            <el-form
              :inline="true"
              :model="formInline"
            >
              <el-form-item label="店铺名称">
                <el-input
                  v-model="formInline.shopName"
                  maxlength="20"
                  placeholder="请输入店铺名称"
                />
              </el-form-item>
              <el-form-item label="店铺编码">
                <el-input
                  v-model="formInline.shopCode"
                  maxlength="20"
                  placeholder="请输入店铺编码"
                />
              </el-form-item>
              <el-form-item label="审核状态">
                <el-select
                  v-model="formInline.state"
                  placeholder="请选择审核状态"
                >
                  <el-option label="待审核" value="0" />
                  <el-option label="报名成功" value="1" />
                  <el-option label="报名失败" value="2" />
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
              :data="tableData"
              border
              :header-cell-style="{ background: '#EEF3FF', color: '#333333' }"
              tooltip-effect="dark"
              style="width: 100%"
            >
              <el-table-column label="店铺名称" width="220">
                <template #default="scope">{{ scope.row.shopName }}</template>
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
            <div class="fenye">
              <el-pagination
                :current-page="currentPage"
                :page-sizes="[10, 20, 50, 100]"
                :page-size="10"
                layout="total, sizes, prev, pager, next, jumper"
                :total="total"
                @size-change="handleSizeChange"
                @current-change="handleCurrentChange"
              />
            </div>
          </div>
        </el-tab-pane>
        <el-tab-pane label="活动数据" name="third">
          <!-- <List :list-id="info" /> -->
          <DetailComponent :info-list="infoList" @export="exportData">
            <template #table>
              <div class="table">
                <el-table
                  :data="activityTable"
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
                <div class="fenye">
                  <el-pagination
                    :current-page="chartQuery.page"
                    :page-sizes="[10, 20, 50, 100]"
                    :page-size="chartQuery.pageSize"
                    layout="total, sizes, prev, pager, next, jumper"
                    :total="chartTotal"
                    @size-change="chartSizeChanges"
                    @current-change="chartCurrentChanges"
                  />
                </div>
              </div>
            </template>
          </DetailComponent>
        </el-tab-pane>
      </el-tabs>
    </div>

    <!-- ******************************************************弹框开始***************************************************************** -->
    <!-- 审核记录弹框 -->
    <el-dialog
      v-model="checkDIa"
      title="审核记录"
      center
      width="30%"
      :close-on-click-modal="false"
      :modal-append-to-body="false"
      :modal="false"
    >
      <div class="diaddStyle">
        <el-table
          :data="checkLists"
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
          <el-button type="primary" @click="checkDIa = false">确定</el-button>
        </span>
      </template>
    </el-dialog>

    <!-- 活动商品记录弹框 -->
    <el-dialog
      v-model="foodsDia"
      title="活动商品"
      center
      width="70%"
      :close-on-click-modal="false"
      :modal-append-to-body="false"
      :modal="false"
    >
      <div class="diaddStyle">
        <el-table
          :data="tableDatas"
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
          <el-table-column prop="sectionPrice" label="售价(元)" />
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
        <div class="fenye">
          <el-pagination
            :current-page="chartQuery.page"
            :page-sizes="[10, 20, 50, 100]"
            :page-size="chartQuery.pageSize"
            layout="total, sizes, prev, pager, next, jumper"
            :total="totals"
            @size-change="chartSizeChanges"
            @current-change="chartCurrentChanges"
          />
        </div>
      </div>
      <template #footer>
        <span class="dialog-footer">
          <el-button type="primary" @click="foodsDia = false">确定</el-button>
        </span>
      </template>
    </el-dialog>

    <!-- 审核清退 -->
    <el-dialog
      v-model="checkObj.show"
      :title="checkObj.title"
      center
      width="30%"
      :close-on-click-modal="false"
      :modal-append-to-body="false"
      :modal="false"
    >
      <div v-if="checkObj.type === 1" class="diaddStyle">
        <el-form ref="form" :model="addform" label-width="80px">
          <el-form-item label="审核状态">
            <el-radio-group v-model="addform.state">
              <el-radio label="1">报名成功</el-radio>
              <el-radio label="2">报名失败</el-radio>
            </el-radio-group>
          </el-form-item>
          <el-form-item label="备注">
            <el-input
              v-model="addform.remark"
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
          <el-button @click="checkDIa = checkObj.show = false">取消</el-button>
        </span>
      </template>
    </el-dialog>
  </el-dialog>
</template>

<script setup>
import {
  activeGetExamines,
  activeLiquidation,
  activExamine,
} from '@/api/active'

import {
  getDiscountDetail,
  getDiscountShop,
  getDiscountProduct,
  getDiscountChart,
  exportDiscountData,
} from '@/api/active/active_discount.js'
import DetailComponent from '@/views/active/component/detail.vue'
import { ref } from 'vue';

const visible = ref(false)
const activeName = ref('first')
const formInline = ref({
  // activityId: 0,
  // shopName: '', // 店铺名称
  // shopCode: '', // 店铺编码
  // state: '', // 审核状态 0-待审核 1-报名成功 2-报名失败
  page: 1,
  pageSize: 10,
  signType: 3, // 1-平台优惠券 2-平台秒杀 3-平台限时折扣
})
const addform = ref({
  signId: '', // 报名id
  state: '1', // 审核状态 1-报名成功 2-报名失败
  remark: '', // 备注
})
const checkObj = ref({})
const form = ref({})
const tableData = ref([])
const tableDatas = ref([])
const checkLists = ref([])
const total = ref(1)
const totals = ref(1)
const currentPage = ref(1)
const checkDIa = ref(false)
const foodsDia = ref(false)
const signId = ref('')
const activityTable = ref([])
const infoList = ref([{ name: '成交总额(元)', value: '0', fields: 'money' }])
const chartTotal = ref(1)
const chartQuery = ref({
  page: 1,
  pageSize: 10,
})

const discountId = ref(null)

// 打开详情弹窗
function open (id) {
  discountId.value = parseInt(id)
  loadData()
  visible.value = true
}
defineExpose({ open })

// 获取详情数据
function loadData () {
  getDetails()
  getChartData()
  formInline.value.discountId = discountId.value
  getAll(formInline.value)
}

function handleSizeChange (val) {
  formInline.value.pageSize = val
  getAll(formInline.value)
}
function handleCurrentChange (val) {
  formInline.value.page = val
  getAll(formInline.value)
}
function handleSizeChanges (val) {
  getProducts({
    signId: signId.value,
    page: 1,
    pageSize: val,
  })
}
function handleCurrentChanges (val) {
  getProducts({
    signId: signId.value,
    page: val,
    pageSize: 10,
  })
}
function search () {
  total.value = 1
  formInline.value.page = 1
  getAll(formInline.value)
}
async function checkList (row) {
  checkDIa.value = true
  const res = await activeGetExamines({
    only: `${row.shopId}-${row.activityId}-${row.signId}`,
  })
  checkLists.value = res.data || []
}
function seeMore (row) {
  foodsDia.value = true
  signId.value = row.signId
  getProducts({
    signId: signId.value,
    page: 1,
    pageSize: 10,
  })
}
async function examine (row) {
  addform.value.signId = row.signId
  checkObj.value = {
    title: '审核',
    show: true,
    arr: row,
    type: 1,
  }
}

async function liquidation (row) {
  checkObj.value = {
    title: '清退',
    show: true,
    arr: row,
    type: 2,
  }
}

async function enter () {
  if (checkObj.value.type === 1) {
    const res = await activExamine(addform.value)
    if (res.code === '') {
      ElMessage({
        message: '处理成功',
        type: 'success',
      })
      checkObj.value.show = false
      getAll(formInline.value)
    }
  } else {
    const res = await activeLiquidation({
      signId: checkObj.value.arr.signId,
    })
    if (res.code === '') {
      ElMessage({
        message: '清退成功',
        type: 'success',
      })
      checkObj.value.show = false
      getAll(formInline.value)
    }
  }
}

async function getDetails () {
  const res = await getDiscountDetail({ discountId: discountId.value })
  form.value = res.data
}

async function getAll (formInline) {
  const res = await getDiscountShop(formInline)
  tableData.value = res.data.list
  total.value = res.data.total
}
async function getProducts (formInline) {
  const res = await getDiscountProduct(formInline)
  tableDatas.value = res.data.list
  totals.value = res.data.total
}
async function getChartData () {
  const data = Object.assign(
    {},
    { discountId: discountId.value },
    chartQuery.value
  )
  const res = await getDiscountChart(data)
  activityTable.value = formateTableList(res.data.shopDataDetails.list)
  chartTotal.value = res.data.shopDataDetails.total
  infoList.value = formateInfoList(res)
}
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
function chartCurrentChanges (val) {
  chartQuery.value.page = val
  getChartData()
}
function chartSizeChanges (val) {
  chartQuery.value.pageSize = val
  getChartData()
}

async function exportData () {
  const res = await exportDiscountData({ discountId: discountId.value })
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
}
</script>

<style lang="scss" scoped>
.pending {
  padding: 30px;
}
.fenye {
  margin-top: 20px;
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
  .shopInfo_left,
  .shopInfo_right {
    float: left;
  }
  .shopInfo_right {
    margin-left: 160px;
    width: 200px;
    height: 200px;
    img {
      width: 100%;
    }
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
