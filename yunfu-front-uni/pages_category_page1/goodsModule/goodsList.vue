<template>
  <view class="container">
    <!-- 商品列表 -->
    <view class="flex-items-plus flex-row search">
      <view class="searchBg">
        <view class="searchImg-box flex-items-plus">
          <image
              class="searchImg"
              :src="`${VUE_APP_STATIC_URL}static/images/searchImg.png`"
          ></image>
          <input
              class="search-box"
              v-model="paramsConfig.keyWord"
              placeholder-class="searchboxPlace"
              placeholder="请输入您想要的宝贝"
          />
        </view>
        <label
            class="mar-left-40 fs28"
            @click="getSearchList()"
        >搜索</label>
      </view>
    </view>
    <view class="tabsbox">
      <u-tabs :list="collectionTypeList" bar-width="60" :bold="false" active-color="#333333"
              inactive-color="#CCCCCC" :is-scroll="false" :current="collectionTypeFlag"
              @change="collectionTypeActive"></u-tabs>
    </view>
    <!--    商品-->
    <view v-if="collectionTypeFlag == 0">
      <view class="shop-list-nav">
        <view class="mlr-20">
          <view
              class="nav-item-sort"
              @click="sortTap(1)"
          >
            <text
                class="nav-title"
                :class="{'active' : sortIndex === 1}"
            >默认
            </text>
          </view>
          <view
              class="nav-item-sort"
              @click="sortTap(2)"
          >
            <text
                class="nav-title"
                :class="{'active' : sortIndex === 2}"
            >价格
            </text>
            <view class="r">
              <view
                  class="arrowUp"
                  :class="{activeUp: paramsConfig.sortType === 1}"
              ></view>
              <view
                  class="arrowDown"
                  :class="{activeDown: paramsConfig.sortType === 2}"
              ></view>
            </view>
          </view>
          <view
              class="nav-item-sort"
              @click="sortTap(3)"
          >
            <text
                class="nav-title"
                :class="{'active' : sortIndex === 3}"
            >销量
            </text>
            <view class="r">
              <view
                  class="arrowUp"
                  :class="{activeUp: paramsConfig.sortVolume === 1}"
              ></view>
              <view
                  class="arrowDown"
                  :class="{activeDown: paramsConfig.sortVolume === 2}"
              ></view>
            </view>
          </view>
        </view>
      </view>
      <!-- 骨架屏 -->
      <u-skeleton
          el-color="#efefef"
          bg-color="#fff"
          :loading="loading && isFirstComeIn"
          :animation="true"
      ></u-skeleton>
      <view class="listBox u-skeleton">
        <view
            v-for="(item, index) in list"
            :key="index"
            class="goodsDetails-box flex-display flex-column"
            @click="jumpToDetail(item)"
        >
          <view class="spikeList goodsDetails ">
            <view class="listItem">
              <view class="itemBox">
                <image
                    :src="item.image"
                    class="pic-img default-img u-skeleton-rect"
                />
              </view>
              <view class="itemInfo">
                <p class="u-skeleton-rect">{{ item.productName }}</p>
                <view
                    class="number"
                    v-if="item.number != null"
                >
                  <view class="numText u-skeleton-rect">已售{{ item.number }}件</view>
                  <view
                      class="numText u-skeleton-rect"
                      v-if="item.total !==0 && item.activityType !== 0"
                  >限量{{ item.total }}件
                  </view>
                </view>
                <view v-else class="skeleton-box u-skeleton-rect"></view>
                <view class="flex-row-plus flex-item mar-top-30">
                  <image
                      v-if="item.activityType!==0"
                      class="iconImg u-skeleton-rect"
                      :src="getProductTypeIcon(item.activityType)"
                  />
                  <view class="font-color-C83732 flex-row-plus">
                    <b>￥</b>
                    <label class="fs28">{{ item.price }}</label>
                  </view>
                  <view class="discountsPriceLine font-color-999 u-skeleton-rect">¥{{ item.originalPrice }}</view>
                </view>
                <view class="flex-display flex-sp-between flex-row mar-top-20 flex-items shopName">
                  <label class="fs22 font-color-FFEBC4">{{ item.shopName }}</label>
                </view>
              </view>
            </view>
          </view>
        </view>
      </view>
    </view>
    <!--    店铺-->
    <view v-if="collectionTypeFlag == 1">
      <view>
        <!-- 骨架屏 -->
        <u-skeleton
            el-color="#efefef"
            bg-color="#f7f7f7"
            :loading="loading && isFirstComeIn"
            :animation="true"
        ></u-skeleton>
        <view class="swipe-box swipeBox u-skeleton">
          <view class="shopBox" v-for="(item, index) in storeCollect" :key="item.shopId" :index="index">
            <view class="item wid flex-row-plus flex-display">
              <view class="infoCent">
                <view class="flex-row-plus flex-sp-between flex-items-plus wid">
                  <view class="flex-display flex-items flex-row pad-topbot-10 wid">
                    <image class="head-img u-skeleton-fillet" mode="aspectFill" :src="item.shopLogo" />
                    <!-- 此层wrap在此为必写的，否则可能会出现标题定位错误 -->
                    <view class="flex-display flex-sp-between wid">
                      <view class="title-wrap mar-left-20">
                        <view>
                          <view class="title u-line-2 shopName">
                            <text class="u-skeleton-rect">{{ item.shopName }}</text>
                          </view>
                        </view>
                        <!--                      <text class="font-color-CCC fs24">{{item.person}}人关注</text>-->
                        <view class="font-color-999 fs24 location u-skeleton-rect"><text class="location-text">所在地：</text>{{item.shopAdress}}</view>
                      </view>
                      <view class="toStore flex-items-plus fs24 u-skeleton-rect" @click="toStoreClick(item.shopId)">
                        进入店铺
                        <image :src="`${VUE_APP_STATIC_URL}static/images/arrowR.png`"></image>
                      </view>
                    </view>
                  </view>
                </view>
                <view class="shopImgBox"  v-if="item.skus.length>0">
                  <view class="itemImgBox u-skeleton-fillet" v-for="(sItem, sIndex) of item.skus.slice(0, 4)"
                        :key="sIndex"
                        @click.stop="goodsDateils(sItem.shopId,sItem.productId,sItem.skuId)">
                    <image :src="sItem.image" class="pic-img default-img"></image>
                  </view>
                </view>
              </view>
            </view>
          </view>
        </view>
      </view>
    </view>


    <!-- 搜索为空 -->
    <view
        v-if="listEmpty"
        class="emptyCart-box flex-items-plus flex-column"
    >
      <image
          class="emptyCart-img"
          :src="`${VUE_APP_STATIC_URL}static/images/searchEmpty.png`"
      ></image>
      <label class="font-color-999 fs26 mar-top-30">{{collectionTypeFlag === 0 ? '搜索不到你要找的宝贝呢' : '搜索不到你要找的店铺呢' }}</label>
      <label class="font-color-999 fs26 mar-top-10">换个词试试吧～</label>
    </view>
    <slide-loading />
    <view
        class="reachBottom"
        v-if="noMore && topLeft > 400"
    >
      <image
          class="reach-icon"
          :src="`${VUE_APP_STATIC_URL}static/img/reachBottom.png`"
          mode="widthFix"
      ></image>
      <text class="reach-text">这里到底了哦~~</text>
    </view>
    <!-- 回到顶部 -->
    <ReturnTop :returnTopFlag="returnTopFlag" />
  </view>
