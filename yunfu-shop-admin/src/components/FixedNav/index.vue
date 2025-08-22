<template>
  <nav
    class="zk_fixed_nav"
    :class="{ zk_set_fixed : fixed, zk_fixed_border: !backgroundColor && fixed }"
    :style="{
      'background-color': `${backgroundColor}`
    }"
  >
    <slot />
  </nav>
</template>

<script>
export default {
  props: {
    height: { // 浮现距离
      type: Number,
      default: 0
    },
    backgroundColor: {
      type: String,
      default: ''
    }
  },
  data() {
    return {
      fixed: false
    }
  },
  mounted() {
    window.addEventListener('scroll', () => { this.zk_fixed_nav() })
  },
  methods: {
    zk_fixed_nav() {
      if (!this.height) { return }
      this.fixed = window.scrollY > this.height
    }
  }
}
</script>

<style lang="scss" scoped>
.zk_fixed_nav{
  width: 100%;
}
.zk_set_fixed {
  width: 100%;
  position: fixed;
  top: 0;
  z-index: 9;
}
.zk_fixed_border{
  background-color: #FFF;
  box-shadow: 0 2px 10px 0 rgba(0, 0, 0, 0.1)
}
</style>
