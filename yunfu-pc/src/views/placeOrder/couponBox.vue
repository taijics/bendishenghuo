<template>
  <div class="couponBox">
    <div class="discountList clearfix">
      <div class="couponItem"
        v-for="(item, index) of settlementData.coupons"
        :key="item.couponId"
        @click="preferentialUse(item, index)"
        :class="{active: curPrefCouponInx === index}"
      >
        <div class="couponItemTop">
          <img src="../../assets/images/indexLogo.png" alt="">
          <span>
            <i>￥</i>{{item.reduceMoney}}
          </span>
          <span style="height:15px;">使用条件：{{item.content}}</span>
          <span>有效期至：{{item.endTime}}</span>
          <div class="couponType">平台券</div>
        </div>
        <div class="couponItemBot">
          立即使用
          <span class="iconfont currentSelect"
          v-if="curPrefCouponInx === index"
          >&#xe612;</span>
        </div>
      </div>
      <div
        v-for="(item, index) of shopsData"
        :key="item.shopId"
      >
          <div class="couponItem"
          v-for="(shop) of item.shopCoupons"
          :key="shop.id"
          :class="{active: shopCoupons[index].id === shop.id}"
          @click="selectShopCoupon(item, index, shop)">
          <div class="couponItemTop">
              <img src="../../assets/images/indexLogo.png" alt="">
              <!--                <span><i>￥</i>{{item.reduceMoney}}</span>-->
              <span>优惠：{{shop.content}}</span>
              <span style="height:15px;"></span>
              <span>有效期至：{{shop.endTime}}</span>
              <div class="couponType">店铺券</div>
          </div>
          <div class="couponItemBot">
              立即使用
              <!-- <span class="iconfont currentSelect" v-if="currentShopCoupon === shopIndex">&#xe612;</span> -->
              <span class="iconfont currentSelect"
              v-if="shopCoupons[index].id === shop.id"
              >&#xe612;</span>
          </div>
          </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  props: {}
}
</script>

<style>

</style>
