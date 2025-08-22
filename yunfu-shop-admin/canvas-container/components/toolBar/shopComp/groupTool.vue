<template>
  <div class="brandListTool">
    <h3 class="toolTit">拼团专区</h3>
<!--    <div class="toolBox" v-if="terminal !== 4">-->
<!--      <div class="itemBox">-->
<!--        <label>标题</label>-->
<!--        <el-input v-model="activeComponent.componentContent.title" placeholder="请输入内容"></el-input>-->
<!--      </div>-->
<!--    </div>-->
    <div v-if="typeId == 3">
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
    </div>
      <div class="styleSelectLine" v-if="terminal == 4">
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
      <div class="toolBox" v-if="activeComponent.componentContent.arrangeType === '多行多列' && terminal == 4">
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
    <el-dialog title="选择活动" :visible.sync="showSkillActivity" width="900px">
      <el-table :data='skillActivity' style="width: 100%" @row-click="rowClick" highlight-current-row>
        <el-table-column label width="35">
          <template slot-scope="scope">
            <el-radio :label="scope.row.shopGroupWorkId" v-model="radioId"/>
          </template>
        </el-table-column>
        <el-table-column
          prop="groupName"
          label="标题">
        </el-table-column>
        <el-table-column
          :formatter="getDate"
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
import ToolSelect from '../toolModule/tool-select'
import ToolSingleImg from '../toolModule/tool-single-img'
import ToolSelectLink from '../toolModule/tool-select-link'
export default {
  mixins: [toolMixin, sendReqMixin],
  name: 'groupTool',
  components: {
    ToolSelectLink,
    ToolSingleImg,
    ToolSelect,
    Draggable
  },
  data () {
    return {
      radioId: '',
      skillActivity: [],
      selectSkill: {},
      showSkillActivity: false,
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
      categoryList: [],
      textAlign: 'left',
      imgCurrent: null,
      dialogVisible: false,
      dialogCategory: false,
      currentCategory: null,
      // categoryName: '', // 类别名称
      productList: [], // 产品列表
      productNum: 2, // 商品展示数量
      labelCurrent: null,
      arrangeList: [
        // {
        //   id: 1,
        //   type: 'L1',
        //   name: '一行一个',
        //   Icon: '&#xe603'
        // },
        {
          id: 2,
          type: 'L2',
          name: '多行多列',
          Icon: '&#xe625'
        },
        {
          id: 3,
          type: 'L3',
          name: '横向滑动',
          Icon: '&#xe624;'
        }
      ]
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
      setGroupNum: 'SET_GROUPNUM'
    }),
    // 时间变换
    getDate(row) {
      return `${row.startTime}至${row.endTime}`
    },
    // 状态变换
    getState(row) {
      const opt = {
        0:"未开始",
        1:"进行中",
        2:"已结束"
      }
      return opt[row.state]
    },
    // 点击选择活动
    selectActivity() {
      this.getActivity()
      this.showSkillActivity = true
      this.radioId = this.activeComponent.componentContent.shopGroupWorkId
    },
    // 获取活动数据
    getActivity() {
      const _ = this
      const params = {
        method: 'GET',
        url: `${api.getGroupWorks}?shopId=${Cookies.get('cereShopId')}`,
      }
      this.sendReq(params, (res) => {
        _.skillActivity = res.data
      })

    },
    // 行点击
    rowClick(row) {
      this.selectSkill = row;
      this.radioId=row.shopGroupWorkId;
    },
    // 确认活动选择
    confirmActivity() {
      this.activeComponent.componentContent.shopGroupWorkId = this.selectSkill.shopGroupWorkId
      this.activeComponent.componentContent.activityName = this.selectSkill.groupName
      this.showSkillActivity = false
      this.setGroupNum() // 通知画布刷新
    },
    // 取消活动选择
    cancelSkill() {
      this.showSkillActivity = false;
      this.radioId = ''
    },
    // 替换活动
    replaceActivity () {
      this.showSkillActivity = true
      this.getActivity()
    },
    // 删除已选活动
    deleteActivity () {
      this.activeComponent.componentContent.activityName = ''
      this.activeComponent.componentContent.shopGroupWorkId = ''
      this.setGroupNum() // 通知画布刷新
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
.config-content {
  .item {
    padding: 12px 0;
    border-bottom: 1px #ddd solid;
    &:nth-child(1) {
      border-top: 1px #ddd solid;
    }
  }
  .label-text {
    color: #666;
    span {
      color: hsl(357, 97%, 49%);
      font-size: 20px;
      vertical-align: middle;
      display: inline-block;
      margin-right: 5px;
    }
  }

  .add {
      margin-top: 10px;
      width: 50px;
      height: 50px;
      text-align: center;
      line-height: 50px;
      border:1px #ddd solid;
      box-shadow: 0 0 10px #ddd;
      .el-icon-plus {
        color: blue !important;
      }
      &:hover {
        cursor: pointer;
      }
  }
}


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

.porListBox {
  margin-top: 10px;
  padding: 10px;
  background: #F0F3F4;
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
</style>
