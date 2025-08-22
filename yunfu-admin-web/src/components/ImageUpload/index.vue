<template>
  <div class="component-upload-image">
    <div v-if="false" class="imgBox">
      <div v-for="item in files" :key="item.url" class="imgItem">
        <div class="dot">X</div>
        <img :src="item.url" />
      </div>
    </div>
    <el-upload
      multiple
      :action="uploadFileUrl"
      list-type="picture-card"
      :on-success="handleUploadSuccess"
      :before-upload="handleBeforeUpload"
      :limit="limit"
      :on-error="handleUploadError"
      :on-exceed="handleExceed"
      name="file"
      :on-remove="handleRemove"
      :show-file-list="true"
      :headers="headers"
      :file-list="files"
      :on-preview="handlePictureCardPreview"
      :class="{ hide: files.length >= limit }"
    >
      <el-icon><Plus /></el-icon>
    </el-upload>

    <!-- 上传提示 -->
    <div v-if="showTip" slot="tip" class="el-upload__tip">
      请上传
      <template v-if="fileSize">
        大小不超过 <b style="color: #f56c6c">{{ fileSize }}MB</b>
      </template>
      <template v-if="fileType">
        格式为 <b style="color: #f56c6c">{{ fileType.join('/') }}</b>
      </template>
      的文件
    </div>

    <el-dialog
      v-model="dialogVisible"
      title="预览"
      width="800"
      append-to-body
    >
      <img
        :src="dialogImageUrl"
        style="display: block; max-width: 100%; margin: 0 auto"
      />
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, toRefs, computed, watch } from 'vue'
import { uploadUrl } from '@/utils/request'
const props = defineProps({
  brandLogo: {
    type: String || Object || Array,
    default: ''
  },
  // 图片数量限制
  limit: {
    type: Number,
    default: 5,
  },
  // 大小限制(MB)
  fileSize: {
    type: Number,
    default: 5,
  },
  // 文件类型, 例如['png', 'jpg', 'jpeg']
  fileType: {
    type: Array,
    default: () => ['png', 'jpg', 'jpeg'],
  },
  // 是否显示提示
  isShowTip: {
    type: Boolean,
    default: true,
  },
})

const { brandLogo, limit, fileSize, fileType, isShowTip } = toRefs(props)

const number = ref(0)
const uploadList = ref([])
const dialogImageUrl = ref('')
const dialogVisible = ref(false)
const hideUpload = ref(false)
const uploadFileUrl = ref(uploadUrl) // 请求地址
const headers = ref({ Authorization: '' }) // 设置上传的请求头部
const files = ref([])
const showTip = computed(() => isShowTip.value && (fileType.value || fileSize.value)) // 是否显示提示

const emits = defineEmits(['update:brandLogo'])

watch(() => brandLogo, (newVal) => {
  if (newVal.value) {
    let list = Array.isArray(newVal.value) ? newVal.value : newVal.value.split(',')
    files.value = list.map(item => {
      if (typeof item === 'string') {
        item = { name: item, url: item }
      }
      return item
    })
  } else {
    files.value = []
    return []
  }
}, { deep: true, immediate: true })

// 删除图片
function handleRemove (file, fileList) {
  const findex = files.value.map((f) => f.name).indexOf(file.name)
  if (findex > -1) {
    files.value.splice(findex, 1)
    emits('update:brandLogo', listToString(files.value))
  }
}
// 上传成功回调
function handleUploadSuccess (res) {
  uploadList.value.push({ name: res.data.url, url: res.data.url })
  if (uploadList.value.length === number.value) {
    files.value = files.value.concat(uploadList.value)
    uploadList.value = []
    number.value = 0
    emits('update:brandLogo', listToString(files.value))
    ElMessage.success('上传成功')
    // this.$modal.closeLoading()
  }
}
// 上传前loading加载
function handleBeforeUpload (file) {
  let isImg = false
  if (fileType.value.length) {
    let fileExtension = ''
    if (file.name.lastIndexOf('.') > -1) {
      fileExtension = file.name.slice(file.name.lastIndexOf('.') + 1)
    }
    isImg = fileType.value.some((type) => {
      if (file.type.indexOf(type) > -1) return true
      if (fileExtension && fileExtension.indexOf(type) > -1) return true
      return false
    })
  } else {
    isImg = file.type.indexOf('image') > -1
  }
  if (!isImg) {
    ElMessage.error(
      `文件格式不正确, 请上传${fileType.value.join('/')}图片格式文件!`
    )
    return false
  }
  if (fileSize.value) {
    const isLt = file.size / 1024 / 1024 < fileSize.value
    if (!isLt) {
      ElMessage.error(`上传头像图片大小不能超过 ${fileSize.value} MB!`)
      return false
    }
  }
  ElMessage.warning('正在上传图片，请稍候...')
  number.value++
}
// 文件个数超出
function handleExceed () {
  ElMessage.error(`上传文件数量不能超过 ${limit.value} 个!`)
}
// 上传失败
function handleUploadError () {
  ElMessage.error('上传图片失败，请重试')
  // this.$modal.closeLoading()
}
// 预览
function handlePictureCardPreview (file) {
  dialogImageUrl.value = file.url
  dialogVisible.value = true
}
// 对象转成指定字符串分隔
function listToString (list, separator) {
  let strs = ''
  let listArr = []
  // separator = separator || ','
  for (const i in list) {
    listArr.push(list[i].url)
    // strs += list[i].url + separator
  }
  strs = listArr.join(',')
  // return strs !== '' ? strs.substr(0, strs.length - 1) : ''
  return strs
}
</script>

<style lang="scss" scoped>
// .el-upload--picture-card 控制加号部分
:deep(.hide .el-upload--picture-card) {
  display: none;
}

// 去掉动画效果
:deep(.el-list-enter-active),
:deep(.el-list-leave-active) {
  transition: all 0s;
}

:deep(.el-list-enter),
.el-list-leave-active {
  opacity: 0;
  transform: translateY(0);
}

.imgBox {
  display: flex;
  flex-wrap: wrap;

  .imgItem {
    position: relative;
    width: 100px;
    height: 100px;
    .dot {
      position: absolute;
      right: -10px;
      top: -10px;
      width: 20px;
      height: 20px;
      color: #fff;
      background-color: red;
      text-align: center;
      line-height: 20px;
      border-radius: 50%;
      cursor: pointer;
    }

    img {
      width: 100%;
      height: 100%;
      margin-right: 5px;
      margin-bottom: 5px;
      display: inline-block;
    }
  }
}
</style>
