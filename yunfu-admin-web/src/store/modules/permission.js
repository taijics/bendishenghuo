import { mainRoutes } from '../../router/index.js'
import Layout from '@/layout/index.vue'
import {defineAsyncComponent} from 'vue'
const permission = {
  state: {
    // routers: constantRoutes,
    routers: mainRoutes,
    addRouters: [],
    hasLoad: false,
  },
  mutations: {
    SET_ROUTERS: (state, routers) => {
      state.addRouters = routers
      state.routers = mainRoutes.concat(routers)
    },
    SET_LOAD: (state, hasLoad) => {
      state.hasLoad = hasLoad
    },
  },
  actions: {
    GenerateRoutes ({ commit }, asyncRouter) {
      commit('SET_ROUTERS', asyncRouter)
    },
  },
}

export const filterAsyncRouter = (routers) => {
  // let loadChild = true // 是否加载子组件
  return routers.filter((router) => {
    if (router.resourceType === 'catalog') {
      // 菜单节点，添加Layout父容器
      // if (router.children.length !== 0) {
      //   router.component = Layout
      // } else {
      //   // router.component = Layout
      //   const menu = JSON.parse(JSON.stringify(router))
      //   router.path = '/'
      //   router.component = Layout
      //   // 修改子组件
      //   menu.component = loadView(menu.path)
      //   menu.resourceType = 'menu'
      //   router.children.push(menu)
      //   // console.log('单独菜单', router)
      //   // console.log('单独menu', menu)
      //   loadChild = false
      // }
      router.component = Layout
      // console.log(router)
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
const modules = import.meta.glob('@/views/**/*.vue', { eager: true, import: 'default' })
export const loadView = (view) => {
  let res;
  for (const path in modules) {
    const dir = path.split('views')[1].split('.vue')[0];
    if (dir === view || dir === view + '/index') {
      res = modules[path]
    }
  }
  return res;
}

export default permission