</template>


<script setup>
import { request } from '@/utils/request'
import API from "../../config/api";
import {onLoad, onPageScroll, onReachBottom} from '@dcloudio/uni-app';
import { ref } from "vue";
import { VUE_APP_STATIC_URL } from "@/config/api";

const loading = ref(false); // 数据是否正在加载
const isFirstComeIn = ref(true); // 是否是首次进入页面（骨架屏）
const paramsConfig = ref({
  page:1,
  pageSize:20,
  total:0,
  keyWord:'',
  sortType:0, // 价格排序条件
  sortVolume:0 // 销量排序条件
})
const topLeft = ref(0)
const sortIndex = ref(1); // 当前选中了哪个进行排序
const list = ref(Array.from(new Array(9).keys()).map(item => ({}))); // 数据
const loadOver = ref(0); // 是否加载完毕 0否1是
const listEmpty = ref(false)
const returnTopFlag = ref(false); // 返回顶部显示隐藏
const noMore = ref(false)
const collectionTypeList = ref([{
  name: '商品'
}, {
  name: '店铺'
}])
const collectionTypeFlag = ref(0)
// 商品和店铺收藏数据初始化
const createEmptyItems = (count, itemTemplate = {}) => Array.from({ length: count }, () => ({ ...itemTemplate }));
const productCollect = ref(createEmptyItems(8));
const storeCollect = ref(createEmptyItems(7, { skus: createEmptyItems(4) }));

