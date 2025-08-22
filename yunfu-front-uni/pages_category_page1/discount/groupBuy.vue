<template>
  <view class="groupBuy">
    <view class="groupBuyBg">
      <image :src="`${VUE_APP_STATIC_URL}static/images/groupBuyLogo.png`"></image>
    </view>
    <view
        class="countdown"
        v-if="shopShowType == false"
    >
      <label v-if="groupDataList.state === 1">距结束剩余</label>
      <label v-else>即将开始</label>
      <view class="endDate"><span>{{ hou }}</span><i>:</i><span>{{ min }}</span><i>:</i><span>{{ sec }}</span></view>
    </view>
    <view class="shop-list-nav">
      <view
          class="nav-item-sort"
          @click="sortTap(1)"
      >
        <text
            class="nav-title"
            :class="{'active' : sortIndex == 1}"
        >综合
        </text>
      </view>
      <view
          class="nav-item-sort"
          @click="sortTap(2)"
      >
        <text
            class="nav-title"
            :class="{'active' : sortIndex == 2}"
        >价格
        </text>
        <view class="r">
          <view
              class="arrowUp"
              :class="{activeUp: type == 1}"
          ></view>
          <view
              class="arrowDown"
              :class="{activeDown: type == 2}"
          ></view>
        </view>
      </view>
      <view
          class="nav-item-sort"
          @click="sortTap(3)"
      >
        <text
            class="nav-title"
            :class="{'active' : sortIndex == 3}"
        >销量
        </text>
        <view class="r">
          <view
              class="arrowUp"
              :class="{activeUp: volume == 1}"
          ></view>
          <view
              class="arrowDown"
              :class="{activeDown: volume == 2}"
          ></view>
        </view>
      </view>
    </view>
    <view class="spikeList mar-top-20 u-skeleton">
      <Skeleton
          el-color="#888888"
          bg-color="#333333"
          :loading="loading && isFirstComeIn"
          :animation="true"
      />
      <view
          class="listItem"
          v-for="(item,index) in groupBuy"
          :key="index"
      >
        <view class="itemBox u-skeleton-rect">
          <image :src="item.image" />
        </view>
        <view class="itemInfo">
          <view class="title">
            <view class="u-skeleton-rect product-name">
              <p>{{ item.productName }}</p>
            </view>
            <view class="tag-box">
              <view
                  class="number group-buy-number u-skeleton-rect"
                  v-if="item.person>0"
              >{{ item.person }}人团
              </view>

              <view
                  class="number u-skeleton-rect"
                  v-if="item.limitNumber"
              >限量{{ item.limitNumber }}件 / 剩余{{ item.limitStockNumber }}件
              </view>
            </view>
          </view>
          <view class="originalPrice">
            <text class="u-skeleton-rect">原价: ¥{{ item.originalPrice }}</text>
          </view>
          <view class="price">
            <view class="currentPrice flex-row-plus flex-items-plus font-color-FF7800 u-skeleton-rect">
              <view class="iconBox">
                <image :src="`${VUE_APP_STATIC_URL}static/images/groupBuyIcon.png`"></image>
              </view>
              <view class="flex-row-plus flex-items priceInfo">
                <label class="fs24">￥</label>
                <label class="fs36">{{ item.price }}</label>
              </view>
            </view>
            <view class="u-skeleton-fillet">
              <view
                  v-if="groupDataList.state === 1"
                  class="snapUpBtn "
                  @click="gogoodsDetails(item.shopId,item.productId,item.skuId)"
              >
                <view class="btnText">去拼团</view>
                <view style="width: 82%;margin: 0 auto">
                  <progress
                      activeColor="#FFFFFF"
                      :percent="getPercent(5, 10)"
                      active
                      stroke-width="5"
                  />
                </view>
              </view>
              <view
                  v-else
                  class="snapUpBtn btnStyle1"
              >
                <view class="btnText">即将开始</view>
                <view style="width: 82%;margin: 0 auto">
                  <progress
                      activeColor="#FFFFFF"
                      :percent="getPercent(5, 10)"
                      active
                      stroke-width="5"
                  />
                </view>
              </view>
            </view>
          </view>
        </view>
      </view>
      <view
          v-if="ifEmpty"
          class="emptyOrder-box flex-items-plus flex-column"
      >
        <image
            class="emptyOrder-img"
            :src="`${VUE_APP_STATIC_URL}static/img/bgnull.png`"
        ></image>
        <label class="font-color-999 fs26 mar-top-30">暂无活动商品～</label>
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
  </view>
