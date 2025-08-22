import { createApp } from 'vue'
import { createPinia } from 'pinia'
import App from './App.vue'
import router from './router'
import '../node_modules/normalize.css/normalize.css' // 重置样式表
import ElementPlus from 'element-plus'
import zhCn from 'element-plus/dist/locale/zh-cn.mjs'
import './assets/font_icon/iconfont.css'
import { QuillEditor } from '@vueup/vue-quill'
import '@vueup/vue-quill/dist/vue-quill.snow.css';

const store = createPinia()
const app = createApp(App)
app.component('QuillEditor', QuillEditor)
app.use(router).use(store).use(store).use(ElementPlus, {
  locale: zhCn,
}).mount('#canvas')
