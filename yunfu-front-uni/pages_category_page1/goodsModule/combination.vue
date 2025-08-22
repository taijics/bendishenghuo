<template>
  <view class="combinationBox">
    <global-loading />
    <view class="topInfo">
      <view class="topBg">
        <swiper class="swiper" :circular="circular" :autoplay="autoplay" :vertical="vertical" :duration="duration">
          <swiper-item v-for="(item, index) of ruleList" :key="index">
            <view class="swiper-item uni-bg-red">{{item.price}}元任选{{item.number}}件</view>
          </swiper-item>
        </swiper>
      </view>
    </view>
    <view class="combinationList">
      <view class="combinationItem" v-for="(item, index) of productList" :key="index" @click="goodsDateils(item.shopId,item.productId,item.skuId)">
        <view class="imgBox">
          <image :src="item.image" class="pic-img default-img"></image>
        </view>
        <view class="itemInfoBox">
          <view class="itemTit">{{item.productName}}</view>
          <view class="itemNum">{{item.number}}人付款</view>
          <view class="addInfo">
            <view class="price">￥{{item.price}}</view>
            <view class="selectBtn" @click.stop="showRuleBox(item, index)">
              <image :src="`${VUE_APP_STATIC_URL}static/images/cart1.png`" v-if="item.selected === 0"></image>
              <image v-else :src="`${VUE_APP_STATIC_URL}static/images/cart2.png`"></image>
            </view>
          </view>
        </view>
      </view>
    </view>


<!--     商品详情-->
    <u-popup v-model="goosDetailshowFlag" mode="bottom" border-radius="14">
      <view class="goosDetailshow-box">
        <view class="detailImg-box flex-row-plus">
          <image class="detailImg default-img" :src="skuImg"></image>
          <view class="flex-column-plus mar-left-40">
            <view class="font-color-C5AA7B">
              <label class="fs24">¥</label>
              <label class="fs36 mar-left-10">
                {{detailList.activityType == 1 ? skuOriginalPrice : skuPrice}}
              </label>
            </view>
            <label class="fs24 font-color-999 mar-top-20">库存 {{stockNumber}} 件</label>
            <label class="fs24 mar-top-20">已选</label>
          </view>
        </view>
        <view class="color-box flex-column-plus">
          <view v-for="(attritem,index) in skuProdList.names" :key="index">
            <label class="fs24 font-color-999">{{attritem.skuName}}</label>
            <view class="colorName-box">
              <view class="pad-bot-30" v-for="(attrRes, resIndex) in attritem.values" :key="resIndex">
                <view class="colorName" :class="{'colorName-on' :subIndex[index] == resIndex}"
                      @click="colorActiveClick(attrRes,index,resIndex)">{{attrRes.skuValue}}</view>
              </view>
            </view>
          </view>
        </view>
        <view class="goodsNum-box flex-row-plus flex-sp-between">
          <label class="font-color-999 fs24">数量</label>
          <view class="goodsNum">
            <text class="subtract" @click="numSub()">-</text>
            <text class="goodsNumber">{{buyNum}}</text>
            <text class="add" @click.stop="numAdd()">+</text>
          </view>
        </view>
        <view class="flex-items flex-sp-around btnBox">
          <view class="goosDetailbut-box flex-row-plus" @click="goosDetailshowFlag = false">
            <view class="buyNowBut cancelBtn">取消</view>
          </view>
          <view class="goosDetailbut-box flex-items-plus" @click="goosDetailshowFlag = false">
            <view class="buyNowBut" @click="addCart">确定</view>
          </view>
        </view>
      </view>
    </u-popup>
  </view>
</template>

<script setup>
// selectCompose
import { ref } from "vue";
import { onLoad } from "@dcloudio/uni-app";
import { request } from "../../utils/request";
import API from "../../config/api";
import { VUE_APP_STATIC_URL } from "@/config/api";

const page = ref(1);
const pageSize = ref(10);
const list = ref([]);
const pricing = ref({});
const productList = ref([]);
const ruleList = ref([]);
const autoplay = ref(true);
const duration = ref(2000);
const vertical = ref(true);
const circular = ref(true);
const buyNum = ref(1);
const goosDetailshowFlag = ref(false);
const shopId = ref(0);
const skuId = ref(0);
const terminal = ref(1);
const skuPrice = ref('');
const skuOriginalPrice = ref('');
const attrItemIdArr = ref([]);
const detailList = ref([]);
const subIndex = ref([]);
const selectArr = ref([]);
const skuProdList = ref([]);
const stockNumber = ref(0);
const skuImg = ref('');
const currentIndex = ref(null);
const priceId = ref(null);
const skuProdId = ref(null);
const ifGroupPro = ref(false);
const attrList = ref([]);
const attrValueList = ref([]);

onLoad((option) => {
  priceId.value = option.priceId
  getSelectByPriceId() // 获取定价
  getSelectProductListByPriceId()
})

