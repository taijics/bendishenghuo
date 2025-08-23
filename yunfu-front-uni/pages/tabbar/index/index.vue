<template>
    <div class="hom-page" :style="{ 'padding-top': height + 'px' }">
        <!--    <global-loading />-->
        <u-sticky offset-top="0" h5-nav-height="0" bg-color="#fff">
            <view class="head">
                <!-- #ifdef MP-WEIXIN -->
                <view class="header weiXinBox" :style="{ 'padding-top': topHeight + 'px' }">
                    <view class="topBox" :style="{ height: height + 'px' }">
                        <image class="logo" :src="`${VUE_APP_STATIC_URL}static/assets/img/logo.png`" mode="widthFix"></image>
                    </view>
                </view>
                <view class="wxBtnBg" :style="{ 'padding-top': topHeight + height + 10 + 'px' }">
                    <view class="weiXinBoxBtn" @click="searchPro">
                        <image class="search-icon" :src="`${VUE_APP_STATIC_URL}static/img/search.png`" mode="widthFix"></image>
                        <text>请输入您想要的宝贝</text>
                    </view>
                </view>
                <!-- #endif -->
                <!-- #ifdef H5 || APP-PLUS -->
                <view class="header">
                    <view class="topBox topWap">
                        <image class="logo" :src="`${VUE_APP_STATIC_URL}static/assets/img/logo.png`" mode="widthFix"></image>
                        <view class="search-btn" @click="searchPro">
                            <image class="search-icon" :src="`${VUE_APP_STATIC_URL}static/img/search.png`" mode="widthFix"></image>
                        </view>
                    </view>
                </view>
                <!-- #endif -->
                <category-list @tabChange="tabChange"></category-list>
            </view>
        </u-sticky>
        <canvas-page ref="canvasPageRef" :componentsData="componentsData" v-if="activeTab == 0" :terminal="terminal" :typeId="1"></canvas-page>
        <category-show ref="categoryShowRef" v-else :categoryid="categoryid"></category-show>
        <ad-window ref="adWindowRef" :triggerCondition="1"></ad-window>
        <tui-modal :show="privacyShow" :custom="true" :fadein="true">
            <view class="Put-box1">
                <view class="text-align fs34 fs-bold">协议与隐私政策</view>
                <p class="mar-top-20">欢迎来到cereshop！我们根据最新的法律、法规、监管政策要求，更新了cereshop隐私政策。</p>
                <view class="flex-display flex-sp-between">
                    <view class="btn submit" @click="privacyShow = false">同意</view>
                </view>
            </view>
        </tui-modal>
    </div>
</template>

<script setup>
import { ref, nextTick } from 'vue';
import { onLoad, onReachBottom, onShow } from '@dcloudio/uni-app';
import tuiModal from '@/components/modal/modal.vue';
import AdWindow from '@/components/adWindow';
import API from '@/config/api';
import { request } from '@/utils/request';
import api from '@/components/canvasShow/config/api';
import CategoryList from '@/components/basics/categoryList.vue';
import CategoryShow from '@/components/basics/categoryShow.vue';
import comHeader from '@/components/canvasShow/basics/header/app';
import canvasPage from '@/components/canvasShow/canvasShowPage.vue';
import { VUE_APP_STATIC_URL } from '@/config/api';

const terminal = ref(API.terminal);
const activeTab = ref(0);
const categoryid = ref(0);
const topHeight = ref(0);
const height = ref(0);
const privacyShow = ref(false);
const componentsData = ref([]);
const typeId = ref(1);
const categoryShowRef = ref();
const adWindowRef = ref();

onReachBottom(() => {
    HandleLoadMoreProduct();
});

onLoad(() => {
    if (!uni.getStorageSync('storage_key')) {
        // #ifdef APP-PLUS
        privacyShow.value = true;
        // #endif
    }
    nextTick(() => {
        canvasGet();
        adWindowRef.value.getAd();
    });
});

onShow(() => {
    // #ifdef MP-WEIXIN || MP-BAIDU || MP-TOUTIAO || MP-QQ
    let menuButtonInfo = uni.getMenuButtonBoundingClientRect();
    topHeight.value = menuButtonInfo.top;
    height.value = menuButtonInfo.height;
    // #endif
});

// 读取画布
function canvasGet() {
    var apiUrl = api.getCanvas + '?terminal=' + terminal.value + '&type=' + typeId.value;
    // if (shopId.value) {
    //   apiUrl += '&shopId=' + shopId.value
    // }
    let params = {
        url: apiUrl,
        method: 'GET'
    };
    // uni.showLoading({
    //   mask: true,
    //   title: '加载中...',
    // })
    request(apiUrl, {}, 'GET')
        .then((res) => {
            if (JSON.stringify(res.data) !== '{}') {
                componentsData.value = JSON.parse(res.data.json);
            }
            uni.hideLoading();
        })
        .catch((err) => {
            uni.hideLoading();
            throw Error(err);
        });
}
// 分享到朋友圈
function onShareTimeline() {
    return {
        title: miniHomeRemark.value,
        imageUrl: miniHomeImg.value,
        path: 'pages/tabbar/index/index'
    };
}
// 分享好友
function onShareAppMessage() {
    return {
        title: miniHomeRemark.value,
        imageUrl: miniHomeImg.value,
        path: 'pages/tabbar/index/index'
    };
}

