import { createApp } from 'vue'

import 'normalize.css/normalize.css' // A modern alternative to CSS resets
// import locale from 'element-ui/lib/locale/lang/en' // lang i18n
import App from './App.vue'

import '@/styles/index.scss' // global css

import store from './store'
import Icon from '@/components/Icon/index.vue'
import * as ElementPlusIconsVue from '@element-plus/icons-vue'
import 'virtual:svg-icons-register'

// import '@/icons' // icon
import '@/permission' // permission control
import router from './router'
const app = createApp(App)
for (const [key, component] of Object.entries(ElementPlusIconsVue)) {
  app.component(key, component)
}
app.use(router).use(store).component('icon', Icon).mount('#app')
