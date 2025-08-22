<template>
  <div class="integralPage">
    <div class="configuration">
      <el-form
        ref="ruleForm"
        :model="ruleForm"
        :rules="rules"
        label-width="100px"
        class="demo-ruleForm"
      >
        <el-form-item label="认证时间：" prop="newPhone">
          {{ now_time }}
        </el-form-item>
        <el-form-item label="管理员电话" prop="newPhone">
          <el-input
            v-if="Number(privacyTime)===0"
            disabled
            :value="hidden(ruleForm.newPhone,3,4)"
            style="width: 70%"
            placeholder="请输入管理员电话"
          />
          <el-input
            v-else
            disabled
            v-model="ruleForm.newPhone"
            style="width: 70%"
            placeholder="请输入管理员电话"
          />
        </el-form-item>
        <el-form-item label="验证码" prop="code">
          <el-input
            v-model="ruleForm.code"
            maxlength="6"
            style="width: 40%; margin-right: 38px"
            placeholder="请输入验证码"
          />
          <el-button
            class="codeBtn"
            type="primary"
            :loading="codeloading"
            @click="getCode(ruleForm.newPhone)"
          >
            <span v-if="!codeloading">获取验证码</span>
            <span v-else>{{ count }} s</span>
          </el-button>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="submint(ruleForm.newPhone)">
            确定
          </el-button>
        </el-form-item>
      </el-form>
    </div>
  </div>
</template>

<script>
import {
  getAdminPhone,
  getPrivacyCode,
  verifyPrivacyCode,
} from "@/api/privacy";
const TIME_COUNT = 120; // 更改倒计时时间
const JM = require("@/utils/rsaEncrypt.js");
export default {
  data() {
    // 管理员手机号码
    const newPhone = (rule, value, callback) => {
      if (!value) {
        return callback(new Error("请输入新手机号"));
      } else if (/^1[3456789]\d{9}$/.test(value) === false) {
        return callback(new Error("请输入正确的手机号"));
      } else {
        callback();
      }
    };
    // 验证码
    const code = (rule, value, callback) => {
      if (!value) {
        return callback(new Error("请输入验证码"));
      } else {
        callback();
      }
    };
    return {
      ruleForm: {
        newPhone: "",
        code: "",
      },
      newPhone: "",
      rules: {
        newPhone: [{ required: true, validator: newPhone, trigger: "blur" }],
        code: [{ required: true, validator: code, trigger: "blur" }],
      },
      codeloading: false,
      count: "",
      timer: null,
      privacyTime: "",
      now_time: "",
    };
  },
  created() {
    this.getPhone();
    // 获取认证的时间
    this.privacyTime = localStorage.getItem("privacyTime");
    if (Number(this.privacyTime) === 0) {
      this.now_time = "未认证";
    } else {
      var time = new Date(Number(this.privacyTime));
      var year = time.getFullYear();
      var month = time.getMonth() + 1;
      var day = time.getDate();
      var hours = time.getHours();
      var minutes = time.getMinutes();
      this.now_time =
        year + "-" + month + "-" + day + " " + hours + ":" + minutes;
    }
    console.log(this.now_time);
  },
  mounted() {},
  methods: {
    // 获取管理员电话
    getPhone() {
      getAdminPhone().then((res) => {
        this.ruleForm.newPhone = res.data;
      });
    },
    // 获取验证码
    async getCode(phone) {
      console.log(phone);
      if (phone === "" || phone === undefined) {
        this.$message.error("请填写手机号");
        return;
      }
      if (/^1[3456789]\d{9}$/.test(phone) === false) {
        this.$message.error("请填写正确手机号");
        return false;
      }
      if (!this.timer) {
        this.codeloading = true;
        this.count = TIME_COUNT;
        this.show = false;
        const res = await getPrivacyCode({ phone });
        if (res.code === "") {
          this.$message({
            message: "发送成功，请注意查看手机短信",
            type: "success",
          });
        }
        this.timer = setInterval(() => {
          if (this.count > 0 && this.count <= TIME_COUNT) {
            this.count--;
          } else {
            this.show = true;
            clearInterval(this.timer); // 清除定时器
            this.timer = null;
            this.codeloading = false;
          }
        }, 1000);
      }
    },
    // 确定
    async submint() {
      this.timer = null;
      this.codeloading = false;
      if (this.ruleForm.code === "" || this.ruleForm.code === undefined) {
        this.$message.error("请填写验证码");
        return;
      }
      var data = {
        code: JM.encrypt(this.ruleForm.code),
        username: JM.encrypt(this.ruleForm.newPhone),
      };
      const res = await verifyPrivacyCode(data);
      if (res.data === true) {
        this.$message({
          message: "二次认证成功，该认证24小时内有效，超过时间需要重新认证",
          type: "success",
        });
        this.ruleForm.code = "";
        location.reload()
      }
    },
    // 中间部分
    hidden(str, frontLen, endLen) {
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
  },
};
</script>

<style lang="scss" scpoed>
.integralPage {
  padding: 32px 20px;
  .configuration {
    width: 600px;
  }
}
</style>
