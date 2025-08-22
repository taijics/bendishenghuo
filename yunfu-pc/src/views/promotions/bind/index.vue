/**
  组合捆绑专区页面
 */
<template>
  <div class="bindPage">
    <!-- <div v-if="proList.length > 0"> -->
    <div v-if="true">
        <ActivitySlot class="activityBind" :imgTitle="imgTitle">
          <template v-slot:title>
            <div class="title">
              <ul>
                <li
                  class="ruleItem"
                  v-for="(item, index) in discountList"
                  :key="index"
                >
                任选{{ item.number }}件{{ item.price }}元
                </li>
              </ul>
            </div>
          </template>
          <template v-slot:section>
            <div class="bindList" v-loading="loading">
              <div class="item"
                v-for="item in proList"
                :key="item.productId"
              >
                <ItemSlot :data="item" @toDetail="toProductDetail(item)">
                  <template v-slot:button>
                    <button class="buy" @click="showCart(item)">加入购物车</button>
                  </template>
                </ItemSlot>
              </div>
            </div>
          </template>
        </ActivitySlot>
        <el-pagination
          style="margin:20px 0;"
          background
          layout="prev, pager, next, jumper"
          :page-size="listquery.pageSize"
          :current-page="listquery.page"
          @current-change="changePage"
          :total="total">
        </el-pagination>
      </div>
      <div v-else class="noproduct">
        <icon-svg style="width: 240px; height: 240px; margin-bottom: 20px;" icon-class="user-order-nodata" />
        <p class="fs20 font-color-999">该活动没有商品～</p>
      </div>
      <!-- 商品选择规格加入购物车弹框 -->
      <el-dialog
        title="加入购物车"
        :visible.sync="sukVisible"
        width="800px"
      >
        <div class="productInfo" v-loading="loadingCheck">
          <img class="proImg" :src="productCheckData.image || ''" alt="">
          <div class="proInfo">
            <div class="title">
              <div class="name">{{ productCheckData.productName }}</div>
              <div class="price" v-if="skuValues.toString().length > 0 && productCheckData.map[skuValues.toString()]">
                ￥{{ productCheckData.map[skuValues.toString()].price || 0 }}
              </div>
              <div class="price" v-if="skuValues[0] === '' && productCheckData.map">
                ￥{{ productCheckData.map['单款项'].price || 0 }}
              </div>
            </div>
            <div class="skus" v-if="productCheckData.names">
              <ul v-if="productCheckData.names.length">
                <li
                  class="skusList"
                  v-for="(item, index) in productCheckData.names"
                  :key="item.nameCode"
                >
                  <h1>{{item.skuName}}</h1>
                  <div class="listItem"
                    v-for="(value, i) in item.values"
                    :key="i"
                    @click="skuValues.splice(index, 1, value.valueCode)"
                    :class="skuValues.indexOf(value.valueCode) !== -1 ? 'selected-item' : ''"
                  >{{ value.skuValue }}</div>
                </li>
              </ul>
            </div>
          </div>
        </div>
        <button class="cartButton" @click="addCart">加入购物车</button>
      </el-dialog>
      <!-- 提示弹框 -->
      <el-dialog
        :visible.sync="tipsVisible"
        width="800px"
      >
        <div class="content">
          <h1>注意事项：</h1>
          <p>1.如已添加满足条件的商品，请前往购物车结算。</p>
          <p>2.不满足规则的商品会按普通商品计算价格。</p>
          <p>3.同一订单只会计算一套规则，如满足多个规格，请拆开下单。</p>
        </div>
        <button class="cartButton" @click="tipsVisible = false">确认</button>
      </el-dialog>
  </div>
</template>

<script>
import {mapMutations} from 'vuex'

import ActivitySlot from '@/components/activity/activitySlot.vue'
import ItemSlot from '@/views/promotions/components/itemSlot.vue'
import StoreNav from '@/views/store/storeNav.vue'

