<template>
  <view>
    <!-- 提交订单 -->
    <view v-if="ifShow">
      <view class="content">
        <view
            class="address-box"
            @click="addAddressTap"
        >
          <image
              :src="`${VUE_APP_STATIC_URL}static/images/orderAddress.png`"
              class="address-img"
          ></image>
          <!-- 有地址的 -->
          <view
              class="address-r"
              v-if="userAddressInfo.receiveName"
          >
            <view class="address-name-box">
              <text>{{ userAddressInfo.receiveName }}</text>
              <text class="phone">{{ userAddressInfo.receivePhone }}</text>
            </view>
            <view class="address-info">
              <text>{{ userAddressInfo.receiveAdress }} {{ userAddressInfo.address }}</text>
            </view>
          </view>
          <!-- 没有地址的 -->
          <view
              class="address-r"
              v-else
          >
            <text>你还没有收货地址哦，点击这里添加</text>
          </view>
          <image
              :src="`${VUE_APP_STATIC_URL}static/images/greyArrow.png`"
              class="arrow-right-img"
          ></image>
        </view>
        <view class="order-list-box">
          <view
              class="item"
              v-for="(item, sIndex) in settlement.shops"
              :key="item.shopId"
          >
            <view class="order-list-top">
              <view class="top-l">
                <image
                    :src="`${VUE_APP_STATIC_URL}static/images/orderStoreIcon.png`"
                    class="shop-img"
                >
                </image>
                <text class="shop-name">{{ item.shopName }}</text>
              </view>
            </view>
            <view class="order-info-box">
              <view class="order-info">
                <view
                    class="order-info-item"
                    v-for="(cItem, index) in item.skus"
                    :key="cItem.productId"
                >
                  <image
                      :src="cItem.image"
                      class="product-img"
                  ></image>
                  <view class="info-box">
                    <text class="product-name">{{ cItem.productName }}</text>
                    <view class="product-sku">
                      <view v-for="(vItem, index) in cItem.values">
                        <label class="mar-left-20">{{ vItem }}</label>
                      </view>
                    </view>
                    <view class="price-sku-box flex-display flex-sp-between">
                      <view class="product-price">
                        <text class="fuhao">￥</text>
                        {{ cItem.price }}
                      </view>
                      <view class="product-num">x {{ cItem.number }}</view>
                    </view>
                  </view>
                </view>
                <view
                    v-if="item.receiveNotMatch"
                    class="adressTips"
                >当前地址不支持配送，可更换其他地址试试
                </view>
                <view class="delivery-way-box">
                  <view>
                    <view class="item">
                      <view class="flex-items">
                        <text>配送方式</text>
                      </view>
                      <view class="flex-row-plus flex-items">
                        <text v-if="item.distribution.distributionPrice > 0">快递 ¥
                          {{ item.distribution.distributionPrice }}
                        </text>
                        <text v-else>快递 免邮</text>
                      </view>
                    </view>
                    <view class="flex-item">
                      <text
                          class="font-color-666 fs24"
                          v-for="(hItem, hIndex) of item.skuDiscountInfoMap"
                      >{{ hItem[0] }}
                      </text>
                    </view>
                  </view>
                </view>
              </view>
              <view
                  class="discount-item1"
                  v-if="item.shopCoupons.length>0"
                  @click="showShopCoupons(item,sIndex)"
              >
                <view class="discount-label">店铺优惠</view>
                <view class="discount-info-box flex-items">
                  <view
                      class="discount-info2"
                      v-if="item.currentCoupon && item.currentCoupon.couponType === 1"
                  >
                    -￥{{ item.currentCoupon.reduceMoney }}
                  </view>
                  <view
                      class="discount-info2"
                      v-if="item.currentCoupon && item.currentCoupon.couponType === 2"
                  >
                    {{ item.currentCoupon.reduceMoney }}折券
                  </view>
                  <image
                      class="discount-img"
                      :src="`${VUE_APP_STATIC_URL}static/images/arrowRight.png`"
                  ></image>
                </view>
              </view>
              <view class="order-total-box">
                <text class="total-num">共{{ item.number }}件</text>
                <text class="total-num ml10">总计</text>
                <text
                    class="total-price ml10"
                    v-if="item.totalAfterDiscount > 0"
                >
                  ¥{{
                    (parseFloat(item.totalAfterDiscount) + parseFloat(item.distribution.distributionPrice || 0)).toFixed(2)
                  }}
                </text>
                <text
                    class="total-price ml10"
                    v-else
                >¥0.00
                </text>
              </view>
            </view>
          </view>

        </view>
        <view
            class="discount-item"
            @click="showDiscount"
        >
          <view class="discount-label">平台优惠</view>
          <view class="discount-info-box flex-items">
            <view
                class="discount-info2"
                v-if="promotionInfoDTO.couponId"
            >
              <text v-if="promotionInfoDTO.couponType === 2">{{ promotionInfoDTO.reduceMoney }}折</text>
              <text v-else> -￥{{ promotionInfoDTO.reduceMoney | clip2Decimal }}</text>
            </view>
            <view
                class="discount-info1"
                v-else-if="couponsList.length<1"
            >无
            </view>
            <view
                class="discount-info1"
                v-else
            >不使用
            </view>
            <image
                class="discount-img"
                :src="`${VUE_APP_STATIC_URL}static/images/arrowRight.png`"
            ></image>
          </view>
        </view>
        <!--      积分支付-->
        <view
            class="integralPayBox"
            v-if="integralShow"
        >
          <view class="integralBg">
            <view class="integralTit fs26">可用{{ integralNum }}积分抵扣{{ integralPrice.toFixed(2) }}元</view>
            <view class="maxIntegral">
              <checkbox-group
                  @change="changeIntegral"
                  style="width: 50rpx"
              >
                <checkbox
                    style="transform:scale(0.7);"
                    class="integralCheckbox"
                    color="#C5AA7B"
                    value="1"
                    :checked="selectIntegral"
                />
              </checkbox-group>
            </view>
          </view>
        </view>
        <view class="cashier-box">
          <CashierList
              :total-price="totalPrice"
              @change="handleChangeCashier"
          />
        </view>
        <view class="order-flow-box">
          <view class="flow-word">交易流程：</view>
          <view class="flow-word mt25">
            <text>1、填写收货信息并完成支付</text>
            <text>2、双方根据物品的交易方式进行交易</text>
            <text>3、拿到物品，交易结束</text>
          </view>
          <!--        实付款不含邮费，涉及邮寄双方协定好费用，提醒发起人修改价格再完成支付；-->
          <view class="flow-word mt50">注：应国家邮政总局的要求，即日起涉及到个人快递包裹必须收件人实名制，否则将影响到收寄配送。请避免使用「先生，男士，小姐，女士，昵称」等模糊称谓。
          </view>
        </view>
      </view>
      <view
          class="order-confirm-box"
      >
        <view class="flex-items flex-sp-between">
          <text class="num-box">共{{ totalCount }}件</text>
          <view>
            <text class="total">合计：</text>
            <text
                v-if="totalPrice>0"
                class="price"
            >¥{{ totalPrice.toFixed(2) }}
            </text>
            <text
                v-else
                class="price"
            >¥0.00
            </text>
          </view>
        </view>
        <!-- active 当有地址时按钮加上active选中的样式-->
        <button
            v-if="isRegionalScope"
            class="btn unActive"
            type="default"
            :disabled="false"
        >提交订单
        </button>
        <submit-button v-else text="提交订单" @submitEvent="submitOrder"></submit-button>
      </view>
      <!-- 活动弹框 -->
      <u-popup
          class="activity-con"
          v-model="isShowDiscount"
          mode="bottom"
          border-radius="14"
          close-icon-pos="top-right"
          close-icon-size="20"
      >
        <view
            class="activity-box"
            style="height: 1000rpx;"
        >
          <view class="title-box">
            <image
                class="close-btn"
                @click="onDiscountClose"
                :src="`${VUE_APP_STATIC_URL}static/images/close.png`"
            ></image>
          </view>
          <view class="activity-coupon-box">
            <scroll-view
                scroll-y="true"
                style="height: 900rpx;"
            >
              <view class="content-box">
                <view v-if="usableListLength">
                  <view class="label-lingqu">可用优惠券列表</view>
                  <view class="couponBox">
                    <view
                        class="coupon-item"
                        v-for="(usableItem, index) in settlement.coupons"
                        :key="index"
                        @click="couponItemTap(index, usableItem)"
                    >
                      <view
                          class="money-box"
                          v-if="usableItem.couponType === 1"
                      >
                        ￥{{ usableItem.reduceMoney }}
                      </view>
                      <view
                          class="money-box"
                          v-else
                      >{{ usableItem.reduceMoney }}折券
                      </view>
                      <view class="info-box">
                        <view
                            class="date font-color-999"
                            style="font-size:22upx;  margin-top: 20upx;"
                        >
                          {{
                            getDate(usableItem.startTime.replace(/-/g, '.'))
                          }}-{{ getDate(usableItem.endTime.replace(/-/g, '.')) }}
                        </view>
                        <view class="info font-color-999">满{{ usableItem.fullMoney }}元可用</view>
                      </view>
                      <image
                          class="check-img"
                          :src="`${VUE_APP_STATIC_URL}static/images/selectActive.png`"
                          v-if="usableItem.checked"
                      ></image>
                      <image
                          class="check-img"
                          :src="`${VUE_APP_STATIC_URL}static/images/selectEmpty.png`"
                          v-else
                      >
                      </image>
                    </view>
                  </view>
                </view>
              </view>
            </scroll-view>
          </view>
        </view>
      </u-popup>
      <u-popup
          class="activity-con"
          v-model="isShopCoupons"
          mode="bottom"
          border-radius="14"
          close-icon-pos="top-right"
          close-icon-size="20"
      >
        <view class="activity-box">
          <view class="title-box">
            <image
                class="close-btn"
                @click="onshopClose"
                :src="`${VUE_APP_STATIC_URL}static/images/close.png`"
            ></image>
          </view>
          <view class="activity-coupon-box">
            <scroll-view
                scroll-y="true"
                style="height: 900rpx;"
            >
              <view class="content-box">
                <view v-if="shopCouponsLength">
                  <view class="label-lingqu">可用优惠券列表</view>
                  <view class="couponBox">
                    <view
                        class="coupon-item"
                        v-for="(sItem, index) in shopCouponslist.shopCoupons"
                        :key="sItem.id"
                        @click="shopCouponItemTap(index,sItem)"
                    >
                      <view
                          class="money-box"
                          v-if="sItem.couponType === 1"
                      >￥{{ sItem.reduceMoney }}
                      </view>
                      <view
                          class="money-box"
                          v-else
                      >{{ sItem.reduceMoney }}折券
                      </view>
                      <view
                          class="date font-color-999"
                          style="font-size:22upx;  margin-top: 10upx;"
                      >
                        {{ getDate(sItem.startTime.replace(/-/g, '.')) }}-{{
                          getDate(sItem.endTime.replace(/-/g, '.'))
                        }}
                      </view>
                      <view class="info-box">
                        <view class="info font-color-999">满{{ sItem.fullMoney }}元可用</view>
                      </view>
                      <image
                          class="check-img"
                          :src="`${VUE_APP_STATIC_URL}static/images/selectActive.png`"
                          v-if="sItem.checked"
                      ></image>
                      <image
                          class="check-img"
                          :src="`${VUE_APP_STATIC_URL}static/images/selectEmpty.png`"
                          v-else
                      >
                      </image>
                    </view>
                  </view>
                </view>
              </view>
            </scroll-view>
          </view>
        </view>
      </u-popup>
    </view>
  </view>
