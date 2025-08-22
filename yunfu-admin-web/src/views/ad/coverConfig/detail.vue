<template>
  <el-dialog
    v-model="visible"
    class="viewDialog"
    :close-on-click-modal="false"
    title="弹窗广告详情"
    width="800px"
  >
    <el-descriptions class="margin-top" :column="1" border>
      <el-descriptions-item label="广告名称">
        {{ form.name }}
      </el-descriptions-item>
      <el-descriptions-item label="上线时间">
        {{ form.startTime }} - {{ form.endTime }}
      </el-descriptions-item>
      <el-descriptions-item label="弹窗图片">
        <a :href="form.popupImg" style="color: #42b983" target="_blank"><img :src="form.popupImg" alt="点击打开" class="img-ad" /></a>
      </el-descriptions-item>
      <el-descriptions-item label="关闭按钮">
        <a :href="form.closeImg" style="color: #42b983" target="_blank"><img :src="form.closeImg" alt="点击打开" class="el-avatar" /></a>
      </el-descriptions-item>
      <el-descriptions-item label="跳转类型">
        <span v-if="form.jumpType === 0">不跳转</span>
        <span v-if="form.jumpType === 1">商品</span>
        <span v-if="form.jumpType === 2">分类</span>
        <span v-if="form.jumpType === 3">平台券</span>
        <span v-if="form.jumpType === 4">跳转小程序</span>
        <span v-if="form.jumpType === 5">公众号文章</span>
      </el-descriptions-item>
      <el-descriptions-item v-if="form.jumpType !== 0" label="链接配置">
        <div v-if="form.jumpType === 1">
          {{ jumpContent.name }}
        </div>
        <div v-if="form.jumpType === 2">
          {{ jumpContent.name }}
        </div>
        <div v-if="form.linkType === 3">
          <span v-for="(item, index) in jumpContent.items" :key="index">
            <i v-if="index !== 0">,</i> {{ item.name }}
          </span>
        </div>
        <div v-if="form.linkType === 4">
          <el-descriptions class="margin-top" :column="1" border>
            <el-descriptions-item label="小程序app id">
              {{ jumpContent.appId }}
            </el-descriptions-item>
            <el-descriptions-item label="页面路径">
              {{ jumpContent.link }}
            </el-descriptions-item>
          </el-descriptions>
        </div>
        <div v-if="form.linkType === 5">
          <el-descriptions class="margin-top" :column="1" border>
            <el-descriptions-item label="页面路径">
              {{ jumpContent.link }}
            </el-descriptions-item>
          </el-descriptions>
        </div>
      </el-descriptions-item>
      <el-descriptions-item label="触发条件">
        <span v-if="form.triggerCondition === 1">每天进入商城首页</span>
        <span v-if="form.triggerCondition === 2">支付成功后</span>
      </el-descriptions-item>
      <el-descriptions-item label="针对会员">
        <span v-if="form.applyGroup === 1">全体成员</span>
        <span v-if="form.applyGroup === 2">会员</span>
      </el-descriptions-item>
    </el-descriptions>
    <template #footer>
      <div class="dialog-footer">
        <el-button @click="visible = false">确实</el-button>
      </div>
    </template>
  </el-dialog>
</template>

<script setup>
import { ref } from 'vue'
const visible = ref(false)
const form = ref({})
const jumpContent = ref({})

const show = (row) => {
  form.value = JSON.parse(JSON.stringify(row))
  jumpContent.value = row.jumpContent ? JSON.parse(row.jumpContent) : {}
  visible.value = true
}
defineExpose({ show })
</script>

<style lang="scss" scoped>
.viewDialog {
  .img-ad {
    height: 200px;
  }
  :deep(.el-descriptions-item__label) {
    width: 130px;
  }
}
</style>
