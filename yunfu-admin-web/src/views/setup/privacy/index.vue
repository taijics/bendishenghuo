<template>
  <div class="integralPage">
    <div class="configuration">
      <el-form
        ref="formRef"
        :model="ruleForm"
        :rules="rules"
        label-width="100px"
      >
        <el-form-item label="认证时间">{{ now_time }}</el-form-item>
        <el-form-item v-if="Number(privacyTime) === 0" label="管理员电话">
          <el-input
            disabled
            :model-value="hidden(ruleForm.newPhone, 3, 4)"
            placeholder="请输入管理员电话"
          />
        </el-form-item>
        <el-form-item v-else label="管理员电话" prop="newPhone">
          <el-input
            v-model="ruleForm.newPhone"
            disabled
            placeholder="请输入管理员电话"
          />
        </el-form-item>
        <el-form-item
          label="验证码"
          prop="code"
        >
          <el-input
            v-model="ruleForm.code"
            maxlength="6"
            placeholder="请输入验证码"
          >
            <template #append>
              <el-button
                :loading="codeloading"
                @click="getCode(ruleForm.newPhone)"
              >
                <span v-if="!codeloading">获取验证码</span>
                <span v-else>{{ count }} s</span>
              </el-button>
            </template>
          </el-input>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" :loading="submitLoading" @click="submint(formRef)">确定</el-button>
        </el-form-item>
      </el-form>
    </div>
  </div>
</template>

<script setup>
import { getAdminPhone, getPrivacyCode, verifyPrivacyCode } from '@/api/privacy'
import { encrypt } from '@/utils/rsaEncrypt.js'
import { onMounted, ref } from 'vue';

const TIME_COUNT = 120 // 更改倒计时时间
// 管理员手机号码
const newPhoneVal = (rule, value, callback) => {
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
const formRef = ref(null)
const ruleForm = ref({
  newPhone: '',
  code: '',
})
const rules = {
  newPhone: [{ required: true, validator: newPhoneVal, trigger: 'blur' }],
  code: [{ required: true, validator: code, trigger: 'blur' }],
}
const submitLoading = ref(false)
const codeloading = ref(false)
const count = ref('')
const timer = ref(null)
const privacyTime = ref(0)
const now_time = ref('')
onMounted(() => {
  getPhone()
  // 获取认证的时间
  privacyTime.value = localStorage.getItem('privacyTime')
  if (Number(privacyTime.value) === 0) {
    now_time.value = '未认证'
  } else {
    const time = new Date(Number(privacyTime.value))
    const year = time.getFullYear()
    const month = time.getMonth() + 1
    const day = time.getDate()
    const hours = time.getHours()
    const minutes = time.getMinutes()
    now_time.value =
        year + '-' + month + '-' + day + ' ' + hours + ':' + minutes
  }
})

// 获取管理员电话
function getPhone () {
  getAdminPhone().then((res) => {
    ruleForm.value.newPhone = res.data
  })
}

// 获取验证码
async function getCode (phone) {
  if (phone === '' || phone === undefined) {
    ElMessage.error('请填写手机号')
    return
  }
  if (/^1[3456789]\d{9}$/.test(phone) === false) {
    ElMessage.error('请填写正确手机号')
    return false
  }
  if (!timer.value) {
    codeloading.value = true
    count.value = TIME_COUNT
    const res = await getPrivacyCode({ phone })
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

// 确定
async function submint (formEl) {
  if (!formEl) return
  formEl.validate(valid => {
    if (valid) {
      submitLoading.value = true
      timer.value = null
      codeloading.value = false
      const data = {
        code: encrypt(ruleForm.value.code),
        username: encrypt(ruleForm.value.newPhone)
      }
      verifyPrivacyCode(data).then(res => {
        if (res.data === true) {
          ElMessage({
            message: '二次认证成功，该认证24小时内有效，超过时间需要重新认证',
            type: 'success',
          })
          formEl.resetFields()
          location.reload()
        }
      }).finally(() => {
        submitLoading.value = false
      })
    } else {
      return false
    }
  })
}

// 中间部分
function hidden (str, frontLen, endLen) {
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
