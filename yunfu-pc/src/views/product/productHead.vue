<template>
    <div class="productHead">
      <div class="head">
        <div class="store">
          <img :src="collectData.shopLogo" @click="toStore(collectData.shopId)" alt="">
          <div class="desc">
            <p class="storeName">{{collectData.shopName}}</p>
            <div class="sales">
              <span class="species">商品种类：<span>{{collectData.classifyNumber}}</span></span>
              <span class="sold">已售：<span>{{collectData.number}}</span></span>
            </div>
          </div>
          <div class="service" v-show="hasService">
            <div class="item">
              <icon-svg style="font-size: 30px;" icon-class="shop-service" />
              <span class="fs12">微信客服</span>
            </div>
            <canvas class="qrcode" ref="headQrcode"></canvas>
          </div>
        </div>
        <div class="search">
          <div class="searchSelect">
            <el-dropdown @command="searchCommand" trigger="click">
              <span class="el-dropdown-link">{{searchVal}}
                <i class="el-icon-arrow-down cur-poi el-icon--right"></i>
              </span>
              <el-dropdown-menu slot="dropdown">
                <el-dropdown-item command="宝贝">宝贝</el-dropdown-item>
                <el-dropdown-item command="店铺">店铺</el-dropdown-item>
              </el-dropdown-menu>
            </el-dropdown>
          </div>
          <div class="searchRight">
            <input type="text" v-model="keyword" @keyup.enter="searchPro" placeholder="请输入搜索商品">
          </div>
          <span class="btn cur-poi" @click="searchPro"><i class="icon el-icon-search"></i></span>
        </div>
      </div>
    </div>
</template>

<script>
import {mapMutations, mapGetters} from 'vuex'

import QRCode from 'qrcode'
import {
  getServiceURL
} from '@/api/product.js'
export default {
  name: 'productHead',
  data () {
    return {
      searchVal: '宝贝',
      keyword: '',
      hasService: false
    }
  },
  watch: {
    'collectData.shopId': {
      handler (nVal, oVal) {
        if (nVal !== oVal) {
          this.hasService = false // 初始化微信客服框
          this.getSercvice(this.collectData.shopId)
        }
      },
      deep: true
    }
  },
  computed: {
    ...mapGetters([
      'collectData'
    ])
  },
  mounted () {
    this.getSercvice(this.collectData.shopId)
  },
  methods: {
    ...mapMutations({
        setSearchObj: 'SET_SEARCHOBJ'
    }),
    searchCommand (command) {
      this.searchVal = command
    },
    // 搜索商品
    searchPro () {
      this.setSearchObj({
        keyword: this.keyword,
        searchVal: this.searchVal
      })
      if (this.$route.name !== 'search') {
        this.$router.push({
          path: '/activity/search'
        })
      }
    },
    // 跳转到店铺
    toStore (id) {
      this.$router.push({
        path: '/store', query: {shopId: id}
      })
    },
    async getSercvice (shopid) {
      const shopids = JSON.parse(sessionStorage.getItem('service_shopds')) || []
      const serviceUrl = JSON.parse(sessionStorage.getItem('service_url')) || []
      let url = null
      const index = shopids.indexOf(shopid)
      if (index === -1) { // 没用该店铺客服
        const response = await getServiceURL({id: shopid})
        const res = response.data
        url = res.data.url
        if (!url) { return }
        // 缓存处理
        shopids.push(shopid)
        serviceUrl.push(url)
        this.hasService = true
        sessionStorage.setItem('service_shopds', JSON.stringify(shopids))
        sessionStorage.setItem('service_url', JSON.stringify(serviceUrl))
      } else {
        this.hasService = true
        url = serviceUrl[index]
      }
      if (!url) { return }
      QRCode.toCanvas(this.$refs.headQrcode, url, error => {
        console.log(error)
      })
    }
  }
}
</script>

<style lang="scss" scoped>
.productHead{
  width: 100%;
  background-color: #fff;
  height: 80px;
  margin-bottom: 20px;
  display: flex;
  justify-content: center;
  .head{
    width: 1250px;
    height: 100%;
    display: flex;
    justify-content: space-between;
    align-items: center;
    .store{
      display: flex;
      img{
        width: 60px;
        height: 60px;
        margin-right: 10px;
        border: 1px solid #F3F4F5;
        cursor: pointer;
      }
      .desc{
        display: flex;
        flex-direction: column;
        justify-content: space-between;
        padding: 5px 0;
        .storeName{
          font-size: 18px;
          color: #333;
        }
        .sales{
          font-size: 12px;
          .species,.sold{
            color: #999;
            margin-right: 15px;
            span{
              color: #333;
            }
          }
        }
      }
      .service{
        width: 58px;
        height: 58px;
        color: #C5AA7B;
        background-color: #FAF8F5;
        // overflow: hidden;
        cursor: pointer;
        &:hover{
          .qrcode{
            display: block;
          }
        }
        .item{
          width: 100%;
          height: 100%;
          display: flex;
          flex-direction: column;
          justify-content: center;
          align-items: center;
          span{
            margin-top: 6px;
          }
        }
        .qrcode{
          width: 100px !important;
          height: 100px !important;
          display: none;
        }
      }
    }
    .search{
      width: 394px;
      height: 39px;
      border: 2px solid #F3F4F5;
      display: flex;
      .searchSelect{
        width: 82px;
        height: 30px;
        margin-top: 2px;
        border-right: 1px solid #CCCCCC;
        text-align: center;
        line-height: 30px;
        .el-dropdown{
          color: #C5AA7B;
        }
      }
      .searchRight{
        flex: 1;
        input{
          padding-left: 15px;
          font-size: 14px;
          color: #333;
          line-height: 35px;
        }
      }
      .btn{
        font-size: 20px;
        line-height: 35px;
        padding-right: 15px;
      }
    }
  }
}
</style>
