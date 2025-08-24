<template>
  <view class="merchant-wrap" :style="wrapStyle">
    <!-- 排序 Tabs（距离/推荐/销量） -->
    <view class="sort-tabs">
      <view
        v-for="t in sortTabs"
        :key="t.key"
        class="tab-item"
        :class="{ active: t.key === curSort }"
        @tap="onChangeSort(t.key)"
      >
        <text class="tab-text">{{ t.label }}</text>
        <view class="tab-underline" />
      </view>
    </view>

    <!-- 列表卡片 -->
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

        <!-- 绿色“积 XX%”胶囊 -->
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
import { request } from '@/utils/request'

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
        api: ds.api || '/api/shop/getShopsBySortType',
        method: (ds.method || 'GET').toUpperCase(),
        params: initParams
      },
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
      this.refresh()
    },
    refresh() {
      // 暴露给父组件的“下拉刷新”入口
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
        // 适配 yunfu-front-uni: request(url, data, method)
        const res = await request(this.dataSource.api, params, this.dataSource.method)

        // 返回结构兼容
        const data = res.data || res || {}
        const list = data.list || data.records || data.rows || data.items || data.result || []
        const total = data.total != null ? data.total : data.count != null ? data.count : (Array.isArray(list) ? list.length : 0)

        const normalized = (list || []).map((it) => this.normalizeMerchant(it))
        this.merchants = reset ? normalized : this.merchants.concat(normalized)

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
      // 页级 onReachBottom 会调用到这里
      this.fetchList(false)
    },
    normalizeMerchant(raw = {}) {
      const rate =
        raw.rebateRate != null ? raw.rebateRate :
        raw.pointRate  != null ? raw.pointRate  :
        raw.rewardRate != null ? raw.rewardRate :
        raw.integralRate != null ? raw.integralRate : null

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
/* 样式与之前一致，略 */
.merchant-wrap { box-sizing: border-box; background-color: #f6f7f9; }
/* ...其余样式保持你当前版本 */
</style>