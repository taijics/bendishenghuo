<template>
  <!-- !loading -->
  <template v-if="!loading">
    <view
        class="container u-skeleton"
        @scroll="handlePageScroll"
    >
      <view class="">
        <!--  拼团滚动-->
        <view class="news-box">
          <view class="news-bg">
            <swiper
                class="goodsImgswiper-box"
                :vertical="true"
                :circular="true"
                interval="8000"
                duration="2000"
                :autoplay="true"
            >
              <swiper-item
                  v-for="(item, index) of broadCastList"
                  :key="index"
              >
                <view class="news-item flex-items">
                  <image
                      class="item-avatar"
                      :src="item.headImage"
                  ></image>
                  <view class="news-item-user">{{ item.name }}</view>
                  <view class="news-item-info">{{ item.timeStr }}</view>
                  <view
                      class="news-item-info"
                      v-if="item.type === 1"
                  >给了好评
                  </view>
                  <view
                      class="news-item-info"
                      v-if="item.type === 2"
                  >正在拼单
                  </view>
                  <view
                      class="news-item-info"
                      v-if="item.type === 3"
                  >拼单成功
                  </view>
                  <view
                      class="news-item-info"
                      v-if="item.type === 4"
                  >下单
                  </view>
                </view>
              </swiper-item>
            </swiper>
          </view>
        </view>

        <!-- 轮播图+分享+价格名称+活动倒计时+优惠券 -->
        <GoodActivityDetail
            ref="goodActivityDetail"
            :sku-select="selectedSku"
            :product-info="productData"
            :time-active-type="timeActiveType"
            :mark-tools="markTools"
            :shop-mark-tools="shopMarkTools"
            @activityEnd="handleActivityEnd"
            @couponClick="handleShowCoupon"
        />

        <!-- 发货 -->
        <view class="express-box flex-items flex-row fs24 u-skeleton-fillet">
          <label class="fs24 font-color-999 mar-right-20 ">发货</label>
          <image
              :src="`${VUE_APP_STATIC_URL}static/images/mapIcon.png`"
              v-if="productData.receive && productData.receive.receiveAdress"
          ></image>
          <label
              class="mar-left-10 mapName mar-right-30"
              v-if="productData.receive && productData.receive.receiveAdress"
          >{{
              productData.receive.receiveAdress
            }}</label>
          <label>快递：¥ {{ productData.logisticsPrice || 0 }}</label>
        </view>

        <!-- 选择SKU -->
        <view
            class="fs24 chooseSize-box flex-start"
            @click="handleShowGoodsSkuSelect(6)"
        >
          <view class="chooseSize-content flex-items flex-row flex-sp-between u-skeleton-fillet">
            <view class="flex-row-plus ">
              <label class="fs26   mar-left-30 font-color-999">选择</label>
              <view class="valueBox mar-left-20 flex-items">
                <view
                    class="mar-right-10"
                    v-for="(item, index) of currentSuk"
                    :key="index"
                >{{ item.skuText || '-' }}
                </view>
              </view>
            </view>
            <image
                class="arrow-icon"
                :src="`${VUE_APP_STATIC_URL}static/img/user/arrow.png`"
            ></image>
          </view>
        </view>

        <!--结合销售-->
        <CombinedSales
            :pid="productId"
            :productData="productData"
        ></CombinedSales>
        <!--拼团-->
        <view
            v-if="selectedSku.activityType === 1"
            class="borRig-line-20"
        ></view>
        <!-- 拼单列表 -->
        <view
            v-if="selectedSku.activityType === 1&&topThreeCollageOrders.length > 0"
            class="goodsDiscount"
        >
          <view class="questionTit mar-left-30 flex-items flex-row flex-sp-between">
            <label class="">这些人正在拼单</label>
            <view class="allMoreBox">
              <view
                  class="allMore"
                  @click="handleOpenGroupBookingList"
              >查看全部
              </view>
              <image
                  class="evaluateAllArrow-icon mar-left-10"
                  :src="`${VUE_APP_STATIC_URL}static/img/user/arrow.png`"
              ></image>
            </view>
          </view>
          <view
              class="groupBuy"
              v-for="(Gitem, index) in topThreeCollageOrders"
              :key="index"
          >
            <view
                class="groupBuyList"
                v-if="Gitem.time > 0"
            >
              <view class="groupBuyItem">
                <view class="leftAvatar">
                  <img
                      :src="Gitem.headImage"
                      alt=""
                  >
                  <span>{{ Gitem.name }}</span>
                </view>
                <view class="rightInfo">
                  <view
                      class="groupBuyTime"
                      style="width: 70%;"
                  >
                    <view class="needPeople flex-row-plus">还差<b>{{ Gitem.person }}人</b>拼成</view>
                    <view class="endDate">剩余{{ handleGetDownTime(Gitem.time) }}</view>
                  </view>
                  <view
                      class="groupBuyBtn"
                      @click="handleGoGroupBooking(Gitem.collageId)"
                  >和Ta拼
                  </view>
                </view>
              </view>
            </view>
          </view>
        </view>
        <!--  评价  -->
        <GoodEvaluateAndQuestion
            ref="goodEvaluateAndQuestion"
            class=" u-skeleton-fillet"
            :product-info="productData"
            :comment-list="commentList"
        />
        <!-- 店铺 -->
        <view class="inStore-box flex-items flex-row flex-sp-between  u-skeleton-fillet">
          <view class="flex-display flex-row">
            <view>
              <image
                  @click="handleJumpToStore"
                  class="inStore-logo default-img"
                  :src="productData.shopLogo"
              ></image>
            </view>
            <view class="flex-display flex-column mar-left-20">
              <label @click="handleJumpToStore">{{ productData.shopName }}</label>
              <view class="flex-display flex-row fs24 font-color-999 mar-top-5">
                <label>商品总类：{{ productData.classifyNumber }}</label>
                <label class="mar-left-30">已售：{{ productData.number }}件</label>
              </view>
            </view>
          </view>
          <view
              class="inStore-but"
              @click="handleJumpToStore"
          >去逛逛
          </view>
        </view>
        <!-- 详细信息 -->
        <view class="goodsDetails-box u-skeleton-fillet">
          <view class="goodsDetails-title">
            <view class="goodsDetails-Line"></view>
            <label class="goodsDetails-text">宝贝详情</label>
            <view class="goodsDetails-Line"></view>
          </view>
          <view class="goodsDetailsimg-box">
            <view class="">
              <rich-text :nodes="sellDescList"></rich-text>
            </view>
          </view>
        </view>
      </view>
      <!-- 底部购买 -->
      <view class="buygoods-box">
        <view
            class="buygoodsBut-box flex-row-plus"
            :style="{'height':(isIphone === true? 160:130)+'rpx'}"
        >
          <view class="btns_container">
            <view
                class="btns flex-column-plus"
                @click="handleJumpToStore"
            >
              <image
                  class="store-icon"
                  :src="`${VUE_APP_STATIC_URL}static/images/storeIcon.png`"
              ></image>
              <label class="fs22">店铺</label>
            </view>
            <!-- #ifdef MP-WEIXIN || APP-PLUS || H5 -->
            <view
                class="btns flex-column-plus mar-left-10"
                @click="flyToService"
            >
              <image
                  class="store-icon"
                  :src="`${VUE_APP_STATIC_URL}static/images/service-product-detail.png`"
              ></image>
              <label class="fs22">客服</label>
            </view>
            <!-- #endif -->
            <view
                class="btns flex-column-plus mar-left-10 flex-items Cart"
                @click="handleJumpToShopCart"
            >
              <view
                  class="cartAllNum"
                  v-if="allCartNum>0"
              >{{ allCartNum }}
              </view>
              <image
                  class="store-icon"
                  :src="`${VUE_APP_STATIC_URL}static/images/gouwuche.png`"
              ></image>
              <label class="fs22">购物车</label>
            </view>
          </view>
          <view class="btns_container">
            <view
                class="flex-row-plus offShelf"
                v-if="productData.shelveState === 0"
            >
              商品已下架
            </view>
            <view
                class="flex-row-plus flex-items"
                v-else-if="selectedSku.activityType === 1"
            >
              <view
                  class="joinShopCartBut"
                  @click=" handleShowGoodsSkuSelect(4)"
              >单独购买
              </view>
              <view
                  class="buyNowBut"
                  @click=" handleShowGoodsSkuSelect(3)"
              >我要开团
              </view>
            </view>
            <view
                class="flex-row-plus flex-items"
                v-else
            >
              <view
                  class="joinShopCartBut"
                  @click=" handleShowGoodsSkuSelect(1)"
              >加入购物车
              </view>
              <view
                  class="buyNowBut"
                  @click=" handleShowGoodsSkuSelect(2)"
              >立即购买
              </view>
            </view>
          </view>
        </view>
      </view>
      <!-- 回到顶部 -->
      <ReturnTop :returnTopFlag="returnTopFlag" />
      <!-- SKU选择器 -->
      <GoodSkuSelect
          ref="skuSelect"
          :product-data="productData"
          :selected-sku="selectedSku"
          :collage-id="collageId"
          @postSelectSku="selectSkuPostProcessor"
          @getCurrentSku="handleSelectSku"
          @changeCartNum="(num)=>allCartNum = num"
          @getInitSku="getInitSku"
      />
      <!-- 优惠券选择器 -->
      <coupon-popup
          ref="couponPopup"
          :markTools="markTools"
          :shopMarkTools="shopMarkTools"
          :setTop="topLeft"
          :currentActive="currentActive"
      ></coupon-popup>
      <!-- 拼单弹框 -->
      <u-popup
          class="popupDiscount"
          v-model="showGroupBuyList"
          mode="center"
          border-radius="14"
          close-icon-pos="top-right"
          close-icon-size="20"
      >
        <view class="popupDiscountTit">这些人正在拼单</view>
        <view class="groupBuy">
          <view class="groupBuyList">
            <scroll-view
                style="height: 480upx;"
                scroll-y
            >
              <view
                  class="groupBuyItem1"
                  v-for="(aitem,index) in selectedSku.collageOrders"
                  :key="index"
              >
                <view
                    class="leftAvatar"
                    v-if="aitem.time > 0"
                >
                  <img
                      :src="aitem.headImage"
                      alt=""
                  >
                  <view class="groupBuyTime">
                    <view class="needPeople"><span>{{ aitem.name }}</span>还差<b>{{ aitem.person }}人</b>
                    </view>
                    <view class="endDate">剩余{{ handleGetDownTime(aitem.time) }}</view>
                  </view>
                </view>
                <view
                    class="rightInfo"
                    v-if="aitem.time > 0"
                >
                  <view
                      class="groupBuyBtn"
                      @click="handleGoGroupBooking(aitem.collageId)"
                  >和Ta拼
                  </view>
                </view>
              </view>
            </scroll-view>
          </view>
        </view>
      </u-popup>
      <!-- 骨架屏 -->
      <!--    <Skeleton
              el-color="#efefef"
              bg-color="#fff"
              :loading="isFirstComeIn&&loading"
              :animation="true"
          ></Skeleton>-->
    </view>
  </template>