/**
 * 排序
 * @param index 1默认 2价格 3销量
 */
function sortTap(index) {
  resetPage()
  sortIndex.value = index
  const selectObj = {
    0:1,
    1:2,
    2:0
  }
  // 默认排序
  if (index === 1) {
    paramsConfig.value.sortType = paramsConfig.value.sortVolume = 0
  }
  // 价格排序
  if (index === 2) {
    paramsConfig.value.sortVolume = 0
    paramsConfig.value.sortType = selectObj[paramsConfig.value.sortType]
  }
  // 销量排序
  if (index === 3) {
    paramsConfig.value.sortType = 0
    paramsConfig.value.sortVolume = selectObj[paramsConfig.value.sortVolume]
  }
  getProductList(1)
}

/**
 * 重新设置分页
 */
function resetPage(){
  loadOver.value = 0
  isFirstComeIn.value = true
  paramsConfig.value.total = 0
  paramsConfig.value.page = 1
  storeCollect.value = createEmptyItems(7, { skus: createEmptyItems(4) })
  list.value = Array.from(new Array(9).keys()).map(item => ({}))
}

/**
 * 搜索
 * @param status 0非首次 1首次
 */
function getProductList(status) {
  loading.value = true
  if (status === 1) {
    resetPage()
  }
  if (comeInType === 1) {
    getProductListByClassify()
  } else {
    getProductListBySearch()
  }
}

function getSearchList() {
  if (collectionTypeFlag.value == 0) {
    getProductList(1)
  } else {
    resetPage()
    getStoreList()
  }
}

/**
 * 通过分类查询商品
 */
async function getProductListByClassify(){
  const res = await request(API.GetClaasifyProducts, {
    classifyId: classifyId,
    classifyLevel: classifyLevel,
    type: paramsConfig.value.sortType,
    volume:paramsConfig.value.sortVolume,
    productName: paramsConfig.value.keyWord,
    page: paramsConfig.value.page,
    pageSize: paramsConfig.value.pageSize
  }, 'GET')
  handleAfterGetListData(res.data)
}

/**
 * 通过查询查询商品
 * @returns {Promise<void>}
 */
async function getProductListBySearch(){
  const res = await request(API.GgetSearchProducts, {
    search: paramsConfig.value.keyWord,
    type: paramsConfig.value.sortType,
    volume:paramsConfig.value.sortVolume,
    page: paramsConfig.value.page,
    pageSize: paramsConfig.value.pageSize
  }, 'GET')
  handleAfterGetListData(res.data)
}

/**
 * 处理数据加载完毕后逻辑
 * @param responseData response数据
 */
function handleAfterGetListData(responseData){
  isFirstComeIn.value = loading.value = false
  list.value = list.value.concat(responseData.list).filter(item => JSON.stringify(item) !== '{}')
  paramsConfig.value.total = responseData.total
  listEmpty.value = list.value.length === 0
  if (list.value.length >= responseData.total) {
    noMore.value = true
  }
  // 是否加载完毕
  if (paramsConfig.value.total === list.value.length) {
    loadOver.value = 1
  }
}

