<template>
  <div class="orderDetailExpressInfo">
    <div class="userInfo common">
      <p class="title">收货信息</p>
      <p>
        <span v-if="data.type === 3">退货</span>收货地址：{{data.receiveAdress}}{{data.address}}</p>
      <div class="info">
          <p>
            <span v-if="data.type === 3">退货</span>收货人：{{data.receiveName}}
          </p>
          <p>
            <span v-if="data.type === 3">退货</span>收货电话：{{data.receivePhone}}
          </p>
      </div>
    </div>
    <div class="shopInfo common">
      <p class="title">卖家信息</p>
      <p>店铺名称：{{data.shopName}}</p>
      <p>联系电话：{{data.chargePersonPhone}}</p>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    data: {
      type: Object,
      default: () => ({
        receiveName: '',
        receivePhone: '',
        receiveAdress: '',
        address: '',
        shopName: '',
        chargePersonPhone: '',
        type: 0
      })
    }
  }
}
</script>

<style lang="scss" scoped>
.orderDetailExpressInfo{
  height: 150px;
  border: 1px solid #F3F4F5;
  display: flex;
  justify-content: space-between;
  .common{
    padding: 20px 30px;
    display: flex;
    flex-direction: column;
    justify-content: space-between;
    .title{
      font-size: 16px;
    }
    p{
      font-size: 14px;
    }
  }
  .userInfo{
    flex: 1;
    .info{
      display: flex;
      justify-content: space-between;
      p{
        flex: 1;
      }
    }
  }
  .shopInfo{
    flex: 1;
    border-left: 1px solid #F3F4F5;
  }
}
</style>