</template>

<script setup>
import { hidden } from "@/utils/hidden";
import { handleDoPay } from "@/utils/payUtil";
import { request } from '@/utils/request'
import API from "../../config/api";
import { onBackPress, onLoad, onShow } from "@dcloudio/uni-app";
import CashierList from "../../components/CashierList";
import { ref,inject } from "vue";
import { VUE_APP_STATIC_URL } from "@/config/api";
import {btnUseLoading} from "../../hooks/bntUseLoading";

const { btnShowLoading } = btnUseLoading()
const promotionInfoDTO = ref({
  couponId: 0,
  ifAdd: 1,
  reduceMoney: 0
});
// 埋点ID
const pointProductIds = ref('');
const couponActiveShowFalg = ref(false);
const settlement = ref({});
const type = ref(0);
const skuItemDTOList = ref([]);
const userAddressInfo = ref({});
const isShowDiscount = ref(false);
const isShopCoupons = ref(false);
const usableListLength = ref(0);
const shopCouponsLength = ref(0);
const shopCouponslist = ref([]);
const shopInfoDTO = ref({});
const reduceMoney = ref(0);
const submitActive = ref(true);
const distributionPrice = ref(0); //运费
const totalPrice = ref(0); //合计
const receiveId = ref('');
const totalCount = ref(0);
const skuItemList = ref({});
const shopGroupWorkId = ref(0);
const sumitType = ref('');
const collageId = ref(null);
const couponIfAdd = ref(true);
const couponsList = ref([]);
const shopCouIndex = ref(0); //优惠券index
const shopIndex = ref(0);
const shopCheckedType = ref(true);
const discountPrice = ref(0);
const selectShopCoupon = ref([]); // 已选择店铺优惠券
const huabeiDetail = ref(true);
const showHuabeiPopup = ref(false);
const huabeiChargeType = ref(0);
const huabeiFeerateList = ref([]);
const paymentMode = ref(0); //支付方式 1-微信支付 2-支付宝支付 3-花呗分期
const huabeiPeriod = ref(3); //选择的花呗分期数 有 3 6 12 3种选项，默认是3
const chargeFeeList = ref([]); //花呗每期的手续费
const fenqiFeeList = ref([]); //花呗每期的支付额
const showWechatPayType = ref(false);
const showAlipayPayType = ref(false);
const showHuabeiPayType = ref(false);
const orderId = ref(null);
const couponType = ref(0);
const selectIntegral = ref(true);
const integralNum = ref(0);
const ifShow = ref(false);
const integralRatio = ref(0); // 积分兑换比例
const integralPrice = ref(0); // 总积分可减多少元
const orderCreditThreshold = ref(0); // 满多少元可以抵扣
const integralShow = ref(false); // 显示隐藏积分
const checkedPlatformCoupon = ref(undefined);
const oneClickSubmit = ref(true); //只提交订单一次
const isRegionalScope = ref(false); //是否在商家配置范围内地址
const payObj = ref({}) // 支付相关