</template>

<script setup>
import { ref } from "vue"
import {request} from "../../utils/request";
import {onLoad, onShow, onReachBottom, onPageScroll} from "@dcloudio/uni-app";
import API from "@/config/api";
import { VUE_APP_STATIC_URL } from "@/config/api";
import Skeleton from "../../components/Skeleton/index.vue";

const pageType = ref(true);
const groupBuy = ref([{}, {}, {}, {}, {}, {}, {}, {}, {}]);
const page = ref(1);
const pageSize = ref(10);
const loadingType = ref(0);
const hou = ref("00");
const min = ref("00");
const sec = ref("00");
const shopId = ref(0);
const shopGroupWorkId = ref(0);
const type = ref(0);          // 价格
const volume = ref(0);        // 销量
const shopShowType = ref(false);
const selectIndex = ref(0);
const sortIndex = ref(1);
const groupDataList = ref({});
const topLeft = ref(0); // 无更多数据显示距离
const returnTopFlag = ref(false); // 返回顶部显示隐藏
const loading = ref(false);
const noMore = ref(false); // 没有更多数据显示隐藏
const isFirstComeIn = ref(true);
const total = ref(0); // 订单总数据
const ifEmpty = ref(false); // 是否为空

onLoad((options) => {
  if (options.shopId && options.shopGroupWorkId) {
    shopShowType.value = false
    shopId.value = options.shopId
    shopGroupWorkId.value = options.shopGroupWorkId
  } else {
    shopShowType.value = true
    shopId.value = 0
    shopGroupWorkId.value = 0
  }
})

onShow(() => {
  groupBuy.value = [{}, {}, {}, {}, {}, {}, {}, {}, {}]
  getGroupBuylist()
})

onReachBottom(() => {
  if (noMore.value) {
    uni.stopPullDownRefresh()
  } else {
    page.value = page.value + 1
    getGroupBuylist()
  }
})

onPageScroll(e => {
  returnTopFlag.value = e.scrollTop > 600;
  topLeft.value = e.scrollTop
})
/**
 * 进度条
 * @param num 当前数
 * @param total 总数
 * @returns {string|number|string}
 */
const getPercent = (num, total) => {
  num = parseFloat(num);
  total = parseFloat(total);
  if (isNaN(num) || isNaN(total)) {
    return "-";
  }
  return total <= 0 ? "0%" : Math.round((num / total) * 10000) / 100.0;
}
/**
 * 排序
 * @param index
 */
const sortTap = (index) => {
  isFirstComeIn.value = true
  page.value = 1
  groupBuy.value = []
  sortIndex.value = index
  if (index == 1) {
    type.value = 0
    volume.value = 0
  } else if (index == 2) {
    volume.value = 0
    if (type.value === 0) {
      type.value = 1
    } else {
      type.value = type.value != 1 ? 1 : 2
    }
  } else if (index == 3) {
    type.value = 0
    if (volume.value === 0) {
      volume.value = 1
    } else {
      volume.value = volume.value != 1 ? 1 : 2
    }
  }
  getGroupBuylist()
}
/**
 * 跳转商品详情
 * @param shopId 店铺ID
 * @param productId 商品ID
 * @param skuId 规格ID
 */
