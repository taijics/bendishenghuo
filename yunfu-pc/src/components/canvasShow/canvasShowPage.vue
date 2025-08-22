<template>
  <div class="layout hom-layout">
      <div class="list-group-item" v-for="(item,index) in componentsData" :key="index">
        <component
          :is="componentMap[terminal-1].get(item.type)"
          :componentContent="item.componentContent"
          :terminal="terminal"
          :typeId="typeId"
          :shopId="shopId"
        ></component>
      </div>
  </div>
</template>

<script>
  import componentMap from './componentMap'
  // import api from './config/api'
  import {
    getCanvas,
    getClassify,
    getProducts
  } from './config/api'
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
      async canvasGet () {
        let params = {
          terminal: this.terminal,
          type: this.typeId
        }
        if (this.shopId) {
          params.shopId = this.shopId
        }
        const response = await getCanvas(params)
        const res = response.data

        if (JSON.stringify(res.data) !== '{}') {
          this.canvasId = res.data.canvasId
          var componentsData = JSON.parse(res.data.json)
          for (let i = 0; i < componentsData.length; i++) {
            if (componentsData[i].type === 'shopHeader' && this.terminal === 4) {
              if (
                componentsData[i].componentContent.category
                && componentsData[i].componentContent.category.length !== 0
                ) {
                var categoryArr = componentsData[i].componentContent.category
                let response = await getClassify()
                const res = response.data
                componentsData[i].componentContent.category = res.data.filter((item) => {
                  for (let i = 0; i < categoryArr.length; i++) {
                    if (categoryArr[i].id === item.id) {
                      return true
                    }
                  }
                })
              }
            }
          }
          this.componentsData = componentsData
        } else {
          this.canvasId = ''
        }
      }
    }
  }
</script>

<style lang="scss" scoped>
  .hom-layout{
  }
</style>

<style lang="scss">
  .warp{
    width: 690px;
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
