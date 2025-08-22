<template>
  <div class="container">
    <el-container>
      <el-header>
        <el-row class="title">更换手机号码</el-row>
      </el-header>
      <el-main>
        <el-row>
          <el-col :span="18" :offset="3">
            <ShopStep :data="stepsArr" :active="active" />
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
              <el-input class="codeipt" v-model="verifyCode" placeholder="验证码"></el-input>
            </el-col>
            <el-col class="flex-row-plus" :span="3">
              <el-button
                v-if="isoldCodeShow"
                class="codebut"
                @click="getoldCode"
                >{{ oldcodeText }}</el-button
              >
              <el-button v-else class="codebut codeDisable">{{
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
              <el-input class="codeipt" type="number" v-model="iphoneNum" placeholder="输入新号码"></el-input>
            </el-col>
          </el-row>
          <el-row class="mar-top-30">
            <el-col class="flex-row-plus" :span="5" :offset="8">
              <el-input class="codeipt" type="number" v-model="code" placeholder="验证码"></el-input>
            </el-col>
            <el-col class="flex-row-plus" :span="3">
              <el-button
                v-if="isCodeShow"
                class="codebut"
                @click="getCode(1)"
                >{{ codeText }}</el-button
              >
              <el-button v-else class="codebut codeDisable" type="primary">{{
                codeText
              }}</el-button>
            </el-col>
          </el-row>
          <el-row class="mar-top-30">
            <el-col class="flex-row-plus" :span="4" :offset="10">
              <el-button class="submitBut" @click="updatePhone" type="primary" v-throttle
                >提交</el-button
              >
            </el-col>
          </el-row>
        </div>
        <div v-if="active == 2" style="margin:70px 0">
          <el-row>
            <el-col :span="8" :offset="8" style="text-align:center;margin-bottom:20px;">
              <icon-svg style="font-size: 120px; margin-bottom: 20px;" icon-class="success" />
            </el-col>
          </el-row>
          <el-row>
            <el-col :span="8" :offset="8" style="text-align:center;">
              <span>恭喜您，更换手机已完成！</span>
            </el-col>
          </el-row>
        </div>
      </el-main>
      <el-footer class="mar-top-50">
        <el-row class="flex-column-plus mar-20-30">
          <span class="fs8" style="color:#C83732;font-size:16px;">安全服务提示</span>
          <span class="mar-top-20 fs7 font-color-9A9"
            >•
            绑定手机可提高帐号安全性</span
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

import ShopStep from '@/components/base/steps.vue'

import {
  getTheCode
} from '@/api/login.js'
import {
  changePhone,
  checkUser
} from '@/api/user/user.js'

export default {
  components: {ShopStep},
  data () {
    return {
      stepsArr: [
        {
          value: 0,
          label: '身份验证'
        },
        {
          value: 1,
          label: '更换手机号码'
        },
        {
          value: 2,
          label: '完成'
        }
      ],
      active: 0,
      iphoneNum: '',
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
    if (this.userInfo.phone) {
      this.verifyIphone = this.userInfo.phone
    }
    this.phone = this.verifyIphone.substr(0, 3) + '****' + this.verifyIphone.substr(7, this.verifyIphone.split('').length)
  },
  methods: {
    // 获取更换手机号的验证码
    async getCode () {
      if (!(/^(13[0-9]|14[579]|15[0-3,5-9]|16[6]|17[0135678]|18[0-9]|19[89])\d{8}$/.test(this.iphoneNum))) {
        this.$message.warning('手机号格式错误请重新输入')
        return
      }
      const response = await getTheCode({ phone: this.verifyIphone })
      const res = response.data
      if (res.code === '200') {
        this.$message.success('验证码获取成功')
        this.timer()
      } else {
        this.$message.warning(res.message)
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
    // 获取身份验证的验证码
    async getoldCode () {
      if (!(/^(13[0-9]|14[579]|15[0-3,5-9]|16[6]|17[0135678]|18[0-9]|19[89])\d{8}$/.test(this.verifyIphone))) {
        this.$message.warning('手机号格式错误请重新输入')
        return
      }
      const response = await getTheCode({ phone: this.verifyIphone })
      const res = response.data
      if (res.code === '200') {
        this.$message({
          message: '验证码获取成功',
          type: 'success'
        })
        this.oldtimer()
      } else {
        this.$message({
            message: res.message,
            type: 'warning'
        })
      }
    },
    // 更改手机号
    async updatePhone () {
      if (!(/^(13[0-9]|14[579]|15[0-3,5-9]|16[6]|17[0135678]|18[0-9]|19[89])\d{8}$/.test(this.iphoneNum))) {
        this.$message.warning('手机号格式错误请重新输入')
        return
      }
      if (this.code === '') {
        this.$message.warning('验证码不能为空')
        return
      }
      const response = await changePhone({
        phone: this.iphoneNum,
        verificationCode: this.code
      })
      const res = response.data
      if (res.code === '200') {
        this.active = 2
      } else {
        this.$message.warning(res.message)
      }
    },
    // 获取身份验证的验证码倒计时
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
    // 获取更换手机号的验证码倒计时
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
  .el-header{
    padding: 0;
    .title{
      padding: 0 30px;
      line-height: 50px;
      background-color: #FAFAFA;
    }
  }
  .submitBut {
    width: 400px;
    color: $mainGlod;
    background-color: #333;
    border-radius: 0;
  }
  .codebut {
    padding: 13px 20px;
    width: 100%;
    text-align: center;
    color: #FFF;
    background-color: $mainGlod;
    border-radius: 0;
  }
  .codeDisable{
    color: #999;
    cursor: auto;

  }
  >>>.codeipt{
    .el-input__inner{
      border-radius: 0;
    }
  }
  .bottom-box {
    background-color: #eeeeee;
  }
  >>>.el-footer{
      background-color: #eee;
      height: auto !important;
  }
}
</style>
