<template>
  <el-dialog
    v-model="visible"
    :close-on-click-modal="false"
    title="新增ip"
    width="500px"
  >
    <el-form
      ref="formRef"
      :model="form"
      :rules="rules"
      size="small"
      label-width="40px"
    >
      <el-form-item
        label="ip"
        prop="ip"
      >
        <el-input
          v-model="form.ip"
          type="textarea"
          :autosize="{ minRows: 6, maxRows: 6 }"
          placeholder="支持多条批量录入，ip间用英文逗号间隔"
          maxlength="400"
        />
      </el-form-item>
    </el-form>
    <template #footer>
      <span class="dialog-footer">
        <el-button
          @click="doCancel"
        >取消
        </el-button>
        <el-button
          type="primary"
          @click="doSubmit"
        >确认
        </el-button>
      </span>
    </template>
  </el-dialog>
</template>

<script setup>
import { addBlack } from '@/api/risk'
import { ref } from 'vue';
const visible = ref(false)
const form = ref({
  ip: '',
  type: 1,
})
const rules = {
  ip: [{ required: true, message: '请输入ip', trigger: 'blur' }],
}

function show (row) {
  form.value = {
    ip: '',
    type: 1,
  }
  visible.value = true
}
function doCancel () {
  visible.value = false
}

const $emit = defineEmits(['reset'])
const formRef = ref()
function doSubmit () {
  formRef.value.validate((valid) => {
    if (valid) {
      addBlack(form.value)
        .then((res) => {
          ElMessage({
            message: '新增成功',
            type: 'success',
          })
          $emit('reset')
        })
        .finally(() => {
          visible.value = false
        })
    }
  })
}
defineExpose({ show })
</script>
