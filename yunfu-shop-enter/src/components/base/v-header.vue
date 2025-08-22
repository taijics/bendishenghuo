<template>
  <div class="header">
    <div class="warp headerBox">
      <div class="headerLeft" @click="goToHome">
        返回CERESHOP商家入驻首页
      </div>
      <div class="headerRight">
        <!-- <div class="registeredLogin" v-if="userName !== 'undefined' && userName !== ' '">{{ userName }}</div> -->
        <!-- <div v-else class="registeredLogin" @click="goToLogin">登录/免费注册</div> -->
        <div class="contactUs">400-990-2300</div>
      </div>
    </div>
  </div>
</template>

<script>
import {mapGetters, mapMutations} from 'vuex'
export default {
  name: 'login',
  computed: {
    ...mapGetters([
      'userName'
    ])
  },
  methods: {
    ...mapMutations({
      setUserInfo: 'SET_USERNAME' // 修改用户信息
    }),
    goToHome () {
      this.$router.push({path: '/'})
    },
    goToLogin () {
      this.setUserInfo('')
      window.location.href = `https://ceres.zkthink.com/pc/#/login?type=2`
    }
  }
}
</script>

<style lang="scss" scoped>
.header {
  background: #F1F2F7;
  .headerBox {
    display: flex;
    height: 42px;
    justify-content: space-between;
    align-items: center;
    color: #333333;
    font-size: 14px;
    .headerLeft {
      cursor: pointer;
    }
    .headerRight {
      display: flex;
      .registeredLogin {
        cursor: pointer;
        padding-right: 15px;
        border-right: 1px solid #999999;
        margin-right: 15px;
      }
    }
  }
}
</style>
