<template>
  <div class="container">
    <el-container>
      <el-header>
        <el-row>更换密码</el-row>
      </el-header>
      <el-main>
        <el-row>
          <el-col :span="18" :offset="3">
            <el-steps :space="250" :active="active" align-center>
              <el-step title="身份验证"></el-step>
              <el-step title="修改密码"></el-step>
              <el-step title="完成"></el-step>
            </el-steps>
          </el-col>
        </el-row>
        <div v-if="active == 0">
          <el-row class="mar-top-30">
            <el-col :span="8" :offset="9">
              <span>已绑定的手机号码：{{phone}}</span>
            </el-col>
          </el-row>
          <el-row class="mar-top-30">
            <el-col class="flex-row-plus" :span="5" :offset="8">
              <el-input class="codeipt" v-model="verifyCode" placeholder="验证码"></el-input>
            </el-col>
            <el-col class="flex-row-plus" :span="3">
              <el-button
                v-if="isoldCodeShow"
                class="codebut"
                @click="getoldCode"
                >{{ oldcodeText }}</el-button
              >
              <el-button v-else class="codebut">{{
                oldcodeText
              }}</el-button>
            </el-col>
          </el-row>
          <el-row class="mar-top-30">
            <el-col class="flex-row-plus" :span="4" :offset="10">
              <el-button class="submitBut" @click="checkUser" type="primary"
                >下一步</el-button
              >
            </el-col>
          </el-row>
        </div>
        <div v-if="active == 1">
          <el-row class="mar-top-30">
            <el-col :span="8" :offset="8">
              <el-input class="codeipt" v-model="pwd" placeholder="新6位数密码"></el-input>
            </el-col>
          </el-row>
          <el-row class="mar-top-30">
            <el-col class="flex-row-plus" :span="8" :offset="8">
              <el-input class="codeipt" v-model="confirmPwd" placeholder="确认新6位数密码"></el-input>
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
              <el-button class="submitBut" @click="updatePassword" type="primary"
                >提交</el-button
              >
            </el-col>
          </el-row>
        </div>
        <div v-if="active == 2" style="margin:70px 0">
          <el-row>
            <el-col :span="8" :offset="8" style="text-align:center;margin-bottom:20px;">
              <img class="finishImg" src="../../../../static/image/wancheng@2x.png" />
            </el-col>
          </el-row>
          <el-row>
            <el-col :span="8" :offset="8" style="text-align:center;">
              <span>恭喜您，修改密码已完成！</span>
            </el-col>
          </el-row>
        </div>
      </el-main>
      <el-footer class="mar-top-50">
        <el-row class="flex-column-plus mar-20-30">
          <span class="fs8">安全服务提示</span>
          <span class="mar-top-20 fs7 font-color-9A9">• 为保障您的帐号安全，变更重要信息需要身份验证</span>
          <span class="mar-top-10 fs7 font-color-9A9">• 绑定过程中有疑问请联系在线客服</span>
          <span class="mar-top-10 fs7 font-color-9A9">• 更改绑定手机，如原手机号停用无法获取</span>
        </el-row>
      </el-footer>
    </el-container>
  </div>
</template>
<script>
import {
  getTheCode
} from '@/api/login.js'
import {
  updateLoginPWD,
  checkUser
} from '@/api/user.js'
import {mapGetters} from 'vuex'
export default {
  data () {
    return {
      active: 0,
      pwd: '',
      confirmPwd: '',
      code: '',
      codeText: '获取验证码',
      time: 60,
      isCodeShow: true,
      isoldCodeShow: true,
      verifyCode: '',
      oldcodeText: '获取验证码',
      oldtime: 60,
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
    // 获取修改密码的验证码
    async getCode () {
      const response = await getTheCode({ phone: this.verifyIphone })
      const res = response.data
      if (res.code === '200') {
        this.$message.success('验证码获取成功')
        this.timer()
      }
    },
    // 身份验证
    async checkUser () {
      if (this.verifyCode === '') {
        this.$message.warning('验证码不能为空')
        return
      }
      const response = await checkUser({
        phone: this.verifyIphone,
        verificationCode: this.verifyCode
      })
      const res = response.data
      if (res.code === '200') {
        this.active = 1
      } else {
        this.$message(res.message)
      }
    },
    // 修改密码
    async updatePassword () {
      if (this.pwd !== this.confirmPwd) {
        this.$message.warning('两次密码不一致')
        return
      }
      const response = await updateLoginPWD({
        newPassword: this.confirmPwd,
        verificationCode: this.code
      })
      const res = response.data
      if (res.code === '200') {
        this.active = 2
      }
    },
    // 获取身份验证的验证码
    async getoldCode () {
      const response = await getTheCode({ phone: this.verifyIphone })
      const res = response.data
      if (res.code === '200') {
        this.$message.success('验证码获取成功')
        this.oldtimer()
      }
    },
    // 修改密码的验证码倒计时
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
    },
    // 身份验证的验证码倒计时
    oldtimer () {
      if (this.oldtime > 0) {
        this.oldtime--
        this.oldcodeText = this.oldtime + 's'
        setTimeout(this.oldtimer, 1000)
        this.isoldCodeShow = false
      } else {
        this.oldtime = 0
        this.oldcodeText = '获取验证码'
        this.isoldCodeShow = true
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
  box-sizing: border-box;
  border: 1px solid #E5E5E5;
  padding: 30px;
  .el-header{
    padding: 0;
  }
  .submitBut {
    width: 160px;
    background-color: #FF7800;
    border-radius: 0;
  }
  .codebut {
    padding: 13px 20px;
    width: 100%;
    text-align: center;
    background-color: #DDDDDD;
    color: #333333;
    border-radius: 0;
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
