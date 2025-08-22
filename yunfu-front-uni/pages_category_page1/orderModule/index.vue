<!-- 订单中心 -->
<template>
  <view class="container">
<!--    <global-loading />-->
    <view style="padding-bottom:68upx;">
      <u-sticky
          bg-color="#fff"
      >
        <u-tabs
            class="tabs"
            disabled
            :list="tabList"
            :is-scroll="false"
            active-color="#C5AA7B"
            :current="tabCurrentType"
            @change="handleTabChange"
        />
      </u-sticky>
      <view class="order-list-box u-skeleton">
        <Skeleton
            el-color="#efefef"
            bg-color="#fff"
            :loading="loading"
            :animation="true"
        />
        <view
            class="item ske-loading"
            v-for="(orderItem, orderIndex) in list"
            :key="orderIndex"
        >
          <view class="order-list-top">
            <view
                class="top-l u-skeleton-rect"
                @click.stop="goShop(orderItem.shopId)"
            >
              <image
                  :src="orderItem.shopLogo"
                  class="shop-img"
              />
              <text class="shop-name">{{ orderItem.shopName }}</text>
              <image
                  :src="`${VUE_APP_STATIC_URL}static/images/arrowRight.png`"
                  class="arrow-img"
              />
            </view>
            <view class="order-status u-skeleton-rect">
              {{ getOrderStatusLabel(orderItem.state, orderItem.returnType) }}
            </view>
          </view>
          <view
              class="order-info-box"
              @click="goOrderDesc(orderItem)"
          >
            <view class="order-info">
              <view
                  class="order-info-item"
                  v-for="(skuItem, skuIndex) in orderItem.skus"
                  :key="skuIndex"
              >
                <image
                    :src="skuItem.image"
                    class="product-img default-img u-skeleton-fillet"
                />
                <view class="info-box">
                  <view class="u-skeleton-rect name-box">
                    <text class="product-name">{{ skuItem.productName }}</text>
                  </view>
                  <view class="product-sku u-skeleton-rect">{{ skuItem.value }}</view>
                  <view class="price-sku-box">
                    <view class="box-h flex-items-plus u-skeleton-rect">
                      <text class="product-price">
                        <text
                            class="fuhao"
                        >￥
                        </text>
                        {{ skuItem.price }}
                      </text>
                      <text class="product-num">x {{ skuItem.number }}</text>
                    </view>
                    <view
                        v-if="skuItem.commentId === 0 && orderItem.state === 4"
                        class="evaluate"
                        @click.stop="goEvaluate(skuItem,orderItem.orderId)"
                    >立即评价
                    </view>
                    <view
                        v-if="skuItem.commentId !== 0 && orderItem.state === 4 && orderItem.skus[0].ifAdd !== 1"
                        class="evaluate2"
                        @click.stop="goAdditionalEvaluation(orderIndex,skuItem.commentId)"
                    >追加评价
                    </view>
                  </view>
                </view>
              </view>
              <view class="total-price-box">
                <view class="u-skeleton-rect skeleton-box">
                  总价¥{{
                    (orderItem.orderPrice + orderItem.logisticsPrice).toFixed(2)
                  }},优惠¥{{ orderItem.discountPrice }}
                  <span v-if="orderItem.price > 0">
                      ，{{ orderItem.state === 1 ? '应付¥' : '实付¥' }}{{ orderItem.price }}
                    </span>
                </view>
              </view>
            </view>
            <view
                class="btnBox flex-items flexSpBetween"
                :class="{flexSpBetween: orderItem.state===5 || orderItem.state === 9}"
            >
              <view class="u-skeleton-rect" style="min-height: 60rpx; min-width: 60rpx;">
                <view
                    class="delIcon"
                    v-if="orderItem.state===5 || orderItem.state === 9"
                    @click.stop="handleDeleteOrder(orderItem)"
                ></view>
              </view>
              <view class="order-btn-box u-skeleton-rect">
                <text
                    :class="['btn',buttonItem.className] "
                    v-for="buttonItem in getOrderOptionButtonObj(orderItem)"
                    :key="buttonItem.name"
                    @click.stop="handleOrderOptionButtonEvent(buttonItem)"
                >
                  {{ buttonItem.name }}
                </text>
              </view>
            </view>
          </view>
        </view>
        <slide-loading />
        <view
            class="reachBottom"
            v-if="topLeft > 300 && !isEmpty && list.length >=listTotal"
        >
          <image
              class="reach-icon"
              :src="`${VUE_APP_STATIC_URL}static/img/reachBottom.png`"
              mode="widthFix"
          ></image>
          <text class="reach-text">这里到底了哦~~</text>
        </view>
        <Empty
            background="none"
            :show="isEmpty"
            :icon-url="`${VUE_APP_STATIC_URL}static/images/emptyOrderImg.png`"
        >您还没有订单哦~
        </Empty>
      </view>
    </view>
    <!-- 回到顶部 -->
    <ReturnTop :returnTopFlag="returnTopFlag" />
    <!-- 支付 -->
    <u-popup
        v-model="payObj.showPayPopup"
        border-radius="15"
        closeable
        mode="bottom"
    >
      <view class="pay-list-content">
        <CashierList
            style="width: 100%;"
            :total-price="payObj.totalPrice"
            @change="handleChangePayItem"
        />
        <view
            class="pay-confirm-btn"
            @click="handleGoPay"
        >确认
        </view>
      </view>
    </u-popup>
  </view>