onLoad(options=> {
  getQuery()
  type.value = options.type
  if (options.receiveId) {
    receiveId.value = options.receiveId
  }
})
onShow(()=>{
  if (uni.getStorageSync("receiveItem")) {
    receiveId.value = uni.getStorageSync("receiveItem").receiveId
  }
  if (uni.getStorageSync("skuItemDTOList") != "") {
    skuItemDTOList.value = uni.getStorageSync('skuItemDTOList')
    if (skuItemDTOList.value[0].shopDiscountId > 0) {
      sumitType.value = 4
    } else if (skuItemDTOList.value[0].shopSeckillId > 0) {
      sumitType.value = 3
    }
    getSettlement(false)
  } else if (uni.getStorageSync("skuItemList") != "") {
    skuItemList.value = uni.getStorageSync("skuItemList")
    //console.log(skuItemList, 999)
    shopGroupWorkId.value = skuItemList.value.shopGroupWorkId
    sumitType.value = skuItemList.value.type
    collageId.value = skuItemList.value.collageId
    getSettlement(true)
  }
})
// onBackPress(e=> {
//   if (e.from === 'navigateBack') {
//     return false;
//   }
//   back();
//   return true
// })


function getQuery() {
  request(API.Query, {
    name: 'credit_exchange_rate'
  }, 'GET').then(res => {
    integralRatio.value = parseFloat(res.data.dictDescribe)
  }).catch(res => {
    console.log('平台端未配置积分兑换比例(1积分抵扣多少金额)')
    throw Error(res)
  })
}
// 积分价格计算
function changeIntegral() {
  selectIntegral.value = !selectIntegral.value
  if (selectIntegral.value) {
    totalPrice.value = totalPrice.value - integralPrice.value
  } else {
    totalPrice.value = totalPrice.value + integralPrice.value
  }
}
function back() {
  if (type.value == 2 || type.value) {
    uni.switchTab({
      url: '../../pages/tabbar/cart/index'
    })
  } else {
    uni.navigateBack({
      delta: 1
    });
  }
}

// 获取订单信息
function getSettlement(isGroup) {
  ifShow.value = true
  let _url = '',
      _data = ''
  // 是否是拼团
  if (isGroup) {
    _url = API.getGroupSettlement
    _data = skuItemList.value
  } else {
    _url = API.Settlement
    _data = {
      type: type.value,
      shops: skuItemDTOList.value,
      receiveId: receiveId.value
    }
    // composeId: 68
  }
  request(_url, _data, 'POST').then(res => {
    settlement.value = res.data
    couponsList.value = res.data.coupons
    huabeiChargeType.value = res.data.huabeiChargeType
    if (huabeiChargeType.value === 2) {
      huabeiFeerateList.value = res.data.huabeiFeerateList
    } else {
      huabeiFeerateList.value = [0, 0, 0]
    }
    let shopLen = settlement.value.shops.length
    settlement.value.shops.forEach((value) => {
      value['totalNum'] = value.total
      value['pricing'] = 0
    })
    // 如果没有地址时进入购买宝贝页面对下面的商品件数和总计进行赋值
    if (!settlement.value.receive.receiveAdress) {
      settlement.value.shops.map(item => {
        totalCount.value += item.number
        totalPrice.value += item.total || item.totalNum
      })
    }
    // 初始化平台券选中状态
    if (settlement.value.coupons.length > 0) {
      settlement.value.coupons.forEach((item) => {
        item.checked = false
      })
    }
    settlement.value.shops.forEach((item) => {
      item.totalAfterDiscount = item.total
    })
    // 默认选中商家的第一张优惠券
    for (let s = 0; s < shopLen; s++) {
      const curShop = settlement.value.shops[s]
      curShop.skus.forEach((item) => {
        item['skuTotalNum'] = item.total
      })
      if (curShop.shopCoupons.length > 0) {
        curShop.shopCoupons.forEach((item) => {
          item.checked = false
        })
        const firstShopCoupon = curShop.shopCoupons[0];
        shopCouponItemTap(0, firstShopCoupon)
      }
    }
    if (uni.getStorageSync('receiveItem')) {
      let receiveItem = uni.getStorageSync('receiveItem')
      userAddressInfo.value = receiveItem
      receiveId.value = receiveItem.receiveId
      userAddressInfo.value.receivePhone = hidden(userAddressInfo.value.receivePhone, 3, 4)
    } else if (res.data.receive) {
      receiveId.value = res.data.receive.receiveId
      userAddressInfo.value = res.data.receive
      userAddressInfo.value.receivePhone = hidden(userAddressInfo.value.receivePhone, 3, 4)
    }
    uni.removeStorageSync('receiveItem')
    usableListLength.value = res.data.coupons.length
    isReceiveCan()
    getTotal()
  }).catch(res => {
    uni.hideLoading()
    throw new Error(res)
  })
}


// 根据地址判断是否能下单
function isReceiveCan() {
  settlement.value.shops.map(item => {
    if (item.receiveNotMatch) {
      isRegionalScope.value = item.receiveNotMatch
    }
    if (isRegionalScope.value) {
      uni.showToast({
        title: '当前地址不支持配送，请参与红色字提示',
        icon: 'none'
      })
    }
  })
}

function addAddressTap() {
  uni.navigateTo({
    url: '../../pages_category_page2/userModule/address?type=' + type.value,
  })
}
function getDate(time) {
  if (!time) return '';
  return time.split(' ')[0]
}

