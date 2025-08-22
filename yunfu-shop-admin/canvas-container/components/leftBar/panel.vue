<template>
  <div class="panelBoxWarp">
    <div class="panelBox" :class="{'on':sidebarShow}">
      <!--<div class="componentList">-->
        <!--<ul>-->
          <!--<li v-for="(item, index) of componentList" :key="index" :class="{'on':componentActive == index}" @click="componentActive=index">-->
            <!--<i class="iconfont icon-fangkuai"></i>-->
            <!--<span>{{item}}</span>-->
          <!--</li>-->
        <!--</ul>-->
      <!--</div>-->
      <div class="categoryList">
        <div class="itemBox" v-for="(item, index) of panelShowList" :key="index">
          <h3>{{item.title}}</h3>
          <div class="childList">
            <draggable
              class="dragArea list-group"
              :list="item.classList"
              :clone="cloneItem"
              :group="{ name: 'pageEdit', pull: 'clone', put: false }"
              :options="{sort:false}"
            >
              <div @mouseover="hoverItem (classItem)" @mouseout="hoverItemOut" class="childItem list-group-item" v-for="(classItem, index) of item.classList" :key="index">
                <div class="childItemWarp">
                  <div class="contentBox">
                    <i class="iconfont" :class="classItem.iconClass"></i>
                    <span>{{classItem.title}}</span>
                  </div>
                  <div class="cloneText">
                    组件放置区域
                  </div>
                </div>
              </div>
            </draggable>
          </div>
        </div>
      </div>
    </div>
    <div class="btnToggle" @click="sidebarShow=!sidebarShow" :class="{'on':sidebarShow}">
      <i class="iconfont icon-arrow-right"></i>
      <i class="iconfont icon-arrow-left"></i>
    </div>
  </div>
</template>

<script>
  // 默认配置文件
  import panelList from './panelList'
  import draggable from 'vuedraggable'
  import { mapGetters } from 'vuex'
  export default {
    name: 'panel',
    components: {
      draggable
    },
    data () {
      return {
        sidebarShow: true,
        componentActive: 0,
        componentList: ['组件', '组件'],
        panelList: panelList,
        isHover: ''
      }
    },
    methods: {
      hoverItem (classItem) {
        this.isHover = classItem.title
      },
      hoverItemOut () {
        this.isHover = ''
      },
      cloneItem (item) {
        return JSON.parse(JSON.stringify(item))
      }
    },
    computed: {
      ...mapGetters([
        'terminal',
        'typeId'
      ]),
      panelShowList(){
        let _this = this
        var _panelList = JSON.parse(JSON.stringify(this.panelList))
        var mewPaneList =  _panelList.filter(parent=>{
          let children = parent.classList.filter(child=>{
            console.log(child.title,!(child.onlyApp && _this.terminal==4),!(child.onlyAdmin && _this.typeId==3),!(child.onlyMerchant && _this.typeId==1))
            return !(child.onlyApp && _this.terminal==4) && !(child.onlyAdmin && _this.typeId==3) && !(child.onlyMerchant && _this.typeId==1)
          })
          parent.classList = children
          return parent
        })
        console.log(this.panelList)
        return mewPaneList
      }
    }
  }
</script>

<style lang="scss" scoped>
  .panelBoxWarp{
    position: relative;
    height: 100%;
  }
  .panelBox {
    width: 0px;
    min-height: 100%;
    display: flex;
    overflow: hidden;
    transition: 0.2s width ease;
    &.on{
      width: 200px;
    }
    .componentList{
      width: 64px;
      padding: 17px 0;
      text-align: center;
      li{
        position: relative;
        margin-bottom: 18px;
        .iconfont{
          font-size: 24px;
        }
        span{
          font-size: 12px;
          display: block;
        }
        &.on,&:hover{
          color: $mainColor;
          :after{
            content: '';
            position: absolute;
            left: 0;
            top: 0;
            width: 2px;
            height: 100%;
            background-color: $mainColor;
          }
        }
      }
    }
    .categoryList {
      border-left: 1px solid #F0F3F4;
      width: 186px;
      padding: 20px 0 20px 10px;
      .itemBox {
        h3 {
          padding-left: 20px;
          height: 35px;
          line-height: 35px;
          font-size: 16px;
          color: #333333;
          position: relative;
          &:before{
            content: '';
            border-left:5px solid $mainColor;
            border-top:4px solid transparent;
            border-bottom:4px solid transparent;
            position: absolute;
            left: 10px;
            top: 50%;
            margin-top: -4px;
          }
        }
        .childList {
          font-size: 14px;
          color: #333333;
          padding: 20px 10px;
          .list-group{
            display: flex;
            flex-wrap: wrap;
            :hover {
              background: #FF7800;
              color: #ffffff;
              border-radius: 3px;
              //cursor: move;
            }
            .childItemWarp{
              height: 80px;
            }
            .childItem {
              width: 50%;
              .contentBox{
                height: 100%;
                display: flex;
                flex-flow: column;
                align-items: center;
                justify-content: center;
                cursor: move;
                .iconfont{
                  font-size: 30px;
                }
                span {
                  margin-top: 5px;
                }
              }
              .cloneText{
                display: none;
              }
            }
          }
        }
      }
    }
  }
  .btnToggle{
    width: 20px;
    height: 66px;
    background-color: #fff;
    border-radius: 0 20px 20px 0;
    position: absolute;
    right: -20px;
    top: 50%;
    margin-top: -33px;
    display: flex;
    align-items: center;
    cursor: pointer;
    z-index: 9;
    .icon-arrow-left{
      display: none;
    }
    &.on{
      .icon-arrow-left{
        display: block;
      }
      .icon-arrow-right{
        display: none;
      }
    }
  }
</style>
