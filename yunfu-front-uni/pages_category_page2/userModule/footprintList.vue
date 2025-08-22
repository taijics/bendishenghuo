<template>
  <view class="footprint-box u-skeleton">
    <Skeleton
        el-color="#efefef"
        bg-color="#fff"
        :loading="loading && isFirstComeIn"
        :animation="true"
    />
    <view v-if="!tipsShow">
      <view class="wid function-box">
        <view
            class="finishbox"
            @click="finishClick"
            v-if="allCheckShow"
        >完成
        </view>
        <view
            v-else
            class="flex-row-plus editicon-box flex-items fs28"
            @click="editClick"
        >
          <image
              class="editicon u-skeleton-rect"
              :src="`${VUE_APP_STATIC_URL}static/images/collectionEditicon.png`"
          ></image>
          <label class="mar-left-10 u-skeleton-rect">编辑</label>
        </view>
      </view>
      <view
          class="swipe-box"
          v-for="(ditem, findex) in footprintList"
          :key="findex"
      >
        <view class="daytime">
          <label class="mar-left-30 u-skeleton-rect">{{ ditem.createTime }}</label>
        </view>
        <view
            class="listItem"
            :index="index"
            v-for="(item, index) in ditem.products"
            :key="item.footprintId"
            @click="click(index,findex)"
        >
          <u-swipe-action
              :show="item.show"
              ref="footActionSwipe"
              :disabled="allCheckShow"
              @open="open(index,findex)"
              @click="delFootProduction(index,findex)"
              :options="options"
          >
            <view class="itemBox">
              <view
                  @click.stop="toGoodsDetails(item.productId,item.shopId,item.skuId)"
                  class="item wid flex-display"
              >
                <view
                    v-if="allCheckShow"
                    class="selectIconBox"
                >
                  <image
                      v-if="item.selected == 1"
                      @click.stop="footItemSel(index,findex,0)"
                      :src="`${VUE_APP_STATIC_URL}static/images/selectActive.png`"
                      class="cart-select-img"
                  ></image>
                  <image
                      v-else
                      @click.stop="footItemSel(index,findex,1)"
                      :src="`${VUE_APP_STATIC_URL}static/images/selectEmpty.png`"
                      class="cart-select-img"
                  ></image>
                </view>
                <image
                    class="product-img default-img u-skeleton-fillet"
                    mode="aspectFill"
                    :src="item.image"
                />
                <!-- 此层wrap在此为必写的，否则可能会出现标题定位错误 -->
                <view class="title-wrap mar-left-20">
                  <view class="title u-line-2 fs28">
                    <text class="u-skeleton-rect">{{ item.productName }}</text>
                  </view>
                  <view class="flex-items">
                    <image
                        v-if="item.activityType===1"
                        class="iconType u-skeleton-rect"
                        :src="`${VUE_APP_STATIC_URL}static/images/groupBuyIcon.png`"
                        alt="拼团icon"
                    ></image>
                    <image
                        v-if="item.activityType === 2"
                        class="iconType u-skeleton-rect"
                        :src="`${VUE_APP_STATIC_URL}static/images/spikeIcon.png`"
                        alt="秒杀活动"
                    ></image>
                    <image
                        v-if="item.activityType === 3"
                        class="iconType discountIcon u-skeleton-rect"
                        :src="`${VUE_APP_STATIC_URL}static/images/discountTagIcon.png`"
                        alt="限时折扣活动"
                    ></image>
                    <image
                        v-if="item.activityType === 4"
                        class="iconType u-skeleton-rect"
                        :src="`${VUE_APP_STATIC_URL}static/images/spikeIcon.png`"
                        alt="平台秒杀"
                    ></image>
                    <image
                        v-if="item.activityType===5"
                        class="iconType u-skeleton-rect"
                        :src="`${VUE_APP_STATIC_URL}static/images/discountListIcon.png`"
                        alt="平台折扣"
                    ></image>
                    <image
                        v-if="item.activityType===9"
                        class="iconType u-skeleton-rect"
                        :src="`${VUE_APP_STATIC_URL}static/images/memberCenterIcon.png`"
                        alt="会员价"
                    ></image>
                    <image
                        v-if="item.activityType === 8"
                        class="iconType u-skeleton-rect"
                        :src="`${VUE_APP_STATIC_URL}static/images/holidaySaleIcon.png`"
                        alt="场景营销"
                    ></image>
                    <label class="fs40 mar-right-20 font-color-C83732 u-skeleton-rect price-box">¥{{ item.price }}</label>
                    <label class="font-color-CCC discountsPriceLine fs24 u-skeleton-rect">¥{{ item.originalPrice }}</label>
                  </view>
                </view>
              </view>
            </view>
          </u-swipe-action>
        </view>
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
      <view
          v-show="allCheckShow"
          class="allcheck-box flex-row-plus flex-sp-between flex-items"
      >
        <view class="left">
          <image
              v-if="isAllCheck"
              :src="`${VUE_APP_STATIC_URL}static/images/selectActive.png`"
              class="cart-select-img"
              @click="allSel(0)"
          ></image>
          <image
              v-else
              :src="`${VUE_APP_STATIC_URL}static/images/selectEmpty.png`"
              class="cart-select-img"
              @click="allSel(1)"
          ></image>
          <text>全选</text>
        </view>
        <view class="right">
          <view
              class="btn-delete"
              @click="showCardModal"
          >删除
          </view>
        </view>
      </view>
      <view
          v-if="allCheckShow"
          class="pad-bot-140"
      ></view>
    </view>
    <view
        v-else
        class="mar-top-100 empty-box"
        @click="goToIndex"
    >
      <image
          class="footprint-empty"
          src="https://datumstar.oss-cn-shenzhen.aliyuncs.com/dkyaemtmfwfxbvtuyyhi.png"
      ></image>
      <view class="tohome-box flex-items-plus">去首页逛逛</view>
    </view>

    <!-- 删除确认弹窗 -->
    <tui-modal
        :show="cardModal"
        :custom="true"
        :fadein="true"
    >
      <view class="Put-box1">
        <view class="text-align fs34 fs-bold">
          温馨提示
        </view>
        <view class="mar-top-40 text-align">
          是否删除该浏览足迹？
        </view>
        <view
            class="btn submit"
            @click="footprintDel"
        >确定
        </view>
      </view>
      <view
          v-if="cardModal"
          @click="cardModal = false"
          class="cancelDel"
      >
        <image
            :src="`${VUE_APP_STATIC_URL}static/images/cancelClose.png`"
            mode=""
        ></image>
      </view>
    </tui-modal>
    <!-- 回到顶部 -->
    <ReturnTop :returnTopFlag="returnTopFlag" />
  </view>
