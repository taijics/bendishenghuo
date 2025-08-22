<template>
  <div class="productInfo">
    <img :src="productData.productImage" @click="toProductDetail"/>
    <p class="title">{{ productData.productName }}</p>
    <div class="skus">
      <el-dropdown trigger="click" @command="chooseSku" >
        <span class="el-dropdown-link">
          {{ currentSku.skuName || '请选择规格' }}<i class="el-icon-arrow-down el-icon--right"></i>
        </span>
        <el-dropdown-menu slot="dropdown">
          <el-dropdown-item
            v-for="item in productData.composeSkuInfoList"
            :key="item.skuId"
            :command="item"
          >{{ item.skuName }}</el-dropdown-item>
        </el-dropdown-menu>
      </el-dropdown>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    productData: {
      type: Object,
      default: () => ({})
    },
    index: Number
  },
  data () {
    return {
      currentSku: {
        price: 0,
        skuId: 0,
        skuName: ''
      }
    }
  },
  methods: {
    toProductDetail () {
      this.$emit('jump', {
        productId: this.productData.productId,
        skuId: this.productData.composeSkuInfoList[0].skuId
      })
    },
    chooseSku (item) {
      this.currentSku = item
      this.$emit('getsku', {
        item,
        index: this.index
      })
    }
  }
}
</script>

<style lang="scss" scoped>
.productInfo{
  width: 180px;
  display: flex;
  flex-direction: column;
  img{
    width: 100px;
    height: 100px;
    margin: auto;
    cursor: pointer;
  }
  .title{
    width: 100%;
    margin: 10px 0;
    text-align: center;
    color: #FFFFFF;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
  }
  $txtHeight: 25px;
  .skus{
    width: 120px;
    height: $txtHeight;
    margin: auto;
    border: 1px solid #B7B7B7;
    position: relative;
  }
  >>>.el-dropdown{
    width: 100%;
    height: 100%;
    text-align: center;
    line-height: $txtHeight;
    cursor: pointer;
    color: #B7B7B7;
  }
}
</style>
