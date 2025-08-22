<template>
  <el-dialog
    v-model="activityVisible"
    title="优惠券活动详情"
    width="74%"
    center
    :close-on-click-modal="false"
    @closed="closed"
  >
    <div class="pending">
      <el-tabs v-model="tabsActiveName">
        <el-tab-pane label="活动信息" name="first">
          <div class="shop_info">
            <h3 class="detail_title">店铺信息</h3>
            <div class="shopInfo_left">
              <p class="detail_text">
                <span>活动名称：</span>
                <span class="text">{{ infoForm.activityName }}</span>
              </p>
              <p class="detail_text">
                <span>活动介绍：</span>
                <span class="text">{{ infoForm.activityIntroduce }}</span>
              </p>
              <p class="detail_text">
                <span>报名时间：</span>
                <span class="text">{{ infoForm.signStartTime }}-{{ infoForm.signEndTime }}</span>
              </p>
              <p class="detail_text">
                <span>起止时间：</span>
                <span class="text">{{ infoForm.activityStartTime }}-{{ infoForm.activityEndTime }}</span>
              </p>
              <p class="detail_text">
                <span>活动保证金：</span>
                <span class="text textColor">
                  <el-radio-group v-model="infoForm.ifBond">
                    <el-radio :label="1" disabled>需要</el-radio>
                    <el-radio :label="0" disabled>不需要</el-radio>
                  </el-radio-group>
                </span>
              </p>
              <p v-if="infoForm.ifBond" class="detail_text">
                <span>保证金金额：</span>
                <span class="text">{{ infoForm.bondMoney }}</span>
              </p>
              <!-- <p v-if="infoForm.activityLabel" class="detail_text">
                  <span>活动标签：</span>
                  <span class="mf">
                    <el-tag type="warning" effect="dark">{{
                      infoForm.activityLabel
                    }}</el-tag>
                  </span>
                </p> -->
            </div>
            <div class="shopInfo_right">
              <img v-if="infoForm.image" :src="infoForm.image" alt="" />
            </div>
          </div>
          <div class="shop_info">
            <h3 class="detail_title">优惠规则</h3>
            <p v-if="infoForm.discountMode" class="detail_text">
              <span>优惠方式：</span>
              <span class="text">
                <el-radio-group v-model="infoForm.discountMode">
                  <el-radio :label="1" disabled>满减</el-radio>
                  <el-radio :label="2" disabled>优惠券</el-radio>
                </el-radio-group>
              </span>
            </p>
            <p v-if="infoForm.couponContent" class="detail_text">
              <span>优惠内容：</span>
              <span v-if="infoForm.discountMode === 1" class="text">
                减 {{ infoForm.couponContent }} 元
              </span>
              <span v-if="infoForm.discountMode === 2" class="text">
                {{ infoForm.couponContent }}折
              </span>
            </p>
            <p v-if="infoForm.threshold" class="detail_text">
              <span>使用门槛：</span>
              <span class="text">
                <div>满 {{ infoForm.threshold }} 元</div>
              </span>
            </p>
            <p v-if="infoForm.number" class="detail_text">
              <span>发放数量：</span>
              <span class="text"> {{ infoForm.number }}张 </span>
            </p>
            <p v-if="infoForm.receiveType" class="detail_text">
              <span>领取次数：</span>
              <span v-if="infoForm.receiveType === 2" class="text">
                {{ infoForm.frequency }}次
              </span>
              <span
                v-else
                class="text"
              > 无限制 </span>
            </p>
            <p class="detail_text">
              <span>同步微信卡包：</span>
              <el-checkbox
                v-model="infoForm.syncCard"
                :true-label="1"
                :false-label="0"
                :disabled="true"
              />
            </p>
          </div>
          <div v-if="infoForm.syncCard === 1" class="sync_card_info">
            <h3 class="detail_title">卡券同步设置</h3>
            <p v-if="infoForm.cardTitle" class="detail_text">
              <span>卡券标题：</span>
              <span class="text">
                {{ infoForm.cardTitle }}
              </span>
            </p>
            <p v-if="infoForm.cardColor" class="detail_text">
              <span>券主题颜色：</span>
              <span
                class="color-box"
                :style="{ backgroundColor: getCouponColor(infoForm.cardColor) }"
              ></span>
              <span class="text">
                {{ infoForm.cardColor }}
              </span>
            </p>
            <p v-if="infoForm.cardNotice" class="detail_text">
              <span>使用须知：</span>
              <span class="text">
                <div>
                  {{ infoForm.cardNotice }}
                </div>
              </span>
            </p>
          </div>
        </el-tab-pane>
        <!-- 参与店铺 -->
        <el-tab-pane
          label="参与店铺"
          name="second"
        >
          <div class="formSearch">
            <el-form
              :inline="true"
              :model="shopQuery"
            >
              <el-form-item label="店铺名称">
                <el-input
                  v-model="shopQuery.shopName"
                  maxlength="20"
                  placeholder="请输入店铺名称"
                />
              </el-form-item>
              <el-form-item label="店铺编码">
                <el-input
                  v-model="shopQuery.shopCode"
                  maxlength="20"
                  placeholder="请输入店铺编码"
                />
              </el-form-item>
              <el-form-item label="审核状态">
                <el-select
                  v-model="shopQuery.state"
                  placeholder="请选择审核状态"
                >
                  <el-option
                    label="待审核"
                    value="0"
                  />
                  <el-option
                    label="报名成功"
                    value="1"
                  />
                  <el-option
                    label="报名失败"
                    value="2"
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
              </el-form-item>
            </el-form>
          </div>
          <div class="tableBox">
            <el-table
              :data="shopTableData"
              border
              :header-cell-style="{ background: '#EEF3FF', color: '#333333' }"
              tooltip-effect="dark"
              style="width: 100%"
            >
              <el-table-column
                label="店铺名称"
                width="220"
              >
                <template #default="scope">{{ scope.row.shopName }}</template>
              </el-table-column>
              <el-table-column
                prop="shopCode"
                label="店铺编码"
              />
              <el-table-column
                prop="productNumber"
                label="参与商品数"
              />
              <el-table-column
                prop="examine"
                label="审核次数"
              />
              <el-table-column label="审核状态">
                <template #default="scope">
                  <span v-if="scope.row.state == 0">待审核</span>
                  <span v-if="scope.row.state == 1">报名成功</span>
                  <span v-if="scope.row.state == 2">报名失败</span>
                </template>
              </el-table-column>
              <el-table-column
                label="操作"
                show-overflow-tooltip
              >
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
                      @click="handleCheck(scope.row)"
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
                :current-page="shopPage.page"
                :page-sizes="[10, 20, 50, 100]"
                :page-size="10"
                layout="total, sizes, prev, pager, next, jumper"
                :total="shopPage.total"
                @size-change="handleSizeChange"
                @current-change="handleCurrentChange"
              />
            </div>
          </div>
        </el-tab-pane>
        <el-tab-pane :lazy="true" label="数据图表" name="chart">
          <div v-loading="visible.chart" class="chartPage">
            <div class="topChart">
              <MapChart
                v-if="cityData.length > 0"
                class="mapCanvas"
                :city-data="cityData"
              />
              <RankComponent
                class="rank"
                :title="'商家成交排行榜'"
                :subtitle="'成交额/元'"
                :rank-data="dealData"
              />
              <RankComponent
                class="rank"
                :title="'畅销商品排行榜'"
                :subtitle="'售卖个数/个'"
                :rank-data="sealsDate"
              />
            </div>
            <div class="minChart">
              <DistributionChart
                class="distribut"
                :chart-data="pieData"
              />
              <TypePie
                class="typePie"
                :classify-data="classifyData"
              />
            </div>
            <div class="bottomChart">
              <TrendChart
                class="trend"
                :chart-data="trendData"
              />
            </div>
          </div>
          <!-- <List :list-id="currentCouponId" /> -->
        </el-tab-pane>
        <el-tab-pane
          :lazy="true"
          label="数据详情"
          name="detail"
        >
          <TableData
            :table-data="detailData"
            :total="detailQuery.total"
            @handleCurrentChange="pageGetShopTable"
            @handleSizeChange="sizeGetShopTable"
            @export="exportShopTable"
          />
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
          :data="checkData"
          border
          :header-cell-style="{ background: '#EEF3FF', color: '#333333' }"
          tooltip-effect="dark"
          style="width: 100%"
        >
          <el-table-column
            label="动态"
            width="220"
          >
            <template #default="scope">{{
              scope.row.operationDescribtion
            }}
            </template>
          </el-table-column>
          <el-table-column
            prop="createTime"
            label="时间"
          />
          <el-table-column
            prop="name"
            label="操作人"
          />
          <el-table-column
            prop="remark"
            label="其他信息"
          />
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
      v-model="visible.record"
      title="活动商品"
      center
      width="70%"
      :close-on-click-modal="false"
      :modal-append-to-body="false"
      :modal="false"
    >
      <div class="diaddStyle">
        <el-table
          :data="shopRecordData"
          border
          :header-cell-style="{ background: '#EEF3FF', color: '#333333' }"
          tooltip-effect="dark"
          style="width: 100%"
        >
          <el-table-column
            label="产品主图"
            width="220"
          >
            <template #default="scope">
              <img
                :src="scope.row.image"
                width="50"
                height="50"
                alt
                srcset
              />
            </template>
          </el-table-column>
          <el-table-column
            prop="productName"
            label="产品名称"
          />
          <el-table-column
            prop="productId"
            label="产品id"
          />
          <el-table-column
            prop="price"
            label="售价(元)"
          />
          <el-table-column
            prop="originalPrice"
            label="原价(元)"
          />
          <el-table-column
            prop="stockNumber"
            label="库存(件)"
          />
          <el-table-column
            prop="volume"
            label="累计销量(件)"
          />
          <el-table-column label="上架状态">
            <template #default="scope">
              <span v-if="scope.row.shelveState == 1">上架</span>
              <span v-if="scope.row.shelveState == 0">下架</span>
            </template>
          </el-table-column>
        </el-table>
        <div class="fenye">
          <el-pagination
            :current-page="shopRecordPage.page"
            :page-sizes="[10, 20, 50, 100]"
            :page-size="shopRecordPage.pageSize"
            layout="total, sizes, prev, pager, next, jumper"
            :total="shopRecordPage.total"
            @size-change="handleSizeChanges"
            @current-change="handleCurrentChanges"
          />
        </div>
      </div>
      <template #footer>
        <span class="dialog-footer">
          <el-button type="primary" @click="visible.record = false">确定</el-button>
        </span>
      </template>
    </el-dialog>

    <!-- 审核清退 -->
    <el-dialog
      v-model="checkSetting.show"
      :title="checkSetting.title"
      center
      width="30%"
      :close-on-click-modal="false"
      :modal-append-to-body="false"
      :modal="false"
    >
      <div v-if="checkSetting.type === 1" class="diaddStyle">
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
      <div
        v-else
        class="diaddStyle"
      >
        <div class="text">确认要清退本商家吗？</div>
        <div class="text">清退后商家的所有商品将退出本次活动</div>
      </div>
      <template #footer>
        <span class="dialog-footer">
          <el-button type="primary" @click="enter">确定</el-button>
          <el-button @click="visible.check = checkSetting.show = false">取消</el-button>
        </span>
      </template>
    </el-dialog>
  </el-dialog>
