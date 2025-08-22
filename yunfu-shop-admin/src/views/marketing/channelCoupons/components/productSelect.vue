<template>
  <div v-show="visible" class="product-select">
    <el-form :inline="true" :model="params" class="demo-form-inline">
      <el-form-item label="">
        <el-input v-model="params.search" maxlength="20" placeholder="店铺名称/商品ID/商品分组" />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" @click="onSubmit">查询</el-button>
      </el-form-item>
    </el-form>
    <el-table
      v-if="tableData && tableData.length > 0"
      ref="multipleTable"
      :loading="loading"
      :data="tableData"
      max-height="500"
      border
      row-key="productId"
      style="width: 100%"
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
        prop="productId"
        label="产品ID"
      />
      <el-table-column label="产品主图" width="180" align="center">
        <template slot-scope="scope">
          <el-image
            style="width: 80px; height: 80px"
            :src="scope.row.image"
            fit="contain"
          />
        </template>
      </el-table-column>
      <el-table-column
        prop="productName"
        label="产品名称"
        width="180"
      />
      <el-table-column
        prop="price"
        label="售价"
      />
      <el-table-column
        prop="originalPrice"
        label="原价"
      />
      <el-table-column
        prop="stockNumber"
        label="库存"
      />
      <el-table-column
        prop="number"
        label="销量"
      />
    </el-table>
    <el-pagination
      :current-page="params.currentPage"
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
import { getProducts } from '@/api/public'
export default {
  name: 'ProductSelect',
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
      visible: false,
      tableRadio: '',
      params: {
        search: '',
        page: 1,
        pageSize: 10,
        shopId: 0,
        shelveState: 1
      },
      total: 0,
      tableData: [],
      multipleSelection: []
    }
  },
  mounted() {
    this.params.shopId = parseInt(Cookies.get('cereShopId'))
  },
  methods: {
    // 获取产品信息
    async getTableData(citem) {
      this.loading = true
      if (citem) {
        // this.params.cid = citem.shopCouponId
        this.params.shopCouponId = citem.shopCouponId
      }
      console.log(this.params, 'this.params')
      const res = await getProducts(this.params)
      this.visible = true
      this.loading = false
      this.tableRadio = ''
      this.tableData = res.data.list || []
      this.total = res.data.total || []
      this.afterInit()
    },
    afterInit() {
      if (this.isMultiple) {
        if (this.proIds.length > 0) {
          this.tableData.forEach(row => {
            for (let i = 0; i < this.proIds.length; i++) {
              if (this.proIds[i] === row.id) {
                this.$refs.productTable.toggleRowSelection(row, true)
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
