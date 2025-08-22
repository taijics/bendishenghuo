<template>
  <div class="store">
    <div class="banxin">
      <StoreNav
        :shop="shopInfo"
        @search="storeSearch"
      />
      <div class="nav">
        <el-tabs v-model="activeName" @tab-click="handleClick">
          <el-tab-pane label="店铺首页" name="index"></el-tab-pane>
          <el-tab-pane label="所有商品" name="all"></el-tab-pane>
          <el-tab-pane
            v-for="item in shopClassifyList"
            :key="item.classifyId"
            :name="item.classifyId.toString()"
            :label="item.classifyName"
          >
          </el-tab-pane>
        </el-tabs>
      </div>
      <div v-if="isIndex && !activityPage">
        <CanvasPage
          v-if="shopInfo.shopId"
          :terminal="4"
          :typeId="3"
          :shopId="shopInfo.shopId"
        />
      </div>
      <div v-if="!isIndex && !activityPage">
        <img v-if="banner" class="banner" :src="banner" alt="">
        <div class="content">
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
                <div class='up' :class="index=='3' && volume==1 ? 'low' : ''"></div>
                <div class='down' :class="index=='3' && volume==2 ? 'high':''"></div>
              </div>
            </div>
          </div>
          <div>
            <div v-if="noProduct === false">
              <h3>{{classifyTitle}}</h3>
              <ProductList :productList='productList'></ProductList>
            </div>
            <div class="noproduct" v-else>
              <icon-svg
                style="width: 240px; height: 240px; margin-bottom: 20px;"
                icon-class="user-order-nodata"
              />
              <p class="fs20 font-color-999">暂时没有商品～</p>
            </div>
          </div>
          <el-pagination
            v-if="productList.length>0"
            :current-page="page"
            :page-size="12"
            @current-change="handleCurrentChange"
            background layout='prev, pager, next'
            :total='total'
          ></el-pagination>
        </div>
      </div>
      <router-view v-if="activityPage"></router-view>
    </div>
  </div>
</template>
<script>
import ProductList from '@/components/base/productList'
import {mapMutations} from 'vuex'
import CanvasPage from '@/components/canvasShow/canvasShowPage'
import StoreNav from '@/views/store/storeNav.vue'

