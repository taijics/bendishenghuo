import Vue from 'vue'
import Router from 'vue-router'
import layout from '@/views/layout'
import home from '@/views/home/index'
import status from '@/views/reviewStatus/index'
import mUinitBusiness from '../views/moblie/mUinitBusiness'
import mEnterprise from '../views/moblie/mEnterprise'
import mPersonal from '../views/moblie/mPersonal'
import mOtherOrg from '../views/moblie/mOtherOrg'
// 移动端
import mStatus from '../views/moblie/mStatus'
// const error = (resolve) => {
//   import('@/components/error/error').then((module) => {
//     resolve(module)
//   })
// }
Vue.use(Router)

const router = new Router({
  routes: [
    {
      path: '/',
      name: 'home',
      component: home
    },
    {
      path: '/layout',
      name: 'layout',
      component: layout,
      children: [
        {
          path: '/status',
          name: 'status',
          component: status
        },
        {
          path: '/personal', // PC 个人入驻
          name: 'personal',
          component: () => import('@/views/SettleIn/personal')
        },
        {
          path: '/individualBusiness', // PC 个人工商入驻
          name: 'individualBusiness',
          component: () => import('@/views/SettleIn/individualBusiness')
        },
        {
          path: '/enterprisesApply', // PC 企业入驻
          name: 'enterprisesApply',
          component: () => import('@/views/SettleIn/enterprisesApply')
        },
        {
          path: '/organization', // PC 其它组织机构入驻
          name: 'organization',
          component: () => import('@/views/SettleIn/organization')
        }
      ]
    },
    {
      path: '/mStatus',
      name: 'mStatus',
      component: mStatus
    },
    {
      path: '/mUinitBusiness', // 手机个人工商入驻
      name: 'mUinitBusiness',
      component: mUinitBusiness
    },
    {
      path: '/mEnterprise', // 手机企业入驻
      name: 'mEnterprise',
      component: mEnterprise
    },
    {
      path: '/mPersonal', // 手机个人入驻
      name: 'mPersonal',
      component: mPersonal
    },
    {
      path: '/mOtherOrg', // 手机其它组织机构入驻
      name: 'mOtherOrg',
      component: mOtherOrg
    }
  ]
})

router.beforeEach((to, from, next) => {
  next()
})

export default router
