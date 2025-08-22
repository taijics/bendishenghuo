<template>
  <div class="login-code">
    <el-button
      class="codeBtn"
      type="primary"
      :loading="loading.btns"
      @click="handleGetCode"
    >
      <span v-if="!loading.btns">获取验证码</span>
      <span v-else>{{ count }} s</span>
    </el-button>
  </div>
</template>

<script setup>
import { reactive, shallowRef, toRefs } from 'vue';

import { getCode } from '@/api/user'
const props = defineProps({
  phone: {
    type: String,
    default: ''
  },
  verificationCode: {
    type: String,
    default: ''
  }
})
const { phone, verificationCode } = toRefs(props);

const TIME_COUNT = 60;
let count = shallowRef(0);
let loading = reactive({
  btns: false
})
let interval = reactive({
  count: null
})

async function handleGetCode () {
  if (!phone.value) {
    ElMessage.error('请填写电话号码')
    return
  }
  const phoneReg = /^1[3456789]\d{9}$/;
  if (!phoneReg.test(phone.value)) {
    ElMessage.error('请填写正确手机号')
    return false
  }
  if (!verificationCode.value) {
    ElMessage.error('请填写图形验证码')
    return
  }
  if (!interval.count) {
    loading.btns = true
    count.value = TIME_COUNT
    const res = await getCode({
      phone: phone.value,
      code: verificationCode.value
    })
    if (res.code === '') {
      ElMessage({
        message: '发送成功，请注意查看手机短信',
        type: 'success',
      })
    }
    interval.count = setInterval(() => {
      if (count.value > 0 && count.value <= TIME_COUNT) {
        count.value--
      } else {
        clearInterval(interval.count) // 清除定时器
        interval.count = null
        loading.btns = false
      }
    }, 1000)
  }
}
</script>
<style lang="scss" scoped>
.login-code {
  .codeBtn {
    display: flex;
    justify-content: center;
    align-items: center;
    background-color: #eeeeee;
    color: #666666;
    border: none;
  }
  img {
    vertical-align: middle;
  }
}
</style>
