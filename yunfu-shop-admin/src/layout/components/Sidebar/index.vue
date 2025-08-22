<template>
  <div :class="{ 'has-logo': showLogo }">
    <logo v-if="isCollapse" :collapse="isCollapse" />
    <logo v-else :collapse="isCollapse" />
    <el-scrollbar wrap-class="scrollbar-wrapper">
      <el-menu
        :default-active="activeMenu"
        :collapse="isCollapse"
        :background-color="variables.menuBg"
        :text-color="variables.menuText"
        :unique-opened="false"
        :active-text-color="variables.menuActiveText"
        :collapse-transition="false"
        mode="vertical"
      >
        <sidebar-item
          v-for="(route,index) in routers"
          :key="index"
          class="tabLink"
          :item="route"
          :base-path="route.path"
        />
      </el-menu>
    </el-scrollbar>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'
import Logo from './Logo'
import SidebarItem from './SidebarItem'
import variables from '@/styles/variables.scss'
// import { adminBuild } from '@/api/user'
// import { getUserId, setBtns } from '@/utils/auth'

export default {
  components: { SidebarItem, Logo },
  data() {
    return {
      // routes: []
    }
  },
  computed: {
    ...mapGetters([
      'sidebar',
      'routers'
    ]),
    // routes() {
    //   return this.$router.options.routes;
    // },
    activeMenu() {
      const route = this.$route
      const { meta, path } = route
      // if set path, the sidebar will highlight the path you set
      if (meta.activeMenu) {
        return meta.activeMenu
      }
      return path
    },
    showLogo() {
      return this.$store.state.settings.sidebarLogo
    },
    variables() {
      return variables
    },
    isCollapse() {
      return !this.sidebar.opened
    }
  },
  // created() {
  //   adminBuild({ businessUserId: getUserId() }).then(
  //     res => {
  //       this.routes = res.data
  //       // localStorage.setItem("permissionList", JSON.stringify(res.data));
  //     }
  //   )
  // },
  methods: {
    // touchSidbar(arr) {
    //   debugger
    //   console.log(arr)
    //   let res = []
    //   this.routes.forEach(element => {
    //     const t = element
    //     if (element.path === arr) {
    //       console.log(111213)
    //       res = element
    //     } else {
    //       t.children.forEach(e => {
    //         if (e.path === arr) {
    //           res = e
    //         }
    //       })
    //     }
    //   })
    //   setBtns(JSON.stringify(res.buttons))
    //   console.log(res)
    // }
  }
}
</script>