/**
 * 去商品详情
 * @param item
 */
function jumpToDetail({shopId,productId,skuId}){
  uni.navigateTo({
    url: `goodsDetails?shopId=${shopId}&productId=${productId}&skuId=${skuId}`
  })
}

/**
 * 根据活动类型获取活动icon
 * @param activityType
 * @returns {*}
 */
function getProductTypeIcon(activityType){
  const iconList = {
    1: `${VUE_APP_STATIC_URL}static/images/groupBuyIcon.png`,
    2: `${VUE_APP_STATIC_URL}static/images/spikeIcon.png`,
    3: `${VUE_APP_STATIC_URL}static/images/discountListIcon.png`,
    4: `${VUE_APP_STATIC_URL}static/images/spikeIcon.png`,
    5: `${VUE_APP_STATIC_URL}static/images/discountListIcon.png`,
    7: `${VUE_APP_STATIC_URL}static/images/holidaySaleIcon.png`,
    9: `${VUE_APP_STATIC_URL}static/images/memberCenterIcon.png`
  }
  return iconList[activityType]
}

// ========================================== 生命周期函数 =========================================================
let comeInType = 0 // 进入页面类型 0普通1分类
let classifyId = undefined // 如果是分类进入，赋值分类ID进行查询
let classifyLevel = undefined // 如果是分类进入，赋值分类ID进行查询
onLoad((option) => {
  paramsConfig.value.keyWord = option.keyWord ?? ''
  comeInType = option.category3Id?1:0
  classifyId = option.category3Id ?? undefined
  classifyLevel = option.classifyLevel ?? null
   getProductList(1)
})
onReachBottom(() => {
  if (noMore.value) {
    uni.stopPullDownRefresh()
  } else {
    paramsConfig.value.page++
    if (collectionTypeFlag.value == 0) {
      getProductList(0)
    } else {
      getStoreList()
    }
  }
})


function collectionTypeActive(index) {
  collectionTypeFlag.value = index
  isFirstComeIn.value = true
  noMore.value = false
  if (index == 0) {
    getProductList(1)
  } else if (index == 1) {
    storeCollect.value = createEmptyItems(7, { skus: createEmptyItems(4) });
    paramsConfig.value.page = 1
    getStoreList()
  }
}
function getStoreList() {
  loading.value = true
  request(API.ShopSearch, {
        page: paramsConfig.value.page,
        pageSize: paramsConfig.value.pageSize,
        search: paramsConfig.value.keyWord
      },
      'GET').then(res => {
    storeCollect.value = storeCollect.value
        .concat(res.data.list)
        .filter(item => {
          if (Array.isArray(item.skus) && item.skus.length === 4) {
            // 检查每个 skus 的对象是否为空对象
            const isEveryItemEmpty = item.skus.every(subItem => Object.keys(subItem).length === 0);
            // 只有当所有对象都为空时，才过滤掉当前这项
            return !isEveryItemEmpty;
          }
          return true;
        });
    paramsConfig.value.total = res.data.total
    listEmpty.value = storeCollect.value.length === 0
    isFirstComeIn.value = false
    if (storeCollect.value.length >= res.data.total) {
      noMore.value = true
    }
    // 是否加载完毕
    if (paramsConfig.value.total === storeCollect.value.length) {
      loadOver.value = 1
    }
  }).catch(res => {
    uni.showToast({
      title: '失败',
      icon: "none"
    })
    throw Error(res)
  })
}
//去店铺
function toStoreClick(storeId) {
  uni.navigateTo({
    url: '../../pages_category_page1/store/index?storeId=' + storeId
  })
}

//商品详情
function goodsDateils(shopId, productId, skuId) {
  uni.navigateTo({
    url: '/pages_category_page1/goodsModule/goodsDetails?shopId=' + shopId + '&productId=' +
        productId + '&skuId=' + skuId
  })
}

onPageScroll(e => {
  returnTopFlag.value = e.scrollTop > 600;
  topLeft.value = e.scrollTop
})
</script>

<style
    lang="scss"
    scoped
