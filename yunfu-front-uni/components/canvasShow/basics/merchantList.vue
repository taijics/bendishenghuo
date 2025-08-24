<template>
    <view class="merchant-wrap" :style="wrapStyle">
        <!-- 排序 Tabs（距离/推荐/销量） -->
        <view class="sort-tabs">
            <view v-for="t in sortTabs" :key="t.key" class="tab-item" :class="{ active: t.key === curSort }" @tap="onChangeSort(t.key)">
                <text class="tab-text">{{ t.label }}</text>
                <view class="tab-underline" />
            </view>
        </view>

        <!-- 列表卡片 -->
        <view v-for="(m, idx) in merchants" :key="m.id || idx" class="card" :class="{ shadow: uiStyle.cardShadow }" :style="cardStyle" @tap="handleClick(m)">
            <image class="cover" :src="m.logo || m.cover || defaultLogo" mode="aspectFill" />
            <view class="right">
                <!-- 标题 + 状态（右侧仅绿色文字） -->
                <view class="title-row">
                    <text class="title" :style="{ color: uiStyle.titleColor }">
                        {{ m.name || '商家' }}
                    </text>
                    <text class="status-text-only" :style="{ color: uiStyle.statusColor }">{{ businessText(m) }}</text>
                </view>

                <!-- 销量 -->
                <view class="sold-row" v-if="m.monthlySales != null || m.soldCount != null">
                    <text class="sold-text">已售{{ m.monthlySales != null ? m.monthlySales : m.soldCount }}</text>
                </view>

                <!-- 积分胶囊 + 距离（同一行，左右分布） -->
                <view class="rebate-row" v-if="m.rebateText || m.distance != null">
                    <view class="rebate-chip" v-if="m.rebateText" :style="rebateStyle" style="padding: 0 5px 0 0; border-radius: 0.51875rem 8px 4px 0.51875rem">
                        <text class="rebate-flag">积</text>
                        <text class="rebate-text">{{ m.rebateText }}</text>
                    </view>
                    <view class="distance" v-if="m.distance != null">
                        <image class="loc-icon" :src="locIcon" mode="widthFix" />
                        <text class="distance-text">{{ formatDistance(m.distance) }}</text>
                    </view>
                </view>

                <!-- 类目 -->
                <view class="rebate-row">
                    <view class="meta-row">
                        <text class="category" :style="{ color: uiStyle.subTextColor }">
                            {{ m.categoryName || '更多优选' }}
                        </text>
                    </view>
                    <!-- 地址 -->
                    <view class="addr-row" v-if="m.address">
                        <text class="addr" :style="{ color: uiStyle.subTextColor }">
                            {{ m.address }}
                        </text>
                    </view>
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
import { request } from '@/utils/request';
import API from '@/config/api';

