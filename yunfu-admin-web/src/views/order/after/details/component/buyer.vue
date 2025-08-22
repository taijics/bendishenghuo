<template>
  <div class="store_info_page">
    <p v-for="(item, index) in storeInfo" :key="index">
      <span>{{ item.name }}:</span>
      <span>{{ item.value }}</span>
    </p>
  </div>
</template>

<script setup>
import { onMounted, ref, toRefs } from 'vue';

const props = defineProps({
  dialog: {
    type: Object,
    default () {
      return {}
    },
  }
})
const { dialog } = toRefs(props)
const storeInfo = ref([
  { name: '下单账户', value: '', field: 'name' },
  { name: '注册时间', value: '', field: 'registerTime' },
  { name: '手机号', value: '', field: 'phone' },
  { name: '订单总数', value: '', field: 'orders' },
  { name: '售后单数', value: '', field: 'afters' },
  { name: '售后成功率', value: '', field: 'rate' },
])

function getOrderInfo (o) {
  storeInfo.value.map((item) => {
    item.value = o[item.field] || ''
  })
}

onMounted(() => {
  getOrderInfo(dialog.value)
})
</script>

<style lang="scss" scoped>
.store_info_page {
  padding: 20px 10%;
  overflow: hidden;
  p {
    width: 50%;
    float: left;
    line-height: 30px;
    span {
      font-size: 16px;
      color: #333333;
      display: inline-block;
      &:nth-of-type(1) {
        // width: 130px;
        margin-right: 20px;
      }
      &:nth-of-type(2) {
        color: #666666;
      }
    }
  }
}
</style>