const gogoodsDetails = (shopId, productId, skuId) => {
  uni.navigateTo({
    url: '../goodsModule/goodsDetails?shopId=' + shopId + '&productId=' + productId + '&skuId=' + skuId
  })
}
/**
 * 获取拼团数据
 * @returns {Promise<void>}
 */
const getGroupBuylist = async () => {
  loading.value = true
  let param = {
    page: page.value,
    pageSize: pageSize.value,
    shopId: shopId.value,
    shopGroupWorkId: shopGroupWorkId.value,
    type: type.value,
    volume: volume.value
  }
  try {
    const res = await request(API.getGroupBuyList, param, 'GET')
    uni.hideLoading()
    groupDataList.value = res.data
    groupBuy.value = groupBuy.value.concat(res.data.page.list).filter(item => JSON.stringify(item) !== '{}')
    if (groupBuy.value.length === 0) {
      ifEmpty.value = true
    }
    total.value = res.data.page.total
    if (groupBuy.value.length >= total.value) {
      noMore.value = true
    }
    if (shopShowType.value == false) {
      dateformat(res.data.time)
      countDown()
    }
  } catch (err) {
    uni.showToast({
      title: '失败',
      icon: "none"
    })
    throw Error(err)
  } finally {
    loading.value = false
    isFirstComeIn.value = false
  }
}

/**
 * 时分秒换算
 */
const dateformat = (micro_second) => {
  // 总秒数
  let second = Math.floor(micro_second / 1000);
  // 天数
  let day = Math.floor(second / 3600 / 24);
  // 小时
  let hr = Math.floor(second / 3600 % 24);
  // 分钟
  let mins = Math.floor(second / 60 % 60);
  // 秒
  let secs = Math.floor(second % 60);
  hou.value = hr + day * 24
  min.value = mins
  sec.value = secs
}

const countDown = () => {
  let timeOut = setTimeout(() => {
    let hous = parseInt(hou.value);
    let mins = parseInt(min.value);
    let secs = parseInt(sec.value);

    let netxSec = secs - 1;
    let netxMin = mins
    let netxHou = hous;

    if (netxHou == 0 && netxMin == 0 && netxSec == -1) {
      clearTimeout(timeOut)
      uni.switchTab({
        url: '../../pages/tabbar/index/index'
      })
      uni.showToast({
        title: "活动结束",
        duration: 2000,
        icon: 'none'
      })
    } else {
      if (netxSec == -1) {
        netxSec = 59
        netxMin = netxMin - 1;
      }
      if (netxMin == -1) {
        netxMin = 59
        netxHou = netxHou - 1
      }
      hou.value = timeFormat(netxHou),
      min.value = timeFormat(netxMin),
      sec.value = timeFormat(netxSec),
      countDown();
    }
  }, 1000)
}

/**
 * 小于10的格式化函数
 */
const timeFormat = (param) => {
  return param < 10 ? '0' + param : param;
}
</script>
<style>
page {
  background: #333333;
}
</style>
<style
    lang="scss"
    scoped
>
page {
  background: #333333;
}

