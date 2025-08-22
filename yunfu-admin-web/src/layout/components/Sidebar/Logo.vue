<template>
  <div class="sidebar-logo-container">
    <transition name="sidebarLogoFade">
      <router-link
        v-if="collapse"
        key="collapse"
        class="sidebar-logo-link"
        to="/"
      >
        <img src="../../../assets/images/logo.png" class="sidebar-logo" />
        <h1 v-if="collapse" class="sidebar-title">{{ title }}</h1>
      </router-link>

      <router-link
        v-else
        key="expand"
        class="sidebar-logo-link sidebar-collapse-logo-link"
        to="/"
      >
        <img src="../../../assets/images/logo.png" class="sidebar-logo" />
        <h1 v-if="collapse" class="sidebar-title">{{ title }}</h1>
      </router-link>
    </transition>
  </div>
</template>

<script setup>
defineProps({
  collapse: {
    type: Boolean,
    required: true
  }
})
const title = 'cereShop平台端'
</script>

<style lang="scss" scoped>
// .fade-enter-active,
// .fade-leave-active {
//     opacity: 1;
//     transition: all 0.5s ease-out;
// }
// .fade-enter-from,
// .fade-leave-to {
//     opacity: 0;
// }
.sidebar-logo-container {
  position: relative;
  width: 100%;
  height: 50px;
  line-height: 50px;
  background: #2b2f3a;
  // text-align: center;
  overflow: hidden;

  & .sidebar-logo-link {
    display: block;
    height: 100%;
    width: 100%;

    & .sidebar-logo {
      width: 32px;
      height: 32px;
      vertical-align: middle;
      margin: 0 11px;
    }
    & .sidebar-title {
      display: inline-block;
      margin: 0;
      color: #fff;
      font-weight: 600;
      line-height: 50px;
      font-size: 19px;
      font-family: Avenir, Helvetica Neue, Arial, Helvetica, sans-serif;
      vertical-align: middle;
    }
  }
  & .sidebar-collapse-logo-link {
    display: flex;
    align-items: center;
    justify-content: center;
  }
}
.sidebarLogoFade-enter-active {
  transition: opacity 2s;
}

.sidebarLogoFade-leave-active,
.sidebarLogoFade-enter-from,
.sidebarLogoFade-leave-to {
  opacity: 0;
}
</style>