>
page {
  background: #f8f8f8;
}
.tabsbox {
  position: relative;
  z-index: 999;
}

input {
  padding-left: 80upx;
}

.container {
  height: 100%;
  background: #f8f8f8;

  .search {
    padding: 20rpx;
    background: #FFFFFF;
    border-top: 2rpx solid #F3F4F5;
    position: relative;
    z-index: 2;
  }

  .searchImg-box {
    position: relative;
  }

  .emptyCart-box {
    position: absolute;
    top: 0;
    bottom: 0;
    left: 0;
    right: 0;
    margin: auto;

    .emptyCart-img {
      width: 113upx;
      height: 98upx;
    }
  }

  .searchBg {
    width: 100%;
    display: flex;
    background-color: #F7F7F7;
    align-items: center;
    height: 78rpx;
    justify-content: space-between;
    padding: 0 20rpx;

    label {
      font-weight: 400;
      color: #333333;
    }
  }

  .searchImg {
    width: 50upx;
    height: 50upx;
    position: absolute;
    left: 0upx;
  }

  .search-box {
    width: 400upx;
    height: 66upx;
  }

  .searchboxPlace {
    font-size: 26upx;
    color: #A9A9A9;
    padding-right: 30upx;
  }

  .searchClose-icon {
    z-index: 999;
    width: 40upx;
    height: 40upx;
    margin-left: -50upx;
  }

  .promotion618 {
    width: 130upx;
    height: 30upx;
  }

  .goodsDetails-box {
    background: #FFFFFF;
    margin-top: 20rpx;
    box-sizing: border-box;

    .spikeList {
      border-bottom: 1upx solid #EDEDED;
      padding-top: 30rpx;
      padding-bottom: 30upx;
      position: relative;

      .listItem {
        display: flex;
        border-bottom: 1upx solid #EEEEEE;
        padding-left: 30rpx;

        .iconImg {
          width: 58rpx;
          height: 36rpx;
        }

        &:last-child {
          border-bottom: none;
        }

        .itemBox {
          width: 220upx;
          height: 220upx;
          margin-right: 30upx;

          image {
            width: 100%;
            height: 100%;
          }
        }

        .itemInfo {
          flex: 1;
          .skeleton-box {
            width: 100rpx;
            height: 40rpx;
          }
          p {
            font-size: 26upx;
            color: #333333;
            line-height: 40upx;
            margin-bottom: 30upx;
            overflow: hidden;
            text-overflow: ellipsis;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            line-clamp: 2;
            -webkit-box-orient: vertical;
            min-height: 40rpx;
          }

          .number {
            color: #999999;
            font-size: 26upx;
            display: flex;
            align-items: center;

            .numText {
              padding: 0 10rpx;
              height: 40rpx;
              line-height: 40rpx;
              border: 2rpx solid #E4E5E6;
              color: #C5AA7B;
              font-size: 20rpx;
              margin-right: 10rpx;
            }
          }
          .discountsPriceLine {
            min-width: 60rpx;
            padding-left: 30rpx;
          }
        }
      }

      .shopName {
        position: absolute;
        left: 0;
        top: 0;
        height: 50rpx;
        background: #333333;
        opacity: 1;
        border-radius: 0 20rpx 20rpx 0;
        padding: 10rpx 15rpx;
      }
    }
  }

  .listBox {
    padding: 0 24rpx;
    box-sizing: border-box;

    .usersBox {
      margin-top: 20rpx;

      label {
        padding: 10rpx;
        border: 2rpx solid #E4E5E6;
      }
    }
  }
}

.shop-list-nav {
  position: relative;
  z-index: 9999;
  background: #fff;

  .mlr-20 {
    margin: 0 20rpx;
    display: flex;
    flex-direction: row;
    align-items: center;
    height: 80rpx;
    line-height: 76rpx;
  }
}

.nav-item {
  flex: 1;
  font-size: 30rpx;
  color: #666;
  display: flex;
  flex-direction: column;
  align-items: center;
  height: 80rpx;
  line-height: 76rpx;
}