// 平台优惠券选择
function couponItemTap(index, coupon) {
  if (!coupon.checked && selectShopCoupon.value.length) { // 判断商家券情况
    uni.showToast({
      title: '不可与商家券叠加使用！',
      icon: 'none'
    })
    return false
  }
  // 已选中的情况下取消选中
  if (coupon.checked) {
    let promotionInfoDTOs = {}
    if (coupon.couponId) {
      promotionInfoDTOs['couponId'] = 0
      promotionInfoDTOs['ifAdd'] = 1
      promotionInfoDTOs['reduceMoney'] = 0
    }
    promotionInfoDTO.value = promotionInfoDTOs
    coupon.checked = false
    isShowDiscount.value = false
    checkedPlatformCoupon.value = undefined
    settlement.value.shops.forEach(shopItem => {
      if (shopItem.skus) {
        shopItem.skus.forEach(skuItem => {
          skuItem.buyerCouponId = null
        })
      }
    })
    getTotal()
  } else {
    // 先把所有已选中的平台优惠券改为未选中
    settlement.value.coupons.forEach((item) => {
      item.checked = false
    })
    let totalPrice = 0 // 订单总价
    let shopsLen = settlement.value.shops.length // 结算页店铺数量
    let matchCouponSkuList = []
    for (let i = 0; i < shopsLen; i++) {
      let matchCouponNormalPrice = 0
      let priceCount = 0
      const curShop = settlement.value.shops[i]
      let skuLen = curShop.skus.length
      let tmpPriceSkuList = []
      for (let j = 0; j < skuLen; j++) {
        const curSku = curShop.skus[j]
        if (curSku.priceId > 0) {
          priceCount++
        }
        const ids = coupon.ids
        if (ids.indexOf(curSku.productId) > -1) {
          if (curSku.priceId > 0) {
            tmpPriceSkuList.push(curSku)
          } else {
            matchCouponSkuList.push(curSku)
            matchCouponNormalPrice = matchCouponNormalPrice + curSku.price * curSku.number
          }
        }
      }
      if (priceCount === tmpPriceSkuList.length) {
        totalPrice += curShop.priceAfterDiscount
        matchCouponSkuList = matchCouponSkuList.concat(tmpPriceSkuList)
      }
      totalPrice += matchCouponNormalPrice
    }
    if (settlement.value.shops[shopIndex.value].total < coupon.fullMoney) {
      uni.showToast({
        title: '不满足优惠券使用条件！',
        icon: 'none'
      })
      return false
    }
    if (coupon.couponType === 1 && coupon.reduceMoney >= totalPrice) {
      uni.showToast({
        title: '不可使用大于等于合计金额的优惠劵！',
        icon: 'none'
      })
      return false
    }
    // 如果是折扣券，需要记录，在什么基数上打折
    coupon.useMoney = totalPrice
    let promotionInfoDTOs = {}
    if (coupon.couponId) {
      promotionInfoDTOs['couponId'] = coupon.couponId
      promotionInfoDTOs['ifAdd'] = coupon.ifAdd
      promotionInfoDTOs['couponType'] = coupon.couponType
      promotionInfoDTOs['reduceMoney'] = coupon.reduceMoney
    }
    promotionInfoDTO.value = promotionInfoDTOs
    isShowDiscount.value = false
    checkedPlatformCoupon.value = coupon
    matchCouponSkuList.forEach(item => {
      item.buyerCouponId = coupon.couponId
    })
    getTotal()
    // 选中优惠券
    coupon.checked = true
  }
}

// 店铺优惠券选择
function shopCouponItemTap(index, coupon) {
  // 取消选择优惠券
  if (coupon.checked) {
    coupon.checked = false
    settlement.value.shops[shopIndex.value].totalAfterDiscount = settlement.value.shops[shopIndex.value].total
    settlement.value.shops[shopIndex.value].currentCoupon = {}
    settlement.value.shops[shopIndex.value].skus.forEach(item => {
      item.buyerShopCouponId = null
    })
    isShopCoupons.value = false
    selectShopCoupon.value = []
    getTotal()
    return false
  }
  if (settlement.value.shops[shopIndex.value].total < coupon.fullMoney) {
    uni.showToast({
      title: '不满足优惠券使用条件！',
      icon: 'none'
    })
  } else if (coupon.couponType === 1 && settlement.value.shops[shopIndex.value].total < coupon.reduceMoney) {
    uni.showToast({
      title: '不可使用大于商品金额的优惠劵！',
      icon: 'none'
    })
  } else {
    // 选择优惠券
    if (promotionInfoDTO.value.couponId !== 0) {
      uni.showToast({
        title: '此券不可与平台券叠加！',
        icon: 'none'
      })
      return false
    }
    if (coupon.couponType === 1) {
      if (coupon.reduceMoney >= settlement.value.shops[shopIndex.value].total) {
        uni.showToast({
          title: '优惠券优惠金额不能大于等于合计金额！',
          icon: 'none'
        })
        return false
      }
    }

    isShopCoupons.value = false
    let useCoupon = useShopCoupon(shopIndex.value, index)
    if (useCoupon) {
      // 确认使用当前点击的商家券，先将所有的商家券取消选中
      for (let i = 0; i < selectShopCoupon.value.length; i++) {
        selectShopCoupon.value[i].checked = false
      }
      selectShopCoupon.value = []

      coupon.checked = true
      settlement.value.shops[shopIndex.value].currentCoupon = coupon
      settlement.value.shops[shopIndex.value].skus.forEach(item => {
        if (item.buyerShopCouponId > 0 && item.buyerShopCouponId !== coupon.shopCouponId) {
          item.buyerShopCouponId = null
        }
      })
      selectShopCoupon.value.push(coupon)
    } else {
      settlement.value.shops[shopIndex.value].totalAfterDiscount = settlement.value.shops[shopIndex.value].total
    }
    getTotal()
  }
}

function useShopCoupon(shopIndex, couponIndex) {
  // 当前需要使用优惠券的店铺
  const curShop = settlement.value.shops[shopIndex]
  // 当前需要使用优惠券店铺使用优惠券后的价格init
  curShop.totalAfterDiscount = 0
  // 当前优惠券所有所对应的优惠券
  let curCoupon
  if (curShop.shopCoupons && curShop.shopCoupons.length > 0) {
    curCoupon = curShop.shopCoupons[couponIndex]
  }
  if (!curCoupon) {
    return false
  }
  let useCoupon = false
  let matchCouponNormalSkuList = []
  let matchCouponPriceSkuList = []
  if (curCoupon.applyType !== 1) {
    const ids = curCoupon.ids
    let skuLength = curShop.skus.length
    // 符合优惠券商品列表中的普通sku价格综合
    let matchCouponNormalPrice = 0
    // 符合定价捆绑且在优惠券商品列表中的价格综合
    let matchCouponPricePrice = 0
    // 符合定价捆绑活动的sku数量
    let priceCount = 0
    for (let idx = 0; idx < skuLength; idx++) {
      let curSku = curShop.skus[idx]
      if (curSku.priceId > 0) {
        priceCount++
      }
      if (ids.indexOf(curSku.productId) > -1) {
        if (curSku.priceId > 0) {
          matchCouponPriceSkuList.push(curSku)
        } else {
          matchCouponNormalSkuList.push(curSku)
          matchCouponNormalPrice = matchCouponNormalPrice + curSku.price * curSku.number
        }
      }
    }
    // 如果定价捆绑的所有sku都符合优惠券
    if (priceCount === matchCouponPriceSkuList.length) {
      matchCouponPricePrice = curShop.priceAfterDiscount
    }
    // 符合的sku的price加起来是否满足满减的条件
    const priceFinal = matchCouponPricePrice + matchCouponNormalPrice
    if (priceFinal < curCoupon.fullMoney || (curCoupon.couponType === 1 && priceFinal <= curCoupon
        .reduceMoney)) {
      return false
    }
    // 判断是满减，还是折扣
    if (curCoupon.couponType === 1) {
      curShop.totalAfterDiscount = curShop.total - curCoupon.reduceMoney
      useCoupon = true
    } else {
      // 打折后优惠抵扣的金额
      let priceDiscount = (priceFinal * ((10 - curCoupon.reduceMoney) / 10)).toFixed(2)
      let tmpTotal = curShop.total - priceDiscount
      if (tmpTotal.toFixed(2) >= 0.01) {
        curShop.totalAfterDiscount = tmpTotal.toFixed(2)
        useCoupon = true
      }
    }
    if (useCoupon) {
      // 满足的sku设置buyerShopCouponId
      if (priceCount === matchCouponPriceSkuList.length) {
        let length1 = matchCouponPriceSkuList.length
        for (let idx = 0; idx < length1; idx++) {
          matchCouponPriceSkuList[idx].buyerShopCouponId = curCoupon.shopCouponId
        }
      }
      let length2 = matchCouponNormalSkuList.length
      for (let idx = 0; idx < length2; idx++) {
        matchCouponNormalSkuList[idx].buyerShopCouponId = curCoupon.shopCouponId
      }
    }
  } else {
    if (curCoupon.couponType === 1) {
      if (curShop.total > curCoupon.reduceMoney) {
        curShop.totalAfterDiscount = curShop.total - curCoupon.reduceMoney
        useCoupon = true
      }
    } else {
      if (curShop.total > curCoupon.fullMoney) {
        let priceDiscount = (curShop.total * ((10 - curCoupon.reduceMoney) / 10)).toFixed(2)
        let tmpTotal = curShop.total - priceDiscount
        if (tmpTotal.toFixed(2) >= 0.01) {
          curShop.totalAfterDiscount = tmpTotal.toFixed(2)
          useCoupon = true
        }
      }
    }
    if (useCoupon) {
      let skuLength = curShop.skus.length
      for (let idx = 0; idx < skuLength; idx++) {
        curShop.skus[idx].buyerShopCouponId = curCoupon.shopCouponId
      }
    }
  }
  return useCoupon
}