</template>

<script setup>
import Skeleton from "../../components/Skeleton";
import CombinedSales from "@/components/activities/combinedSales";
import CouponPopup from "@/components/goodsDetalils/coupon-popup.vue";
import { Services } from "@/utils/services";
import GoodEvaluateAndQuestion from "./components/GoodEvaluateAndQuestion";
import GoodActivityDetail from "./components/GoodActivityDetail";
import GoodSkuSelect from "./components/GoodSkuSelect";
import { TimeFormatting } from "@/utils/timeUtil";
import { request } from "@/utils/request";
import API from "@/config/api";
import { inject, nextTick, onBeforeUnmount, ref } from "vue";
import { onLoad, onPageScroll, onUnload } from '@dcloudio/uni-app';
import { useLoading } from "@/hooks/useLoading";
import { VUE_APP_STATIC_URL } from "@/config/api";
import ProductSkeleton from "./components/ProductSkeleton.vue";

const $store = inject('$store')
const $getJumpParam = inject('$getJumpParam')
const $jump = inject('$jump')
const $jumpToTabbar = inject('$jumpToTabbar')
// ========================================== ref ==================================================
const goodActivityDetail = ref()
const skuSelect = ref()
const couponPopup = ref()
const goodEvaluateAndQuestion = ref()

