<template>
  <div class="container">
    <el-container>
      <el-header>
        <el-row>解绑手机</el-row>
      </el-header>
      <el-main>
        <el-row>
          <el-col :span="24">
            <el-steps :space="450" :active="active" align-center>
              <el-step title="身份验证"></el-step>
              <el-step title="完成"></el-step>
            </el-steps>
          </el-col>
        </el-row>
        <div v-if="active == 0">
          <el-row class="mar-top-30">
            <el-col :span="8" :offset="9">
              <span>已绑定的手机号码：{{ phone }}</span>
            </el-col>
          </el-row>
          <el-row class="mar-top-30">
            <el-col class="flex-row-plus" :span="5" :offset="8">
              <el-input class="codeipt" v-model="code" placeholder="验证码"></el-input>
            </el-col>
            <el-col class="flex-row-plus" :span="3">
              <el-button
                v-if="isCodeShow"
                class="codebut"
                type="primary"
                @click="getCode"
                >{{ codeText }}</el-button
              >
              <el-button v-else class="codebut">{{
                codeText
              }}</el-button>
            </el-col>
          </el-row>
          <el-row class="mar-top-30">
            <el-col class="flex-row-plus" :span="4" :offset="10">
              <el-button class="submitBut" @click="relievePhone"
                >提交</el-button
              >
            </el-col>
          </el-row>
        </div>
        <div v-if="active == 1" style="margin:70px 0">
          <el-row>
            <el-col :span="8" :offset="8" style="text-align:center;margin-bottom:20px;">
              <img class="finishImg" src="../../../../static/image/wancheng@2x.png" />
            </el-col>
          </el-row>
          <el-row>
            <el-col :span="8" :offset="8" style="text-align:center;">
              <span>恭喜您，已成功解绑手机！</span>
            </el-col>
          </el-row>
        </div>
      </el-main>
      <el-footer class="mar-top-50">
        <el-row class="flex-column-plus mar-20-30">
          <span class="fs8">安全服务提示</span>
          <span class="mar-top-20 fs7 font-color-9A9"
            >•
            绑定手机可提高帐号安全性，您也可以使用已绑定手机快速找回支付密码等</span
          >
          <span class="mar-top-10 fs7 font-color-9A9"
            >• 一个手机号只能绑定一个帐号</span
          >
        </el-row>
      </el-footer>
    </el-container>
  </div>
</template>

<script>
import {mapGetters} from 'vuex'

import {
  getTheCode
} from '@/api/login.js'
import {
  freedPhone
} from '@/api/user/user.js'
export default {
  data () {
    return {
      active: 0,
      iphoneNum: '',
      code: '',
      codeText: '获取验证码',
      time: 60,
      isCodeShow: true,
      verifyIphone: '',
      phone: ''
    }
  },
  computed: {
    ...mapGetters([
      'userInfo' // 用户信息
    ])
  },
  created () {
    this.verifyIphone = this.userInfo.phone
    this.phone = this.verifyIphone.substr(0, 3) + '****' + this.verifyIphone.substr(7, this.verifyIphone.split('').length)
  },
  methods: {
    // 获取验证码
    async getCode () {
      const response = await getTheCode({ phone: this.verifyIphone })
      const res = response.data
      if (res.code === '200') {
        this.$message({
          message: '验证码获取成功',
          type: 'success'
        })
        this.timer()
      }
    },
    // 解绑手机号
    async relievePhone () {
      const response = await freedPhone({
        phone: this.verifyIphone,
        verificationCode: this.code
      })
      const res = response.data
      if (res.code === '200') {
        this.active = 1
      }
    },
    timer () {
      if (this.time > 0) {
        this.time--
        this.codeText = this.time + 's'
        setTimeout(this.timer, 1000)
        this.isCodeShow = false
      } else {
        this.time = 0
        this.codeText = '获取验证码'
        this.isCodeShow = true
      }
    }
  }
}
</script>
<style lang="scss" scoped>
.container {
  width: 100%;
  height: 100%;
  display: flex;
  flex-direction: column;
  background-color: #ffffff;
  border: 1px solid #E5E5E5;
  padding: 30px;
  box-sizing: border-box;
  .el-header{
    padding: 0;
  }
  .submitBut {
    width: 160px;
    background-color: #FF7800;
    border-radius: 0;
    color: #FFFFFF;
  }
  .codebut {
    width: 100%;
    text-align: center;
    background-color: #DDDDDD;
    border-radius: 0;
    padding: 13px 20px;
    color: #333333;
  }
  >>>.codeipt{
    .el-input__inner{
      border-radius: 0;
    }
  }
  .bottom-box {
    background-color: #eeeeee;
  }
  .finishImg {
    width: 66px;
    height: 66px;
    border-radius: 50%;
  }
  >>>.el-footer{
      background-color: #eee;
      height: auto !important;
  }
  .el-steps {
    max-width: 900px;
    margin: 0 auto;
    /deep/ {
      .el-step__description {
        padding-top: 12px;
      }
      .el-step__icon {
        width: 36px;
        height: 36px;
      }
      .el-step__title {
        font-size: 16px;
        line-height: 1em;
        margin-top: 14px;
      }
      .el-step__line {
        height: 6px;
        background-color: #ddd;
        top: 15px;
        left: 0;
        .el-step__line-inner{
          border-style: none;
        }
      }
      .el-step:first-of-type .el-step__line {
        width: 50%;
        left: auto;
        right: 0;
      }
      .el-step:last-of-type .el-step__line {
        display: block;
        width: 50%;
      }
      .is-finish,
      .is-process {
        color: #666;
        .el-step__line {
          background-color: #FF7800;
        }
        .el-step__icon {
          color: #fff;
          background-color: #FF7800;
          border-color: #FF7800;
        }
      }

      .is-wait {
        color: #dddddd;
        .el-step__icon {
          color: #fff;
          background-color: #dddddd;
          border-color: #dddddd;
        }
      }
    }
  }
}
</style>
