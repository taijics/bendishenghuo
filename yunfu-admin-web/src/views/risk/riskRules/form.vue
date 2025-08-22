<template>
  <el-dialog
    v-model="visible"
    :close-on-click-modal="false"
    :title="isAdd ? '新建规则' : '编辑规则'"
    width="600px"
  >
    <el-form
      ref="formRef"
      :model="form"
      :rules="rules"
      label-width="80px"
    >
      <el-form-item
        label="规则名称"
        prop="ruleName"
      >
        <el-input
          v-model="form.ruleName"
          maxlength="20"
        />
      </el-form-item>
      <el-form-item label="规则关系">
        <el-radio-group v-model="form.ruleType">
          <el-radio :label="1">满足以下任一规则</el-radio>
          <el-radio :label="2">满足以下全部规则</el-radio>
        </el-radio-group>
      </el-form-item>
      <div class="group-head">
        <b>基础规则1： 创建订单数限制</b>
        <el-switch
          v-model="form.ruleSwitchPlaceOrder"
          :active-value="1"
          :inactive-value="0"
        />
      </div>
      <div class="group-body">
        最近
        <el-input
          v-model="rulePlaceOrderLimit.timeNum"
          onkeyup="value=value.replace(/[^\d]/g,'')"
          maxlength="9"
          placeholder="输入小时数"
        />
        小时，创建订单数
        <el-select
          v-model="rulePlaceOrderLimit.compare"
          placeholder="请选择"
        >
          <el-option
            v-for="item in options"
            :key="item.value"
            :label="item.label"
            :value="item.value"
          />
        </el-select>
        <el-input
          v-model="rulePlaceOrderLimit.num"
          class="mar-l"
          onkeyup="value=value.replace(/[^\d]/g,'')"
          maxlength="9"
          placeholder="输入订单数"
        />
      </div>
      <div class="group-head">
        <b>基础规则2： 待付款订单数限制</b>
        <el-switch
          v-model="form.ruleSwitchWaitPay"
          :active-value="1"
          :inactive-value="0"
        />
      </div>
      <div class="group-body">
        最近
        <el-input
          v-model="ruleWaitPayLimit.timeNum"
          onkeyup="value=value.replace(/[^\d]/g,'')"
          maxlength="9"
          placeholder="输入小时数"
        />
        小时，待付款订单数
        <el-select
          v-model="ruleWaitPayLimit.compare"
          placeholder="请选择"
        >
          <el-option
            v-for="item in options"
            :key="item.value"
            :label="item.label"
            :value="item.value"
          />
        </el-select>
        <el-input
          v-model="ruleWaitPayLimit.num"
          class="mar-l"
          onkeyup="value=value.replace(/[^\d]/g,'')"
          maxlength="9"
          placeholder="输入订单数"
        />
      </div>
      <div class="group-head">
        <b>基础规则3： 单sku商品采购数限制</b>
        <el-switch
          v-model="form.ruleSwitchSku"
          :active-value="1"
          :inactive-value="0"
        />
      </div>
      <div class="group-body">
        单sku商品采购数量
        <el-select
          v-model="ruleSkuLimit.compare"
          placeholder="请选择"
        >
          <el-option
            v-for="item in options"
            :key="item.value"
            :label="item.label"
            :value="item.value"
          />
        </el-select>
        <el-input
          v-model="ruleSkuLimit.num"
          class="mar-l"
          onkeyup="value=value.replace(/[^\d]/g,'')"
          maxlength="9"
          placeholder="输入采购数"
        />
      </div>
      <div class="group-head">
        <b>基础规则4： 售后订单数限制</b>
        <el-switch
          v-model="form.ruleSwitchPostSale"
          :active-value="1"
          :inactive-value="0"
        />
      </div>
      <div class="group-body">
        最近
        <el-input
          v-model="rulePostSaleLimit.timeNum"
          onkeyup="value=value.replace(/[^\d]/g,'')"
          maxlength="9"
          placeholder="输入月数"
        />
        个月，售后订单数
        <el-select
          v-model="rulePostSaleLimit.compare"
          placeholder="请选择"
        >
          <el-option
            v-for="item in options"
            :key="item.value"
            :label="item.label"
            :value="item.value"
          />
        </el-select>
        <el-input
          v-model="rulePostSaleLimit.num"
          class="mar-l"
          onkeyup="value=value.replace(/[^\d]/g,'')"
          maxlength="9"
          placeholder="输入采购数"
        />
      </div>
    </el-form>
    <template #footer>
      <div
        class="dialog-footer"
      >
        <el-button
          @click="doCancel"
        >取消
        </el-button>
        <el-button
          type="primary"
          @click="doSubmit"
        >确认
        </el-button>
      </div>
    </template>

  </el-dialog>
