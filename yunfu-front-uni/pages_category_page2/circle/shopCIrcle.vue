<template>
  <view class="circle-page">
    <global-loading />
    <Header
        circle-back
        ref="headerRef"
        :propUp="false"
        @animation="getScrollTransparency"
        :distance="topHeight"
        :scroll-top="scrollTop">
    </Header>
    <view class="shop-circle">
      <view class="shop-circle-box">
        <view class="circle-sticky" :style="{top: topHeight + 'rpx'}" :class="{reveal: opacity === 1}">
<!--          <u-sticky-->
<!--              bg-color="#fff"-->
<!--              :offset-top="topHeight"-->
<!--              :customNavHeight="topHeight"-->
<!--              h5-nav-height="0"-->
<!--          >-->
            <view v-if="opacity === 1">
              <view class="circle-header">
                <view class="left-arrow" @click="back">
                  <image :src="`${VUE_APP_STATIC_URL}static/images/back.png`" class="back" @click="back"/>
                </view>
                <view class="avatar">
                  <image :src="shopInfo.avatar" alt="" class="avatar-img"/>
                </view>
                <view class="username">{{shopInfo.name}}</view>
              </view>
            </view>
            <view v-else>
              <view class="circle-top">
                <view class="l-p">
                  <image :src="shopInfo.avatar" class="avatar"/>
                  <view class="u-box">
                    <view class="text">{{shopInfo.name}}</view>
                    <view class="text" @click="goShop(shopInfo.shopId)">
                      进入店铺
                      <image class="arrow" :src="`${VUE_APP_STATIC_URL}static/images/arrowRight.png`"></image>
                    </view>
                  </view>
                </view>
                <view class="r-p" v-if="!shopInfo.isCollect" @click="collectShop">关注ta</view>
              </view>
            </view>
            <u-tabs
                class="tabs"
                disabled
                :list="categoryList"
                :is-scroll="false"
                active-color="#333333"
                :current="tabCurrentType"
                inactiveColor="#999999"
                @change="handleTabChange"
            />
<!--          </u-sticky>-->
        </view>
        <view class="circle-list">
          <view class="list-box" v-for="it in cirCleList" :key="it.type">
            <view
                class="circle-item"
                v-for="item in it.list"
            >
              <view class="img-box" @click.stop="jumpTo(item, 'info')">
                <img class="item-img" :src="item.fileUrl || item.cover">
                <img
                    v-if="item.fileType===2"
                    class="play-icon"
                    :src="`${VUE_APP_STATIC_URL}static/img/circle/play.png`"
                />
              </view>
              <view class="t-box">
                <view class="t-title" @click.stop="jumpTo(item, 'info')">{{item.remark}}</view>
                <view class="b-box">
                  <view class="l-p" @click.stop="jumpTo(item, 'shop')">
                    <img class="shop-img" :src="item.avatar"/>
                    <text>{{item.name}}</text>
                  </view>
                  <view class="r-p">
                    <image
                        :src="`${VUE_APP_STATIC_URL}static/img/circle/like${item.likeStatus?'_active':''}.png`"
                        class="icon-img"
                        @click="handleLike(item)"/>
                    <text>{{item.likeCount}}</text>
                  </view>
                </view>
              </view>
            </view>
          </view>
        </view>
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
        <view v-if="isShow" class="emptyCart-box flex-items-plus flex-column">
          <image class="emptyCart-img" :src="`${VUE_APP_STATIC_URL}static/img/bgnull.png`" mode="widthFix" />
          <label class="font-color-999 fs26 mar-top-30">这里空空如也~</label>
        </view>
      </view>
    </view>
  </view>
</template>

