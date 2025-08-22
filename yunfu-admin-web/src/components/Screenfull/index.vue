<template>
  <div>
    <icon size="30" :icon="isFullscreen ? 'icon-fullscreen-shrink' : 'icon-fullscreen-expand'" @click="click" />
  </div>
</template>

<script setup>
import { ref, onBeforeMount, onBeforeUnmount } from 'vue'
import screenfull from 'screenfull'
const isFullscreen = ref(false)

onBeforeMount(() => {
  init()
})

onBeforeUnmount(() => {
  if (screenfull.enabled) {
    screenfull.off('change', change)
  }
})

const click = () => {
  if (!screenfull.isEnabled) {
    ElMessage({
      message: 'you browser can not work',
      type: 'warning',
    })
    return false
  }
  screenfull.toggle()
}
const change = () => {
  isFullscreen.value = screenfull.isFullscreen
}
const init = () => {
  if (screenfull.isEnabled) {
    // screenfull.request(); // 并不支持默认全屏显示
    screenfull.on('change', change)
  }
}
</script>

<style scoped>
.icon {
  cursor: pointer;
  font-size: 12px;
  vertical-align: middle;
}
.screenfull-svg {
  display: inline-block;
  cursor: pointer;
  fill: #5a5e66;
  width: 20px;
  height: 20px;
  vertical-align: 10px;
}
</style>
