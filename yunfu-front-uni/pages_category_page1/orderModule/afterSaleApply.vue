<!-- 申请售后 -->
<template>
  <view>
    <view class="content">
      <view class="order-list-box">
        <view class="item">
          <view class="order-info-box">
            <view class="order-info">
              <u-checkbox-group @change="checkboxGroupChange">
                <u-checkbox
                    active-color="#C5AA7B"
                    shape="circle"
                    size="40"
                    v-for="(item, index) in item.skus"
                    :key="index"
                    v-model="item.checked"
                    :name='item.skuId'
                    @change="checkboxChange(item)">
                  <view class="order-info-item">
                    <image :src="item.image"
                           class="product-img"></image>
                    <view class="info-box">
                      <text class="product-name">{{ item.productName }}</text>
                      <view class="product-sku">{{ item.value }}</view>
                      <view class="price-sku-box">
                        <text class="product-price">
                          <text class="fuhao">￥</text>
                          {{ item.price }}
                        </text>
                        <text class="product-num">x {{ item.number }}</text>
                      </view>
                    </view>
                  </view>
                </u-checkbox>
              </u-checkbox-group>
            </view>
          </view>
        </view>
      </view>
      <view class="afterSale-select-box">
        <view class="selectBtn flex-items flex-sp-between">
          <view class="selectBox">
            <checkbox-group name="allCheck"
                            @change="changeAll">
              <label>
                <checkbox color="#C5AA7B"
                          :value="allCheck.value"
                          :checked="allCheck.checked"/>
                <text>{{ allCheck.name }}</text>
              </label>
            </checkbox-group>
          </view>
          <view class="selectRight flex-items">
            <view class="selectNum">{{ number || 0 }}件商品</view>
            <view class="totalPrice">合计：
              <text>￥{{ total.toFixed(2) }}</text>
            </view>
          </view>
        </view>
        <view class="afterBtnBox flex-items flex-sp-between">
          <view class="afterBtn1"
                @click="ReturnMoney(item)">仅退款
          </view>
          <view v-if="distribution !== 1"
                class="afterBtn2"
                @click="ReturnGoods(item)">退款退货
          </view>
        </view>
      </view>
    </view>
  </view>
</template>

<script setup>
import { inject, nextTick, ref } from "vue"
import { request } from '../../utils/request'
import API from "../../config/api"
import { onLoad } from "@dcloudio/uni-app"

const item = ref({});
const checkboxChangelist = ref([])
const xuanzlist = ref([])
const allCheck = ref({
  name: '全选',
  value: 'all',
  checked: false
})
const number = ref(null)
const total = ref(0)
const skuLength = ref(0)
const distribution = ref(null)
const isAllSelect = ref(0)
const evaluated = ref(0)
const $getJumpParam = inject('$getJumpParam')
onLoad((options) => {
  item.value = $getJumpParam(options);
  item.value.skus.forEach(item=>item.checked = false)
  skuLength.value = item.value.skus.length
  distribution.value = item.value.skus[0].distribution
  if([2].includes(item.value.state)){
    distribution.value = 1
  }
  evaluated.value = options.isAllSelect
})
/**
 * 算钱
 * @returns {Promise<unknown>}
 * @constructor
 */
const HandleGetRefundMoney = () => {
  return new Promise((resolve, reject) => {
    if (xuanzlist.value.length <= 0) {
      resolve(0)
      return
    }
    let postData = {
      orderId: item.value.orderId,
      isAllSelect: evaluated.value == 1 ? xuanzlist.value.length === item.value.skus.length ? 1 : 0 : 0,
      skus: xuanzlist.value
    }
    request(API.GetRefundMoney, postData, "POST").then(res => {
      uni.hideLoading()
      resolve(parseFloat(res.json))
    })
  })
}
/**
 * 申请退款
 */
const ReturnMoney = (obj) => {
  if (item.value.orderPrice != item.value.price && xuanzlist.value.length != skuLength.value) {
    uni.showToast({
      title: '改价后的订单不允许拆开售后',
      duration: 1000,
      icon: 'none'
    })
    return
  }
  if (xuanzlist.value.length <= 0) {
    uni.showToast({
      title: '请选择退款的商品',
      duration: 2000,
      icon: 'none'
    })
  } else {
    uni.setStorageSync('afterSaleApplyRefund', xuanzlist.value)
    uni.navigateTo({
      url: 'afterSaleApplyRefund?orderId=' + item.value.orderId + '&isAllSelect=' + (evaluated.value==1 ? isAllSelect.value : 0)
    })
  }
}

/**
 * 全选
 * @param e
 * @returns {Promise<void>}
 */