<script setup>
import {ref, onMounted, onUnmounted, toRefs, watch, inject, computed} from 'vue';
import { onLoad, onReachBottom, onShow, onPageScroll } from "@dcloudio/uni-app";
import { useScroll } from "@/hooks/useScroll";
import Header from "./component/Header.vue";
import API from "@/config/api";
import {request} from "@/utils/request"
import { VUE_APP_STATIC_URL } from "@/config/api";
import Skeleton from "../../components/Skeleton/index.vue";
const $jump = inject('$jump')
const topHeight = ref(0)
const height = ref(0)
const isShow = ref(false);
const headerRef = ref();
const categoryList = ref([]);
const shopId = ref(0);
const shopInfo = ref({});
const recommendId = ref(0);
const tabCurrentType = ref(0)// 选中tab的索引
const topLeft = ref(0); // 无更多数据显示距离
const returnTopFlag = ref(false); // 返回顶部显示隐藏
const loading = ref(false);
const noMore = ref(false); // 没有更多数据显示隐藏
const isFirstComeIn = ref(true);
const total = ref(0); // 订单总数据
const ifEmpty = ref(false); // 是否为空
const defaultCircle = {
  list: [],
  total: 0,
  categoryId: '1',
  shopId: shopId.value
}
const cirCleList = ref([])
const circleData = ref({...defaultCircle});
const defaultPage = {
  page: 1,
  pageSize: 10
}
const pageInfo = ref({...defaultPage})
const info = ref({
  fileUrl: [],
  products: []
});
const init = async() => {
  circleData.value =  {...defaultCircle};
  categoryList.value = [
    {fileType: '1', name: '图文'},
    {fileType: '2', name: '视频'},
  ];
  getCircle();
}


onLoad(async(options)=>{
  // #ifdef MP-WEIXIN || MP-BAIDU || MP-TOUTIAO || MP-QQ
  let menuButtonInfo = uni.getMenuButtonBoundingClientRect()
  topHeight.value = menuButtonInfo.top
  // #endif
  // #ifdef APP
  topHeight.value = 50
  // #endif
  shopId.value = options.shopId;
  recommendId.value = options.recommendId;
  getRecommendInfo();
})

// 关注店铺
const collectShop = async() => {
  const {code} = await request(API.CollectShop, {shopId: shopId.value}, 'POST');
  if(code) getRecommendInfo();
}

const getRecommendInfo = async() => {
  const {code, data} = await request(API.CircleInfo, {recommendId: recommendId.value}, 'GET');
  if(code==='') {
    shopInfo.value = data
  }
}

// 圈子列表
// const getCircle = async() => {
//   if (circleData.value.total!=0&&circleData.value.list.length>=circleData.value.total){
//     return
//   }
//   const {code, data} = await await request(API.CirclePage, {
//     ...pageInfo.value,
//     fileType: circleData.value.categoryId,
//     shopId: shopId.value
//   }, 'GET');
//   if(code==='') {
//     let tData = data.list || [];
//     tData.forEach(it => {
//       it.fileUrl = it.fileUrl.split(',')[0];
// 	  if(it.fileType===2) it.fileUrl = it.cover;
//     })
//     circleData.value = {
//       ...circleData.value,
//       list: [...circleData.value.list, ...tData],
//       total: data.total
//     }
//     if(circleData.value.list.length===0) isShow.value = true;
//   }
// }
// 圈子列表
const getCircle = async() => {
  if (circleData.value.total!=0&&circleData.value.list.length>=circleData.value.total){
    return
  }
  const {code, data} = await await request(API.CirclePage, {
    ...pageInfo.value,
    fileType: circleData.value.categoryId,
    shopId: shopId.value
  }, 'GET');
  if(code==='') {
    let tData = data.list || [];
    tData.forEach(it => {
      it.fileUrl = it.fileUrl.split(',')[0];
      if(it.fileType===2) it.fileUrl = it.cover;
    })
    const list  = [...circleData.value.list, ...tData];
    let rList = [];
    let lList = [];
    list.forEach((it, i) => {
      if (i % 2 === 0) {
        lList.push(it);
      } else {
        rList.push(it);
      }
    })
    circleData.value = {
      ...circleData.value,
      list: [...circleData.value.list, ...tData],
      total: data.total,
      lList,
      rList
    }
    cirCleList.value = [
      {type: 'left', list: lList},
      {type: 'right', list: rList}
    ]
    if(circleData.value.list.length===0) isShow.value = true;
  }
}

