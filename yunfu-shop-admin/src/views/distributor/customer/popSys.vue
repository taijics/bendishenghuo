<template>
  <div class="content">
    <br>
    <br>
    <el-row>
      <el-col :span="4">邀请下级：</el-col>
      <el-col :span="8">
        <el-radio-group v-model="updataQuery.ifInvitation">
          <el-radio :label="1">允许</el-radio>
          <el-radio :label="0" style="margin-left:90px;">不允许</el-radio>
        </el-radio-group>
        <div class="text">被邀请人通过邀请海报进入同意之后，会和邀请人绑定上下级关系</div>
      </el-col>
    </el-row>
    <br>
    <br>
    <br>
    <el-row>
      <el-col :span="4">关系绑定有效期：</el-col>
      <el-col :span="8">
        <el-radio-group v-model="updataQuery.bindValidity" @change="change">
          <el-radio :label="1">永久有效</el-radio>
          <el-radio :label="2" style="margin-left:60px;">
            <el-input v-model="updataQuery.validityDay" maxlength="9" :disabled="disabled" class="input" />&nbsp;天有效
          </el-radio>
        </el-radio-group>
      </el-col>
    </el-row>
    <br>
    <br>
    <br>
    <el-row>
      <el-col :span="4">是否允许抢客：</el-col>
      <el-col :span="20">
        <el-radio-group v-model="updataQuery.ifRobbing" @change="change1">
          <el-radio :label="1">随时可抢客</el-radio>
          <el-radio :label="2" style="margin-left:60px;">不允许抢客</el-radio>
          <el-radio :label="3" style="margin-left:60px;">
            保护期&nbsp;&nbsp;
            <el-input v-model="updataQuery.robbingDay" maxlength="9" :disabled="disabled1" class="input" />&nbsp;天不允许抢
          </el-radio>
        </el-radio-group>
      </el-col>
    </el-row>
    <br>
    <br>
    <br>
    <el-row class="mbt">
      <el-col :span="4">分销员之间建立客户关系：</el-col>
      <el-col :span="8">
        <el-radio-group v-model="updataQuery.ifDistributionRelationship">
          <el-radio :label="1">允许</el-radio>
          <el-radio :label="0" style="margin-left:90px;">不允许</el-radio>
        </el-radio-group>
      </el-col>
    </el-row>
    <el-button type="primary" class="cancel" @click="cancel">取消</el-button>
    <el-button type="primary" class="subm" @click="subm">保存</el-button>
  </div>
</template>

<script>
import { shipGetById, shipSave, shipUpdate } from '@/api/distributor'
export default {
  data() {
    return {
      disabled: false,
      disabled1: false,
      updataQuery: {
        validityDay: '',
        ifInvitation: '',
        bindValidity: '',
        robbingDay: '',
        ifRobbing: '',
        ifDistributionRelationship: ''
      }
    }
  },
  created() {
    this.salesRelationConfig()
  },
  methods: {
    // 关系设置
    async salesRelationConfig() {
      const res = await shipGetById({ })
      console.log(res)
      if (JSON.stringify(res.data) === '{}') {
        this.first = true
      } else {
        this.first = false
        this.updataQuery = res.data
      }
      // console.log('关系设置', this.relationItem)
    },
    cancel() {
      this.salesRelationConfig()
      this.$message({
        message: '已取消',
        type: 'success'
      })
    },
    async subm() {
      console.log(this.updataQuery)
      if (this.first) {
        const res = await shipSave(this.updataQuery)
        if (res.code === '') {
          this.$message.success('新增成功')
          this.salesRelationConfig()
        }
      } else {
        const res = await shipUpdate(this.updataQuery)
        if (res.code === '') {
          this.$message.success('修改成功')
          this.salesRelationConfig()
        }
      }
      //   const res = await Distribution.updataConfig(this.updataQuery);
      //   console.log(res);
      //   const { code } = res.data;
      //   if (code == 0) {
      //     this.$message({
      //       message: "保存成功",
      //       type: "success"
      //     });
      //   }
    },
    change(e) {
      if (e === 1) {
        this.disabled = true
      } else {
        this.disabled = false
      }
    },
    change1(e) {
      if (e === 1 || e === 2) {
        this.disabled1 = true
      } else {
        this.disabled1 = false
      }
    }
  }
}
</script>

<style lang='scss' scoped>
el-radio {
  zoom: 150%;
}
.content {
  font-size: 16px;
  width: 1400px;
  margin-top: 100px;
  margin: auto;
  .text {
    line-height: 60px;
    font-size: 15px;
    color: grey;
  }
  .input {
    width: 100px;
    background: #ffffff;
    border-radius: 4px;
  }
  .cancel {
    width: 100px;
    height: 48px;
    background: #ffffff;
    border: 1px solid #e0e5eb;
    color: #333333;
    border-radius: 4px;
  }
  .subm {
    width: 100px;
    height: 48px;
    border-radius: 4px;
  }
}
::v-deep .el-radio__inner {
  width: 30px;
  height: 30px;
}
::v-deep.el-radio__label {
  font-size: 14px;
}
.mbt {
  margin-bottom: 50px;
}
</style>
