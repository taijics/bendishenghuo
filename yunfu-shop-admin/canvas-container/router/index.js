import Vue from 'vue'
import Router from 'vue-router'
import canvasShowPage from '@@/components/canvasShow/canvasShowPage'
import canvasEditPage from '@@/components/canvasEditPage'
import canvasContainer from '../views/canvasContainer'
Vue.use(Router)

const router = new Router({
  routes: [
    {
      path: '/canvasShowPage',
      name: 'canvasShowPage',
      component: canvasShowPage
    },
    {
      path: '/canvasEditPage',
      name: 'canvasEditPage',
      component: canvasEditPage
    },
    {
      path: '/',
      name: 'canvasContainer',
      component: canvasContainer
    }
  ]
})

export default router
