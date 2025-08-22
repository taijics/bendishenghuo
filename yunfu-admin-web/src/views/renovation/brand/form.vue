<template>
  <div>
    <el-dialog
      v-model="dialogVisible"
      :title="title"
      width="50%"
      :before-close="handleClose"
    >
      <el-form ref="formRef" :model="form" :rules="formRules" label-width="80px">
        <el-form-item label="名称" prop="brandName">
          <el-input
            v-model="form.brandName"
            maxlength="20"
            placeholder="请输入品牌名称"
          />
        </el-form-item>
        <el-form-item label="logo" prop="brandLogo">
          <ImageUpload v-model:brandLogo="form.brandLogo" :limit="1" />
        </el-form-item>
      </el-form>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="handleClose">取 消</el-button>
          <el-button
            type="primary"
            :loading="loading"
            @click="handleSubmit"
          >确 定</el-button>
        </span>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import ImageUpload from '@/components/ImageUpload/index.vue'
import { addBrand, updateBrand } from '@/api/renovation'
import { ref, toRefs, watch } from 'vue';
const Form = function () {
  this.id = null
  this.brandLogo = null
  this.brandName = null
}
const props = defineProps({
  item: {
    // eslint-disable-next-line vue/require-prop-type-constructor
    type: Object || null,
    default: () => ({}),
  }
})
const { item } = toRefs(props)
const loading = ref(false)
const title = ref('新增品牌')
const formRules = {
  brandName: [
    { required: true, message: '请输入品牌名称', trigger: 'blur' },
    { max: 20, message: '品牌名称应小于20个字符', trigger: 'blur' },
  ],
  brandLogo: [
    { required: true, message: '请上传品牌logo', trigger: 'blur' },
  ],
}
const form = ref({})
const dialogVisible = ref(false)
watch(item, () => {
  if (item.value) {
    form.value = JSON.parse(JSON.stringify(item.value))
    if (form.value.id !== null && form.value.id !== undefined) {
      title.value = '修改品牌'
    } else {
      title.value = '新增品牌'
    }
  } else {
    form.value = new Form()
  }
})
const formRef = ref()

function open () {
  dialogVisible.value = true
}
function handleSubmit () {
  formRef.value.validate(async (val) => {
    loading.value = true
    if (!val) return ElMessage.warning('请完善表单')
    if (form.value.id != null) {
      await updateBrand(form.value)
    } else {
      await addBrand(form.value)
    }
    ElMessage.success('操作成功')
    loading.value = false
    handleClose()
  })
}
const $emit = defineEmits(['confirm'])
defineExpose({ open })
function handleClose () {
  $emit('confirm', form)
  formRef.value.resetFields()
  dialogVisible.value = false
}
</script>