export default {
    name: 'ComMerchantList',
    props: {
        componentData: {
            type: Object,
            required: true
        }
    },
    data() {
        const cc = (this.componentData && this.componentData.componentContent) || {};
        const ui = cc.uiStyle || {};
        const ds = cc.dataSource || {};
        // 默认分页参数：page / pageSize，与参考页一致
        const initParams = Object.assign({ page: 1, pageSize: 10, sort: 'distance' }, ds.params || {});

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
                tagColor: ui.tagColor || '#18C46E',
                integralBorder: '1.5px solid #18C46E'
            },
            dataSource: {
                api: API.getShopsBySortType,
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
            size: initParams.pageSize || 10,
            total: 0,
            loading: false,
            finished: false,

            defaultLogo: `${process.env.VUE_APP_STATIC_URL || ''}/static/images/shop_default.png`,
            emptyImg: `${process.env.VUE_APP_STATIC_URL || ''}/static/images/empty.png`,
            locIcon: `${process.env.VUE_APP_STATIC_URL || ''}/static/images/location_pin.png`
        };
    },
    computed: {
        wrapStyle() {
            return {
                padding: `${this.uiStyle.gap}rpx ${this.uiStyle.gap}rpx 0 ${this.uiStyle.gap}rpx`
            };
        },
        cardStyle() {
            return {
                borderRadius: this.uiStyle.cardRadius + 'rpx',
                padding: this.uiStyle.padding + 'rpx',
                marginBottom: this.uiStyle.gap + 'rpx'
            };
        },
        rebateStyle() {
            return {
                color: this.uiStyle.tagColor,
                backgroundColor: this.uiStyle.tagBg,
                border: this.uiStyle.integralBorder
            };
        }
    },
    watch: {
        componentData: {
            deep: true,
            handler() {
                this.resetAndFetch();
            }
        }
    },
    mounted() {
        this.fetchList(true);
    },
    methods: {
        sortKeyToType(key) {
            if (key === 'distance') return 1;
            if (key === 'sales') return 3;
            return 2;
        },
        onChangeSort(key) {
            if (this.curSort === key) return;
            this.curSort = key;
            this.dataSource.params.sort = key;
            this.refresh();
        },
        refresh() {
            const ds = this.componentData?.componentContent?.dataSource || {};
            const params = Object.assign({ page: 1, pageSize: this.size, sort: this.curSort }, ds.params || {});
            this.page = params.page;
            this.size = params.pageSize;
            this.total = 0;
            this.merchants = [];
            this.finished = false;
            this.dataSource.params = params;
            this.fetchList(true);
        },
        async fetchList(reset = false) {
            if (this.loading) return;
            if (!reset && this.finished) return;
            this.loading = true;
            try {
                const baseParams = {
                    page: this.page,
                    pageSize: this.size,
                    sort: this.curSort,
                    type: this.sortKeyToType(this.curSort)
                };
                const params = Object.assign({}, this.dataSource.params || {}, baseParams);
                const res = await request(this.dataSource.api, params, this.dataSource.method);

                const data = res.data || res || {};
                const list = data.list || data.records || data.rows || data.items || data.result || [];
                const total = data.total != null ? data.total : data.count != null ? data.count : Array.isArray(list) ? list.length : 0;

                const normalized = (list || []).map((it) => this.normalizeMerchant(it));
                this.merchants = reset ? normalized : this.merchants.concat(normalized);

                this.total = total;
                const reached = this.merchants.length >= this.total && this.total !== 0;
                this.finished = reached || (Array.isArray(list) && list.length < this.size);
                if (!this.finished) this.page += 1;
            } catch (e) {
                this.finished = true;
            } finally {
                this.loading = false;
            }
        },
        loadMore() {
            this.fetchList(false);
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
                    : raw.integrationRatio != null
                    ? raw.integrationRatio
                    : null;

            return {
                id: raw.id || raw.merchantId || raw.shopId,
                name: raw.name || raw.title || raw.shopName || raw.shopName,
                logo: raw.logo || raw.avatar || raw.image || raw.shopLogo,
                cover: raw.cover || raw.bgImage,
                categoryName: raw.categoryName || raw.category || raw.typeName || (raw.categories && raw.categories.join(' / ')),
                address: raw.address || raw.addr || raw.location,
                distance: raw.distance,
                status: raw.status != null ? raw.status : raw.businessStatus,
                isOpen: raw.isOpen,
                soldCount: raw.soldCount != null ? raw.soldCount : raw.monthlySales != null ? raw.monthlySales : raw.number,
                monthlySales: raw.monthlySales != null ? raw.monthlySales : raw.soldCount != null ? raw.soldCount : raw.number,
                rebateText: rate == null ? '' : this.formatRebate(rate)
            };
        },
        formatRebate(v) {
            const n = Number(v);
            if (isNaN(n)) return String(v);
            const pct = n <= 1 ? n * 100 : n;
            return pct.toFixed(2) + '%';
        },
        formatDistance(v) {
            if (v == null || v === '') return '';
            const n = Number(v);
            if (isNaN(n)) return String(v);
            if (n >= 1000) return (n / 1000).toFixed(2) + 'km';
            return Math.round(n) + 'm';
        },
        businessText(m) {
            const open = m.isOpen === true || m.status === 1 || m.status === 'open' || m.status === 'OPEN' || m.status === '营业中';
            return open ? '营业中' : '休息中';
        },
        handleClick(m) {
            if (m && m.id) {
                try {
                    uni.navigateTo({ url: `/pages/merchant/detail/index?id=${m.id}` });
                } catch (e) {}
            }
        }
    }
};
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
    color: #18c46e;
    font-weight: 600;
}
.tab-underline {
    display: none;
}

/* 卡片 */
.card {
    display: flex;
    flex-direction: row;
    align-items: flex-start;
    background: #ffffff;
    border-radius: 24rpx;
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

/* 标题 + 状态（仅绿色文字） */
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
.status-text-only {
    font-size: 26rpx;
    font-weight: 600;
}

/* 已售 */
.sold-row {
    margin-top: 8rpx;
}
.sold-text {
    color: #9aa0a6;
    font-size: 26rpx;
}

/* 积分胶囊 + 距离 同行 */
.rebate-row {
    margin-top: 12rpx;
    display: flex;
    align-items: center;
    justify-content: space-between;
}
.rebate-chip {
    display: inline-flex;
    align-items: center;
    padding: 4rpx 12rpx;
    border-radius: 999rpx;
}
.rebate-flag {
    font-size: 22rpx;
    color: #ffffff;
    background: #18c46e;
    border-radius: 12rpx;
    padding: 2rpx 8rpx;
    margin-right: 8rpx;
}
.rebate-text {
    font-size: 24rpx;
    font-weight: 600;
    color: #18c46e;
}

/* 类目仅一行显示 */
.meta-row {
    margin-top: 10rpx;
}
.category {
    font-size: 26rpx;
    color: #666666;
}

/* 距离 */
.distance {
    display: flex;
    flex-direction: row;
    align-items: center;
    color: #666666;
}
.loc-icon {
    width: 24rpx;
    height: 24rpx;
    margin-right: 8rpx;
}
.distance-text {
    font-size: 26rpx;
}

/* 地址 */
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

/* 空态与底部 */
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