</template>

<script setup>

import { ref } from "vue";
import {onLoad, onPageScroll, onReachBottom} from "@dcloudio/uni-app";
import { request } from "@/utils/request";
import API from "@/config/api";
import TuiModal from "@/components/modal/modal.vue";
import { VUE_APP_STATIC_URL } from "@/config/api";
import Skeleton from "../../components/Skeleton/index.vue";

const topLeft = ref(0); // 无更多数据显示距离
const returnTopFlag = ref(false); // 返回顶部显示隐藏
const loading = ref(false);
const noMore = ref(false); // 没有更多数据显示隐藏
const isFirstComeIn = ref(true);
const allCheckShow = ref(false);
const isAllCheck = ref(false);
const disabled = ref(false);
const btnWidth = ref(180);
const show = ref(false);
const page = ref(1);
const pageSize = ref(5);
const loadingType = ref(0);
const footprintList = ref([{products: [{}, {}, {}, {}, {}, {}, {}], isReady: 1}]);
const footEmpty = ref(false);
const newTimeArr = ref([]);
const tipsShow = ref(false);
const cardModal = ref(false); //删除弹窗显示
const ids = ref([]);
const options = ref([
  {
    text: ' ',
    style: {
      backgroundColor: '#C83732',
      color: '#FFEBC4'
    }
  }
])
onLoad(() => {
  getFootprintList()
})
onReachBottom(() => {
  if (loadingType.value == 1) {
    uni.stopPullDownRefresh()
  } else {
    page.value = page.value + 1
    getFootprintList()
  }
})

//去商品详情
function toGoodsDetails(productId, shopId, skuId) {
  uni.navigateTo({
    url: '../../pages_category_page1/goodsModule/goodsDetails?productId=' + productId + '&shopId=' + shopId + '&skuId=' + skuId
  })
}

// 点击编辑底下删除按钮
function showCardModal() {
  footprintList.value.forEach((value, index) => {
    value.products.forEach((value1, index1) => {
      if (value1.selected == 1) {
        ids.value.push(value1.productId)
      }
      if (!ids.value.length) {
        uni.showToast({
          title: '请选择要删除的足迹商品！',
          icon: 'none'
        })
      } else {
        cardModal.value = true
      }
    })
  })
}

