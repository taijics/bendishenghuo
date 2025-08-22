<template>
  <div class="productAnswer">
    <div class="answerTop">
      <p>有什么疑问，问问买过此商品的同学吧～</p>
      <span @click="anonymousFn">我要提问</span>
    </div>
    <div class="questionList" v-if="problemList.length">
      <div class="itemBox" v-for="(item, index) of problemList" :key="item.problemId">
        <div class="itemTit">
          <h3><span>问</span>{{ item.problem }}</h3>
          <span class="nameOrTime">{{ item.name }} {{ item.createTime }}</span>
        </div>
        <div class="replyListBox">
          <ul :class="{moreShow: current === index}" v-if="item.answers.length">
            <li v-for="(reply, index) of item.answers" :key="reply.answerId">
              <i v-if="index === 0">答</i>
              <div class="replyInfo">
                <span class="info">{{ reply.answer }}</span>
                <span class="time">{{ reply.name }} {{ reply.createTime}}</span>
              </div>
            </li>
          </ul>
          <div v-else style="height:30px;margin-top:15px;font-size:14px;color:#999999;">
            <span>暂无回答</span>
          </div>
          <div class="btnBox">
            <div class="moreBtn"
              v-if="item.answers.length>1"
              @click="clickMoreList(index)">
              {{ current === index ? '收起回答' : '显示更多答复' }}
              <i class="iconfont" v-html="current === index ? '&#xe660;' : '&#xe695;'"></i>
            </div>
            <div v-else></div>
            <div
            v-if="item.ifAnswer"
            class="replyBtn" @click="toAnswer(item.problem,item.problemId)">我要回答</div>
          </div>
        </div>
      </div>
      <el-pagination
        style="margin-bottom:20px;"
        background
        layout="prev, pager, next, jumper"
        :page-size="pageSize"
        :current-page="page"
        @current-change="changePage"
        :total="total">
      </el-pagination>
    </div>
    <el-dialog
      title="提问"
      :visible.sync="qaDialog"
      width="600px"
      :center="true"
      :before-close="qaDialogClose">
      <div class="qaDialogBox">
        <p class="qaInfo">您的问题将推送给已购用户，TA们会帮您解答哦～</p>
        <el-input
          type="textarea"
          :rows="4"
          placeholder="请输入内容"
          resize="none"
          v-model="putQuestion">
        </el-input>
        <el-checkbox v-model="anonymous">匿名提问</el-checkbox>
      </div>
      <span slot="footer" class="dialog-footer">
        <el-button @click="qaDialog = false">取 消</el-button>
        <el-button class="submit" @click="addProblem">发 布</el-button>
      </span>
    </el-dialog>
    <el-dialog
      title="回答"
      :visible.sync="replyDialog"
      width="600px"
      :center="true"
      :before-close="replyDialogClose">
      <div class="qaDialogBox">
        <p class="qaInfo">问：{{questionTitle}}</p>
        <el-input
          type="textarea"
          :rows="4"
          placeholder="请输入内容"
          resize="none"
          v-model="putReply">
        </el-input>
        <el-checkbox v-model="anonymousReply">匿名回答</el-checkbox>
      </div>
      <span slot="footer" class="dialog-footer">
        <el-button @click="replyDialog = false">取 消</el-button>
        <el-button class="submit" @click="addAnswer">发 布</el-button>
      </span>
    </el-dialog>
  </div>
</template>

