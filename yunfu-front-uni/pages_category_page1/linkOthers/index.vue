<template>
  <view>
    <web-view :src="url"></web-view>
  </view>
</template>

<script setup>
import {ref} from "vue";
import {onLoad} from "@dcloudio/uni-app";
const url = ref('')
onLoad((e) => {
  url.value = `${e.url}/#/?&username=${e.username}&user=${e.user}`
})
</script>
