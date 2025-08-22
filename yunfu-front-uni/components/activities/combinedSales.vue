<template>
  <view class="group-list" v-if="selectComposeData && selectComposeData.length > 0">
    <view class="group-warp">
      <view class="title">
        <label>
          <image class="title-img" :src="`${VUE_APP_STATIC_URL}static/images/combinationIcon.png`" alt="组合销售" mode="widthFix"></image>
        </label>
        <view class="price-text">
          组合价：¥{{composePrice}}
        </view>
      </view>
      <view>
        <scroll-view class="tabs-nav" scroll-x="true">
          <view class="ul">
            <view v-for="(item,index) in selectComposeData" :key="index" class="li" :class="tabIndex===index && 'on'" @click="tabChange(index)">
              {{ item.composeName }}</view>
          </view>
        </scroll-view>
        <view class="tabs-item" v-for="(item,index) in selectComposeData" :key="index" :class="tabIndex===index && 'on'">
          <swiper class="swiper pro-box" :indicator-dots="false" :autoplay="true" :display-multiple-items="item.composeProductInfoList.length < 3?item.composeProductInfoList.length:3" @change="swiperChange" :disable-touch="item.composeProductInfoList.length <= 3">
            <swiper-item class="pro-item-warp" v-for="(itemJ,indexJ) in item.composeProductInfoList" :key="indexJ" >
              <view class="pro-item-inner">
                <view class="pro-item">
                  <view class="pro-item-img">
                    <image class="img" :src="itemJ.productImage"></image>
                  </view>
                  <view class="pro-item-info">
                    <h3 class="name">
                      {{itemJ.productName}}
                    </h3>
                    <view class="sku" @click.stop="changeSkuItemValue(itemJ, indexJ)">
                      <view class="text">{{itemJ.skuItem.skuName}}</view>
                    </view>
                  </view>
                </view>
              </view>
            </swiper-item>
          </swiper>
          <view class="swiper-dots" v-if='item.composeProductInfoList.length > 3'>
            <text :class="{'dot-active':swiperCurrent === index,'dot': true}"
                  v-for="(dot, index) in item.composeProductInfoList.length - 2"
                  :key="index"
            ></text>
          </view>
        </view>
        <view class="btn-buy" @click="doBuy">立即购买</view>
      </view>
    </view>
    <!-- 商品详情 -->
    <u-popup v-model="goodsDetailShowFlag" mode="bottom" border-radius="14">
      <view class="goosDetailshow-box">
        <view class="detailImg-box flex-row-plus">
          <image class="detailImg" :src="selectedSku.image"></image>
          <view class="flex-column-plus mar-left-40">
            <view class="font-color-C5AA7B">
              <label class="fs24">¥</label>
              <label class="fs36 mar-left-10">{{getPrice(selectedSku)}}</label>
            </view>
            <label class="fs24 font-color-999 mar-top-20">库存 {{selectedSku.stockNumber}} 件</label>
            <label class="fs24 mar-top-20">已选</label>
          </view>
        </view>
        <view class="color-box flex-column-plus">
          <view v-for="(attritem,index) in skuProData.names" :key="index" class="skuStyle">
            <label class="fs24 font-color-999">{{attritem.skuName}}</label>
            <view class="colorName-box">
              <view class="pad-bot-30" v-for="(attrRes, resIndex) in attritem.values" :key="resIndex">
                <view class="colorName"
                      :class="{'colorName-on' : getselectedAttrVal(attritem.nameCode) == attrRes.valueCode}"
                      @click="nameCodeValueCodeClick(attritem.nameCode, attrRes.valueCode, true)">
                  {{attrRes.skuValue}}
                </view>
              </view>
            </view>
          </view>
        </view>
        <!--        <view class="goodsNum-box flex-row-plus flex-sp-between" :class="{'bottom-line' :supportHuabei}">-->
        <!--          <label class="font-color-999 fs24">数量</label>-->
        <!--          <view class="goodsNum">-->
        <!--            <text class="subtract" @click="updateNumSub()">-</text>-->
        <!--            <text class="goodsNumber" v-model="buyNum">{{buyNum}}</text>-->
        <!--            <text class="add" @click.stop="-->
        <!--            ()">+</text>-->
        <!--          </view>-->
        <!--        </view>-->
        <view class="goosDetailbut-box flex-items-plus">
          <!--          <button type="default" @click="goodsDateils(shopId,productId,skuId)" >查看详情</button>-->
          <button type="default" class="submitBtn" @click="submitBtn()">确认</button>
        </view>
      </view>
    </u-popup>
  </view>
</template>

<script setup>
import API from "../../config/api";
import { request } from "@/utils/request";
import { defineProps,toRefs } from "vue";
import { getCurrentInstance, onMounted, ref } from "vue";
import { VUE_APP_STATIC_URL } from "@/config/api";

