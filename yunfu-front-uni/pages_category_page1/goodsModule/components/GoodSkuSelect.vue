<!--
    * @FileDescription: sku选择器（花呗、拼团下单）
    * @Author: kahu
    * @Date: 2022/11/7
    * @LastEditors: kahu
    * @LastEditTime: 2022/11/7
-->
<template>
  <div class="content">
    <u-popup
        v-model="goodsDetailShowFlag"
        mode="bottom"
        border-radius="14"
    >
      <view class="goosDetailshow-box">
        <view class="detailImg-box flex-row-plus">
          <image
              class="detailImg"
              :src="selectedSku.image"
          ></image>
          <view class="flex-column-plus mar-left-40">
            <view class="font-color-C5AA7B">
              <label class="fs24">¥</label>
              <label
                  class="fs36 mar-left-10"
              >
                {{selectedSku.activityType === 1 && btnType === 4 ? selectedSku['salePrice'] : selectedSku.price}}
              </label>
            </view>
            <label class="fs24 font-color-999 mar-top-20">库存 {{ selectedSku.stockNumber }} 件</label>
            <label class="fs24 mar-top-20">已选</label>
          </view>
        </view>
        <view class="color-box flex-column-plus">
          <view
              v-for="(skuRowItem,skuRowIndex) in productData['names']"
              :key="skuRowIndex"
          >
            <label
                class="fs26 font-color-333"
                v-if="skuRowItem['nameCode']"
            >{{ skuRowItem.skuName }}</label>
            <view class="colorName-box">
              <view
                  class="pad-bot-30"
                  v-for="(skuColItem, skuColIndex) in skuRowItem.values"
                  :key="skuColIndex"
              >
                <view
                    class="colorName"
                    :class="{'colorName-on' : selectedAttr[skuRowItem['nameCode']] === skuColItem.valueCode}"
                    @click="handleClickSkuItem(skuRowItem['nameCode'], skuColItem.valueCode)"
                >
                  {{ skuColItem.skuValue }}
                </view>
              </view>
            </view>
          </view>
        </view>
        <view class="goodsNumCent">
          <view
              class="goodsNum-box flex-row-plus flex-sp-between"
              :class="{'bottom-line' :aliAgingObj.supportHanaUta}"
          >
            <label class="font-color-333 fs26">数量</label>
            <view class="goodsNum">
              <view
                  class="item subtract"
                  @click="handleNumSub"
              >-
              </view>
              <view
                  class="item goodsNumber"
              >{{ buyNum }}
              </view>
              <view
                  class="item add"
                  @click="handleNumAdd"
              >+
              </view>
            </view>
          </view>
        </view>
        <!-- 花呗分期 -->
        <view
            class="huabei-box flex-column-plus"
            v-if="aliAgingObj.supportHanaUta"
        >
          <label class="font-color-999 fs24">花呗分期</label>
          <scroll-view
              class="fenqi-box"
              scroll-x="true"
          >
            <view
                class="huabei-item"
                :class="[{'fenqi-on' :aliAgingObj.selectIndex === 0},{'disabled' :aliAgingObj.disableSelectList[0]}]"
                @click="handleSelectAliAging(0)"
            >
              <label class="huabei-period">分3期(含手续费)</label>
              <label class="huabei-money">￥{{ aliAgingObj.agingMoneyList[0] }}/期</label>
            </view>
            <view
                class="huabei-item"
                :class="[{'fenqi-on' :aliAgingObj.selectIndex  === 1},{'disabled' :aliAgingObj.disableSelectList[1]}]"
                @click="handleSelectAliAging(1)"
            >
              <label class="huabei-period">分6期(含手续费)</label>
              <label class="huabei-money">￥{{ aliAgingObj.agingMoneyList[1] }}/期</label>
            </view>
            <view
                class="huabei-item"
                :class="[{'fenqi-on' :aliAgingObj.selectIndex  === 2},{'disabled' :aliAgingObj.disableSelectList[2]}]"
                @click="handleSelectAliAging(2)"
            >
              <label class="huabei-period">分12期(含手续费)</label>
              <label class="huabei-money">￥{{ aliAgingObj.agingMoneyList[2] }}/期</label>
            </view>
          </scroll-view>
        </view>

        <view
            v-if="btnType===6"
            class="skuSelectBtn undercarriage"
        >
          <view
              class="flex-row-plus offShelf"
              v-if="productData.shelveState === 0"
          >
            商品已下架
          </view>
          <view
              class="flex-row-plus flex-items flex-sp-around"
              v-else-if="selectedSku.activityType === 1"
          >
            <view
                class="selectJoinShop selectBtn font-color-333"
                @click="handleBuyNow"
            >单独购买
            </view>
            <view
                class="selectBuyNow selectBtn font-color-FFEBC4"
                @click="handleBuyWithGroup(1)"
            >我要开团
            </view>
          </view>
          <view
              class="flex-row-plus flex-items flex-sp-around"
              v-else
          >
            <view
                class="selectJoinShop selectBtn font-color-333"
                @click="handleAddCart"
            >加入购物车
            </view>
            <view
                class="selectBuyNow selectBtn font-color-FFEBC4"
                @click="handleBuyNow"
            >立即购买
            </view>
          </view>
        </view>
        <view v-else>
          <view
              v-if="selectedSku.activityType === 1 && collageId !== 0"
              class="goosDetailbut-box flex-items-plus"
              :style="{'padding-bottom':(isIphone === true? 60:20)+'rpx'}"
          >
            <view
                class="joinbuyBut"
                @click="handleBuyWithGroup(2)"
            >确定
            </view>
          </view>
          <view
              v-else-if="selectedSku.activityType === 1 && btnType === 3"
              class="goosDetailbut-box flex-row-plus"
              :style="{'padding-bottom':(isIphone === true? 60:20)+'rpx'}"
          >
            <view
                class="buyNowBut"
                @click="handleBuyWithGroup(1)"
            >去拼团
            </view>
          </view>
          <view
              v-else
              class="goosDetailbut-box flex-row-plus"
              :style="{'padding-bottom':(isIphone === true? 60:20)+'rpx'}"
          >
            <submit-button v-if="btnType === 1" text="确认" @submitEvent="handleAddCart"></submit-button>
            <submit-button v-else text="确认" @submitEvent="handleBuyNow(2)"></submit-button>
          </view>
        </view>
      </view>
    </u-popup>
  </div>
