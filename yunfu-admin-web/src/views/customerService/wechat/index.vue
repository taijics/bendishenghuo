<template>
  <div class="servicePage">
    <div class="configuration">
      <el-form
        ref="formRef"
        :model="ruleForm"
        :rules="rules"
        label-width="100px"
      >
        <el-form-item label="服务ID" prop="serviceId">
          <el-input v-model="ruleForm.serviceId" maxlength="20" />
        </el-form-item>
        <el-form-item label="Secret" prop="serviceSecret">
          <el-input v-model="ruleForm.serviceSecret" maxlength="20" />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="submitForm(formRef)">保存</el-button>
          <el-button @click="resetForm(formRef)">重置</el-button>
        </el-form-item>
      </el-form>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'

const formRef = ref(null)
const ruleForm = ref({
  serviceId: '',
  serviceSecret: ''
})
const rules = ref({
  serviceId: [
    { required: true, message: '请输入服务ID', trigger: 'blur' },
  ],
  serviceSecret: [
    { required: true, message: '请输入Secret', trigger: 'blur' }
  ]
})

const submitForm = (formEl) => {
  if (!formEl) return
  formEl.validate((valid) => {
    if (valid) {
      alert('submit!')
    } else {
      console.log('error submit!!')
      return false
    }
  })
}
const resetForm = (formEl) => {
  formEl.resetFields()
}
</script>

<style lang="scss" scpoed>
.servicePage {
  padding: 32px 20px;
  .configuration {
    width: 600px;
  }
  .el-input {
    width: 70%;
    .el-input__inner {
      height: 38px;
    }
  }
  .el-button {
    height: 38px;
  }
}
</style>
