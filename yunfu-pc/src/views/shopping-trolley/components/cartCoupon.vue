<template>
  <ul class="cartCouponBox">
    <p class='title'>{{ title }}:</p>
    <li
      v-for='(item, index) in couponList'
      :key='index'
    >
      <!-- 满减券 -->
      <p class="coupon"
        v-if="item.couponType === 1 && item.state === 3"
      >
        满<span>{{ item.fullMoney }}</span>减<span>{{ item.reduceMoney }}</span>元
      </p>
      <!-- 折扣券 -->
      <p class="coupon"
        v-if="item.couponType === 2 && item.state === 3"
      >
        满<span>{{ item.fullMoney }}</span>打<span>{{ item.reduceMoney }}</span>折
      </p>
      <p class="btn"
        v-if="item.state === 3"
        v-throttle
        @click="chooseCoupon(item)"
      >立即领取></p>
    </li>
  </ul>
</template>

<script>
export default {
  props: {
    title: {
      type: String,
      default: '优惠券'
    },
    couponList: {
      type: Array,
      default: () => []
    }
  },
  methods: {
    chooseCoupon (item) {
      this.$emit('chooseCoupon', item)
    }
  }
}
</script>

<style lang="scss" scoped>
.cartCouponBox{
  margin-top: 12px;
  .title {
    font-size: 14px;
    color: #333;
  }
  // flex: 1;
  li {
    height: 40px;
    line-height: 40px;
    margin-top: 20px;
    display: flex;
    // overflow: hidden;
    .coupon{
      color: #333;
    }
    .btn{
      margin-left: 8px;
      color: #C83732;
    }
  }
}
</style>