</template>

<script setup>
import CashierList from "../../components/CashierList";
import Empty from "../../components/Empty";
import { orderTabList, orderTypeEnum } from "./config/orderConfig";
import { handleDoPay } from "@/utils/payUtil";
import Skeleton from "../../components/Skeleton";
import { request } from '@/utils/request'
import API from "../../config/api";
import { inject, nextTick, onMounted, ref } from "vue";
import {onBackPress, onLoad, onPageScroll, onReachBottom, onShow, onUnload} from "@dcloudio/uni-app";
import { useLoading } from "@/hooks/useLoading";
const {showLoading,hideLoading} = useLoading();
import { VUE_APP_STATIC_URL } from "@/config/api";
import SlideLoading from "../../components/SlideLoading/index.vue";

const returnTopFlag = ref(false); // 回到顶部
const topLeft = ref(0)
const $showLoading = showLoading
const $hideLoading = hideLoading
const $jump = inject('$jump')
const $jumpToTabbar = inject('$jumpToTabbar')

const loading = ref(false)
const orderState = ref('')// 订单类型（params参数）
const page = ref(1)
const pageSize = ref(10)
const list = ref([{skus:[{}]}, {skus:[{}]}, {skus:[{}]}, {skus:[{}]}, {skus:[{}]}, {skus:[{}]}])
const listTotal = ref(0) // 用户订单总数
const isEmpty = ref(false) // 列表是否为空
const tabList = ref(orderTabList) // 顶部tabs
const tabCurrentType = ref(0)// 选中tab的索引
const payObj = ref({
  showPayPopup: false,
  totalPrice: 0,
  payInfo: {}
})

onLoad(options => {
  if (options.type!==undefined) {
    tabCurrentType.value = options.type
    orderState.value = options.type
  } else {
    orderState.value = ''
  }
})
const show = ref(false)
onShow(() => {
  // #ifdef H5
  const pageList = getCurrentPages();//获取应用页面栈
  const {$page} = pageList[pageList.length - 1];//获取当前页面信息
  if ($page.options.type) {
    tabCurrentType.value = $page.options.type
    orderState.value = $page.options.type
  }
  // #endif
})
onMounted(()=>{
  nextTick(()=>{
    console.log(tabCurrentType.value)
    handleTabChange(Number(tabCurrentType.value))
  })
  // handleRefreshList()
})
onUnload(() => {
  goUserIndex()
})
onReachBottom(() => {
  if (!isEmpty.value && list.value.length >= listTotal.value) {
    uni.stopPullDownRefresh()
  } else {
    ++page.value
    handleGetOrderList()
  }
})
// 返回顶部
onPageScroll((e)=>{
  returnTopFlag.value = e.scrollTop > 600;
  topLeft.value = e.scrollTop
})

