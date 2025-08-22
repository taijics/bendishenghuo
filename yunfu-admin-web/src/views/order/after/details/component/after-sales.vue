<template>
  <div>
    <div v-if="dialog.allow" class="allow">
      <h1>建议联系商家，由商家操作同意退款。</h1>
      <p>
        若你同意售后，客户申请的类型为仅退款时，将自动从商家账户退款给买家
        若客户申请的类型为退款退货时，本售后将转为待买家退回物品的状态，有可能被商家拒收
      </p>
    </div>
    <div v-else class="refuse">
      <p>拒绝售后，本售后将自动关闭，但买家有权再次发起。</p>
    </div>

    <el-form label-width="120px" label-position="top" :model="form">
      <el-form-item label="备注内容">
        <el-input
          v-model="form.remark"
          maxlength="200"
          type="textarea"
          placeholder="请填写相关内容"
        />
      </el-form-item>
    </el-form>

    <div class="btn_list">
      <el-button type="primary" @click="agree(dialog)">{{
        dialog.btnName
      }}</el-button>
      <el-button @click="cancel">取消</el-button>
    </div>
  </div>
</template>

<script setup>
// import { handles } from '@/api/after'
import { ref } from 'vue';

const props = defineProps({
  dialog: {
    type: Object,
    default: () => {},
  }
})
const form = ref({
  remark: '',
})
const emits = defineEmits(['dialogs', 'close'])
function agree (dialog) {
  dialog.remark = form.value.remark
  emits('dialogs', dialog)
}
function cancel () {
  emits('close')
}``
</script>

<style lang="scss" scoped>
h1 {
  font-size: 24px;
  font-weight: 500;
  color: rgba(51, 51, 51, 1);
  text-align: center;
  width: 50%;
  margin: 30px auto;
}
p {
  font-size: 16px;
  color: rgba(51, 51, 51, 1);
  text-align: center;
  width: 50%;
  margin: 30px auto;
}

.btn_list {
  width: 200px;
  margin: 20px auto;
}

:deep(.el-textarea) {
  width: 100%;
  textarea {
    min-height: 150px !important;
  }
}
</style>
