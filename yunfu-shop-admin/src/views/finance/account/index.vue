<template>
  <div class="accont_Page">
    <!-- 卡片栏 -->
    <el-card class="box-card">
      <div v-if="show">
        <div slot="header" class>
          <span>绑定账户</span>
        </div>
        <div class="text_item">
          <!--银行卡图片 -->
          <div class="leftImg">
            <img :src="defaultBank" alt>
          </div>
          <!-- 银行图片 -->
          <div class="bankName">
            <div class="bankNumber">
              <div class="bankNumber_1" v-html="err" />
              <div v-if="Number(privacyTime)===0" class="bankNumber_2">{{ hidden(bankArr.cardNumber, 3, 4) }}</div>
              <div v-else class="bankNumber_2">{{ bankArr.cardNumber }}</div>
            </div>
            <div class="bankNumber">
              <div class="bankNumber_1">持卡人：</div>
              <div class="bankNumber_1">{{ bankArr.cardName }}</div>
            </div>
          </div>
          <!-- 按钮 -->
          <div class="btnList">
            <div class="cutBank" @click="delBank(2)">解绑</div>
            <div class="changeBank" @click="replaceCard(3)">更换</div>
          </div>
        </div>
      </div>
      <div v-else>
        <div slot="header" class>
          <span>绑定账户</span>
        </div>
        <div class="text_item">
          <!--银行卡图片 -->
          <div class="leftImg">
            <img
              :src="defaultBank"
              alt
            >
          </div>
          <!-- 银行图片 -->
          <div class="bankName">
            <div class="bankNumber">
              <div class="bankNumber_2">尚未绑定账户</div>
            </div>
          </div>
          <!-- 按钮 -->
          <div class="btnList">
            <div class="changeBank" @click="bindCard(1)">立即绑定</div>
          </div>
        </div>
      </div>
    </el-card>

    <!-- 弹框开始 -->
    <el-dialog
      :title="dialogData.title"
      :visible.sync="dialogData.isVisible"
      width="500px"
      :close-on-click-modal="false"
      center
      @close="closeDialog"
    >
      <!-- 绑定银行卡 -->
      <el-form
        v-if="dialogData.type===1"
        ref="form"
        :model="form"
        :rules="rules"
        label-width="120px"
      >
        <el-form-item label="持卡人姓名" prop="cardName">
          <el-input v-model="form.cardName" maxlength="20" @onblur="btKeyUp" />
        </el-form-item>
        <el-form-item label="卡号" prop="cardNumber">
          <el-input v-model="form.cardNumber" maxlength="19" oninput="value=value.replace(/[^\d]/g,'')" />
        </el-form-item>
        <el-form-item label="银行" prop="bank">
          <el-select v-model="form.bank" filterable placeholder="请选择所属银行">
            <el-option
              v-for="item in options"
              :key="item.dictName"
              :label="item.dictName"
              :value="item.dictId"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="注册手机号" prop="phone">
          <el-input v-model="form.phone" oninput="value=value.replace(/[^\d]/g,'')" maxlength="11" style="width: 120px;" />
          <el-button
            class="sendCode"
            type="primary"
            :loading="codeloading"
            @click="sendCode(form.phone)"
          >
            <span v-if="!codeloading">获取验证码</span>
            <span v-else>{{ count }} s</span>
          </el-button>
        </el-form-item>
        <el-form-item label="验证码" prop="code">
          <el-input v-model="form.code" style="width: 120px;" oninput="value=value.replace(/[^\d]/g,'')" maxlength="6" />
        </el-form-item>
      </el-form>
      <!-- 解绑 -->
      <el-form
        v-if="dialogData.type===2"
        ref="unbind"
        :model="unbinds"
        :rules="rules"
        label-width="120px"
      >
        <el-form-item label="注册手机号" prop="phone">
          <el-input v-model="unbinds.phone" maxlength="11" style="width: 120px;" />
          <el-button
            class="sendCode"
            type="primary"
            :loading="codeloading"
            @click="sendCode(unbinds.phone)"
          >
            <span v-if="!codeloading">获取验证码</span>
            <span v-else>{{ count }} s</span>
          </el-button>
        </el-form-item>
        <el-form-item label="验证码" prop="code">
          <el-input v-model="unbinds.code" style="width: 120px;" />
        </el-form-item>
      </el-form>
      <!-- 更换银行卡 -->
      <el-form
        v-if="dialogData.type===3"
        ref="card"
        :model="card"
        :rules="rules"
        label-width="120px"
      >
        <!-- <p class="card">原绑定信息</p>
        <el-form-item label="原持卡人姓名" prop="cardName">
          <el-input v-model="card.cardName" />
        </el-form-item>
        <el-form-item label="原银行卡号" prop="oldCardNumber">
          <el-input v-model="card.oldCardNumber" />
        </el-form-item>
        <p class="card">新绑定信息</p>-->
        <el-form-item label="持卡人姓名" prop="cardName">
          <el-input v-model="card.cardName" maxlength="20" @onblur="btKeyUp" />
        </el-form-item>
        <el-form-item label="卡号" prop="cardNumber">
          <el-input v-if="cardNumberShow" :value="hidden(card.cardNumber, 3, 4)" @focus="focusCardNunberInput" oninput="value=value.replace(/[^\d]/g,'')" maxlength="19" />
          <el-input v-else v-model="card.cardNumber" maxlength="19" oninput="value=value.replace(/[^\d]/g,'')" />
        </el-form-item>
        <el-form-item label="银行" prop="bank">
          <el-select v-model="card.bank" filterable placeholder="请选择所属银行">
            <el-option
              v-for="item in options"
              :key="item.dictName"
              :label="item.dictName"
              :value="item.dictId"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="注册手机号" prop="phone">
          <el-input v-if="phoneShow" :value="hidden(card.phone, 3, 4)" @focus="focusPhoneInput" oninput="value=value.replace(/[^\d]/g,'')" maxlength="11" style="width: 120px;" />
          <el-input v-else v-model="card.phone" oninput="value=value.replace(/[^\d]/g,'')" maxlength="11" style="width: 120px;" />
          <el-button
            class="sendCode"
            type="primary"
            :loading="codeloading"
            @click="sendCode(card.phone)"
          >
            <span v-if="!codeloading">获取验证码</span>
            <span v-else>{{ count }} s</span>
          </el-button>
        </el-form-item>
        <el-form-item label="验证码" prop="code">
          <el-input v-model="card.code" oninput="value=value.replace(/[^\d]/g,'')" maxlength="6" style="width: 120px;" />
        </el-form-item>
      </el-form>
      <p slot="footer" class="dialog-footer">
        <el-button
          type="primary"
          @click="confirm(formList[dialogData.type])"
        >{{ dialogData.confirm || '确定' }}</el-button>
        <el-button @click="dialogData.isVisible = false">取 消</el-button>
      </p>
    </el-dialog>
  </div>
