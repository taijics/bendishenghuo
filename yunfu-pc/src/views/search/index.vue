<template>
  <div class='search'>
    <div class='banxin'>
      <div class='head'>
        <div class="bread">
          <div class='all'>全部结果</div>
          <i class="el-icon-arrow-right" />
          <div class='keyword'>{{keyword}}</div>
          <i v-if="keyword" class="el-icon-arrow-right" />
        </div>
        <div class='sort'>
          <div>排序：</div>
          <div class='default' :class="index=='1'?'active':''" @click="defaultSort()">默认</div>
          <div class='price' :class="index=='2'?'active':''" @click="priceSort()">
            价格
            <div class='arr'>
              <div class='up' :class="type==1?'low':''"></div>
              <div class='down' :class="type==2?'high':''"></div>
            </div>
          </div>
          <div class='sales' :class="index=='3'?'active':''" @click="salesSort()">
            销量
            <div class='arr'>
              <div class='up' :class="index=='3' && volume==1 ?'low':''"></div>
              <div class='down' :class="index=='3' && volume==2 ?'high':''"></div>
            </div>
          </div>
          <div class="priceBox" v-if="searchVal=='宝贝'">
            <div class='min'>¥<input type='number' v-model="minMoney" /></div>
            <div style='margin: 0 8px'>-</div>
            <div class='max'>¥<input type='number' v-model="maxMoney" /></div>
            <div class='btn' @click="priceSearch">确定</div>
            <div class='clear' @click="clearMoney">清空</div>
          </div>
        </div>
      </div>
      <div class='result'>
        <div class="pro" v-if="searchVal=='宝贝' && noProduct==false" v-loading="loading">
          <ProductList :productList='productList'></ProductList>
        </div>
        <div class="empty" v-if="searchVal=='宝贝' && noProduct==true && network==false">
          <icon-svg style="width: 240px; height: 240px; margin-bottom: 20px;" icon-class="no-result" />
          <p class="fs20 font-color-999">搜索不到你要找的宝贝呢换个词试试吧～</p>
        </div>
        <div class="empty" v-if="searchVal=='店铺' && noShop==true && network==false">
          <icon-svg style="width: 240px; height: 240px; margin-bottom: 20px;" icon-class="no-result" />
          <p class="fs20 font-color-999">搜索不到你要找的店铺呢换个词试试吧～</p>
        </div>
        <!-- <div class="network" v-if="searchVal=='宝贝' && noProduct==true && network==true"> -->
        <div class="network" v-if="network">
          <icon-svg style="width: 240px; height: 240px; margin-bottom: 20px;" icon-class="net-error" />
          <p class="fs20 font-color-999">哎呀，网络开小差了～</p>
        </div>
        <div class='store' v-if="searchVal=='店铺' && noShop==false" v-loading="loading1">
          <div class='storeBox' v-for="(item,index) in storeList" :key="index">
            <div class='top'>
              <img
                class='storeImg'
                :src='item.shopLogo'
                alt=''
              />
              <div class='storeDesc'>
                <p class='storeName'>{{item.shopName}}</p>
                <p class='storeSite'><span>所在地：</span>{{item.shopAdress}}</p>
              </div>
              <div class='enter' @click="toStore(item.shopId)">进入店铺>></div>
            </div>
            <div class='content' v-if="item.skus.length">
              <div class='productBox' v-for="(items,indexs) in item.skus" :key="indexs" @click="toProductDetail(item.shopId,items)">
                <img :src='items.image' alt='' />
                <p class='productName'>{{items.productName}}</p>
                <p class='price'>¥{{items.price}}</p>
              </div>
            </div>
          </div>
        </div>
        <el-pagination
          v-if="productList.length>0 || storeList.length>0"
          :current-page="page"
          :page-size="12"
          @current-change="handleCurrentChange"
          background layout='prev, pager, next' :total='total'>
        </el-pagination>
      </div>
    </div>
  </div>
</template>
<script>
import ProductList from '@/components/base/productList'

import {
  getSearchProduct
} from '@/api/product.js'

