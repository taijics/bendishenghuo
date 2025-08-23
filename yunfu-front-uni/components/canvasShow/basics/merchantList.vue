<template>
  <view class="merchant-wrap" :style="wrapStyle">
    <!-- 排序 Tabs -->
    <view class="sort-tabs" v-if="showSortTabs">
      <view
        v-for="(t, i) in sortTabs"
        :key="t.key"
        class="tab-item"
        :class="{ active: t.key === curSort }"
        @tap="onChangeSort(t.key)"
      >
        <text class="tab-text">{{ t.label }}</text>
        <view class="tab-underline" />
      </view>
    </view>

    <!-- 列表 -->
    <view
      v-for="(m, idx) in merchants"
      :key="m.id || idx"
      class="card"
      :class="{ shadow: uiStyle.cardShadow }"
      :style="cardStyle"
      @tap="handleClick(m)"
    >
      <image class="cover" :src="m.logo || m.cover || defaultLogo" mode="aspectFill" />

      <view class="right">
        <!-- 标题 + 状态 -->
        <view class="title-row">
          <text class="title" :style="{ color: uiStyle.titleColor }">
            {{ m.name || '商家' }}
          </text>
          <view class="status" :style="statusStyle(m)">
            <text class="status-text">{{ businessText(m) }}</text>
          </view>
        </view>

        <!-- 销量 -->
        <view class="sold-row" v-if="m.monthlySales != null || m.soldCount != null">
          <text class="sold-text">已售{{ m.monthlySales != null ? m.monthlySales : m.soldCount }}</text>
        </view>

        <!-- 积分返利胶囊 -->
        <view class="rebate-row" v-if="m.rebateText">
          <view class="rebate-chip" :style="rebateStyle">
            <text class="rebate-flag">积</text>
            <text class="rebate-text">{{ m.rebateText }}</text>
          </view>
        </view>

        <!-- 类目 + 距离 -->
        <view class="meta-row">
          <text class="category" v-if="m.categoryName" :style="{ color: uiStyle.subTextColor }">
            {{ m.categoryName }}
          </text>

          <view class="distance" v-if="m.distance != null">
            <image class="loc-icon" :src="locIcon" mode="widthFix" />
            <text class="distance-text">{{ formatDistance(m.distance) }}</text>
          </view>
        </view>

        <!-- 地址 -->
        <view class="addr-row" v-if="m.address">
          <text class="addr" :style="{ color: uiStyle.subTextColor }">
            {{ m.address }}
          </text>
        </view>
      </view>
    </view>

    <!-- 空态 -->
    <view v-if="!loading && merchants.length === 0" class="empty">
      <image class="empty-img" :src="emptyImg" mode="widthFix" />
      <text class="empty-text">这里空空如也~</text>
    </view>

    <!-- 底部加载/更多 -->
    <view v-if="merchants.length" class="footer">
      <view v-if="!finished" class="load-more" @tap="loadMore">
        <text>加载更多</text>
      </view>
      <view v-else class="no-more">
        <text>这里到底了哦~~</text>
      </view>
    </view>
  </view>
</template>

<script>
/**
 * 商家列表（merchantList）
 * - 样式对齐需求截图：卡片圆角阴影、左图右文、营业中绿色标签、销量、绿色“积 XX%”胶囊、类目、距离、地址
 * - 数据来源：componentContent.dataSource（api/method/params）
 * - 风格配置：componentContent.uiStyle（圆角/阴影/间距/文字颜色/状态与标签颜色）
 * - 显示：componentContent.show（各元素开关，保留但当前样式默认展示）
 * - 排序：顶部 Tabs（距离/推荐/销量），切换会修改 params.sort 并重新拉取
 */
import request from '@/utils/request'

