<template>
  <div class="setting_page">
    <el-form ref="form" label-width="200px">
      <el-form-item label="申请条件:">
        <el-radio-group v-model="applyCondition" @change="applyConditions">
          <p class="radiop">
            <el-radio :label="1">购买任意商品</el-radio>
          </p>
          <p class="radiop">
            <el-radio :label="2">
              至少下单满
              <el-input v-model="text" maxlength="9" :disabled="disabled" />单
            </el-radio>
          </p>
          <p class="radiop">
            <el-radio :label="3">
              消费金额满
              <el-input v-model="text1" maxlength="9" :disabled="disabled1" />元
            </el-radio>
          </p>
        </el-radio-group>
      </el-form-item>
      <el-form-item label="审核设置：">
        <el-radio-group v-model="auditFlag" @change="auditFlags">
          <el-radio :label="0">无需审核自动成为分销</el-radio>
          <el-radio :label="1">需要审核</el-radio>
        </el-radio-group>
      </el-form-item>
      <el-form-item label-width="100" style="padding-left: 120px;">
        <el-button plain @click="cancel">取消</el-button>
        <el-button type="primary" @click="subm">保存</el-button>
      </el-form-item>
    </el-form>
  </div>
</template>

<script>
import { getByShopId, recruitAdd, recruitUpdate } from '@/api/distributor'
export default {
  data() {
    return {
      text: '',
      text1: '',
      disabled: true,
      disabled1: true,
      first: true,
      relationQuery: {
        current: 1,
        map: {},
        model: {},
        order: 'descending',
        size: 10,
        sort: 'id'
      },
      applyCondition: 1,
      auditFlag: 0,
      relationItem: {},
      updataQuery: {
        applyCondition: '',
        applyDetail: '',
        auditFlag: '',
        expireTime: '',
        id: '',
        isCanInvite: '',
        isForeverValid: '',
        protectTime: '',
        rebindCustomerFlag: '',
        salesBindFalg: '',
        selfBuyReturnCommisionFlag: ''
      }
    }
  },
  created() {
    this.salesRelationConfig()
  },
  methods: {
    // 关系设置
    async salesRelationConfig() {
      const res = await getByShopId({})
      console.log(res)
      if (JSON.stringify(res.data) === '{}') {
        this.first = true
      } else {
        this.first = false
        this.applyCondition = res.data.condition
        this.auditFlag = res.data.ifExamine
        this.text = res.data.frequency || ''
        this.text1 = res.data.money || ''
        this.updataQuery.id = this.relationItem.id
        this.updataQuery.auditFlag = this.relationItem.auditFlag
        this.updataQuery.applyCondition = this.relationItem.applyCondition
        console.log(this.relationItem)
      }
    },
    applyConditions(e) {
      console.log(e)
      if (e === 1) {
        this.disabled = true
        this.disabled1 = true
        this.text1 = ''
        this.text = ''
      } else if (e === 2) {
        this.disabled = false
        this.disabled1 = true
      } else if (e === 3) {
        this.disabled = true
        this.disabled1 = false
      }
      this.relationQuery.model.applyCondition = e
    },
    auditFlags(e) {
      this.relationQuery.model.auditFlag = e
    },
    // 复制链接
    copy(data) {
      const oInput = document.createElement('input')
      oInput.value = data
      document.body.appendChild(oInput)
      oInput.select() // 选择对象;
      document.execCommand('Copy') // 执行浏览器复制命令
      this.$message({
        message: '复制成功',
        type: 'success'
      })
      oInput.remove()
    },
    preview() {},
    // 取消
    cancel() {
      this.$message({
        message: '已取消',
        type: 'success'
      })
    },
    // 保存
    async subm() {
      const obj = {
        condition: this.applyCondition,
        frequency: this.text, // 下单次数
        money: this.text1, // 消费金额
        ifExamine: this.auditFlag, // 是否需要审核 1-是 0-否
        url: '' // 招募页链接
      }
      if (this.first) {
        const res = await recruitAdd(obj)
        if (res.code === '') {
          this.$message.success('新增成功')
        }
      } else {
        const res = await recruitUpdate(obj)
        if (res.code === '') {
          this.$message.success('编辑成功')
        }
      }
    }
  }
}
</script>

<style lang='scss' scoped>
.setting_page {
  padding: 20px 0;
}
p {
  margin: 0;
  padding: 0;
}
.radiop {
  line-height: 40px;
}

::v-deep .el-input {
  width: 80px;
  margin: 0 10px;
}
</style>
