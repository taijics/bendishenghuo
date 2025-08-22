<template>
  <view class="exchangeDetailBox">
<!--    <global-loading />-->
    <view class="topBg">
      <view class="exchangeCoupon flex-items">
        <view class="couponInfo">
          <view class="font-color-FFF fs60">{{currentCoupon.couponType === 1 ? `满${currentCoupon.fullMoney}减${currentCoupon.reduceMoney}元` : `打${currentCoupon.reduceMoney}折`}}</view>
          <view class="font-color-FFF mar-top-30 fs48">{{currentCoupon.couponType === 1 ? '满减券' : '折扣券'}}</view>
        </view>
      </view>
    </view>
    <view class="cent mar-top-30">
      <view class="bg integralInfo flex-display flex-sp-between">
        <view class="integralLeft flex-display">
          <view>
            <view class="fs48 font-color-C83732 flex-items">
              <view class="mar-right-20">{{currentCoupon.credit||0}}积分</view>
              <view class="remaining fs24 font-color-C83732">
                还剩{{currentCoupon.stockNumber||0}}件
              </view>
            </view>
            <view class="fs32 font-color-333" v-if="currentCoupon.fullMoney !== 0">满{{currentCoupon.fullMoney}}{{currentCoupon.couponType === 1 ? '减' : '打'}}{{currentCoupon.reduceMoney}}{{currentCoupon.couponType === 1 ? '元' : '折'}}券</view>
            <view class="fs32 font-color-333" v-if="currentCoupon.fullMoney === 0">无门槛{{currentCoupon.couponType === 1 ? '减' : '打'}}{{currentCoupon.reduceMoney}}{{currentCoupon.couponType === 1 ? '元' : '折'}}券</view>
          </view>
        </view>
        <view class="integralRight flex-column-plus flex-end">
          <view class="remaining fs28 font-color-999">已兑{{currentCoupon.takeCount||0}}</view>
        </view>
      </view>
    </view>
    <view class="cent mar-top-30">
      <view class="bg exchangeCondition">
        <view class="conditionTit fs32 font-color-333 font-weight-bold">兑换条件</view>
        <view class="flex-items flex-sp-between mar-top-30">
          <text class="fs28 font-color-333">有效期</text>
          <text class="fs28 font-color-999">{{currentCoupon.startTime.replace(/-/g, '.')}}-{{ currentCoupon.endTime.replace(/-/g, '.')}}</text>
        </view>
        <view class="flex-items flex-sp-between mar-top-30">
          <text class="fs28 font-color-333">兑换须知</text>
          <text class="fs28 font-color-999">虚拟权益兑换后不可退换</text>
        </view>
      </view>
    </view>
    <view class="cent mar-top-30">
      <view class="bg proCondition">
        <view class="conditionTit fs32 font-color-333 font-weight-bold">可用商品</view>
        <view class="productItemBox mar-top-30">
          <view class="productItem" v-for="item of productList" :key="item.productId" @click="goodsDateils(item.shopId,item.productId,item.skuId)">
            <view class="productImg">
              <image :src="item.image"></image>
            </view>
            <view class="productTit mar-top-10 fs28 font-color-333">{{ item.productName }}</view>
            <view class="productPrice font-color-C83732 fs40">￥{{ item.price }}</view>
          </view>
        </view>
      </view>
    </view>

      <wx-send-coupon @success="success" :couponList="[currentCoupon]" :isExchange="true">
<!--        <view class="exchangeBtnBg flex-items">-->
<!--          <view class="exchangeBtn">立即兑换</view>-->
<!--        </view>-->
        <submit-button position="bottom" @submitEvent="exchangeFn" bg-color="#fff"></submit-button>
      </wx-send-coupon>
    <!-- 签到弹窗 -->
    <tui-modal :show="exchangeTips" :custom="true" :fadein="true">
      <view class="Put-box1">
        <view class="text-align fs34 fs-bold">
          是否兑换此优惠券
        </view>
        <view class="flex-display flex-sp-between">
          <view class="btn" @click="exchangeTips = false">
            取消
          </view>
          <view class="btn submit" @click="exchangeFn">
            确定
          </view>
        </view>
      </view>
    </tui-modal>
  </view>
</template>

<script setup>
import {ref} from "vue";
import tuiModal from "@/components/modal/modal";
import {request} from "../../utils/request";
import API from "../../config/api";
import WxSendCoupon from "../../components/wx/wxSendCoupon";
import {onLoad, onReachBottom} from "@dcloudio/uni-app";
import { btnUseLoading } from '../../hooks/bntUseLoading'

const { btnShowLoading, btnHideLoading } = btnUseLoading()
const productList = ref([]);
const page = ref(1);
const pageSize = ref(10);
const loadingType = ref(0);
const currentCoupon = ref({
  stockNumber: 0,
  credit: 0,
  takeCount: 0
});
const exchangeTips = ref(false);

