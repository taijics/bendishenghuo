<template>
  <el-config-provider :locale="locale">
    <div id="app">
      <el-dialog
        v-model="tipShow"
        title="温馨提示"
        top="30vh"
        width="30%"
        center
      >
        <span>为保护个人隐私信息，系统自动对敏感数据进行脱敏。如需编辑、查看完整信息，可通过“用户隐私二次认证”功能进行验证，验证通过之后，24小时内可查看完整信息。</span>
        <template #footer>
          <span class="dialog-footer">
            <el-button @click="tipShow = false">关闭</el-button>
          </span>
        </template>
      </el-dialog>
      <router-view />
    </div>
  </el-config-provider>
</template>

<script setup>
import { ref, onBeforeMount } from 'vue'
import { getPrivacySwitch } from '@/api/privacy'
import zhCn from 'element-plus/dist/locale/zh-cn.mjs'
import { useStore } from 'vuex'

const { getters } = useStore()
const locale = zhCn
const tipShow = ref(false)
onBeforeMount(() => {
  if (getters['token']) {
    getPrivacy()
  }
})

const getPrivacy = () => {
  getPrivacySwitch().then((res) => {
    var IsTipshow = localStorage.getItem('IsTipshow')
    localStorage.setItem('privacyTime', res.data)
    if (getters['token'] && !IsTipshow && res.data === 0) {
      tipShow.value = true
      localStorage.setItem('IsTipshow', true)
    }
  })
}
</script>
<style lang="scss">
.el-dialog__header {
  background-color: #3a68f2;
  text-align: left;
  margin-right: 0;
}

.el-dialog__title {
  color: #ffffff;
}
</style>
