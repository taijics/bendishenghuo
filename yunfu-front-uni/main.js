import { createApp } from 'vue'
import App from './App.vue'
import uView from './uni_modules/vk-uview-ui';
import store from './store'
import { jump, jumpToTabbar, goBack, getJumpParam } from './utils/jumpUtil'
import loadingPlugin from './utils/plugIn/globalLoading'
import GlobalLoading from "@/components/diyLoading/index.vue";
import SlideLoading from "./components/SlideLoading/index.vue";
import SubmitButton from "./components/SubmitButton/index.vue";
import ReturnTop from "./components/ReturnTop/index.vue";
import UvSkeleton from "@/components/uv-skeleton/uv-skeleton.vue";
const app = createApp(App)

app.use(uView)
app.use(store)
app.use(loadingPlugin)
app.component('GlobalLoading',GlobalLoading)
app.component('SlideLoading',SlideLoading)
app.component('SubmitButton',SubmitButton)
app.component('UvSkeleton',UvSkeleton)
app.component('ReturnTop',ReturnTop)
app.config.productionTip = false

app.provide('$store', store)
app.provide('$jump', jump)
app.provide('$jumpToTabbar', jumpToTabbar)
app.provide('$goBack', goBack)
app.provide('$getJumpParam', getJumpParam)

console.log(store)

app.mount('#app')
