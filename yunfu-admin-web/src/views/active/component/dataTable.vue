<template>
  <el-card class="activityData">
    <div slot="header" class="clearfix">
      <span class="title">商家数据明细</span>
      <el-button type="primary" @click="send">导出</el-button>
    </div>
    <div class="text">
      <!--  表格 -->
      <div class="content_table">
        <div class="table">
          <el-table
            :data="tableData"
            border
            :header-cell-style="{ background: '#EEF3FF', color: '#333333' }"
            style="width: 100%"
          >
            >
            <el-table-column prop="shopName" label="店铺名称" />
            <el-table-column prop="shopCode" label="店铺编码" />
            <el-table-column prop="products" label="参与商品数(件)" />
            <el-table-column prop="persons" label="访客数(人)" />
            <el-table-column prop="orders" label="订单数(笔)" />
            <el-table-column prop="customers" label="成交客户数(笔)" />
            <el-table-column prop="price" label="客单价(元)" />
            <el-table-column prop="total" label="成交总额(元)" />
          </el-table>
          <div class="fenye">
            <el-pagination
              :current-page="page"
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
    </div>
  </el-card>
</template>

<script>
export default {
  props: {
    tableData: {
      type: Array,
      default: () => [],
    },
    total: {
      type: Number,
      default: 0,
    },
  },
  data() {
    return {
      page: 1,
    }
  },
  methods: {
    handleCurrentChange(e) {
      this.$emit('handleCurrentChange', e)
    },
    handleSizeChange(e) {
      this.$emit('handleSizeChange', e)
    },
    send() {
      this.$emit('export')
    },
  },
}
</script>

<style lang="scss" scoped>
.activityData {
  width: 100%;
  .clearfix {
    line-height: 40px;
    .title {
      font-size: 20px;
    }
    button {
      width: 120px;
      height: 40px;
      background: #3a68f2;
      border-radius: 4px;
      float: right;
      padding: 3px 0;
    }
  }
}
</style>