import {
  getShopIndex,
  getShopClassify,
  getShopProducts,
  getShopBanner
} from '@/api/shop.js'
export default {
  components: {
    ProductList,
    CanvasPage,
    StoreNav
  },
  data () {
    return {
      banner: '',
      activeName: 'index',
      index: '1',
      classifyTitle: '',
      shopClassifyList: [],
      shopInfo: {
        shopId: null,
        shopName: null,
        shopLogo: null
      },
      productList: [],
      total: 0,
      type: '',
      volume: '',
      page: 1,
      noProduct: false,
      isIndex: true,
      activityPage: false
    }
  },
  mounted () {
    // var shopData = this.$route.query.shopId
    this.shopInfo.shopId = parseInt(this.$route.query.shopId)
    this.getShopIndex()
    this.getShopClassify()
    this.getShopBanner()
  },
  watch: {
    '$route' (to, from) {
      if (to.query.shopId !== from.query.shopId) {
        this.shopInfo.shopId = parseInt(to.query.shopId)
        this.$router.go(0)
      }
    }
  },
  methods: {
    ...mapMutations({
      setCollectData: 'SET_COLLECTDATA'
    }),
    // 获取店铺首页
    async getShopIndex () {
      const response = await getShopIndex({ shopId: this.shopInfo.shopId })
      const res = response.data
      if (res.code === '200') {
        let data = {
          ifCollect: res.data.ifCollect,
          collectId: res.data.collectId,
          shopAdress: res.data.shopAdress,
          shopName: res.data.shopName,
          shopId: res.data.shopId,
          classifyNumber: res.data.classifyNumber,
          number: res.data.number,
          shopLogo: res.data.shopLogo
        }
        this.formateShop(res)
        this.setCollectData(data)
      } else {
        this.$message.warning(res.message)
      }
    },
    // 获取店铺分类
    async getShopClassify () {
      const response = await getShopClassify({ shopId: this.shopInfo.shopId })
      const res = response.data
      if (res.code === '200') {
          this.shopClassifyList = res.data.filter(item => JSON.stringify(item) !== '{}')
          // this.activeName = res.data[0].classifyId.toString()
          // this.classifyTitle = res.data[0].classifyName
          // this.getShopProducts()
        } else {
          this.$message({
            message: res.message,
            type: 'warning'
          })
        }
    },
    // 获取店铺banner
    async getShopBanner () {
      const response = await getShopBanner({ shopId: this.shopInfo.shopId })
      const res = response.data
      if (res.code === '200') {
        if (res.data.length > 0) {
          this.banner = res.data[0].bannerImage
        }
      } else {
        this.$message({
          message: res.message,
          type: 'warning'
        })
      }
    },
    // 获取店铺商品
    async getShopProducts () {
      const loading = this.$loading({
        lock: true,
        text: '加载中...',
        spinner: 'el-icon-loading',
        background: 'rgba(255,255,255,0.62)'
      })
      let params = {
        shopId: this.shopInfo.shopId,
        type: this.type,
        volume: this.volume,
        page: this.page,
        pageSize: 12
      }
      if (this.activeName !== 'all') {
        params.groupId = this.activeName
      }
      const response = await getShopProducts(params)
      const res = response.data
      if (res.code === '200') {
        this.productList = res.data.page.list
        // this.formateShop(res)
        if (res.data.page.list.length < 1) {
          this.noProduct = true
        } else {
          this.noProduct = false
        }
        loading.close()
      } else {
        this.$message({
          message: res.message,
          type: 'warning'
        })
      }
    },
    formateShop (res) {
      // 头部数据
      this.shopInfo = {
        shopId: res.data.shopId,
        shopName: res.data.shopName,
        shopLogo: res.data.shopLogo,
        shopAdress: res.data.shopAdress,
        ifCollect: res.data.ifCollect
      }
    },
    // 分类切换
    handleClick (event) {
      this.classifyTitle = event.label
      if (event.name === 'index') {
        this.activityPage = false
        this.isIndex = true
      } else {
        this.activityPage = false
        this.isIndex = false
        this.getShopProducts()
      }
    },
    // 分页器跳转
    handleCurrentChange (val) {
      this.page = val
      this.getShopProducts()
    },
    // 默认排序
    defaultSort () {
      this.type = ''
      this.volume = ''
      this.index = '1'
      this.page = 1
      this.getShopProducts()
    },
    // 价格排序
    priceSort () {
      if (this.type !== 1) {
        this.type = 1
      } else {
        this.type = 2
      }
      this.page = 1
      this.volume = ''
      this.index = '2'
      this.getShopProducts()
    },
    // 销量排序
    salesSort () {
      if (this.volume !== 1) {
        this.volume = 1
      } else {
        this.volume = 2
      }
      this.page = 1
      this.type = ''
      this.index = '3'
      this.getShopProducts()
    },
    // 店铺搜索
    async storeSearch (val) {
      this.activeName = 'all'
      let params = {
        shopId: this.shopInfo.shopId,
        search: val,
        page: this.page,
        pageSize: 12
      }
      this.isIndex = false
      const response = await getShopProducts(params)
      const res = response.data
      if (res.code === '200') {
        this.productList = res.data.page.list
        // this.formateShop(res)
        if (res.data.page.list.length < 1) {
          this.noProduct = true
        } else {
          this.noProduct = false
        }
      } else {
        this.$message({
          message: res.message,
          type: 'warning'
        })
      }
    }
  }
}
</script>
<style lang="scss" scoped>
.store {
  width: 100%;
  //text-align: center;
  padding-bottom: 143px;
  .banxin {
    >>>.nav{
      width: 1200px;
      margin: 0 auto;
      .el-tabs{
        margin-bottom: 10px;
        .el-tabs__item.is-active{
          color: $mainGlod;
        }
        .el-tabs__active-bar{
          background-color: $mainGlod
        }
        .el-tabs__item{
          font-size: 16px;
        }
        .el-tabs__item:hover{
          color: $mainGlod
        }
        .el-tabs__nav-wrap::after{
          display: none;
        }
      }
    }
    .banner{
      width: 100%;
      height: 356px;
      margin-bottom: 25px;
    }
    .content{
      width: 1200px;
      margin: 0 auto;
      padding: 0 0 30px;
      box-sizing: border-box;
      .sort {
        width: 100%;
        height: 63px;
        line-height: 27px;
        display: flex;
        align-items: center;
        border-bottom: 1px solid #f1f1f1;
        color: #666666;
        margin-bottom: 50px;
        .default {
          margin-left: 20px;
          cursor: pointer;
        }
        .sales {
          display: flex;
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
          color: $mainGlod;
          .arr{
            .high{
              border-top-color: $mainGlod;
            }
            .low{
              border-bottom-color: $mainGlod;
            }
          }
        }
      }
      h3{
        font-size: 24px;
        font-weight: bold;
        margin-bottom: 80px;
      }
      .noproduct{
        width: 100%;
        text-align: center;
        padding: 200px 0;
      }
    }
    >>>.el-pagination{
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
  }
}
</style>
