<template>
  <div class="store_info_page">
    <p
      v-for="(item, index) in storeInfo"
      :key="index"
    >
      <span>{{ item.name }}:</span>
      <span>{{
        item.field === 'effectiveYear' ? item.value + '年' : item.value
      }}</span>
    </p>
  </div>
</template>

<script setup>
import { hidden } from '@/utils'
import { onMounted, ref, toRefs } from 'vue';

const props = defineProps({
  dialog: {
    type: Object,
    default: () => {
    },
  }
})
const { dialog } = toRefs(props)

const storeInfo = ref([
  { name: '店铺名称', value: '', field: 'shopName' },
  { name: '合同有效期', value: '', field: 'effectiveYear' },
  { name: '负责人', value: '', field: 'chargePersonName' },
  { name: '联系电话', value: '', field: 'shopPhone' },
  { name: '联系地址', value: '', field: 'shopAdress' },
])

function getShopInfo (o) {
  storeInfo.value.map((item) => {
    if (item.field === 'shopPhone') {
      item.value = hidden(o[item.field], 3, 3)
    } else if (item.field === 'shopAdress') {
      item.value = hidden(o[item.field], 1, 1)
    } else {
      item.value = o[item.field] || ''
    }
  })
}
onMounted(() => {
  getShopInfo(dialog.value)
})
</script>

<style
    lang="scss"
    scoped
>
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
        // width:130px;
        margin-right: 20px;
      }

      &:nth-of-type(2) {
        color: #666666;
      }
    }
  }
}
</style>
