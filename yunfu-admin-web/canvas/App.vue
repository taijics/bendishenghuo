<template>
  <div id="app">
    <el-config-provider>
      <router-view />
    </el-config-provider>
  </div>
</template>

<script setup>
import { onMounted } from 'vue'

onMounted(() => {
  document.body.style.setProperty('--el-color-primary', '#FF7800')
  //  document.body.style.setProperty('--el-color-primary-light-9', '#f5a864')
  document.body.style.setProperty('--el-color-primary-light-3', '#f5a864')
})
</script>