// ========================================== data =================================================
const isFirstComeIn = ref(true);
const loading = ref(true);
const isIphone = ref("");
const returnTopFlag = ref(false); // 回到顶部
const productId = ref(''); // 商品ID，有可能屎缓存数据
const shopGroupWorkId = ref(null); // 拼团数据ID
const topThreeCollageOrders = ref({}); // 当前商品拼单数据
const collageId = ref(0); // 去拼团时的拼单ID
const broadCastList = ref([]); // 拼团滚动数据
const showGroupBuyList = ref(false); // 是否展示拼单弹窗
const shopGroupWorkTicker = ref(null); // 拼团倒计时定时器
const paramSkuId = ref(null); // 秒杀商品ID
const productData = ref({}); // 商品详情
const selectedSku = ref({}); // 当前选中SKU
const currentSuk = ref([]); // 选中的SKU（子组件给当前页面做数据渲染）
const buyNum = ref(1); // 当前选取的SKU购买数量
const storeId = ref(''); // 店铺ID
const shopId = ref('');
const commentList = ref([]); // 商品评价列表
const sellDescList = ref(''); // 商品详情长图（富文本）
const timeActiveType = ref(true); // 是否开启活动（非则预热）
const btnType = ref(1); // 拉起SKU窗口的按钮类型 1加入购物车 2立即购买 3开团 4单独购买 6选择SKU
const allCartNum = ref(0); // 购物车数量
const markTools = ref([]);// 平台优惠券
const shopMarkTools = ref([]); // 店铺优惠券
const currentActive = ref(0);// 优惠券选项卡类型
const topLeft = ref(0); // 距离顶部（返回顶部使用）
const pointOption = ref({
  inTime: null,
  data: {
    eventType: 1,
    productIds: '',
  }
})// 埋点对象


// ================================================ methods ================================================
/**
 * 页面滚动事件
 * @param e
 */
function handlePageScroll(e) {
  topLeft.value = e.scrollTop
}


// ================================================ SKU相关 ================================================

/**
 * 选取sku
 * @param skuObj:{currentSuk:object,selectedSku:object,buyNum:number}
 */
function handleSelectSku(skuObj) {
  currentSuk.value = skuObj.currentSku
  selectedSku.value = skuObj.skuItem
  buyNum.value = skuObj.buyNum
}

/**
 * 打开SKU弹窗
 * @param type 1加入购物车 2立即购买 3开团 4单独购买 6选择SKU
 */
function handleShowGoodsSkuSelect(type) {
  // todo 加入未加载完成拒绝点击逻辑
  if(loading.value)return
  // 为type情况时，绝不可能为和他人拼单
  collageId.value = 0
  skuSelect.value.btnType = type
  skuSelect.value.goodsDetailShowFlag = true
}


/**
 * 选择sku后置方法
 * 判断有无活动等操作
 */
function selectSkuPostProcessor() {
  const ifEnable = selectedSku.value['ifEnable']
  if (selectedSku.value.activityType === 1 && ifEnable === 0) {
    topThreeCollageOrders.value = selectedSku.value.collageOrders.slice(0, 3)
  }
  if ([1, 2, 3, 4, 5].includes(selectedSku.value.activityType) && ifEnable === 0) {
    goodActivityDetail.value.handleGetCountDownNumber(selectedSku.value.endTime)
  }
  timeActiveType.value = ifEnable === 0;
}

/**
 * 活动商品时间到后置方法
 * 供GoodActivityDetail组件调用
 */
