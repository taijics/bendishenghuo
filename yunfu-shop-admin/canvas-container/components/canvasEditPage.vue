<template>
   <div class="layout hom-layout" v-loading="loading">
     <draggable
       class="dragArea list-group"
       :list="componentsData"
       group="pageEdit"
       @change="pageChange"
     >
     <div class="list-group-item" v-for="(item,index) in componentsData" :key="index" :class="[{'on':activeComponent == index},'item-'+item.type]" @click="selectComponent(item,index)">
       <component v-show="!item.isEmpty" :isNoData.sync='item.isEmpty' :is="componentMap[terminal-1].get(item.type)" :componentContent="item.componentContent" :terminal="terminal" :typeId="typeId" :shopId="shopId" @cleckLoading="cleckLoading"></component>
       <div class="no-data" v-show="item.isEmpty">
         <i class="iconfont icon-kong"></i>
         <p>暂无数据<br>请在右边窗口编辑内容</p>
       </div>
       <div class="btns">
         <span @click="delComponent(item,index)"><i class="iconfont icon-shanchu"></i></span>
       </div>
     </div>
     </draggable>
   </div>
</template>

<script>
  import draggable from 'vuedraggable'
  import componentMap from './canvasShow/componentMap'
  import { mapGetters, mapMutations } from 'vuex'
  export default {
  // import testData from '@@/config/testData3'
    name: 'canvasEditPage',
    components: {
      draggable
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
    data () {
      return {
        activeComponent: -1,
        componentMap: componentMap,
        loading: false
      }
    },
    mounted () {
      // this.setComponentsData(testData)
    },
    computed: {
      ...mapGetters([
        'componentsData'
      ])
    },
    methods: {
      ...mapMutations({
        setActiveComponent: 'SET_ACTIVECOMPONENT',
        setComponentsData: 'SET_COMPONENTSDATA'
      }),
      // 画布添加或者移动了组件
      pageChange (e) {
        if (e.added) {
          this.activeComponent = e.added.newIndex
          e.added.element.index = e.added.newIndex
          this.setActiveComponent(e.added.element)
        }
        if (e.moved) {
          this.activeComponent = e.moved.newIndex
          e.moved.element.index = e.moved.newIndex
          this.setActiveComponent(e.moved.element)
        }
        this.$emit('showRightBox', true)
      },
      // 选中组件
      selectComponent (item, index) {
        this.activeComponent = index
        item.index = index
        this.setActiveComponent(item)
        this.$emit('showRightBox', true)
    },
      // 删除组件
      delComponent (item, index) {
        this.$confirm('确定删除吗？', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          this.activeComponent = -1
          this.componentsData.splice(index, 1)
          this.$emit('showRightBox', false)
        }).catch(() => {
        })
      },
      cleckLoading(){
        if(typeof(uni) !== 'undefined'){
          uni.getStorage({
            key: 'sendNum',
            success: function (res) {
              let sendNum = res.data;
              this.loading = parseInt(sendNum) !== 0
            }
          })
        } else {
          let sendNum = localStorage.getItem('sendNum')
          this.loading = parseInt(sendNum) !== 0
        }
      },
      // 检查组件是否为空
      checkIsNoData(dataList) {
        for(let i=0;i<dataList.length;i++){
          const newVal = dataList[i].componentContent
          let isEmpty = true
          let _data = ''
          switch (dataList[i].type){
            case 'banner':
              _data=newVal.bannerData
              _data.forEach(function(value ){
                if(value.bannerUrl){
                  isEmpty = false
                }
              })
              break
            case 'notice':
            case 'text':
            case 'imageTextNav':
            case 'imageText':
            case 'imageTextList':
            case 'brandList':
            case 'categoryList':
            case 'assistDiv':
              isEmpty = false
              break
            case 'productList':
              _data = newVal.productData
              if((_data.sourceType=='1' && _data.productIdList.length > 0) || (_data.sourceType=='2' && _data.categoryId != 0)){
                isEmpty = false
              }
              break
            case 'custom':
              _data=newVal.imgData
              _data.forEach(function(value ){
                if(value.src){
                  isEmpty = false
                }
              })
              break
            case 'groupList':
              if(this.typeId === 1){
                isEmpty = false
              }
              else {
                if(newVal.shopGroupWorkId){
                  isEmpty = false
                }
              }
              break
            case 'spikeList':
              if(newVal.shopSeckillId){
                isEmpty = false
              }
              break
            case 'discountList':
              if(newVal.discountId){
                isEmpty = false
              }
              break
            case 'priceList':
              if(newVal.priceId){
                isEmpty = false
              }
              break
            case 'vip':
              isEmpty = false
              break
            case 'coupon':
              if(newVal.selectedCoupon.length > 0){
                isEmpty = false
              }
              break
            case 'newProduct':
              _data = newVal.productData
              if((_data.sourceType=='1' && _data.productIdList.length > 0) || (_data.sourceType=='2' && _data.categoryId != 0)){
                isEmpty = false
              }
              break
            case 'shop':
              _data=newVal.imgTextData
              _data.forEach(function(value ){
                if(value.img){
                  isEmpty = false
                }
              })
              break
          }
          dataList[i].isEmpty = isEmpty
          this.$forceUpdate()
        }
        console.log(dataList)
      },
    },
    // 监控组件是否为空
    watch: {
      'componentsData': {
        handler(newVal, oldVal) {
          this.checkIsNoData(newVal)
        },
        deep: true
      }
    }
  }
</script>

<style lang="scss" scoped>
.hom-layout {
  background-color: #fff;
  ::v-deep .sortable-chosen {
    .contentBox {
      display: none;
    }
    .cloneText {
      display: block;
      width: 100%;
      height: 50px;
      line-height: 50px;
      font-size: 18px;
      text-align: center;
      background-color: $mainColor;
      color: #fff;
    }
  }
  .list-group {
    min-height: calc(100vh - 50px);
  }
  .list-group-item {
    position: relative;
    cursor: move;
    background-color: #fff;
    min-height: 100px;
    &.item-assistDiv,&.item-notice,&.item-text{
      min-height: 0px;
    }
    .btns {
      display: none;
    }
    &:hover {
      &:after {
        content: '';
        position: absolute;
        width: 100%;
        height: 100%;
        left: 0;
        top: 0;
        border: 1px $mainColor dashed;
        z-index: 2;
      }
    }
    &.on {
      &:after {
        content: '';
        position: absolute;
        width: 100%;
        height: 100%;
        left: 0;
        top: 0;
        border: 1px $mainColor solid;
        z-index: 2;
      }
      .btns {
        display: block;
        position: absolute;
        right: -13px;
        top: 50%;
        margin-top: -13px;
        z-index: 3;
        span {
          display: block;
          width: 26px;
          height: 26px;
          line-height: 26px;
          text-align: center;
          color: #666;
          background-color: #fff;
          box-shadow: 0 0 2px rgba(51, 51, 51, 0.2);
          cursor: pointer;
        }
      }
    }
  }
}
.no-data {
  width: 100%;
  display: flex;
  height: 300px;
  -webkit-box-align: center;
  align-items: center;
  -webkit-box-pack: center;
  justify-content: center;
  color: #999;
  text-align: center;
  font-size: 16px;
  line-height: 1.8;
  .iconfont {
    font-size: 100px;
    color: $mainColor;
    margin-right: 50px;
  }
}
</style>

<style lang="scss">
.warp {
  width: 690px;
  margin: 0 auto;
  max-width: 100%;
  &.terminal4 {
    width: 1200px;
    max-width: 100%;
  }
}
.flex-box {
  display: flex;
}
</style>
