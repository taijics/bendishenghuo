<template>
  <div class="sotreNav">
    <img v-if="shop.shopLogo" :src="shop.shopLogo" alt="">
    <!-- 店铺信息 -->
    <div class="shopInfo">
      <div class="name">{{ shop.shopName }}</div>
      <div class="address">所在地 <span>{{shop.shopAdress}}</span></div>
    </div>
    <!-- 收藏 -->
    <div class="icon" @click="collectShop">
      <icon-svg
      v-if="shop.ifCollect === 0"
      style="font-size: 24px;" icon-class="unCollect" />
      <icon-svg
      v-if="shop.ifCollect === 1"
      style="font-size: 24px;" icon-class="collect" />
      <span>收藏</span>
    </div>
    <!-- 联系客服 -->
    <div v-if="hasService" class="icon service" @click="collectShop">
      <icon-svg style="font-size: 30px;" icon-class="shop-service" />
      <span>微信客服</span>
      <div class="qrcodeContainer">
        <canvas class="qrcode" ref="headQrcode"></canvas>
      </div>
    </div>
    <div class="search">
      <el-input v-model="keyword" placeholder="请输入商品名称" @keyup.enter.native="search" />
      <div  @click="search" >
        <icon-svg class="searchIcon" icon-class="search"/>
      </div>
    </div>
  </div>
</template>

<script>
import QRCode from 'qrcode'

import {
  getServiceURL
} from '@/api/product.js'
import {
  postCollect
} from '@/api/user/user.js'
export default {
  props: {
    shop: {
      type: Object,
      default: () => ({
        shopId: '',
        shopLogo: '',
        shopName: '',
        shopAdress: '',
        ifCollect: 0
      })
    }
  },
  data () {
    return {
      keyword: '',
      hasService: false
    }
  },
  watch: {
    'shop.shopId': {
      handler (nVal, oVal) {
        if (nVal !== oVal) {
          console.log(nVal, oVal)
          this.getSercvice()
        }
      },
      deep: true
    }
  },
  mounted () {
    this.getSercvice()
  },
  methods: {
    search () {
      if (this.keyword === '') {
        this.$message.warning('请输入搜索内容！')
        return
      }
      this.$emit('search', this.keyword)
    },
    // 收藏店铺
    async collectShop () {
      if (!this.shop.shopId) {
        return
      }
      const response = await postCollect({ shopId: this.shop.shopId })
      const res = response.data
      if (res.code === '200') {
        this.$message.success(this.shop.ifCollect === 1 ? '取消收藏' : '收藏成功')
        this.shop.ifCollect = this.shop.ifCollect === 1 ? 0 : 1
      } else {
        this.$message.error(res.message)
      }
    },
    async getSercvice () {
      if (!this.shop.shopId) {
        return
      }
      const shopids = JSON.parse(sessionStorage.getItem('service_shopds')) || []
      const serviceUrl = JSON.parse(sessionStorage.getItem('service_url')) || []
      let url = null
      const index = shopids.indexOf(this.shop.shopId)
      if (index === -1) { // 没用该店铺客服
        const response = await getServiceURL({id: this.shop.shopid})
        const res = response.data
        url = res.data.url
        if (!url) { return }
        // 缓存处理
        shopids.push(this.shop.shopId)
        serviceUrl.push(url)
        this.hasService = true
        sessionStorage.setItem('service_shopds', JSON.stringify(shopids))
        sessionStorage.setItem('service_url', JSON.stringify(serviceUrl))
      } else {
        this.hasService = true
        url = serviceUrl[index]
      }
      if (!url) { return }
      this.$nextTick(() => {
        QRCode.toCanvas(this.$refs.headQrcode, url, error => {
          console.log(error)
        })
      })
    }
  }
}
</script>

<style lang="scss" scoped>
.sotreNav{
  max-width: 1200px;
  height: 80px;
  margin: auto;
  display: flex;
  align-items: center;
  img{
    width: 58px;
    height: 58px;
  }
  .shopInfo{
    height: 50px;
    margin: 0 15px;
    font-family: Microsoft YaHei;
    cursor: default;
    display: flex;
    flex-direction: column;
    justify-content: space-between;
    .name{
      font-size: 20px;
      color: #333333;
    }
    .address{
      font-size: 12px;
      color: #999999;
      span{
        color: #333333;
      }
    }
  }
  .icon{
    width: 60px;
    height: 60px;
    padding: 6px 0;
    margin-left: 15px;
    border: 1px solid #F3F4F5;
    cursor: pointer;
    display: flex;
    flex-direction: column;
    justify-content: space-between;
    align-items: center;
    position: relative;
    span{
      font-size: 12px;
      font-family: Microsoft YaHei;
      color: #999999;
    }
  }
  .service{
    &:hover{
      color: #C5AA7B;
      background-color: #FAF8F5;
      span{
        color: #C5AA7B;
      }
      .qrcodeContainer{
        display: block;
      }
    }
    .qrcodeContainer{
      position: absolute;
      top: 60px;
      z-index: 100;
      display: none;
      background-color: #FFF;
      opacity: 1;
      .qrcode{
        width: 150px !important;
        height: 150px !important;
      }
    }
  }
  .search{
    position: relative;
    flex: 1;
    .el-input{
      width: 460px;
      float: right;
    }
    >>>.el-input__inner{
      border-radius: 0;
    }
    .searchIcon{
      cursor: pointer;
      font-size: 25px;
      position: absolute;
      right: 10px;
      top: 7px;
    }
  }
}
</style>