onReachBottom(() => {
  if(loadingType.value == 1){
    uni.stopPullDownRefresh()
  }else{
    page.value = page.value + 1
    getProductList()
  }
})

onLoad((options) => {
  if (options.data) {
    currentCoupon.value = JSON.parse(options.data)
    console.log(currentCoupon.value)
    getProductList()
  }
})

const getProductList = async () => {
  // uni.showLoading({
  //   title: '加载中...',
  // })
  try {
    const res = await request(API.getCouponProducts, {
      activityId: currentCoupon.value.couponId,
      page: page.value,
      pageSize: pageSize.value
    }, 'GET')
    if (res.code === '200') {
      productList.value = productList.value.concat(res.data.list)
      if (productList.value.length == res.data.total) {
        loadingType.value = 1
      }
    }
  } catch (err) {}
}

const receiveCoupon = () => {
  exchangeTips.value = true
}

const exchangeFn = async () => {
  btnShowLoading()
  let paramsData = {
    couponId: currentCoupon.value.couponId,
    source: 3
  }
  try {
    const res = await request(API.exchangeCoupon, paramsData, 'POST')
    exchangeTips.value = false
    uni.showToast({
      title: '兑换成功',
      icon:"success"
    })
    uni.navigateTo({
      url: '/pages_category_page1/integral/index?tabActive=2'
    })
  } catch (res) {
    if(res.code !== '200'){
      uni.showToast({
        title:res.data.message,
        icon:"none"
      })
    }
  } finally {
    btnHideLoading()
  }
}

// 商品详情
const goodsDateils = (shopId, productId, skuId) => {
  uni.navigateTo({
    url: '/pages_category_page1/goodsModule/goodsDetails?shopId='+shopId + '&productId='+productId +'&skuId='+skuId
  })
}

const success = () => {
  uni.showToast({
    title: '兑换成功',
    icon:"success"
  })
  uni.navigateTo({
    url: '/pages_category_page1/integral/index?tabActive=2'
  })
}
</script>

<style lang="scss" scoped>
@import "../../style/images";
page {
  background: #F8F8F8;
}
.exchangeDetailBox {
  padding-bottom: 200rpx;
  background: #F8F8F8;
 .topBg {
   background: $addBankBg no-repeat left top;
   background-size: contain;
   height: 350rpx;
   padding: 40rpx 20rpx 0 20rpx;
   .exchangeCoupon {
     background: $exchagneCoupon no-repeat left top;
     background-size: contain;
     height: 302rpx;
     border-radius: 16rpx;
     .couponInfo {
       color: #FDFED6;
       margin-left: 48rpx;
       font-weight: 400;
     }
   }
  }
  .cent {
    padding: 0 20rpx;
    .bg {
      background: #FFFFFF;
      padding: 30rpx;
      border-radius: 16rpx;
    }
  }
  .integralInfo {
    .integralLeft {
      .remaining {
        width: auto;
        height: 48rpx;
        line-height: 48rpx;
        padding: 0 15rpx;
        text-align: center;
        background: rgba(200, 55, 50, 0.16);
        border-radius: 24rpx 24rpx 24rpx 0;
        font-weight:300;
      }
    }
  }
  .conditionTit {
    border-bottom: 2rpx solid #F3F4F5;
    height: 92rpx;
    line-height: 92rpx;
  }
  .productItemBox {
    display: flex;
    flex-wrap: wrap;
    justify-content: flex-start;
    width: 100%;
    .productItem {
      height: 420rpx;
      flex: 1;
      margin: 0 20rpx 40rpx 0;
      width: calc((100% - 20rpx) / 2);
      min-width: calc((100% - 20rpx) / 2);
      max-width: calc((100% - 20rpx) / 2);
      &:nth-child(2n) {
        margin-right: 0;
      }
    }
  }
  .proCondition {
    .productItem {
      .productImg {
        width: 325rpx;
        height: 325rpx;
        image {
          width: 100%;
          height: 100%;
        }
      }
      .productTit {
        overflow:hidden;
        text-overflow:ellipsis;
        white-space:nowrap;
      }
      .productPrice {
        margin-top: 15rpx;
      }
    }
  }
  .exchangeBtnBg {
    width: 750rpx;
    height: 164rpx;
    background: #FFFFFF;
    box-shadow: 0 -1rpx 0rpx rgba(197, 202, 207, 0.5);
    padding: 0 20rpx;
    position: fixed;
    left: 0;
    bottom: 0;
    .exchangeBtn {
      width: 100%;
      height: 100rpx;
      line-height: 100rpx;
      text-align: center;
      background: #333333;
      border-radius: 50rpx;
      color: #FFEBC4;
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
      margin-left: 20rpx;
    }
  }
  .btn-pad {
    padding: 0 32rpx;
  }
}
</style>