/**
 * 计算总价，商家券的优惠计算，在调用本方法之前已经计算好在shops[].totalAfterDiscount
 */
function getTotal() {
  totalPrice.value = 0
  totalCount.value = 0
  integralPrice.value = 0
  integralNum.value = 0
  let shopSumPrice = 0
  let shopsLen = settlement.value.shops.length
  for (let i = 0; i < shopsLen; i++) {
    totalPrice.value += parseFloat(settlement.value.shops[i].totalAfterDiscount)
    shopSumPrice += parseFloat(settlement.value.shops[i].totalAfterDiscount)
    totalCount.value += settlement.value.shops[i].number
  }

  if (checkedPlatformCoupon.value) {
    const couponType = checkedPlatformCoupon.value.couponType
    const reduceMoney = checkedPlatformCoupon.value.reduceMoney
    if (couponType === 1 && totalPrice.value - reduceMoney > 0) { // 满减
      totalPrice.value = shopSumPrice - reduceMoney
    } else if (couponType === 2 && reduceMoney > 0) { // 折扣
      const useMoney = checkedPlatformCoupon.value.useMoney
      totalPrice.value = (shopSumPrice - useMoney) + useMoney * reduceMoney / 10
    }
  }
  // 积分支付计算
  calcCredit()
  // 加上每个商家的运费
  settlement.value.shops.forEach((item) => {
    totalPrice.value = totalPrice.value + (item.distribution.distributionPrice || 0)
  })
  //recalcHuabei()
}


function calcCredit() {
  let shopsLen = settlement.value.shops.length
  const skuRemainMap = calcSkuRemainMap()
  const skuCreditMap = settlement.value.skuCreditMap;
  if (skuCreditMap && integralRatio.value > 0) {
    orderCreditThreshold.value = settlement.value.orderCreditThreshold
    let remainUserCredit = settlement.value.userTotalCredit
    let remainTotalPrice = Math.round((totalPrice.value + Number.EPSILON) * 100) / 100
    let remainDeductLimit = settlement.value.creditDeductLimit
    // 只有订单金额达到阈值，并且用户还有剩余的积分，才能进行积分抵扣
    if (totalPrice.value >= orderCreditThreshold.value && remainUserCredit > 0 && remainDeductLimit > 0) {
      for (let i = 0; i < shopsLen; i++) {
        const curShop = settlement.value.shops[i]
        let skuLen = curShop.skus.length
        for (let j = 0; j < skuLen; j++) {
          const curSku = curShop.skus[j]
          const skuId = curSku.skuId
          if (skuCreditMap[skuId] > 0 && skuRemainMap[skuId] > 0 && remainUserCredit > 0 &&
              remainTotalPrice > 0) {
            // 抵扣之后，必须保证整个订单至少还有0.01元，可用于支付
            if (remainTotalPrice - skuRemainMap[skuId] < 0.01) {
              skuRemainMap[skuId] -= 0.01
            }
            // 按照比例换算成需要多少积分抵扣(取整)
            let finalSkuCredit = parseInt((skuRemainMap[skuId] / integralRatio.value).toString());
            console.log(finalSkuCredit, 'finalSkuCredit')
            // 优先以商家配置的商品可抵扣积分为准
            if (skuCreditMap[skuId] < finalSkuCredit) {
              finalSkuCredit = skuCreditMap[skuId]
            }
            // 不能超过用户剩余积分
            if (remainUserCredit < finalSkuCredit) {
              finalSkuCredit = remainUserCredit
            }
            // 不能超过整个订单可抵扣积分
            if (remainDeductLimit < finalSkuCredit) {
              finalSkuCredit = remainDeductLimit
            }
            curSku.cachedCredit = finalSkuCredit
            integralNum.value += finalSkuCredit
            remainUserCredit -= finalSkuCredit
            remainDeductLimit -= finalSkuCredit
            remainTotalPrice -= finalSkuCredit
          }
        }
      }
    }
    //计算抵扣价格
    if (integralNum.value !== 0) {
      integralNum.value = parseInt(integralNum.value)
      integralPrice.value = integralNum.value * integralRatio.value
      if (integralNum.value !== 0) {
        integralShow.value = true
      }
      if (selectIntegral.value) {
        totalPrice.value = totalPrice.value - integralPrice.value
      }
    } else {
      integralShow.value = false
    }
  }
}

/**
 * 计算sku在整个运单价格中的剩余价值 1元的订单，打1折优惠之后，剩余价值就是0.1元
 */
