<template>
  <el-dialog
    v-model="visible"
    title="支付有礼活动详情"
    width="74%"
    center
    :close-on-click-modal="false"
  >
    <div class="pending">
      <el-tabs v-model="activeName">
        <el-tab-pane
          label="活动信息"
          name="first"
        >
          <div class="shop_info">
            <h3 class="detail_title">店铺信息</h3>
            <div class="shopInfo_left">
              <p class="detail_text">
                <span>活动名称：</span>
                <span class="text">{{ form.politeName }}</span>
              </p>
              <p class="detail_text">
                <span>活动备注：</span>
                <span class="text">{{ form.remark }}</span>
              </p>
              <p class="detail_text">
                <span>起止时间：</span>
                <span
                  class="text"
                >{{ form.startTime }} - {{ form.endTime }}</span>
              </p>
            </div>
          </div>`
          <div class="shop_info">
            <h3 class="detail_title">优惠规则</h3>
            <p class="detail_text">
              <span>优惠方式：</span>
              <span
                v-if="form.buyerMode === 1"
                class="text"
              >
                按结算金额优惠
              </span>
              <span
                v-if="form.buyerMode === 2"
                class="text"
              >
                按结算数量优惠
              </span>
            </p>
            <p class="detail_text">
              <span>优惠门槛：</span>
              <span
                v-if="form.buyerMode === 1"
                class="text"
              >
                满{{ form.buyer }}元
              </span>
              <span
                v-if="form.buyerMode === 2"
                class="text"
              >
                满{{ form.buyer }}件
              </span>
            </p>
            <p class="detail_text">
              <span>优惠内容：</span>
              <span class="text">
                <el-table
                  :data="couponList"
                  border
                  :header-cell-style="{
                    background: '#EEF3FF',
                    color: '#333333',
                  }"
                  tooltip-effect="dark"
                  style="width: 700px"
                >
                  <el-table-column
                    prop="activityName"
                    label="优惠券名称"
                  />
                  <el-table-column
                    label="优惠类型"
                    width="220"
                  >
                    <template #default="scope">
                      <span v-if="scope.row.activityType === 1">满减</span>
                      <span v-if="scope.row.activityType === 2">折扣</span>
                    </template>
                  </el-table-column>
                  <el-table-column label="优惠券内容">
                    <template #default="scope">
                      <span v-if="scope.row.activityType === 1">
                        满{{ scope.row.threshold }} 减
                        {{ scope.row.couponContent }}
                      </span>
                      <span v-if="scope.row.activityType === 2">
                        满{{ scope.row.threshold }} 打
                        {{ scope.row.couponContent }}折
                      </span>
                    </template>
                  </el-table-column>
                  <el-table-column
                    prop="endTime"
                    label="到期时间"
                  />
                </el-table>
              </span>
            </p>
            <p
              v-if="form.growth"
              class="detail_text"
            >
              <span>赠送成长值：</span>
              <span class="text"> {{ form.growth }}点成长值 </span>
            </p>
            <p
              v-if="form.credit"
              class="detail_text"
            >
              <span>赠送积分：</span>
              <span class="text"> {{ form.credit }}积分 </span>
            </p>
          </div>
        </el-tab-pane>
        <el-tab-pane
          label="活动数据"
          name="third"
        >
          <!-- <List :list-id="info" /> -->
          <DetailComponent
            :list="activityTable"
            :info-list="infoList"
          >
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
                  <el-table-column
                    prop="name"
                    label="用户名称"
                  />
                  <el-table-column
                    prop="phone"
                    label="用户手机号"
                  />
                  <el-table-column
                    prop="number"
                    label="获取优惠券数量"
                  />
                  <el-table-column
                    prop="growth"
                    label="获取成长值"
                  />
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
  </el-dialog>
</template>

<script setup>
import { getChartData, getPoliteDetail } from '@/api/active/active_polite.js'
import DetailComponent from '@/views/active/component/detail.vue'
import { computed, onMounted, ref, toRefs, watch } from 'vue';

let visible = ref(false)
let activeName = ref('first')
let formInline = ref({
  politeId: 0,
  shopName: '', // 店铺名称
  shopCode: '', // 店铺编码
  state: '', // 审核状态 0-待审核 1-报名成功 2-报名失败
  page: 1,
  pageSize: 10,
})
let form = ref({})
let couponList = ref([])
let activityTable = ref([])
let infoList = ref([{ name: '成交总额(元)', value: '0', fields: 'money' }])
let chartTotal = ref(1)
let chartQuery = ref({
  page: 1,
  pageSize: 10,
})
let politeId = ref(null)

function open (id) {
  politeId.value = parseInt(id)
  loadData()
  visible.value = true
}
defineExpose({ open })

function loadData () {
  getDetails()
  formInline.value.politeId = politeId.value
  getChart()
}

function getDetails () {
  getPoliteDetail({ politeId: politeId.value }).then(res => {
    form.value = res.data
    couponList.value = res.data.details
  })
}

function getChart () {
  const data = Object.assign(
    {},
    { politeId: politeId.value },
    chartQuery.value
  )
  getChartData(Object.assign(
    {},
    { politeId: politeId.value },
    chartQuery.value
  )).then(res => {
    infoList.value = formateInfoList(res)
  })
  // activityTable = formateTableList(res.data.shopDataDetails.list)
  // chartTotal = res.data.shopDataDetails.total
}
function formateInfoList (res) {
  return [
    {
      name: '发放优惠券数量',
      value: res.data.number || 0,
    },
    {
      name: '领取礼品笔数',
      value: res.data.receives || 0,
    },
    {
      name: '	领取礼品人数',
      value: res.data.users || 0,
    },
    {
      name: '成长值发放',
      value: res.data.growth || 0,
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

}

.shop_info {
  overflow: hidden;

  .shopInfo_left{
    float: left;
  }
}

// radio默认选中修改颜色
.el-radio__input.is-disabled + span.el-radio__label {
  color: #409eff !important;
}
</style>
