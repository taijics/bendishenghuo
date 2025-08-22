<template>
  <div class="form_content">
    <el-dialog
      v-model="diaShow"
      :close-on-click-modal="false"
      :title="dialogOption.title"
      width="40%"
      :before-close="handleClose"
    >
      <el-form
        ref="formRef"
        :model="form"
        :rules="formRules"
        label-width="120px"
      >
        <el-form-item
          label="渠道名称："
          prop="channelName"
        >
          <el-input
            v-model="form.channelName"
            maxlength="20"
            clearable
            type="text"
            placeholder="请输入渠道名称"
          />
        </el-form-item>
      </el-form>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="handleClose">取 消</el-button>
          <el-button
            type="primary"
            :loading="dialogOption.loading"
            @click="handleConfirm"
          >确 定</el-button>
        </span>
      </template>

    </el-dialog>
  </div>
</template>

<script setup>
import { add, edit } from '@/api/channel'
import { computed, ref, toRefs, watch } from 'vue';

const props = defineProps({
  show: {
    type: Boolean,
    default: () => false,
  },
  item: {
    // eslint-disable-next-line vue/require-prop-type-constructor
    type: Object,
    default: () => ({
      id: null,
      channelName: null,
    }),
  },
})
const { show, item } = toRefs(props)
const dialogOption = ref({
  loading: false,
  title: '新增渠道',
})
const form = ref({
  id: null,
  channelName: null,
})
const formRules = {
  channelName: [
    { required: true, message: '请输入渠道名称', trigger: 'blur' },
    {
      min: 1,
      max: 20,
      message: '渠道名称长度在1-20个字符',
      trigger: 'blur',
    },
  ],
}
const $emit = defineEmits(['update:show', 'confirm', 'close'])
const diaShow = computed({
  get: () => show.value,
  set: (value) => $emit('update:show', value)
})
watch(item, () => {
  if (item.value?.id) {
    dialogOption.value.title = '修改渠道'
    form.value = item
  } else {
    dialogOption.value.title = '添加渠道'
    handleResetForm()
  }
}, { deep: true })
const formRef = ref(null)

function handleConfirm () {
  formRef.value.validate(async (val) => {
    if (!val) return ElMessage.error('请完善表单')
    dialogOption.value.loading = true
    if (form.value.id) {
      await edit(form.value)
    } else {
      await add(form.value)
    }
    dialogOption.value.loading = false
    ElMessage.success('添加成功')
    handleResetForm()
    $emit('confirm', form.value)
    diaShow.value = false
  })
}

function handleClose () {
  handleResetForm()
  diaShow.value = false
  $emit('close', form.value)
}

function handleResetForm () {
  formRef.value?.resetFields()
}
</script>

<style lang="scss" scoped>
:deep(.el-form-item) {
  .el-input {
    .el-input__inner {
      height: 38px;
    }
  }
}
</style>
