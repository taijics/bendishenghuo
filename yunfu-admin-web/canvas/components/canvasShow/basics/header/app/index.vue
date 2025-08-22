<template>
  <div class="header">
    <div class="top-box">
      <img
        v-if="componentContent.logoType === 1"
        class="logo"
        :src="componentContent.imageUrl"
        mode="heightFix"
      >
      <h3
        v-else
        class="h3"
        :style="{
          fontSize: componentContent.fontSizeNum + 'px',
          fontWeight: componentContent.textFontW,
          color: componentContent.titColor,
        }"
      >
        {{ componentContent.title }}
      </h3>
      <div class="search-btn">
        <img
          class="search-icon"
          src="https://ceres.zkthink.com/static/img/search.png"
          mode="widthFix"
        >
      </div>
    </div>
    <div class="tabs-nav-warp">
      <div class="tabs-nav" scroll-x="true">
        <div class="ul">
          <div
            class="li"
            :class="{ on: activeTab === 0 }"
            @click="tabChange(0)"
          >
            首页
          </div>
          <div
            v-for="(item, index) in classifyData"
            :key="index"
            class="li"
            :class="{ on: activeTab === index + 1 }"
          >
            {{ item.categoryName }}
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
<script setup>
import { ref, toRefs } from 'vue';
import commonMixin from '../mixin';
const props = defineProps({
  componentContent: {
    type: Object,
    default () {
      return {};
    },
  },
});
const { componentContent } = toRefs(props);
const { classifyData } = commonMixin();
const activeTab = ref(0);
</script>

<style lang="scss" scoped>
.header {
  .top-box {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding-left: 30px;
    width: 100%;
    .logo {
      // width: 280px;
      height: 70px;
      margin-top: 0px;
    }

    .search-btn {
      height: 66px;
      background: rgba(255, 255, 255, 1);
      border-radius: 33px;
      display: flex;
      flex-direction: row;
      align-items: center;
      margin-right: 30px;
      cursor: pointer;
      .search-icon {
        width: 60px;
        height: 60px;
      }
    }
  }
}
.tabs-nav-warp {
  margin-top: 20px;
  padding: 0 30px;
  overflow: hidden;
  .tabs-nav {
    .ul {
      display: flex;
      .li {
        flex: 1 0 auto;
        margin-left: 36px;
        font-size: 30px;
        color: #999999;
        position: relative;
        padding-bottom: 18px;
        &:first-child {
          margin-left: 0;
        }
        &.on {
          &:after {
            content: "";
            width: 100%;
            height: 4px;
            background: #c5aa7b;
            position: absolute;
            left: 0;
            bottom: 0;
          }
          font-weight: bold;
        }
      }
    }
  }
}
</style>
