<template>
  <div class="product-select">
    <el-form :inline="true" :model="params" class="demo-form-inline">
      <el-form-item label="">
        <el-input v-model="params.search" maxlength="20" placeholder="请输入优惠券名称" />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" @click="getTableData">查询</el-button>
      </el-form-item>
    </el-form>
    <el-table
      ref="couponTable"
      :loading="loading"
      :data="tableData"
      max-height="240"
      border
      style="width: 100%"
      row-key="productId"
      @selection-change="selectionChange"
    >
      <el-table-column
        v-if="isMultiple"
        width="40"
        type="selection"
        :reserve-selection="true"
        fixed="left"
      />
      <el-table-column v-else label="" width="40" align="center">
        <template slot-scope="scope">
          <el-radio v-model="tableRadio" :label="scope.row"><i /></el-radio>
        </template>
      </el-table-column>
      <el-table-column
        prop="shopCouponId"
        label="优惠券id"
        width="180"
      />
      <el-table-column
        prop="couponName"
        label="优惠券名称"
        width="180"
      />
      <el-table-column
        prop="couponType"
        label="类型"
        width="180"
      >
        <template slot-scope="scope">
          <span v-if="scope.row.couponType === 1">满减券</span>
          <span v-if="scope.row.couponType === 2">折扣券</span>
        </template>
      </el-table-column>
      <el-table-column
        prop="content"
        label="内容"
      />
      <el-table-column
        prop="effectiveStart"
        label="活动开始时间"
      />
      <el-table-column
        prop="effectiveEnd"
        label="活动结束时间"
      />
    </el-table>
    <el-pagination
      :current-page="params.page"
      :hide-on-single-page="true"
      :page-sizes="[10, 20, 50, 100]"
      :page-size="params.pageSize"
      layout="total, sizes, prev, pager, next, jumper"
      :total="total"
      @size-change="handleSizeChange"
      @current-change="handleCurrentChange"
    />
  </div>
</template>
<script>
import Cookies from 'js-cookie'
import { getCoupons } from '@/api/public'
export default {
  name: 'CouponSelect',
  props: {
    isMultiple: {
      type: Boolean,
      default: false
    },
    proId: {
      type: Number,
      default: 0
    },
    proIds: {
      type: Array,
      default: () => []
    }
  },
  data() {
    return {
      loading: false,
      tableRadio: '',
      multipleSelection: [],
      dialogProduct: false,
      params: {
        page: 1,
        pageSize: 10,
        search: ''
      },
      tableData: [],
      total: 0
    }
  },
  watch: {
    tableRadio(val) {
      this.$emit('couponChange', val)
    }
  },
  mounted() {
    this.params.shopId = parseInt(Cookies.get('cereShopId'))
    this.getTableData()
  },
  methods: {
    // 获取优惠券
    async getTableData() {
      const res = await getCoupons(this.params)
      this.loading = false
      this.tableData = res.data.list || []
      this.total = res.data.total || 10
      this.afterInit()
    },
    afterInit() {
      if (this.isMultiple) {
        if (this.proIds.length > 0) {
          this.tableData.forEach(row => {
            for (let i = 0; i < this.proIds.length; i++) {
              if (this.proIds[i] === row.id) {
                this.$refs.couponTable.toggleRowSelection(row, true)
              }
            }
          })
        }
      } else {
        if (this.proId !== 0) {
          this.tableRadio = this.proId
        }
      }
    },
    // 搜索
    onSubmit() {
      this.getTableData()
    },
    // 每页条数改变
    handleSizeChange(val) {
      this.params.pageSize = val
      this.getTableData()
    },
    // 当前页改变
    handleCurrentChange(val) {
      this.params.page = val
      this.getTableData()
    },
    // 多选改变
    selectionChange(val) {
      this.multipleSelection = val
      this.$emit('couponChange', val)
    }
  }
}
</script>

<style lang="scss" scoped>
.product-select{
  .el-pagination{
    padding: 0px;
    margin-top: 20px;
    text-align: right;
  }
  .el-table{
    margin-bottom: 20px;
    .img{
      width: 80px;
      height: 80px;
    }
    .el-radio{
     ::v-deep .el-radio__label{
        display: none;
      }
    }
  }
}
</style>
