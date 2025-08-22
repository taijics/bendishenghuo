<template>
  <el-form
    ref="ruleFormRef"
    :model="ruleForm"
    :rules="rules"
    label-position="left"
    label-width="0px"
    class="login-form"
  >
    <el-form-item prop="username">
      <el-input
        v-model="ruleForm.username"
        type="text"
        maxlength="11"
        auto-complete="off"
        placeholder="请输入手机号码"
        class="iptHeight"
      />
    </el-form-item>
    <el-form-item>
      <el-input
          v-model="ruleForm.verificationCode"
          maxlength="6"
          type="text"
          class="iptHeight graphic"
          auto-complete="off"
          placeholder="请输入图形验证码"
      >
        <template #append>
          <img :src="graphicCode" @click="loadImage" />
        </template>
      </el-input>
    </el-form-item>
    <el-form-item prop="code">
      <el-input
        v-model="ruleForm.code"
        maxlength="6"
        type="text"
        class="iptHeight"
        auto-complete="off"
        placeholder="请输入验证码"
        @keyup.enter="login"
      >
        <template #append>
          <VerificationCode
            :phone="ruleForm.username"
            :verificationCode="ruleForm.verificationCode"
          />
        </template>
      </el-input>
    </el-form-item>
    <div class="boxBottom">
      <el-checkbox
        v-model="ruleForm.rememberMe"
        style="margin: 0 0 25px 0"
      >自动登录</el-checkbox>
    </div>

    <el-form-item style="width: 100%">
      <el-button
        :loading="loading.btns"
        type="primary"
        style="width: 100%; border-radius: 27px; height: 54px;"
        @click.native.prevent="login"
      >
        <span v-if="!loading.btns">登录</span>
        <span v-else>登 录 中...</span>
      </el-button>
    </el-form-item>
  </el-form>
</template>

<script setup>
import { defineComponent, reactive, ref, watch, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import { useStore } from 'vuex';
import { UserActionEnum } from '@/store/modules/user/state';

import { encrypt } from '@/utils/rsaEncrypt.js'

import VerificationCode from './verificationCode.vue'

defineComponent({
  name: 'PhoneLoginComponent'
});

const store = useStore();
const router = useRouter();

let loading = reactive({
  btns: false
})
let ruleForm = reactive({
  username: '',
  code: '',
  rememberMe: false,
  verificationCode: ''
})
const rules = {
  username: [
    { required: true, trigger: 'blur', message: '手机号不能为空' },
  ],
  code: [{ required: true, trigger: 'blur', message: '验证码不能为空' }],
}
const redirect = ref(null);
const graphicCode = ref('')
const ruleFormRef = ref();
function login () {
  ruleFormRef.value.validate((valid) => {
    if (valid) {
      loading.btns = true
      const data = {
        username: encrypt(ruleForm.username),
        code: encrypt(ruleForm.code),
        rememberMe: ruleForm.rememberMe,
      }
      store.dispatch(UserActionEnum.LOGIN, data)
        .then(() => {
          router.push({ path: redirect.value || '/' }).then(() => {
            window.location.reload()
          })
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

function loadImage () {
  graphicCode.value = `${import.meta.env.VITE_BASE_URL}/code/captcha?` + Math.random()
}

onMounted(() => {
  graphicCode.value = `${import.meta.env.VITE_BASE_URL}/code/captcha`
})

watch(() => router.currentRoute.value.query,
  (_nVal, _oVal) => {
    redirect.value = _nVal.redirect
  }
)
</script>
<style lang="scss" scoped>
:deep(.iptHeight) {
  .el-input__wrapper {
    height: 54px;
    padding: 1px;
    .el-input__inner {
      height: 100%;
      padding: 0 11px;
      border-radius: 3px;
    }
  }
  .el-input-group__append {
    .login-code {
      height: 100%;
      .el-button {
        height: 100%;
      }
    }
  }
}
:deep(.graphic) {
  .el-input-group__append {
    background: none;
    padding: 0 10px;
    img {
      width: 80px;
      height: 50px;
    }
  }
}
</style>