const props = defineProps({
  pid: {
    type: String,
    default: ''
  },
  productData: {
    type: Object,
    default: ()=>{}
  }
})
// 解构props
const {pid,productData} = toRefs(props)

// =============================== data ========================================
const tabIndex = ref(0);
const swiperCurrent = ref(0);
const selectComposeData = ref([]);
const curProIndex = ref(0);
const selectedSku = ref([]);
const selectedAttr = ref([]);
const skuProData = ref({});
const goodsDetailShowFlag = ref(false);
const composePrice = ref(0);

// ============================= methods ======================================
/**
 * 切换套餐
 * @param index
 */
const tabChange = (index)=>{
  tabIndex.value = index
  calculatePrice()
}

/**
 * 滑动回调方法
 * @param e
 */
const swiperChange = (e)=> {
  swiperCurrent.value = e.detail.current;
}

/**
 * 获取组合销售数据
 */
const getSelectCompose = ()=> {
  request(API.selectCompose, {
        productId: pid.value
      },
      "GET").then(res => {
    const {data} = res
    for(let i=0;i< data.length;i++) {
      let proList = data[i].composeProductInfoList
      for (let j = 0; j < proList.length; j++) {
        proList[j].skuItem = proList[j].composeSkuInfoList[0]
      }
    }
    selectComposeData.value = data
    calculatePrice()
  })
}

/**
 * 更换商品样式
 * @param item
 * @param index
 */
const changeSkuItemValue = (item,index)=> {
  curProIndex.value = index
  uni.showLoading({
    mask: true,
    title: '加载中...'
  })
  request(API.QueryProductDetail, {
        shopId: productData.value.shopId,
        productId: item.productId,
        skuId: item.skuItem.skuId,
        terminal: 1
      },
      "GET").then(res => {
    uni.hideLoading()
    const {data} = res
    //如果是单款式商品，需要特殊处理productData.names
    const mapKeys = Object.keys(data.map)
    if (mapKeys.length === 1 && mapKeys[0] === '单款项') {
      data.names[0].values.push({
        skuValue: '单款项',
        valueCode: '单款项'
      })
    }

    //如果sku的图像为空，设置为商品的图像
    for (var key in data.map) {
      let skuImage = data.map[key].image
      if (!skuImage) {
        data.map[key].image = data.images[0]
      }
    }

    skuProData.value = res.data
    goodsDetailShowFlag.value = true
    selectBySkuId(item.skuItem.skuId)
  })
}

const selectBySkuId = (skuId) => {
  if (skuId) {
    let mapinfo = skuProData.value.map
    let flag = true
    console.log(skuProData.value)
    for (var key in mapinfo) {
      if (parseInt(mapinfo[key].skuId) === parseInt(skuId)) {
        flag = false
        selectedSku.value = mapinfo[key]
        // 选中sku对应的规格
        const valueCodeList = key.split(',')
        selectedAttr.value = []
        skuProData.value.names.forEach(attr => {
          for (const index in attr.values) {
            let valueCode = attr.values[index].valueCode
            if (valueCodeList.includes(valueCode)) {
              nameCodeValueCodeClick(attr.nameCode, valueCode, false)
              break
            }
          }
        })
        break
      }
    }
    // 匹配不上就赋值第一个
    if(flag){
      for (const key in mapinfo) {
        selectedSku.value = mapinfo[key]
        break
      }
    }
  }
}

const nameCodeValueCodeClick = (nameCode, valueCode, reSelectSku)=> {
  selectedAttr.value[nameCode] = valueCode
  if (reSelectSku) {
    let attrList = []
    for (const key in selectedAttr.value) {
      attrList.push(selectedAttr.value[key])
    }
    const attrKey = attrList.join(',')
    let mapinfo = skuProData.value.map
    for (const key in mapinfo) {
      if (attrKey === key) {
        selectedSku.value = mapinfo[key]
      }
    }
  }
  getCurrentInstance().proxy.$forceUpdate() // 重绘
}

/**
 * 提交更换商品规格
 */
const submitBtn = ()=> {
  const curPro = selectComposeData.value[tabIndex.value].composeProductInfoList[curProIndex.value]
  for(let i=0;i<curPro.composeSkuInfoList.length;i++){
    if(curPro.composeSkuInfoList[i].skuId === selectedSku.value.skuId){
      selectedSku.value.skuName = curPro.composeSkuInfoList[i].skuName
    }
  }
  curPro.skuItem = selectedSku.value
  calculatePrice()
  goodsDetailShowFlag.value = false
}

/**
 * 计算组合价
 */
