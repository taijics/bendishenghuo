<template>
  <el-dialog
    v-model="visible"
    :title="activityForm.politeId ? '修改支付有礼活动' : '新增支付有礼活动'"
    width="50%"
    center
    :close-on-click-modal="false"
    @closed="closed"
  >
    <div class="content">
      <el-form
        ref="formRef"
        :model="form"
        :rules="rules"
        label-width="120px"
      >
        <br />
        <h2>基础信息</h2>
        <br />
        <el-form-item label="活动名称:" prop="politeName">
          <el-input
            v-model="form.politeName"
            maxlength="20"
            placeholder="请输入活动名称"
            :disabled="unStart"
            style="width: 100%"
          />
        </el-form-item>

        <el-form-item label="活动备注:">
          <el-input
            v-model="form.remark"
            maxlength="200"
            type="textarea"
            placeholder="请输入活动备注"
            :disabled="unStart"
            style="width: 100%"
          />
        </el-form-item>

        <el-form-item label="活动时间:" prop="startTime">
          <el-date-picker
            v-model="date1"
            type="datetimerange"
            range-separator="至"
            start-placeholder="开始时间"
            end-placeholder="结束时间"
            value-format="YYYY-MM-DD HH:mm:ss"
            :disabled="applyEnd"
            style="width: 100%"
            :clearable="false"
          />
          <p class="timeInfo">平台活动时间不能交叉</p>
        </el-form-item>

        <h2>优惠规则</h2>
        <br />
        <el-form-item label="优惠方式:" prop="buyerMode">
          <el-radio-group v-model="form.buyerMode">
            <el-radio
              :label="1"
              :disabled="unStart"
            >按结算金额优惠
            </el-radio>
            <el-radio
              :label="2"
              :disabled="unStart"
            >按结算数量优惠
            </el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item v-if="form.buyerMode" label="优惠门槛:" prop="buyer">
          <div v-if="form.buyerMode === 1">
            满
            <el-input-number
              v-model="form.buyer"
              :precision="2"
              :controls="false"
              :max="999999"
              :min="0"
              :disabled="unStart"
              style="width: 100px; margin: 0 10px"
            />
            元
          </div>
          <div v-if="form.buyerMode === 2">
            满
            <el-input-number
              v-model="form.buyer"
              :precision="0"
              :controls="false"
              :max="999999"
              :min="0"
              :disabled="unStart"
              style="width: 100px; margin: 0 10px"
            />
            件
          </div>
        </el-form-item>
        <el-form-item label="赠送内容:" prop="checkDiscount">
          <el-checkbox-group v-model="checkDiscount">
            <el-checkbox
              :label="1"
              :disabled="unStart"
            >优惠券
            </el-checkbox>
            <el-checkbox
              :label="2"
              :disabled="unStart"
            >成长值
            </el-checkbox>
            <el-checkbox
              :label="3"
              :disabled="unStart"
            >积分值
            </el-checkbox>
          </el-checkbox-group>
        </el-form-item>
        <el-form-item v-if="checkDiscount.indexOf(1) !== -1" label="赠送优惠券:" prop="details">
          <el-button
            class="selectCoupon"
            @click="showCouponTable"
          >选择优惠券
          </el-button>

          <div class="showCoupon" style="width:100%">
            <el-table
              v-show="couponSelectionList.length > 0"
              ref="showTable"
              :data="couponSelectionList"
              border
              :header-cell-style="{ background: '#EEF3FF', color: '#333333' }"
              tooltip-effect="dark"
              style="width: 800px"
            >
              <el-table-column
                prop="activityName"
                label="优惠券名称"
              />
              <el-table-column label="优惠类型">
                <template #default="scope">
                  <span v-if="scope.row.activityType === 1">满减</span>
                  <span v-if="scope.row.activityType === 2">折扣</span>
                </template>
              </el-table-column>
              <el-table-column
                prop="content"
                label="优惠券内容"
              >
                <template #default="scope">
                  <span v-if="scope.row.activityType === 1">
                    满{{ scope.row.threshold }}元 减{{
                      scope.row.couponContent
                    }}元
                  </span>
                  <span v-if="scope.row.activityType === 2">
                    满{{ scope.row.threshold }}元 打{{
                      scope.row.couponContent
                    }}折
                  </span>
                </template>
              </el-table-column>
              <el-table-column
                prop="time"
                label="到期时间"
              />
            </el-table>
          </div>
        </el-form-item>
        <el-form-item v-if="checkDiscount.indexOf(2) !== -1" label="赠送成长值:" prop="growth">
          赠送
          <el-input-number
            v-model="form.growth"
            :precision="0"
            :controls="false"
            :max="999999"
            :min="0"
            :disabled="unStart"
            style="width: 100px; margin: 0 10px"
          />
          点成长值
        </el-form-item>
        <el-form-item v-if="checkDiscount.indexOf(3) !== -1" label="赠送积分值:" prop="credit">
          赠送
          <el-input-number
            v-model="form.credit"
            :precision="0"
            :controls="false"
            :max="999999"
            :min="0"
            :disabled="unStart"
            style="width: 100px; margin: 0 10px"
          />
          点积分值
        </el-form-item>
      </el-form>
    </div>

    <!-- 选择优惠券 -->
    <el-dialog
      v-model="couponTableVisible"
      title="选择优惠券"
      center
      width="1000px"
      :close-on-click-modal="false"
      :append-to-body="true"
    >
      <div class="diaddStyle">
        <el-table
          ref="multipleTableRef"
          :data="couponList"
          :loading="couponloading"
          border
          :header-cell-style="{ background: '#EEF3FF', color: '#333333' }"
          tooltip-effect="dark"
          style="width: 100%"
          @selection-change="couponSelection"
        >
          <el-table-column
            type="selection"
            width="55"
            align="center"
          />
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
          <el-table-column
            prop="content"
            label="优惠券内容"
          />
          <el-table-column
            prop="time"
            label="到期时间"
          />
        </el-table>
      </div>
      <el-pagination
        :current-page="couponQuery.page"
        :page-size="10"
        layout="total, prev, pager, next"
        :total="couponTotal"
        style="float: right; margin: 10px 0"
        @current-change="handleCouponChange"
      />

      <template #footer>
        <span
          class="dialog-footer"
        >
          <el-button
            class="cancelCoupon"
            type="warning"
            @click="clearSelections"
          >取消选中内容</el-button>
          <el-button
            type="primary"
            @click="couponTableVisible = false"
          >确认</el-button>
        </span>
      </template>

    </el-dialog>
    <template #footer>
      <div class="btn_list">
        <el-button @click="closed">取消</el-button>
        <el-button type="primary" :loading="btnLoading" @click="save(formRef)">确认</el-button>
      </div>
    </template>
  </el-dialog>
