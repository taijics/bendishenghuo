<template>
  <div class="grid-menu-wrap">
    <div class="grid-menu">
      <div
        v-for="(item, idx) in gridMenu"
        :key="idx"
        class="grid-cell"
      >
        <div class="grid-img-box">
          <img v-if="item.img" :src="item.img" class="grid-img" />
          <span v-else class="iconfont default-img">&#xe64a;</span>
        </div>
        <div class="grid-text">{{ item.text || '菜单' }}</div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed } from 'vue'
const props = defineProps({ data: Object })
const defaultMenu = [
  { img: '', text: '餐饮美食' },
  { img: '', text: '休闲玩乐' },
  { img: '', text: '酒店民宿' },
  { img: '', text: '运动健身' },
  { img: '', text: '看病买药' },
  { img: '', text: '按摩足疗' },
  { img: '', text: '超市便利' },
  { img: '', text: '宠物天地' },
  { img: '', text: '亲子乐园' },
  { img: '', text: '更多优选' }
]
const gridMenu = computed(() => {
  const arr = props?.data?.componentContent?.gridMenuData
  return Array.isArray(arr) && arr.length > 0 ? arr : defaultMenu
})
</script>

<style scoped lang="scss">
.grid-menu-wrap {
  width: 100%;
  background: #fff;
  border-radius: 18px;
  padding: 24px 0 10px 0;
  margin: 0 auto;
  box-shadow: 0 2px 8px 0 rgba(0,0,0,0.03);
}
.grid-menu {
  display: grid;
  grid-template-columns: repeat(5, 1fr);
  grid-template-rows: repeat(2, 1fr);
  gap: 0 0;
}
.grid-cell {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: flex-start;
  padding: 10px 0 0 0;
}
.grid-img-box {
  width: 62px;
  height: 62px;
  border-radius: 18px;
  overflow: hidden;
  background: #f2f3f5;
  margin-bottom: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
}
.grid-img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  border-radius: 16px;
}
.default-img {
  font-size: 38px;
  color: #ddd;
}
.grid-text {
  font-size: 16px;
  color: #333;
  font-weight: 700;
  margin-top: 2px;
  text-align: center;
  letter-spacing: 1px;
}
</style>