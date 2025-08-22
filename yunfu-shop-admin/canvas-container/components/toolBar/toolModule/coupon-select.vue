<template>
  <div class="product-select">
    <el-form :inline="true" :model="formData" class="demo-form-inline">
      <el-form-item label="">
        <el-input v-model="formData.keyword" maxlength="20" placeholder="请输入优惠券名称"></el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" @click="onSubmit">查询</el-button>
      </el-form-item>
    </el-form>
    <el-table
      :data="tableData"
      max-height="500"
      border
      style="width: 100%"
      ref="couponTable"
      row-key="productId"
      @selection-change="handleSelectionChange"
    >
      <el-table-column
        width="40"
        type="selection"
        :reserve-selection="true"
        fixed="left"
      >
      </el-table-column>
      <el-table-column
        prop="couponName"
        label="优惠券名称"
        width="180">
      </el-table-column>
      <el-table-column
        prop="content"
        label="内容">
      </el-table-column>
      <el-table-column
        prop="effectiveStart"
        label="活动开始时间">
      </el-table-column>
      <el-table-column
        prop="effectiveEnd"
        label="活动结束时间">
      </el-table-column>
    </el-table>
    <el-pagination
      @size-change="handleSizeChange"
      @current-change="handleCurrentChange"
      :current-page="currentPage"
      :hide-on-single-page="true"
      :page-sizes="[10, 20, 50, 100]"
      :page-size="pageSize"
      layout="total, sizes, prev, pager, next, jumper"
      :total="total">
    </el-pagination>
  </div>
</template>

<script>
  import api from '@@/components/canvasShow/config/api'
  import {sendReqMixin} from '@@/components/canvasShow/config/mixin'
  import Cookies from 'js-cookie'
  import { mapGetters } from 'vuex'
  export default {
    name: 'coupon-select',
    mixins: [sendReqMixin],
    data () {
      return {
        tableRadio: '',
        formData: {
          keyword: ''
        },
        currentPage: 1,
        total: 0,
        pageSize: 10,
        multipleSelection: [],
        tableData: [{
          id: 100,
          name: '测试'
        }]
      }
    },
    mounted () {
      this.getTableData()
    },
    computed: {
      ...mapGetters([
        'typeId'
      ])
    },
    methods: {
      // 获取优惠券
      getTableData () {
        var _this = this
        let _url = ''
        if(this.typeId===1){
          _url = `${api.getCoupons}?page=${this.currentPage}&pageSize=${this.pageSize}`
        } else if(this.typeId===3){
          _url = `${api.getShopCoupons}?page=${this.currentPage}&pageSize=${this.pageSize}&shopId=${Cookies.get('cereShopId')}`
        }
        if (this.formData.keyword) {
          _url += `&search=${this.formData.keyword}`
        }
        let params = {
          url: _url,
          method: 'GET'
        }
        this.sendReq(params, (res) => {
          _this.tableData = res.data.list
          if(this.typeId===1){
            _this.tableData.map(function(value){
              value.couponName = value.activityName
              value.effectiveStart = value.activityStartTime
              value.effectiveEnd = value.activityEndTime
              return value;
            });
          }
          _this.total = res.data.total
        })
      },
      // 搜索
      onSubmit () {
        this.getTableData()
      },
      // 每页条数改变
      handleSizeChange (val) {
        this.pageSize = val
        this.getTableData()
      },
      // 当前页改变
      handleCurrentChange (val) {
        this.currentPage = val
        this.getTableData()
      },
      // 多选改变
      handleSelectionChange (val) {
        this.multipleSelection = val
      },
      // 多选改变
      resetTableData (list) {
        this.$refs.couponTable.clearSelection();
        this.$refs.couponTable.toggleRowSelection(list,true);
      }
    }
  }
</script>

<style lang="scss" scoped>
  .product-select{
    .el-pagination{
      padding: 0px;
      margin-top: 30px;
    }
    .el-table{
      .img{
        width: 80px;
        height: 80px;
      }
    }
  }
</style>