const canvasPageRef = ref();
/**
 * 请求非首页的子组件的下一页
 * */
function HandleLoadMoreProduct() {
    if (activeTab.value != 0) {
        let pitchOnPage = categoryShowRef.value;
        if (pitchOnPage.total !== 0 && pitchOnPage.productList.length < pitchOnPage.total) {
            pitchOnPage.page++;
            pitchOnPage.getData();
        }
    } else {
        // 首页画布
        const lastComponent = componentsData.value.at(-1);
        if (lastComponent && lastComponent.type === 'productList' && lastComponent.componentContent.openBottomLoad) {
            console.log('商品组件触底加载', canvasPageRef.value);
            canvasPageRef.value && canvasPageRef.value.loadMore();
        }
    }
}
/**
 * 清空非首页的子组件商品数据
 * 回滚请求参数到起始页
 * */
function HandleCleanActiveTabProduct() {
    nextTick(() => {
        if (categoryShowRef.value) {
            let pitchOnPage = categoryShowRef.value;
            pitchOnPage.total = 0;
            pitchOnPage.page = 1;
            pitchOnPage.productList = [{}, {}, {}, {}, {}, {}, {}, {}];
            pitchOnPage.getData(1);
        }
    });
}
function tabChange(index, id) {
    let categoryLevel = 1;
    HandleCleanActiveTabProduct();
    activeTab.value = index;
    categoryid.value = id;
    uni.pageScrollTo({
        scrollTop: 0
    });
}
// 查询产品
function searchPro(key, type) {
    uni.navigateTo({
        url: `/pages_category_page1/search/index/index`
    });
}
</script>

<style lang="scss" scoped>
.hom-page {
    margin-top: calc(20rpx + var(--status-bar-height));
}
.head {
    background: #fff;
}
.header {
    background: #fff;
    .toLive {
        height: 40px;
        color: #fff;
        background-color: #333;
    }

    .topBox {
        display: flex;
        align-items: center;
        justify-content: space-between;
        width: 100%;
    }

    .logo {
        width: 280rpx;
        height: 42rpx;
        margin-top: -40rpx;
        // margin-left: 30rpx;
    }

    .search-btn {
        height: 66rpx;
        background: rgba(255, 255, 255, 1);
        border-radius: 33rpx;
        display: flex;
        flex-direction: row;
        align-items: center;
        margin-right: 30rpx;

        .search-icon {
            width: 60rpx;
            height: 60rpx;
            // margin-left: 33rpx;
        }

        .search-word {
            font-size: 26rpx;
            font-weight: 400;
            color: rgba(153, 153, 153, 1);
            margin-left: 10rpx;
        }
    }

    .tabs-nav-warp {
        margin-top: 20rpx;
        padding: 0 30rpx;
    }

    .tabs-nav {
        .ul {
            display: flex;

            .li {
                flex: 1 0 auto;
                margin-left: 36rpx;
                font-size: 30rpx;
                color: #999999;
                position: relative;
                padding-bottom: 18rpx;

                &:first-child {
                    margin-left: 0;
                }

                &.on {
                    &:after {
                        content: '';
                        width: 100%;
                        height: 4rpx;
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

.weiXinBox {
    width: 100%;
    position: fixed;
    background: #ffffff;
    z-index: 99;
}

.wxBtnBg {
    padding: 0 20rpx;

    .weiXinBoxBtn {
        display: flex;
        align-items: center;
        padding: 10rpx 0 10rpx 15rpx;
        width: 100%;
        background: #f3f4f5;
        opacity: 1;

        .search-icon {
            width: 50rpx;
            height: 50rpx;
            margin-right: 20rpx;
        }

        text {
            color: #999999;
        }
    }
}

.terminal1 {
    .header {
        .topBox {
            // justify-content: left;

            .search-btn {
                .search-icon {
                    margin-left: 0rpx;
                }
            }
        }
    }
}

.topTitle {
    display: flex;
    justify-content: center;
    align-items: center;
    height: 100rpx;
    width: 100%;

    .topText {
        text-align: center;
        color: #000000;
        font-size: 38rpx;
        font-weight: bold;
    }
}

.topWap {
    //padding-top: 60rpx;

    .logo {
        margin-top: 0 !important;
    }
}

.terminal2 {
}

.terminal3 {
}

// 触底样式
.reachBottom {
    margin-top: 30rpx;
    display: flex;
    flex-direction: column;
    align-items: center;

    .reach-icon {
        width: 150rpx;
        height: 150rpx;
    }

    .reach-text {
        margin: 20rpx 0;
        color: #cccccc;
    }
}

.Put-box1 {
    .btn {
        text-align: center;
        margin-top: 40rpx;
        border: 1px solid #333333;
        height: 80upx;
        line-height: 80upx;
        width: 100%;
        color: #333333;
    }

    .submit {
        background-color: #333333;
        color: #ffebc4;
    }
}
</style>