export default {
  name: 'ComMerchantList',
  props: {
    componentData: {
      type: Object,
      required: true
    }
  },
  data() {
    const cc = (this.componentData && this.componentData.componentContent) || {}
    const ui = cc.uiStyle || {}
    const ds = cc.dataSource || {}

    const initParams = Object.assign({ page: 1, size: 10, sort: 'distance' }, ds.params || {})

    return {
      uiStyle: {
        // 单位：rpx
        cardRadius: ui.cardRadius != null ? ui.cardRadius : 24,
        cardShadow: ui.cardShadow != null ? ui.cardShadow : true,
        padding: ui.padding != null ? ui.padding : 20,
        gap: ui.gap != null ? ui.gap : 20,
        titleColor: ui.titleColor || '#111111',
        subTextColor: ui.subTextColor || '#666666',
        statusColor: ui.statusColor || '#18C46E',
        tagBg: ui.tagBg || '#E9F7EE',
        tagColor: ui.tagColor || '#18C46E'
      },
      dataSource: {
        api: ds.api || '/api/merchant/list',
        method: (ds.method || 'GET').toUpperCase(),
        params: initParams
      },

      // 排序标签
      sortTabs: [
        { key: 'distance', label: '距离' },
        { key: 'recommend', label: '推荐' },
        { key: 'sales', label: '销量' }
      ],
      curSort: initParams.sort || 'distance',

      merchants: [],
      page: initParams.page || 1,
      size: initParams.size || 10,
      total: 0,
      loading: false,
      finished: false,

      defaultLogo: `${process.env.VUE_APP_STATIC_URL || ''}/static/images/shop_default.png`,
      emptyImg: `${process.env.VUE_APP_STATIC_URL || ''}/static/images/empty.png`,
      locIcon: `${process.env.VUE_APP_STATIC_URL || ''}/static/images/location_pin.png`
    }
  },
  computed: {
    wrapStyle() {
      return {
        padding: `${this.uiStyle.gap}rpx ${this.uiStyle.gap}rpx 0 ${this.uiStyle.gap}rpx`
      }
    },
    cardStyle() {
      return {
        borderRadius: this.uiStyle.cardRadius + 'rpx',
        padding: this.uiStyle.padding + 'rpx',
        marginBottom: this.uiStyle.gap + 'rpx'
      }
    },
    rebateStyle() {
      return {
        color: this.uiStyle.tagColor,
        borderColor: this.uiStyle.tagColor,
        backgroundColor: this.uiStyle.tagBg
      }
    },
    showSortTabs() {
      // 若数据源带了 sort 字段，则展示排序 Tabs
      return true
    }
  },
  watch: {
    componentData: {
      deep: true,
      handler() {
        this.resetAndFetch()
      }
    }
  },
  mounted() {
    this.fetchList(true)
  },
  methods: {
    onChangeSort(key) {
      if (this.curSort === key) return
      this.curSort = key
      this.dataSource.params.sort = key
      this.resetAndFetch()
    },
    resetAndFetch() {
      const ds = (this.componentData?.componentContent?.dataSource) || {}
      const params = Object.assign({ page: 1, size: this.size, sort: this.curSort }, ds.params || {})
      this.page = params.page
      this.size = params.size
      this.total = 0
      this.merchants = []
      this.finished = false
      this.dataSource.params = params
      this.fetchList(true)
    },
    async fetchList(reset = false) {
      if (this.loading) return
      if (!reset && this.finished) return
      this.loading = true
      try {
        const params = Object.assign({}, this.dataSource.params || {}, { page: this.page, size: this.size })

        const req = { url: this.dataSource.api, method: this.dataSource.method }
        if (this.dataSource.method === 'GET') req.params = params
        else req.data = params

        const res = await request(req)
        // 兼容多种返回结构
        const data = res.data || {}
        const list = data.list || data.records || data.rows || data.items || data.result || []
        const total = data.total != null ? data.total : data.count != null ? data.count : (Array.isArray(list) ? list.length : 0)

        const normalized = (list || []).map((it) => this.normalizeMerchant(it))
        if (reset) this.merchants = normalized
        else this.merchants = this.merchants.concat(normalized)

        this.total = total
        const reached = this.merchants.length >= this.total && this.total !== 0
        this.finished = reached || (Array.isArray(list) && list.length < this.size)

        if (!this.finished) this.page += 1
      } catch (e) {
        this.finished = true
      } finally {
        this.loading = false
      }
    },
    loadMore() {
      this.fetchList(false)
    },
    normalizeMerchant(raw = {}) {
      const rate =
        raw.rebateRate != null
          ? raw.rebateRate
          : raw.pointRate != null
          ? raw.pointRate
          : raw.rewardRate != null
          ? raw.rewardRate
          : raw.integralRate != null
          ? raw.integralRate
          : null
      // 组装展示字段
      return {
        id: raw.id || raw.merchantId || raw.shopId,
        name: raw.name || raw.title || raw.shopName,
        logo: raw.logo || raw.avatar || raw.image || raw.shopLogo,
        cover: raw.cover || raw.bgImage,
        categoryName: raw.categoryName || raw.category || (raw.categories && raw.categories.join(' / ')),
        address: raw.address || raw.addr || raw.location,
        distance: raw.distance,
        status: raw.status,
        isOpen: raw.isOpen,
        soldCount: raw.soldCount != null ? raw.soldCount : raw.monthlySales,
        monthlySales: raw.monthlySales != null ? raw.monthlySales : raw.soldCount,
        rebateText: rate == null ? '' : this.formatRebate(rate)
      }
    },
    formatRebate(v) {
      const n = Number(v)
      if (isNaN(n)) return String(v)
      // 允许后端传 0.1 或 10 两种，统一显示百分号
      const pct = n <= 1 ? (n * 100) : n
      return pct.toFixed(2) + '%'
    },
    formatDistance(v) {
      if (v == null || v === '') return ''
      const n = Number(v)
      if (isNaN(n)) return String(v)
      if (n >= 1000) return (n / 1000).toFixed(2) + 'km'
      return Math.round(n) + 'm'
    },
    businessText(m) {
      const open =
        m.isOpen === true ||
        m.status === 1 ||
        m.status === 'open' ||
        m.status === 'OPEN' ||
        m.status === '营业中'
      return open ? '营业中' : '休息中'
    },
    statusStyle(m) {
      const open = this.businessText(m) === '营业中'
      return {
        color: this.uiStyle.statusColor,
        borderColor: this.uiStyle.statusColor,
        backgroundColor: '#FFFFFF',
        opacity: open ? 1 : 0.5
      }
    },
    handleClick(m) {
      if (m && m.id) {
        try {
          uni.navigateTo({ url: `/pages/merchant/detail/index?id=${m.id}` })
        } catch (e) {}
      }
    }
  }
}
</script>

