<template>
  <div class="activityMain">
    <SecondNav />
    <router-view />
  </div>
</template>

<script>
import SecondNav from '@/components/base/secondNav.vue'
export default {
  components: {SecondNav}
}
</script>
