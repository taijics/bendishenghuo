<template>
  <div class="categoryTool">
    <h3 class="toolTit">类别列表</h3>
    <div class="toolBox">
      <div class="itemBox">
        <label>标题</label>
        <el-input v-model="activeComponent.componentContent.title" maxlength="20" placeholder="请输入内容"></el-input>
      </div>
      <tool-select :linkValue.sync='activeComponent.componentContent.textAlign' title="文字对齐方式" :options="alignList"></tool-select>
      <div class="textTit">添加类别</div>
      <div class="categoryListBox">
        <draggable v-model="activeComponent.componentContent.categoryData">
          <div v-for="(item, index) in activeComponent.componentContent.categoryData" :key="index" class="item">
            <div class="listItemBox">
              <div class="addImgTit" @click="openAddCategory(item, index)">
                <div class="titLeft">
                  <span class="iconfont">&#xe703;</span>
                  <span class="iconfont">&#xe64a;</span>
                  <span>类别</span>
                </div>
                <div class="titRight">
                  <span class="iconfont" @click.stop="deleteItem(item, index)">&#xe633;</span>
                  <span v-html="categoryCurrent === index ? '&#xe660;' : '&#xe695;'" class="iconfont"></span>
                </div>
              </div>
              <div class="addBox" v-show="categoryCurrent === index">
                <div class="addContent">
                  <tool-single-img :imageUrl.sync='item.img' tip='建议尺寸5:4等比例图片'></tool-single-img>
                  <div v-if="!item.selClassData.categoryName" class="addCategoryBox" @click="addItemCategory(item, index)"><span class="iconfont">&#xe685;</span>添加类别</div>
                  <div v-else class="categoryName">
                    <span>{{item.selClassData.categoryName}}</span>
                    <div class="operation">
                      <span class="iconfont" @click="replaceCategory(index)">&#xe66c;</span>
                      <span class="iconfont" @click="deleteCategory(index)">&#xe633;</span>
                    </div>
                  </div>
                </div>
                <div @click="deleteItem(item, index)" class="deleteItem"><span class="iconfont">&#xe633;</span>删除内容</div>
              </div>
            </div>
          </div>
        </draggable>
      </div>
    </div>
    <div class="addImgBtn" v-show="activeComponent.componentContent.categoryData.length < 6" @click="addCategory"><span class="iconfont">&#xe64a;</span>添加类别</div>
    <div class="addImgBtn" v-show="activeComponent.componentContent.categoryData.length === 6"><span class="iconfont">&#xe608;</span>最多只能添加6个</div>
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
    <el-dialog title="选择类别" :visible.sync="dialogCategory" width="480px">
      <category-select ref="categorySelect"></category-select>
      <span slot="footer" class="dialog-footer">
         <el-button @click="dialogCategory = false">取 消</el-button>
         <el-button type="primary" @click="categoryChanged">确 定</el-button>
      </span>
    </el-dialog>
  </div>
</template>

<script>
  import Draggable from 'vuedraggable'
  import {toolMixin} from '@@/config/mixin'
  import CategorySelect from '../toolModule/category-select'
  import ToolSingleImg from '../toolModule/tool-single-img'
  import ToolSelect from '../toolModule/tool-select'
  // import imageSrc from '../../../assets/canvasImg'
  export default {
    mixins: [toolMixin],
    name: 'categoryTool',
    components: {
      ToolSelect,
      ToolSingleImg,
      CategorySelect,
      Draggable
    },
    data () {
      return {
        title: '', // 标题内容
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
          },
          {
            id: 3,
            label: '居右',
            value: 'right'
          }
        ],
        textAlign: 'left',
        categoryCurrent: null,
        dialogVisible: false,
        dialogCategory: false,
        currentCategory: null
      }
    },
    computed: {
    },
    methods: {
      openAddCategory (item, index) {
        if (this.categoryCurrent === index) {
          this.categoryCurrent = null
          return false
        }
        this.categoryCurrent = index
      },
      // 添加类别
      addCategory () {
        this.activeComponent.componentContent.categoryData.push({
          selClassData: [],
          img: ''
        })
      },
      // 删除内容
      deleteItem (item, index) {
        this.$confirm('确定删除此项？')
          .then(_ => {
            this.activeComponent.componentContent.categoryData.splice(index, 1)
          })
          .catch(_ => {
          })
      },
      addItemCategory (item, index) {
        this.dialogCategory = true
        this.categoryCurrent = index
      },
      // 替换类别
      replaceCategory (index) {
        this.dialogCategory = true
        this.categoryCurrent = index
        console.log(this.categoryCurrent)
      },
      // 删除已选类别
      deleteCategory (index) {
        this.activeComponent.componentContent.categoryData[index].selClassData = ''
      },
      // 选择类别
      categoryChanged () {
        let nodesObj = this.$refs.categorySelect.$refs['cascader'].getCheckedNodes()
        console.log(nodesObj, this.categoryCurrent)
        if (nodesObj) {
          var data = nodesObj[0].data
          this.dialogCategory = false
          this.activeComponent.componentContent.categoryData[this.categoryCurrent].id = data.id
          this.activeComponent.componentContent.categoryData[this.categoryCurrent].selClassData = data
        }
      }
    }
  }
</script>

<style lang="scss" scoped>
  .categoryTool {
    padding: 20px 20px 0 20px;
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
      .textTit {
        height: 35px;
        line-height: 35px;
        font-size: 16px;
        color: #333333;
        font-weight: bold;
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
    }
     ::v-deep .ql-container {
      height: 200px;
    }
    .categoryListBox {
      margin-top: 30px;
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
        .addContent {
          padding: 13px;
          .addCategoryBox {
            width: 100%;
            height: 35px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #ffffff;
            background: $mainColor;
            border-radius: 4px;
            margin: 15px 0;
            cursor: pointer;
          }
          .deleteItem {
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
            margin-bottom: 10px;
            span {
              font-size: 18px;
              color: #ffffff;
              margin-right: 5px;
            }
          }
          .categoryName {
            height: 35px;
            display: flex;
            align-items: center;
            background: #e9e9e9;
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
    .classList {
      .classTit {
        display: flex;
        justify-content: space-between;
        height: 50px;
        align-items: center;
        padding:0 20px;
        background: #eeeeee;
        span {
          display: block;
          width: 100px;
          text-align: center;
        }
      }
      .classListBox {
        max-height: 300px;
        overflow-y: auto;
        .classItemBox {
          display: flex;
          padding: 0 20px;
          align-items: center;
          border-bottom: 1px solid #eeeeee;
          div {
            display: flex;
            flex: 1;
            justify-content: space-between;
            height: 50px;
            align-items: center;
            span:nth-child(1) {
              padding-left: 5px;
            }
            span {
              display: block;
              width: 100px;
              text-align: left;
            }
            span:nth-child(2) {
              text-align: center;
            }
          }
        }
      }
    }
  }
</style>
