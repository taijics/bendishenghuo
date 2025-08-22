<template>
  <div class="qaList">
    <div class="attentionBox">
      <div class="">
        <div class="searchRight">
          <span v-if="!edit" class="batch" @click="showEdit">批量管理</span>
          <div v-else class="saveList">
            <el-checkbox v-model="selectAll" @change="changeChecked" :true-label='1' :false-label='0'>全选</el-checkbox>
            <span class="delete" @click="delFun">删除</span>
            <span class="save" @click="saveList">保存</span>
          </div>
        </div>
      </div>
    </div>
    <el-tabs v-model="activeName" @tab-click="handleClick">
      <el-tab-pane label="我的提问" name="question" class="sub-main" v-loading="loading">
        <div v-if="flag">
          <div class="questionList listBox">
            <div class="item"
              v-for="(item,index) in questionList"
              :key="item.problemId"
              :class="{selected: item.selected === 1, edit: edit}"
              @click="selectQu(index,item.selected)"
            >
              <div class="questionBox">
                <div class="mc" v-if="edit"></div>
                <img class="cur-poi" :src="item.image" alt="" @click="toProductDetail(item)">
                <div class="infoBox">
                  <div>
                    <span class="question spans">问</span>
                    <h3>{{ item.problem }}</h3>
                    <span class="time">{{ item.createTime }}</span>
                  </div>
                  <!-- {{ item.answers }} -->
                  <ul :class="{moreShow:current === index}" v-if="item.answers.length > 0">
                    <span class="answer spans">答</span>
                    <li class="answerList" v-for="(anw,inx) in item.answers" :key="anw.answerId">
                      <p>{{ anw.answer }}</p>
                      <span class="viewDetail"
                        :class="{noSee:current!==null&&inx!==item.answers.length-1}"
                        v-if="item.answers.length > 1"
                        @click="seeAll(index)"
                      >{{current===null?'查看全部':'收起'}}</span>
                    </li>
                  </ul>
                  <p v-else class="noReply">暂无回答</p>
                </div>
              </div>
            </div>
          </div>
          <el-pagination
            class="mar-top-30"
            v-if="questionList.length"
            background
            layout="prev, pager, next, jumper"
            :page-size="questionPageSize"
            :current-page="questionPage"
            @current-change="questionChangePage"
            :total="questionTotal">
          </el-pagination>
        </div>
        <div class="nothing sub-main" v-else>
          <icon-svg style="width: 240px; height: 240px; margin-bottom: 20px;" icon-class="user-wenda-nodata" />
          <p class="fs20 font-color-999">你还没有提问～</p>
        </div>
      </el-tab-pane>
      <el-tab-pane label="我的回答" name="QA" class="sub-main" v-loading="loading">
        <div v-if="flag1">
          <div class="qaBoxList listBox">
            <div class="item"
              v-for="(item,index) in qaList"
              :key="item.problemId"
              :class="{selected: item.selected === 1, edit: edit}"
              @click="selectQa(index,item.selected)"
            >
              <div class="qaBox">
                <div class="mc" v-if="edit"></div>
                <img :src="item.image" alt="" @click="toProductDetail(item)">
                <div class="infoBox">
                  <span class="question spans">问</span>
                  <h3>{{ item.problem }}</h3>
                  <div v-for="(anw,inx) of item.answers" :key="anw.answerId">
                    <span class="answer spans" v-if="inx === 0">答</span>
                    <p class="reply" v-if="inx === 0">{{ anw.answer }}</p>
                    <p class="replyTime" v-if="inx === 0">回答于：{{ anw.createTime }}</p>
                  </div>
                </div>
              </div>
              <div class="rightBox">
                <span class="time">{{ item.createTime }}</span>
              </div>
            </div>
          </div>
          <el-pagination
            class="mar-top-30"
            v-if="qaList.length"
            background
            layout="prev, pager, next, jumper"
            :page-size="qaPageSize"
            :current-page="qaPage"
            @current-change="qaChangePage"
            :total="qaTotal">
          </el-pagination>
        </div>
        <div class="nothing sub-main" v-else>
          <icon-svg style="width: 240px; height: 240px; margin-bottom: 20px;" icon-class="user-wenda-nodata" />
          <p class="fs20 font-color-999">你还没有回答～</p>
        </div>
      </el-tab-pane>
    </el-tabs>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'

