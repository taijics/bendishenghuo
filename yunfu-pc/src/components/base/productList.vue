<template>
  <div class="product">
    <div class="productBox"
      v-for="(item, index) in productList"
      :key="index"
    >
      <img class="cur-poi" :src="item.image" alt="" @click="toProductDetail(item)" />
      <p class="productName">{{ item.productName }}</p>
      <!-- 简介 -->
      <p class="productDesc">
        <span v-if="$route.name=='store' || $route.name=='search'">{{ item.productBrief }}</span>
      </p>
      <div class="price">
        <span class="presentPrice">¥{{ item.price }}</span>
        <span class="originalPrice">¥{{ item.originalPrice }}</span>
      </div>
      <p class="shopName cur-poi"
        v-if="$route.name=='category'"
        @click.stop="toStore(item.shopId)"
      >
        {{ item.shopName }}
      </p>
    </div>
  </div>
</template>
<script>
export default {
  props: ['productList'],
  data  () {
    return {}
  },
  methods: {
    toProductDetail (item) {
      let data = {
        productId: item.productId,
        skuId: item.skuId,
        shopId: item.shopId
      }
      this.$router.push({
        path: '/productDetail',
        query: {
          proData: JSON.stringify(data)
        }
      })
    },
    // 跳转到店铺
    toStore (id) {
      this.$router.push({
        path: '/store',
        query: {
          shopId: id
        }
      })
    }
  }
}
</script>
<style lang="scss" scoped>
.product {
  width: 100%;
  display: flex;
  flex-flow: wrap;
  margin-bottom: 30px;
  .productBox {
    width: 23%;
    margin: 10px 1%;
    transition: all 0.3s linear;
    text-align: center;
    img {
      width: 100%;
      height: 282px;
      margin-bottom: 27px;
    }
    .productName {
      font-weight: bold;
      margin-bottom: 12px;
      white-space: nowrap;
      overflow: hidden;
      text-overflow: ellipsis;
    }
    .price {
      margin-bottom: 12px;
      .presentPrice {
        font-size: 18px;
        font-weight: bold;
        color: #C83732;
      }
      .originalPrice {
        font-size: 16px;
        text-decoration: line-through;
        margin-left: 10px;
      }
    }
    .productDesc,.shopName {
      margin-top: 20px;
      color: #999999;
      display: flex;
      align-items: center;
      justify-content: center;
      margin-bottom: 30px;
    }
    .productDesc{
      span{
        max-width: 200px;
        height: 20px;
        margin: auto;
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
      }
    }
    .shopName{
      cursor: pointer;
    }
  }
  // .productBox:nth-of-type(4n){
  //   margin-right: 0;
  // }
  .productBox:hover{
    box-shadow:0 0 20px #cccccc;
  }
}
</style>
