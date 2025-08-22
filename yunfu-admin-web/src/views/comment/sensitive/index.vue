<template>
  <div class="sensitive">
    <el-card class="box-card">
      <template #header>
        <div class="header">
          <span style="font-size: 18px;font-weight: bold;">敏感词</span>
          <el-button
            class="saveButton"
            type="primary"
            @click="save"
          >保存
          </el-button>
        </div>
      </template>
      <el-form ref="formRef" :model="form" label-width="80px">
        <el-form-item label="状态">
          <el-radio-group v-model="form.state">
            <el-radio label="1">开启</el-radio>
            <el-radio label="0">关闭</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="处理措施">
          <el-radio-group v-model="form.handleMeasures">
            <el-radio label="1">禁止发布</el-radio>
            <el-radio label="2">需要审核</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="敏感词库">
          <el-input
            v-model="form.sensitiveWord"
            maxlength="400"
            placeholder="1.首次添加请直接输入保存，添加多个敏感词请用逗号隔开，如：'敏感词1,敏感词...' 2.二次添加请点击编辑，在原有的敏感词后再输入"
            type="textarea"
          />
        </el-form-item>
      </el-form>
      <el-table
        v-loading="tableLoading"
        :data="tableData"
        border
        :header-cell-style="{ background: '#EEF3FF', color: '#333333' }"
        tooltip-effect="dark"
        style="width: 100%"
        class="dataTable"
      >
        <el-table-column label="敏感词名称" width="220">
          <template #default="scope">{{
            scope.row.sensitiveWord
          }}</template>
        </el-table-column>
        <el-table-column label="是否开启">
          <template #default="scope">
            <span v-if="scope.row.state">是</span>
            <span v-else>否</span>
          </template>
        </el-table-column>
        <el-table-column label="处理措施">
          <template #default="scope">
            <span v-if="scope.row.handleMeasures == 1">禁止发布</span>
            <span v-else>需要审核</span>
          </template>
        </el-table-column>
        <el-table-column label="操作">
          <template #default="scope">
            <div class="btnList">
              <el-button type="primary" link @click="run(scope.row)">编辑 </el-button>
            </div>
          </template>
        </el-table-column>
      </el-table>
    </el-card>
  </div>
</template>

<script setup>
import { sensitiveAdd, sensitiveGetAll, sensitiveUpdate } from '@/api/comment'
import { onMounted, ref } from 'vue';

let form = ref({
  sensitiveWord: '', // 敏感词库
  state: '1', // 是否开启 1-是 0-否
  handleMeasures: '2', // 处理措施  1-禁止发布 2-需审核
})
let tableLoading = ref(false)
let tableData = ref([])
let editState = ref(false)

onMounted(() => {
  getAll()
})

// 添加敏感词
function save () {
  if (form.value.sensitiveWord === '') {
    ElMessage.error('请输入敏感词')
    return
  }
  const fn = editState.value ? sensitiveUpdate : sensitiveAdd
  fn(form.value).then(res => {
    if (res.code === '') {
      ElMessage.success('操作成功')
      getAll()
      form.value.sensitiveWord = ''
      if (!editState.value) {
        editState.value = false
      }
    }
  })
}

function getAll () {
  tableLoading.value = true
  sensitiveGetAll().then(res => {
    tableData.value = res.data
    form.value.id = res.data[0].id
  }).finally(() => {
    tableLoading.value = false
  })
}

function run (row) {
  editState.value = true
  form.value = {
    sensitiveWord: row.sensitiveWord, // 敏感词库
    state: row.state.toString(), // 是否开启 1-是 0-否
    handleMeasures: row.handleMeasures.toString(), // 处理措施  1-禁止发布 2-需审核
    id: row.id,
  }
}
</script>

<style lang="scss" scoped>
.header {
  width: 100%;
  display: flex;
  align-items: center;
  justify-content: space-between;
}
</style>
