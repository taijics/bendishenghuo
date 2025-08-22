<template>
  <div class="payInfo">
    <div>商品总价：<span>￥{{ data.total }}</span></div>
    <div>运费：<span>￥{{ data.expressPrice }}</span></div>
    <div>平台优惠：<span>- ￥{{ data.discount }}</span></div>
    <div>
      <b v-if="data.paymentState === 0">需付款：</b>
      <b v-if="data.paymentState === 1">需付款：</b>
      <b v-if="type === 3 && data.paymentState === 1">退款金额：</b>
      <span>￥{{ data.payPrice }}</span>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    data: {
      type: Object,
      default: () => ({
        total: 0,
        expressPrice: 0,
        discount: 0,
        payPrice: 0,
        paymentState: 0 // 是否支付 0未支付 1已支付
      })
    },
    type: {
      type: Number,
      default: 0 // 订单类型 1拼团 3售后
    }
  }
}
</script>

<style lang="scss" scoped>
.payInfo{
  height: 70px;
  border: 2px solid #F3F4F5;
  color: #333;
  font-size: 14px;
  font-family: Microsoft YaHei;
  display: flex;
  align-items: center;
  div{
    width: 15%;
    text-align: center;
    white-space: nowrap;
  }
  span{
    color: $mainGlod;
  }
}
</style>
