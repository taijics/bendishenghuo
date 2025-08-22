<template>
  <div class="miniCardComponents">
    <span class="title">{{ props.title }}</span>
    <h2>{{ props.nums }}</h2>
    <span class="gray">{{ props.precent }}：</span>
    <span
      class="precent"
      :class="{
        redP: props.precentData > 0,
        greenP: props.precentData < 0,
      }"
    >
      {{ props.precentData || 0 }}%
    </span>
    <span v-if="props.precentData > 0" class="triangle up"></span>
    <span v-if="props.precentData < 0" class="triangle down"></span>
  </div>
</template>

<script setup>

const props = defineProps({
  title: {
    type: String,
    default: '',
  },
  precent: {
    type: String,
    default: '',
  },
  nums: {
    type: Number,
    default: 0,
  },
  precentData: {
    type: Number,
    default: 0,
  },
})
</script>

<style lang="scss" scoped>
.miniCardComponents {
  $red: #d04a41;
  $green: #427a0a;
  margin-right: 50px;
  h2 {
    margin: 12px 0;
    font-weight: bold;
  }
  .title {
    font-size: 16px;
    font-weight: 700;
  }
  .gray {
    color: #929292;
  }
  .precent {
    margin: 0 8px;
  }
  .redP {
    color: $red;
  }
  .greenP {
    color: $green;
  }
  .triangle {
    width: 0;
    height: 0;
    position: relative;
    border: 8px solid;
  }
  .up {
    position: relative;
    top: -12px;
    border-color: transparent transparent $red transparent;
  }
  .down {
    position: relative;
    top: 12px;
    border-color: $green transparent transparent transparent;
  }
}
</style>
