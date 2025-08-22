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
        <el-form-item label="旧手机号" prop="oldPhone">
          <el-input
            v-if="Number(privacyTime)===0"
            disabled
            :value="hidden(oldPhone,3,4)"
            style="width: 70%"
            placeholder="请输入旧手机号"
          />
          <el-input
            v-else
            disabled
            v-model="oldPhone"
            style="width: 70%"
            placeholder="请输入旧手机号"
          />
        </el-form-item>
        <el-form-item label="新手机号" prop="newPhone">
          <el-input
            v-model="ruleForm.newPhone"
            maxlength="11"
            style="width: 70%"
            placeholder="请输入新手机号"
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
            @click="getCode(oldPhone)"
          >
            <span v-if="!codeloading">获取验证码</span>
            <span v-else>{{ count }} s</span>
          </el-button>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="submint"> 确定 </el-button>
        </el-form-item>
      </el-form>
    </div>
  </div>
</template>

<script>
import {
  getAdminPhone,
  getUpdatePhoneCode,
  updatePhone,
} from "@/api/privacy";
const JM = require("@/utils/rsaEncrypt.js");
const TIME_COUNT = 120; // 更改倒计时时间
export default {
  data() {
    // 旧手机号
    const oldPhone = (rule, value, callback) => {
      if (!value) {
        return callback(new Error("请输入旧手机号"));
      } else if (/^1[3456789]\d{9}$/.test(value) === false) {
        return callback(new Error("请输入正确的手机号"));
      } else {
        callback();
      }
    };
    // 新手机号
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
      oldPhone: "",
      rules: {
        oldPhone: [{ required: true, validator: oldPhone, trigger: "blur" }],
        newPhone: [{ required: true, validator: newPhone, trigger: "blur" }],
        code: [{ required: true, validator: code, trigger: "blur" }],
      },
      codeloading: false,
      count: "",
      timer: null,
      privacyTime: 0,
    };
  },
  created() {
    this.getPhone();
    this.privacyTime = localStorage.getItem("privacyTime");
  },
  mounted() {},
  methods: {
    // 获取管理员电话
    getPhone() {
      getAdminPhone().then((res) => {
        this.oldPhone = res.data
      });
    },
    // 获取验证码
    async getCode(phone) {
      console.log(phone);
      if (phone === "" || phone === undefined) {
        this.$message.error("请填写新手机号");
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
        const res = await getUpdatePhoneCode({ phone });
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
    submint() {
      if (this.ruleForm.newPhone === "" || this.ruleForm.newPhone === undefined) {
        this.$message.error("请填写新手机号");
        return;
      }
      if (/^1[3456789]\d{9}$/.test(this.ruleForm.newPhone) === false) {
        this.$message.error("请填写正确手机号");
        return false;
      }
      if (this.ruleForm.code === "" || this.ruleForm.code === undefined) {
        this.$message.error("请填写验证码");
        return;
      }
      var data = {
        code: JM.encrypt(this.ruleForm.code),
        newPhone: JM.encrypt(this.ruleForm.newPhone),
        phone: JM.encrypt(this.oldPhone),
      };
      updatePhone(data).then((res) => {
        if (res.code === "") {
          this.$message({
            message: "手机号修改成功",
            type: "success",
          });
          this.getPhone();
          this.ruleForm = {
            newPhone: "",
            code: "",
          };
        }
      });
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