/**
 * 重新加载列表
 */
async function handleRefreshList() {
  loading.value = true
  page.value = 1
  list.value = [{}, {}, {}, {}, {}, {}]
  isEmpty.value = false
  await handleGetOrderList()
}


/**
 * 切换tab
 * @param tabIndex
 */
async function handleTabChange(tabIndex) {
  topLeft.value = 0
  if (loading.value) return
  tabCurrentType.value = tabIndex;
  orderState.value = tabList.value[tabIndex].number
  await handleRefreshList()
}

/**
 * 获取列表数据
 * @return {Promise<void>}
 */
async function handleGetOrderList() {
  $showLoading()
  orderState.value === 0 ? orderState.value = '' : undefined
  try {
    const params = {
      state: orderState.value,
      page: page.value,
      pageSize: pageSize.value
    }
    const {data} = await request(API.FindOrderList, params, 'GET')
    listTotal.value = data.total
    list.value = list.value.concat(data.list).filter(item => JSON.stringify(item) !== '{}')
    if (list.value.length === 0) {
      isEmpty.value = true
    }
  } finally {
    loading.value = false
    $hideLoading()
  }
}

/**
 * 根据订单状态获取状态label
 * @param state
 * @param returnType 是否退款1是
 * @return {string}
 */
function getOrderStatusLabel(state, returnType = 0) {
  if (returnType) return '退款中'
  return orderTypeEnum[state]
}

/**
 * 根据订单Item获取按钮信息
 * @param orderItem
 * @return *[]
 */
function getOrderOptionButtonObj(orderItem) {
  const {state, returnType, afterState, skus, collageId} = orderItem
  const orderNeedBtnList = [] // 订单应有的btn
  // 取消订单
  if ([1, 6].includes(state)) {
    orderNeedBtnList.push({
      name: '取消订单',
      className: 'l',
      functionName: 'handleCancelOrder',
      functionParams: [orderItem]
    })
  }
  // 立即付款
  if (state === 1) {
    orderNeedBtnList.push({
      name: '立即付款',
      className: 'r',
      functionName: 'handlePayOrder',
      functionParams: [orderItem]
    })
  }
  // 申请售后
  if ([2, 3, 4].includes(state) && [0, 6].includes(Number(afterState)) && skus[0].ifAdd !== 1) {
    orderNeedBtnList.push({
      name: '申请售后',
      className: 'l',
      functionName: 'goAfterSalesService',
      functionParams: [orderItem]
    })
  }
  // 查看物流
  if ([3, 4].includes(state)) {
    orderNeedBtnList.push({
      name: '查看物流',
      className: 'l',
      functionName: 'goLogisticsInformation',
      functionParams: [orderItem]
    })
  }
  // 确认收货
  if ([3].includes(state)) {
    orderNeedBtnList.push({
      name: '确认收货',
      className: 'r',
      functionName: 'handleConfirmReceipt',
      functionParams: [orderItem]
    })
  }
  // 退款详情
  if ([1].includes(returnType)) {
    orderNeedBtnList.push({
      name: '退款详情',
      className: 'l',
      functionName: 'goRefundDetail',
      functionParams: [orderItem]
    })
  }
  // 邀请拼单
  if ([6].includes(state)) {
    orderNeedBtnList.push({
      name: '邀请拼单',
      className: 'r',
      functionName: 'goSpellGroup',
      functionParams: [orderItem]
    })
  }
  // 再次开团 | 再次购买
  if ([5].includes(state)) {
    orderNeedBtnList.push({
      name: collageId !== 0 ? '再次开团' : '再次购买',
      className: 'r',
      functionName: 'handleBuyAgainEvent',
      functionParams: [orderItem]
    })
  }
  return orderNeedBtnList
}

