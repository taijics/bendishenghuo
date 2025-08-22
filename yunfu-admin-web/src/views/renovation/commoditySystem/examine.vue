<template>
  <el-dialog
    v-model="visible"
    title="上架审核"
    width="30%"
    style="margin-top: 10%"
  >
    <el-form :model="form">
      <el-form-item label="审核状态" label-width="120px">
        <el-radio-group v-model="form.shelveState">
          <el-radio :label="1">通过</el-radio>
          <el-radio :label="3">驳回</el-radio>
        </el-radio-group>
      </el-form-item>
      <el-form-item
        v-if="form.shelveState == 3"
        label="驳回原因"
        label-width="120px"
      >
        <el-input
          v-model="form.reject"
          maxlength="200"
          type="textarea"
          autocomplete="off"
        />
      </el-form-item>
    </el-form>
    <template #footer>
      <span class="dialog-footer">
        <el-button @click="visible = false">取 消</el-button>
        <el-button type="primary" @click="handleSubmit">确 定</el-button>
      </span>
    </template>
  </el-dialog>
</template>

<script setup>
import { ref, shallowRef } from 'vue';
import {
  examine,
} from '@/api/commodity'

const emits = defineEmits(['check'])

let visible = shallowRef(false);
let form = ref({})

function open ({
  id,
}) {
  visible.value = true
  if (id) {
    form.value.productId = id
  }
  form.value.reject = ''
}
function cancel () {
  visible.value = false
}

function handleSubmit () {
  if (form.value.shelveState === 3 && form.value.reject === '') {
    return ElMessage.warning('请输入驳回原因')
  }
  examine(form.value).then(res => {
    if (res.code === '') {
      cancel()
      if (form.value.shelveState === 1) {
        ElMessage.success('审核成功')
      } else {
        ElMessage.success('已驳回')
      }
      emits('check')
    }
  })
}

defineExpose({
  open,
  cancel
})
</script>