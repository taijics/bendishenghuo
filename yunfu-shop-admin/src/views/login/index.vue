<template>
  <div class="login" :style="'background-image:url(' + Background + ');'">
    <!-- 登录 -->
    <div v-if="getPassword" class="loginBox">
      <div class="leftBox" />
      <div class="rightBox">
        <h2>商家登录</h2>
        <div class="tabTouch">
          <div
            v-for="(item, index) in activeList"
            :key="index"
            :class="[tabIndex != index ? 'touchOne' : 'touchTwo']"
            @click="touchTab(index)"
          >{{ item.name }}</div>
        </div>
        <!-- 账户密码登录 -->
        <div v-if="!tabIndex">
          <el-form
            ref="loginForm"
            :model="loginForm"
            :rules="loginRules"
            label-position="left"
            label-width="0px"
            class="login-form"
          >
            <el-form-item prop="username">
              <el-input
                v-model="loginForm.username"
                type="text"
                maxlength="11"
                auto-complete="off"
                placeholder="请输入账户"
                class="iptHeight"
              >
                <svg-icon slot="prefix" icon-class="user" class="el-input__icon input-icon" />
              </el-input>
            </el-form-item>
            <el-form-item prop="password">
              <el-input
                v-model="loginForm.password"
                maxlength="16"
                type="password"
                class="iptHeight"
                auto-complete="off"
                placeholder="请输入密码"
                @keyup.enter.native="handleAccountLogin"
              >
                <svg-icon slot="prefix" icon-class="password" class="el-input__icon input-icon" />
              </el-input>
            </el-form-item>
            <div class="boxBottom">
              <el-checkbox v-model="loginForm.rememberMe" style="margin: 0 0 25px 0">自动登录</el-checkbox>
              <div class="forgetPsd" @click="runForgetPassord">忘记密码</div>
            </div>

            <el-form-item style="width: 100%">
              <el-button
                :loading="loading"
                size="medium"
                type="primary"
                style="width: 100%; border-radius: 20px"
                @click.native.prevent="handleAccountLogin"
              >
                <span v-if="!loading">登 录</span>
                <span v-else>登 录 中...</span>
              </el-button>
            </el-form-item>
          </el-form>
        </div>
        <!-- 手机号登录 -->
        <div v-else>
          <el-form
            ref="anthorForm"
            :model="anthorForm"
            :rules="anthorRules"
            label-position="left"
            label-width="0px"
            class="login-form"
          >
            <el-form-item prop="username">
              <el-input
                v-model="anthorForm.username"
                type="text"
                maxlength="11"
                auto-complete="off"
                placeholder="请输入手机号码"
                class="iptHeight"
              >
                <svg-icon slot="prefix" icon-class="user" class="el-input__icon input-icon" />
              </el-input>
            </el-form-item>
            <el-form-item prop="code">
              <el-input
                v-model="anthorForm.code"
                maxlength="6"
                type="text"
                class="iptHeight"
                auto-complete="off"
                style="width: 63%"
                placeholder="请输入验证码"
                @keyup.enter.native="handlePhoneLogin"
              >
                <svg-icon slot="prefix" icon-class="password" class="el-input__icon input-icon" />
              </el-input>
              <div class="login-code">
                <el-button
                  class="codeBtn"
                  type="primary"
                  :loading="codeloading"
                  @click="getCode(anthorForm.username)"
                >
                  <span v-if="!codeloading">获取验证码</span>
                  <span v-else>{{ count }} s</span>
                </el-button>
              </div>
            </el-form-item>
            <div class="boxBottom">
              <el-checkbox v-model="loginForm.rememberMe" style="margin: 0 0 25px 0">自动登录</el-checkbox>
            </div>

            <el-form-item style="width: 100%">
              <el-button
                :loading="loading"
                size="medium"
                type="primary"
                style="width: 100%; border-radius: 20px"
                @click.native.prevent="handlePhoneLogin"
              >
                <span v-if="!loading">登 录</span>
                <span v-else>登 录 中...</span>
              </el-button>
            </el-form-item>
          </el-form>
        </div>
      </div>
    </div>
    <!-- 找回密码 -->
    <div v-else class="loginBox">
      <el-card class="box-card">
        <div slot="header" class="clearfix">
          <span style="margin-left: 25px">找回密码</span>
          <el-button
            style="float: right; padding: 3px 0"
            type="text"
            @click="getPassword=true"
          >返回登录</el-button>
          <div class="cardBox">
            <el-form
              ref="retrievePwd"
              :model="retrievePwdForm"
              :rules="retrievePwdRules"
              label-position="left"
              label-width="0px"
              class="login-form"
            >
              <el-form-item prop="username">
                <el-input
                  v-model="retrievePwdForm.username"
                  type="text"
                  maxlength="11"
                  auto-complete="off"
                  placeholder="请输入手机号码"
                  class="iptHeight"
                >
                  <svg-icon slot="prefix" icon-class="user" class="el-input__icon input-icon" />
                </el-input>
              </el-form-item>
              <el-form-item prop="code">
                <el-input
                  v-model="retrievePwdForm.code"
                  maxlength="6"
                  type="text"
                  class="iptHeight"
                  auto-complete="off"
                  style="width: 63%"
                  placeholder="请输入验证码"
                  @keyup.enter.native="forgetPwdFn"
                >
                  <svg-icon slot="prefix" icon-class="password" class="el-input__icon input-icon" />
                </el-input>
                <div class="login-code">
                  <el-button
                    class="codeBtn"
                    type="primary"
                    :loading="codeloading"
                    @click="getCode(retrievePwdForm.username)"
                  >
                    <span v-if="!codeloading">获取验证码</span>
                    <span v-else>{{ count }} s</span>
                  </el-button>
                </div>
              </el-form-item>
              <el-form-item prop="newPassword">
                <el-input
                  v-model="retrievePwdForm.newPassword"
                  type="password"
                  maxlength="11"
                  auto-complete="off"
                  placeholder="新密码"
                  class="iptHeight"
                >
                  <svg-icon slot="prefix" icon-class="password" class="el-input__icon input-icon" />
                </el-input>
              </el-form-item>
              <el-form-item prop="password">
                <el-input
                  v-model="retrievePwdForm.password"
                  type="password"
                  maxlength="11"
                  auto-complete="off"
                  placeholder="确认密码"
                  class="iptHeight"
                >
                  <svg-icon slot="prefix" icon-class="password" class="el-input__icon input-icon" />
                </el-input>
              </el-form-item>
              <el-form-item style="width: 100%">
                <el-button
                  :loading="loading"
                  size="medium"
                  type="primary"
                  style="width: 100%; border-radius: 20px"
                  @click.native.prevent="forgetPwdFn"
                >
                  <span v-if="!loading">确 认 修 改</span>
                  <span v-else>提 交 中...</span>
                </el-button>
              </el-form-item>
            </el-form>
          </div>
        </div>
      </el-card>
    </div>
    <!--  底部  -->
    <div class="login-footer">© 2019 cereshop</div>
  </div>