const functionList = {
  handleCancelOrder: handleCancelOrder,
  handlePayOrder: handlePayOrder,
  goAfterSalesService: goAfterSalesService,
  goLogisticsInformation: goLogisticsInformation,
  handleConfirmReceipt: handleConfirmReceipt,
  goRefundDetail: goRefundDetail,
  goSpellGroup: goSpellGroup,
  handleBuyAgainEvent: handleBuyAgainEvent
}

/**
 * 处理订单btn事件
 * @param buttonItem 由getOrderOptionButtonObj生成的item项
 */
function handleOrderOptionButtonEvent(buttonItem) {
  const {functionName, functionParams} = buttonItem
  if (functionList[functionName]) {
    functionList[functionName](...functionParams)
  } else {
    throw new Error(`${ buttonItem.name }的function在本VM中不存在`)
  }
}

/**
 * 取消订单
 * @param orderItem
 */
function handleCancelOrder(orderItem) {
  const modalOptions = {
    title: '温馨提示',
    content: '您确定要取消该订单吗？',
    confirmText: '确定取消',
    cancelText: '点错了',
    success: ({confirm}) => {
      confirm ? handleDoCancel(orderItem) : undefined
    }
  }
  uni.showModal(modalOptions)
}


/**
 * 确定取消订单
 * @param orderItem
 * @return {Promise<void>}
 */
async function handleDoCancel(orderItem) {
  $showLoading()
  try {
    await request(API.CancelOrder, {
      orderId: orderItem.orderId
    }, 'POST')
    await handleRefreshList()
    uni.showToast({
      icon: 'none',
      title: '取消成功'
    })
  } finally {
    $hideLoading()
  }
}

/**
 * 确认收货
 * @param orderItem
 */
function handleConfirmReceipt(orderItem) {
  const modalOptions = {
    title: '温馨提示',
    content: '确定您已经收到货物，否则会造成财产损失',
    confirmText: '确定收到',
    cancelText: '点错了',
    success: ({confirm}) => {
      confirm ? handleDoConfirmReceipt(orderItem) : undefined
    }
  }
  uni.showModal(modalOptions)
}

/**
 * 确定确认收货
 * @param orderItem
 * @return {Promise<void>}
 */
async function handleDoConfirmReceipt(orderItem) {
  $showLoading()
  console.log(orderItem)
  const {orderId} = orderItem
  try {
    await request(API.ConfirmReceive, {
      orderId: orderId
    }, 'POST')
    tabCurrentType.value = 4;
    orderState.value = 4
    await handleRefreshList()
    uni.showToast({
      icon: 'none',
      title: '收货成功'
    })
  } finally {
    $hideLoading()
  }
}

/**
 * 删除订单
 * @param orderItem
 */
function handleDeleteOrder(orderItem) {
  const modalOptions = {
    title: '温馨提示',
    content: '您确定要删除该订单吗？',
    confirmText: '确定删除',
    cancelText: '点错了',
    success: ({confirm}) => {
      confirm ? handleDoDeleteOrder(orderItem) : undefined
    }
  }
  uni.showModal(modalOptions)
}


/**
 * 确定删除订单
 * @param orderItem
 */
async function handleDoDeleteOrder(orderItem) {
  $showLoading()
  const {orderId} = orderItem
  try {
    await request(API.DelOrder, {orderId}, 'POST')
    await handleRefreshList()
    uni.showToast({
      icon: 'none',
      title: '删除成功'
    })
  } finally {
    $hideLoading()
  }
}

/**
 * 再次购买 || 再次拼团
 * @param orderItem
 */
