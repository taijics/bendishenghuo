<template>
  <div :class="{ 'has-logo': showLogo }">
    <Logo v-if="showLogo" :collapse="!isCollapse" />
    <el-scrollbar>
      <el-menu
        :default-active="route.path"
        :collapse="isCollapse"
        :active-text-color="variables.menuActiveText"
        :background-color="variables.menuBg"
        :text-color="variables.menuText"
        :collapse-transition="false"
        mode="vertical"
      >
        <template v-for="router in routers" :key="router.permissionId">
          <sidebar-item v-if="!router.hidden" :item="router" :base-path="router.path" :is-collapse="!isCollapse" />
        </template>
      </el-menu>
    </el-scrollbar>
  </div>
</template>

<script setup>
import { computed } from 'vue'
import { useStore } from 'vuex'
import { useRoute } from 'vue-router'
import Logo from './Logo.vue'
import SidebarItem from './SidebarItem.vue'
import variables from '@/styles/variables.module.scss'

const route = useRoute()
const store = useStore()
const { getters } = useStore()
const routers = computed(() => getters['routers'])
const showLogo = computed(() => store.state.settings.sidebarLogo)
const isCollapse = computed(() => !getters['sidebar'].opened)
</script>

<style scoped>
:deep(.el-popper.is-dark) {
  display: flex;
  align-items: center;
}
</style>
