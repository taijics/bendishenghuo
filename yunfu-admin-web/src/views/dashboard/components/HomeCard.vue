<template>
  <div ref="cardComponent" class="homeCardComponent">
    <div class="top">
      <span class="fs22" :style="{ color: `${color}` }">{{ props.title }}</span>
      <span
        class="today"
        :style="{ color: `${props.color}`, borderColor: `${props.todayColor}` }"
      >今日</span>
    </div>
    <div class="nums" :style="{ color: `${props.color}` }">{{ props.cardData.nums }}</div>
    <div class="footer">
      <div class="item">
        <div class="precent">
          周环比
          <span
            class="precent"
            :class="{
              redP: props.cardData.precent > 0,
              greenP: props.cardData.precent < 0,
            }"
          >
            {{ props.cardData.precent || 0 }}%
          </span>
          <span v-if="props.cardData.precent > 0" class="triangle up"></span>
          <span v-if="props.cardData.precent < 0" class="triangle down"></span>
        </div>
      </div>
      <div class="item">
        <span>昨日数据</span>
        <span>{{ props.cardData.lastNums }}</span>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'

const cardComponent = ref(null)
const props = defineProps({
  cardData: {
    type: Object,
    default: () => ({
      nums: '',
      precent: 0,
      lastNums: '',
    }),
  },
  title: {
    type: String,
    default: '',
  },
  nums: {
    type: Number,
    default: 0,
  },
  precent: {
    type: Number,
    default: 0,
  },
  lastNums: {
    type: Number,
    default: 0,
  },
  color: {
    type: String,
    default: null,
  },
  backgroundColor: {
    type: String,
    default: null,
  },
  todayColor: {
    type: String,
    default: null,
  },
})

onMounted(() => {
  cardComponent.value.style.backgroundColor = props.backgroundColor
})
</script>

<style lang="scss">
.homeCardComponent {
  padding: 15px;
  display: inline-flex;
  flex-direction: column;
  min-width: 200px;
  min-height: 200px;
  border-radius: 16px;
  .top {
    font-size: 22px;
    margin: 12px 0 12px 12px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    .today {
      font-size: 14px;
      padding: 8px 16px;
      border: 1px solid;
      border-radius: 4px;
    }
  }
  .nums {
    margin: 8px;
    font-size: 48px;
  }
  .footer {
    height: 115px;
    font-size: 16px;
    padding: 12px 0;
    border-radius: 8px;
    background-color: rgba($color: #fff, $alpha: 0.8);
    box-shadow: 0px 10px 20px 1px rgba(27, 85, 175, 0.05000000074505806);
    display: flex;
    flex-direction: column;
    justify-content: space-around;
    .item {
      margin: 0 12px;
      // line-height: 40px;
      display: flex;
      justify-content: space-between;
      align-items: center;
      color: #333;
      // opacity: .5;
      .precent {
        $red: #d04a41;
        $green: #427a0a;
        span {
          margin-left: 18px;
          // opacity: 1;
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
    }
  }
}
</style>
