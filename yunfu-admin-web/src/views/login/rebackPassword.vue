<template>
  <div class="loginBoxs">
    <div class="topback">找回密码</div>
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span style="margin-left: 25px">找回密码</span>
        <el-button
          style="float: right; padding: 3px 0"
          type="primary"
          link
          @click="() => $emit('backToLogin')"
        >返回登录</el-button>
        <el-form
          ref="ruleFormRef"
          :model="ruleForm"
          :rules="rules"
          label-position="left"
          label-width="0px"
          class="login-form"
        >
          <el-form-item prop="phone">
            <el-input
              v-model="ruleForm.phone"
              type="text"
              maxlength="11"
              auto-complete="off"
              placeholder="请输入手机号码"
              class="iptHeight"
            />
          </el-form-item>
          <el-form-item prop="code">
            <el-input
              v-model="ruleForm.code"
              maxlength="6"
              type="text"
              class="iptHeight"
              auto-complete="off"
              placeholder="请输入验证码"
            >
              <template #append>
                <VerificationCode
                  :phone="ruleForm.phone"
                />
              </template>
            </el-input>
          </el-form-item>
          <el-form-item prop="password">
            <el-input
              v-model="ruleForm.password"
              type="password"
              maxlength="16"
              auto-complete="off"
              placeholder="请输入密码"
              class="iptHeight"
            />
          </el-form-item>
          <el-form-item prop="newPassword">
            <el-input
              v-model="ruleForm.newPassword"
              type="password"
              maxlength="16"
              auto-complete="off"
              placeholder="请再次输入密码"
              class="iptHeight"
            />
          </el-form-item>
          <el-form-item style="width: 100%">
            <el-button
              :loading="loading.btns"
              type="primary"
              style="width: 100%; border-radius: 20px"
              @click.native.prevent="resetPassword"
            >
              <span v-if="!loading.btns">重 置 密 码</span>
              <span v-else>重 置 中...</span>
            </el-button>
          </el-form-item>
        </el-form>
      </div>
    </el-card>
  </div>
</template>

<script setup>
import { UserActionEnum } from '@/store/modules/user/state';
import { defineComponent, reactive, ref } from 'vue';
import { useStore } from 'vuex';
import { encrypt } from '@/utils/rsaEncrypt.js'

import VerificationCode from './verificationCode.vue'

defineComponent({
  name: 'RebackPasswordComponent'
})
const emit = defineEmits(['backToLogin']);

const store = useStore();

let ruleForm = reactive({
  phone: '',
  code: '',
  password: '',
  newPassword: '',
})
let loading = reactive({
  btns: false,
  code: false,
})

const validateNewPassword = (rule, value, callback) => {
  if (value !== ruleForm.password) {
    callback(new Error('两次输入密码不一致!'))
  } else {
    callback()
  }
}
const rules = {
  phone: [{ required: true, trigger: 'blur', message: '手机号不能为空' }],
  code: [{ required: true, trigger: 'blur', message: '验证码不能为空' }],
  password: [
    { required: true, trigger: 'blur', message: '密码不能为空' },
    {
      pattern: /^[~!@#$%^&*\-+=_.0-9a-zA-Z]{8,16}$/,
      message: '8-16密码数字英文混合',
    },
  ],
  newPassword: [
    { required: true, trigger: 'blur', message: '请再次输入密码' },
    { validator: validateNewPassword, trigger: 'blur' },
  ],
}

const ruleFormRef = ref();
function resetPassword () {
  ruleFormRef.value.validate((valid) => {
    if (valid) {
      loading.btns = true
      const data = {
        phone: encrypt(ruleForm.phone),
        code: encrypt(ruleForm.code),
        password: encrypt(ruleForm.password),
        newPassword: encrypt(ruleForm.newPassword),
      }
      store.dispatch(UserActionEnum.RESET_PASSWORD, data)
        .then(() => {
          ElMessage.success('重置成功')
          emit('backToLogin')
        })
        .catch(() => {
        }).finally(() => {
          loading.btns = false
        })
    } else {
      return false
    }
  })
}
</script>

<style lang="scss" scoped>
.loginBoxs {
  width: 400px;
  .topback {
    // width: 1000px;
    height: 100px;
    background: #3a68f2;
    border-radius: 10px 10px 0px 0px;
    font-size: 30px;
    color: #ffffff;
    display: flex;
    justify-content: center;
    align-items: center;
    .box-card {
      width: 100%;
      height: 100%;
      .clearfix {
        width: 50%;
        margin: 10% auto;
      }
    }
  }
  .login-form {
    border-radius: 6px;
    background: #ffffff;
    padding: 25px 25px 5px 25px;
    .el-input {
      height: 38px;
      input {
        height: 38px;
      }
    }
    .input-icon {
      height: 39px;
      width: 14px;
      margin-left: 2px;
    }
  }
}
</style>