<template>
  <div class="layout">
    <TopNav></TopNav>
    <div class="main">
      <router-view></router-view>
    </div>
    <Footer></Footer>
    <div class="showTheLogin"></div>
  </div>
</template>
<script>
import Vue from 'vue'
import Footer from '@/components/base/footer'
import TopNav from '@/components/base/topNav'
import Login from '@/views/login/login.vue'

export default {
  name: 'layout',
  components: {TopNav, Footer, Login},
  data () {
    return {
      dom: null
    }
  },
  watch: {
    '$store.state.showLogin': {
      handler (nVal, oVal) {
        if (nVal) {
          const LoginCom = Vue.extend(Login)
          if (document.getElementsByClassName('showTheLogin').length > 0) {
            this.dom = new LoginCom().$mount('.showTheLogin')
          }
          if (document.getElementsByClassName('hiddenLogin').length > 0) {
            this.dom = new LoginCom().$mount('.hiddenLogin')
          }
        } else {
          if (this.dom) {
            document.getElementsByClassName('showTheLogin')[0].setAttribute('class', 'hiddenLogin')
          }
        }
      }
    }
  }
}
</script>
<style scoped lang='scss'>
.layout{
  height: 100%;
  overflow: auto;
  display: flex;
  flex-direction: column;
  .main{
    flex: 1;
  }
}
.hiddenLogin{
  animation: hiddenRight 1s;
  animation-fill-mode:forwards;
  -webkit-animation-fill-mode:forwards;
}
@keyframes hiddenRight {
  from {
    opacity: 1;
  }
  to {
    opacity: 0;
    display: none;
  }
}
</style>
