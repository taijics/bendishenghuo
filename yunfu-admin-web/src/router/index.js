import { createRouter, createWebHistory } from 'vue-router';

/* Layout */
import Layout from '@/layout/index.vue'

export const mainRoutes = [
  {
    path: '/login',
    component: () => import('@/views/login/index.vue'),
    hidden: true,
  },
  {
    path: '/:catchAll(.*)',
    component: () => import('@/views/404.vue'),
    hidden: true,
  },
  {
    path: '/',
    component: Layout,
    redirect: '/dashboard',
    meta: {
      title: '总览',
      icon: 'Monitor',
    },
    children: [
      {
        path: 'dashboard',
        name: 'dashboard',
        component: () => import('@/views/dashboard/index.vue'),
        meta: {
          title: '总览',
          icon: 'Monitor',
        },
      },
    ],
  },
]

const createRouterFun = () =>
  createRouter({
    scrollBehavior: () => ({
      y: 0,
    }),
    // routes: constantRoutes
    history: createWebHistory(import.meta.env.VITE_BASE_PREFIX),
    routes: mainRoutes,
  });

const router = createRouterFun()

// Detail see: https://github.com/vuejs/vue-router/issues/1234#issuecomment-357941465
export function resetRouter () {
  const newRouter = createRouterFun()
  router.matcher = newRouter.matcher // reset router
}

export default router