const calculatePrice = ()=>{
  const {composeProductInfoList:proList,composeType,promote} = selectComposeData.value[tabIndex.value] || {composeProductInfoList:[],composeType:undefined,promote:undefined}
  let total = 0
  for(let i=0;i<proList.length;i++){
    total += getPrice(proList[i].skuItem)
  }
  switch (composeType){
    case 1:
      composePrice.value = promote.toFixed(2)
      break
    case 2:
      composePrice.value = (total - promote).toFixed(2)
      break
    case 3:
      composePrice.value = parseFloat(total * promote / 10).toFixed(2)
      break
  }
}

/**
 * 根据活动显示不同价格
 * @param item
 * @returns {*}
 */
const getPrice = (item)=>{
  // 所属活动 0-常规商品 1-拼团活动 2-秒杀活动 3-限时折扣活动 4-平台秒杀 5-平台折扣 6-定价捆绑 7-组合捆绑 8-场景营销 9-会员价
  if(item.activityType){
    if(item.activityType === 0 || item.activityType === 6 || item.activityType === 7){
      return item.price
    } else {
      return item.originalPrice
    }
  } else {
    return item.price
  }
}

/**
 * 立即购买
 */
const doBuy = ()=>{
  let addCart = []
  let shopObj = {}
  shopObj["shopId"] = productData.value.shopId
  shopObj["composeId"] = selectComposeData.value[tabIndex.value].composeId
  shopObj["skus"] = []
  let proList = selectComposeData.value[tabIndex.value].composeProductInfoList
  let len2 = proList.length
  for (let j = 0; j < len2; j++) {
    let skusObj = {}
    skusObj["number"] = 1
    skusObj["skuId"] = proList[j].skuItem.skuId
    shopObj.skus.push(skusObj)
  }
  addCart.push(shopObj)
  uni.setStorageSync('skuItemDTOList', addCart)
  uni.navigateTo({
    url: '../../pages_category_page1/orderModule/orderConfirm?type=1'
  })
}

const getselectedAttrVal = (item)=>{
  return selectedAttr.value[item]
}

onMounted(()=>{
  getSelectCompose()
})
</script>