</template>

<script setup>
import { defineComponent, reactive, ref, shallowRef, toRefs } from 'vue'
// import List from '../component'
import MapChart from '@/views/active/couponlist/component/mapChart.vue'
import DistributionChart from '@/views/active/couponlist/component/chartDistribution.vue'
import RankComponent from '@/views/active/couponlist/component/rank.vue'
import TypePie from '@/views/active/couponlist/component/typePie.vue'
import TrendChart from '@/views/active/couponlist/component/trendChart.vue'
import TableData from '@/views/active/component/dataTable.vue'

import {
  getCouponColor
} from './couponColor.js'
import {
  getCouponShops,
  getCouponDetail,
  exportCouponData,
  getCharts,
  getShopDatas,
} from '@/api/active/active_coupon.js'
import { activeGetExamines, activeGetProducts, activeLiquidation, activExamine, excel_shop_detail, } from '@/api/active'

defineComponent({
  name: 'CouponDetail'
})

const activityVisible = ref(false)
const tabsActiveName = shallowRef('first')
const currentCouponId = shallowRef(null)

/**
 * ***************************
 * 活动信息查询
 * ***************************
 * */
const infoForm = ref({});

// 打开详情弹窗
function open (id) {
  currentCouponId.value = parseInt(id)
  shopQuery.activityId = currentCouponId.value
  getShopAll()
  detailQuery.activityId = currentCouponId.value
  getShopTable()
  getChartData()
  getDetails()
  activityVisible.value = true
}
defineExpose({ open })

