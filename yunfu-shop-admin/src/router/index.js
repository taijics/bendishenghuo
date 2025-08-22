import Vue from 'vue'
import Router from 'vue-router'

Vue.use(Router)

/* Layout */
import Layout from '@/layout'

/**
 * Note: sub-menu only appear when route children.length >= 1
 * Detail see: https://panjiachen.github.io/vue-element-admin-site/guide/essentials/router-and-nav.html
 *
 * hidden: true                   if set true, item will not show in the sidebar(default is false)
 * alwaysShow: true               if set true, will always show the root menu
 *                                if not set alwaysShow, when item has more than one children route,
 *                                it will becomes nested mode, otherwise not show the root menu
 * redirect: noRedirect           if set noRedirect will no redirect in the breadcrumb
 * name:'router-name'             the name is used by <keep-alive> (must set!!!)
 * meta : {
    roles: ['admin','editor']    control the page roles (you can set multiple roles)
    title: 'title'               the name show in sidebar and breadcrumb (recommend set)
    icon: 'svg-name'/'el-icon-x' the icon show in the sidebar
    breadcrumb: false            if set false, the item will hidden in breadcrumb(default is true)
    activeMenu: '/example/list'  if set path, the sidebar will highlight the path you set
  }
 */

/**
 * constantRoutes
 * a base page that does not have permission requirements
 * all roles can be accessed
 */
