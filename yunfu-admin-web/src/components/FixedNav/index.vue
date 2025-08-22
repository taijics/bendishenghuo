<template>
  <nav
    class="zk_fixed_nav"
    :class="[
      fixed ? `zk_set_fixed ${fixedCustomClass}` : '',
      !backgroundColor && fixed ? 'zk_fixed_border' : '',
    ]"
    :style="{
      'background-color': `${backgroundColor}`,
    }"
  >
    <slot></slot>
  </nav>
</template>

<script setup>
import { defineComponent, onMounted, onUnmounted, shallowRef, toRefs } from 'vue'

defineComponent({
  name: 'FixedNav'
})
/**
 * @property {number} height 浮现距离
 * @property {string} backgroundColor 背景颜色
 * @property {string} fixedCustomClass 标题固定后自定义class名
 */
const props = defineProps({
  height: {
    type: Number,
    default: 0,
  },
  backgroundColor: {
    type: String,
    default: '',
  },
  fixedCustomClass: {
    type: String,
    default: ''
  }
})
const { height, fixedCustomClass } = toRefs(props);
let fixed = shallowRef(false);

function zk_fixed_nav () {
  console.log('zk_fixed_nav')
  if (!height.value) {
    return
  }
  fixed.value = window.scrollY > height.value
}
onMounted(() => {
  window.addEventListener('scroll', zk_fixed_nav)
})
onUnmounted(() => {
  window.removeEventListener('scroll', zk_fixed_nav)
})
</script>

<style lang="scss" scoped>
.zk_fixed_nav {
  width: 100%;
  padding: 8px 12px;
}
.zk_set_fixed {
  width: 100%;
  position: fixed;
  top: 0;
  z-index: 9;
}
.zk_fixed_border {
  background-color: #fff;
  box-shadow: 0 2px 10px 0 rgba(0, 0, 0, 0.1);
}
</style>