</template>

<script setup>
import {
  addPoliteActivity,
  getPoliteCoupon,
  getPoliteDetail,
  updatePoliteActivity,
} from '@/api/active/active_polite.js'
import Form from './module'
import { computed, ref } from 'vue'

// 活动时间校验
const activityTime = (rule, value, callback) => {
  let signStartTime = Date.parse(date1.value[1])
  let timestamp = Date.parse(new Date())
  if (date1.value.length < 2) {
    return callback(new Error('请选择活动时间'))
  } else if (signStartTime < timestamp) {
    return callback(new Error('活动结束时间不能小于当前时间'))
  } else {
    callback()
  }
}
// 赠送内容校验
const giftContents = (rule, value, callback) => {
  if (checkDiscount.value.length < 1) {
    return callback(new Error('请至少选择一个赠送内容'))
  } else {
    callback()
  }
}
// 优惠券校验
const giftCoupons = (rule, value, callback) => {
  if (couponSelectionList.value.length < 1) {
    return callback(new Error('请至少选择一张优惠券'))
  } else {
    callback()
  }
}
const activityForm = ref({})
const visible = ref(false)
const formRef = ref(null)
const form = ref(new Form())
const date1 = ref([])
const couponTableVisible = ref(false)
const btnLoading = ref(false)
const couponloading = ref(false)
const couponQuery = ref({
  page: 1,
  pageSize: 10,
})
const couponList = ref([])
const couponTotal = ref(10)
const couponSelectionList = ref([])
const checkDiscount = ref([1])
const rules = {
  politeName: [{ required: true, message: '请输入活动名称', trigger: 'blur' }],
  startTime: [{ required: true, validator: activityTime, trigger: 'change' }],
  buyerMode: [{ required: true, message: '请选择优惠方式', trigger: 'change' }],
  buyer: [{ required: true, message: '请输入优惠门槛', trigger: 'blur' }],
  checkDiscount: [{ required: true, validator: giftContents, trigger: 'change' }],
  details: [{ required: true, validator: giftCoupons, trigger: 'change' }],
  growth: [{ required: true, message: '请输入赠送成长值', trigger: 'blur' }],
  credit: [{ required: true, message: '请输入赠送积分值', trigger: 'blur' }],
}
const unStart = computed(() => {
  const t = activityForm.value.politeId ? activityForm.value : null
  return t && !(t.state === 0)
})

