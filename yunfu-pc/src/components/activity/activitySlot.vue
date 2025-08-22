// 营销活动插槽
<template>
  <div class="activitySlot">
    <nav>
      <img :src="imgTitle" alt="">
      <slot name="title"></slot>
    </nav>
    <slot name="section"></slot>
  </div>
</template>

<script>
export default {
  props: {
    imgTitle: {
      type: String,
      default: ''
    }
  }
}
</script>

<style lang="scss" scoped>
.activitySlot{
  max-width: 1250px;
  margin: auto;
  nav{
    height: 250px;
    background-color: #333;
    img{
      width: 100%;
      height: 250px;
    }
  }
}
</style>