function handleActivityEnd() {
  selectedSku.value.activityType = 0
  location.reload()
}

// ================================================ 拼团相关 ================================================
/**
 * 获取拼团滚动数据
 */
async function handleGetGroupBookingRollList() {
  let param = {
    productId: productId.value,
    shopGroupWorkId: shopGroupWorkId.value ?? undefined,
  }
  const res = await request(API.GetBroadCastList, param, 'GET')
  broadCastList.value = res.data
}

/**
 * 设置拼团倒计时
 */
function handleSetDownTime() { //这个计时器是每秒减去数组中指定字段的时间
  let productHaveCollageOrder = false
  // 判断sku组合中是否存在拼单
  const skuCollects = productData.value.map
  for (const skuCollectItemKey in skuCollects) {
    const collageOrders = skuCollects[skuCollectItemKey]['collageOrders']
    if (collageOrders && collageOrders.length > 0) {
      productHaveCollageOrder = true
      break
    }
  }
  if (!productHaveCollageOrder) return

  shopGroupWorkTicker.value = setInterval(() => {
    for (const skuCollectItemKey in skuCollects) {
      const collageOrders = skuCollects[skuCollectItemKey]['collageOrders']
      if (collageOrders && collageOrders.length > 0) {
        collageOrders.forEach(collageItem => {
          collageItem.time > 0 ? collageItem.time -= 1000 : ''
        })
      }
    }
  }, 1000);
}

/**
 * 和他人拼单
 * @param collageIds 已存在的拼团订单ID
 */
function handleGoGroupBooking(collageIds) {
  showGroupBuyList.value = false
  collageId.value = collageIds
  skuSelect.value.goodsDetailShowFlag = true
}


/**
 * 根据时间戳获取格式化时间（处理计时器）
 * @param remainMillSecs 毫秒，还有多久结束
 * @return {string}
 */
function handleGetDownTime(remainMillSecs) {
  if (remainMillSecs <= 0) {
    clearInterval(shopGroupWorkTicker.value)
    shopGroupWorkTicker.value = null
    handleGetProductDetail()
  }
  const timeFormatting = TimeFormatting(remainMillSecs / 1000);
  return `${ timeFormatting.hour }:${ timeFormatting.min }:${ timeFormatting.sec }`;
}


/**
 * 打开拼团列表
 */
function handleOpenGroupBookingList() {
  if (topThreeCollageOrders.value.length > 0) {
    showGroupBuyList.value = true
  } else {
    uni.showToast({
      title: "还没有人拼单，快去拼单吧！",
      icon: "none"
    })
  }
}


// ================================================ 跳转相关 ================================================
/**
 * 跳转到购物车
 */
function handleJumpToShopCart() {
  $jumpToTabbar('../../pages/tabbar/cart/index')
}

/**
 * 跳转到店铺
 */
function handleJumpToStore() {
  $jump(`../store/index?storeId=${ shopId.value }`)
}

/**
 * 打开优惠券弹窗
 */
function handleShowCoupon() {
  console.log(couponPopup)
  couponPopup.value.showActivity = true
}

const {hideLoading} = useLoading()

/**
 * 获取商品详情
 */
async function handleGetProductDetail() {
  loading.value = true
  try {
    console.log(paramSkuId.value)
    let postData = {
      shopId: shopId.value,
      productId: productId.value,
      skuId: paramSkuId.value,
      terminal: 1
    }
    const res = await request(API.QueryProductDetail, postData, "GET")
    isFirstComeIn.value = false
    loading.value = false
    productData.value = res.data
    markTools.value = res.data.markTools //平台优惠券
    shopMarkTools.value = res.data.shopMarkTools //店铺优惠券
    currentActive.value = markTools.value?.length === 0 && shopMarkTools.value.length > 0 ? 1 : 0
    //处理单规格商品，如果是单款式商品，需要特殊处理productData.names
    const skuCollectionList = productData.value.map
    const skuCollectionListKeys = Object.keys(skuCollectionList)
    if (skuCollectionListKeys.length === 1 && skuCollectionListKeys[0] === '单款项') {
      productData.value.names[0].values.push({
        skuValue: productData.value.names[0].skuName,
        valueCode: '单款项'
      })
    }

    //如果sku的图像为空，设置为商品的图像
    for (const key in skuCollectionList) {
      if (!skuCollectionList[key].image) {
        skuCollectionList[key].image = productData.value.images[0]
      }
    }

    // 评价
    commentList.value = res.data.comments
    // 宝贝详情
    let result = res.data.text.replace(/(<img[^>]*?)\sstyle=""/gi, '$1');
    sellDescList.value = result.replace(/\<img/gi,
        '<img style="max-width:100%;height:auto" ')

    //渲染商详之后，如果参数传了skuId，则选中该skuId，否则选中第一个规格
    // await nextTick(async () => {
    //
    // })
  } finally {
    loading.value = false
    hideLoading()
  }
}
async function getInitSku() {
  if (paramSkuId.value) {
    skuSelect.value.handleSelectBySkuId(paramSkuId.value)
  } else {
    // 默认选中第0个
    for (const skuRowItem of productData.value.names) {
      skuSelect.value.handleClickSkuItem(skuRowItem.nameCode, skuRowItem.values[0].valueCode)
    }
  }
  //如果是拼团，设置拼团id
  if (productData.value.activityType === 1) {
    shopGroupWorkId.value = productData.value.shopGroupWorkId
    await handleGetGroupBookingRollList()
    handleSetDownTime();
  }
  await goodEvaluateAndQuestion.value.handleGetProblemList()
}

