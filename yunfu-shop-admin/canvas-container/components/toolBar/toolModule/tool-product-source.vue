<template>
  <div class="tool-select-product">
    <div class="title">
      <span>商品来源</span>
      <div class="source-select">
        <el-radio v-model="productData.sourceType" label="1">商品</el-radio>
        <el-radio v-model="productData.sourceType" label="2">类别</el-radio>
      </div>
    </div>
    <div class="porListBox">
      <product-source-multiple :productData.sync='productData' v-if="productData.sourceType=='1'" :type="type"></product-source-multiple>
      <product-source-category :productData.sync='productData' v-if="productData.sourceType=='2'" :type="type"></product-source-category>
    </div>
  </div>
</template>

<script>
import ProductSourceCategory from './product-source-category'
import ProductSourceMultiple from './product-source-multiple'
export default {
name: "tool-product-source",
  components: { ProductSourceMultiple, ProductSourceCategory },
  data () {
    return {
      categoryList: [],
      dialogCategory: false,
      sourceType: "1",
    }
  },
  props: {
    productData: {
      type: Object,
      default: () => {}
    },
    type: {
      type: String,
      default: ''
    }
  },
  mounted () {
  },
  methods: {
  }
}
</script>

<style lang="scss" scoped>
 .tool-select-product{
   .title{
     display: flex;
     justify-content: space-between;
     margin-bottom: 10px;
   }
 }
</style>