const applyEnd = computed(() => {
  const t = activityForm.value.politeId ? activityForm.value : null
  return t && (t.state === 3 || t.state === 4)
})

// 打开弹窗
function open (row) {
  if (row) {
    activityForm.value = row
    getDetails()
  } else {
    activityForm.value = {}
  }
  visible.value = true
}
defineExpose({ open })
// 编辑时获取数据
async function getDetails () {
  const res = await getPoliteDetail({
    politeId: activityForm.value.politeId,
  })
  if (JSON.stringify(res.data) !== '{}') {
    form.value = res.data
    date1.value = [res.data.startTime, res.data.endTime]
    if (res.data.details && res.data.details.length > 0) {
      checkDiscount.value.push(1)
      couponSelectionList.value = res.data.details
    }
    if (res.data.growth > 0) {
      checkDiscount.value.push(2)
    }
    if (res.data.credit > 0) {
      checkDiscount.value.push(3)
    }
  }
}

const $emit = defineEmits(['refersh'])
// 打开优惠券表格
function showCouponTable () {
  couponTableVisible.value = true
  couponloading.value = true
  getCouponData()
}
// 翻页
function handleCouponChange (val) {
  couponQuery.value.page = val
  getCouponData()
}
// 获取优惠券列表
async function getCouponData () {
  const res = await getPoliteCoupon(couponQuery.value)
  couponList.value = res.data.list
  couponTotal.value = res.data.total
}

// 选择优惠券
function couponSelection (val) {
  couponSelectionList.value = val
}

const multipleTableRef = ref()
// 清空选中的优惠券
function clearSelections () {
  multipleTableRef.value.clearSelection()
  form.value.details = []
}
// 保存
function save (formEl) {
  if (!formEl) return
  formEl.validate(valid => {
    if (valid) {
      btnLoading.value = true
      if (couponSelectionList.value.length !== 0) {
        form.value.details = couponSelectionList.value.map((item) => {
          return {
            activityId: item.activityId,
            activityName: item.activityName,
            activityType: item.activityType,
            couponContent: item.couponContent,
            threshold: item.threshold,
          }
        })
      }
      let params = Object.assign({}, form.value, {
        startTime: date1.value[0] || '',
        endTime: date1.value[1] || '',
      })
      let fn = addPoliteActivity
      if (activityForm.value.politeId) {
        params.id = activityForm.value.politeId
        fn = updatePoliteActivity
      }
      fn(params).then((res) => {
        if (res.code === '') {
          ElMessage.success('操作成功')
          $emit('refersh')
          closed()
        }
      }).finally(() => {
        btnLoading.value = false
      })
    }
  })
}
// 弹窗关闭时清空表单数据
function closed () {
  visible.value = false
  formRef.value.resetFields()
  form.value = new Form()
  date1.value = []
  couponList.value = []
}
</script>

<style lang="scss" scoped>
  h2 {
    font-size: 24px;
    font-weight: 500;
    position: relative;

    &::before {
      content: '';
      height: 24px;
      width: 4px;
      background-color: #3a68f2;
      position: absolute;
      left: -10px;
      top: 2px;
      display: block;
    }
  }

  .content {
    background-color: #fff;
    padding: 0 50px 0;
    overflow: hidden;

    .el-form {
      .el-form-item {
        :deep(.el-form-item__label) {
          font-weight: bold;
        }
      }
    }

    .photo {
      padding: 70px 100px;

      .avatar-uploader {
        width: 180px;

        .el-icon-plus,
        img {
          width: 180px;
          height: 180px;
          line-height: 180px;
          border: 1px #bbb solid;
          border-radius: 4px 4px 0px 4px;
          margin-bottom: 10px;
          text-align: center;
        }

        img {
          border: none;
        }
      }
    }
  }
    .btn_list {
      height: 80px;
      line-height: 80px;
      border-top: 1px solid #e0e5eb;
      text-align: right;
      .el-button {
        height: 38px;
      }
    }

  .timeInfo {
    font-size: 12px;
    color: #999999;
  }

  .el-input {
    width: 400px;
  }

  .selectCoupon {
    width: 200px;
    margin-bottom: 12px;
    border: 1px solid #dcdfe6;
  }

  .cancelCoupon {
    display: block;
    margin: 20px 0 10px 820px;
  }
</style>