function calcSkuRemainMap() {
  let skuRemainMap = {}
  let shopsLen = settlement.value.shops.length
  const skuCreditMap = settlement.value.skuCreditMap
  for (let i = 0; i < shopsLen; i++) {
    const curShop = settlement.value.shops[i]
    let skuLen = curShop.skus.length
    let checkedShopCoupon = undefined
    curShop.shopCoupons.forEach((item) => {
      if (item.checked) {
        checkedShopCoupon = item
      }
    })
    for (let j = 0; j < skuLen; j++) {
      const curSku = curShop.skus[j]
      const skuId = curSku.skuId
      // 不是定价捆绑，并且有配置可抵扣的积分，才有必要计算比例
      if (!curSku.priceId > 0 && skuCreditMap[skuId] > 0) {
        let remainSkuMoney = curSku.price * curSku.number
        if (checkedShopCoupon) {
          let skuShopPercent = remainSkuMoney / curShop.total
          let curReduceMoney = 0
          if (checkedShopCoupon.couponType === 1) {
            curReduceMoney = checkedShopCoupon.reduceMoney * skuShopPercent
          } else {
            curReduceMoney = remainSkuMoney * (10 - checkedShopCoupon.reduceMoney) / 10
          }
          remainSkuMoney = remainSkuMoney - curReduceMoney
        }
        // 使用平台券
        if (checkedPlatformCoupon.value && remainSkuMoney > 0) {
          // 满减
          if (checkedPlatformCoupon.value.couponType === 1) {
            let skuTotalPercent = remainSkuMoney / totalPrice.value
            remainSkuMoney -= checkedPlatformCoupon.value.reduceMoney * skuTotalPercent
          }
          // 折扣
          else {
            remainSkuMoney = remainSkuMoney * checkedPlatformCoupon.value.reduceMoney / 10
          }
        }
        skuRemainMap[skuId] = remainSkuMoney
      }
    }
  }
  return skuRemainMap
}

// 展示平台端优惠券
function showDiscount() {
  // let shopifAdd = 1
  // if(settlement.shops[shopIndex].shopCoupons.length>0){
  // 	shopifAdd = settlement.shops[shopIndex].shopCoupons[shopCouIndex].ifAdd
  // }
  if (settlement.value.coupons.length > 0) {
    for (let i = 0; i < selectShopCoupon.value.length; i++) {
      if (selectShopCoupon.value[i].ifAdd == 0) {
        uni.showToast({
          title: '不可叠加已选择的店铺券',
          icon: 'none'
        })
        return false
      }
    }
    isShowDiscount.value = true
  } else {
    uni.showToast({
      title: '暂无可用优惠券',
      icon: 'none'
    })
  }
}
// 显示店铺优惠券
function showShopCoupons(item, sIndex) {
  if (item.shopCoupons.length > 0) {
    isShopCoupons.value = true
    shopCouponslist.value = item
    shopCouponsLength.value = item.shopCoupons.length
    shopIndex.value = sIndex
  } else {
    uni.showToast({
      title: '暂无可用优惠券',
      icon: 'none'
    })
  }
}

function onDiscountClose() {
  isShowDiscount.value = false
}
function onshopClose() {
  isShopCoupons.value = false
}


/**
 * 检查提交表单
 * @return {boolean}
 */
function handleCheckOrderForm() {
  if (!payObj.value.paymentMode) {
    uni.showToast({
      title: '请选择支付方式',
      icon: 'none'
    })
    return false
  }
  if (!oneClickSubmit.value) {
    uni.showToast({
      title: "已提交，请勿重新操作！",
      icon: 'none'
    })
    return false
  }
  if (!userAddressInfo.value.receiveName) {
    uni.showToast({
      icon: 'none',
      title: '请选择收货地址'
    })
    return false
  }
  oneClickSubmit.value = false
  return true
}

/**
 * 支付更改事件
 * @param params
 */
function handleChangeCashier(params){
  payObj.value = params
}

/**
 * 组装结算数据
 */
function handlePackageData() {
  uni.showLoading({
    mask: true,
    title: '订单提交中...',
  })
  let couponIdinfo = 0
  if (promotionInfoDTO.value.couponId) {
    couponIdinfo = promotionInfoDTO.value.couponId
  }
  let data = {
    shopDiscountId: null,
    collageId: collageId.value,
    type: sumitType.value,
    shopGroupWorkId: null,
    receiveId: receiveId.value,
    couponId: couponIdinfo,
    price: totalPrice.value,
    remark: "",
    shops: [],
    discountPrice: discountPrice.value,
    shopSeckillId: null
  }

  if (shopGroupWorkId.value > 0) {
    data.shopGroupWorkId = shopGroupWorkId.value
  }

  if (skuItemDTOList.value != '') {
    if (skuItemDTOList.value[0].shopDiscountId > 0) {
      data.shopDiscountId = skuItemDTOList.value[0].shopDiscountId
    } else if (skuItemDTOList.value[0].shopSeckillId > 0) {
      data.shopSeckillId = skuItemDTOList.value[0].shopSeckillId
    }
  }
  let datashopslen = settlement.value.shops.length
  for (let n = 0; n < datashopslen; n++) {
    let shopsobj = {}
    shopsobj["shopId"] = settlement.value.shops[n].shopId
    shopsobj["sceneId"] = settlement.value.shops[n].sceneId
    shopsobj["distribution"] = {}
    shopsobj["skus"] = []
    if (settlement.value.shops[n].currentCoupon) {
      shopsobj["id"] = settlement.value.shops[n].currentCoupon.id
    }
    data.shops.push(shopsobj)
    data.shops[n].distribution.distributionPrice = settlement.value.shops[n].distribution.distributionPrice
    data.shops[n].distribution.distributionName = settlement.value.shops[n].distribution.distributionName
    let dataskuslen = settlement.value.shops[n].skus.length
    for (let m = 0; m < dataskuslen; m++) {
      let skusobj = {}
      const curSku = settlement.value.shops[n].skus[m]
      skusobj["skuId"] = curSku.skuId
      skusobj["number"] = curSku.number
      skusobj["ifLogistics"] = curSku.ifLogistics
      skusobj["selected"] = curSku.selected
      skusobj["platformSeckillId"] = curSku.platformSeckillId
      skusobj["platformDiscountId"] = curSku.platformDiscountId
      skusobj["shopSeckillId"] = curSku.shopSeckillId
      skusobj["shopDiscountId"] = curSku.shopDiscountId
      skusobj["sceneId"] = curSku.sceneId
      skusobj["priceId"] = curSku.priceId
      skusobj["useMember"] = curSku.useMember
      skusobj["composeId"] = curSku.composeId
      // 处理埋点id
      pointProductIds.value += curSku.productId + ','
      // 积分传参
      if (selectIntegral.value && curSku.cachedCredit) {
        skusobj["useCredit"] = curSku.cachedCredit
        skusobj["useCreditAmount"] = (curSku.cachedCredit * integralRatio.value).toFixed(2)
      }
      data.shops[n].skus.push(skusobj)
    }
  }

  // 去除最后一个,
  if (pointProductIds.value.endsWith(',')) {
    pointProductIds.value = pointProductIds.value.slice(0, -1)
  }
  handleSetPayMode(data)
  uni.hideLoading()
  return data
}

/**
 * 根据环境设置下单的支付信息
 * @param data handlePackageData返回值
 */
function handleSetPayMode(data){
  // subPaymentMode 1-小程序支付 2-app支付 3-H5支付
  // paymentMode 1-微信 2-支付宝
  data.paymentMode = payObj.value.paymentMode
  // #ifdef H5
  data.subPaymentMode = 3
  // #endif

  // #ifdef MP-WEIXIN
  data.subPaymentMode = 1
  // #endif

  // #ifdef APP-PLUS
  data.paymentMode = 1
  // #endif
  // #ifdef MP-ALIPAY
  data.subPaymentMode = 2
  // #endif
}

