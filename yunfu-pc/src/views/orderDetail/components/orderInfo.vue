<template>
  <div class="orderDetailInfo">
    <div class="title">订单信息</div>
    <div class="top">
      <p class="order">订单编号： {{ data.orderId }}</p>
      <p class="des">物流单号：{{ data.deliverFormid }}</p>
      <p class="bottom">物流公司：{{ data.express }}</p>
    </div>
    <div class="top">
      <p class="order">创建时间：{{ data.createTime }}</p>
      <p class="des">备注：{{ data.des }}</p>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    data: {
      type: Object,
      default: () => ({
        orderId: '',
        des: '',
        createTime: ''
      })
    }
  }
}
</script>

<style lang="scss" scoped>
.orderDetailInfo{
  height: 150px;
  padding: 20px 30px;
  border: 1px solid #F3F4F5;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  .top{
    display: flex;
    p {
      min-width: 220px;
    }
    .des{
      margin-left: 100px;
    }
  }
  .title{
    font-size: 16px;
  }
  p{
    font-size: 14px;
  }
}
</style>
