<template>
  <a v-if="isExternal(to)" :href="to" target="_blank" rel="noopener">
    <slot></slot>
  </a>
  <div v-else @click="push">
    <slot></slot>
  </div>
</template>

<script setup>
import { computed } from 'vue'
import { useRouter } from 'vue-router'
import { useStore } from 'vuex'
import { isExternal } from '@/utils/validate'

const store = useStore()
const router = useRouter()
const sidebar = computed(() => store.state.app.sidebar)
const device = computed(() => store.state.app.device)

const props = defineProps({
  to: {
    type: String,
    required: true
  }
})
const push = () => {
  if (device.value === 'mobile' && sidebar.value.opened === true) {
    store.dispatch('app/closeSideBar', { withoutAnimation: true })
  }
  router.push(props.to).catch(err => {
    console.error(err)
  })
}

</script>