</template>

<script>
import {
  accountGetById,
  getSelect,
  bankDelete,
  bankUpdate,
  bankAdd,
  getCode
} from '@/api/account'
import defaultBank from '@/assets/images/bank/default_bank_3x.png'
const TIME_COUNT = 60 // 更改倒计时时间
export default {
  data() {
    return {
      err: '账&#12288;号：',
      bankArr: '',
      show: true,
      codeloading: false,
      dialogData: {},
      count: '',
      mobile: '13444444444',
      options: [],
      formList: {
        1: 'form',
        2: 'unbind',
        3: 'card'
      },
      // 绑定银行卡
      form: {
        cardName: '',
        cardNumber: '',
        bank: '',
        phone: '',
        code: ''
      },
      // 解绑
      unbinds: {
        phone: '',
        code: ''
      },
      // 更换
      card: {
        cardName: '',
        cardNumber: '',
        bank: '',
        phone: '',
        code: ''
      },
      rules: {
        cardName: [
          { required: true, message: '请输入持卡人姓名', trigger: 'blur' }
        ],
        cardNumber: [
          { required: true, message: '请输入银行卡号', trigger: 'blur' }
        ],
        phone: [{ required: true, message: '请输入手机号', trigger: 'blur' }],
        code: [{ required: true, message: '请输入验证码', trigger: 'blur' }],
        bank: [{ required: true, message: '请输入选择银行', trigger: 'blur' }],
        oldCardNumber: [
          { required: true, message: '请输入原银行卡号', trigger: 'blur' }
        ]
      },
      privacyTime: 0,
      cardNumberShow: true, // 是否显示卡号脱敏
      phoneShow: true, // 是否显示手机号脱敏
      oldCardNumber: '',
      oldPhone: '',
      defaultBank: defaultBank
    }
  },
  created() {
    this.bankDetails()
    this.bankName()
    this.privacyTime = localStorage.getItem('privacyTime')
    console.log(this.privacyTime)
  },
  methods: {
    closeDialog(){
      this.card.cardNumber = this.card.cardNumber ? this.card.cardNumber : this.oldCardNumber
      this.card.phone = this.card.phone ? this.card.phone : this.oldPhone
    },
    focusPhoneInput(){
      this.phoneShow = false,
      this.card.phone = ''
    },
    focusCardNunberInput(){
      this.cardNumberShow = false
      this.card.cardNumber = ''
    },
    // 获取验证码
    async sendCode(phone) {
      var myreg = /^1[3-9]\d{9}$/
      if (phone === '') {
        this.$message.error('请填写电话号码')
        return
      } else if (!myreg.test(phone)) {
        this.$message({
          message: '请输入正确手机号',
          type: 'warning'
        })
        return false
      }
      if (!this.timer) {
        const res = await getCode({ phone })
        if (res.code === '') {
          this.$message({
            message: '发送成功，请注意查看手机短信',
            type: 'success'
          })
        }
        this.codeloading = true
        this.count = TIME_COUNT
        this.timer = setInterval(() => {
          if (this.count > 0 && this.count <= TIME_COUNT) {
            this.count--
          } else {
            this.show = true
            clearInterval(this.timer) // 清除定时器
            this.timer = null
            this.codeloading = false
          }
        }, 1000)
      }
    },
    btKeyUp(e) {
      e.target.value = e.target.value.replace(/[`~!@#$%^&*()_\-+=<>?:"{}|,.\/;'\\[\]·~！@#￥%……&*（）——\-+={}|《》？：“”【】、；‘’，。、' ']/g, '')
    },
    // 解绑
    async unbind(v) {
      const res = await bankDelete(this.unbinds)
      if (res.code === '') {
        this.$message({
          message: '解绑成功',
          type: 'success'
        })
        this.bankDetails()
        this.dialogData.isVisible = false
      }
    },
    // 更换银行卡
    replaceCard(v) {
      this.dialogData = {
        title: '更换银行卡',
        isVisible: true,
        confirm: '更换',
        type: v
      }
      this.card = this.bankArr
      this.cardNumberShow = true
      this.oldCardNumber = this.card.cardNumber
      this.oldPhone = this.card.phone
    },
    // 绑定银行卡
    bindCard(v) {
      this.dialogData = {
        title: '绑定银行卡',
        isVisible: true,
        confirm: '绑定',
        type: v
      }
      this.card = {
        cardName: '',
        cardNumber: '',
        bank: '',
        phone: '',
        code: ''
      }
    },
    // 解绑银行卡
    delBank(v) {
      this.dialogData = {
        title: '解绑银行卡',
        isVisible: true,
        confirm: '解绑',
        type: v
      }
    },
    // 确认
    confirm(formName) {
      this.$refs[formName].validate(valid => {
        if (valid) {
          console.log(formName)
          if (formName === 'card') {
            this.changeBank()
          } else if (formName === 'form') {
            this.addBank()
          } else if (formName === 'unbind') {
            this.unbind()
          }
        } else {
          console.log('error submit!!')
          return false
        }
      })
    },
    // 更换账户
    async changeBank() {
      var regExp = /^([1-9]{1})(\d{15}|\d{18})$/
      if (!regExp.test(this.card.cardNumber)) {
        this.$message({
          message: '请输入正确银行卡号！',
          type: 'warning'
        })
        return false
      }
      const res = await bankUpdate(this.card)
      if (res.code === '') {
        this.$message({
          message: '更换成功',
          type: 'success'
        })
        this.bankDetails()
        this.dialogData.isVisible = false
      }
    },
    // 绑定账户
    async addBank() {
      var regExp = /^([1-9]{1})(\d{15}|\d{18})$/
      if (!regExp.test(this.form.cardNumber)) {
        this.$message({
          message: '请输入正确银行卡号！',
          type: 'warning'
        })
        return false
      }
      const res = await bankAdd(this.form)
      if (res.code === '') {
        this.$message({
          message: '绑定成功',
          type: 'success'
        })
        this.bankDetails()
        this.dialogData.isVisible = false
      }
    },
    // 查询账户
    async bankDetails() {
      const res = await accountGetById({ })
      if (res.code === '') {
        console.log(JSON.stringify(res.data))
        if (JSON.stringify(res.data) === '{}') {
          this.show = false
        } else {
          this.bankArr = res.data
          this.show = true
        }
        console.log(this.show)
      }
    },
    async bankName() {
      const res = await getSelect({ dictName: '所属银行' })
      this.options = res.data
      console.log(this.options)
    },
    // 中间部分
    hidden(str, frontLen, endLen) {
      if (str && frontLen && endLen) {
        let endLenData = 0
        if (str.length !== 2) {
          endLenData = endLen
        }
        const len = str.length - frontLen - endLenData;
        let xing = '';
        for (let i = 0; i < len; i++) {
          xing += '*';
        }
        return (
          str.substring(0, frontLen) + xing + str.substring(str.length - endLenData)
        );
      }
    }
  }
}
</script>

<style scoped lang='scss'>
@import url("../../../styles/elDialog.scss");
.text_item {
  padding: 20px;
  display: flex;
  justify-content: space-between;
  align-items: center;
  .leftImg {
    width: 260px;
    height: 68px;
    overflow: hidden;
    img {
      width: 260px;
      height: 68px;
    }
  }
  .bankName {
    font-size: 18px;
    color: #333333;
    .bankNumber {
      display: flex;
      justify-content: flex-start;
      align-items: center;
      line-height: 30px;
      .bankNumber_1 {
        font-size: 18px;
      }
      .bankNumber_2 {
        font-size: 22px;
      }
    }
    .bankPeople {
      display: flex;
      justify-content: center;
      align-items: center;
    }
  }
  .btnList {
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 15px;
    cursor: pointer;
    .cutBank {
      background: rgba(58, 104, 242, 0.2);
      border: 1px solid #3a68f2;
      opacity: 0.5;
      border-radius: 4px;
      font-size: 16px;
      color: #3a68f2;
      width: 100px;
      height: 48px;
      display: flex;
      align-items: center;
      justify-content: center;
      margin-right: 30px;
    }
    .changeBank {
      display: flex;
      align-items: center;
      justify-content: center;
      width: 100px;
      height: 48px;
      background: #3a68f2;
      border-radius: 4px;
      color: #ffffff;
    }
  }
}
.dialog-footer {
  text-align: center;
  .el-button {
    padding: 15px 30px;
    &:nth-child(1) {
      margin-right: 40px;
    }
  }
}
.unbind {
  height: 40px;
  line-height: 40px;
  span {
    display: inline-block;
    font-size: 14px;
    color: #606266;
    &:nth-child(1) {
      width: 120px;
      text-align: right;
      padding-right: 12px;
      font-weight: 600;
    }
    &:nth-child(2) {
      margin-right: 50px;
    }
  }
  .el-button {
    padding: 6px 20px;
  }
}
.card {
  font-size: 18px;
  color: #84878d;
  // font-weight: 600;
}
.el-form {
  .el-form-item {
    label {
      font-weight: 400 !important;
    }
  }
}
.sendCode {
  margin-left: 20px;
}
</style>