const changeAll = async (e) => {
  if (e.detail.value.length == 0) {
    item.value.skus.map((item) => {
      item.checked = false
    })
    allCheck.value.checked = false
    // this.item.skus.map(item => this.$set(item, 'checked', false));
    // this.$set(this.allCheck, 'checked', false);
    xuanzlist.value = []
    if (item.value.state === 4 && evaluated.value != undefined) {
      isAllSelect.value = evaluated.value
    } else {
      isAllSelect.value = 0
    }
  } else {
    item.value.skus.map((item) => {
      item.checked = true
    })
    allCheck.value.checked = true
    // this.item.skus.map(item => this.$set(item, 'checked', true));
    // this.$set(this.allCheck, 'checked', true);
    if (item.value.state === 4 && evaluated.value != undefined) {
      isAllSelect.value = evaluated.value
    } else {
      isAllSelect.value = 1
    }
    xuanzlist.value = item.value.skus.filter(item => item.checked == true)
    number.value = 0
    // this.total = 0
    item.value.skus.forEach((item) => {
      number.value = number.value + item.number
    })
  }
  total.value = await HandleGetRefundMoney()
}

/**
 * 申请退货
 */
const ReturnGoods = () => {
  if (item.value.orderPrice != total.value && xuanzlist.value.length != skuLength.value) {
    uni.showToast({
      title: '改价后的订单不允许拆开售后',
      duration: 1000,
      icon: 'none'
    })
    return
  }
  if (xuanzlist.value.length <= 0) {
    uni.showToast({
      title: '请选择退货的商品',
      duration: 2000,
      icon: 'none'
    })
  } else {
    uni.navigateTo({
      url: 'afterSaleApplyRetund?list=' + encodeURIComponent(JSON.stringify(xuanzlist.value)) + '&orderId=' + item.value.orderId + '&isAllSelect='+ (evaluated.value == 1 ? isAllSelect.value : 0)
    })
  }
}

const checkboxGroupChange = (e) => {
  // console.log(e, 'fdsfdsfsdf')
}

const checkboxChange = async (e) => {
  nextTick(async ()=>{
    //console.log(item.value.skus)
    // 动态设置商品件数和总计
    if (!e.checked) {
      number.value = number.value - e.number
    } else {
      number.value = number.value + e.number
    }
    // 筛选勾选的
    xuanzlist.value = item.value.skus.filter(item => item.checked == true)

    // 是否为全选
    if (item.value.skus.length == xuanzlist.value.length) {
      if (item.value.state === 4 && evaluated.value != undefined) {
        isAllSelect.value = evaluated.value
      } else {
        isAllSelect.value = 1
      }
      allCheck.value.checked = true
    } else {
      if (item.value.state === 4 && evaluated.value != undefined) {
        isAllSelect.value = evaluated.value
      } else {
        isAllSelect.value = 0
      }
      allCheck.value.checked = false
    }
    total.value = await HandleGetRefundMoney()
  })

}
</script>

<style lang="scss"
       scoped>
page {
  background: #F8F8F8;
}

.order-list-box {
  padding: 20upx 30upx;
  box-sizing: border-box;
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
  border-bottom: 1px solid #eee;
}

.top-l {
  display: flex;
  flex-direction: row;
  align-items: center;
}

.shop-img {
  width: 36upx;
  height: 36upx;
  margin-right: 10upx;
}

.shop-name {
  font-size: 30upx;
  color: #333;
  font-weight: bold;
}

.arrow-img {
  margin-left: 15upx;
  width: 24upx;
  height: 24upx;
}

.order-status {
  font-size: 28upx;
  color: #ff7911;
  font-weight: 500;
}

.order-info-box {
  padding: 0 30upx;
  box-sizing: border-box;
}

.order-info {
  /* border-bottom: 1px solid #eee; */
}

.order-info-item {
  display: flex;
  flex-direction: row;
  padding: 10upx 20upx;
  border-bottom: solid 1px #eee;
  width: 600rpx;
}

.order-info-item:last-child {
  border-bottom: none;
}

.product-img {
  width: 180upx;
  height: 180upx;
  border-radius: 10upx;
  margin-right: 30upx;
}

.info-box {
  flex: 1;
  display: flex;
  flex-direction: column;
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
  display: flex;
  flex-direction: row;
  justify-content: space-between;
  margin-top: 10upx;
}

.product-sku {
  font-size: 24upx;
  color: #999;
  margin-top: 30upx;
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
  font-size: 28upx;
  color: #999;
}

.afterSale-select-box {
  position: fixed;
  bottom: 0;
  width: 100%;
  background: #fff;
  padding: 30rpx;
  box-sizing: border-box;
  height: 240rpx;
}

.afterBtnBox {
  margin-top: 30rpx;

  .afterBtn1 {
    width: 342rpx;
    line-height: 100rpx;
    border: 2rpx solid #333333;
    text-align: center;
    color: #333333;
    margin-right: 30rpx;
  }

  .afterBtn2 {
    width: 342rpx;
    height: 100rpx;
    line-height: 100rpx;
    background: #333333;
    border: 2rpx solid #333333;
    text-align: center;
    color: #FFEBC4;
  }
}
</style>