function getDetails () {
  getCouponDetail({ activityId: currentCouponId.value }).then(res => {
    infoForm.value = res.data
  })
}

/**
 * ***************************
 * 活动信息查询
 * ***************************
 * */
let shopQuery = reactive({
  signType: 1, // 1-平台优惠券 2-平台秒杀 3-平台限时折扣
  activityId: 0,
  shopName: '', // 店铺名称
  shopCode: '', // 店铺编码
  state: '', // 审核状态 0-待审核 1-报名成功 2-报名失败
})
let shopPage = reactive({
  page: 1,
  pageSize: 10,
  total: 0
})
// 店铺数据
let shopTableData = ref([]);
// 查询参与店铺
function getShopAll () {
  getCouponShops(Object.assign({}, shopQuery, shopPage)).then(res => {
    shopTableData.value = res.data.list
    shopPage.total = res.data.total
  })
}
// 查询
function search () {
  shopPage.page = 1
  getShopAll()
}
function handleSizeChange (val) {
  shopPage.pageSize = val
  getShopAll()
}
function handleCurrentChange (val) {
  shopPage.page = val
  getShopAll()
}

/**
 *
 * 活动商品
 *
 */
let shopRecordData = ref([]);
let shopRecordQuery = reactive({
  signId: null
})
let shopRecordPage = reactive({
  page: 1,
  pageSize: 10,
  total: 0
});
// 初始化查询所有活动商品
function getProducts (params) {
  activeGetProducts(Object.assign({}, shopRecordPage, shopRecordQuery)).then(res => {
    shopRecordData.value = res.data.list
    shopRecordPage.total = res.data.total
  })
}
function handleSizeChanges (val) {
  shopRecordPage.pageSize = val
  getProducts()
}
function handleCurrentChanges (val) {
  shopRecordPage.page = val
  getProducts()
}