const $store = inject('$store')
/**
 * 提交订单
 * @return {Promise<void>}
 */
async function submitOrder() {
  if (!handleCheckOrderForm()) return;
  // 处理表单
  const data = handlePackageData()
  // uni.showLoading({
  //   mask: true,
  //   title: '结算中...',
  // })
  btnShowLoading()
  try {
    const res = await request(API.PlaceOrder, data, 'POST')
    // 下单成功处理埋点
    $store.dispatch('doPointer', {
      eventType: 3,
      productIds: pointProductIds.value
    })
    if (type.value == 2) {
      let carSkusData = data.shops
      let skusArr = []
      for (let i = 0; i < carSkusData.length; i++) {
        carSkusData[i].skus.map(item => {
          skusArr.push(item.skuId)
        })
      }
    }
    let submitResult = res.data
    orderId.value = res.data.orderId
    submitResult.type = 1
    submitResult.paymentMode = data.paymentMode
    if(payObj.value.paymentMode && payObj.value.huabeiPeriod){
      submitResult.huabeiPeriod = payObj.value.huabeiPeriod
    }
    await handleDoPay.call(undefined, submitResult)
  } catch (e) {
    oneClickSubmit.value = true
    uni.showToast({
      title: '订单结算错误',
      icon: 'none'
    })
    throw Error(e)
  } finally {
    // uni.hideLoading()
  }
}
</script>

<style lang="scss">
@import "../../style/images";
page {
  background-color: #F7F7F7;
}

.content {
  padding: 0 30upx 240rpx;
  box-sizing: border-box;
}

.address-box {
  margin-top: 20upx;
  background: #fff;
  border-radius: 10upx;
  width: 100%;
  padding: 30upx;
  box-sizing: border-box;
  display: flex;
  flex-direction: row;
  align-items: center;
  margin-bottom: 20rpx;
}

.address-box .address-img {
  width: 71upx;
  height: 57upx;
  margin-right: 20upx;
}

.address-box .address-r {
  flex: 1;
  display: flex;
  flex-direction: column;
  font-size: 28upx;
  color: #333;
}

.arrow-right-img {
  width: 62upx;
  height: 62upx;
  margin-left: 20upx;
}

.address-name-box {
  font-size: 30upx;
  color: #333;
}

.phone {
  font-size: 24upx;
  color: #999;
  margin-left: 20upx;
}

.address-info {
  font-size: 28upx;
  color: #333;
  margin-top: 15upx;
}

.order-list-box .item {
  background: #fff;
  border-radius: 10upx;
}

.order-list-top {
  height: 96upx;
  padding: 0 30upx;
  box-sizing: border-box;
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: space-between;
  border-bottom: 2rpx solid #eee;
}

.top-l {
  display: flex;
  flex-direction: row;
  align-items: center;
}

.shop-img {
  width: 34upx;
  height: 34upx;
  margin-right: 10upx;
}

.shop-name {
  font-size: 30upx;
  color: #333;
  font-weight: bold;
}

.arrow-img {
  margin-left: 15upx;
  width: 62upx;
  height: 62upx;
}

.order-info-box {
  padding: 0 30upx;
  box-sizing: border-box;
}

.order-info-item {
  display: flex;
  flex-direction: row;
  padding: 20upx 0;
}

.product-img {
  width: 180upx;
  height: 180upx;
  border-radius: 10upx;
  margin-right: 30upx;
}

.info-box {
  flex: 1;
}

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

.price-sku-box {
  width: 100%;
  display: flex;
  flex-direction: row;
  justify-content: space-between;
}

.product-sku {
  font-size: 24upx;
  font-weight: 500;
  color: #999;
  margin-left: -20upx;
  width: 100%;
  display: flex;
  flex-direction: row;
}

.product-price {
  font-size: 32upx;
  color: #C83732;
  font-weight: 400;
}

.product-price .fuhao {
  font-size: 28upx;
}

.product-num {
  font-size: 28upx;
  color: #999;
  font-weight: 400;
}

.adressTips {
  margin-bottom: 19rpx;
  color: #D53912;
}

.delivery-way-box {
  display: flex;
  flex-direction: column;
  border: 2rpx solid #E4E5E6;
  padding: 20rpx;
  margin-bottom: 20rpx;
  box-sizing: content-box;
}

.delivery-way-box .item {
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: space-between;
  font-size: 26upx;
  color: #333;
}

.delivery-way-box .item {
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: space-between;
  font-size: 26rpx;
  color: #333;
}

.delivery-way-box .item .way {
  color: #999;
  margin-left: 30upx;
}

.order-total-box {
  padding: 20upx 0;
  text-align: right;
}

.total-num {
  font-size: 26upx;
  color: #333;
}

.total-price {
  font-size: 46rpx;
  color: #333333;
}

.ml10 {
  margin-left: 10upx;
}

.order-flow-box {
  display: flex;
  flex-direction: column;
}

.flow-word {
  font-size: 24upx;
  color: #999;
  display: flex;
  flex-direction: column;
}

.mt25 {
  margin-top: 20upx;
}

.mt50 {
  margin-top: 30upx;
  margin-bottom: 20upx;
}

.order-confirm-box {
  position: fixed;
  bottom: 0;
  left: 0;
  width: 100%;
  background: #fff;
  padding: 30rpx 30rpx 0 30rpx;
  .btn {
    border-radius: 0;
  }
}

.num-box {
  font-size: 30upx;
  color: #999;
}

.num-box .total {
  color: #333;
}

.num-box .price {
  color: #ff7911;
  font-weight: bold;
}

.order-confirm-box .btn {
  width: 100%;
  height: 80rpx;
  line-height: 80rpx;
  background: #eee;
  font-size: 28rpx;
  color: #FFEBC4;
  text-align: center;
  margin-top: 20rpx;
}

.order-confirm-box .btn.active {
  background: #333333;
  color: #FFEBC4;
}

.order-confirm-box .btn.unActive {
  background: #333333;
  color: #FFEBC4;
  opacity: 0.7;
}

.discount-item1 {
  width: 100%;
  box-sizing: border-box;
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: space-between;
  background: white;
  padding: 20rpx;
  border: 2rpx solid #E4E5E6;
}

.discount-item {
  width: 100%;
  height: 98upx;
  box-sizing: border-box;
  margin: 30upx 0;
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: space-between;
  padding: 0 20upx;
  background: white;
}

