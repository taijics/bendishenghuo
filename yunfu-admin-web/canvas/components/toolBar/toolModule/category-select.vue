<template>
  <el-cascader
    ref="cascader"
    style="width: 100%"
    :options="categoryList"
    :props="{
      checkStrictly: true,
      label: 'categoryName',
      value: 'id',
      children: 'childs',
    }"
    clearable
  />
</template>

<script setup>
import { ref, onMounted } from 'vue';
import api from '@@/components/canvasShow/config/api';
import { checkEmptyChild } from '@@/config/common';
import { sendReqMixin } from '@@/components/canvasShow/config/mixin';
const { sendReq } = sendReqMixin();
const categoryList = ref([]);
const cascader = ref()
onMounted(() => {
  getCategory();
});

// 获取类别
function getCategory () {
  const params = {
    url: api.getClassify,
    method: 'GET',
  };
  sendReq(params, (res) => {
    categoryList.value = res.data;
    checkEmptyChild(categoryList.value);
  });
}

defineExpose({
  cascader
})
</script>