function handleBuyAgainEvent(orderItem) {
  const {skus, shopId, collageId} = orderItem
  // 判断拼团ID是否为0
  if (collageId !== 0) {
    // 拼团直接跳回商品详情
    const path = `../goodsModule/goodsDetails`
    const params = {
      productId: skus[0].productId,
      shopId,
      skuId: skus[0].skuId
    }
    $jump(path, params)
  } else {
    // 跳转详情
    goBuyAgain(orderItem)
  }
}

/**
 * 处理选择支付方式
 * @param params
 */
function handleChangePayItem(params) {
  const {payInfo} = payObj.value
  payInfo.paymentMode = params.paymentMode
  payInfo.huabeiPeriod = params.huabeiPeriod
}

/**
 * 处理下单支付
 * @param orderItem
 * @return {Promise<void>}
 */
async function handlePayOrder(orderItem) {
  const {orderPrice, collageId, orderId} = orderItem
  payObj.value.totalPrice = orderPrice
  payObj.value.payInfo.collageId = collageId
  payObj.value.payInfo.money = orderPrice
  payObj.value.payInfo.orderId = orderId
  payObj.value.payInfo.type = 2
  payObj.value.showPayPopup = true
}


/**
 * 处理支付（选择支付方式以后）
 */
async function handleGoPay() {
  await handleDoPay(payObj.value.payInfo)
  payObj.value.showPayPopup = false
  payObj.value.totalPrice = 0
  payObj.value.payInfo = {}
}

/**
 * 去物流信息
 * @param orderItem
 */
function goLogisticsInformation(orderItem) {
  const {express, deliverFormid} = orderItem
  const url = `logisticsInfo?express=${ express }&deliverFormid=${ deliverFormid }`
  $jump(url)
}


/**
 * 跳转再次购买
 * @param orderItem
 * @return {Promise<void>}
 */
async function goBuyAgain(orderItem) {
  // 循环sku，获取商品详情，并且判断库存
  const postAjax = []
  orderItem.skus.forEach(skuItem => {
    postAjax.push(queryProductDetail(skuItem))
  })
  // 并发执行
  const skuDetailList = await Promise.all(postAjax);
  let canNotBuyNameList = []
  // 判断库存
  skuDetailList.forEach(skuDetail => {
    for (const skuDetailSkuMapKey in skuDetail.map) {
      // 判断此SKU是否存在于传进来的item
      const orderItemSku = orderItem.skus.find(skuItem => skuItem.skuId === skuDetail.map[skuDetailSkuMapKey].skuId);
      if (!orderItemSku) continue
      const dbSku = skuDetail.map[skuDetailSkuMapKey]
      if (orderItemSku.number > dbSku.stockNumber) {
        canNotBuyNameList.push(orderItemSku.productName)
      }
    }
  })
  // 如果有库存不足
  if (canNotBuyNameList.length > 0) {
    return uni.showToast({
      icon: 'none',
      title: canNotBuyNameList.join(",") + " 库存不足"
    })
  }
  // 制造数据
  const buyInfo = [{
    ifWork: orderItem.ifWork,
    shopId: orderItem.shopId,
    shopName: orderItem.shopName,
    shopDiscountId: orderItem.shopDiscountId,
    shopSeckillId: orderItem.shopSeckillId,
    skus: orderItem.skus
  }]
  uni.setStorageSync('skuItemDTOList', buyInfo)
  uni.navigateTo({
    url: '../orderModule/orderConfirm?type=1',
  })
}

/**
 * 获取商品详情
 * @param orderItem
 * @return {Promise<*>}
 */
async function queryProductDetail(orderItem) {
  const {shopId, productId, skuId} = orderItem
  $showLoading()
  let postData = {
    shopId,
    productId,
    skuId,
    terminal: 1
  }
  try {
    const res = await request(API.QueryProductDetail, postData, "GET")
    return res.data
  } catch (e) {
    throw new Error(e)
  } finally {
    $hideLoading()
  }
}



