<template>
  <div class="integralPage">
    <div class="configuration">
      <el-form
        ref="ruleFormRef"
        :model="ruleForm"
        :rules="rules"
        label-width="240px"
      >
        <el-form-item
          label="积分"
          prop="switch"
        >
          <el-radio-group
            v-model="ruleForm.switch"
            @change="updateConfig('credit_switch', ruleForm.switch)"
          >
            <el-radio label="1">开启</el-radio>
            <el-radio label="0">关闭</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item
          label="下单后每1元赠送多少积分给客户"
          prop="proportion"
        >
          <el-input
            v-model.number="ruleForm.proportion"
            maxlength="9"
            oninput="value=value.replace(/[^\d]/g,'')"
            @blur="updateConfig('credit_order_rate', ruleForm.proportion)"
          />
        </el-form-item>
        <el-form-item
          label="满足多少元可以抵扣积分"
          prop="deduction"
        >
          <el-input
            v-model="ruleForm.deduction"
            maxlength="9"
            @blur="
              updateConfig('credit_order_amount_threshold', ruleForm.deduction)
            "
          />
        </el-form-item>
        <el-form-item
          label="积分抵扣金额比例"
          prop="priceNum"
          class="priceNum"
        >
          <el-input
            v-model="ruleForm.priceNum"
            maxlength="9"
            @blur="updateConfig('credit_exchange_rate', ruleForm.priceNum)"
          />
          <span>1积分可抵扣多少额度</span>
        </el-form-item>
        <el-form-item
          label="每笔订单最多抵扣多少积分"
          prop="priceNum"
        >
          <el-input
            v-model="ruleForm.integralNum"
            maxlength="9"
            @blur="updateConfig('credit_deduct_limit', ruleForm.integralNum)"
          />
        </el-form-item>
      </el-form>
    </div>
  </div>
</template>

<script setup>
import { dictGetChilds, dictUpdate } from '@/api/setup'
import { onMounted, ref } from 'vue';

const checkIntegralProportion = (rule, value, callback) => {
  const reg = /^[0-9]*[1-9][0-9]*$/
  if (!value || value > 10000 || value < 1 || !reg.test(value)) {
    return callback(new Error('请输入1-10000之间的整数'))
  } else {
    callback()
  }
}
// 满多少抵扣
const checkFullMinus = (rule, value, callback) => {
  if (!value) {
    return callback(new Error('请输入满多少可以抵扣！'))
  } else if (!Number(value)) {
    return callback(new Error('请输入正确的数值！'))
  } else {
    callback()
  }
}
// 积分支付比例
const checkProportion = (rule, value, callback) => {
  if (!value) {
    return callback(new Error('请输入积分支付金额比例！'))
  } else if (!Number(value)) {
    return callback(new Error('请输入正确的数值！'))
  } else {
    callback()
  }
}
// 最高使用积分
const checkHighestUsed = (rule, value, callback) => {
  if (!value) {
    return callback(new Error('请输入每笔订单最多抵扣多少积分！'))
  } else if (!Number(value)) {
    return callback(new Error('请输入正确的数值！'))
  } else {
    callback()
  }
}

const ruleForm = ref({
  proportion: '',
  deduction: '',
  switch: '',
  priceNum: '',
  integralNum: '',
})

const addForm = ref({
  createTime: '',
  dictDescribe: '',
  dictId: '',
  dictName: '',
  dictPid: 1900,
  updateTime: '',
})

const oldData = ref({
  proportion: '',
  deduction: '',
  switch: '',
  priceNum: '',
  integralNum: '',
})

const sonInline = ref({
  dictPid: '1900',
  page: 1,
  pageSize: 10,
})

const dictList = ref([])

const rules = {
  proportion: [
    {
      required: true,
      validator: checkIntegralProportion,
      trigger: 'blur',
    },
  ],
  deduction: [
    { required: true, validator: checkFullMinus, trigger: 'blur' },
  ],
  priceNum: [
    { required: true, validator: checkProportion, trigger: 'blur' },
  ],
  integralNum: [
    { required: true, validator: checkHighestUsed, trigger: 'blur' },
  ],
  switch: [
    { required: true, message: '请选择积分是否开关', trigger: 'change' },
  ]
}

onMounted(() => {
  getInfo()
})

const ruleFormRef = ref()
function updateConfig (dictName, value) {
  ruleFormRef.value.validate((valid) => {
    if (valid) {
      if (value !== '') {
        for (let i = 0; i < dictList.value.length; i++) {
          if (dictList.value[i].dictName === dictName) {
            addForm.value.dictId = dictList.value[i].dictId
            break
          }
        }
        if (dictName === 'credit_order_rate') {
          if (ruleForm.value.proportion !== oldData.value.proportion) {
            changeFn(dictName, value)
          }
        } else if (dictName === 'credit_order_amount_threshold') {
          if (ruleForm.value.deduction !== oldData.value.deduction) {
            changeFn(dictName, value)
          }
        } else if (dictName === 'credit_switch') {
          changeFn(dictName, value)
        } else if (dictName === 'credit_exchange_rate') {
          if (ruleForm.value.priceNum !== oldData.value.priceNum) {
            changeFn(dictName, value)
          }
        } else if (dictName === 'credit_deduct_limit') {
          if (ruleForm.value.integralNum !== oldData.value.integralNum) {
            changeFn(dictName, value)
          }
        }
      }
    }
  })
}
function changeFn (dictName, value) {
  addForm.value.dictName = dictName
  addForm.value.dictDescribe = value
  dictUpdate(addForm.value).then((res) => {
    if (res.code === '') {
      ElMessage({
        message: '修改成功',
        type: 'success',
      })
      getInfo()
    }
  })
}

// 初始化查询所有数据
function getInfo () {
  dictGetChilds(sonInline.value).then((res) => {
    dictList.value = res.data.list
    dictList.value.forEach((item) => {
      if (item.dictName === 'credit_switch') {
        ruleForm.value.switch = item.dictDescribe
        oldData.value.switch = item.dictDescribe
      }
      if (item.dictName === 'credit_order_amount_threshold') {
        ruleForm.value.deduction = item.dictDescribe
        oldData.value.deduction = item.dictDescribe
      }
      if (item.dictName === 'credit_order_rate') {
        ruleForm.value.proportion = item.dictDescribe
        oldData.value.proportion = item.dictDescribe
      }
      if (item.dictName === 'credit_exchange_rate') {
        ruleForm.value.priceNum = item.dictDescribe
        oldData.value.priceNum = item.dictDescribe
      }
      if (item.dictName === 'credit_deduct_limit') {
        ruleForm.value.integralNum = item.dictDescribe
        oldData.value.integralNum = item.dictDescribe
      }
    })
  })
}
</script>

<style
    lang="scss"
    scpoed
>
.integralPage {
  padding: 32px 20px;

  .configuration {
    width: 600px;
  }
  .el-input__inner {
    height: 38px;
  }

  .integralBox {
    span {
      color: #999999;
      font-size: 12px;
    }
  }
}
</style>
