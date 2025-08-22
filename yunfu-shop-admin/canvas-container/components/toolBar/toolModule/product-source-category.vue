<template>
  <div class="product-source-category">
    <div class="porListBox">
      <div class="addProduct">
        <div v-if="!productData.categoryName" class="addProBtn addImgBtn" @click="addProductCls"><span class="iconfont">&#xe685;</span>添加类别</div>
        <div v-else class="categoryName">
          <span>{{productData.categoryName}}</span>
          <div class="operation">
            <span class="iconfont" @click="replaceCategory">&#xe66c;</span>
            <span class="iconfont" @click="deleteCategory">&#xe633;</span>
          </div>
        </div>
      </div>
    </div>
    <el-dialog title="选择类别" :visible.sync="dialogCategory" width="600px">
      <el-cascader style="width: 100%"
                   ref="cascader"
                   :options="categoryList"
                   :props="{ checkStrictly: true,label: 'categoryName',value: 'id',children: 'childs' }"
                   clearable></el-cascader>
      <span slot="footer" class="dialog-footer">
        <el-button @click="dialogCategory = false">取 消</el-button>
        <el-button type="primary" @click="addCategoryData">确 定</el-button>
      </span>
    </el-dialog>
  </div>
</template>

<script>
import api from '@@/components/canvasShow/config/api'
import {sendReqMixin} from '@@/components/canvasShow/config/mixin'
import {checkEmptyChild} from '@@/config/common'
import { mapMutations } from 'vuex'
export default {
name: "product-source-category",
  mixins: [sendReqMixin],
  data () {
    return {
      categoryList: [],
      dialogCategory: false,
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
    // 获取类别
    getCategory () {
      var _this = this
      let params = {
        url: api.getClassify,
        method: 'GET'
      }
      this.sendReq(params, (res) => {
        _this.categoryList = res.data
        checkEmptyChild(_this.categoryList)
        _this.dialogCategory = true
      })
    },
    // 添加类别
    addProductCls () {
      this.getCategory()
    },
    // 替换类别
    replaceCategory () {
      this.getCategory()
    },
    // 删除已选类别
    deleteCategory () {
      this.productData.categoryName = ''
      this.productData.categoryId = ''
      this.viewRefresh()
    },
    // 添加类别
    addCategoryData () {
      let nodesObj = this.$refs['cascader'].getCheckedNodes()
      if (nodesObj) {
        var categoryId = nodesObj[0].value
        var categoryName = nodesObj[0].label
        this.productData.categoryId = categoryId
        this.productData.categoryName = categoryName
        this.dialogCategory = false
        this.viewRefresh()
      }
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
      .categoryName {
        height: 35px;
        display: flex;
        align-items: center;
        background: #e9e9e9;
        border-radius: 4px;
        padding: 0 10px;
        justify-content: space-between;
        span {
          color: #333333;
        }
        span {
          color: #333333;
        }
        .operation {
          display: flex;
          span {
            width: 35px;
            display: block;
            height: 35px;
            line-height: 35px;
            text-align: center;
            cursor: pointer;
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
