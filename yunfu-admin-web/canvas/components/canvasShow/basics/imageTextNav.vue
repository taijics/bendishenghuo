<template>
  <ul class="ul image-text-nav" :class="'terminal' + terminal">
    <li
      v-for="(item, index) in componentContent.imgTextData"
      :key="index"
      class="li"
      :style="{ flex: '0 0 ' + getItemValue() + '%' }"
      @click="jumpLink(componentContent.linkObj)"
    >
      <div class="img-box">
        <div class="img-box-inner">
          <el-image :src="item.img" fit="cover" />
        </div>
      </div>
      <h4 class="h4">{{ item.title }}</h4>
    </li>
  </ul>
</template>

<script setup>
import { toRefs } from 'vue';
import { funMixin } from '../config/mixin'
const { jumpLink } = funMixin()
const props = defineProps({
  terminal: {
    type: Number,
    default: 4,
  },
  componentContent: {
    type: Object,
    default () {
      return {};
    }
  }
})
const { terminal, componentContent } = toRefs(props)
// 计算生成格子百分比
function getItemValue () {
  const len = parseInt(componentContent.value.imgTextData.length)
  if (len === 0) {
    return 0
  } else {
    return ((1 / len) * 10000) / 100.0
  }
}
</script>

<style lang="scss" scoped>
.image-text-nav {
  min-height: 100px;
  width: 690px;
  margin: 0 auto;
  display: flex;
  padding: 20px 0;
  .li {
    text-align: center;
    .img-box {
      .el-image {
        width: 100px;
        height: 100px;
      }
    }
    .h4 {
      font-size: 26px;
      color: #333;
      line-height: 33px;
    }
  }
  &.terminal4 {
    width: 1000px;
    .li {
      .img-box {
        display: inline-block;
        width: 100px;
        height: 100px;
        border: 2px solid #f3f4f5;
        border-radius: 10px;
        &-inner {
          display: flex;
          justify-content: center;
          align-items: center;
          height: 100%;
        }
        .el-image {
          width: 60px;
          height: 60px;
        }
      }
      .h4 {
        font-size: 18px;
        color: #ccc;
        line-height: 1em;
        padding-top: 20px;
      }
    }
  }
}
</style>
