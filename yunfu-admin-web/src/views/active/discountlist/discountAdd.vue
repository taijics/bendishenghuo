<template>
  <el-dialog
    v-model="visible"
    :title="activityForm.discountId ? '修改优限时折扣活动' : '新增限时折扣活动'"
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
        label-width="100px"
      >
        <br />
        <h2>基础信息</h2>
        <br />
        <el-form-item label="活动名称:" prop="discountName">
          <el-input
            v-model="form.discountName"
            maxlength="20"
            placeholder="请输入活动名称"
            :disabled="unStart"
          />
        </el-form-item>
        <el-form-item label="活动介绍:">
          <el-input
            v-model="form.remark"
            maxlength="200"
            type="textarea"
            placeholder="请输入活动介绍"
            :disabled="unStart"
            style="width: 400px"
          />
        </el-form-item>
        <!-- :picker-options="pickerOptions" -->
        <el-form-item label="报名时间:" prop="startTime">
          <el-date-picker
            v-model="date2"
            type="datetimerange"
            range-separator="至"
            start-placeholder="开始时间"
            end-placeholder="结束时间"
            value-format="YYYY-MM-DD HH:mm:ss"
            :clearable="false"
          />
          <p class="timeInfo">报名时间不能交叉且报名时间不能大于活动时间</p>
        </el-form-item>
        <el-form-item label="活动时间:" prop="signStartTime">
          <el-date-picker
            v-model="date1"
            type="datetimerange"
            range-separator="至"
            start-placeholder="开始时间"
            end-placeholder="结束时间"
            value-format="YYYY-MM-DD HH:mm:ss"
            :disabled="unStart"
            :clearable="false"
          />
          <p class="timeInfo">
            平台活动时间不能交叉并且活动时间不能小于报名时间
          </p>
        </el-form-item>
        <el-form-item label="活动保证金:" prop="ifBond">
          <el-radio-group v-model="form.ifBond">
            <el-radio
              :label="1"
              :disabled="unStart"
            >需要
            </el-radio>
            <el-radio
              :label="0"
              :disabled="unStart"
            >不需要
            </el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item v-if="form.ifBond === 1" label="保证金金额:" prop="bondMoney">
          <el-input-number
            v-model="form.bondMoney"
            :precision="2"
            :controls="false"
            :max="999999"
            :min="0"
            placeholder="请输入活动保证金金额"
            :disabled="unStart"
          />
        </el-form-item>
        <h2>优惠规则</h2>
        <br />
        <el-form-item label="全场折扣:" prop="discount">
          <el-input-number
            v-model="form.discount"
            :precision="0"
            :controls="false"
            :max="999999"
            :min="0"
            :disabled="unStart"
            style="width: 100px; margin-right: 12px"
          />
          折
        </el-form-item>
        <el-form-item label="是否限购:" prop="ifLimit">
          <el-radio-group v-model="form.ifLimit">
            <el-radio
              :label="2"
              :disabled="unStart"
            >限购
            </el-radio>
            <el-radio
              :label="1"
              :disabled="unStart"
            >不限购
            </el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item v-if="form.ifLimit === 2" label="限购(件/人):" prop="limitNumber">
          <el-input-number
            v-model="form.limitNumber"
            :precision="0"
            :controls="false"
            :max="999999"
            :min="0"
            :disabled="unStart"
          />
        </el-form-item>
        <el-form-item label="优惠券叠加:" prop="ifAdd">
          <el-radio-group v-model="form.ifAdd">
            <el-radio
              :label="1"
              :disabled="unStart"
            >叠加
            </el-radio>
            <el-radio
              :label="0"
              :disabled="unStart"
            >不叠加
            </el-radio>
          </el-radio-group>
        </el-form-item>
      </el-form>
    </div>
    <template #footer>
      <div class="btn_list">
        <el-button @click="closed">取消</el-button>
        <el-button type="primary" :loading="btnLoading" @click="save(formRef)">确认</el-button>
      </div>
    </template>
  </el-dialog>
</template>

<script setup>
import { addDiscountData, editDiscountData, getDiscountDetail, } from '@/api/active/active_discount.js'
import Form from './modul'
import { computed, ref } from 'vue';

const $emit = defineEmits(['refersh'])
// 报名时间校验
const enrollmentTime = (rule, value, callback) => {
  let startTime = Date.parse(date2.value[1])
  let timestamp = Date.parse(new Date())
  if (date2.value.length < 2) {
    return callback(new Error('请选择报名时间'))
  } else if (startTime < timestamp) {
    return callback(new Error('报名结束时间不能小于当前时间'))
  } else {
    callback()
  }
}
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
const rules = {
  discountName: [{ required: true, message: '请输入活动名称', trigger: 'blur' }],
  startTime: [{ required: true, validator: enrollmentTime, trigger: 'change' }],
  signStartTime: [{ required: true, validator: activityTime, trigger: 'change' }],
  ifBond: [{ required: true, message: '请选择是否需要活动保证金', trigger: 'change' }],
  bondMoney: [{ required: true, message: '请输入保证金金额', trigger: 'blur' }],
  discount: [{ required: true, message: '请输入全场折扣', trigger: 'blur' }],
  ifLimit: [{ required: true, message: '请选择是否限购', trigger: 'change' }],
  limitNumber: [{ required: true, message: '请输入限购数量', trigger: 'blur' }],
  ifAdd: [{ required: true, message: '请选择是否可以优惠券叠加', trigger: 'change' }],
}
const visible = ref(false)
const formRef = ref(null)
const activityForm = ref({})
const form = ref(new Form())
const btnLoading = ref(false)
const date1 = ref([])
const date2 = ref([])
const unStart = computed(() => {
  const t = activityForm.value.discountId ? activityForm.value : null
  return t && !(t.state === 0)
})
const applyEnd = computed(() => {
  const t = activityForm.value.discountId ? activityForm.value : null
  return t && (t.state === 3 || t.state === 4)
})

// 弹窗打开
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
  const res = await getDiscountDetail({
    discountId: activityForm.value.discountId,
  })
  if (JSON.stringify(res.data) !== '{}') {
    form.value = res.data
    date1.value = [res.data.startTime, res.data.endTime]
    date2.value = [res.data.signStartTime, res.data.signEndTime]
  }
}
// 保存
function save (formEl) {
  if (!formEl) return
  formEl.validate(valid => {
    if (valid) {
      btnLoading.value = true
      const params = Object.assign({}, form.value, {
        startTime: date1.value[0] || '',
        endTime: date1.value[1] || '',
        signStartTime: date2.value[0] || '',
        signEndTime: date2.value[1] || '',
        bondMoney: form.value.bondMoney * 1,
      })
      let fn = addDiscountData
      if (activityForm.value.discountId) {
        fn = editDiscountData
        params.details = params.promotionDetail
        params.discountId = activityForm.value.discountId
      }
      fn(params).then((res) => {
        if (res.code === '') {
          ElMessage.success('新增成功')
          $emit('refersh')
          closed()
        }
      }).finally(() => {
        btnLoading.value = false
      })
    }
  })
}
// 弹窗关闭后清空表单数据
function closed () {
  visible.value = false
  formRef.value.resetFields()
  form.value = new Form()
  date1.value = []
  date2.value = []
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
</style>
