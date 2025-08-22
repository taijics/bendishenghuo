<template>
  <div class="login">
    <!-- 登录 -->
    <div v-if="getPassword" class="loginBox">
      <div class="topText">
        平台登录
      </div>
      <el-tabs v-model="tabs.activeName">
        <el-tab-pane label="账户密码登录" name="account">
          <AccountLogin
            class="login-form"
            @forgetPassword="getPassword = false"
          />
        </el-tab-pane>
        <el-tab-pane label="手机号码登录" name="phone">
          <PhoneLogin class="login-form" />
        </el-tab-pane>
      </el-tabs>
    </div>

    <!-- 找回密码 -->
    <RebackPassword
      v-else
      @backToLogin="() => getPassword = true"
    />
    <!--  底部  -->
    <div class="login-footer">© 2019 cereshop</div>
  </div>
</template>

<script setup>
import { defineComponent, reactive, ref } from 'vue';
import AccountLogin from './account.vue';
import PhoneLogin from './phone.vue';
import RebackPassword from './rebackPassword.vue';

defineComponent({
  name: 'LoginIndex'
})

const getPassword = ref(true);

let tabs = reactive({
  activeName: 'account'
})
</script>

<style lang="scss" scoped>
.topText {
  font-size: 40px;
  font-weight: bold;
  color: #ffffff;
  text-align: center;
  position: absolute;
  top: -70px;
  left: 105px;
}
.login {
  height: 100%;
  background-size: cover;
  position: relative;
  display: flex;
  justify-content: center;
  align-items: center;
  background-image: url('../../assets/images/background.jpg');
}
.loginBox {
  width: 360px !important;
  height: 400px;
  background: #ffffff;
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  .el-tabs{
    :deep(.el-tabs__nav-wrap::after) {
      background-color: transparent;
    }
    :deep(.el-tabs__nav-scroll){
      display: flex;
      justify-content: center;
      .el-tabs__item{
        height: 50px;
        line-height: 50px;
      }
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
  .iptHeight {
    height: 54px !important;
    input {
      height: 54px !important;
    }
    span {
      display: flex;
      align-items: center;
    }
    .input-icon {
      width: 20px;
      height: 20px;
    }
  }
}

.login-footer {
  position: fixed;
  bottom: 0;
  width: 100%;
  text-align: center;
}
</style>