.nav-title {
}

.nav-item.active {
  color: #C5AA7B;
}

.nav-item .line {
  display: inline-block;
  width: 80rpx;
  height: 4rpx;
  background: #fff;
  border-radius: 2rpx;
}

.nav-item.active .line {
  background: #C5AA7B;
}

.nav-item.padd-l {
  padding-left: 20%;
  box-sizing: border-box;
}

.active {
  color: #C5AA7B;
}

.nav-item.padd-r {
  padding-right: 20%;
  box-sizing: border-box;
}

.nav-item-sort {
  flex: 1;
  font-size: 24rpx;
  color: #222;
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: center;
  height: 80rpx;
  line-height: 80rpx;
}

.nav-item-sort .r {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  margin-left: 5rpx;

  .arrowDown {
    width: 0;
    height: 0;
    border-width: 10rpx;
    border-style: solid;
    border-color: #CCCCCC transparent transparent transparent;
    margin-top: 2rpx;
  }

  .arrowUp {
    margin-bottom: 2rpx;
    width: 0;
    height: 0;
    border-width: 10rpx;
    border-style: solid;
    border-color: transparent transparent #CCCCCC transparent;
  }

  .activeDown {
    border-color: #C5AA7B transparent transparent transparent;
  }

  .activeUp {
    border-color: transparent transparent #C5AA7B transparent;
  }
}

//.nav-item-sort .r .arrow-img {
//  width: 32rpx;
//  height: 32rpx;
//  padding: 7rpx;
//  box-sizing: border-box;
//}
//// #ifdef MP-ALIPAY
//.nav-item-sort .r .arrow-img {
//  width: 16rpx;
//  height: 16rpx;
//  padding: 4rpx;
//  box-sizing: border-box;
//}
.search {
  padding-top: 20rpx;
}
// #endif
.tabsbox ::v-deep #u-tab-item-0 {
  position: relative;
}

.tabsbox ::v-deep .u-tab-bar {
  background-color: #c5aa7b !important;
}

.shopBox {
  margin-bottom: 20rpx;
}
.swipe-box {
  padding: 0 20rpx;
  .shopImgBox {
    display: flex;
    margin-left: 90rpx;
    padding-bottom: 20rpx;
    margin-top: 20rpx;
    .itemImgBox {
      margin-right: 15rpx;
      margin-left: 5rpx;

      image {
        width: 120rpx;
        height: 120rpx;
        border: 2rpx solid #F3F4F5;
      }
    }
  }
  .item {
    display: flex;

    .infoCent {
      padding: 20rpx;
      width: 100%;
      .title-wrap {
        width: 350rpx;
      }
      .location {
        display: -webkit-box;
        -webkit-box-orient: vertical;
        -webkit-line-clamp: 3;
        overflow: hidden;
        padding-right: 10rpx;
        .location-text {
          color: #606266;
          font-size: 24rpx;
        }
      }
    }
  }
  .head-img {
    width: 80rpx;
    flex: 0 0 80rpx;
    height: 80rpx;
    border-radius: 50%;
  }

  .title {
    text-align: left;
    font-size: 28rpx;
    color: $u-content-color;
    height: 165rpx;
    padding-right: 20rpx;
  }

  .shopName {
    height: auto;
    overflow: hidden;
    white-space: nowrap;
    text-overflow: ellipsis;
    width: 340rpx;
    margin-bottom: 10rpx;
    text {
      min-width: 200rpx;
      min-height: 40rpx;
      display: inline-block;
    }
  }

  .cart-select-img {
    width: 40upx;
    height: 40upx;
    margin: 0upx 30upx 0upx;
    box-sizing: border-box;
  }

  .toStore {
    width: 80px;
    color: #FFEBC4;
    padding: 0rpx 5rpx;
    height: 52rpx;
    background: #333333;
    image {
      width: 10rpx;
      height: 18rpx;
      margin-left: 10rpx;
    }
  }

  .shopBox {
    margin-top: 20rpx;
    .item {
      background: #FFFFFF;
    }
  }
}
</style>
