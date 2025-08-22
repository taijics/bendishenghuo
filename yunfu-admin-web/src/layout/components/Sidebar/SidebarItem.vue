<template>
  <div v-if="!item.hidden">
    <!-- 只包含一个子路由节点的路由，显示其【唯一子路由】 -->
    <template v-if="hasOneShowingChild(item.children, item) && (!onlyOneChild.children || onlyOneChild.noShowingChildren)">
      <el-menu-item v-if="onlyOneChild.meta" :index="resolvePath(onlyOneChild.path)" :class="{ 'submenu-title-noDropdown': !isNest }" @click="jump(resolvePath(onlyOneChild.path))">
        <icon :icon="onlyOneChild.meta.icon" />
        <template #title><span>{{ onlyOneChild.meta.title }}</span></template>
      </el-menu-item>
    </template>

    <!-- 包含多个子路由  -->
    <el-sub-menu v-else :index="resolvePath(item.path)" teleported>
      <template #title>
        <Item v-if="item.meta" :icon="item.meta.icon" :title="item.meta.title" />
      </template>
      <SidebarItem
        v-for="child in item.children"
        :key="child.path"
        :is-nest="true"
        :item="child"
        :base-path="resolvePath(child.path)"
      />
    </el-sub-menu>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import path from 'path-browserify'
import { useRouter } from 'vue-router'
import { useStore } from 'vuex'
import { isExternal } from '@/utils/validate'
import Item from './Item.vue'

const props = defineProps({
  item: {
    type: Object,
    required: true
  },
  basePath: {
    type: String,
    required: true
  },
  isNest: {
    type: Boolean,
    default: false
  }
})
const router = useRouter()
const store = useStore()
const sidebar = computed(() => store.state.app.sidebar)
const device = computed(() => store.state.app.device)
const onlyOneChild = ref();

const hasOneShowingChild = (children = [], parent) => {
  // 需要显示的子路由数组
  const showingChildren = children.filter((item) => {
    if (item.meta?.hidden) {
      return false // 过滤不显示的子路由
    } else {
      onlyOneChild.value = item // 唯一子路由赋值（多个子路由情况 onlyOneChild 变量是用不上的）
      return true
    }
  })

  // 1：如果只有一个子路由, 返回 true
  if (showingChildren.length === 1) {
    return true
  }

  // 2：如果无子路由, 复制当前路由信息作为其子路由，满足只拥有一个子路由的条件，所以返回 true
  if (showingChildren.length === 0) {
    onlyOneChild.value = { ...parent, path: '', noShowingChildren: true }
    return true
  }
  return false
}
const resolvePath = (routePath) => {
  if (isExternal(routePath)) {
    return routePath
  }
  if (isExternal(props.basePath)) {
    return props.basePath
  }
  if (props.basePath.indexOf('/http') === 0) {
    return props.basePath.slice(1)
  }
  // 完整路径 = 父级路径(/level/level_3) + 路由路径
  const fullPath = path.resolve(props.basePath, routePath) // 相对路径 → 绝对路径
  return fullPath
}
const jump = (path) => {
  if (device.value === 'mobile' && sidebar.value.opened === true) {
    store.dispatch('app/closeSideBar', { withoutAnimation: true })
  }
  if (isExternal(path)) {
    window.open(path)
  } else {
    router.push({ path }).catch(err => {
      console.error(err)
    })
  }
}
</script>
<style lang="scss" scoped>
.submenu-title-noDropdown {
  &>span {
    margin-left: 12px;
  }
}
</style>
