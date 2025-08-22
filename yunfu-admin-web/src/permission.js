import router from './router'
import store from './store'
import { ElMessage as Message } from 'element-plus'
import NProgress from 'nprogress' // progress bar
import 'nprogress/nprogress.css' // progress bar style
import { getUserId, getToken } from '@/utils/auth' // get token from cookie
import { adminBuild } from '@/api/user.js'
import { filterAsyncRouter } from '@/store/modules/permission.js'
import getPageTitle from '@/utils/get-page-title'
import { UserActionEnum } from './store/modules/user/state'

NProgress.configure({
  showSpinner: false,
}) // NProgress Configuration

const whiteList = ['/login'] // no redirect whitelist
router.beforeEach(async (to, from, next) => {
  // start progress bar
  NProgress.start()
  // set page title
  document.title = getPageTitle(to.meta.title)

  // determine whether the user has logged in
  const hasToken = getToken()
  if (hasToken) {
    if (to.path === '/login') {
      // if is logged in, redirect to the home page
      next({
        path: '/',
      })
      NProgress.done()
    } else {
      // if (store.getters.routers.length === 0) {}
      // const hasGetUserInfo = store.getters.name
      // if (hasGetUserInfo) {
      //   console.log('hasGetUserInfo')
      //   // console.log('hasGetUserInfo', hasGetUserInfo)
      //   next()
      // }
      if (store.getters.routers.length === 0) {
        // 条件加载
        await loadMenus(next, to)
        store.commit('SET_LOAD', true)
      } else if (!store.getters.hasLoad) {
        // 是否加载过动态路由
        // // 修改hasLoad为false，防止死循环
        await loadMenus(next, to)
        store.commit('SET_LOAD', true)
      } else {
        try {
          next()
        } catch (error) {
          // remove token and go to login page to re-login
          await store.dispatch(UserActionEnum.RESET_TOKEN)
          Message.error(error || 'Has Error')
          next(`/login?redirect=${to.path}`)
          NProgress.done()
        }
      }
    }
  } else {
    /* has no token*/
    if (whiteList.indexOf(to.path) !== -1) {
      // in the free login whitelist, go directly
      console.log('no token')
      next()
    } else {
      // other pages that do not have permission to access are redirected to the login page.
      next(`/login?redirect=${to.path}`)
      NProgress.done()
    }
  }
})

export const loadMenus = async (next, to) => {
  const adminRes = await adminBuild({ platformUserId: getUserId() })
  const asyncRouter = filterAsyncRouter(adminRes.data)
  // 画布设置
  asyncRouter.forEach((item) => {
    if (item.path.indexOf('.html') !== -1) {
      item.path = item.path + '?' + getToken()
    }
  })
  // 异常跳转添加
  asyncRouter.push({ path: '*', redirect: '/404', hidden: true })
  await store.dispatch('GenerateRoutes', asyncRouter).then(() => {
    // 存储路由
    // 动态添加可访问路由表
    asyncRouter.forEach((route) => {
      if (route.path.indexOf('/') === -1 || route.path.indexOf('http') === 0) {
        route.path = '/' + route.path
      }
      router.addRoute(route);
    });
    next({ ...to, replace: true })
  })
}

router.afterEach(() => {
  // finish progress bar
  NProgress.done()
})
