<template>
  <el-icon :size="size">
    <template v-if="icon">
      <!-- 本地icon文件名需有'icon-'字符 -->
      <SvgIcon v-if="icon.indexOf('icon-') !== -1" :icon="icon" />
      <component :is="icon" v-else />
    </template>
  </el-icon>
</template>
<script setup>
import SvgIcon from '@/components/SvgIcon/index.vue'
defineProps({
  icon: {
    type: String,
    required: true
  },
  size: {
    type: String,
    default: '20'
  }
})
</script>
<style lang="scss" scoped>
</style>
