<template>
  <div class="shopStep">
    <div class="processBox"
    v-for="item in data"
    :key="item.value"
    :class="{last : item.value === arrLength -1}">
      <div class="title">
        <div class="edge-left" v-if="item.value !== 0"></div>
        <div class="content"
        :class="{glod : item.value <= active}">{{ item.label }}</div>
        <div class="edge" v-if="item.value !== arrLength -1"
        :class="{glodEdge : item.value <= active}"></div>
      </div>
      <div class="des"></div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'shopStep',
  props: {
    data: {
      type: Array,
      default: () => []
    },
    active: {
      type: Number,
      default: 0
    }
  },
  data () {
    return {
      arrLength: 0
    }
  },
  created () {
    this.arrLength = this.data.length
  }
}
</script>

<style lang="scss" scoped>
$stepHeight: 50px;
.shopStep{
  display: flex;
  height: $stepHeight;
  overflow: hidden;
  .processBox{
    flex: 1;
    .title{
      width: 100%;
      display: flex;
      position: relative;
      .content{
        flex: 1;
        color: #999999;
        text-align: center;
        background-color: #E5E5E5;
        line-height: $stepHeight;
      }
      .edge{
        position: relative;
        z-index: 1;
        width: 0;
        height: 0;
        border: $stepHeight/2 solid;
        border-color: transparent transparent transparent #E5E5E5;
      }
      .edge-left{
        position: absolute;
        z-index: 1;
        width: 0;
        height: 0;
        border: $stepHeight/2 solid;
        border-color: transparent transparent transparent #FFF;
      }
    }
  }
  .last{
    margin-right: - $stepHeight/2;
  }
  .glod{
    color: #FFF !important;
    background-color: $mainGlod !important;
  }

  .glodEdge{
    border-color: transparent transparent transparent $mainGlod !important;
  }
}
</style>
