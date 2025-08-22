// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import Vue from 'vue'
import App from './App'
import router from './router'
import store from './store'
// import '@/config/rem' // 配置flex
import 'normalize.css' // 重置样式表
import ElementUI from 'element-ui'
import './../theme/index.css'
import { Toast } from 'vant'
// import '@/styles/element-ui-style.css' // 重置样式表
Vue.use(ElementUI)
Vue.use(Toast)
// optionally import default styles
Vue.prototype.$message = ElementUI.Message

// 阻止启动生产消息
Vue.config.productionTip = false

/* eslint-disable no-new */
new Vue({
  el: '#app',
  router,
  store,
  components: { App },
  template: '<App/>'
})