</template>

<script setup>
// 是否展示SKU弹窗
import {inject, onMounted, ref, toRefs} from "vue";
import { request } from "@/utils/request";
import API from "@/config/api";
import {btnUseLoading} from "../../../hooks/bntUseLoading";

const { btnShowLoading } = btnUseLoading()
const emit = defineEmits(['getCurrentSku','postSelectSku', 'getInitSku'])
const $store = inject('$store')
const goodsDetailShowFlag=ref( false)
    // 已经选中的valueCode key => value  names.nameCode=>values.valueCode 处理选中渲染
const selectedAttr=ref( {})
// 当前选中的skuMap对象（服务端数据）
const selectedSku=ref( {})
const shopDiscountId = ref(0)
const shopSeckillId = ref(0)
// 1加入购物车 2立即购买 3开团 4单独购买 6SKU选择
const btnType=ref( 0)
const buyNum=ref( 1)
    // 花呗对象
const aliAgingObj=ref( {
  supportHanaUta: false,
  selectIndex: -1,
  disableSelectList: [true, true, true],
  agingMoneyList: ["0.00", "0.00", "0.00"]
})

const props = defineProps({
  productData: {
    type: Object,
    default: () => ({})
  },
  isIphone: {
    type: Boolean,
    default: () => false
  },
  collageId: {
    type: Number,
    default: () => 0
  }
})
const {productData,isIphone,collageId} = toRefs(props)
// 获取默认sku
onMounted(() => {
  emit('getInitSku')
})

/**
 * 当前SKU数量减少
 */
function handleNumSub() {
  if (buyNum.value > 1) {
    buyNum.value = buyNum.value - 1
  } else {
    uni.showToast({
      title: '亲！至少一件哦！',
      icon: "none"
    })
  }
}

/**
 * 当前SKU数量加
 */
function handleNumAdd() {
  if (buyNum.value < selectedSku.value.stockNumber) {
    buyNum.value = buyNum.value + 1
  } else {
    uni.showToast({
      title: '库存不足！',
      icon: "none"
    })
  }
}

/**
 * 根据skuId选择SKU
 * @param skuId SkuId
 */
