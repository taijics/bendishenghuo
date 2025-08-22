<template>
  <div>
    <div class="pending">
      <!-- 搜索 -->
      <div class="formSearch">
        <el-form :inline="true" :model="formInline">
          <el-form-item label="店铺名称">
            <el-input
              v-model="formInline.shopName"
              maxlength="20"
              placeholder="请输入店铺名称"
            />
          </el-form-item>
          <el-form-item>
            <el-button type="primary" plain @click="onSubmit">查询</el-button>
          </el-form-item>
        </el-form>
      </div>
      <!-- 表格 -->
      <div class="tableBox">
        <el-table
          :data="tableData"
          border
          :header-cell-style="{ background: '#EEF3FF', color: '#333333' }"
          tooltip-effect="dark"
          style="width: 100%"
          @selection-change="handleSelectionChange"
        >
          <el-table-column type="selection" />
          <el-table-column label="店铺名称" width="220">
            <template #default="scope">{{ scope.row.shopName }}</template>
          </el-table-column>
          <el-table-column prop="chargePersonName" label="负责人" />
          <el-table-column prop="chargePersonPhone" label="联系电话" />
          <el-table-column label="合同状态">
            <template #default="scope">
              <span v-if="scope.row.contractState === 0">无效</span>
              <span v-if="scope.row.contractState === 1">有效</span>
            </template>
          </el-table-column>
          <el-table-column prop="createTime" label="创建时间" />
        </el-table>
        <div class="fenye">
          <el-pagination
            :current-page="currentPage"
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
</template>

<script setup>
import { businessListGetAll } from '@/api/business'
import { nextTick, onMounted, ref } from 'vue';
const activeName = ref('first')
const formInline = ref({
  shopName: '', // 店铺名称
  shopCode: '', // 店铺编码
  chargePersonName: '', // 店铺负责人
  contractState: '', // 合同状态 1-有效 0-无效
  page: 1, // 当前页
  pageSize: 10, // 每页记录数
})
const disabled = ref(false)
const total = ref(1)
const tableData = ref([])
const currentPage = ref(1)
const userState = ref(1)
const multipleSelection = ref([])
onMounted(() => {
  getAll(formInline.value)
})
function handleSizeChange (val) {
  formInline.value.pageSize = val
  getAll(formInline.value)
}
function handleCurrentChange (val) {
  formInline.value.page = val
  getAll(formInline.value)
}
function handleClick (tab, event) {
  console.log(tab, event)
}
function onSubmit () {
  currentPage.value = 1
  getAll(formInline.value)
}
function next () {
  activeName.value = 'second'
}
const ruleForm = ref()
const ruleFormInfo = ref()
function closeFn () {
  nextTick(() => {
    ruleForm.value.clearValidate()
    ruleFormInfo.value.clearValidate()
    dialogVisible.value = false
  })
}
const $emit = defineEmits(['selectShop'])
function handleSelectionChange (val) {
  multipleSelection.value = val
  $emit('selectShop', multipleSelection.value)
}
function search () {}
async function getAll (formInline) {
  const res = await businessListGetAll(formInline)
  total.value = res.data.total
  tableData.value = res.data.list
}
</script>

<style lang="scss" scoped>
.pending {
  padding: 30px;
}
.fenye {
  margin-top: 20px;
}
.elipt {
  width: 50%;
}
.elspan {
  margin-left: 10px;
}
</style>
