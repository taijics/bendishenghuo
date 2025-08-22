<template>
  <div class="product-source-category">
    <div class="porListBox">
      <div class="addProduct">
        <div v-if="productData.imgTextData && productData.imgTextData.length > 0" class="productList">
          <ul @click="addProduct">
            <li v-for="(item,index) in productData.imgTextData" :key="index">
              <el-image
                style="width: 50px; height: 50px"
                :src="item.image"
                fit="contain"></el-image>
            </li>
          </ul>
        </div>
        <div v-else class="addProBtn addImgBtn" @click="addProduct"><span class="iconfont">&#xe685;</span>添加商品</div>
      </div>
    </div>
    <el-dialog title="选择产品" :visible.sync="dialogProduct">
      <product-select ref="productSelect" :selectedRows="productData.imgTextData" :isMultiple="true"></product-select>
      <span slot="footer" class="dialog-footer">
        <el-button @click="dialogProduct = false">取 消</el-button>
        <el-button type="primary" @click="addProductData">确 定</el-button>
      </span>
    </el-dialog>
  </div>
</template>

<script>
import {sendReqMixin} from '@@/components/canvasShow/config/mixin'
import ProductSelect from './product-select'
import { mapMutations } from 'vuex'
export default {
name: "product-source-multiple",
  components: { ProductSelect },
  mixins: [sendReqMixin],
  data () {
    return {
      dialogProduct: false,
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
    this.selsectValue = this.linkValue // props 不能直接修改
  },
  methods: {
    ...mapMutations({
      setNewProductNum: 'SET_NEWPRODUCTNUM',
      setProductNum: 'SET_PRODUCTNUM'
    }),
    // 添加产品
    addProduct () {
      this.dialogProduct = true
    },
    // 确定选择
    addProductData () {
      this.productData.imgTextData = this.$refs.productSelect.multipleSelection
      this.productData.productIdList = []
      let imgTextData = this.productData.imgTextData
      imgTextData.forEach(item => {
        this.productData.productIdList.push(item.productId)
      })
      console.log(this.productData.productIdList,'productIdList')
      this.dialogProduct =  false
      this.viewRefresh()
    },
    // 通知画布刷新
    viewRefresh(){
      if(this.type === 'newProduct'){
        this.setNewProductNum()
      } else {
        this.setProductNum()
      }
    }
  }
}
</script>

<style lang="scss" scoped>
.product-source-category{
  .porListBox {
    padding: 10px;
    background: #F0F3F4;
    .addProduct {
      .productList{
        ul{
          display: flex;
          cursor: pointer;
          flex-wrap: wrap;
          li{
            display: block;
            height: 50px;
            margin: 0 2px 5px 0;
            position: relative;
          }
        }
      }
      .addImgBtn {
        border-radius: 4px;
        background: $mainColor;
        text-align: center;
        height: 36px;
        color: #ffffff;
        font-size: 14px;
        display: flex;
        align-items: center;
        justify-content: center;
        cursor: pointer;
        span {
          font-size: 20px;
          margin-right: 5px;
        }
      }
    }
  }
}
</style>
