<template>
  <div class="layout hom-layout">
      <div class="list-group-item" v-for="(item,index) in componentsData" :key="index">
        <component :is="componentMap[terminal-1].get(item.type)" :componentContent="item.componentContent" :terminal="terminal" :typeId="typeId" :shopId="shopId"></component>
      </div>
  </div>
</template>

<script>
  import componentMap from './componentMap'
  import api from './config/api'
  import {sendReqMixin} from './config/mixin'
  export default {
    name: 'canvasPage',
    mixins: [sendReqMixin],
    data () {
      return {
        // terminal: 4, // 画布设备 1 小程序，2 H5，3 App 4 电脑
        // typeId: 3, // 画布类型 1 平台画布，2 自定义页面，3 商家店铺装修
        // shopId: 0, // 店铺id
        componentsData: [],
        activeComponent: -1,
        componentMap: componentMap
      }
    },
    props: {
      terminal: {
        type: Number,
        default: 4
      },
      typeId: {
        type: Number,
        default: 1
      },
      shopId: {
        type: Number,
        default: 0
      }
    },
    mounted () {
      // this.shopId = Cookies.get('cereShopId')
      this.canvasGet()
    },
    methods: {
      // 读取画布
      canvasGet () {
        var _this = this
        var apiUrl = api.getCanvas + '?terminal=' + this.terminal + '&type=' + this.typeId
        if (this.shopId) {
          apiUrl += '&shopId=' + this.shopId
        }
        let params = {
          url: apiUrl,
          method: 'GET'
        }
        this.sendReq(params, (res) => {
          if (JSON.stringify(res.data) !== '{}') {
            _this.canvasId = res.data.canvasId
            var componentsData = JSON.parse(res.data.json)
            for (let i = 0; i < componentsData.length; i++) {
              // 商品列表
              if (componentsData[i].type === 'productList') {
                if (componentsData[i].componentContent.productData.sourceType === '1') {
                  _this.sendReq({
                    url: `${api.getProducts}?page=1&pageSize=99&ids=${componentsData[i].componentContent.productData.productIdList}`,
                    method: 'GET'
                  }, (proRes) => {
                    componentsData[i].componentContent.productData.imgTextData = proRes.data.list
                  })
                } else if(componentsData[i].componentContent.productData.sourceType === '2'){
                  _this.sendReq({
                    url: `${api.getProducts}?page=1&pageSize=99&classifyId=${componentsData[i].componentContent.productData.categoryId}`,
                    method: 'GET'
                  }, (proRes) => {
                    componentsData[i].componentContent.productData.imgTextData = proRes.data.list
                  })
                }
              }
              if (componentsData[i].type === 'shopHeader' && this.terminal === 4) {
                if (componentsData[i].componentContent.category && componentsData[i].componentContent.category.length !== 0) {
                  var categoryArr = componentsData[i].componentContent.category
                  _this.sendReq({
                    url: `${api.getClassify}`,
                    method: 'GET'
                  }, (proRes) => {
                    componentsData[i].componentContent.category = proRes.data.filter((item) => {
                      for (let i = 0; i < categoryArr.length; i++) {
                        if (categoryArr[i].id === item.id) {
                          return true
                        }
                      }
                    })
                  })
                }
              }
            }
            _this.componentsData = componentsData
          } else {
            _this.canvasId = ''
          }
          // console.log(JSON.parse(res.data.json))
        })
      }
    }
  }
</script>

<style lang="scss" scoped>
  .hom-layout{
    background-color: #f5f5f5;
  }
</style>

<style lang="scss">
  .warp{
    width: 710px;
    margin: 0 auto;
    max-width: 100%;
    &.terminal4{
      width: 1200px;
      max-width: 100%;
    }
  }
  .flex-box{
    display: flex;
  }
</style>