<script>
import {
  getProductProblem,
  askProductProblem,
  answerProductProblem
} from '@/api/product.js'
export default {
  name: 'productAnswer',
  data () {
    return {
      qaDialog: false,
      replyDialog: false,
      putQuestion: '',
      putReply: '',
      anonymous: false,
      anonymousReply: false,
      current: null,
      problemList: [],
      questionTitle: '',
      problemId: null,
      page: 1,
      pageSize: 10,
      total: 0,
      currentPro: JSON.parse(this.$route.query.proData)
    }
  },
  mounted () {
    this.getProblems()
  },
  methods: {
    // 查询商品问答
    async getProblems () {
      const response = await getProductProblem({
        productId: this.currentPro.productId,
        page: this.page,
        pageSize: this.pageSize
      })
      const res = response.data
      if (res.code === '200') {
        this.problemList = res.data.list
        this.total = res.data.total
      } else {
        this.$message.warning(res.message)
      }
    },
    // 提问请求
    async addProblem () {
      if (this.putQuestion === '') {
        this.$message.warning('请输入问题内容')
        return
      }
      const response = await askProductProblem({
        ifAnonymous: this.anonymous ? 1 : 0,
        problem: this.putQuestion,
        productId: this.currentPro.productId
      })
      const res = response.data
      if (res.code === '200') {
        this.$message.success('提问成功')
        this.putQuestion = ''
        this.anonymous = false
        this.qaDialog = false
        this.getProblems()
      }
    },
    // 回答请求
    async addAnswer () {
      if (this.putReply === '') {
        this.$message.warning('请输入回答内容')
        return
      }
      const response = await answerProductProblem({
        ifAnonymous: this.anonymousReply ? 1 : 0,
        answer: this.putReply,
        productId: this.currentPro.productId,
        problemId: this.problemId
      })
      const res = response.data
      if (res.code === '200') {
        this.$message.success('回答成功')
        this.putReply = ''
        this.anonymousReply = false
        this.replyDialog = false
        this.getProblems()
      }
    },
    // 提问
    anonymousFn () {
      this.qaDialog = true
    },
    // 取消提问
    qaDialogClose () {
      this.qaDialog = false
    },
    // 回答
    toAnswer (title, id) {
      this.questionTitle = title
      this.problemId = id
      this.replyDialog = true
    },
    // 取消回答
    replyDialogClose () {
      this.replyDialog = false
    },
    // 展开更多回复
    clickMoreList (index) {
      if (this.current === index) {
        this.current = null
      } else {
        this.current = index
      }
    },
    // 翻页
    changePage (val) {
      this.page = val
      this.getProblems()
    }
  }
}
</script>

<style lang="scss" scoped>
.productAnswer {
  .answerTop {
    height: 110px;
    background: #F9F9F9;
    text-align: center;
    padding: 20px;
    box-sizing: border-box;
    p {
      color: #333333;
      font-size: 14px;
      margin: 0 0 25px 0;
    }
    span {
      width: 94px;
      height: 28px;
      line-height: 28px;
      color: #C83732;
      border: 1px solid #C83732;
      font-size: 14px;
      display: block;
      margin: 0 auto;
      cursor: pointer;
    }
  }
  >>> .el-dialog__body {
    .qaDialogBox {
      .qaInfo {
        color: #999999;
        font-size: 14px;
        margin-bottom: 20px;
      }
    }
    .el-textarea__inner {
      padding: 15px;
    }
    .el-checkbox {
      margin-top: 10px;
    }
  }
  >>> .el-dialog__footer {
    padding-top: 20px;
    .el-button {
      width: 200px;
      height: 50px;
      color: #333;
      background-color: #F3F4F5;
      font-size: 16px;
      border-radius: 0;
    }
    .submit{
      color: #FFEBC4 !important;
      background-color: #333 !important;
    }
  }
  .questionList {
    margin-top: 30px;
    padding-right: 20px;
    .itemBox {
      padding-bottom: 20px;
      border-bottom: 1px solid #E5E5E5;
      margin-bottom: 30px;
      .itemTit {
        display: flex;
        justify-content: space-between;
        h3 {
          flex: 1;
          span {
            width: 18px;
            height: 18px;
            text-align: center;
            line-height: 18px;
            background-color: #C83732;
            display: inline-block;
            color: #FFFFFF;
            font-size: 12px;
            margin-right: 10px;
          }
          color: #333333;
          font-size: 14px;
        }
        .nameOrTime {
          font-size: 14px;
          color: #999999;
          margin-left: 30px;
        }
      }
      .replyListBox {
        ul {
          margin-top: 15px;
          height: 30px;
          overflow: hidden;
          li {
            display: flex;
            margin-bottom: 20px;
            position: relative;
            i {
              position: absolute;
              left: 0;
              width: 18px;
              height: 18px;
              background-color: #C5AA7B;
              border-radius: 4px;
              display: inline-block;
              color: #FFFFFF;
              line-height: 18px;
              text-align: center;
              font-size: 12px;
              font-style: normal;
            }
            .replyInfo {
              display: flex;
              flex: 1;
              justify-content: space-between;
              border-bottom: 1px solid #E5E5E5;
              margin-left: 28px;
              padding-bottom: 20px;
              .info {
                color: #333333;
                font-size: 14px;
                position: relative;
                flex: 1;
              }
              .time {
                color: #999999;
                font-size: 14px;
                margin-left: 30px;
              }
            }
          }
          li:last-child {
            margin-bottom: 15px;
          }
        }
        .moreShow {
          height: auto;
        }
        .btnBox {
          display: flex;
          justify-content: space-between;
          .replyBtn {
            color: $mainGlod;
            font-size: 12px;
            cursor: pointer;
            border: 1px solid $mainGlod;
            padding: 4px 10px;
          }
          .moreBtn {
            color: $mainGlod;
            font-size: 12px;
            margin-left: 28px;
            cursor: pointer;
            i {
              font-size: 12px;
            }
          }
        }
      }
    }
  }
}
</style>
