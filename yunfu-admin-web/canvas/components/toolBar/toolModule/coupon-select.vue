<template>
  <div class="product-select">
    <el-form :inline="true" :model="formData">
      <el-form-item label="">
        <el-input
          v-model="formData.keyword"
          maxlength="20"
          placeholder="请输入优惠券名称"
        />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" @click="onSubmit">查询</el-button>
      </el-form-item>
    </el-form>
    <el-table
      ref="couponTable"
      :data="tableData"
      max-height="500"
      border
      style="width: 100%"
      row-key="productId"
      @selection-change="handleSelectionChange"
    >
      <el-table-column
        width="40"
        type="selection"
        :reserve-selection="true"
        fixed="left"
      />
      <el-table-column prop="couponName" label="优惠券名称" width="180" />
      <el-table-column prop="content" label="内容" />
      <el-table-column prop="effectiveStart" label="活动开始时间" />
      <el-table-column prop="effectiveEnd" label="活动结束时间" />
    </el-table>
    <el-pagination
      :current-page="currentPage"
      :hide-on-single-page="true"
      :page-sizes="[10, 20, 50, 100]"
      :page-size="pageSize"
      layout="total, sizes, prev, pager, next, jumper"
      :total="total"
      @size-change="handleSizeChange"
      @current-change="handleCurrentChange"
    />
  </div>
</template>

<script setup>
import api from '@@/components/canvasShow/config/api'
import Cookies from 'js-cookie'
import { ref, onMounted, toRefs } from 'vue';
import { sendReqMixin } from '@@/components/canvasShow/config/mixin';
const { sendReq } = sendReqMixin();
import { canvasStore } from '@@/store/canvas';
import { storeToRefs } from 'pinia';
const canvasStoreObj = canvasStore();
const { typeId } = storeToRefs(canvasStoreObj);
const props = defineProps({
  selectedCoupon: {
    type: Array,
    default: () => [],
  }
});
const { selectedCoupon } = toRefs(props);
const couponTable = ref()
const formData = ref({
  keyword: '',
})
const currentPage = ref(1)
const total = ref(0)
const pageSize = ref(10)
const multipleSelection = ref([])
const tableData = ref([
  {
    id: 100,
    name: '测试',
  },
])

onMounted(() => {
  getTableData()
})

// 获取优惠券
function getTableData () {
  let _url = ''
  if (typeId.value === 1) {
    _url = `${api.getCoupons}?page=${currentPage.value}&pageSize=${pageSize.value}`
  } else if (typeId.value === 3) {
    _url = `${api.getShopCoupons}?page=${currentPage.value}&pageSize=${
      pageSize.value
    }&shopId=${Cookies.get('cereShopId')}`
  }
  if (formData.value.keyword) {
    _url += `&search=${formData.value.keyword}`
  }
  const params = {
    url: _url,
    method: 'GET',
  }
  sendReq(params, (res) => {
    tableData.value = res.data.list
    if (typeId.value === 1) {
      tableData.value.map(function (value) {
        value.couponName = value.activityName
        value.effectiveStart = value.activityStartTime
        value.effectiveEnd = value.activityEndTime
        return value
      })
    }
    console.log(selectedCoupon.value, 'selectedCoupon')
    total.value = res.data.total
  })
}
// 搜索
function onSubmit () {
  getTableData()
}
// 每页条数改变
function handleSizeChange (val) {
  pageSize.value = val
  getTableData()
}
// 当前页改变
function handleCurrentChange (val) {
  currentPage.value = val
  getTableData()
}
// 多选改变
function handleSelectionChange (val) {
  multipleSelection.value = val
}

defineExpose({
  multipleSelection
})
</script>

<style lang="scss" scoped>
.product-select {
  .el-pagination {
    padding: 0px;
    margin-top: 30px;
  }
  .el-table {
    .img {
      width: 80px;
      height: 80px;
    }
  }
}
</style>