// export const constantRoutes = [{
//   path: '/login',
//   component: () => import('@/views/login/index'),
//   hidden: true
// },
// {
//   path: '/404',
//   component: () => import('@/views/404'),
//   hidden: true
// },
// {
//   path: '/',
//   component: Layout,
//   redirect: '/dashboard',
//   children: [{
//     path: 'dashboard',
//     name: 'Dashboard',
//     component: () => import('@/views/dashboard/index'),
//     meta: {
//       title: '概括',
//       icon: 'dashboard'
//     }
//   }]
// },
// {
//   path: '/order',
//   component: Layout,
//   redirect: '/order',
//   name: 'order',
//   meta: {
//     title: '订单',
//     icon: 'el-icon-s-help'
//   },
//   children: [{
//     path: 'pending',
//     name: 'pending',
//     component: () => import('@/views/order/pending/index'),
//     meta: {
//       title: '待处理订单',
//       icon: 'table'
//     }
//   },
//   // pendDetails
//   {
//     hidden: true, // (默认 false)
//     path: 'pendDetails',
//     name: 'pendDetails',
//     component: () => import('@/views/order/pending/pendDetails'),
//     meta: {
//       title: '订单详情',
//       icon: 'table'
//     }
//   },
//   {
//     path: 'aftersale',
//     name: 'aftersale',
//     component: () => import('@/views/order/aftersale/index'),
//     meta: {
//       title: '售后订单',
//       icon: 'tree'
//     }
//   },
//   {
//     hidden: true, // (默认 false)
//     path: 'afterDetails',
//     name: 'afterDetails',
//     component: () => import('@/views/order/aftersale/afterDetails'),
//     meta: {
//       title: '售后订单详情',
//       icon: 'tree'
//     }
//   }
//   ]
// },
// {
//   path: '/marketing',
//   component: Layout,
//   redirect: '/marketing',
//   name: 'marketing',
//   meta: {
//     title: '营销中心',
//     icon: 'el-icon-s-help'
//   },
//   children: [{
//     path: 'coupon',
//     name: 'coupon',
//     component: () => import('@/views/marketing/coupon/index'),
//     meta: {
//       title: '优惠券管理',
//       icon: 'table'
//     }
//   },
//   {
//     hidden: true, // (默认 false)
//     path: 'addCoupon',
//     name: 'addCoupon',
//     component: () => import('@/views/marketing/coupon/add'),
//     meta: {
//       title: '新增优惠券',
//       icon: 'table'
//     }
//   },
//   {
//     path: 'groupBuy',
//     name: 'groupBuy',
//     component: () => import('@/views/marketing/group/index'),
//     meta: {
//       title: '拼团',
//       icon: 'table'
//     }
//   },
//   {
//     path: 'addGroupBuy',
//     name: 'addGroupBuy',
//     component: () => import('@/views/marketing/group/add'),
//     meta: {
//       title: '新增拼团',
//       icon: 'table'
//     }
//   },
//   {
//     path: 'spike',
//     name: 'spike',
//     component: () => import('@/views/marketing/spike/index'),
//     meta: {
//       title: '秒杀',
//       icon: 'tree'
//     }
//   },
//   {
//     hidden: true, // (默认 false)
//     path: 'addSpike',
//     name: 'addSpike',
//     component: () => import('@/views/marketing/spike/add'),
//     meta: {
//       title: '新增秒杀活动',
//       icon: 'table'
//     }
//   },
//   {
//     path: 'discount',
//     name: 'discount',
//     component: () => import('@/views/marketing/discount/index'),
//     meta: {
//       title: '限时折扣',
//       icon: 'tree'
//     }
//   },
//   {
//     hidden: true, // (默认 false)
//     path: 'addDiscount',
//     name: 'addDiscount',
//     component: () => import('@/views/marketing/discount/add'),
//     meta: {
//       title: '新增限时折扣活动',
//       icon: 'table'
//     }
//   },
//   {
//     path: 'scene',
//     name: 'scene',
//     component: () => import('@/views/marketing/scene/index'),
//     meta: {
//       title: '场景营销',
//       icon: 'tree'
//     }
//   },
//   {
//     hidden: true, // (默认 false)
//     path: 'addScene',
//     name: 'addScene',
//     component: () => import('@/views/marketing/scene/add'),
//     meta: {
//       title: '新增场景营销',
//       icon: 'table'
//     }
//   },
//   {
//     path: 'compose',
//     name: 'compose',
//     component: () => import('@/views/marketing/compose/index'),
//     meta: {
//       title: '组合捆绑',
//       icon: 'tree'
//     }
//   },
//   {
//     hidden: true, // (默认 false)
//     path: 'addCompose',
//     name: 'addCompose',
//     component: () => import('@/views/marketing/compose/add'),
//     meta: {
//       title: '新增组合捆绑',
//       icon: 'table'
//     }
//   },
//   {
//     path: 'price',
//     name: 'price',
//     component: () => import('@/views/marketing/price/index'),
//     meta: {
//       title: '定价捆绑',
//       icon: 'tree'
//     }
//   },
//   {
//     hidden: true, // (默认 false)
//     path: 'addPrice',
//     name: 'addPrice',
//     component: () => import('@/views/marketing/price/add'),
//     meta: {
//       title: '新增定价捆绑',
//       icon: 'table'
//     }
//   }
//   ]
// },
// {
//   path: '/customer',
//   component: Layout,
//   redirect: '/customer',
//   name: 'customer',
//   meta: {
//     title: '客户管理',
//     icon: 'el-icon-s-help'
//   },
//   children: [{
//     path: 'customerList',
//     name: 'customerList',
//     component: () => import('@/views/customer/customerList'),
//     meta: {
//       title: '客户列表',
//       icon: 'table'
//     }
//   }, {
//     path: 'customerDetail',
//     name: 'customerDetail',
//     component: () => import('@/views/customer/customerList/customerDetail.vue'),
//     meta: {
//       title: '客户详情',
//       icon: 'table'
//     }
//   },
//   {
//     path: 'tagList',
//     name: 'tagList',
//     component: () => import('@/views/customer/tagList'),
//     meta: {
//       title: '标签管理',
//       icon: 'table'
//     }
//   },
//   {
//     path: 'clusteringList',
//     name: 'clusteringList',
//     component: () => import('@/views/customer/clustering'),
//     meta: {
//       title: '客户分群',
//       icon: 'table'
//     }
//   },
//   {
//     path: 'addClustering',
//     name: 'addClustering',
//     component: () => import('@/views/customer/addClustering'),
//     meta: {
//       title: '客户分群',
//       icon: 'table'
//     }
//   },
//   {
//     path: 'operate',
//     name: 'operate',
//     component: () => import('@/views/customer/operate'),
//     meta: {
//       title: '运营计划',
//       icon: 'table'
//     }
//   },
//   {
//     path: 'addOperate',
//     name: 'addOperate',
//     component: () => import('@/views/customer/addOperate'),
//     meta: {
//       title: '添加运营计划',
//       icon: 'table'
//     }
//   },
//   {
//     hidden: true, // (默认 false)
//     path: 'addCustomer',
//     name: 'addCustomer',
//     component: () => import('@/views/customer/addCustomer'),
//     meta: {
//       title: '新增客户',
//       icon: 'table'
//     }
//   }]
// },
// {
//   path: '/commodity',
//   component: Layout,
//   redirect: '/commodity',
//   name: 'commodity',
//   meta: {
//     title: '商品',
//     icon: 'el-icon-s-help'
//   },
//   children: [{
//     path: 'commoditySystem',
//     name: 'commoditySystem',
//     component: () => import('@/views/commodity/commoditySystem/index'),
//     meta: {
//       title: '商品管理',
//       icon: 'table'
//     }
//   },
//   {
//     hidden: true, // (默认 false)
//     path: 'addCommodity',
//     name: 'addCommodity',
//     component: () => import('@/views/commodity/commoditySystem/addCommodity'),
//     meta: {
//       title: '新增商品',
//       icon: 'table'
//     }
//   },
//   {
//     path: 'commodityList',
//     name: 'commodityList',
//     component: () => import('@/views/commodity/commodityList/index'),
//     meta: {
//       title: '商品分组',
//       icon: 'tree'
//     }
//   },
//   {
//     hidden: true, // (默认 false)
//     path: 'addCommodityGroup',
//     name: 'addCommodityGroup',
//     component: () => import('@/views/commodity/commodityList/commodityGroup'),
//     meta: {
//       title: '新增分组',
//       icon: 'table'
//     }
//   }
//   ]
// },
// {
//   path: '/shop',
//   component: Layout,
//   redirect: '/shop',
//   name: 'shop',
//   meta: {
//     title: '店铺',
//     icon: 'el-icon-s-help'
//   },
//   children: [{
//     path: 'decoration',
//     name: 'decoration',
//     component: () => import('@/views/shop/decoration/index'),
//     meta: {
//       title: '店铺装修',
//       icon: 'table'
//     }
//   },
//   {
//     path: 'material',
//     name: 'material',
//     component: () => import('@/views/shop/material/index'),
//     meta: {
//       title: '素材管理',
//       icon: 'tree'
//     }
//   }
//   ]
// },
// {
//   path: '/system',
//   component: Layout,
//   redirect: '/system',
//   name: 'system',
//   meta: {
//     title: '设置',
//     icon: 'nested'
//   },
//   children: [{
//     hidden: true, // (默认 false)
//     path: '/system/editShopSys',
//     component: () => import('@/views/system/shopSys/edit'), // Parent router-view
//     name: 'editShopSys',
//     meta: {
//       title: '编辑店铺信息'
//     }
//   },
//   {
//     path: '/system/shopSys',
//     component: () => import('@/views/system/shopSys/index'), // Parent router-view
//     name: 'dict',
//     meta: {
//       title: '店铺设置'
//     }
//   },
//   {
//     path: '/system/logistics',
//     component: () => import('@/views/system/logistics/index'),
//     name: 'roler',
//     meta: {
//       title: '物流设置'
//     }
//   }
//   ]
// },
// {
//   path: '/finance',
//   component: Layout,
//   meta: {
//     title: '财务',
//     icon: 'nested'
//   },
//   children: [{
//     path: 'index',
//     name: 'Finance',
//     component: () => import('@/views/finance/index'),
//     meta: {
//       title: '财务明细',
//       icon: 'form'
//     }
//   },
//   {
//     path: 'accountIndex',
//     name: 'account',
//     component: () => import('@/views/account/index'),
//     meta: {
//       title: '收款账户',
//       icon: 'form'
//     }
//   },
//   {
//     path: 'bond',
//     name: 'bond',
//     component: () => import('@/views/bond/index'),
//     meta: {
//       title: '保证金',
//       icon: 'form'
//     }
//   }]
// },
// {
//   path: '/Distributor',
//   component: Layout,
//   redirect: '/Distributor',
//   children: [{
//     path: 'DistributorIndex',
//     name: 'DistributorIndex',
//     component: () => import('@/views/Distributor/index'),
//     meta: {
//       title: '分销员',
//       icon: 'dashboard'
//     }
//   }]
// },
// {
//   path: '/active',
//   component: Layout,
//   redirect: '/active',
//   children: [{
//     path: 'active',
//     name: 'active',
//     component: () => import('@/views/active/index'),
//     meta: {
//       title: '平台活动',
//       icon: 'dashboard'
//     }
//   },
//   {
//     hidden: true, // (默认 false)
//     path: 'getActive',
//     name: 'getActive',
//     component: () => import('@/views/active/getActive'),
//     meta: {
//       title: '活动报名',
//       icon: 'dashboard'
//     }
//   },
//   {
//     hidden: true, // (默认 false)
//     path: 'activeData',
//     name: 'activeData',
//     component: () => import('@/views/active/activeData'),
//     meta: {
//       title: '活动数据',
//       icon: 'dashboard'
//     }
//   }
//   ]
// },
// {
//   path: '/setup',
//   component: Layout,
//   name: 'setup',
//   meta: {
//     title: '系统管理',
//     icon: 'el-icon-s-help'
//   },
//   children: [{
//     path: 'user',
//     name: 'user',
//     component: () => import('@/views/setup/user/index'),
//     meta: {
//       title: '用户管理',
//       icon: 'table'
//     }
//   },
//   {
//     path: 'role',
//     name: 'role',
//     component: () => import('@/views/setup/role/index'),
//     meta: {
//       title: '角色管理',
//       icon: 'tree'
//     }
//   },
//   {
//     path: 'tabs',
//     name: 'tabs',
//     component: () => import('@/views/setup/tabs/index'),
//     meta: {
//       title: '菜单管理',
//       icon: 'tree'
//     }
//   }
//   ]
// },
// {
//   path: '/customerService',
//   component: Layout,
//   name: 'customerService',
//   meta: {
//     title: '微信客服',
//     icon: 'el-icon-s-help'
//   },
//   children: [{
//     path: 'customerService',
//     name: 'customerService',
//     component: () => import('@/views/customerService/index'),
//     meta: {
//       title: '客服管理',
//       icon: 'table'
//     }
//   }
//   ]
// },
// {
//   path: '/liveMenu',
//   component: Layout,
//   name: 'liveMenu',
//   meta: {
//     title: '直播管理',
//     icon: 'el-icon-s-help'
//   },
//   children: [{
//     path: 'liveRoom',
//     name: 'liveRoom',
//     component: () => import('@/views/liveMenu/liveRoom'),
//     meta: {
//       title: '直播间管理',
//       icon: 'table'
//     }
//   },
//   {
//     path: 'liveProduct',
//     name: 'liveProduct',
//     component: () => import('@/views/liveMenu/liveProduct'),
//     meta: {
//       title: '直播商品管理',
//       icon: 'table'
//     }
//   }
//   ]
// },
// // 404 page must be placed at the end !!!
// {
//   path: '*',
//   redirect: '/404',
//   hidden: true
// }
// ]