// 切换分类
function tabChange(categoryId='') {
  isShow.value = false;
  topLeft.value = 0;
  circleData.value =  {...defaultCircle, categoryId, list: []};
  getCircle();

};


/**
 * 切换tab
 * @param tabIndex
 */
async function handleTabChange(tabIndex) {
  tabCurrentType.value = tabIndex;
  pageInfo.value.page = 1;
  const categoryId = categoryList.value[tabIndex].fileType
  circleData.value =  {...defaultCircle, categoryId, list: []};
  await getCircle()
}

/**
 * 跳转店铺
 * @param id
 */
function goShop(id) {
  $jump(`/pages_category_page1/store/index?storeId=${ id }`)
}

//跳转店铺动态主页、图文或视频详情
function jumpTo(item, type) {
  let url = '';
  if(type==='info') {
    url = `/pages_category_page2/circle/${item.fileType===1?'img':'video'}Circle?recommendId=${item.recommendId}`;
  }
  uni.navigateTo({url});
}

// 点赞
const handleLike = async(item) => {
  const {recommendId, likeStatus} = item;
  const {code} = await request(API.CircleLike, {
    recommendId,
    type: likeStatus?2:1
  }, "POST");
  if(code==='') {
    circleData.value.list.forEach(it => {
      if(it.recommendId===recommendId) {
        it.likeStatus = likeStatus?0:1;
        likeStatus?it.likeCount--:it.likeCount++;
      }
    })
  }
}

const back = () => {
  uni.navigateBack()
}
const opacity = ref(0)
const {scrollTop} = useScroll()
const getScrollTransparency = (value) => {
  opacity.value = value
}
const computedHeightStyle = computed(() => {
  const style = {width: '100%', height: 0, background: '#FFFFFF'}
  if (!headerRef.value || !headerRef.value.heightInfo) return style
  return {...style, height: `${ headerRef.value.heightInfo.statusBarHeight }px`}
})
// onMounted(() => {
//   init();
// })

onShow(()=>{
  // #ifdef MP-WEIXIN || MP-BAIDU || MP-TOUTIAO || MP-QQ
  let menuButtonInfo = uni.getMenuButtonBoundingClientRect()
  topHeight.value = menuButtonInfo.top
  height.value = menuButtonInfo.height
  // #endif
  init();
})

onPageScroll((e)=>{
  topLeft.value = e.scrollTop
})

onReachBottom(() => {
  if (circleData.value.total !== 0 && circleData.value.list.length < circleData.value.total) {
    pageInfo.value.page++;
    getCircle();
  }
})
</script>