function handleSelectBySkuId(skuId) {
  if (!skuId) return
  // 当前商品后端返回的所有sku的排列组合
  const allSkuValueGroupMap = productData.value.map
  for (const allSkuValueGroupMapKey in allSkuValueGroupMap) {
    if (parseInt(allSkuValueGroupMap[allSkuValueGroupMapKey].skuId) !== parseInt(skuId)) continue;
    selectedSku.value = allSkuValueGroupMap[allSkuValueGroupMapKey]
    echoFatherRowText(productData.value, selectedSku.value, buyNum.value)
    // 控制组件选中渲染
    const selectValueCodes = selectedSku.value['valueCodes'].split(',')
    for (const skuRow of productData.value.names) {
      for (const skuCol of skuRow.values) {
        if (!selectValueCodes.includes(skuCol['valueCode'])) continue;
        selectedAttr.value[skuRow['nameCode']] = skuCol['valueCode']
        break; // 一行的sku只会有一个value
      }
    }
  }
}

/**
 * 点击sku的一项
 * @param nameCode SKU行的nameCode
 * @param valueCode SKU列的valueCode
 * nameCodeValueCodeClick
 */
function handleClickSkuItem(nameCode, valueCode) {
  // 当前选中
  selectedAttr.value[nameCode] = valueCode
  // 获取到所有的sku的values.valueCode
  let values = []
  for (const key in selectedAttr.value) {
    values.push(selectedAttr.value[key])
  }
  // 当前选中的sku的key组合
  // 后端返回的productData.map中，排列组合了所有values[].valueCode的情况，使用逗号分隔
  const nowSelectSkuValueGroupKey = values.join(',') // 相较于allSkuValueGroupMap的key
  // 后端返回的所有sku组合（values.valueCode）
  const allSkuValueGroupMap = productData.value.map
  // 遍历后端数据
  for (const allSkuValueGroupMapKey in allSkuValueGroupMap) {
    // 当和当前选中的sku一致
    if (nowSelectSkuValueGroupKey === allSkuValueGroupMapKey) {
      selectedSku.value = allSkuValueGroupMap[allSkuValueGroupMapKey]
      echoFatherRowText(productData.value, selectedSku.value, buyNum.value)
    }
  }
}

/**
 * 回显父组件（通讯）
 * @param productData 当前商品对象
 * @param skuItem 当前选中的sku的后端数据
 * @param buyNum 当前sku购买数量
 */
function echoFatherRowText(productData, skuItem, buyNum) {
  // 获取到当前选中的sku的valueCode
  const currentSku = []
  // 取出所有的valueCode
  const nowSelectValueCodeList = skuItem['valueCodes'].split(',')
  const skuRows = productData.names
  for (const skuRow of skuRows) {
    const skuValues = skuRow.values
    for (const skuValue of skuValues) {
      if (!nowSelectValueCodeList.includes(skuValue.valueCode)) continue;
      const currentSkuItem = {skuText: ''}
      if (skuValue.valueCode === '单款项') {
        currentSkuItem['skuText'] = skuValue['skuValue']
      } else {
        currentSkuItem['skuText'] = `${ skuValue.skuName }:${ skuValue.skuValue }`
      }
      currentSku.push(currentSkuItem)
      break; // 只会对应一个value数据，找到就break减少循环
    }
  }
  emit('getCurrentSku', {
    skuItem,
    currentSku,
    buyNum
  })
  // 选中sku之后，做一些相应的操作
  // postSelectSku依赖于getCurrentSku的数据
  emit('postSelectSku')
}


//加入购物车
async function handleAddCart() {
  btnShowLoading()
  handleCheckIsLogin()
  if (selectedSku.value.stockNumber < 1) {
    return uni.showToast({
      title: '库存不足',
      icon: "none"
    })
  }
  // uni.showLoading({
  //   mask: true,
  //   title: '添加中...',
  // })
  try {
    const postData = {
      skuId: selectedSku.value.skuId,
      number: buyNum.value,
    }
    await request(API.ShoppingaddCart, postData, 'POST')
    // 埋点
    $store.dispatch('doPointer', {
      eventType: 2,
      productIds: productData.value.productId
    })
    // 给购物车小图标赋值数量
    let newAllCartNum = uni.getStorageSync('allCartNum') + buyNum.value
    uni.setStorageSync('allCartNum', newAllCartNum)
    emit('changeCartNum',newAllCartNum)
    uni.showToast({
      title: '添加成功',
      icon: 'none'
    })
    setTimeout(()=>{
      buyNum.value = 1
      goodsDetailShowFlag.value = false
    },2000)
  }finally {
    // uni.hideLoading()
  }
}

/**
 * 立即购买（下单）
 */
