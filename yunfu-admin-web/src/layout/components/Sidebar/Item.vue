<template>
  <div>
    <icon :icon="icon" />
    <span>{{ title }}</span>
  </div>
</template>
<script setup>
defineProps({
  icon: {
    type: String,
    required: true
  },
  title: {
    type: String,
    required: true
  }
})
</script>

<style scoped>
span {
  vertical-align: middle;
  margin-left: 12px;
}
</style>