.pay-type-item {
  .pay-type-radio {
    background-color: white;
    border-bottom: 1upx solid #EDEDED;
    margin-bottom: 20upx;
    padding: 24upx 20upx 24upx 20upx;

    .pay-type-img {
      display: inline-block;

      .pay-type-img-inner {
        width: 50upx;
        height: 50upx;
        vertical-align: middle;
      }
    }

    .pay-type-label {
      vertical-align: middle;
      margin-left: 30upx;
    }

    .pay-type-radio-item {
      float: right;
      width: 50upx;
      height: 50upx;
    }

    .huabei-detail {
      margin-top: 20upx;

      .fenqi-wenzi {
        display: inline-block;
        margin-left: 64upx;
      }

      .fenqi-amount {
        display: block;
        margin-left: 64upx;
        margin-top: 14upx;
        color: #BABBBC;
      }

      .fenqi-charge-fee {
        float: right;
        margin-right: 68upx;
        color: #BABBBC;
      }

      .fenqi-modal {
        width: 40upx;
        height: 40upx;
        margin-left: 20upx;
        float: right;
        position: relative;
        top: -80upx;
      }
    }
  }
}

.period-radio {
  margin: 30upx;
  width: 95%;
  border-bottom: 1px solid #EFEFEF;

  .period-amount {
    display: inline-block;

    .period-each-charge {
      display: inline-block;
      margin-top: 12upx;
      margin-left: 6upx;
      font-size: 26upx;
      color: #b7b7b7;
      margin-bottom: 13upx;
    }
  }

  .period-each {
    display: block;
  }

  .period-type-radio-item {
    float: right;
  }
}

.huabei-confirm {
  height: 120upx;
  padding: 0upx 108upx 0upx 32upx;

  .fenqi-all {
    display: inline-block;
    width: 100%;
  }

  .fenqi-total-amount {
    float: left;
  }

  .fenqi-confirm {
    float: right;
    width: 160upx;
    padding: 0upx 20upx;

    .btn {
      width: 216upx;
      height: 80upx;
      line-height: 80upx;
      border-radius: 40upx;
      font-size: 28upx;
      text-align: center;
      background: linear-gradient(90deg, rgba(255, 162, 0, 1), rgba(255, 121, 17, 1));
      color: #fff;
      display: inline-block;
      margin-right: 66upx;
    }
  }
}

.discount-info-box {
  display: flex;
  flex-direction: row;
}

.discount-label,
.discount-info1 {
  font-size: 26upx;
  color: #333;
}

.discount-info2 {
  color: #C5AA7B;
}

.discount-img {
  width: 30upx;
  height: 30upx;
  margin-left: 20upx;
}

.activity-con {
  .activity-box {
    display: flex;
    flex-direction: column;
    width: 100%;
    height: 1000upx;
  }

}

.activity-box .title-box {
  width: 100%;
  height: 100upx;
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: center;
  position: relative;
  border-bottom: solid 1px #EEEEEE;
}

.activity-coupon-box {
  display: flex;
  flex-direction: column;
  width: 100%;
  overflow: auto;
  flex: 1;
}

.title-box .close-btn {
  width: 100upx;
  height: 100upx;
  box-sizing: border-box;
  padding: 30upx;
  position: absolute;
  top: 0;
  right: 0;
}

.content-box {
  width: 100%;
  box-sizing: border-box;
  display: flex;
  flex-direction: column;
  padding: 30upx;
}

.tag-box {
  width: 100%;
  box-sizing: border-box;
  height: 80upx;
  line-height: 80upx;
  font-size: 28upx;
  font-weight: 500;
  color: #FF7911;
}

.label-lingqu {
  width: 100%;
  font-size: 28upx;
  font-weight: 500;
  color: rgba(51, 51, 51, 1);
}

.coupon-item1 {
  width: 690upx;
  height: 120upx;
  margin-top: 20upx;
  color: #FFFFFF;
  flex-shrink: 0;
}

.coupon-item2 {
  width: 690upx;
  height: 120upx;
  background-size: 690upx 120upx;
  margin-top: 20upx;
  color: rgba(255, 121, 17, 1);
  flex-shrink: 0
}

.un-coupon-item {
  color: #bbb;
}

.money-box {
  font-size: 40upx;
  font-weight: 500;

}

.info-box {
  font-size: 24upx;
  font-weight: 400;
  margin: 10rpx;
}


.receive-success {
  width: 100%;
  position: fixed;
  top: 0;
  bottom: 0;
  left: 0;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  z-index: 9999;
}

.success-box {
  width: 380upx;
  height: 280upx;
  background: rgba(0, 0, 0, 0.5);
  border-radius: 10upx;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
}

.success-box .success-img {
  width: 200upx;
  height: 130upx;
}

.success-box .text {
  font-size: 28upx;
  margin-top: 50upx;
  font-weight: 400;
  color: rgba(255, 255, 255, 1);
}

.check-img {
  width: 40upx;
  height: 40upx;
  margin-top: 40rpx;
}

.mt30 {
  margin-top: 30upx;
}

.activity-con {
  .activity-box {
    display: flex;
    flex-direction: column;
    width: 100%;
    height: 1000upx;
  }

}

.activity-box .title-box {
  width: 100%;
  height: 100upx;
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: center;
  position: relative;
  border-bottom: solid 1px #EEEEEE;
}

.activity-coupon-box {
  display: flex;
  flex-direction: column;
  width: 100%;
  overflow: auto;
  flex: 1;
}

.title-box .close-btn {
  width: 100upx;
  height: 100upx;
  box-sizing: border-box;
  padding: 30upx;
  position: absolute;
  top: 0;
  right: 0;
}

.content-box {
  width: 100%;
  box-sizing: border-box;
  display: flex;
  flex-direction: column;
  padding: 30upx;
}

.tag-box {
  width: 100%;
  box-sizing: border-box;
  height: 80upx;
  line-height: 80upx;
  font-size: 28upx;
  font-weight: 500;
  color: #FF7911;
}

.label-lingqu {
  width: 100%;
  font-size: 28upx;
  font-weight: 500;
  color: rgba(51, 51, 51, 1);
}

.couponBox {
  display: flex;
  flex-flow: wrap;
  margin-top: 30rpx;
  justify-content: space-between;
}

.coupon-item {
  width: 48%;
  height: 291rpx;
  background: $couponsIcon no-repeat center top;
  margin-top: 20upx;
  color: #C5AA7B;
  flex-shrink: 0;
  text-align: center;
  padding-top: 1rpx;
  background-size: contain;
}

.un-coupon-item {
  color: #bbb;
}

.money-box {
  font-size: 40upx;
  font-weight: 500;
  margin-top: 30rpx;
}

.integralPayBox {
  margin: 20rpx 0;

  .integralBg {
    height: 98rpx;
    display: flex;
    justify-content: space-between;
    align-items: center;
    background: #FFFFFF;
    padding: 0 20rpx;

    .maxDeduction {
      margin-right: 15rpx;
    }
  }
}
</style>
<style>
.pay-type-item /deep/ .uni-radio-input-checked {
  background-color: #C5AA7B !important;
  border-color: #C5AA7B !important;
}

.maxIntegral /deep/ .uni-checkbox-input {
  width: 30rpx;
  height: 30rpx;
}

.maxIntegral /deep/ .uni-checkbox-input-checked:before {
  font-size: 30rpx;
}

.maxIntegral /deep/ .uni-checkbox-input-checked {
  border: 2rpx solid #C5AA7B !important;
}
</style>
