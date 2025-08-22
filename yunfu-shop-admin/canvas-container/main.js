// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import Vue from 'vue'
import App from './App'
import router from './router'
import store from './store'
import '../node_modules/normalize.css/normalize.css' // 重置样式表
import ElementUI from 'element-ui'
import './styles/index.scss'
import './styles/theme/index.css'
import './assets/font_icon/iconfont.css'
// require styles 引入样式
import 'quill/dist/quill.core.css'
import 'quill/dist/quill.snow.css'
import 'quill/dist/quill.bubble.css'
// import 'element-ui/lib/theme-chalk/index.css'
Vue.use(ElementUI)

Vue.prototype.$message = ElementUI.Message

// 阻止启动生产消息
Vue.config.productionTip = false

/* eslint-disable no-new */
new Vue({
  el: '#canvas',
  router,
  store,
  components: { App },
  template: '<App/>'
})
