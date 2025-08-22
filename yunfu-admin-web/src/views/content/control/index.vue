<template>
  <div class="main-con">
    <div>
      <span>自动审核</span>
      <el-switch
        v-model="enable"
        size="large"
        style="margin: 0 10px 0 20px;"
        @change="setControl"
      />
      <span>{{enable?"开启":"关闭"}}</span>
    </div>
  </div>
</template>

<script setup>
import {ref, onBeforeMount} from "vue";
import {
  controlConfig,
  getControl
} from '@/api/content';

const enable =  ref(false);

const setControl = async() => {
  const {code} = await controlConfig({enable: enable.value});
  if(code==='') {}
}

const controlInfo = async() => {
  const {code, data} = await getControl();
  if(code==='') enable.value = data;
}

onBeforeMount(() => {
  controlInfo();
})
</script>

<style lang="scss" scoped>
.main-con {
  background: #ffffff;
  padding: 20px;
}
</style>