let checkForm = reactive({
  signId: '', // 报名id
  state: '1', // 审核状态 1-报名成功 2-报名失败
  remark: '', // 备注
})
let checkSetting = reactive({
  title: '审核',
  show: false,
  arr: '',
  type: 1,
});

// 处理
function examine (row) {
  checkForm.signId = row.signId
  setCheckSetting({
    title: '审核',
    show: true,
    arr: row,
    type: 1,
  })
}

// 查看
function seeMore (row) {
  visible.record = true
  shopRecordQuery.signId = row.signId
  getProducts()
}

// 清退
function liquidation (row) {
  setCheckSetting({
    title: '清退',
    show: true,
    arr: row,
    type: 2,
  })
}
function setCheckSetting (object) {
  checkSetting.title = object.title || ''
  checkSetting.show = object.show || false
  checkSetting.arr = object.arr || {}
  checkSetting.type = object.type || 1
}
// 确定
function enter () {
  if (checkSetting.type === 1) {
    activExamine(checkForm).then(res => {
      if (res.code === '') {
        ElMessage.success('处理成功')
        checkSetting.show = false
        getShopAll()
      }
    })
  } else {
    activeLiquidation({
      signId: checkSetting.arr.signId,
    }).then(res => {
      if (res.code === '') {
        ElMessage.success('清退成功')
        checkSetting.show = false
        getShopAll()
      }
    })
  }
}
/**
 *
 * 数据详情
 *
 */
