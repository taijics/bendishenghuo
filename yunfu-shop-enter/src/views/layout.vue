<template>
  <div class="layout">
    <v-header class="vHeader"></v-header>
    <router-view class="centBox"></router-view>
  </div>
</template>

<script>
  import VHeader from '@/components/base/v-header'
  export default {
    name: 'layout',
    components: {VHeader}
  }
</script>
<style lang="scss">
.layout {
  flex-direction: column;
  height: 100%;
  display: flex;
  background-image: url("../assets/images/personal-bc.webp");
  background-repeat: no-repeat;
  background-size: 100% 100%;
}
.vHeader {
  flex-shrink: 0;
}
.centBox {
  flex-grow: 1;
}
</style>
