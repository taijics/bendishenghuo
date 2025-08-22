<template>
  <div class="brandListTool">
    <h3 class="toolTit">商品列表</h3>
    <div class="toolBox">
<!--      <div class="itemBox" v-if="terminal !== 4">-->
<!--        <label>标题</label>-->
<!--        <el-input v-model="activeComponent.componentContent.title" placeholder="请输入内容"></el-input>-->
<!--      </div>-->
      <tool-product-source :productData.sync='activeComponent.componentContent.productData' :type="activeComponent.type"></tool-product-source>
      <div class="styleSelectLine">
        <div class="blockTit">
          <span>排列样式</span>
          <span>{{activeComponent.componentContent.arrangeType}}</span>
        </div>
        <div class="selectCompose">
          <div class="composeList">
            <span class="item iconfont" :class="{active: activeComponent.componentContent.arrangeType === item.name}" @click="selectArrange(item)" v-for="(item) of arrangeList" :key="item.id" v-html="item.Icon"></span>
          </div>
        </div>
      </div>
      <div v-if="activeComponent.componentContent.arrangeType === '多行多列' && terminal == 4">
        <div class="productTit">
          <span>展示排数</span>
          <span>{{activeComponent.componentContent.productRowNum}}</span>
        </div>
        <div class="itemBox">
          <div class="block">
            <el-slider :max="9" :min="1" v-model="activeComponent.componentContent.productRowNum"></el-slider>
          </div>
        </div>
        <div class="productTit">
          <span>每排商品数</span>
          <span>{{activeComponent.componentContent.productNum}}</span>
        </div>
        <div class="itemBox">
          <div class="block">
            <el-slider :max="5" :min="2" v-model="activeComponent.componentContent.productNum"></el-slider>
          </div>
        </div>
      </div>
      <div class="itemChoice">
        <div class="Tit">查看更多</div>
        <div class="Info" v-text="activeComponent.componentContent.showMore ? '显示' : '隐藏'"></div>
        <div class="modifyBox">
          <el-checkbox v-model="activeComponent.componentContent.showMore"></el-checkbox>
        </div>
      </div>
<!--      <div class="moreBox" v-show="activeComponent.componentContent.showMore">-->
<!--        <div class="link">-->
<!--          <tool-select-link :linkObj.sync='activeComponent.componentContent.linkObj' styleType="1"></tool-select-link>-->
<!--        </div>-->
<!--      </div>-->

    </div>
    <el-dialog
      title="提示"
      :visible.sync="dialogVisible"
      width="30%"
      :before-close="deleteItem">
      <span>点击确定删除此项</span>
      <span slot="footer" class="dialog-footer">
    <el-button @click="dialogVisible = false">取 消</el-button>
    <el-button type="primary" @click="dialogVisible = false">确 定</el-button>
  </span>
    </el-dialog>
  </div>
</template>

<script>
  import Draggable from 'vuedraggable'
  import {toolMixin} from '@@/config/mixin'
  import { mapGetters } from 'vuex'
  import ToolSelect from '../toolModule/tool-select'
  import ToolSingleImg from '../toolModule/tool-single-img'
  import ToolSelectLink from '../toolModule/tool-select-link'
  import ToolProductSource from '../toolModule/tool-product-source'
  export default {
    mixins: [toolMixin],
    name: 'productListTool',
    components: {
      ToolProductSource,
      ToolSelectLink,
      ToolSingleImg,
      ToolSelect,
      Draggable
    },
    data () {
      return {
        title: '', // 标题内容
        textInfo: '', // 文本
        imgTextData: [
          {
            title: '',
            isShow: true,
            imgData: '',
            describe: '',
            url: ''
          }
        ],
        alignList: [
          {
            id: 1,
            label: '居左',
            value: 'left'
          },
          {
            id: 2,
            label: '居中',
            value: 'center'
          }
        ],
        textAlign: 'left',
        imgCurrent: null,
        dialogVisible: false,
        currentCategory: null,
        // categoryName: '', // 类别名称
        productList: [], // 产品列表
        productNum: 2, // 商品展示数量
        labelCurrent: null,
        arrangePCList: [
          {
            id: 1,
            type: 'L2',
            name: '多行多列',
            Icon: '&#xe625'
          },
          {
            id: 2,
            type: 'L2',
            name: '横向滑动',
            Icon: '&#xe624;'
          }
        ],
        arrangeAppList: [
          {
            id: 1,
            type: 'L1',
            name: '多行多列',
            Icon: '&#xe625'
          },
          {
            id: 2,
            type: 'L2',
            name: '横向滑动',
            Icon: '&#xe624;'
          },
        ]
      }
    },
    computed: {
      ...mapGetters([
        'terminal'
      ]),
      arrangeList(){
        if(this.terminal == 4){
          return this.arrangePCList
        } else {
          return this.arrangeAppList
        }
      }
    },
    methods: {
      openAddImg (item, index) {
        if (this.imgCurrent === index) {
          this.imgCurrent = null
          return false
        }
        this.imgCurrent = index
      },
      // 添加图文
      addImgText () {
        this.activeComponent.componentContent.imgTextData.push({
          title: '',
          isShow: true,
          imgData: '',
          url: ''
        })
      },
      // 删除内容
      deleteItem (item, index) {
        this.$confirm('确定删除此项？')
          .then(_ => {
            this.activeComponent.componentContent.imgTextData.splice(index, 1)
          })
          .catch(_ => {})
      },

      handleAvatarSuccess (res, file) {
        this.imageUrl = URL.createObjectURL(file.raw)
      },
      // 标签手风琴
      openAddLabel (item, index) {
        if (this.labelCurrent === index) {
          this.labelCurrent = null
          return false
        }
        this.labelCurrent = index
      },
      // 添加标签
      addLabel () {
        this.activeComponent.componentContent.labelList.push({
          name: '',
          url: ''
        })
      },
      // 删除标签
      deleteLabelItem (item, index) {
        this.$confirm('确定删除此项？')
          .then(_ => {
            this.activeComponent.componentContent.labelList.splice(index, 1)
          })
          .catch(_ => {})
      },
      // 布局选择
      selectArrange (item) {
        this.activeComponent.componentContent.arrangeType = item.name
      }
    }
  }
