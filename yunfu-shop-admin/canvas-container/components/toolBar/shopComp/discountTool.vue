<template>
  <div class="brandListTool">
    <h3 class="toolTit">限时折扣</h3>
    <div class="toolBox">
      <div class="porListBox">
        <div class="addProduct">
          <div v-if="!activeComponent.componentContent.activityName" class="addProBtn addImgBtn" @click="selectActivity"><span class="iconfont">&#xe685;</span>选择活动</div>
          <div v-else class="categoryName">
            <span>{{activeComponent.componentContent.activityName}}</span>
            <div class="operation">
              <span class="iconfont" @click="replaceActivity">&#xe66c;</span>
              <span class="iconfont" @click="deleteActivity">&#xe633;</span>
            </div>
          </div>
        </div>
      </div>
      <div class="itemBox" v-if="terminal == 4">
        <label>查看全部背景图</label>
        <tool-single-img :imageUrl.sync='activeComponent.componentContent.moreBg' tip='建议尺寸: 290*466px, 高度自适应'></tool-single-img>
      </div>
      <div class="styleSelectLine" v-if="terminal != 4">
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
      <div class="itemChoice" v-if="terminal != 4">
        <div class="Tit">查看更多</div>
        <div class="Info" v-text="activeComponent.componentContent.showMore ? '显示' : '隐藏'"></div>
        <div class="modifyBox">
          <el-checkbox v-model="activeComponent.componentContent.showMore"></el-checkbox>
        </div>
      </div>
    </div>
    <el-dialog title="选择活动" :visible.sync="showDiscountActivity" width="900px">
      <el-table :data='discountActivity' style="width: 100%" @row-click="rowClick" highlight-current-row>
        <el-table-column label width="35">
          <template slot-scope="scope">
            <el-radio v-if="typeId===1" :label="scope.row.discountId" v-model="radioId"/>
            <el-radio v-if="typeId===3" :label="scope.row.shopDiscountId" v-model="radioId"/>
          </template>
        </el-table-column>
        <el-table-column
          prop="discountName"
          label="标题">
        </el-table-column>
        <el-table-column
          :formatter="getDate"
          prop="startTime"
          width="400"
          label="活动时间">
        </el-table-column>
        <el-table-column
          prop="state"
          label="状态"
          :formatter='getState'>
        </el-table-column>
      </el-table>
      <span slot="footer" class="dialog-footer">
        <el-button @click="cancelSkill">取 消</el-button>
        <el-button type="primary" @click="confirmActivity">确 定</el-button>
      </span>
    </el-dialog>
  </div>
</template>

<script>
import Cookies from 'js-cookie'
import Draggable from 'vuedraggable'
import api from '@@/components/canvasShow/config/api'
import {toolMixin} from '@@/config/mixin'
import {sendReqMixin} from '@@/components/canvasShow/config/mixin'
import { mapGetters, mapMutations } from 'vuex'
import {checkEmptyChild} from '@@/config/common'
import ToolSelect from '../toolModule/tool-select'
import ToolSingleImg from '../toolModule/tool-single-img'
import ToolSelectLink from '../toolModule/tool-select-link'
export default {
  mixins: [toolMixin, sendReqMixin],
  name: 'discountTool',
  components: {
    ToolSelectLink,
    ToolSingleImg,
    ToolSelect,
    Draggable
  },
  data () {
    return {
      radioId: '',
      discountActivity: [],
      selectDiscount: {},
      showDiscountActivity: false,
      arrangeList: [
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
    }
  },
  computed: {
    ...mapGetters([
      'terminal',
      'typeId'
    ])
  },
  methods: {
    ...mapMutations({
      setDiscountNum: 'SET_DISCOUNTNUM'
    }),
    // 时间变换
    getDate(row) {
      return `${row.startTime}至${row.endTime}`
    },
    // 状态变换
    getState(row) {
      if(this.typeId === 1){
        const opt = {
          0:"报名未开始",
          1:"报名进行中",
          2:"活动待开始",
          3:"活动进行中",
          4:"活动已结束"
        }
        return opt[row.state]
      }
      if(this.typeId === 3){
        const opt = {
          0:"未开始",
          1:"进行中",
          2:"已结束"
        }
        return opt[row.state]
      }
      return opt[row.state]
    },
    // 点击选择活动
    selectActivity() {
      this.getActivity()
      this.showDiscountActivity = true
      this.radioId = this.activeComponent.componentContent.shopDiscountId
    },
    // 获取活动数据
    getActivity() {
      const _ = this
      let _url = ''
      if(this.typeId===1){
        _url = `${api.getMinDiscount}`
      } else if(this.typeId===3){
        _url = `${api.getDiscounts}?shopId=${Cookies.get('cereShopId')}`
      }
      const params = {
        method: 'GET',
        url: _url,
      }
      this.sendReq(params, (res) => {
        _.discountActivity = res.data
      })


    },
    // 行点击
    rowClick(row) {
      this.selectDiscount = row;
      this.radioId=row.shopDiscountId;
    },
    // 确认活动选择
    confirmActivity() {
      if(this.typeId===1){
        this.activeComponent.componentContent.discountId = this.selectDiscount.discountId
      } else if(this.typeId===3){
        this.activeComponent.componentContent.discountId = this.selectDiscount.shopDiscountId
      }
      this.activeComponent.componentContent.activityName = this.selectDiscount.discountName
      this.showDiscountActivity = false
      this.setDiscountNum() // 通知画布刷新
    },
    // 取消活动选择
    cancelSkill() {
      this.showDiscountActivity = false;
      this.radioId = ''
    },
    // 替换活动
    replaceActivity () {
      this.showDiscountActivity = true
      this.getActivity()
    },
    // 删除已选活动
    deleteActivity () {
      this.activeComponent.componentContent.activityName = ''
      this.activeComponent.componentContent.shopDiscountId = ''
      this.setDiscountNum() // 通知画布刷新
      this.$forceUpdate()
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
    .porListBox {
      padding: 10px;
      background: #F0F3F4;
      margin-bottom: 20px;
      .addProduct {
        .categoryName {
          height: 35px;
          display: flex;
          align-items: center;
          background: #e9e9e9;
          border-radius: 4px;
          padding: 0 10px;
          justify-content: space-between;
          span {
            color: #333333;
          }
          span {
            color: #333333;
          }
          .operation {
            display: flex;
            span {
              width: 35px;
              display: block;
              height: 35px;
              line-height: 35px;
              text-align: center;
              cursor: pointer;
            }
          }
        }
        .addProBtn {}
      }
    }
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
  }
  ::v-deep .el-select {
    width: 100%;
  }
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
