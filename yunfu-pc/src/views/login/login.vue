<template>
  <div class="showTheLogin">
    <div class="loginCent">
      <nav>
        <div class="hiddenLoginBtn">
          <a class="el-icon-close" @click="hiddenLoginBtn" />
        </div>
      </nav>
      <div class="loginForm">
        <!-- <div class="loginTit" v-text="isRegistered == '1' ? '注册' : '登录'"></div> -->
        <div class="loginTitle">
          <div class="title"  v-text="isRegistered !== '1' ? '登录' : '用户注册'"></div>
          <div class="content">
            <span v-text="isRegistered === '1' ? '已有账户？' : '第一次使用cereshop商城？'"></span>
            <u @click="registered" v-text="isRegistered === '1' ? '立即登录' : '用户注册'"></u></div>
        </div>
        <div class="loginFormBox">
          <div class="inputBox">
            <el-input v-model="userName" placeholder="请输入您的手机号码">
              <template slot="prepend"><span class="icon iconfont">&#xe62f;</span></template>
            </el-input>
          </div>
          <div class="inputBox">
            <el-input
              v-model="verificationCode"
              placeholder="请输入验证码"
              @keyup.enter.native="login"
            >
              <template slot="prepend">
                <span class="icon iconfont">&#xe62e;</span>
              </template>
            </el-input>
            <span v-show="codeShow" class="codeBtn" @click="getCode">获取验证码</span>
            <span v-show="!codeShow" class="codeBtn codeCount">重新获取({{codeCountNum}}s)</span>
          </div>
          <div class="noLogin" :class="{registered: isRegistered === '1'}" >
            <el-checkbox v-show="isRegistered === '2'" v-model="isNoLogin">七天免登录</el-checkbox>
            <span ></span>
          </div>
          <el-button class="loginBtn"
            @click="login"
            v-text="isRegistered === '1' ? '注册' : '立即登录'"
            :loading="loadingLogin"
          >立即登录</el-button>
        </div>
        <div class="loginProtocol" v-if="isRegistered === '1'">
          <el-checkbox v-model="haveRead"></el-checkbox>
          <span>阅读并同意</span>
          <span @click="readAgreement">《cereshop 服务协议》</span>
        </div>
      </div>
    </div>
    <el-dialog
      title="服务协议"
      :visible.sync="dialogAgreement"
      width="50%">
      这是服务协议
    </el-dialog>
  </div>
</template>

<script>
import Cookie from 'js-cookie'
import store from '@/store/index.js'
import {
  getTheCode,
  login
} from '@/api/login.js'
import {
  getUserInfo
} from '@/api/user/user.js'
export default {
  name: 'login',
  data () {
    return {
      userName: '',
      verificationCode: '',
      isNoLogin: false,
      haveRead: false,
      codeShow: true,
      codeCountNum: '',
      dialogAgreement: false,
      isRegistered: '2',
      loadingLogin: false
    }
  },
  methods: {
    async getUserInfoData () {
      const response = await getUserInfo()
      const res = response.data
      if (res.code === '200') {
        store.commit('SET_USERINFO', res.data)
        this.userInfoData = res.data
      }
    },
    async getCode () {
      const TIME_COUNT = 120
      let reg = /^1[13456789]\d{9}$/
      if (!reg.test(this.userName)) {
        this.$message({
          message: '手机号格式错误',
          type: 'error',
          customClass: 'messageZindex',
        })
        return
      }
      const response = await getTheCode({ phone: this.userName })
      const res = response.data
      if (res.code === '200') {
        if (!this.timer) {
          this.codeCountNum = TIME_COUNT
          this.codeShow = false
          this.timer = setInterval(() => {
            if (this.codeCountNum > 0 && this.codeCountNum <= TIME_COUNT) {
              this.codeCountNum--
            } else {
              this.codeShow = true
              clearInterval(this.timer)
              this.timer = null
            }
          }, 1000)
        }
        this.$message({
          message: '验证码获取成功',
          type: 'success',
          customClass: 'messageZindex'
        })
      } else {
        this.$message({
          message: res.message,
          type: 'warning',
          customClass: 'messageZindex'
        })
      }
    },
    // 阅读协议
    readAgreement () {
      this.dialogAgreement = true
    },
    login () {
      let reg = /^1[13456789]\d{9}$/
      if (!reg.test(this.userName)) {
        this.$message({
          message: '手机号码格式错误',
          type: 'error',
          customClass: 'messageZindex'
        })
        return
      }
      if (this.verificationCode === '') {
        this.$message({
          message: '请输入验证码',
          type: 'warning',
          customClass: 'messageZindex'
        })
        return
      }
      if (this.isRegistered === '2') {
        this.getLogin()
      } else if (this.haveRead) {
        this.getLogin()
      } else {
        this.$message({
          message: '请阅读并同意服务协议',
          type: 'warning',
          customClass: 'messageZindex'
        })
      }
    },
    async getLogin () {
      this.loadingLogin = true
      const response = await login({
        phone: this.userName,
        verificationCode: this.verificationCode,
        type: this.isRegistered,
        terminal: 5
      })
      const res = response.data
      if (res.code === '200') {
        if (this.isNoLogin) {
          Cookie.set('token', res.data.token, { expires: 7 })
        } else {
          Cookie.set('token', res.data.token, { expires: 1 })
        }
        this.getUserInfoData()
        this.$message({
          message: '登录成功',
          type: 'success',
          customClass: 'messageZindex'
        })
        store.commit('SHOW_LOGIN')
        store.commit('IS_LOGIN', true)
        location.reload()
      } else {
        this.$message({
          message: res.message,
          type: 'warning',
          customClass: 'messageZindex'
        })
      }
      this.loadingLogin = false
    },
    registered () {
      this.codeShow = true
      clearInterval(this.timer)
      this.timer = null
      this.userName = ''
      this.verificationCode = ''
      if (this.isRegistered === '1') {
        this.isRegistered = '2'
      } else {
        this.isRegistered = '1'
      }
    },
    // 关闭登录
    hiddenLoginBtn () {
      store.commit('SHOW_LOGIN')
    }
  }
}
</script>