<style scoped>
.merchant-wrap {
  box-sizing: border-box;
  background-color: #f6f7f9;
}

/* 顶部排序 Tabs */
.sort-tabs {
  height: 88rpx;
  padding: 0 20rpx;
  background-color: #f6f7f9;
  display: flex;
  align-items: center;
}
.tab-item {
  position: relative;
  margin-right: 40rpx;
  height: 88rpx;
  display: flex;
  align-items: center;
}
.tab-text {
  font-size: 30rpx;
  color: #333333;
}
.tab-item.active .tab-text {
  color: #ff4d4f;
  font-weight: 600;
}
.tab-underline {
  position: absolute;
  left: 0;
  bottom: 12rpx;
  height: 8rpx;
  width: 60%;
  border-radius: 8rpx;
  background: transparent;
}
.tab-item.active .tab-underline {
  background: #ff4d4f;
}

.card {
  display: flex;
  flex-direction: row;
  align-items: flex-start;
  background: #ffffff;
}
.card.shadow {
  box-shadow: 0 8rpx 24rpx rgba(0, 0, 0, 0.08);
}
.cover {
  width: 220rpx;
  height: 170rpx;
  border-radius: 16rpx;
  background: #f2f3f5;
  flex-shrink: 0;
}
.right {
  flex: 1;
  margin-left: 20rpx;
  display: flex;
  flex-direction: column;
}

.title-row {
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: space-between;
}
.title {
  font-size: 34rpx;
  font-weight: 700;
  color: #111111;
  max-width: 420rpx;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.status {
  padding: 4rpx 12rpx;
  border: 2rpx solid;
  border-radius: 10rpx;
}
.status-text {
  font-size: 26rpx;
}

.sold-row {
  margin-top: 8rpx;
}
.sold-text {
  color: #9aa0a6;
  font-size: 26rpx;
}

.rebate-row {
  margin-top: 12rpx;
}
.rebate-chip {
  display: inline-flex;
  align-items: center;
  padding: 4rpx 12rpx;
  border-radius: 999rpx;
  border: 2rpx solid;
  background: #e9f7ee;
}
.rebate-flag {
  font-size: 22rpx;
  margin-right: 8rpx;
}
.rebate-text {
  font-size: 24rpx;
  font-weight: 600;
}

.meta-row {
  margin-top: 12rpx;
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: space-between;
}
.category {
  font-size: 26rpx;
}
.distance {
  display: flex;
  flex-direction: row;
  align-items: center;
  color: #666666;
}
.loc-icon {
  width: 24rpx;
  margin-right: 8rpx;
}
.distance-text {
  font-size: 26rpx;
}

.addr-row {
  margin-top: 10rpx;
}
.addr {
  font-size: 26rpx;
  color: #666666;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.empty {
  padding: 60rpx 0 40rpx;
  display: flex;
  align-items: center;
  flex-direction: column;
  color: #999999;
}
.empty-img {
  width: 260rpx;
  margin-bottom: 16rpx;
}
.empty-text {
  font-size: 24rpx;
}

.footer {
  padding: 16rpx 0 28rpx;
  display: flex;
  justify-content: center;
}
.load-more {
  padding: 12rpx 28rpx;
  border-radius: 999rpx;
  border: 2rpx solid #e5e5e5;
  color: #666666;
  font-size: 24rpx;
}
.no-more {
  color: #b2b2b2;
  font-size: 24rpx;
}
</style>