import {
  getBindList,
  getBindProducts,
  // getBindProduct,
  getBindDetail
} from '@/api/Activity/ActivityBind.js'
import {
  addToCart
} from '@/api/user/cart.js'
export default {
  name: 'rabatt',
  components: { ActivitySlot, ItemSlot, StoreNav },
  data () {
    return {
      imgTitle: 'static/image/activity/bindTitle.webp',
      listquery: {
        priceId: null,
        page: 1,
        pageSize: 12
      },
      total: 0,
      loading: false,
      discountList: [], // 规则列表
      proList: [], // 商品列表
      sukVisible: false,
      loadingCheck: false,
      productCheckData: {}, // 选中商品信息
      skuValues: [],
      tipsVisible: false
    }
  },
  created () {
    this.getBindData()
  },
  methods: {
    ...mapMutations({
      setCartNumber: 'SET_CARTNUMBER'
    }),
    // 查询定价捆绑规则
    async getBindData () {
      if (!this.$route.query.shopId) { return }
      const response = await getBindList({ shopId: this.$route.query.shopId })
      const res = response.data
      if (res.code === '200') {
        this.discountList = res.data
      } else {
        this.$message.error(res.message)
      }
      this.listquery.priceId = res.data[0].priceId
      this.getProductList()
    },
    // 查询定价捆绑商品
    async getProductList () {
      if (!this.discountList.length) {
        this.$message.error('店铺信息错误！')
        return
      }
      this.loading = true
      this.listquery.ids = `${this.discountList[0].priceId}`
      this.listquery.shopId = this.$route.query.shopId
      // const response = await getBindProduct(this.listquery)
      const response = await getBindProducts(this.listquery)
      // const response = await getBindProducts({
      //   ids: `${this.discountList[0].priceId}`,
      //   shopId: this.$route.query.shopId
      // })
      const res = response.data
      this.proList = res.data[0].composeProducts
      this.total = res.data[0].total
      this.loading = false
    },
    // 翻页
    changePage (val) {
      this.listquery.page = val
      this.getProductList()
    },
    // 跳转详情
    toProductDetail (row) {
      let data = {
        productId: row.productId,
        shopId: row.shopId,
        skuId: row.skuId
      }
      this.$router.push({
        path: '/productDetail',
        query: {
          proData: JSON.stringify(data)
        }
      })
    },
    // 选择规格
    async showCart (item) {
      this.productCheckData = {}
      this.skuValues = []
      this.loadingCheck = true
      this.sukVisible = true
      const response = await getBindDetail({ productId: item.productId })
      const res = response.data
      this.productCheckData = res.data
      this.loadingCheck = false
    },
    // 添加定价商品购物车
    async addCart () {
      const getKey = this.skuValues.toString() || '单款项'
      const proNum = 1
      if (!this.productCheckData.map[getKey] || !this.productCheckData.map[getKey].skuId) {
        this.$message.warning('请选择规格')
        return
      }
      const response = await addToCart({
        skuId: this.productCheckData.map[getKey].skuId,
        number: proNum
      })
      const res = response.data
      if (res.code === '200') {
        this.setCartNumber(this.$store.state.cartNumber + proNum)
        this.tipsVisible = true
      } else {
        this.$message.error('添加购物车失败！')
      }
      this.sukVisible = false
    }
  }
}
</script>

<style lang="scss" scoped>
.bindPage{
  max-width: 1250px;
  min-height: 600px;
  margin: auto;
  .activityBind{
    position: relative;
    .title{
      height: 35px;
      text-align: center;
      position: absolute;
      top: 160px;
      left: 0;
      right: 0;
      ul{
        display: flex;
        justify-content: center;
        align-items: center;
        .ruleItem{
          margin: 0 10px;
          padding: 0 20px;
          height: 35px;
          line-height: 35px;
          color: #FFF;
          background: linear-gradient(88deg, #D0B88E 0%, #EFD7A8 100%);
          border-radius: 25px;
          cursor: default;
        }
      }
    }
  }
  .bindList {
    display: flex;
    flex-direction: row;
    flex-wrap: wrap;
    .item {
      width: 23%;
      margin: 20px 1%;
      transition: all 0.3s linear;
      .progress{
        width: 100%;
        height: 40px;
        background-color: #DADBDC;
        position: absolute;
        bottom: 0;
        display: flex;
        align-items: center;
        span{
          margin-left: 10px;
        }
        >>> .el-progress{
          flex: 1;
          height: 10px;
          margin: 0 10px;
          // .el-progress-bar{
          //   height: 10px;
          // }
          .el-progress-bar__outer,.el-progress-bar__inner{
            border-radius: 0;
            height: 10px !important;
          }
        }
      }
      .buy{
        width: 100%;
        height: 40px;
        padding: 0;
        margin: 15px 0 0;
        font-size: 18px;
        font-family: PingFang SC;
        color: #FFEBC4;
        background-color: #333333;
        cursor: pointer;
      }
    }
    .item:hover{
      box-shadow:0 0 20px #cccccc;
    }
  }
  .noproduct{
    margin: 80px 0;
    text-align: center;
  }

  .productInfo{
    display: flex;
    .proImg{
      width: 285px;
      height: 330px;
    }
    .proInfo{
      flex: 1;
      max-width: 400px;
      margin-left: 12px;
      .title{
        display: flex;
        justify-content: space-between;
        .name{
          flex: 1;
          font-size: 26px;
          font-weight: bold;
          height: 40px;
          line-height: 40px;
          white-space: nowrap;
          overflow: hidden;
          text-overflow: ellipsis;
        }
        .price{
          font-size: 20px;
          font-weight: bold;
          line-height: 40px;
          color: #C83732;
        }
      }
      .skus{
        .skusList{
          margin: 20px 0;
          .listItem{
            display: inline-block;
            height: 40px;
            line-height: 40px;
            text-align: center;
            padding: 0 9px;
            margin: 10px 8px;
            font-size: 14px;
            color: #666666;
            border: 1px solid #E4E5E6;
            cursor: pointer;
            &:hover{
              border-color: $mainGlod;
            }
          }
          .selected-item {
            color: $mainGlod;
            border-color: transparent;
            box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
          }
        }
      }
    }
  }
  .cartButton{
    display: block;
    width: 120px;
    height: 40px;
    margin: auto;
    line-height: 40px;
    text-align: center;
    color: #FFEBC4;
    background-color: #333333;
    cursor: pointer;
  }
  .content{
    max-width: 600px;
    margin: 20px auto;
    h1{
      color: #C83732;
      font-size: 26px;
    }
    p{
      margin: 8px 0;
    }
  }
}
</style>