export const constantRoutes = [
  {
    path: '/login',
    component: () => import('@/views/login/index'),
    hidden: true
  },
  {
    path: '/404',
    component: () => import('@/views/404'),
    hidden: true
  },
  {
    path: '/',
    component: Layout,
    redirect: '/homedashboard',
    meta: {
      title: '概括',
      icon: 'el-icon-monitor'
    },
    children: [{
      path: 'homedashboard',
      name: 'homedashboard',
      component: () => import('@/views/dashboard/index.vue'),
      meta: {
        title: '概括',
        icon: 'el-icon-monitor'
      }
    }]
  }
  // {
  //   path: '/setup',
  //   component: Layout,
  //   name: 'setup',
  //   meta: {
  //     title: '系统管理',
  //     icon: 'el-icon-s-help'
  //   },
  //   children: [{
  //     path: 'user',
  //     name: 'user',
  //     component: () => import('@/views/setup/user/index'),
  //     meta: {
  //       title: '用户管理',
  //       icon: 'table'
  //     }
  //   },
  //   {
  //     path: 'role',
  //     name: 'role',
  //     component: () => import('@/views/setup/role/index'),
  //     meta: {
  //       title: '角色管理',
  //       icon: 'tree'
  //     }
  //   },
  //   {
  //     path: 'tabs',
  //     name: 'tabs',
  //     component: () => import('@/views/setup/tabs/index'),
  //     meta: {
  //       title: '菜单管理',
  //       icon: 'tree'
  //     }
  //   }]
  // }
]

const createRouter = () => new Router({
  // mode: 'history', // require service support
  scrollBehavior: () => ({
    y: 0
  }),
  routes: constantRoutes
})

const router = createRouter()

// Detail see: https://github.com/vuejs/vue-router/issues/1234#issuecomment-357941465
export function resetRouter() {
  const newRouter = createRouter()
  router.matcher = newRouter.matcher // reset router
}

export default router