</template>

<script setup>
import { addRule, updateRule } from '@/api/risk'
import { ref } from 'vue';

const visible = ref(false)
const form = ref({
  ruleName: '',
  ruleType: 1,
  ruleSwitchPlaceOrder: 0,
  ruleSwitchPostSale: 0,
  ruleSwitchSku: 0,
  ruleSwitchWaitPay: 0,
  rulePlaceOrderLimit: {},
  rulePostSaleLimit: {},
  ruleSkuLimit: {},
  ruleWaitPayLimit: {},
})
const rules = {
  ruleName: [
    { required: true, message: '规则名称不能为空', trigger: 'blur' },
  ],
}
const rulePlaceOrderLimit = ref({
  timeNum: 0,
  compare: 'lt',
  num: 0,
})
const rulePostSaleLimit = ref({
  timeNum: 0,
  compare: 'lt',
  num: 0,
})
const ruleSkuLimit = ref({
  compare: 'lt',
  num: 0,
})
const ruleWaitPayLimit = ref({
  timeNum: 0,
  compare: 'lt',
  num: 0,
})
const cateId = ref(null)
const options = ref([
  {
    value: 'lt',
    label: '小于',
  },
  {
    value: 'eq',
    label: '等于',
  },
  {
    value: 'gt',
    label: '大于',
  },
])
const isAdd = ref(false)

function show (row) {
  isAdd.value = !row
  if (isAdd.value) {
    form.value = {
      ruleName: '',
      ruleType: 1,
      ruleSwitchPlaceOrder: 0,
      ruleSwitchPostSale: 0,
      ruleSwitchSku: 0,
      ruleSwitchWaitPay: 0,
      status: 1,
    }
    rulePlaceOrderLimit.value = {}
    rulePostSaleLimit.value = {}
    ruleSkuLimit.value = {}
    ruleWaitPayLimit.value = {}
  } else {
    form.value = JSON.parse(JSON.stringify(row))
    rulePlaceOrderLimit.value = JSON.parse(row.rulePlaceOrderLimit)
    rulePostSaleLimit.value = JSON.parse(row.rulePostSaleLimit)
    ruleSkuLimit.value = JSON.parse(row.ruleSkuLimit)
    ruleWaitPayLimit.value = JSON.parse(row.ruleWaitPayLimit)
  }
  visible.value = true
}

function doCancel () {
  visible.value = false
}

const $emit = ref(['reset'])
const formRef = ref()

function doSubmit () {
  formRef.value.validate((valid) => {
    if (valid) {
      form.value.rulePlaceOrderLimit = JSON.stringify(
        rulePlaceOrderLimit.value
      )
      form.value.rulePostSaleLimit = JSON.stringify(rulePostSaleLimit.value)
      form.value.ruleSkuLimit = JSON.stringify(ruleSkuLimit.value)
      form.value.ruleWaitPayLimit = JSON.stringify(ruleWaitPayLimit.value)
      if (isAdd.value) {
        addRule(form.value)
          .then((res) => {
            ElMessage({
              message: '新增成功',
              type: 'success',
            })
            $emit('reset')
          }).finally(() => {
            visible.value = false
          })
      } else {
        updateRule(form.value)
          .then((res) => {
            ElMessage({
              message: '修改成功',
              type: 'success',
            })
            $emit('reset')
          }).finally(() => {
            visible.value = false
          })
      }
    }
  })
}

defineExpose({ show })
</script>

<style lang="scss" scoped>
.group-head {
  margin-bottom: 10px;
  display: flex;
  justify-content: space-between;
}
:deep(.el-form-item) {
  .el-input {
    .el-input__inner {
      height: 38px;
    }
  }
}
.group-body {
  margin-bottom: 30px;

  .el-input,.el-select {
    width: 100px;

    :deep(.el-input__inner) {
      padding-right: 0;
      height: 38px;
    }
  }

  .el-select {
    width: 100px;
  }

  .mar-l {
    margin-left: 10px;
  }
}

.el-table .el-button {
  margin-left: 0;
}
</style>
