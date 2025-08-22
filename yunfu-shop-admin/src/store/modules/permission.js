import { constantRoutes } from '@/router/index.js'
import Layout from '@/layout/index'

const permission = {
  state: {
    routers: constantRoutes,
    addRouters: [],
    hasLoad: false
  },
  mutations: {
    SET_ROUTERS: (state, routers) => {
      state.addRouters = routers
      state.routers = constantRoutes.concat(routers)
    },
    SET_LOAD: (state, hasLoad) => {
      state.hasLoad = hasLoad
    }
  },
  actions: {
    GenerateRoutes({ commit }, asyncRouter) {
      commit('SET_ROUTERS', asyncRouter)
    }
  }
}

export const filterAsyncRouter = routers => {
  return routers.filter(router => {
    if (router.resourceType === 'catalog') { // 菜单节点，添加Layout父容器
      router.component = Layout
    } else {
      // const component = router.component
      router.component = loadView(router.path)
    }
    if (router.children && router.children.length) {
      router.children = filterAsyncRouter(router.children)
    }
    return true
  })
}

// 加载页面文件
export const loadView = view => {
  // console.log('view', view)
  return resolve => require([`@/views${view}`], resolve)
  // return resolve => require([`@/views/${view}/index`], resolve)
}

export default permission