const getSelectByPriceId = async () => {
  try {
    const res = await request(API.selectByPriceId,{
      priceId: priceId.value
    },'GET')
    ruleList.value = res.data
  } catch (err) {
    throw new Error(err)
  }
}

const productId = ref('')

const showRuleBox = async (item, index) => {
  shopId.value = item.shopId
  productId.value = item.productId
  skuId.value = item.skuId
  currentIndex.value = index
  await getProductSku()
  await queryProductDetail()
  goosDetailshowFlag.value = true
}

const getSelectProductListByPriceId = async () => {
  try {
    const res = await request(API.selectProductListByPriceId,{
      priceId: priceId.value,
      page: page.value,
      pageSize: pageSize.value
    },'GET')
    uni.hideLoading()
    var proList = res.data.list
    proList.forEach((item) => {
      item['selected'] = 0
      productList.value.push(item)
    })
  } catch (err){}
}

//商品详情
const goodsDateils = (shopId,productId,skuId) => {
  uni.navigateTo({
    url: 'goodsDetails?shopId='+shopId + '&productId='+productId +'&skuId='+skuId
  })
}

//获取商品详情
const queryProductDetail = async () => {
  try {
    const res = await request(API.QueryProductDetail, {
      shopId: shopId.value,
      productId: productId.value,
      skuId: skuId.value,
      terminal: 1
    },"GET")
    detailList.value = res.data
    skuPrice.value = res.data.price
    skuOriginalPrice.value = res.data.originalPrice
    for (let i = 0; i < res.data.attrList.length; i++) {
      subIndex.value[i] = 0
    }
    attrItemIdArr.value[0] = res.data.attrList[0].attrValueList[0].id
  } catch (err) {}
}

/**
 * 获取产品SKU
 * @param productId 产品id
 * @returns {Promise<void>}
 */
const getProductSku = async () => {
  try {
    const res = await request(API.QueryProductSku, {
      skuId: skuId.value,
      productId: productId.value
    }, 'GET')
    skuProdList.value = res.data
    attrList.value = res.data.names
    attrValueList.value = res.data.names[0].values
    //渲染商详之后，默认先选中第一个规格
    colorActiveClick(attrValueList.value[0], 0, 0)
    skuProdId.value = skuId.value
    skuPrice.value = res.data.price
    skuOriginalPrice.value = res.data.originalPrice
    stockNumber.value = res.data.stockNumber
    detailList.value.ifHuabei = res.data.ifHuabei
    // this.$forceUpdate()
  } catch (err) {
    throw new Error(err)
  }
}
/**
 * 颜色选中事件
 */
const colorActiveClick = (res, index, resIndex) => {
  skuImg.value = ''
  attrItemIdArr.value = []
  selectArr.value[index] = res
  subIndex.value[index] = resIndex
  attrItemIdArr.value[index] = res.valueCode
  checkItem()
  checkItemDataClick(attrItemIdArr.value)
}

const checkItemDataClick = (attrItemIdArr) => {
  let attrkey = ''
  for (let i = 0; i < attrItemIdArr.length; i++) {
    attrkey += attrItemIdArr[i] + ','
  }
  attrkey = attrkey.substring(0, attrkey.length - 1)
  let mapinfo = skuProdList.value.map
  for (var key in mapinfo) {
    if (attrkey == key) {
      skuProdId.value = mapinfo[key].skuId
      skuImg.value = mapinfo[key].skuImg
      skuPrice.value = mapinfo[key].price
      skuOriginalPrice.value = mapinfo[key].originalPrice
      stockNumber.value = mapinfo[key].stockNumber
    }
  }
  var currentCode = ''
  for (var i = 0; i < attrItemIdArr.length; i++) {
    if (i === 1 && attrItemIdArr.length > 1) {
      currentCode += ',' + attrItemIdArr[i]
    } else {
      currentCode += attrItemIdArr[i]
    }
  }
  for (let key in skuProdList.value.map) {
    if (key == currentCode) {
      skuImg.value = skuProdList.value.map[key].image
      detailList.value.originalPrice = skuProdList.value.map[key].originalPrice
      if (skuProdList.value.map[key].activityType == 1) {
        ifGroupPro.value = true
        return false
      } else {
        ifGroupPro.value = false
      }
    }
  }
  // 单规格
  if(currentCode==='' && Object.keys(mapinfo)[0] === '单款项'){
    skuImg.value =mapinfo['单款项'].image
  }

}

const checkItem = () => {
  var option = attrList.value
  var result = [] // 定义数组存储被选中的值
  for (let i in option) {
    result[i] = selectArr.value[i] ? selectArr.value[i] : ""
    if (!subIndex.value[i]) {
      subIndex.value[i] = 0
    }
    if (!attrItemIdArr.value[i]) {
      attrItemIdArr.value[i] = option[i].values[0].valueCode
    }
  }
  for (let i in option) {
    var last = result[i]; // 把选中的值存放到字符串last去
    for (let k in option[i].item) {
      result[i] = option[i].item[k].name; // 赋值，存在直接覆盖，不存在往里面添加name值
    }
    result[i] = last; // 还原，目的是记录点下去那个值，避免下一次执行循环时避免被覆盖
  }
  // this.$forceUpdate(); // 重绘
}

