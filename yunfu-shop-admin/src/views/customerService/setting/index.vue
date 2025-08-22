<template>
  <div class="servicePage">
    <div class="configuration">
      <el-form
        ref="ruleForm"
        :model="ruleForm"
        :rules="rules"
        label-width="180px"
        class="demo-ruleForm"
      >
        <el-form-item label="服务ID" prop="appId">
          <el-input v-model="ruleForm.appId" maxlength="20" />
        </el-form-item>
        <el-form-item label="Secret" prop="secret">
          <el-input v-model="ruleForm.secret" maxlength="20" />
        </el-form-item>
        <el-form-item>
          <el-button
            type="primary"
            @click="submitForm('ruleForm')"
          >保存</el-button>
          <el-button @click="resetForm('ruleForm')">重置</el-button>
        </el-form-item>
      </el-form>
    </div>
  </div>
</template>

<script>
import { getConfig, saveOrUpdateConfig } from '@/api/server';
export default {
  data() {
    return {
      ruleForm: {
        appId: '',
        secret: '',
      },
      rules: {
        appId: [{ required: true, message: '请输入服务ID', trigger: 'blur' }],
        secret: [{ required: true, message: '请输入Secret', trigger: 'blur' }],
      },
    };
  },
  created() {
    this.getConfig();
  },
  methods: {
    // 获取客服配置
    getConfig() {
      getConfig().then((res) => {
        console.log(res);
        this.ruleForm = res.data;
      });
    },
    // 保存
    submitForm(formName) {
      this.$refs[formName].validate((valid) => {
        if (valid) {
          saveOrUpdateConfig(this.ruleForm).then((res) => {
            console.log(res);
            if (res.code === '') {
              this.$message.success('保存成功');
            }
          });
        } else {
          console.log('error submit!!');
          return false;
        }
      });
    },
    resetForm(formName) {
      this.$refs[formName].resetFields();
    },
  },
};
</script>

<style lang="scss" scpoed>
.servicePage {
  padding: 5rem 20px;
  .configuration {
    width: 600px;
  }
}
</style>
