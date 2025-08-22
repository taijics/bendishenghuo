<template>
  <div class="module-box link-select">
    <div class="module-box__title">
      <label class="module-box__label">{{title}}</label>
    </div>
    <div class="link-select__confirm">
      <div class="btn" v-if="selectedCategoryList && selectedCategoryList.length === 0" @click="openDialog">
        <span class="iconfont">&#xe685;</span> 添加类别
      </div>
      <div class="info" v-else>
        <div><span>{{selectedCategoryList[0].categoryName}}</span><span v-if="selectedCategoryList.length > 1">+{{selectedCategoryList.length-1}}</span></div>
        <div class="operation">
          <i class="iconfont" @click="openDialog">&#xe66c;</i>
          <i class="iconfont" @click="deleteCategory">&#xe633;</i>
        </div>
      </div>
    </div>
    <el-dialog width="500" title="选择类别" :visible.sync="categoryVisible">
      <el-select v-if="terminal === 4"
        v-model="categoryValue"
        multiple
        collapse-tags
        placeholder="请选择">
        <el-option
          v-for="item in categoryList"
          :key="item.id"
          :label="item.categoryName"
          :value="item.id">
        </el-option>
      </el-select>
      <el-cascader v-else
        ref="cascader"
        :options="categoryList" :props="{ multiple: true,label: 'categoryName',value: 'id',children: 'childs' }"
        clearable></el-cascader>
      <span slot="footer" class="dialog-footer">
         <el-button @click="categoryVisible = false">取 消</el-button>
         <el-button type="primary" @click="categoryChanged">确 定</el-button>
      </span>
    </el-dialog>
  </div>
</template>

<script>
  import api from '@@/components/canvasShow/config/api'
  import {sendReqMixin} from '@@/components/canvasShow/config/mixin'
  import {checkEmptyChild} from '@@/config/common'
  import { mapGetters } from 'vuex'
  export default {
    name: 'tool-select-category',
    mixins: [sendReqMixin],
    data () {
      return {
        props: { multiple: true },
        selectName: '',
        categoryValue: [],
        selectedCategoryList: [],
        categoryList: [],
        categoryVisible: false
      }
    },
    props: {
      title: {
        type: String,
        default: '链接'
      },
      category: {
        type: Array,
        default: () => []
      }
    },
    mounted () {
      this.getCategory()
      this.selectedCategoryList = this.category
    },
    computed: {
      ...mapGetters([
        'terminal'
      ])
    },
    methods: {
      // 获取类别
      getCategory () {
        var _this = this
        let params = {
          url: api.getClassify,
          method: 'GET'
        }
        this.sendReq(params, (res) => {
            _this.categoryList = res.data
          checkEmptyChild(_this.categoryList)
        })
      },
      // 打开添加弹窗
      openDialog () {
        this.categoryVisible = true
      },
      // 类别选择
      categoryChanged () {
        this.categoryVisible = false
        if (this.terminal === 4) {
          this.selectedCategoryList = this.categoryList.filter((item) => {
            for (let i = 0; i < this.categoryValue.length; i++) {
              if (this.categoryValue[i] === item.id) {
                return true
              }
            }
          })
        } else {
          let nodesArr = this.$refs['cascader'].getCheckedNodes()
          if (nodesArr) {
            nodesArr = nodesArr.filter((item) => {
              return item.children.length === 0
            })
            this.selectedCategoryList = []
            for (let i = 0; i < nodesArr.length; i++) {
              this.selectedCategoryList.push(nodesArr[i].data)
            }
          }
        }
        this.$emit('update:category', this.selectedCategoryList)
      },
      // 删除选择
      deleteCategory () {
        this.categoryValue = []
        this.$emit('update:category', [])
      }
    }
  }
</script>

<style lang="scss" scoped>
  .link-select{
    &__select{
     width: 100%;
    }
    &__confirm{
      margin-top: 10px;
      .btn{
        text-align: center;
        background-color: $mainColor;
        color: #fff;
        height: 36px;
        line-height: 36px;
        border-radius: 4px;
        cursor: pointer;
      }
      .info{
        height: 36px;
        line-height: 36px;
        border-radius: 4px;
        padding: 0 10px;
        border:1px solid $mainColor;
        display: flex;
        justify-content: space-between;
        span{
          background-color: #f4f4f5;
          border:1px solid #e9e9eb;
          color: #909399;
          height: 26px;
          padding: 0 8px;
          line-height: 24px;
          border-radius: 4px;
          margin: 5px 6px 5px 0px;
          display: inline-block;
        }
        .operation{
          float: right;
          i{
            width: 35px;
            display: inline-block;
            height: 35px;
            line-height: 35px;
            text-align: center;
            cursor: pointer;
          }
        }
      }
    }
  }
</style>