/**
 * 邀请拼单
 * @param orderItem
 */
function goSpellGroup(orderItem) {
  const {collageId, orderId, skus, shopGroupWorkId} = orderItem
  const url = `../goodsModule/inviteSpell?collageId=${ collageId }&orderId=${ orderId }&type=1&productId=${ skus[0].productId }&skuId=${ skus[0].skuId }&shopGroupWorkId=${ shopGroupWorkId }`
  $jump(url)
}


/**
 * 去用户中心
 */
function goUserIndex() {
  $jumpToTabbar('/pages/tabbar/user/index')
}

/**
 * 去退款详情
 * @param orderItem
 */
function goRefundDetail(orderItem) {
  $jump(`/pages_category_page2/orderModule/refundDetails?item=${ JSON.stringify(orderItem) }`)
}

/**
 * 跳转订单详情
 * @param orderItem
 */
function goOrderDesc(orderItem) {
  $jump(`orderDetails`, orderItem)
}

/**
 * 跳转店铺
 * @param id
 */
function goShop(id) {
  $jump(`../store/index?storeId=${ id }`)
}

/**
 * 申请售后
 * @param orderItem
 */
function goAfterSalesService(orderItem) {
  console.log(orderItem)
  $jump(`afterSaleApply`,orderItem)
}

/**
 * 立即评价
 * @param skuItem
 * @param orderId
 */
function goEvaluate( skuItem, orderId) {
  const params = {
    commentData: skuItem,
    orderId
  }
  $jump('../goodsModule/evaluate', params)
}

/**
 * 追加评价
 * @param orderIndex
 * @param commentId
 */
function goAdditionalEvaluation(orderIndex, commentId) {
  const params = {
    addCommentVOList: list.value[orderIndex],
    commentId,
    type: 1
  }
  $jump('../goodsModule/addEvaluate', params)
}

</script>

<style lang="scss" scoped>
@import "../../style/images";
.tabs {
  position: relative;
  z-index: 999;
}

page {
  width: 100%;
  height: 100%;
  background: #f6f6f6;
}

.nav-box-box {
  height: 88rpx;
  background: #f6f6f6;
  white-space: nowrap;
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  z-index: 10;
}

.nav-box-box .item {
  display: inline-view;
  padding: 0 30rpx;
  box-sizing: border-box;
  height: 88rpx;
  text-align: center;
  line-height: 88rpx;
  font-size: 30rpx;
  color: #666;
  font-weight: 500;
}

.nav-box-box .item.active text {
  display: inline-view;
  color: #ff7911;
  box-sizing: border-box;
  height: 88rpx;
  border-bottom: 2px solid #ff7911;
}

.order-list-box {
  padding: 20rpx 30rpx 0;
  box-sizing: border-box;
}

.order-list-box .item {
  margin-bottom: 20rpx;
  background: #fff;
  border-radius: 10rpx;
  min-height: 500rpx;
}

.order-list-top {
  height: 96rpx;
  padding: 0 30rpx;
  box-sizing: border-box;
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: space-between;
  border-bottom: 1px solid #eee;
}

.top-l {
  display: flex;
  flex-direction: row;
  align-items: center;
  min-width: 200rpx;
  min-height: 44rpx;
}

.shop-img {
  width: 36rpx;
  height: 36rpx;
  margin-right: 10rpx;
}

.shop-name {
  font-size: 30rpx;
  color: #333;
  font-weight: bold;
}

.arrow-img {
  margin-left: 15rpx;
  width: 25rpx;
  height: 25rpx;
}

.order-status {
  font-size: 32upx;
  color: #C5AA7B;
  font-weight: 400;
  min-width: 130rpx;
  min-height: 44rpx;
}

