<template>
  <div class="orderDetailList">
    <!-- 表头 -->
    <nav></nav>
    <section>
      <div class="productItem"></div>
    </section>
    <el-table
      :data="tableData"
      border
      style="width: 100%"
    >
      <el-table-column v-for="item in title"
        :key="item.value"
        :prop="item.prop"
        :label="item.label"
      />
    </el-table>
  </div>
</template>

<script>
export default {
  props: {
    title: {
      type: Array,
      default: () => [
        {
          value: 0,
          prop: '',
          label: ''
        }
      ]
    },
    tableList: {
      type: Array,
      default: () => []
    }
  }
}
</script>

<style lang="scss" scoped>
.orderDetailList{
  nav{}
  section{
    .productItem{
      display: flex;
    }
  }
}
</style>