function handleBuyNow() {
  handleCheckIsLogin()
  if (selectedSku.value.stockNumber < 1) {
    return uni.showToast({
      title: '库存不足',
      icon: "none"
    })
  }
  if (buyNum.value > selectedSku.value.stockNumber && selectedSku.value.stockNumber !== 0) {
    return uni.showToast({
      title: '已超出最大数量限制',
      icon: "none"
    })
  }

  //组装后端数据
  let list = [{
    ifWork: 0,
    shopId: productData.value.shopId,
    shopName: productData.value.shopName,
    shopDiscountId: shopDiscountId.value > 0 ? shopDiscountId.value : null,
    shopSeckillId: shopSeckillId.value > 0 ? shopSeckillId.value : null,
    skus: [{
      productId: productData.value.productId,
      skuId: selectedSku.value.skuId,
      productName: productData.value.productName,
      image: selectedSku.value.image,
      price: selectedSku.value.price,
      weight: 0,
      number: buyNum.value,
      SKU: "",
      total: selectedSku.value.price * buyNum.value,
      ifLogistics: 1
    }]
  }]
  uni.setStorageSync('skuItemDTOList', list)
  buyNum.value = 1
  goodsDetailShowFlag.value = false
  uni.navigateTo({
    url: '../orderModule/orderConfirm?type=1',
  })
}

/**
 * 拼团下单
 * @param type 1单独开团2拼团
 */
function handleBuyWithGroup(type) {
  handleCheckIsLogin()
  if (selectedSku.value.stockNumber < 1) {
    return uni.showToast({
      title: '库存不足',
      icon: "none"
    })
  }
  const data = {
    number: buyNum.value,
    productId: productData.value.productId,
    shopId:  productData.value.shopId,
    skuId: selectedSku.value.skuId,
    shopGroupWorkId: selectedSku.value.shopGroupWorkId,
    type
  }
  if (type !== 1) {
    data.collageId = collageId.value
  }
  uni.removeStorageSync("skuItemDTOList")
  uni.setStorageSync('skuItemList', data)
  goodsDetailShowFlag.value = false
  buyNum.value = 1
  uni.navigateTo({
    url: '../orderModule/orderConfirm?type=1',
  })
}

/**
 * 是否登录
 * @return {boolean|void}
 */
function handleCheckIsLogin() {
  const userInfo = uni.getStorageSync('storage_key')
  if (!userInfo || (userInfo && JSON.stringify(userInfo) === '{}')) {
    return uni.navigateTo({
      url: '../../pages_category_page2/userModule/login'
    })
  }
  return true
}

/**
 * 选择分期
 * @param index 0:3期 1:6期 2:12期
 */
function handleSelectAliAging(index) {
  const aliAgingObj = aliAgingObj.value
  if (aliAgingObj.selectIndex !== index && !aliAgingObj.disableSelectList[index]) {
    aliAgingObj.selectIndex = index;
  } else {
    aliAgingObj.selectIndex = -1;
  }
}

/**
 * 渲染是否支持花呗
 * @param productData 当前商品
 * @param skuPrice:number 选中SKU的价格
 */
function handleRenderAliAging(productData, skuPrice) {
  if (productData.ifHuabei !== 1) return
  const aliAgingObj = aliAgingObj.value
  if (skuPrice && skuPrice >= 0.03) {
    aliAgingObj.supportHanaUta = true
    aliAgingObj.disableSelectList[0] = false;
    aliAgingObj.agingMoneyList[0] = (parseInt((skuPrice / 3 * 100) / 100 + '')).toFixed(2) + ""
  }
  if (skuPrice && skuPrice >= 0.06) {
    aliAgingObj.supportHanaUta = false;
    aliAgingObj.disableSelectList[1] = false;
    aliAgingObj.agingMoneyList[1] = (parseInt((skuPrice / 6 * 100) / 100 + '')).toFixed(2) + ""
  }
  if (skuPrice && skuPrice >= 0.12) {
    aliAgingObj.supportHanaUta = true;
    aliAgingObj.disableSelectList[2] = false;
    aliAgingObj.agingMoneyList[2] = (parseInt((skuPrice / 12 * 100) / 100 + '')).toFixed(2) + ""
  }
}

defineExpose({handleSelectBySkuId,btnType,goodsDetailShowFlag})
</script>

<style
    lang="scss"
    scoped