</template>

<script>
// import { validUsername } from '@/utils/validate'
import { adminBuild, forgetPassword } from '@/api/user'
import {
  getUserId
} from '@/utils/auth' // get token from cookie
const TIME_COUNT = 60 // 更改倒计时时间
import Background from '@/assets/images/background.jpg'
import { getCode } from '@/api/account'
const JM = require('@/utils/rsaEncrypt.js')
export default {
  name: 'Login',
  data() {
    // const validateUsername = (rule, value, callback) => {
    //   if (!validUsername(value)) {
    //     callback(new Error('Please enter the correct user name'))
    //   } else {
    //     callback()
    //   }
    // }
    // const validatePassword = (rule, value, callback) => {
    //   if (value.length < 6) {
    //     callback(new Error('The password can not be less than 6 digits'))
    //   } else {
    //     callback()
    //   }
    // }
    return {
      Background: Background,
      cookiePass: '',
      loginForm: {
        username: '',
        password: '',
        rememberMe: false
      },
      anthorForm: {
        username: '',
        code: '',
        rememberMe: false
      },
      retrievePwdForm: {
        code: '',
        newPassword: '',
        password: '',
        username: '' // 手机号
      },
      tabIndex: 0,
      activeList: [
        {
          name: '账户密码登录',
          id: 0
        },
        {
          name: '手机号码登录',
          id: 1
        }
      ],
      retrievePwdRules: {
        username: [
          { required: true, trigger: 'blur', message: '手机号码不能为空' }
        ],
        code: [
          { required: true, trigger: 'blur', message: '验证码不能为空' }
        ],
        newPassword: [
          { required: true, trigger: 'blur', message: '密码不能为空' }
        ],
        password: [
          { required: true, trigger: 'blur', message: '确认密码不能为空' }
        ]
      },
      loginRules: {
        username: [
          { required: true, trigger: 'blur', message: '用户名不能为空' }
        ],
        password: [{ required: true, trigger: 'blur', message: '密码不能为空' }]
      },
      anthorRules: {
        username: [
          { required: true, trigger: 'blur', message: '手机号不能为空' }
        ],
        code: [{ required: true, trigger: 'blur', message: '验证码不能为空' }]
      },
      loading: false,
      codeloading: false,
      count: '',
      timer: null,
      redirect: undefined,
      getPassword: true
    }
  },
  watch: {
    $route: {
      handler: function(route) {
        this.redirect = route.query && route.query.redirect
      },
      immediate: true
    }
  },
  methods: {
    // 点击tab
    touchTab(index) {
      console.log(index)
      this.tabIndex = index
    },
    // 获取验证码
    async getCode(phone) {
      console.log(phone)
      if (phone === '' || phone === undefined) {
        this.$message.error('请填写电话号码')
        return
      }
      const res = await getCode({ phone })
      if (res.code === '') {
        this.$message({
          message: '发送成功，请注意查看手机短信',
          type: 'success'
        })
        if (!this.timer) {
          this.codeloading = true
          this.count = TIME_COUNT
          this.timer = setInterval(() => {
            if (this.count > 1 && this.count <= TIME_COUNT) {
              this.count--
            } else {
              clearInterval(this.timer) // 清除定时器
              this.timer = null
              this.codeloading = false
            }
          }, 1000)
        }
      }

      // if (!this.timer) {
      //   this.codeloading = true
      //   this.count = TIME_COUNT
      //   this.show = false
      //   const res = await getCode({ phone })
      //   if (res.code === '') {
      //     this.$message({
      //       message: '发送成功，请注意查看手机短信',
      //       type: 'success'
      //     })
      //   }
      //   this.timer = setInterval(() => {
      //     if (this.count > 0 && this.count <= TIME_COUNT) {
      //       this.count--
      //     } else {
      //       this.show = true
      //       clearInterval(this.timer) // 清除定时器
      //       this.timer = null
      //       this.codeloading = false
      //     }
      //   }, 1000)
      // }
    },
    // 忘记密码
    runForgetPassord() {
      this.getPassword = false
    },
    showPwd() {
      if (this.passwordType === 'password') {
        this.passwordType = ''
      } else {
        this.passwordType = 'password'
      }
      this.$nextTick(() => {
        this.$refs.password.focus()
      })
    },
    // 账户登录
    handleAccountLogin() {
      this.$refs.loginForm.validate(valid => {
        if (valid) {
          this.loading = true
          const data = {
            username: JM.encrypt(this.loginForm.username),
            password: JM.encrypt(this.loginForm.password),
            rememberMe: this.loginForm.rememberMe
          }
          this.$store
            .dispatch('user/login', data)
            .then(() => {
              console.log(this.redirect)
              this.$router.push({ path: this.redirect || '/' })
              this.loading = false
              adminBuild({ platformUserId: getUserId() }).then(res => {
                console.log(res)
              })
            })
            .catch(() => {
              this.loading = false
            })
        } else {
          console.log('error submit!!')
          return false
        }
      })
    },
    // 手机号码
    handlePhoneLogin() {
      console.log(this.anthorForm)
      this.$refs.anthorForm.validate(valid => {
        if (valid) {
          this.loading = true
          const data = {
            username: JM.encrypt(this.anthorForm.username),
            code: JM.encrypt(this.anthorForm.code),
            rememberMe: this.anthorForm.rememberMe
          }
          this.$store
            .dispatch('user/login', data)
            .then(() => {
              this.$router.push({ path: this.redirect || '/' })
              this.loading = false
              adminBuild({ platformUserId: getUserId() }).then(res => {
                console.log(res)
              })
            })
            .catch(() => {
              this.loading = false
            })
        } else {
          console.log('error submit!!')
          return false
        }
      })
    },
    // 找回密码
    forgetPwdFn() {
      console.log(this.retrievePwdForm)
      this.$refs.retrievePwd.validate(valid => {
        if (valid) {
          this.loading = true
          const data = {
            username: JM.encrypt(this.retrievePwdForm.username),
            code: JM.encrypt(this.retrievePwdForm.code),
            password: JM.encrypt(this.retrievePwdForm.password),
            newPassword: JM.encrypt(this.retrievePwdForm.newPassword)
          }
          forgetPassword(data).then(res => {
            if (res.code === '') {
              this.loading = false
              this.$message({
                message: '修改成功',
                type: 'success'
              })
              this.getPassword = true
            }
          }).catch(() => {
            this.loading = false
          })
        } else {
          console.log('error submit!!')
          return false
        }
      })
    }
  }
}
</script>

