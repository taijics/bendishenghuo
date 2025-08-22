<template>
  <div>
    <el-button type="warning" @click="reidis">Redis延时任务</el-button>
  </div>
</template>

<script setup>
import { initializationRedis } from '@/api/pay'

const reidis = async () => {
  const res = await initializationRedis()
  if (res.code === '') {
    ElMessage.success('执行成功')
  }
}
</script>
