<template>
    <div class="canvas">
      <div class="topBox">
        <!--<a class="btn-black">返回店铺</a>-->
        <ul>
          <li v-for="(item,index) in deviceList" :key="index" @click="toggleDevice(item.id)" :class="{'on':terminal == item.id}">
            <i class="iconfont" :class="'icon-' + item.name"></i>
          </li>
        </ul>
        <el-button class="btn-save" type="primary" @click="canvasSave">保存画布</el-button>
      </div>
      <div class="bottomWarp">
        <div class="leftBox">
          <left-bar></left-bar>
        </div>
        <div class="mainContentWarp">
          <div class="mainContent" :class="'view-' + terminal">
            <cereshop-layout :terminal="terminal" :typeId="typeId" :shopId="shopId" @showRightBox="showRightBox"></cereshop-layout>
          </div>
        </div>
        <div class="RightBox">
          <tool-panel v-if="comChoose"></tool-panel>
          <div v-else class="noChoose">
            <div> <i class="iconfont icon-kong"></i><p>没有选定的组件<br>请拖拽左侧组件栏添加或者选择一个组件</p></div>
          </div>
      </div>
      </div>
    </div>
</template>

<script>
import leftBar from '../components/leftBar/panel.vue'
import toolPanel from '../components/toolBar/toolPanel'
import CereshopLayout from '../components/canvasEditPage'
import { mapGetters, mapMutations } from 'vuex'
import api from '@@/components/canvasShow/config/api'
import {sendReqMixin} from '@@/components/canvasShow/config/mixin'
import Cookies from 'js-cookie'
  export default {
    name: 'canvasContainer',
    mixins: [sendReqMixin],
    components: {
      CereshopLayout,
      leftBar,
      toolPanel
    },
    data () {
      return {
        comChoose: false,
        deviceList: [{
          id: 1,
          name: 'xiaochengxu'

        }, {
          id: 2,
          name: 'h5'
        }, {
          id: 4,
          name: 'pc'
        }, {
          id: 3,
          name: 'app'
        }],
        canvasId: '',
        shopId: 0
      }
    },
    computed: {
      ...mapGetters([
        'terminal',
        'componentsData',
        'typeId'
      ])
    },
    mounted () {
      this.shopId = parseInt(Cookies.get('cereShopId'))
      this.canvasGet()
    },
    methods: {
      ...mapMutations({
        setTerminal: 'SET_TERMINAL',
        setActiveComponent: 'SET_ACTIVECOMPONENT',
        setComponentsData: 'SET_COMPONENTSDATA'
      }),
      toggleDevice (id) {
        this.setActiveComponent({})
        this.setTerminal(id)
        this.canvasGet()
      },
      // 保存画布
      canvasSave () {
        // 删除非必要的字符
        let cloneComponentsData = JSON.parse(JSON.stringify(this.componentsData))
        for (let i = 0; i < cloneComponentsData.length; i++) {
          delete cloneComponentsData[i].iconClass
          if (cloneComponentsData[i].type === 'productList') {
            cloneComponentsData[i].componentContent.productData.imgTextData = [] // 清除展示数据
          }
        }
        var paramsData = {
          terminal: this.terminal,
          json: JSON.stringify(cloneComponentsData)
        }
        if (this.canvasId) {
          paramsData.canvasId = this.canvasId
        }
        if (this.shopId && this.typeId == 3) {
          paramsData.shopId = this.shopId
        }
        paramsData.type = this.typeId
        console.log(paramsData)
        let params = {
          url: api.saveCanvas,
          method: 'POST',
          data: paramsData
        }
        this.sendReq(params, (res) => {
          if (res.message) {
            this.$message.error(res.message)
          } else {
            this.$message({
              message: '保存成功！',
              type: 'success'
            })
          }
        })
      },
      // 读取画布
      canvasGet () {
        var _this = this
        this.setComponentsData([])
        var apiUrl = api.getCanvas + '?terminal=' + this.terminal + '&type=' + this.typeId
        if (this.shopId && this.typeId == 3) {
          apiUrl += '&shopId=' + this.shopId
        }
        let params = {
          url: apiUrl,
          method: 'GET'
        }
        this.sendReq(params, (res) => {
          if(typeof(uni) !== 'undefined'){
            uni.setStorage({key: 'sendNum',data: 0});
          } else {
            localStorage.setItem('sendNum', 0)
          }
          if (JSON.stringify(res.data) !== '{}') {
            _this.canvasId = res.data.canvasId
            var componentsData = JSON.parse(res.data.json)
            for (let i = 0; i < componentsData.length; i++) {
              componentsData[i].componentContent.hasDatas = true
            }
            _this.setComponentsData(componentsData)
          } else {
            _this.canvasId = ''
          }
        },(err)=>{

        })
      },
      // 右侧工具栏显隐
      showRightBox (flag) {
        this.comChoose = flag
      }
    }
  }
</script>

<style lang="scss" scoped>
  .canvas {
    position: relative;
    display: flex;
    flex-direction: column;
    height: 100%;

    .topBox{
      height: 52px;
      line-height: 52px;
      border-bottom: 1px solid #F0F3F4;
      position: relative;
      display: flex;
      justify-content: center;
      .btn-black{
        position: absolute;
        left: 20px;
        top: 0;
      }
      li{
        width: 56px;
        height: 52px;
        cursor: pointer;
        text-align: center;
        display: inline-block;
        .iconfont{
          font-size: 24px;
        }
        &:hover,&.on{
          background-color: $mainColor;
          color: #fff;
        }
      }
      .btn-save{
        position: absolute;
        right: 20px;
        top: 5px;
      }
    }
    .bottomWarp{
      flex: 1;
      display: flex;
      height: 0;
    }
    .leftBox {
      height: 100%;
      overflow-y: auto;
      overflow-x: hidden;
    }
    .mainContentWarp{
      background-color: #F0F3F4;
      overflow: auto;
      height: 100%;
      flex: 1;
      .mainContent{
        margin: 0 auto;
        max-width: 100%;
        width: 750px;
        &.view-4{
          width: 1300px;
        }
      }
    }
    .RightBox {
      height: 100%;
      overflow: auto;
      .noChoose{
        width: 320px;
        display: flex;
        height: 100%;
        -webkit-box-align: center;
        align-items: center;
        -webkit-box-pack: center;
        justify-content: center;
        color: #999;
        text-align: center;
        font-size: 16px;
        line-height: 1.8;
        .iconfont{
          font-size: 100px;
          color: $mainColor;
        }
      }
    }
  }
</style>