let detailQuery = reactive({
  activityId: 0,
  page: 1,
  pageSize: 10,
})
let detailData = ref([]);
// 查询活动数据详情
function getShopTable () {
  getShopDatas(detailQuery).then(res => {
    detailData.value = res.data.list
    detailQuery.total = res.data.total
  })
}
function pageGetShopTable (e) {
  detailQuery.page = e
  getShopTable()
}
function sizeGetShopTable (e) {
  detailQuery.pageSize = e
  getShopTable()
}

let visible = reactive({
  check: false,
  record: false,
  chart: false,
})

let checkData = ref([]);
// 审核记录
function handleCheck (row) {
  visible.check = true
  activeGetExamines({
    only: `${row.shopId}-${row.activityId}-${row.signId}`,
  }).then(res => {
    checkData.value = res.data
  }).finally(() => {
    visible.check = false
  })
}

// 查询图表
let pieData = ref({});
let cityData = ref([]);
// 成交数据
let dealData = ref([]);
// 畅销商品
let sealsDate = ref([]);
let classifyData = ref([]);
let trendData = ref({});

function getChartData () {
  visible.chart = true
  pieData.value = {}
  cityData.value = []
  dealData.value = []
  sealsDate.value = []
  classifyData.value = []
  trendData.value = {}
  getCharts(detailQuery)
    .then((res) => {
      pieData.value = Object.assign(
        { cityPeople: res.data.cityPeople },
        { newOlds: res.data.newOlds },
        { terminals: res.data.terminals },
        { systems: res.data.systems }
      )
      cityData.value = res.data.cities || []
      dealData.value =
            res.data.shopRankings.map((item) => {
              item.rankName = item.shopName
              item.ranks = item.money
              return item
            }) || []
      sealsDate.value =
            res.data.productRankings.map((item) => {
              item.rankName = item.productName
              item.ranks = item.total
              return item
            }) || []
      classifyData.value = res.data.classifies || []
      trendData.value = res.data.trend || {}
    })
    .catch((err) => {
      console.log(err)
    }).finally(() => {
      visible.chart = false
    })
}

// // 导出表格数据
function exportShopTable () {
  excel_shop_detail(Object.assign({}, shopQuery, shopPage)).then((res) => {
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
function closed () {
  pieData.value = {}
  cityData.value = []
  dealData.value = []
  sealsDate.value = []
  classifyData.value = []
  trendData.value = {}
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
  margin: 12px 0;
  padding: 0 120px;
  //  font-size: 16px;
  &>span:first-child {
    font-weight: bold;
  }
  .text {
    color: #666666;
    line-height: 40px;
    margin-left: 20px;

    div {
      display: inline-block;
    }
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

.sync_card_info {
  .color-box {
    width: 30px;
    height: 30px;
    display: inline-block;
    vertical-align: middle;
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

.chartPage {
  .topChart {
    height: 530px;
    display: flex;

    .mapCanvas {
      flex: 1;
      border: 1px solid #efefef;
      padding: 8px 3px;
    }

    .rank {
      flex: 1;
    }
  }

  .minChart {
    margin: 12px 0;
    padding: 8px;
    height: 600px;
    box-sizing: content-box;
    display: flex;
    border: 1px solid #efefef;

    .distribut {
      flex: 1;
    }

    .typePie {
      flex: 1;
    }
  }

  .bottomChart {
    .trend {
      height: 500px;
    }
  }
}
</style>