<style lang="scss" scoped>
.showTheLogin {
  // height: 100vh;
  // min-height: 768px;
  position: fixed;
  z-index: 9999;
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, 0.5);
  .loginCent {
    // background: url('../../assets/images/beijing.png') no-repeat;
    // flex-grow: 1;
    // background-size: cover;
    width: 500px;
    height: 100%;
    min-height: 768px;
    padding: 20px 50px;
    float: right;
    background-color: #ffffff;
    animation: showRight .5s;
    animation-fill-mode:forwards;
    -webkit-animation-fill-mode:forwards;
    nav{
      margin-bottom: 85px;
      .hiddenLoginBtn{
        a{
          float: right;
        }
      }
    }
    .loginForm {
      width: 500px;
      height: 100%;
      background: #ffffff;
      .loginTitle{
        font-family: Microsoft YaHei;
        color: #333333;
        .title{
          font-size: 36px;
        }
        .content{
          margin: 10px 0;
          font-size: 14px;
          u{
            color: #C5AA7B;
            cursor: pointer;
          }
        }
      }
      .loginFormBox {
        .inputBox {
          position: relative;
          .el-input{
            .iconfont{
              font-size: 32px;
              padding: 0 10px;
            }
          }
          >>> .el-input__inner {
            height: 70px;
            background: #F3F4F5;
            border-radius: 0px;
            font-size: 20px;
            padding-left: 5px;
          }
          &:nth-child(2) {
            margin: 60px 0 20px 0;
          }
          .codeBtn {
            width: 120px;
            height: 50px;
            background: $mainGlod;
            border-radius: 0;
            display: block;
            line-height: 54px;
            text-align: center;
            position: absolute;
            right: 5px;
            bottom: 10px;
            cursor: pointer;
          }
          .codeCount {
            color: #999999;
          }
        }
        .noLogin {
          color: #333333;
          font-size: 18px;
          margin:20px 0 60px 0;
          height: 30px;
          align-items: center;
          display: flex;
          justify-content: space-between;
          >>> .el-checkbox__label {
            font-size: 16px;
            color: #333333;
            font-weight: 400;
          }
          span {
            cursor: pointer;
            font-size: 16px;
            text-decoration: underline;
            color: #666666;
          }
        }
        .registered {
          justify-content: flex-end;
        }
        .loginBtn {
          width: 100%;
          height: 70px;
          background: #333333;
          border-radius: 0;
          border: 1px solid #333333;
          text-align: center;
          font-size: 20px;
          color: $mainGlod;
          cursor: pointer;
          &:hover{
            border: 1px solid $mainGlod;
          }
        }
      }
      .loginProtocol {
        padding: 0 60px;
        display: flex;
        align-items: center;
        height: 80px;
        line-height: 80px;
        border-top: 1px solid #EEEEEE;
        span {
          margin-left: 10px;
        }
        span:nth-child(3) {
          color: #426BEA;
          cursor: pointer;
        }
      }
      >>> .el-checkbox__inner {
        width: 20px;
        height: 20px;
        &:after {
          height: 10px;
          left: 7px;
          width: 4px;
        }
      }
    }
  }
  >>> .el-dialog__body {
    max-height: 500px;
    min-height: 300px;
    overflow: auto;
  }
}
.hiddenLogin {
  display: none;
}
@keyframes showRight {
  from {
    width: 560px;
    opacity: 0;
  }
  to {
    width: 600px;
    opacity: 1;
    display: block;
  }
}
</style>
