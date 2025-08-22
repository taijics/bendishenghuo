<template>
  <div class="activeData">
    <h3>实时统计</h3>
    <div class="couponTit">活动名称：{{ activityName }}</div>
    <div class="dataListBox">
      <div class="dataItem">
        <span>{{ dataInfo.orders }}</span>
        <p>成交笔数</p>
      </div>
      <div class="dataItem">
        <span>{{ dataInfo.users }}</span>
        <p>成交人数</p>
      </div>
      <div class="dataItem">
        <span>{{ dataInfo.total }}</span>
        <p>成交金额</p>
      </div>
    </div>
    <div class="tabListInfo">活动成交的商品</div>
    <div class="tableBox">
      <el-table
        ref="multipleTable"
        v-loading="loading"
        :data="dataInfo.datas.list"
        border
        :header-cell-style="{ background: '#EEF3FF', color: '#333333' }"
        tooltip-effect="dark"
        style="width: 100%"
        max-height="600"
        @selection-change="handleSelectionChange"
      >
        <el-table-column prop="productId" label="商品id" />
        <el-table-column label="商品主图">
          <template slot-scope="scope">
            <img height="80" width="80" :src="scope.row.image" alt srcset>
          </template>
        </el-table-column>
        <el-table-column prop="productName" label="商品名称" />
        <el-table-column prop="sectionPrice" label="活动价" />
        <el-table-column prop="stockNumber" label="库存" />
        <el-table-column prop="valume" label="活动销量" />
        <el-table-column prop="total" label="活动成交金额" />
        <el-table-column prop="number" label="商品限量（件）" />
      </el-table>
      <div class="fenye">
        <el-pagination
          :current-page="formInline.page"
          :page-sizes="[10, 20, 50, 100]"
          :page-size="10"
          layout="total, sizes, prev, pager, next, jumper"
          :total="total"
          @size-change="handleSizeChange"
          @current-change="handleCurrentChange"
        />
      </div>
    </div>
  </div>
</template>

<script>
import {
  getShopId
} from '@/utils/auth'
import { getDatas } from '@/api/active'

export default {
  name: 'ActiveData',
  props: {
    form: {
      type: Object,
      default: () => ({})
    }
  },
  data() {
    return {
      formInline: {
        page: 1,
        pageSize: 10,
        signType: 2,
        shopId: 0
      },
      loading: false,
      activityName: '',
      total: 0,
      dataInfo: {
        datas: {}
      }
    }
  },
  watch: {
    form: {
      handler(nVal, oVal) {
        this.formInline.activityId = nVal.activityId
        this.formInline.signId = nVal.signId
        this.activityName = nVal.activityName
        this.getAll(this.formInline)
      }
    }
  },
  mounted() {
    this.formInline.shopId = parseInt(getShopId())
    // 活动相关数据
    this.formInline.activityId = this.form.activityId
    this.formInline.signId = this.form.signId
    this.activityName = this.form.activityName
    this.getAll(this.formInline)
  },
  methods: {
    // 初始化查询所有数据
    async getAll(formInline) {
      this.loading = true
      const res = await getDatas(formInline)
      this.dataInfo = res.data
      this.total = res.data.datas.total
      this.loading = false
    },
    handleSizeChange(val) {
      this.formInline.pageSize = val
      this.getAll(this.formInline)
    },
    handleCurrentChange(val) {
      this.formInline.page = val
      this.getAll(this.formInline)
    },
    handleSelectionChange(val) {}
  }
}
</script>

<style lang='scss' scoped>
//@import url(); 引入公共css类
@import url("../../styles/elDialog.scss");

.activeData {
  padding: 20px;
  .couponTit {
    margin: 20px 0;
  }
  .dataListBox {
    display: flex;
    justify-content: center;
    margin: 30px 0;
    .dataItem {
      width: 220px;
      height: 120px;
      border-radius: 8px;
      border: 1px solid #999999;
      text-align: center;
      margin: 0 10px;
      span {
        display: block;
        margin-top: 35px;
      }
    }
  }
  .tabListInfo {
    margin: 20px 0;
  }
}
</style>