<style rel="stylesheet/scss" lang="scss">
.login {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100%;
  background-size: cover;
}
.loginBox {
  width: 900px !important;
  height: 600px;
  display: flex;
  background: #ffffff;
  border-radius: 20px;
}
.leftBox {
  width: 325px;
  height: 250px;
  margin: 180px 0 0 30px;
  background: url("../../assets/images/home-content.png") 50% no-repeat;
  background-size: cover;
}
.rightBox {
  margin: auto;
  h2 {
    text-align: center;
  }
}
.tabTouch {
  display: flex;
  justify-content: space-around;
  align-content: center;
  width: 360px;
  margin-left: 8px;
}
.touchOne {
  color: #666666;
  padding: 20px;
}
.touchTwo {
  border-bottom: 1px solid #1890ff;
  padding: 20px;
  color: #1890ff;
}
.boxBottom {
  display: flex;
  justify-content: space-between;
  .forgetPsd {
    font-size: 14px;
    color: #1890ff;
    cursor: pointer;
  }
}
.title {
  margin: 0 auto 30px auto;
  text-align: center;
  color: #707070;
}

.login-form {
  border-radius: 6px;
  background: #ffffff;
  width: 385px;
  padding: 25px 25px 5px 25px;
  .el-input {
    height: 38px;
    input {
      height: 38px;
    }
  }
  .input-icon {
    height: 39px;
    width: 14px;
    margin-left: 2px;
  }
}
.iptHeight {
  height: 54px !important;
  input {
    height: 54px !important;
  }
  span {
    display: flex;
    align-items: center;
  }
  .input-icon {
    width: 20px;
    height: 20px;
  }
}
.login-tip {
  font-size: 13px;
  text-align: center;
  color: #bfbfbf;
}
.login-code {
  float: right;
  .codeBtn {
    height: 54px;
    display: flex;
    justify-content: center;
    align-items: center;
    width: 100px;
    background: #eeeeee;
    color: #666666;
    border: none;
  }
  img {
    vertical-align: middle;
  }
}
.box-card {
  width: 100%;
  height: 100%;
  .clearfix {
    width: 50%;
    margin: 10% auto;
  }
}
.login-footer {
  position: fixed;
  bottom: 0;
  width: 100%;
  text-align: center;
}
</style>
