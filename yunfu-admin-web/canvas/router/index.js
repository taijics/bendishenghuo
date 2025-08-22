import { createRouter, createWebHashHistory } from 'vue-router';
import canvasShowPage from '../components/canvasShow/canvasShowPage.vue'
import canvasEditPage from '../components/canvasEditPage.vue'
import canvasContainer from '../views/canvasContainer.vue'

const router = createRouter({
  history: createWebHashHistory(),
  routes: [
    {
      path: '/canvasShowPage',
      name: 'canvasShowPage',
      component: canvasShowPage,
    },
    {
      path: '/canvasEditPage',
      name: 'canvasEditPage',
      component: canvasEditPage,
    },
    {
      path: '/',
      name: 'canvasContainer',
      component: canvasContainer,
    },
  ],
})

export default router