// 滑动删除单个商品足迹
function delFootProduction(index, findex) {
  let dataArr = footprintList.value[findex]
  newTimeArr.value.push(dataArr.createTime)
  ids.value.push(dataArr.products[index].productId)
  footprintDel()
}

// 删除方法
function footprintDel() {
  isAllCheck.value = false
  request(API.deleteFootprint, {
    ids: ids.value,
    times: newTimeArr.value
  }, 'POST').then(res => {
    footEmpty.value = true
    page.value = 1
    pageSize.value = 5
    getFootprintList()
    cardModal.value = false
    newTimeArr.value = []
    ids.value = []
    setTimeout(function () {
      uni.showToast({
        title: "删除成功",
        duration: 2000,
        icon: 'none',
      });
    }, 1000)
  }).catch(res => {
    uni.showToast({
      title: "删除失败",
      duration: 2000,
      icon: 'none',
    });
  })
}

function footItemSel(index, findex, number) {
  footprintList.value[findex].products[index].selected = number
  let footSelectNum = 0
  let footprintListlen = 0
  let footDataTime = []
  footprintList.value.forEach((value, index1) => {
    value.products.forEach((value, index) => {
      if (value.selected == 0) {
        isAllCheck.value = false
      } else {
        footSelectNum++
        footDataTime[index1] = footprintList.value[index1].createTime
      }
    })
  })
  newTimeArr.value = footDataTime.filter(d => d)
  footprintList.value.forEach((value, index) => {
    value.products.forEach((value, index) => {
      footprintListlen++
    })
  })
  if (footprintListlen == footSelectNum) {
    isAllCheck.value = true
  }
}

function getFootprintList() {
  if (footEmpty.value == true) {
    footprintList.value = []
    footEmpty.value = false
  }
  // uni.showLoading({
  //     mask: true,
  // 	  title: '加载中...',
  // })
  loading.value = true
  request(API.getFootprintList,
      {
        page: page.value,
        pageSize: pageSize.value
      },
      'GET').then(res => {
    if (res.data.length == 0) {
      loadingType.value = 1
      page.value = page.value
    } else {
      footprintList.value = footprintList.value.concat(res.data.list)
      footprintList.value = footprintList.value.filter(item => {
        return item.isReady !== 1
      })
    }
    if (footprintList.value.length === 0) {
      tipsShow.value = true
    }
    if (footprintList.value.length >= res.data.total) {
      noMore.value = true
    }
    loading.value = false
    isFirstComeIn.value = false
    uni.hideLoading()
  }).catch(res => {
    uni.hideLoading()
    uni.showToast({
      title: '浏览足迹查询失败',
      icon: "none"
    })
  })
}

function click(index, findex) {
  let ids = footprintList.value[findex].products[index].productId
  let times = footprintList.value[findex].createTime
  cancelFootprin(ids, times)
  footprintList.value[findex].products.splice(index, 1);
  uni.showToast({
    title: '删除成功',
    icon: "none"
  })
}

function cancelFootprin(ids, times) {
  request(API.deleteFootprint, {
    ids: [ids],
    times: [times]
  }, 'POST').then(res => {
  }).catch(res => {
    uni.showToast({
      title: '失败',
      icon: "none"
    })
  })
}

// 如果打开一个的时候，不需要关闭其他，则无需实现本方法
function open(index, findex) {
  console.log('打开')
  footprintList.value[findex].products[index].show = true;
  footprintList.value[findex].products.map((val, idx) => {
    if (index != idx) footprintList.value[findex].products[idx].show = false;
  })
}

//全选
function allSel(type) {
  isAllCheck.value = !isAllCheck.value
  footprintList.value.forEach((value, index1) => {
    value.products.forEach((value, index) => {
      value.selected = type
      if (type == 1) {
        newTimeArr.value[index1] = footprintList.value[index1].createTime
      }
    })
  })
}

const footActionSwipe = ref([])
const getFootActionSwipe = (e) => {
  footActionSwipe.value.push(e)
}

function editClick() {
  allCheckShow.value = true
  let FootActionSwipe = footActionSwipe.value;
  if (FootActionSwipe.length > 0) {
    FootActionSwipe.forEach(item => item.close())
  }
}

function finishClick() {
  allCheckShow.value = false
}