import {
  searchShop
} from '@/api/shop.js'
import { mapGetters } from 'vuex'
export default {
  components: {
    ProductList
  },
  data () {
    return {
      flag: true,
      page: 1,
      keyword: '',
      searchVal: '',
      index: '1',
      maxMoney: '',
      minMoney: '',
      type: 0,
      volume: 0,
      productList: [],
      total: 0,
      network: false,
      noProduct: false,
      noShop: false,
      storeList: [],
      loading: false,
      loading1: false
    }
  },
  watch: {
    searchObj: {
      handler (newVal, oldVal) {
        this.page = 1
        this.searchInfo()
      },
      deep: true
    }
  },
  computed: {
    ...mapGetters([
      'searchObj'
    ])
  },
  mounted () {
    this.searchInfo()
  },
  methods: {
    searchInfo () {
      if (this.searchObj.keyword !== undefined) {
        this.keyword = this.searchObj.keyword
        this.searchVal = this.searchObj.searchVal
        this.maxMoney = ''
        this.minMoney = ''
        if (this.searchVal === '宝贝') {
          this.getSearchProducts()
        } else {
          this.getShops()
        }
      }
    },
    // 跳转商品详情
    toProductDetail (id, item) {
      let data = {
        shopId: id,
        productId: item.productId,
        skuId: item.skuId
      }
      this.$router.push({
        path: '/productDetail',
        query: {
          proData: JSON.stringify(data)
        }
      })
    },
    // 获取搜索商品数据
    async getSearchProducts () {
      this.loading = true
      const response = await getSearchProduct({
        search: this.keyword,
        type: this.type,
        maxMoney: this.maxMoney,
        minMoney: this.minMoney,
        volume: this.volume,
        page: this.page,
        pageSize: 12
      })
      const res = response.data
      if (res.code === '200') {
        this.productList = res.data.list
        this.total = res.data.total
        this.loading = false
        this.network = false
        if (res.data.list.length < 1) {
          this.noProduct = true
        } else {
          this.noProduct = false
        }
      } else {
        this.$message.warning(res.message)
        this.network = true
      }
    },
    // 获取搜索店铺数据
    async getShops () {
      this.loading1 = true
      const response = await searchShop({
        search: this.keyword,
        type: this.type,
        volume: this.volume,
        page: this.page,
        pageSize: 12
      })
      const res = response.data
      if (res.code === '200') {
        this.storeList = res.data.list
        this.total = res.data.total
        this.loading1 = false
        this.network = false
        if (res.data.list.length === 0) {
          this.noShop = true
        } else {
          this.noShop = false
        }
      } else {
        this.$message.warning(res.message)
        this.network = true
      }
    },
    // 跳转到店铺
    toStore (id) {
      this.$router.push({
        path: '/store', query: {shopId: id}
      })
    },
    // 价格搜索
    priceSearch () {
      this.page = 1
      this.getSearchProducts()
    },
    handleCurrentChange (val) {
      this.page = val
      if (this.searchVal === '宝贝') {
        this.getSearchProducts()
      } else {
        this.getShops()
      }
    },
    // 清空价格搜索
    clearMoney () {
      this.minMoney = ''
      this.maxMoney = ''
    },
    // 默认排序
    defaultSort () {
      this.type = ''
      this.volume = ''
      this.index = '1'
      this.page = 1
      this.maxMoney = ''
      this.minMoney = ''
      if (this.searchVal === '宝贝') {
        this.getSearchProducts()
      } else {
        this.getShops()
      }
    },
    // 价格排序
    priceSort () {
      if (this.type !== 1) {
        this.type = 1
      } else {
        this.type = 2
      }
      this.page = 1
      this.index = '2'
      this.volume = ''
      this.maxMoney = ''
      this.minMoney = ''
      if (this.searchVal === '宝贝') {
        this.getSearchProducts()
      } else {
        this.getShops()
      }
    },
    // 销量排序
    salesSort () {
      if (this.volume !== 1) {
        this.volume = 1
      } else {
        this.volume = 2
      }
      this.page = 1
      this.index = '3'
      this.type = ''
      this.maxMoney = ''
      this.minMoney = ''
      if (this.searchVal === '宝贝') {
        this.getSearchProducts()
      } else {
        this.getShops()
      }
    }
  }
}
</script>
<style lang='scss' scoped>
$searchRed: #C83732;
.search {
  width: 100%;
  height: 100%;
  background-color: #f0f0f0;
  padding-bottom: 143px;
  text-align: center;
  .banxin {
    width: 1252px;
    height: 100%;
    margin: 0 auto;
    .head {
      display: flex;
      justify-content: space-between;
      .bread{
        height: 64px;
        line-height: 64px;
        font-size: 16px;
        display: flex;
        align-items: center;
        .all {
          margin-right: 20px;
        }
        .keyword {
          margin: 0 20px;
          color: $searchRed;
        }
      }
      .sort {
        min-width: 600px;
        height: 63px;
        line-height: 27px;
        display: flex;
        justify-content: space-around;
        align-items: center;
        border-bottom: 1px solid #f1f1f1;
        color: #666666;
        .default {
          margin-left: 20px;
          cursor: pointer;
        }
        .sales {
          display: flex;
          margin-right: 20px;
          cursor: pointer;
          img{
            width: 9px;
            height: 16px;
            vertical-align: middle;
          }
        }
        .price {
          display: flex;
          margin: 0 20px;
          cursor: pointer;
        }
        .arr {
          vertical-align: middle;
          width: 12px;
          margin-left: 3px;
          .up {
            width: 0;
            height: 0;
            border: 6px solid transparent;
            border-bottom-color: #999999;
          }
          .down {
            width: 0;
            height: 0;
            border: 6px solid transparent;
            border-top-color: #999999;
            margin-top: 3px;
          }
        }
        .active{
            display: flex;
            cursor: pointer;
            color: $searchRed;
            .arr{
              .high{
                border-top-color: $searchRed;
              }
              .low{
                border-bottom-color: $searchRed;
              }
            }
          }
          .priceBox{
            display: flex;
            .min,
            .max {
              display: flex;
              width: 100px;
              height: 28px;
              padding: 0 5px;
              background-color: #FFF;
              border: 1px solid #ccc;
              box-sizing: border-box;
              input {
                width: 70px;
                padding-left: 3px;
                flex: 1;
                outline: none;
                border: none;
              }
            }
            .btn {
              width: 70px;
              height: 30px;
              margin: 0 20px;
              color: $mainGlod;
              background: #333333;
              border: 1px solid $mainGlod;
              box-sizing: border-box;
              cursor: pointer;
            }
            .clear {
              width: 70px;
              height: 30px;
              cursor: pointer;
              color: #999999;
              border: 1px solid #999999;
            }
          }
      }
    }
    .result {
      width: 100%;
      background-color: #ffffff;
      // padding: 0 45px 30px;
      box-sizing: border-box;
      margin-bottom: 30px;
      .empty,.network{
        width: 100%;
        text-align: center;
        padding: 100px 0;
      }
      .store {
        width: 100%;
        box-sizing: border-box;
        min-height: 400px;
        padding: 20px;
        .storeBox {
          width: 100%;
          margin-bottom: 50px;
          border: 1px solid #F3F4F5;
          &:hover{
            box-shadow: 0px 10px 20px rgba(0, 0, 0, 0.05);
          }
          .top {
            display: flex;
            align-items: center;
            height: 80px;
            border-bottom: 1px solid #F3F4F5;
            .storeImg {
              width: 50px;
              height: 50px;
              margin: 15px;
            }
            .storeDesc {
              flex: 1;
              text-align: left;
              .storeName {
                font-size: 20px;
                margin-bottom: 10px;
              }
              .storeSite {
                font-size: 14px;
                span{
                  color: #999;
                }
              }
            }
            .enter {
              color: $mainGlod;
              cursor: pointer;
              margin-right: 30px;
            }
          }
          .content {
            display: flex;
            width: 100%;
            overflow-y: auto;
            padding: 15px;
            box-sizing: border-box;
            .productBox {
              cursor: pointer;
              width: 190px;
              padding: 10px 15px;
              margin-right: 20px;
              box-sizing: border-box;
              background-color: #ffffff;
              &:hover{
                border: 1px solid #efefef;
              }
              img {
                width: 160px;
                height: 160px;
                border: 1px dashed #333;
              }
              .productName {
                font-size: 12px;
                font-weight: bold;
                margin: 13px 0;
              }
              .price {
                font-size: 16px;
                color: $searchRed;
                font-weight: bold;
              }
            }
          }
        }
      }
    }
    .guessYouLike {
      width: 100%;
      padding: 30px 45px;
      background-color: #ffffff;
      box-sizing: border-box;
      .title {
        text-align: left;
        font-size: 26px;
        margin-bottom: 22px;
      }
    }
  }
}
>>>.el-pagination{
  padding: 20px;
  text-align: right;
  .el-pager{
    li:not(.disabled):hover{
      color: $mainGlod;
    }
    li:not(.disabled).active{
      background-color: $mainGlod;
    }
    li:not(.disabled).active:hover{
      color: #F4F4F5;
    }
  }
}
.mySwiperLbtn{
  width: 32px;
  height: 32px;
  background-image: url('../../../static/image/zuoa@2x.png');
  background-size: cover;
  left: 0;
}
.mySwiperRbtn{
  width: 32px;
  height: 32px;
  background-image: url('../../../static/image/youa@2x.png');
  background-size: cover;
  right: 0;
}
.pro{
  min-height: 400px;
}
</style>
