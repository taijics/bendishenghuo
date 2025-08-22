<template>
  <el-dialog :close-on-click-modal="false" title="新增渠道优惠券" width="80%" :visible.sync="visible" @close="closeModal">
    <el-form ref="form" :model="form" size="small" label-width="120px">
      <coupon-select ref="couponSelect" @couponChange="couponChange($event)" />
      <product-select ref="productSelect" />
    </el-form>
    <div slot="footer" class="dialog-footer">
      <el-button type="text" @click="doCancel">取消</el-button>
      <el-button type="primary" @click="doSubmit">确认</el-button>
    </div>
  </el-dialog>
</template>

<script>
import {
  add
} from '@/api/channelCoupons'
import ProductSelect from '@/views/marketing/channelCoupons/components/productSelect.vue'
import CouponSelect from '@/views/marketing/channelCoupons/components/couponSelect.vue'
import Cookies from 'js-cookie'
export default {
  name: 'AdForm',
  components: { CouponSelect, ProductSelect },
  data() {
    return {
      loading: false,
      visible: false,
      channelList: [],
      form: {}
    }
  },

  methods: {
    // 关闭弹窗
    closeModal() {
      this.$refs.couponSelect.tableData = []
      this.$refs.couponSelect.params = {
        search: '',
        page: 1,
        pageSize: 10,
        shopId: 0,
        shelveState: 1
      }
      this.$refs.productSelect.tableData = []
      this.$refs.productSelect.visible = false
      this.$refs.productSelect.params = {
        search: '',
        page: 1,
        pageSize: 10,
        shopId: 0,
        shelveState: 1
      }
      this.$refs.couponSelect.getTableData()
    },
    // 打开弹出窗
    show(row) {
      this.form = {
        shopId: parseInt(Cookies.get('cereShopId'))
      }
      this.visible = true
    },
    // 取消
    doCancel() {
      this.visible = false
    },
    doSubmit() {
      this.$refs['form'].validate((valid) => {
        if (valid) {
          this.loading = true
          this.doAdd()
        }
      })
    },
    doAdd() {
      this.$refs['form'].validate((valid) => {
        if (valid) {
          this.form.shopCouponId = this.$refs.couponSelect.tableRadio.shopCouponId
          this.form.productId = this.$refs.productSelect.tableRadio.productId
          if (!this.form.productId) {
            this.$message({
              message: '请查询并选择商品',
              type: 'warning'
            })
            return false
          }
          if (!this.form.shopCouponId) {
            this.$message({
              message: '请查询并选择优惠券',
              type: 'warning'
            })
            return false
          }
          add(this.form).then(res => {
            this.loading = false
            this.resetForm()
            this.$emit('reset')
            this.$message({
              message: '添加成功',
              type: 'success'
            })
          }).catch(err => {
            console.log(err.response.data.message)
            this.loading = false
          })
        }
      })
    },
    couponChange(val) {
      this.$refs.productSelect.getTableData(val)
    },
    resetForm() {
      this.visible = false
      this.$refs.productSelect.params.search = ''
      this.$refs.productSelect.data = []
      this.$refs.couponSelect.params.search = ''
      this.$refs.couponSelect.data = []
    }
  }
}
</script>