>
.goosDetailshow-box {
  margin-bottom: -5upx;

  .detailImg-box {
    margin-top: 30upx;
    margin-left: 30upx;
    border-bottom: 1upx solid #EDEDED;
    padding-bottom: 20upx;
    width: 690upx;

    .detailImg {
      width: 180upx;
      height: 180upx;
    }
  }

  .color-box {
    padding: 30upx 30upx;
    width: 690upx;

    .colorName-box {
      display: flex;
      flex-wrap: wrap;
      flex-direction: row;
      justify-content: flex-start;
      align-items: center;
      margin-top: 30upx;
      margin-left: -30upx;

      .colorName {
        background-color: #FFFFFF;
        margin-left: 30upx;
        padding: 10upx 32upx;
        font-size: 26upx;
        border: 2rpx solid #E4E5E6;
        z-index: 2;
        color: #333333;
      }

      .colorName-on {
        box-shadow: 0 0 20rpx rgba(0, 0, 0, 0.1);
        color: #C5AA7B;
        margin-left: 30upx;
        padding: 10upx 32upx;
        font-size: 26upx;
        text-align: center;
        z-index: 1;
        border: none;
      }
    }

  }

  .modelNum-box {
    padding: 30upx 30upx;
    border-bottom: 1upx solid #EDEDED;
    width: 690upx;

    .modelNumName-box {
      display: flex;
      flex-wrap: wrap;
      flex-direction: row;
      justify-content: flex-start;
      align-items: center;
      margin-top: 30upx;
      margin-left: -30upx;

      .modelNumName-on {
        background-color: #FFE4D0;
        color: #FF7800;
        margin-left: 30upx;
        padding: 10upx 32upx;
        border-radius: 28upx;
        border: 1upx solid #FF7800;
        font-size: 26upx;
        text-align: center;
      }

      .modelNumName {
        background-color: #F5F5F5;
        margin-left: 30upx;
        padding: 10upx 32upx;
        border-radius: 28upx;
        font-size: 26upx;
      }
    }
  }

  .goodsNumCent {
    padding: 0 30upx;

    .goodsNum-box {
      width: 100%;
      padding: 30rpx 0 180rpx 0;
      border-top: 2rpx solid #EDEDED;

      .goodsNum {
        height: 50upx;
        display: flex;
        align-items: center;

        .item {
          width: 50upx;
          height: 50upx;
          line-height: 48rpx;
          border: 1upx solid #999999;
          text-align: center;
        }

        .subtract {
          border-right: 0upx;
        }

        .goodsNumber {
          line-height: 50rpx;
        }

        .add {
          border-left: 0upx;
        }
      }
    }
  }

  .bottom-line {
    border-bottom: 1upx solid #EDEDED;
  }

  .huabei-box {
    padding: 30upx 30upx;
    width: 690upx;

    .fenqi-box {
      margin-top: 15upx;
      width: 120%;

      .huabei-item {
        display: inline-block;
        background: #f3f3f3;
        padding: 16upx 24upx;
        margin: 5upx 10upx;
        border-radius: 15upx;
        text-align: center;
        font-size: 7upx;

        .huabei-period {
          display: block;
        }
      }

      .fenqi-on {
        border: 1px solid #EF7F93;
        color: #EF7F93;
      }

      .disabled {
        color: #cacaca;
      }
    }
  }

  .goosDetailbut-box {
    justify-content: center;
    padding: 0 32rpx;
    .joinShopCartBut {
      width: 343upx;
      height: 80upx;
      border-radius: 40upx 0 0 40upx;
      background-color: #FFC300;
      color: #FFFEFE;
      font-size: 28upx;
      line-height: 80upx;
      text-align: center;
      margin-left: 30upx;
    }

    .buyNowBut {
      width: 90%;
      height: 90upx;
      background-color: #333333;
      font-size: 28upx;
      line-height: 90upx;
      text-align: center;
      color: #FFEBC4;
    }
  }
}

.skuSelectBtn {
  padding-bottom: 30rpx;
  .selectBtn {
    width: 342rpx;
    height: 100rpx;
    line-height: 100rpx;
    text-align: center;
    border: 2rpx solid #333333;
    font-size: 28rpx;
  }
  .selectBuyNow {
    background: #333333;
  }
}

.undercarriage {
  .offShelf {
    width: 700rpx;
    background: #b7b7b7;
    border-radius: 50rpx;
    height: 100rpx;
    line-height: 100rpx;
    justify-content: center;
    color: #333333;
    margin: 0 auto;
  }
}

.couponItemimg {
  width: 150upx;
  height: 60upx;
}

.joinbuyBut {
  width: 190upx;
  height: 80upx;
  background: #333333;
  color: #FFEBC4;
  font-size: 28upx;
  line-height: 80upx;
  text-align: center;
  margin-left: 30upx;
}
</style>
