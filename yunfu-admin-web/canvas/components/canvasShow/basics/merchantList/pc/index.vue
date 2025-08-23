<template>
  <div class="merchant-list-pc" :style="rootStyle">
    <div
      v-for="item in list"
      :key="item.id"
      class="card"
      :style="cardStyle"
    >
      <img class="cover" :src="item.cover" alt="cover" />
      <div class="right">
        <div class="row title-row">
          <div class="title">{{ item.name }}</div>
          <div v-if="conf.show.businessStatus" class="status" :style="{ color: conf.style.statusColor }">
            {{ item.status || '营业中' }}
          </div>
        </div>

        <div class="row sub">
          <span v-if="conf.show.soldCount">已售{{ item.sold || 0 }}</span>
          <span v-if="conf.show.distance" class="distance">📍 {{ item.distance }}</span>
        </div>

        <div class="row">
          <span v-if="conf.show.scoreTag" class="tag" :style="{ backgroundColor: conf.style.tagBg, color: conf.style.tagColor }">
            {{ item.scoreTagText || `积 ${(item.scorePercent || 0) * 100}%` }}
          </span>
          <span class="category" v-if="conf.show.category">{{ item.category }}</span>
        </div>

        <div v-if="conf.show.address" class="row sub ellipsis">
          {{ item.address }}
        </div>
      </div>
    </div>
    <div v-if="!list.length" class="empty">暂无数据</div>
  </div>
</template>

<script>
import mixin from '../mixin.js'

export default {
  name: 'MerchantListPc',
  mixins: [mixin],
  computed: {
    rootStyle() {
      return {
        padding: this.conf.style.padding + 'px'
      }
    },
    cardStyle() {
      return {
        borderRadius: this.conf.style.cardRadius + 'px',
        boxShadow: this.conf.style.cardShadow ? '0 6px 16px rgba(0,0,0,0.06)' : 'none',
        marginBottom: this.conf.style.gap + 'px'
      }
    }
  }
}
</script>

<style scoped>
.merchant-list-pc {
  background: #f5f5f5;
}
.card {
  display: flex;
  background: #fff;
  overflow: hidden;
}
.cover {
  width: 160px;
  height: 120px;
  object-fit: cover;
  border-radius: 8px;
  margin: 16px;
}
.right {
  flex: 1;
  padding: 16px 16px 16px 0;
  min-width: 0;
}
.row {
  display: flex;
  align-items: center;
  justify-content: space-between;
}
.title-row {
  margin-bottom: 8px;
}
.title {
  font-size: 18px;
  font-weight: 600;
  flex: 1;
  margin-right: 8px;
  min-width: 0;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  color: #111;
}
.status {
  font-weight: 600;
}
.sub {
  color: #666;
  font-size: 12px;
  margin-top: 6px;
}
.tag {
  display: inline-block;
  padding: 2px 10px;
  border-radius: 6px;
  font-size: 12px;
  font-weight: 600;
}
.category {
  color: #666;
  font-size: 12px;
  margin-left: auto;
}
.distance {
  margin-left: auto;
  white-space: nowrap;
  margin-left: 8px;
}
.ellipsis {
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}
.empty {
  text-align: center;
  color: #999;
  padding: 24px 0;
  font-size: 14px;
}
</style>