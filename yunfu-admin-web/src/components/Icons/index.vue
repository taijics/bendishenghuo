<template>
  <el-dialog
    :model-value="visible"
    :close-on-click-modal="false"
    title="icon"
    width="60%"
    top="50px"
    center
    @close="close"
  >
    <div class="search_bar">
      <el-input v-model="name" :prefix-icon="Search" placeholder="请输入需要搜索的icon名称" @keyup.enter.native="search" />
    </div>
    <el-tabs v-model="iconClassify">
      <el-tab-pane v-for="(item, index) in iconList" :key="index" :label="item.title + '（' + item.list.length + '）'" :name="index">
        <ul v-if="item.list?.length">
          <li v-for="icon in item.list" :key="icon" :class="{active: icon === iconName}" @click.native="chooseIcon(icon)">
            <icon :icon="icon" size="24" />
            <p>{{ icon }}</p>
          </li>
        </ul>
        <el-empty v-else :image-size="200" />
      </el-tab-pane>
    </el-tabs>
    <template #footer>
      <span class="dialog-footer">
        <el-button @click="visible = false">取 消</el-button>
        <el-button type="primary" @click="confirm">确 定</el-button>
      </span>
    </template>
  </el-dialog>
</template>
<script setup>
import { ref } from 'vue'
import { iconData } from './iconData'
import { Search } from '@element-plus/icons-vue'

const visible = ref(false)
const name = ref('')
const iconList = ref([])
const iconClassify = ref(0)
const iconName = ref('')
const emits = defineEmits(['choose'])

const open = (icon) => {
  init()
  if (icon) {
    for (let i = 0; i < iconList.value.length; i++) {
      for (let j = 0; j < iconList.value[i].list.length; j++) {
        if (iconList.value[i].list[j] === icon) {
          iconClassify.value = i
          iconName.value = iconList.value[i].list[j]
        }
      }
    }
  }
  visible.value = true
}
defineExpose({ open })
const close = () => {
  visible.value = false
}

const init = () => {
  iconList.value = iconData
  name.value = ''
  iconClassify.value = 0
  iconName.value = ''
}
const search = () => {
  iconList.value = JSON.parse(JSON.stringify(iconData))
  for (let i = 0; i < iconList.value.length; i++) {
    iconList.value[i].list = iconData[i].list.filter(item => item.indexOf(name.value.trim()) !== -1)
  }
}
const chooseIcon = (name) => {
  iconName.value = name
}
const confirm = () => {
  emits('choose', iconName.value)
  visible.value = false
}

</script>
<style lang="scss" scoped>
.el-tabs {
ul {
  display: flex;
  flex-wrap: wrap;
  li {
    width: calc(12.5% - 12px);
    cursor: pointer;
    padding: 15px;
    border: 1px solid #E0E0E0;
    text-align: center;
    margin: 5px;
    &>p {
      overflow: hidden;
      text-overflow: ellipsis;
      white-space: nowrap;
      margin-top: 5px;
    }
    &.active,&:hover {
      color: #409EFE;
      border-color: #409EFE;
      .el-icon {
        color: #409EFE;
      }
    }
  }
}
.el-pagination {
  margin-top: 20px;
}
}
</style>