/**
 * 绑定分销关系
 * @param salesId 分销员ID
 * @param storeId 店铺ID
 */
function bindSalesCustomer(salesId, storeId) {
  //如果已登录，静默绑定客户关系，否则跳转到登录页面
  if (!uni.getStorageSync('storage_key')) {
    uni.setStorageSync('salesId', salesId)
    uni.setStorageSync("shopId", storeId)
    uni.navigateTo({
      url: '../../pages_category_page2/userModule/login'
    })
    return
  }
  request(API.BindSalesCustomer, {
    shopId: storeId,
    distributorId: salesId
  }, 'POST').then(res => {
    console.log('分销关系绑定成功！')
  })
}

/**
 * 打开客服
 * @return {Promise<void>}
 */
async function flyToService() {
  (await Services(shopId.value)).flyToService()
}


// =============================================== 生命周期 ============================================
onLoad((options) => {
  // 页面滚动条归0，不然骨架屏有问题
  uni.pageScrollTo({
    scrollTop: 0,
    duration: 0
  })
  productData.value = {
    logisticsPrice: 0,
    images: ['123', '123', '123'],
    productName: '....',
    ifCollect: 1,
  }
  selectedSku.value = {
    activityType: 0,
    originalPrice: 0
  }
  if (options.detail) {
    options = $getJumpParam(options)
  }
  isFirstComeIn.value = true
  loading.value = true
  let salesId = null
  pointOption.value.inTime = new Date().getTime()
  isIphone.value = getApp().globalData.isIphone;
  let item = getApp().globalData.productShareItem
  if (item) {
    const item = getApp().globalData.productShareItem
    shopId.value = parseInt(item.shopId)
    productId.value = item.productId
    paramSkuId.value = item.skuId
    salesId = parseInt(item.salesId)
    getApp().globalData.productShareItem = undefined
  } else {
    shopId.value = parseInt(options.shopId)
    productId.value = options.productId
    paramSkuId.value = options.skuId
    salesId = parseInt(options.salesId)
  }
  // 判断是否是拼团
  if (options.shopGroupWorkId) {
    shopGroupWorkId.value = options.shopGroupWorkId
  }
  handleGetProductDetail()
  // 绑定分销关系
  salesId && shopId.value ? bindSalesCustomer(salesId, shopId.value) : ''
  allCartNum.value = uni.getStorageSync('allCartNum')
  if (allCartNum.value > 99) {
    allCartNum.value = '...'
  }
})
onUnload(() => {
  // 判断是否要埋点
  const nowTime = new Date().getTime()
  if (nowTime - pointOption.value.inTime >= 5000) {
    // 埋点
    pointOption.value.data.productIds = productId.value
    $store.dispatch('doPointer', pointOption.value.data)
  }
  // 销毁平团倒计时计时器
  if (shopGroupWorkTicker.value) {
    clearInterval(shopGroupWorkTicker.value)
    shopGroupWorkTicker.value = null
  }
})

onBeforeUnmount(()=>{
  hideLoading()
})

onPageScroll(e => {
  returnTopFlag.value = e.scrollTop > 600;
  topLeft.value = e.scrollTop
})
</script>
<style>
.page {
  background-color: #F7F7F7;
}
</style>
<style
    scoped
    lang="scss"
>
@import "../../style/images";
.page {
  background-color: #F7F7F7;
}

.news-box {
  position: fixed;
  left: 20rpx;
  top: 200rpx;
  z-index: 9999;

  .news-bg {
    width: 450rpx;
    height: 70rpx;
    overflow: hidden;

    .news-item {
      background: rgba(0, 0, 0, 0.75);
      border-radius: 16rpx;
      height: 70rpx;
      color: #FFFFFF;
      font-size: 24rpx;
      padding: 0 20rpx;
      width: 450rpx;

      .item-avatar {
        width: 50rpx;
        height: 50rpx;
        border-radius: 50%;
        margin-right: 20rpx;
      }
    }
  }
}


.tabsbox {
  width: 100%;
  margin-top: 20rpx;
  background-color: #FFFFFF;
}


.checkimg {
  width: 40rpx;
  height: 40rpx;
  margin-right: 30rpx;
}