<style lang="scss" scoped>
@import "../../style/images";
.group-list{
  padding: 10upx 20upx 60upx;
  border-top: 12upx solid #F8F8F8;
  .group-warp{
    height: 680upx;

    background: #333333;
    box-shadow: 0 20upx 30upx rgba(0, 0, 0, 0.3);
    opacity: 1;
    border-radius: 20upx;
  }
  .title{
    display: flex;
    align-items:center;
    position: relative;
    justify-content: space-between;
    padding: 32upx 0 20upx 30upx;
    .title-img{
      width: 203upx;
    }
    .price-text{
      padding: 0 34upx;
      margin-right: 10upx;
      height: 50upx;
      background: linear-gradient(90deg, #C83732 0%, #E25C44 100%);
      box-shadow: 0 6upx 12upx rgba(233, 0, 0, 0.3);
      border-radius: 26upx;
      font-size: 24upx;
      color: #fff;
      text-align: center;
      line-height: 50upx;
      margin-left: 20upx;
      .swiper{
        height: 50upx;
      }
    }
  }
  .tabs-nav{
    padding: 0 10upx;
    margin-bottom: 20upx;
    .ul{
      display: flex;
      .li{
        //flex: 1 0 auto;
        text-align: center;
        font-size: 26rpx;
        color: #999;
        position: relative;
        padding: 12px 40px;
        word-break: keep-all;
        &:first-child{
          margin-left: 0;
        }
        &.on{
          color: #FFEBC4;
          &:after{
            content: '';
            width: 100%;
            height: 2rpx;
            background: #FFEBC4;
            position: absolute;
            left: 0;
            bottom: 0;
          }
        }
      }
    }
  }
  .tabs-item{
    display: none;
    &.on{
      display: block;
    }
  }
  .pro-box{
    height: 318upx;
    padding: 0 2upx 20upx;
    .pro-item-inner{
      padding: 0 8upx;
      display: flex;
      justify-content: center;
    }
    .pro-item{
      width: 219upx;
      background: #FFFFFF;
      padding: 10upx;
      height: 318upx;
      .pro-item-img{
        width: 100%;
        height: 160upx;
        .img{
          width: 100%;
          height: 100%;
          object-fit: contain;

        }
      }
      .pro-item-info{
        .name{
          font-size: 24upx;
          line-height: 34upx;
          color: #333333;
          overflow: hidden;
          text-overflow:ellipsis;
          white-space: nowrap;
          text-align: center;
          font-weight: normal;
          margin: 8upx 0 26upx;
        }
        .sku{
          width: 180upx;
          height: 50upx;
          margin: 0 auto;
          line-height: 50upx;
          border: 2upx solid #E4E5E6;
          background: $arrowSelect no-repeat right center / 60upx 60upx;
          .text{
            font-size: 24upx;
            color: #999;
            padding-left: 20upx;
            width: 160rpx;
            text-overflow:ellipsis;
            white-space: nowrap;
            overflow: hidden;
          }
        }
      }
    }
  }
  .swiper-dots{
    display: flex;
    justify-content: center;
    .dot{
      display: block;
      width: 24upx;
      height: 4upx;
      background: #FFFFFF;
      opacity: 0.5;
      border-radius: 2upx;
      margin: 0 20upx;
      &.dot-active{
        opacity: 1;
      }
    }
  }
}
.btn-buy{
  width: 688upx;
  height: 84upx;
  //border: 2upx solid rgba(0, 0, 0, 0);
  background: linear-gradient(88deg, #C5AA7B 0%, #FFEBC4 100%);
  font-size: 28upx;
  color: #333;
  line-height: 84upx;
  margin: 30upx auto 0;
  text-align: center;
}

.goosDetailshow-box {
  .detailImg-box {
    margin-top: 30rpx;
    margin-left: 30rpx;
    border-radius: 10rpx;
    border-bottom: 1rpx solid #EDEDED;
    padding-bottom: 20rpx;
    width: 690rpx;

    .detailImg {
      width: 180rpx;
      height: 180rpx;
    }
  }

  .color-box {
    padding: 30rpx 30rpx;
    border-bottom: 1rpx solid #EDEDED;
    width: 690rpx;
    .skuStyle{
      padding: 20rpx 0;
    }

    .skuStyle:nth-child(2) {
      border-top: 1px solid #F3F4F5;
    }

    .colorName-box {
      display: flex;
      flex-wrap: wrap;
      flex-direction: row;
      justify-content: flex-start;
      align-items: center;
      margin-top: 30rpx;
      margin-left: -30rpx;

      .colorName-on {
        background-color: #FFE5D0;
        color: #C5AA7B;
        margin-left: 30rpx;
        padding: 10rpx 32rpx;
        border-radius: 28rpx;
        border: 1rpx solid #C5AA7B;
        font-size: 26rpx;
        text-align: center;
        z-index: 1;
      }

      .colorName {
        background-color: #F5F5F5;
        margin-left: 30rpx;
        padding: 10rpx 32rpx;
        border-radius: 28rpx;
        font-size: 26rpx;
        z-index: 2;
      }
    }

  }

  .modelNum-box {
    padding: 30rpx 30rpx;
    border-bottom: 1rpx solid #EDEDED;
    width: 690rpx;

    .modelNumName-box {
      display: flex;
      flex-wrap: wrap;
      flex-direction: row;
      justify-content: flex-start;
      align-items: center;
      margin-top: 30rpx;
      margin-left: -30rpx;

      .modelNumName-on {
        background-color: #FFE4D0;
        color: #C5AA7B;
        margin-left: 30rpx;
        padding: 10rpx 32rpx;
        border-radius: 28rpx;
        border: 1rpx solid #C5AA7B;
        font-size: 26rpx;
        text-align: center;
      }

      .modelNumName {
        background-color: #F5F5F5;
        margin-left: 30rpx;
        padding: 10rpx 32rpx;
        border-radius: 28rpx;
        font-size: 26rpx;
      }
    }
  }

  .goodsNum-box {
    padding: 30rpx 30rpx;
    width: 690rpx;
    padding-bottom: 140rpx;

    .goodsNumber {
      text-align: center;
      border: 1rpx solid #999999;
      padding: 3rpx 20rpx;
    }

    .subtract {
      border: 1rpx solid #999999;
      padding: 3rpx 20rpx;
      margin-right: -1rpx;
    }

    .add {
      border: 1rpx solid #999999;
      padding: 3rpx 20rpx;
      margin-left: -1rpx;
    }
  }

  .goosDetailbut-box {
    .joinShopCartBut {
      width: 343rpx;
      height: 80rpx;
      background-color: #FFC300;
      color: #FFFEFE;
      font-size: 28rpx;
      line-height: 80rpx;
      text-align: center;
      margin-left: 30rpx;
    }

    .buyNowBut {
      width: 343rpx;
      height: 80rpx;
      border-radius: 0 40rpx 40rpx 0;
      background-color: #FF6F00;
      color: #FFFEFE;
      font-size: 28rpx;
      line-height: 80rpx;
      text-align: center;
    }
  }
  .submitBtn {
    width: 700rpx;
    height: 100rpx;
    line-height: 100rpx;
    font-size: 28rpx;
    border: 1px solid;
    border-radius: 0;
    color: #FFEBC4;
    background: #333333;
    margin: 20rpx 0;
  }
}
</style>