function goToIndex() {
  uni.switchTab({
    url: '/pages/tabbar/index/index'
  })
}

onPageScroll(e => {
  returnTopFlag.value = e.scrollTop > 600;
  topLeft.value = e.scrollTop
})
</script>

<style lang="scss">
page {
  background: #f7f7f7;
}

.footprint-box {
  .function-box {
    background-color: #FFFFFF;
    z-index: 9999;
  }

  .editicon-box {
    display: flex;
    justify-content: flex-end;
    position: relative;
    left: -30rpx;
    padding: 16rpx 0;
  }

  .finishbox {
    display: flex;
    justify-content: flex-end;
    position: relative;
    left: -30rpx;
    padding: 16rpx 0;
  }

  .editicon {
    width: 50rpx;
    height: 50rpx;
  }

  .swipe-box {
    padding: 0 24rpx;

    .listItem {
      //padding: 0 24rpx;
      background: #F8F8F8;
      margin-bottom: 20rpx;
    }

    .daytime {
      width: 100%;
      height: 80rpx;
      background-color: #F7F7F7;
      line-height: 80rpx;
      label {
        display: inline-block;
        min-height: 50rpx;
        min-width: 180rpx;
      }
    }

    .item {
      display: flex;
      padding: 20rpx;
      background: #FFFFFF;

      .selectIconBox {
        margin-right: 14upx;
        display: flex;
        align-items: center;
      }
    }

    .product-img {
      width: 200rpx;
      flex: 0 0 200rpx;
      height: 200rpx;
    }

    .iconType {
      width: 64rpx;
      height: 38rpx;
      margin-right: 10rpx;
    }

    .discountIcon {
      width: 100rpx;
    }

    .head-img {
      width: 80rpx;
      flex: 0 0 80rpx;
      height: 80rpx;
      border-radius: 50%;
    }

    .title {
      text-align: left;
      color: #333333;
      height: 150rpx;
      min-width: 400rpx;
      text {
        min-height: 50rpx;
        display: block;
        min-width: 100%;
      }
    }

    .cart-select-img {
      width: 98upx;
      height: 98upx;
      padding: 30upx;
      box-sizing: border-box;
    }

    // #ifdef MP-ALIPAY
    .cart-select-img {
      width: 49upx;
      height: 49upx;
      padding: 15upx;
      box-sizing: border-box;
    }

    // #endif
    .toStore {
      border: 1rpx #C5AA7B solid;
      color: #C5AA7B;
      padding: 0rpx 20rpx;
      border-radius: 5rpx;
      height: 52rpx;
    }
  }

  .allcheck-box {
    background-color: #FFFFFF;
    padding: 10rpx 0;
    width: 100%;
    position: fixed;
    bottom: 0upx;

    .left {
      display: flex;
      flex-direction: row;
      align-items: center;
      font-size: 28upx;
      color: #666;

      .cart-select-img {
        width: 98upx;
        height: 98upx;
        padding: 30upx;
        box-sizing: border-box;
      }
    }

    .right {
      display: flex;
      flex-direction: row;
      align-items: center;
      box-sizing: border-box;
    }

    .btn-delete {
      width: 232rpx;
      height: 100rpx;
      background: #C83732;
      line-height: 100rpx;
      text-align: center;
      font-size: 28upx;
      color: #FFFFFF;
    }
  }

  .footprint-empty {
    width: 270rpx;
    height: 270rpx;
  }

  .empty-box {
    display: flex;
    justify-content: center;
    flex-direction: column;
    align-items: center;

    .tohome-box {
      color: #FF7800;
      border: 1rpx solid #FF7800;
      width: 240rpx;
      height: 70rpx;
      margin-top: 50rpx;
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
      color: #FFEBC4;
    }
  }

  .cancelDel {
    position: absolute;
    bottom: -50px;
    left: 45%;

    image {
      width: 60upx;
      height: 60upx;
    }
  }
  .price-box {
    min-width: 80rpx;
    min-height: 40rpx;
  }
  .discountsPriceLine {
    min-width: 50rpx;
    min-height: 40rpx;
  }
}
</style>
<style lang="scss" scoped>
@import "../../style/images";
.swipe-box ::v-deep .u-swipe-del {
  align-items: center;
  justify-content: center;
  width: 160rpx !important;
}

.swipe-box ::v-deep .u-btn-text {
  width: 60rpx;
  height: 60rpx;
  display: block;
  background: $delIcon no-repeat center center;
  background-size: contain;
}
</style>