import {
  getMyProblems,
  getMyAnswers,
  delMyProblem,
  delMyAnswers
} from '@/api/user/user.js'
export default {
  name: 'qalist',
  data () {
    return {
      activeName: 'question',
      questionPage: 1,
      questionPageSize: 10,
      questionTotal: 0,
      questionList: [],
      qaPage: 1,
      qaPageSize: 10,
      qaTotal: 0,
      qaList: [],
      current: null,
      flag: true,
      flag1: true,
      edit: false,
      selectAll: 0,
      loading: false
    }
  },
  computed: {
    ...mapGetters([
      'userInfo'
    ])
  },
  mounted () {
    this.getSelfProblems()
  },
  methods: {
    // 我的提问
    async getSelfProblems () {
      this.loading = true
      const response = await getMyProblems({
        page: this.questionPage,
        pageSize: this.questionPageSize
      })
      const res = response.data
      if (res.code === '200') {
        this.questionList = res.data.list
        this.questionTotal = res.data.total
        if (res.data.list.length) {
          this.flag = true
        } else {
          this.flag = false
        }
      } else {
        this.$message.warning(res.message)
      }
      this.loading = false
    },
    // 我的回答
    async getSelfAnswers () {
      this.loading = true
      const response = await getMyAnswers({
        page: this.questionPage,
        pageSize: this.questionPageSize
      })
      const res = response.data
      if (res.code === '200') {
        this.qaList = res.data.list
        this.questionTotal = res.data.total
        if (res.data.list.length) {
          this.flag1 = true
        } else {
          this.flag1 = false
        }
      } else {
        this.$message.warning(res.message)
      }
      this.loading = false
    },
    handleClick () {
      this.edit = false
      this.selectAll = 0
      if (this.activeName === 'question') {
        this.questionPage = 1
        this.getSelfProblems()
      } else {
        this.questionPage = 1
        this.getSelfAnswers()
      }
    },
    questionChangePage (val) {
      this.questionPage = val
      this.getSelfProblems()
    },
    qaChangePage (val) {
      this.qaPage = val
      this.getSelfAnswers()
    },
    seeAll (index) {
      if (this.current === index) {
        this.current = null
      } else {
        this.current = index
      }
    },
    toProductDetail (item) {
      let data = {
        shopId: item.shopId,
        productId: item.productId,
        skuId: item.skuId
      }
      this.$router.push({
        path: '/productDetail',
        query: {
          proData: JSON.stringify(data)
        }
      })
    },
    showEdit () {
      this.edit = true
    },
    changeChecked () {
      if (this.activeName === 'question') {
        this.questionList.map(item => {
          item.selected = this.selectAll
        })
      } else {
        this.qaList.map(item => {
          item.selected = this.selectAll
        })
      }
    },
    delFun () {
      let x = false
      let ids = []
      if (this.activeName === 'question') {
        this.questionList.map(item => {
          if (item.selected === 1) {
            x = true
            ids.push(item.problemId)
          }
        })
        if (x === false) {
          return this.$message.warning('请先选择需要删除的提问')
        }
        this.$confirm('此操作将删除选中的回答, 是否继续?', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          this.delProblem(ids)
        }).catch(() => {})
      } else {
        this.qaList.map(i => {
          if (i.selected === 1) {
            i.answers.map(j => {
              if (j.name === this.userInfo.name) {
                x = true
                ids.push(j.answerId)
              }
            })
          }
        })
        if (x === false) {
          return this.$message.warning('请先选择需要删除的回答')
        }
        this.$confirm('此操作将删除选中的回答, 是否继续?', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          this.delAnswer(ids)
        }).catch(() => {})
      }
    },
    saveList () {
      this.edit = false
    },
    selectQu (index, selected) {
      if (selected === 1) {
        this.questionList[index].selected = 0
      } else {
        this.questionList[index].selected = 1
      }
      this.selectAll = 1
      this.questionList.map(item => {
        if (item.selected === 0) {
          this.selectAll = 0
        }
      })
    },
    selectQa (index, selected) {
      if (selected === 1) {
        this.qaList[index].selected = 0
      } else {
        this.qaList[index].selected = 1
      }
      this.selectAll = 1
      this.qaList.map(item => {
        if (item.selected === 0) {
          this.selectAll = 0
        }
      })
    },
    // 批量删除我的提问
    async delProblem (ids) {
      const response = await delMyProblem({ ids: ids })
      const res = response.data
      if (res.code === '200') {
        this.$message.success('删除成功')
        this.edit = false
        this.selectAll = 0
        this.getSelfProblems()
      } else {
        this.$message.error(res.message)
      }
    },
    async delAnswer (ids) {
      const response = await delMyAnswers({ ids: ids })
      const res = response.data
      if (res.code === '200') {
        this.$message.success('删除成功')
        this.edit = false
        this.selectAll = 0
        this.getSelfAnswers()
      } else {
        this.$message.error(res.message)
      }
    }
  }
}
</script>

