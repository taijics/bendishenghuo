<template>
  <el-form
    ref="ruleFormRef"
    :model="ruleForm"
    :rules="rules"
    label-position="left"
    label-width="0px"
  >
    <el-form-item prop="username">
      <el-input
        v-model="ruleForm.username"
        type="text"
        maxlength="11"
        auto-complete="off"
        placeholder="请输入账户"
        class="iptHeight"
      />
    </el-form-item>
    <el-form-item prop="password">
      <el-input
        v-model="ruleForm.password"
        maxlength="20"
        type="password"
        class="iptHeight"
        auto-complete="off"
        placeholder="请输入密码"
        @keyup.enter="handleLogin"
      />
    </el-form-item>
    <div class="boxBottom">
      <el-checkbox
        v-model="ruleForm.rememberMe"
        style="margin: 0 0 25px 0"
      >自动登录</el-checkbox>
      <div class="forgetPsd" @click="() => $emit('forgetPassword')">忘记密码</div>
    </div>

    <el-form-item style="width: 100%">
      <el-button
        :loading="loading.btns"
        type="primary"
        style="width: 100%; border-radius: 27px; height: 54px;"
        @click.native.prevent="handleLogin"
      >
        <span v-if="!loading.btns">登录</span>
        <span v-else>登 录 中...</span>
      </el-button>
    </el-form-item>
  </el-form>
</template>

<script setup>
import { defineComponent, reactive, ref } from 'vue';
import { useStore } from 'vuex';
import { UserActionEnum } from '@/store/modules/user/state';
import { useRouter } from 'vue-router';

import { encrypt } from '@/utils/rsaEncrypt.js'

defineComponent({
  name: 'AccountLoginComponent'
});
defineEmits(['forgetPassword']);

const store = useStore();
const router = useRouter();
let ruleForm = reactive({
  username: '',
  password: '',
  rememberMe: false,
})

let loading = reactive({
  btns: false,
})

const rules = {
  username: [
    { required: true, trigger: 'blur', message: '用户名不能为空' },
  ],
  password: [
    { required: true, trigger: 'blur', message: '密码不能为空' },
  ],
}

const ruleFormRef = ref();
function handleLogin () {
  ruleFormRef.value.validate((valid) => {
    if (valid) {
      loading.value = true
      store.dispatch(UserActionEnum.LOGIN, {
        username: encrypt(ruleForm.username),
        password: encrypt(ruleForm.password),
        rememberMe: ruleForm.rememberMe,
      })
        .then(() => {
          router.push({ path: '/' }).then(() => {
            window.location.reload()
          })
        })
        .catch(() => {
        }).finally(() => {
          loading.btns = false;
        })
    } else {
      return false
    }
  })
}

</script>

<style lang="scss" scoped>
.boxBottom {
  display: flex;
  justify-content: space-between;
  .forgetPsd {
    font-size: 14px;
    color: #3A68F2;
    cursor: pointer;
  }
}
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
}
</style>