.container {
  padding-bottom: 180upx;

  .arrow-icon {
    width: 16rpx;
    height: 24rpx;
  }

  .goodgDes-box {
    background-color: #FFFFFF;
    width: 100%;
    padding-bottom: 25rpx;

    .priceBuyNum-box {
      width: 677rpx;
      margin-top: 30rpx;
    }

    .nameContainer {
      display: flex;

      .goodsName-box {
        width: 677rpx;
        height: 85rpx;

        .img618-cion {
          width: 70rpx;
          height: 36rpx;
        }
      }

      .collectBox {
        width: 80rpx;
        margin: 0 30rpx 0 15rpx;
        display: flex;
        flex-direction: column;
        justify-content: center;
        align-items: center;
      }

      .store-icon {
        width: 48rpx;
        height: 48rpx;
      }
    }

    .discounts-box {
      margin-top: 20rpx;

      .discounts-text {
        margin-left: 10rpx;
        color: #FF7800;
        background-color: #FFE4CC;
        padding: 6rpx 12rpx;
        border-radius: 4rpx;
      }
    }

    .activity-box {
      display: flex;
      flex-direction: row;
      justify-content: center;
      align-items: flex-end;
      border-top: 1upx solid #EDEDED;

      .activity-content {
        width: 614rpx;
        padding-top: 20rpx;

        .activity-text {
          color: #FF7700;
          border: 1rpx solid #FF7700;
          padding: 6rpx 23rpx;
        }

        .coupon-arrow {
          width: 16rpx;
          height: 24rpx;
          margin-left: 15rpx;
        }
      }
    }
  }

  .express-box {
    height: 100rpx;
    background-color: #FFFFFF;
    padding-left: 30rpx;
    border-top: 12rpx solid #F8F8F8;
    border-bottom: 12rpx solid #F8F8F8;

    image {
      width: 21rpx;
      height: 27rpx;
    }

    .expressSite-icon {
      width: 30rpx;
      height: 30rpx;
    }

    .mapName {
      position: relative;

      &:before {
        content: '';
        width: 2rpx;
        height: 30rpx;
        background: #CCCCCC;
        display: block;
        position: absolute;
        right: -16rpx;
        top: 5rpx;
      }
    }
  }

  .chooseSize-box {
    height: 90rpx;
    background-color: #FFFFFF;
    margin: 10rpx 0;

    .chooseSize-content {
      width: 100%;
      image{
        margin-right: 30rpx;
      }
    }
  }

  .questionTit {
    height: 90rpx;
    border-bottom: 1rpx solid #EEEEEE;
    margin-right: 35rpx;
    color: #333333;
    font-size: 30rpx;

    .allMoreBox {
      display: flex;
      align-items: center;
      color: #999999;
      font-size: 24rpx;

      .evaluateAllArrow-icon {
        width: 18rpx;
        height: 24rpx;
      }
    }
  }

  .shopEvaList {
    display: flex;
    padding: 30rpx;
    flex-wrap: wrap;
    border-bottom: 20rpx solid #EEEEEE;

    .shopEvaItem {
      padding: 0 14rpx;
      height: 60rpx;
      background: #ffe4cc;
      border-radius: 6rpx;
      line-height: 60rpx;
      text-align: center;
      font-size: 28rpx;
      color: #666666;
      margin: 0 20rpx 20rpx 0;
    }
  }

  .storeEvaluate-box {
    background-color: #FFFFFF;
    margin-top: 20rpx;

    .storeEvaluate {
      width: 690rpx;
      padding: 20rpx 0;
      border-bottom: 1rpx solid #EDEDED;
    }

    .storeEvaluateTag-box {
      margin-top: 10rpx;
      margin-left: 10rpx;
      padding-bottom: 30rpx;
      display: flex;
      flex-wrap: wrap;

      .storeEvaluateTag-text {
        background-color: #FFE4CC;
        border-radius: 6rpx;
        padding: 16rpx 14rpx;
        color: #656565;
        margin-left: 20rpx;
        margin-top: 20rpx;
      }
    }
  }

  .inStore-box {
    background-color: #FFFFFF;
    margin-top: 20rpx;
    padding: 20rpx 30rpx;

    .inStore-logo {
      width: 70rpx;
      height: 70rpx;
    }

    .inStore-but {
      width: 140rpx;
      height: 60rpx;
      line-height: 60rpx;
      text-align: left;
      font-size: 24rpx;
      color: #FFEBC4;
      background: #333333;
      padding-left: 20rpx;
      position: relative;

      &:before {
        content: '';
        width: 60rpx;
        height: 60rpx;
        background: $smallArrowR no-repeat center center;
        background-size: contain;
        display: block;
        position: absolute;
        right: 0;
      }
    }
  }

  .goodsDetails-box {
    background-color: #FFFFFF;
    margin-top: 20rpx;
    padding: 20rpx 30rpx;

    .goodsDetails-title {
      display: flex;
      flex-direction: row;
      align-items: center;

      .goodsDetails-Line {
        width: 265rpx;
        border-bottom: 1rpx solid #EDEDED;
      }

      .goodsDetails-text {
        padding: 0 22rpx;
      }
    }

    .goodsDetailsimg-box {
    }
  }

  .priceExplain-box {
    background-color: #FFFFFF;
    margin-top: 20rpx;
    padding: 20rpx 30rpx;

    .priceExplain-title {
      display: flex;
      flex-direction: row;
      align-items: center;

      .priceExplain-Line {
        width: 265rpx;
        border-bottom: 1rpx solid #EDEDED;
      }

      .priceExplain-text {
        padding: 0 22rpx;
      }
    }

    .priceExplain-dot {
      width: 9rpx;
      height: 9rpx;
      border: 1rpx solid #FF7700;
      border-radius: 50%;
      background-color: #FF7700;
    }
  }

  .buygoods-box {
    position: fixed;
    bottom: 0rpx;
    box-sizing: border-box;
    z-index: 999;

    .groupByInfo {
      background: #fffbe9;
      padding: 0 30rpx;
      height: 80rpx;

      .groupByInfoBox {
        height: 80rpx;
      }

      .groupByLeft {
        .groupByAvatar {
          margin-right: 15rpx;
        }

        img {
          width: 50rpx;
          height: 50rpx;
        }

        .name {
          font-size: 24rpx;
        }

        .groupByNum {
          margin-right: 10rpx;
        }

        .groupByTime {
          color: #333333;
        }
      }

      .groupByBtn {
        height: 60rpx;
        background: #333333;
        color: #FFEBC4;
        font-size: 14rpx;
        line-height: 60rpx;
        text-align: center;
        padding: 0 20rpx;
      }
    }

    .buygoodsBut-box {
      background-color: #FFFFFF;
      width: 750rpx;
      padding: 20rpx 32rpx;
      box-shadow: 0rpx 0rpx 10rpx 1rpx #EDEDED;
      box-sizing: border-box;
      display: flex;
      justify-content: space-between;

      .btns_container {
        display: flex;
        align-items: center;
      }

      .btns {
        width: 80rpx;
      }

      .Cart {
        position: relative;

        .cartAllNum {
          position: absolute;
          width: 30rpx;
          height: 30rpx;
          line-height: 30rpx;
          text-align: center;
          font-size: 17rpx;
          color: #FFFFFF;
          background: #C5AA7B;
          border-radius: 50%;
          opacity: 1;
          z-index: 999;
        }

        // #ifdef APP-PLUS
        .cartAllNum {
          right: -6rpx;
          top: -6rpx;
        }

        // #endif
        /* #ifdef H5 */
        .cartAllNum {
          right: -10rpx;
          top: -6rpx;
        }

        /* #endif */
        /* #ifdef MP-WEIXIN */
        .cartAllNum {
          right: -3rpx;
          top: 0;
        }

        /* #endif */
      }

      .store-icon {
        width: 48rpx;
        height: 48rpx;
      }

      .joinShopCartBut {
        width: 190rpx;
        height: 80rpx;
        background-color: #FFFFFF;
        color: #333333;
        font-size: 28rpx;
        line-height: 80rpx;
        border: 2rpx solid #333333;
        text-align: center;
        margin-left: 40rpx;
        box-sizing: border-box;
      }

      .buyNowBut {
        width: 190rpx;
        height: 80rpx;
        background: #333333;
        color: #FFEBC4;
        font-size: 28rpx;
        line-height: 80rpx;
        text-align: center;
        margin-left: 16rpx;
      }

      .offShelf {
        background: #b7b7b7;
        border-radius: 50rpx;
        width: 360rpx;
        margin-left: 50rpx;
        line-height: 80rpx;
        height: 80rpx;
        justify-content: center;
        color: #333333;
      }
    }
  }
  .parameterShow-box {
    .parameter-title {
      width: 100%;
      text-align: center;
      padding-bottom: 36rpx;
    }

    .parameter-modle {
      width: 690rpx;
      padding-bottom: 36rpx;
      font-size: 26rpx;
    }

    .parameterTruebut-box {
      background-color: #FFFFFF;
      padding: 20rpx 0;

      .parameterTruebut {
        width: 690rpx;
        height: 80rpx;
        background-image: linear-gradient(135deg, #FFA100 10%, #FF7911 100%);
        color: #FFFFFF;
        border-radius: 40rpx;
        line-height: 80rpx;
        text-align: center;
        font-size: 26rpx;
      }
    }
  }

  .couponShow-box {
    .couponShow {
      z-index: 333;
      height: 1000rpx;

      .couponTitle-box {
        width: 100%;
      }

      .coupon-title-active {
        color: #FF7700;
        border-bottom: 2rpx solid #FF7700;
        padding-bottom: 30rpx;
      }

      .usableCoupon-content {
        padding: 30rpx 0;

        .usableCoupon-box {
          width: 690rpx;
          height: 140rpx;
          border-radius: 10rpx;
          background-color: #FFE9D8;

          .immediateUse-but {
            color: #FF7800;
            border-radius: 30rpx;
            padding: 0 40rpx;
            border-left: 3rpx solid #EBD7C7;
            height: 140rpx;
            border-radius: 60rpx;
            line-height: 140rpx;
            font-weight: bold;
          }
        }
      }
    }
  }

  .succeedShow-box {
    position: absolute;
    top: 220rpx;
    left: 185rpx;

    .succeedShow {
      background-color: #7F7F7F;
      width: 380rpx;
      height: 280rpx;
      border-radius: 10rpx;
      opacity: 0.8;

      .couponSucceedImg {
        width: 200rpx;
        height: 130rpx;
      }
    }
  }

}

.activity-box {
  display: flex;
  flex-direction: column;
  width: 100%;
  height: 100%;

  .title-box {
    width: 100%;
    height: 100upx;
    display: flex;
    flex-direction: row;
    align-items: center;
    justify-content: center;
    position: relative;
    border-bottom: solid 1px #EEEEEE;
  }
}

.activity-coupon-box {
  display: flex;
  flex-direction: column;
  width: 100%;
  overflow: auto;
  flex: 1;
}

.content-box {
  width: 100%;
  box-sizing: border-box;
  display: flex;
  flex-direction: column;
  padding: 30rpx;
}

.tag-box {
  width: 100%;
  box-sizing: border-box;
  height: 80rpx;
  line-height: 80rpx;
  font-size: 28rpx;
  font-weight: 500;
  color: #FF7911;
}

.label-lingqu {
  width: 100%;
  font-weight: 500;
  color: rgba(51, 51, 51, 1);
}

.coupon-item {
  width: 690rpx;
  height: 120rpx;
  border-radius: 10rpx;
  display: flex;
  flex-direction: row;
  justify-content: space-between;
  align-items: center;
  margin-top: 20rpx;
  flex-shrink: 0;
  background-color: #FFE9D8;
}

.money-box {
  width: 160rpx;
  box-sizing: border-box;
  padding-left: 30rpx;
  font-weight: 500;
  color: #FF7911;
}

.info-box {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  color: rgba(255, 121, 17, 1);
}

.receive-btn {
  width: 200rpx;
  height: 120rpx;
  background: rgba(255, 233, 216, 1);
  box-shadow: 0px 0px 5rpx 0px rgba(102, 102, 102, 0.35);
  line-height: 120rpx;
  text-align: center;
  font-size: 28rpx;
  font-weight: bold;
  color: rgba(255, 121, 17, 1);
  border-bottom-right-radius: 10rpx;
  border-top-right-radius: 10rpx;
  border-top-left-radius: 120rpx;
  border-bottom-left-radius: 120rpx;
}

.received {
  background: #f1f1f1;
  color: #999;
}


.canvas-box {
  display: block;
  position: absolute;
  top: 100rpx;
}

.sceneMarketingBox {
  width: 100%;
  background: $sceneMarketingDetailsIcon no-repeat center;
  padding: 20rpx 30rpx;
  background-size: cover;
  display: flex;
  justify-content: space-between;
  align-items: center;
  .sceneNameBox {
    width: 220rpx;
    text-align: center;
    color: #C83732;
    font-size: 20rpx;
  }
}


.goodsDiscount {
  .groupBuy {
    .groupBuyList {
      .groupBuyItem {
        padding: 0 30rpx;
        height: 116rpx;
        display: flex;
        align-items: center;
        justify-content: space-between;
        border-bottom: 1rpx solid #EEEEEE;

        .leftAvatar {
          display: flex;
          align-items: center;
          width: 50%;

          img {
            width: 72rpx;
            height: 72rpx;
            margin-right: 10rpx;
            border-radius: 50%;
          }
        }

        .rightInfo {
          display: flex;
          align-items: center;
          width: 50%;

          .groupBuyTime {
            .needPeople {
              font-size: 28rpx;
              color: #333333;
              margin-bottom: 10rpx;
              font-weight: 400;

              b {
                color: #C5AA7B;
                font-weight: 400;
              }
            }

            .endDate {
              color: #666666;
            }
          }

          .groupBuyBtn {
            width: 140rpx;
            height: 60rpx;
            line-height: 60rpx;
            background: #333333;
            text-align: center;
            color: #FFEBC4;
            font-size: 24rpx;
          }
        }
      }
    }
  }
}

.popupDiscount {
  padding-bottom: 70rpx;

  .popupDiscountTit {
    font-size: 36rpx;
    color: #333333;
    height: 105rpx;
    line-height: 105rpx;
    text-align: center;
    border-bottom: 1rpx solid #EEEEEE;
  }

  .groupBuy {
    padding-bottom: 80rpx;

    .groupBuyList {
      .groupBuyItem1 {
        padding: 0 30rpx;
        height: 116rpx;
        display: flex;
        align-items: center;
        justify-content: space-between;
        border-bottom: 1rpx solid #EEEEEE;

        .leftAvatar {
          display: flex;
          align-items: center;

          img {
            width: 72rpx;
            height: 72rpx;
            margin-right: 10rpx;
            border-radius: 50%;
          }

          .groupBuyTime {
            margin-right: 80rpx;
            margin-bottom: 10rpx;
            width: 320rpx;

            .needPeople {
              font-size: 26rpx;
              color: #333333;

              span {
                color: #333333;
                padding-right: 10rpx;
              }

              b {
                color: #C5AA7B;
                font-weight: 400;
              }
            }

            .endDate {
              color: #333333;
              opacity: 0.7;
              font-size: 24rpx;
            }
          }
        }

        .rightInfo {
          display: flex;
          align-items: center;

          .groupBuyBtn {
            width: 140rpx;
            height: 70rpx;
            line-height: 70rpx;
            background: #333333;
            text-align: center;
            color: #FFEBC4;
            font-weight: 400;
          }
        }
      }
    }
  }
}

.combination {
  padding: 0 20rpx;

  .combinationList {
    width: 100%;
    height: 680rpx;
    background: #333333;
    box-shadow: 0 20rpx 30rpx rgba(0, 0, 0, 0.3);
    border-radius: 20rpx;

    .combinationTitle {
      padding: 32rpx 20rpx 0 30rpx;

      image {
        width: 211rpx;
        height: 33rpx;
      }

      .combinationPrice {
        padding: 0 20px;
        height: 50rpx;
        background: linear-gradient(90deg, #C83732 0%, #E25C44 100%);
        box-shadow: 0 6rpx 12rpx rgba(233, 0, 0, 0.3);
        border-radius: 26rpx;
        line-height: 50rpx;
        text-align: center;
        color: #FFFFFF;
        opacity: 0.8;
      }
    }

    .buyBtn {
      width: 96%;
      height: 84rpx;
      line-height: 84rpx;
      border: 2rpx solid rgba(0, 0, 0, 0);
      background: linear-gradient(88deg, #C5AA7B 0%, #FFEBC4 100%);
      text-align: center;
      color: #333333;
      margin: 0 auto;
    }
  }
}
</style>
