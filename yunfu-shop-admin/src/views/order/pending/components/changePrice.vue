<template>
  <div class="updatePrice">
    <el-dialog
      :visible.sync="visible"
      :close-on-click-modal="false"
      title="商品改价"
      width="600px"
    >
      <el-form
        ref="ruleForm"
        :model="ruleForm"
        :rules="rules"
        label-width="100px"
      >
        <el-form-item label="订单应付价格" prop="price">
          <el-input v-model="ruleForm.price" disabled />
        </el-form-item>
        <el-form-item label="修改价格" prop="newPrice">
          <el-input
            v-model="ruleForm.newPrice"
            maxlength="9"
            @change="
              (val) => {
                scope.row.newPrice = parseFloat(val) ? parseFloat(val) : 1;
              }
            "
          />
        </el-form-item>
      </el-form>
      <span slot="footer" class="dialog-footer">
        <el-button type="primary" :loading="loading" @click="changeOrderPrice('ruleForm')">确 定</el-button>
        <el-button @click="cancel('ruleForm')">取 消</el-button>
      </span>
    </el-dialog>
  </div>
</template>

<script>
import { updateOrderPrice } from '@/api/order'
export default {
  data() {
    return {
      visible: false,
      loading: false,
      ruleForm: {
        orderId: null,
        price: 0,
        newPrice: 0
      },
      rules: {
        newPrice: [
          { required: true, message: '请输入修改后的价格', trigger: 'blur' }
        ],
      }
    }
  },
  methods: {
    show(row) {
      this.visible = true
      this.ruleForm.orderId = row.orderId
      this.ruleForm.price = row.price
    },
    cancel(ref) {
      this.$refs[ref].resetFields();
      this.visible = false
    },
    changeOrderPrice(ref) {
      this.$refs[ref].validate((valid) => {
        if (valid && !this.loading) {
          this.loading = true
          updateOrderPrice({
            orderId: this.ruleForm.orderId,
            price: this.ruleForm.newPrice,
          }).then(res => {
            if (res.code === '') {
              this.$message.success('修改成功')
              this.visible = false
              this.$emit('success')
            }
          }).catch(err => {
            console.log(err)
          }).finally(() => {
            this.loading = false
          })
        }
      })
    }
  }
}
</script>

<style lang="scss">
@import url("../../../../styles/elDialog.scss");
</style>