.groupBuy {
  .selected {
    color: #FE6F52;
  }

  .groupBuyBg {
    text-align: center;
    margin: 50rpx auto;
    position: relative;
    z-index: 997;
    image {
      width: 262rpx;
      height: 52rpx;
    }
  }

  .countdown {
    display: flex;
    justify-content: center;
    height: 80upx;
    align-items: center;
    width: 100%;
    color: #CCCCCC;
    position: relative;
    z-index: 997;
    .endDate {
      display: flex;
      align-items: center;
      margin-left: 20upx;

      span {
        min-width: 44rpx;
        padding: 0 8rpx;
        height: 52upx;
        line-height: 52upx;
        background: #999999;
        display: block;
        font-size: 26upx;
        color: #FFEBC4;
        text-align: center;
      }

      i {
        font-size: 26upx;
        color: #999999;
        font-style: normal;
        margin: 0 8upx;
      }
    }
  }

  .spikeList {
    padding: 0upx 30upx 20upx 30upx;

    .listItem {
      display: flex;
      padding: 30upx;
      margin-bottom: 30upx;
      background: #FFFFFF;

      &:last-child {
        border-bottom: none;
      }

      .itemBox {
        width: 260upx;
        height: 260upx;
        margin-right: 30upx;

        image {
          width: 100%;
          height: 100%;
        }
      }

      .itemInfo {
        flex: 1;
        display: flex;
        flex-direction: column;
        justify-content: space-between;
        .product-name {
          min-height: 44rpx;
          width: 100%;
        }
        .iconBox {
          image {
            width: 58rpx;
            height: 36rpx;
          }
        }

        p {
          font-size: 26upx;
          color: #333333;
          line-height: 40upx;
          margin-bottom: 20upx;
          text-overflow: -o-ellipsis-lastline;
          overflow: hidden;
          text-overflow: ellipsis;
          display: -webkit-box;
          -webkit-line-clamp: 2;
          line-clamp: 2;
          -webkit-box-orient: vertical;
        }

        .tilte {
          .number {
            color: #C5AA7B;
            font-size: 26rpx;
            height: 40rpx;
            background: #FFFFFF;
            border: 2rpx solid #E4E5E6;
            font-weight: 400;
            display: inline;
            padding: 0 5rpx;
          }
        }

        .originalPrice {
          font-size: 24upx;
          margin-top: 20upx;
          text-decoration: line-through;
          color: #CCCCCC;
        }

        .price {
          display: flex;
          justify-content: space-between;
          align-items: center;

          .priceInfo {
            font-size: 40rpx;
            color: #C83732;
          }

          .snapUpBtn {
            width: 160upx;
            height: 84upx;
            text-align: center;
            background: linear-gradient(90deg, #C83732 0%, #E25C44 100%);
            box-shadow: 0rpx 6rpx 12rpx rgba(233, 0, 0, 0.3);
            opacity: 1;
            border-radius: 10rpx;

            .btnText {
              color: #FFFFFF;
              font-weight: 400;
              opacity: 0.5;
              margin: 10rpx 0;
            }

            .uni-progress {
              border-radius: 10rpx;
            }
          }

          .btnStyle1 {
            background: linear-gradient(90deg, #29C790 0%, #75D98C 100%);
            box-shadow: 0 6rpx 12rpx rgba(52, 203, 144, 0.3);
          }
        }
      }
    }
  }

  .filterBox {
    display: flex;
    height: 80upx;
    align-items: center;
    width: 100%;
    background: #FFFFFF;
    left: 0;

    .item {
      flex: 0 0 33.33%;
      text-align: center;
    }
  }
}

.shop-list-nav {
  display: flex;
  flex-direction: row;
  align-items: center;
  height: 80rpx;
  line-height: 76rpx;
  position: relative;
  z-index: 997;
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
  color: #999999;
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

.emptyOrder-box {
  margin-top: 70upx;

  .emptyOrder-img {
    margin-top: 45%;
    width: 113upx;
    height: 98upx;
  }
}
.tag-box{
  display: flex;
  align-items: center;
  justify-content: flex-start;
  flex-wrap: wrap;
  .number{
    display: inline-block;
    padding: 6rpx 16rpx;
    border-radius: 4rpx;
    border: 1rpx solid #E3928F;
    color: #E3928F;
    font-size: 14rpx;
  }
  .group-buy-number{
    background-color: #E3928F;
    border: none;
    color: #fff;
  }
}

</style>
<style scoped>
.snapUpBtn /deep/ .uni-progress-bar {
  border-radius: 10rpx;
  height: 8rpx;
  background-color: #deabab !important;
}

.snapUpBtn /deep/ .uni-progress-inner-bar {
  border-radius: 10rpx;
}

.spikeNav /deep/ .tabs-nav {
}
</style>