/**
 * 数量减
 */
const numSub = () => {
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
 * 数量加
 */
const numAdd = () => {
  if (buyNum.value < stockNumber.value) {
    buyNum.value = buyNum.value + 1
  } else {
    uni.showToast({
      title: '库存不足！',
      icon: "none"
    })
  }
}

/**
 * 加入购物车
 */
const addCart = async () => {
  //判断是否登录
  if (stockNumber.value < 1) {
    uni.showToast({
      title: '库存不足',
      icon: "none"
    })
  } else {
    try {
      const res = request(API.ShoppingaddCart, {
        skuId: skuProdId.value,
        number: buyNum.value,
      }, 'POST')
      uni.hideLoading()
      uni.showToast({
        title: '添加成功',
        icon: 'none'
      })
      setTimeout(() => {
        productList.value[currentIndex.value].selected = 1
        goosDetailshowFlag.value = false
        uni.showModal({
          title: '温馨提示',
          content: '商品已成功加入购物车？',
          confirmText: "去结算",
          cancelText: '继续添加',
          success: res => {
            if (res.confirm) {
              uni.switchTab({
                url: '../../pages/tabbar/cart/index'
              })
            } else if (res.cancel) {
              console.log('用户点击取消')
            }
          }
        })
      }, 1000);
      buyNum.value = 1
    } catch (err) {
      uni.hideLoading()
      if (res.data.code == 40005) {
        uni.navigateTo({
          url: '../../pages_category_page2/userModule/login'
        })
      }
    }
  }
}
</script>

<style lang="scss" scoped>
@import "../../style/images";
page {
  background: #333333;
}
  .combinationBox {
    .topInfo {
      margin: 40rpx 0;
      .topBg {
        margin: 30rpx auto;
        width: 670rpx;
        height: 86rpx;
        line-height: 86rpx;
        text-align: center;
        background: $combinationBg no-repeat center center;
        background-size: contain;
        overflow: hidden;
      }
    }
    .combinationList {
      display: flex;
      flex-flow: wrap;
      justify-content: space-between;
      padding: 0 20rpx;
      .combinationItem {
        margin-bottom: 30rpx;
        background: #FFFFFF;
        .imgBox {
          width: 348rpx;
          height: 314rpx;
          background: #F5F5F5;
          image {
            width: 100%;
            height: 100%;
            object-fit: contain
          }
        }
        .itemInfoBox {
          padding: 20rpx;
          width: 348rpx;
          .itemTit {
            color: #333333;
            font-size: 28rpx;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
            margin-bottom: 15rpx;
          }
          .itemNum {
            color: #C5AA7B;
            font-size: 20rpx;
            font-weight: 400;
            border: 2rpx solid #E4E5E6;
            display: inline;
            padding: 5rpx 10rpx;
          }
          .addInfo {
            display: flex;
            align-items: center;
            justify-content: space-between;
            .price {
              font-size: 40rpx;
              color: #C83732;
            }
            .selectBtn {
              width: 80rpx;
              height: 80rpx;
              display: flex;
              align-items: center;
              justify-content: center;
              image {
                width: 54rpx;
                height: 54rpx;
              }
            }
          }
        }
      }
    }
  }
.goosDetailshow-box {
  padding-bottom: 10upx;
  .detailImg-box {
    margin-top: 30upx;
    margin-left: 30upx;
    border-bottom: 2upx solid #EDEDED;
    padding-bottom: 20upx;
    width: 100%;
    .detailImg {
      width: 180upx;
      height: 180upx;
    }
  }

  .color-box {
    padding: 30upx 30upx;
    border-bottom: 1upx solid #EDEDED;
    width: 100%;

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

  .goodsNum-box {
    padding: 30upx 30upx;
    width: 100%;
    padding-bottom: 200upx;
    .goodsNum{
      height: 50upx;

      text {
        display: inline-block;
        width: 50upx;
        height: 50upx;
        border: 1upx solid #999999;
        text-align: center;
        line-height: 50upx;
      }

      .subtract {
        border-right: 0upx;
      }

      .add {
        border-left: 0upx;
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
      width: 343upx;
      height: 80upx;
      background-color: #333333;
      font-size: 28upx;
      line-height: 80upx;
      text-align: center;
      color: #FFEBC4;
    }
    .cancelBtn {
      background-color: #FFFFFF !important;
      border: 2rpx solid #333333;
      color: #333333;
    }
  }
  .btnBox {
    padding-bottom: 20rpx;
  }
}
</style>