<style lang="scss" scoped>
@import '../../style/images';
page {
  background: #f8f8f8;
}
.circle-page {
  background: $circleShopBg no-repeat left top;
  background-size: contain;
  .shop-circle {
    padding-top: 350rpx;
    .backBox {
      position: absolute;
      left: 10rpx;
      top: 50rpx;

      .back {
        width: 50rpx;
        height: 50rpx;
        padding: 0rpx 10rpx;
      }
    }
    .shop-circle-box {
      padding-bottom: 100rpx;
      border-radius: 16rpx 16rpx 0 0;
      background: #ffffff;
      .circle-sticky {
        position: static;
        top: 0px;
        left: 0px;
        width: 100%;
        z-index: 970;
      }
      .reveal {
        position: fixed;
      }
      .circle-top {
        display: flex;
        align-items: center;
        justify-content: space-between;
        width: 100%;
        padding: 0 32rpx;
        background: #ffffff;
        .l-p {
          display: flex;
          align-items: center;
          flex: 1;
          .avatar {
            width: 160rpx;
            height: 160rpx;
            border-radius: 50%;
            margin-right: 16rpx;
            margin-top: -50rpx;
            background: #ffffff;
            border: 4rpx solid #ffffff;
          }
          .u-box {
            flex: 1;
            .text {
              color: #A9A9B2;
              font-size: 24rpx;
              display: flex;
              align-items: center;
              &:first-child {
                color: #292929;
                font-size: 28rpx;
              }
            }
            .arrow {
              width: 18rpx;
              height: 18rpx;
              margin-left: 0rpx;
            }
          }
        }
        .r-p {
          width: 118rpx;
          height: 52rpx;
          background: #292932;
          border-radius: 4rpx;
          font-size: 24rpx;
          text-align: center;
          line-height: 52rpx;
          color: #ffffff;
        }
      }
    }
  }
  .tabs-nav-warp{
    background: #fff;
    padding:0 30rpx;
    .tabs-nav{
      .ul{
        display: flex;
        .li{
          flex: 1 0 auto;
          margin-left: 36rpx;
          font-size: 30rpx;
          color: #999999;
          position: relative;
          padding-bottom: 18rpx;
          &:first-child{
            margin-left: 0;
          }
          &.on{
            &:after{
              content: '';
              width: 100%;
              height: 4rpx;
              background: #333333;
              position: absolute;
              left: 0;
              bottom: 0;
            }
            color: #333333;
            font-weight:bold;
          }
        }
      }
    }
  }
  .circle-list {
    padding: 12rpx 20rpx;
    overflow: hidden;
    /* column-count: 2;
    column-gap: 14rpx; */
    display: flex;
    .list-box {
      display:flex;
      width: calc(50% - 7rpx);
      flex-direction:column;
      align-items:flex-start;
      &:first-child {
        margin-right: 14rpx;
      }
    }
    .circle-item {
      /* -moz-page-break-inside:avoid;
      -webkit-column-break-inside:avoid;
      break-inside:avoid; */
      background: #FFFFFF;
      border-radius: 8rpx;
      width: 100%;
      min-height: 400rpx;
      break-inside: avoid; // 不被截断
      margin-bottom: 14rpx;
      .img-box {
        width: 100%;
        height: 348rpx;
        position: relative;
        text-align: center;
        background: #f3f3f3;
        .item-img {
          height: 100%;
          max-width: 100%;
          border-radius: 8rpx 8rpx 0 0;
        }
        .play-icon {
          position: absolute;
          width: 48rpx;
          height: 48rpx;
          top: 150rpx;
          left: calc(50% - 24rpx);
        }
      }
      .video {
        border-radius: 8rpx 8rpx 0 0;
        height: 348rpx;
        width: 100%;
        // max-width: 100%;
      }
      .t-box {
        padding: 20rpx;
        .t-title {
          font-size: 28rpx;
          color: #333333;
          margin-bottom: 16rpx;
          overflow: hidden;
          text-overflow: ellipsis;
          display: -webkit-box;
          -webkit-line-clamp: 2;
          -webkit-box-orient: vertical;
          word-break: break-all;
        }
      }
      .b-box {
        display: flex;
        justify-content: space-between;
        align-items: center;
        text {
          font-size: 24rpx;
          color: #666666;
        }
        .l-p {
          .shop-img {
            width: 48rpx;
            height: 48rpx;
            border-radius: 50%;
            vertical-align: middle;
            margin-right: 8rpx;
          }
        }
        .r-p {
          .icon-img {
            width: 32rpx;
            height: 32rpx;
            margin-right: 8rpx;
            vertical-align: middle;
          }
        }
      }
    }
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
      color: #CCCCCC;
    }
  }
  .emptyCart-box {
    margin-top: 70rpx;
    .emptyCart-img {
      width: 216rpx;
      height: 156rpx;
    }
  }
  .circle-header {
    height: 120rpx;
    display: flex;
    align-items: center;
    width: 100%;
    background: #ffffff;
    border-bottom: 2rpx solid #F8F8F8;
    padding: 0  24rpx;
    .left-arrow {
      width: 32rpx;
      height: 32rpx;
      image {
        width: 100%;
        height: 100%;
      }
    }
    .avatar {
      width: 64rpx;
      height: 64rpx;
      margin: 0 16rpx;
      .avatar-img {
        width: 100%;
        height: 100%;
        border-radius: 50%;
      }
    }
    .username {
      font-size: 28rpx;
      color: #292929;
    }
  }
}
</style>
