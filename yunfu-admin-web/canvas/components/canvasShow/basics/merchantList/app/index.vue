<template>
  <div class="merchant-list" :style="rootStyle">
    <div
      v-for="item in list"
      :key="item.id"
      class="card"
      :style="cardStyle"
    >
      <img class="cover" :src="item.cover" alt="cover" />
      <div class="right">
        <div class="row title-row">
          <div class="title" :style="{ color: conf.style.titleColor, fontSize: conf.style.titleSize + 'px' }">
            {{ item.name }}
          </div>
          <div v-if="conf.show.businessStatus" class="status" :style="{ color: conf.style.statusColor }">
            {{ item.status || '营业中' }}
          </div>
        </div>

        <div v-if="conf.show.soldCount" class="row sub">
          <span>已售{{ item.sold || 0 }}</span>
        </div>

        <div v-if="conf.show.scoreTag" class="row">
          <span class="tag" :style="{ backgroundColor: conf.style.tagBg, color: conf.style.tagColor }">
            {{ item.scoreTagText || `积 ${(item.scorePercent || 0) * 100}%` }}
          </span>
        </div>

        <div class="row sub">
          <span v-if="conf.show.category">{{ item.category }}</span>
          <span v-if="conf.show.distance" class="distance">📍 {{ item.distance }}</span>
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
  name: 'MerchantListApp',
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
        boxShadow: this.conf.style.cardShadow ? '0 4px 12px rgba(0,0,0,0.06)' : 'none',
        marginBottom: this.conf.style.gap + 'px'
      }
    }
  }
}
</script>

<style scoped>
.merchant-list {
  background: #f7f7f7;
}
.card {
  display: flex;
  background: #fff;
  overflow: hidden;
}
.cover {
  width: 112px;
  height: 84px;
  object-fit: cover;
  border-radius: 8px;
  margin: 12px;
}
.right {
  flex: 1;
  padding: 12px 12px 12px 0;
  min-width: 0;
}
.row {
  display: flex;
  align-items: center;
  justify-content: space-between;
}
.title-row {
  margin-bottom: 6px;
}
.title {
  font-weight: 600;
  flex: 1;
  margin-right: 8px;
  min-width: 0;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}
.status {
  font-weight: 600;
}
.sub {
  color: #666;
  font-size: 12px;
  margin-top: 4px;
}
.tag {
  display: inline-block;
  padding: 2px 8px;
  border-radius: 6px;
  font-size: 12px;
  font-weight: 600;
}
.distance {
  margin-left: auto;
  margin-right: 0;
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