.order-info-box {
  padding: 0 30upx;
  box-sizing: border-box;

  .btnBox {
    width: 100%;
    justify-content: flex-end;

    .delIcon {
      width: 40rpx;
      height: 40rpx;
      background: $delListOrder no-repeat center center;
      background-size: contain;
    }
  }

  .flexSpBetween {
    justify-content: space-between;
  }
}

.order-info {
  border-bottom: 1px solid #eee;
}

.order-info-item {
  display: flex;
  flex-direction: row;
  padding: 20upx 0;
}

.product-img {
  width: 180upx;
  height: 180upx;
  margin-right: 30upx;
}

.info-box {
  flex: 1;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
}

.name-box {
  min-height: 60rpx;
  min-width: 200rpx;
  .product-name {
    font-size: 26upx;
    color: #333;
    height: 68upx;
    line-height: 34upx;
    display: -webkit-box;
    overflow: hidden;
    text-overflow: ellipsis;
    word-break: break-all;
    -webkit-box-orient: vertical;
    -webkit-line-clamp: 2;
  }
}

.price-sku-box {
  display: flex;
  flex-direction: row;
  justify-content: space-between;
  .box-h {
    min-width: 140rpx;
    min-height: 40rpx;
  }
}

.product-sku {
  font-size: 24upx;
  color: #999;
  min-height: 34rpx;
  min-width: 150rpx;
}

.product-price {
  font-size: 28upx;
  color: #333;
  font-weight: 400;
}

.product-price .fuhao {
  font-size: 28upx;
}

.product-num {
  display: inline-view;
  font-size: 28upx;
  margin-left: 20upx;
  color: #999;
}

.total-price-box {
  font-size: 26upx;
  color: #333;
  text-align: right;
  padding: 30upx 0;
  .skeleton-box {
    display: inline-block;
    min-height: 50rpx;
    min-width: 400rpx;
  }
}

.order-btn-box {
  padding: 20upx 0;
  display: flex;
  flex-direction: row;
  justify-content: flex-end;
  min-width: 190rpx;
  min-height: 60rpx;
}

.order-btn-box .btn {
  display: inline-view;
  width: 150upx;
  height: 56upx;
  text-align: center;
  line-height: 56upx;
  font-size: 26upx;
  color: #333;
  margin-left: 20upx;
}

.evaluate {
  height: 56upx;
  text-align: center;
  line-height: 56upx;
  font-size: 26upx;
  padding: 0 30upx;
  color: #C5AA7B;
  background: #333333;
}

.evaluate2 {
  height: 56upx;
  text-align: center;
  line-height: 56upx;
  font-size: 26upx;
  padding: 0 30upx;
  background: #333333;
  color: #C5AA7B;
}

.order-btn-box .btn.l {
  border: 2rpx solid #333333;
  color: #333;
}

.order-btn-box .btn.r {
  border: 2rpx solid #C5AA7B;
  color: #C5AA7B;
}

.emptyOrder-box {
  margin-top: 70upx;

  .emptyOrder-img {
    margin-top: 30%;
    width: 216upx;
    height: 152upx;
  }
}

.Put-box1 {
  .btn {
    text-align: center;
    margin-top: 40rpx;
    border: 2rpx solid #333333;
    height: 80rpx;
    line-height: 80rpx;
    width: 240rpx;
    color: #333333;
  }

  .submit {
    background-color: #333333;
    color: #FFEBC4;
  }
}

.pay-list-content {
  width: 100%;
  padding: 60rpx 30rpx 20rpx 30rpx;
  box-sizing: border-box;
  display: flex;
  flex-direction: column;
  align-items: center;
  cashire-list{
    width: 100%!important;
  }

  .pay-confirm-btn {
    width: 80%;
    height: 88rpx;
    margin-top: 15rpx;
    border-radius: 15rpx;
    color: #fff;
    background-color: #c5aa7b;
    display: flex;
    align-items: center;
    justify-content: center;
  }
}

</style>
<style scoped>
.container /deep/ .u-tab-item {
  color: #999999 !important;
}
</style>
