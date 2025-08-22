<template>
  <div class="detailRankPage">
    <div class="top">
      <div class="text">{{ title }}</div>
      <div class="text">{{ subtitle }}</div>
    </div>
    <section>
      <div
        v-for="(item, index) in rankData"
        :key="index"
      >
        <div
          v-if="index < 10"
          class="list"
        >
          <span
            class="icon"
            :class="[index <= 2 ? 'spanAct' : '']"
          >{{
            index + 1
          }}</span>
          <span>{{ item.rankName }}</span>
          <span>{{ item.ranks }}</span>
        </div>
      </div>
    </section>
  </div>
</template>

<script setup>
import { toRefs } from 'vue';

const props = defineProps({
  title: {
    type: String,
    default: '',
  },
  subtitle: {
    type: String,
    default: '',
  },
  rankData: {
    type: Array,
    default: () => [],
  },
})
const { title, subtitle, rankData } = toRefs(props)

</script>

<style
    lang="scss"
    scoped
>
.detailRankPage {
  margin-left: 20px;
  width: 100%;
  height: 100%;
  padding: 20px 12px;
  background: #ffffff;
  border: 1px solid #efefef;
  border-radius: 4px;

  .top {
    width: 100%;
    display: flex;
    justify-content: space-between;

    .text {
      font-size: 18px;
      color: #333333;
    }
  }

  section {
    width: 100%;

    .list {
      margin-top: 20px;
      display: flex;
      justify-content: space-between;
      align-items: center;

      span {
        color: #666666;
      }

      .icon {
        margin-left: 5px;
      }

      .spanAct {
        background-color: #ff7911 !important;
        color: #ffffff !important;
      }

      span:nth-child(1) {
        $height: 26px;
        width: 26px;
        height: $height;
        line-height: $height;
        text-align: center;
        background-color: #dddddd;
        border-radius: 50%;
      }

      span:nth-child(2) {
        flex: 8;
        margin: 0 8px;
      }

      span:nth-child(3) {
        flex: 1;
      }
    }
  }
}
</style>
