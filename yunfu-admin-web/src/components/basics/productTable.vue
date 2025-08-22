<template>
  <el-dialog
    v-model="visible"
    :append-to-body="true"
    :close-on-click-modal="false"
    width="1000px"
    title="选择商品"
  >
    <div class="proSelectBox">
      <!-- 搜索 -->
      <div class="topSearch">
        <div class="formSearch">
          <el-form :inline="true" :model="formData">
            <el-form-item label="">
              <el-input
                v-model="formData.keyword"
                maxlength="20"
                class="inputKeyword"
                placeholder="店铺名称/商品ID/商品分组"
              />
            </el-form-item>
            <el-form-item>
              <el-button type="primary" plain @click="search">查询</el-button>
              <el-button plain @click="clear">重置</el-button>
            </el-form-item>
          </el-form>
        </div>
      </div>
      <!-- 表格 -->
      <div class="tableBox">
        <el-table
          ref="multipleTableRef"
          :data="tableData"
          max-height="500"
          border
          row-key="productId"
          style="width: 100%"
          @selection-change="handleSelectionChange"
        >
          <el-table-column
            v-if="props.isMultiple"
            width="40"
            type="selection"
            :reserve-selection="true"
            fixed="left"
          />
          <el-table-column v-else label="" width="35" align="center">
            <template #default="scope">
              <el-radio v-model="tableRadio" :label="scope.row.productId" @change="radioChange" />
            </template>
          </el-table-column>
          <el-table-column label="产品主图" width="180" align="center">
            <template #default="scope">
              <el-image
                style="width: 80px; height: 80px"
                :src="scope.row.image"
                fit="contain"
              />
            </template>
          </el-table-column>
          <el-table-column prop="productName" label="产品名称" width="180" />
          <el-table-column prop="productId" label="产品ID" />
          <el-table-column prop="price" label="售价" />
          <el-table-column prop="originalPrice" label="原价" />
          <el-table-column prop="stockNumber" label="库存" />
          <el-table-column prop="number" label="销量" />
        </el-table>
        <div class="fenye">
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
      </div>
    </div>
    <template #footer>
      <span class="dialog-footer">
        <el-button @click="visible = false">取 消</el-button>
        <el-button type="primary" @click="submit">确 定</el-button>
      </span>
    </template>
  </el-dialog>
</template>

<script setup>
import { ref, onBeforeMount } from 'vue'
import { getProducts } from '@/api/public'

const props = defineProps({
  proId: {
    type: Number,
    default: 0,
  },
  proIds: {
    type: Array,
    default: () => [],
  },
  isMultiple: {
    type: Boolean,
    default: false,
  },
})
const multipleTableRef = ref(null)
const visible = ref(false)
const tableRadio = ref('')
const radioSelection = ref({})
const formData = ref({
  keyword: '',
  status: '',
})
const currentPage = ref(1)
const total = ref(0)
const pageSize = ref(10)
const tableData = ref([])
const multipleSelection = ref([])
const emits = defineEmits(['doSubmit'])

onBeforeMount(() => {
  getTableData()
})

const open = () => {
  visible.value = true
}
defineExpose({ open })
// 获取产品信息
const getTableData = () => {
  const params = {
    page: currentPage.value,
    pageSize: pageSize.value,
    shelveState: 1,
  }
  if (formData.value.keyword) {
    params.search = formData.value.keyword
  }
  getProducts(params).then((res) => {
    tableData.value = res.data.list
    total.value = res.data.total
    // 表格斌值
    if (props.isMultiple) {
      if (props.proIds.length > 0) {
        tableData.value.forEach((row) => {
          for (let i = 0; i < props.proIds.length; i++) {
            if (props.proIds[i] === row.id) {
              multipleTableRef.value.toggleRowSelection(row, true)
            }
          }
        })
      }
    } else {
      if (props.proId !== 0) {
        tableRadio.value = props.proId
        tableData.value.forEach((row) => {
          if (props.proId === row.id) {
            radioSelection.value = row
          }
        })
      }
    }
  })
}
// 搜索
const search = () => {
  getTableData()
}
const clear = () => {
  formData.value.keyword = ''
  getTableData()
}
// 每页条数改变
const handleSizeChange = (val) => {
  pageSize.value = val
  getTableData()
}
// 当前页改变
const handleCurrentChange = (val) => {
  currentPage.value = val
  getTableData()
}
// 多选改变
const handleSelectionChange = (val) => {
  multipleSelection.value = val
}
// 单选改变
const radioChange = (val) => {
  tableData.value.forEach(i => {
    if (i.productId === val) {
      radioSelection.value = i
    }
  })
}
// 提交
const submit = () => {
  if (props.isMultiple) {
    emits('doSubmit', multipleSelection.value)
  } else {
    emits('doSubmit', radioSelection.value)
  }
  visible.value = false
}
</script>

<style scoped>
.proSelectBox .formSearch .inputKeyword {
  width: 200px;
}
.fenye {
  margin-top: 20px;
}
</style>