<style lang="scss" scoped>
.qaList {
  border: 1px solid #E5E5E5;
  position: relative;
  >>> .el-tabs__nav-wrap::after {
    height: 1px;
  }
  .attentionBox {
      position: absolute;
      top: 15px;
      right: 25px;
      z-index: 99;
      .searchRight {
        display: flex;
        input {
          margin-left: 16px;
          border: 1px solid #E5E5E5;
          padding-left: 10px;
          font-size: 14px;
          width: 175px;
        }
        span {
          display: block;
          height: 30px;
          line-height: 30px;
        }
        .batch {
          color: $mainGlod;
          font-size: 12px;
          width: 78px;
          text-align: center;
          height: 28px;
          line-height: 28px;
          // background: $mainColor;
          background-color: #FFF;
          border: 1px solid $mainGlod;
          cursor: pointer;
        }
        .searchBtn {
          width: 64px;
          height: 28px;
          line-height: 28px;
          background: $mainGlod;
          color: #FFFFFF;
          font-size: 14px;
          text-align: center;
          cursor: pointer;
        }
        .saveList {
          display: flex;
          align-items: center;
          span {
            margin-left: 36px;
            cursor: pointer;
            color: #333333;
            font-size: 14px;
          }
          span.save {
            width: 78px;
            height: 28px;
            background: $mainGlod;
            color: #FFFFFF;
            text-align: center;
            line-height: 28px;
          }
        }
      }
    }
  >>> .el-tabs__nav-scroll {
    padding: 0 25px;
    height: 60px;
    line-height: 60px;
    background-color: #FAFAFA;
    .el-tabs__item {
      font-size: 18px;
      color: #333333;
    }
    .is-active {
      color: $mainGlod;
    }
  }
  >>> .el-tabs__content {
    padding: 35px 40px;
  }
  .listBox {
    border-top: 1px solid #E5E5E5;
    position: relative;
    .item {
      display: flex;
      justify-content: space-between;
      padding: 25px 0;
      border-bottom: 1px solid #E5E5E5;
      // margin-bottom: 30px;
      position: relative;
      .questionBox {
        display: flex;
        width: 100%;
        img {
          width: 62px;
          height: 62px;
          margin-right: 20px;
        }
        .infoBox {
          font-size: 14px;
          color: #333333;
          width: 100%;
          div{
            // height: 30px;
            // line-height: 30px;
            display: flex;
            justify-content: space-between;
            h3{
              flex: 1;
            }
            span {
              display: block;
              text-align: right;
            }
            .time {
              font-size: 13px;
              color: #666666;
              margin-bottom: 25px;
              margin-left: 30px;
            }
          }
          ul{
            height: 30px;
            line-height: 30px;
            overflow: hidden;
            .answerList{
              height: 100%;
              display: inline-flex;
              justify-content: space-between;
              .viewDetail {
                font-size: 14px;
                color: $mainColor;
                cursor: pointer;
              }
              .noSee{
                display: none;
              }
            }
          }
          .noReply {
            height: 30px;
            line-height: 30px;
            color: #999999;
          }
          .moreShow{
            height: auto;
          }
        }
      }
      .qaBox {
        display: flex;
        // width: 700px;
        flex: 1;
        img {
          width: 62px;
          height: 62px;
          margin-right: 20px;
        }
        .infoBox {
          font-size: 14px;
          color: #333333;
          h3 {
            display: inline-block;
            margin-bottom: 20px;
          }
          .reply{
            display: inline-block;
          }
          .noReply {
            color: #999999;
          }
        }
      }
      .question{
        background-color: #C83732;
      }
      .answer{
        background-color: #C5AA7B;
      }
      .spans{
        display: inline-block;
        width: 20px;
        height: 20px;
        margin-right: 10px;
        line-height: 20px;
        text-align: center !important;
        color: #FFF;
        cursor: default;
      }
    }
  }
  .qaBoxList {
    .item {
      .qaBox {
        .infoBox {
          h3 {
            margin-bottom: 10px;
          }
          .reply {
            margin-bottom: 5px;
          }
          .replyTime {
            font-size: 13px;
            color: #999999;
          }
        }
      }
      .rightBox {
        span {
          display: block;
          text-align: right;
          margin-left: 30px;
        }
        .time {
          font-size: 13px;
          color: #666666;
          margin-bottom: 25px;
        }
        .viewDetail {
          font-size: 14px;
          color: $mainColor;
          cursor: pointer;
        }
      }
    }
  }
  // >>> .el-tabs {
  // }
  .sub-main{
    min-height: 400px;
  }
  .nothing{
    width: 100%;
    text-align: center;
    min-height: 400px;
    p{
        margin-bottom: 20px;
    }
    .toIndexBtn{
        background-color: $mainGlod;
        color: #FFFFFF;
        font-weight: normal;
        border-radius: 0;
    }
  }
  .edit:before {
    content: "";
    background: url("./../../../assets/images/user-unselected.svg");
    width: 24px;
    height: 24px;
    position: absolute;
    right: 0;
    top: 60px;
    display: block;
    background-size: contain;
    z-index: 999;
  }
  .selected:before {
    background: url("./../../../assets/images/user-selected.svg");
    background-size: contain;
  }
  .mc{
    position: absolute;
    width: 100%;
    height: 100%;
    opacity: 0;
  }
}
</style>
