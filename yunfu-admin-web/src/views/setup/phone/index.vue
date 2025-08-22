<template>
  <div class="integralPage">
    <div class="configuration">
      <el-form
        ref="formRef"
        :model="formData"
        :rules="rules"
        label-width="100px"
      >
        <el-form-item v-if="Number(privacyTime) === 0" label="旧手机号">
          <el-input
            disabled
            :model-value="hidden(formData.oldPhone, 3, 4)"
            placeholder="请输入旧手机号"
          />
        </el-form-item>
        <el-form-item v-else label="旧手机号" prop="oldPhone">
          <el-input
            v-model="formData.oldPhone"
            disabled
            placeholder="请输入旧手机号"
          />
        </el-form-item>
        <el-form-item label="新手机号" prop="newPhone">
          <el-input
            v-model="formData.newPhone"
            maxlength="11"
            placeholder="请输入新手机号"
          />
        </el-form-item>
        <el-form-item label="验证码" prop="code">
          <el-input
            v-model="formData.code"
            maxlength="6"
            placeholder="请输入验证码"
          >
            <template #append>
              <el-button
                class="codeBtn"
                type="primary"
                :loading="codeloading"
                @click="getCode(formData.oldPhone)"
              >
                <span v-if="!codeloading">获取验证码</span>
                <span v-else>{{ count }} s</span>
              </el-button>
            </template>
          </el-input>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" :loading="loading" @click="submint(formRef)"> 确定 </el-button>
        </el-form-item>
      </el-form>
    </div>
  </div>
</template>

<script setup>
import { ref, onBeforeMount } from 'vue'
import { getAdminPhone, getUpdatePhoneCode, updatePhone } from '@/api/privacy'
import { encrypt } from '@/utils/rsaEncrypt.js'
const TIME_COUNT = 120 // 更改倒计时时间
// 旧手机号
const oldPhone = (rule, value, callback) => {
  if (!value) {
    return callback(new Error('请输入旧手机号'))
  } else if (/^1[3456789]\d{9}$/.test(value) === false) {
    return callback(new Error('请输入正确的手机号'))
  } else {
    callback()
  }
}
// 新手机号
const newPhone = (rule, value, callback) => {
  if (!value) {
    return callback(new Error('请输入新手机号'))
  } else if (/^1[3456789]\d{9}$/.test(value) === false) {
    return callback(new Error('请输入正确的手机号'))
  } else {
    callback()
  }
}
// 验证码
const code = (rule, value, callback) => {
  if (!value) {
    return callback(new Error('请输入验证码'))
  } else {
    callback()
  }
}
const loading = ref(false)
const formRef = ref(null)
const formData = ref({
  oldPhone: '',
  newPhone: '',
  code: '',
})
const rules = ref({
  oldPhone: [{ required: true, validator: oldPhone, trigger: 'blur' }],
  newPhone: [{ required: true, validator: newPhone, trigger: 'blur' }],
  code: [{ required: true, validator: code, trigger: 'blur' }],
})
const codeloading = ref(false)
const count = ref('')
const timer = ref(null)
const privacyTime = ref(0)

onBeforeMount(() => {
  getPhone()
  privacyTime.value = localStorage.getItem('privacyTime')
})
// 获取管理员电话
const getPhone = () => {
  getAdminPhone().then((res) => {
    formData.value.oldPhone = res.data
  })
}
// 获取验证码
const getCode = async (phone) => {
  if (!phone) {
    ElMessage.error('请填写新手机号')
    return
  }
  if (/^1[3456789]\d{9}$/.test(phone) === false) {
    ElMessage.error('请填写正确手机号')
    return false
  }
  if (!timer.value) {
    codeloading.value = true
    count.value = TIME_COUNT
    const res = await getUpdatePhoneCode({ phone })
    if (res.code === '') {
      ElMessage({
        message: '发送成功，请注意查看手机短信',
        type: 'success',
      })
    }
    timer.value = setInterval(() => {
      if (count.value > 0 && count.value <= TIME_COUNT) {
        count.value--
      } else {
        clearInterval(timer.value) // 清除定时器
        timer.value = null
        codeloading.value = false
      }
    }, 1000)
  }
}
const submint = async (formEl) => {
  if (!formEl) return
  await formEl.validate((valid, fields) => {
    if (valid) {
      loading.value = true
      timer.value = null
      codeloading.value = false
      const data = {
        code: encrypt(formData.value.code),
        newPhone: encrypt(formData.value.newPhone),
        phone: encrypt(formData.value.oldPhone)
      }
      updatePhone(data).then((res) => {
        if (res.code === '') {
          ElMessage({
            message: '手机号修改成功',
            type: 'success',
          })
          formEl.resetFields()
          getPhone()
        }
      }).finally(() => {
        loading.value = false
      })
    } else {
      return false
    }
  })
}
// 中间部分
const hidden = (str, frontLen, endLen) => {
  let endLenData = 0
  if (str.length !== 2) {
    endLenData = endLen
  }
  const len = str.length - frontLen - endLenData
  let xing = ''
  for (let i = 0; i < len; i++) {
    xing += '*'
  }
  return (
    str.substring(0, frontLen) +
    xing +
    str.substring(str.length - endLenData)
  )
}
</script>

<style lang="scss" scpoed>
.integralPage {
  padding: 32px 20px;
  .configuration {
    width: 600px;
  }
  .el-form-item__label {
    font-weight: bold;
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