</script>

<style lang="scss" scoped>
  .brandListTool {
    padding: 20px 20px 0px 20px;
    h3 {
      font-size: 18px;
      font-weight: 500;
      height: 35px;
      line-height: 35px;
      color: #333333;
      margin-bottom: 20px;
    }
    .toolBox {
      padding-bottom: 10px;
      .itemChoice {
        font-size: 14px;
        display: flex;
        margin: 20px 0;
        align-items: center;
        .Tit {
          color: #888888;
          margin-right: 10px;
          width: 70px;
        }
        .Info {
          color: #222222;
        }
        .modifyBox {
          text-align: right;
          margin-left: auto;
          span {
            height: 26px;
            line-height: 26px;
            float: left;
            display: block;
            text-align: center;
            cursor: pointer;
            width: 30px;
            border: 1px solid #E8EAEC;
          }
          .textActive {
            border: 1px solid $mainColor;
            color: $mainColor;
          }
          .colorBox {
            display: flex;
            align-items: center;
            justify-content: flex-end;
            span {
              margin-right: 10px;
              cursor: pointer;
              border: none;
              color: $mainColor;
            }
          }
        }
        .fontSize {
          span:nth-child(1) {
            font-size: 16px;
          }
          span:nth-child(2) {
            font-size: 14px;
          }
          span:nth-child(3) {
            font-size: 12px;
          }
        }
      }
      .moreBox{
        border: 1px solid #E8EAEC;
        border-radius: 4px;
        padding:20px 10px;
        .radio{
          margin-bottom: 20px;
        }
        .el-radio{
          margin-right: 10px;
        }
        .link{
          display: flex;
          justify-content: space-between;
          align-items: center;
        }
      }
      .itemBox {
        label {
          font-size: 14px;
          color: #666666;
          height: 40px;
          line-height: 40px;
        }
        margin-bottom: 15px;
      }
      .textTit {
        height: 35px;
        line-height: 35px;
        font-size: 14px;
        color: #333333;
        display: flex;
        justify-content: space-between;
        span {
          font-weight: normal;
          font-size: 14px;
          color: #666666;
        }
      }
      .productTit {
        margin-top: 20px;
        color: #666666;
        height: 35px;
        display: flex;
        align-items: center;
        justify-content: space-between;
        span {
          font-size: 14px;
          color: #666666;
        }
      }
    }
    // ::v-deep .el-select {
    //  width: 100%;
    //}
    .addImgBtn {
      border-radius: 4px;
      background: $mainColor;
      text-align: center;
      height: 36px;
      color: #ffffff;
      font-size: 14px;
      display: flex;
      align-items: center;
      justify-content: center;
      cursor: pointer;
      span {
        font-size: 20px;
        margin-right: 5px;
      }
    }
    .labelLisTit{
      display: flex;
      justify-content: space-between;
      margin-bottom: 10px;
    }
    .labelListWarp{
      padding-bottom: 20px;
      .imgListBox {
        margin-top: 20px;
        .item {
          border: 1px solid #E8EAEC;
          border-radius: 4px;
          margin-bottom: 10px;
        }
        .listItemBox {
          .addImgTit {
            padding: 10px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: #F6F7F9;
            cursor: pointer;
            .titLeft {
              display: flex;
              align-items: center;
              span {
                color: #7D7E80;
              }
              span:nth-child(1) {
                font-size: 28px;
              }
              span:nth-child(2) {
                font-size: 25px;
                margin: 0 6px;
              }
              span:nth-child(3) {
                font-size: 14px;
              }
            }
            .titRight {
              display: flex;
              align-items: center;
              span:nth-child(1) {
                width: 40px;
                text-align: center;
                display: block;
                height: 30px;
                line-height: 30px;
              }
            }
          }
          .addLabelBox{
            padding:0 10px 10px;
            .itemBox{
              margin-bottom: 20px;
              label{
                font-size: 14px;
                color: #666666;
                height: 40px;
                line-height: 40px;
              }
            }
             ::v-deep .module-box{
              margin-bottom: 10px;
            }
          }
          .deleteItem {
            padding: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: #F6F7F9;
            cursor: pointer;
            color: $mainColor;
            font-size: 14px;
            span {
              font-size: 16px;
              margin-right: 5px;
            }
          }
        }
      }
    }
  }

  .styleSelectLine{
    margin-top: 30px;
    .blockTit{
      span{
        margin-right: 16px;
        &:last-child{
          color: $mainColor;
        }
      }
    }
    .composeList{
      display: flex;
      flex-wrap: wrap;
      padding-top: 20px;
      .item{
        width: 50px;
        height: 30px;
        display: flex;
        align-items: center;
        justify-content: center;
        border: 1px solid #E8EAEC;
        color: #999999;
        font-size: 18px;
        text-align: center;
        cursor: pointer;
        &:hover,&.active{
          color: #FF7800;
          border: 1px solid #FF7800;
        }
      }
    }
  }
</style>
