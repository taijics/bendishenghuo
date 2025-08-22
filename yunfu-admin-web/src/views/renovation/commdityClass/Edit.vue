<template>
  <el-dialog
    v-model="isVisible"
    :close-on-click-modal="false"
    :title="title"
    :type="type"
    center
    width="48%"
    top="50px"
    class="group-dialog"
  >
    <div class="add-dialog-component">
      <el-alert
        :style="{ backgroundColor: '#fff' }"
        title="保存后将生效在移动端的分类里"
        type="info"
        :closable="false"
      />
      <el-tree
        ref="elTreeRef"
        class="tree-box"
        :data="treeData"
        :props="{ children: 'childs' }"
        node-key="id"
        default-expand-all
        :expand-on-click-node="false"
      >
        <template #default="{ node, data }">
          <div class="custom-tree-node">
            <div class="content">
              <template v-if="data.depth < 3">
                <el-input
                  v-model="data.categoryName"
                  class="input"
                  :disabled="isCheck"
                  maxlength="6"
                  :placeholder="placeholderTips(data.depth)"
                />
                <el-upload
                  class="upload-uploader"
                  :on-success="handleImageSuccessOne"
                  :multiple="false"
                  :show-file-list="false"
                  :action="action"
                  :file-list="data.categoryImgArray"
                >
                  <img
                    v-if="
                      data.categoryImgArray.length &&
                        data.categoryImgArray[0].imgPath
                    "
                    width="80"
                    height="80"
                    :src="
                      data.categoryImgArray.length &&
                        data.categoryImgArray[0].imgPath
                    "
                  />
                  <el-icon v-else>
                    <el-icon-plus />
                  </el-icon>
                </el-upload>
              </template>
              <template v-else>
                <div
                  class="content"
                  :class="isCheck ? 'disabled' : ''"
                >
                  <el-input
                    v-model="data.categoryName"
                    class="input"
                    :disabled="isCheck"
                    maxlength="6"
                    placeholder="输入三级类别名称（最大6个字符）"
                  />
                  <el-upload
                    :headers="headers"
                    :data="dataObj"
                    :multiple="false"
                    :show-file-list="false"
                    :file-list="data.categoryImgArray"
                    :on-success="handleImageSuccess"
                    class="upload-uploader"
                    :action="action"
                  >
                    <img
                      v-if="data.categoryImgArray && data.categoryImgArray[0].url"
                      width="80"
                      height="80"
                      :src="data.categoryImgArray && data.categoryImgArray[0].url"
                    />
                    <el-icon v-else>
                      <el-icon-plus />
                    </el-icon>
                  </el-upload>
                </div>
              </template>
            </div>
            <div
              v-if="!isCheck"
              class="setting-box"
            >
              <el-button
                type="primary"
                link
                @click="() => append(data)"
              >{{ addTips(data.depth) }}
              </el-button>
              <el-button
                type="primary"
                link
                v-if="data.depth > 1"
                @click="() => remove(node, data)"
              >删除
              </el-button>
            </div>
          </div>
        </template>
      </el-tree>
      <div class="add-btn-wrap">
        <template v-if="isCheck">
          <el-button
            class="add"
            type="primary"
            @click="close"
          >确定
          </el-button>
        </template>
        <template v-else>
          <el-button
            v-if="type === 'add'"
            class="add"
            type="primary"
            @click="addClassification"
          >添加一级类别名称
          </el-button>
          <el-button
            type="primary"
            @click="onSubmit"
          >保存
          </el-button>
        </template>
      </div>
    </div>
  </el-dialog>
</template>

<script setup>
import { Plus as ElIconPlus } from '@element-plus/icons-vue'
import { uploadUrl } from '@/utils/request'
import { commdityClassAdd, commdityClassgetById, commdityClassUpdate, } from '@/api/renovation'
import { computed, getCurrentInstance, ref, toRefs } from 'vue';

defineExpose({ setParams })
let idx = 1000
let imgId = 1
const props = defineProps({
  dialogVisible: {
    type: Boolean,
    default: false,
  },
  type: {
    type: String,
    default: 'add',
  }
})
const { dialogVisible, type } = toRefs(props)
const params = ref({
  categoryName: '',
})
const file = ref('')
const imgList = ref([])
const customParams = ref({
  current: 1,
  map: {},
  model: {
    config: '',
    isCustom: true,
    isDelete: 0,
    name: '',
  },
  order: 'descending',
  size: 100,
  sort: 'id',
})
const treeData = ref([])
const headers = ref({
  Authorization: '',
})
const action = ref(uploadUrl)
const dataObj = ref({
  folderId: 1,
})
const deleteArr = ref([])

const isVisible = computed({
  get () {
    return dialogVisible.value
  },
  set () {
    close()
    reset()
  }
})
const title = computed(() => {
  const stateMap = {
    add: '新建类别',
    edit: '修改类别',
    check: '查看类别',
  }
  return stateMap[type.value]
})
const isCheck = computed(() => {
  return type.value === 'check'
})

async function queryOneCategory (oneClassifyId) {
  if (oneClassifyId === undefined) {
    treeData.value = []
    return
  }
  const res = await commdityClassgetById({
    oneClassifyId,
  })
  console.log(res)
  const resData = res.data
  const treeFilter = (item) => {
    const {
      categoryName,
      categoryImg,
      categoryPath,
      parentName,
      categoryImgArray,
      depth,
      id,
      link,
    } = item
    const newMap = {
      depth: depth,
      categoryName,
      categoryPath: categoryPath || '',
      parentName,
      categoryImgArray,
      link,
      id,
    }
    console.log(depth)
    if (depth === 3) {
      newMap.categoryImgArray = [
        {
          url: categoryImg,
        },
      ]
    }
    if (item.childs && item.childs.length) {
      newMap.childs = item.childs.map(treeFilter)
    }
    return newMap
  }
  if (resData) {
    resData.childs =
        resData && resData.childs && resData.childs.map(treeFilter)
    treeData.value = [resData]
  } else {
    treeData.value = []
  }
}

function handleImageSuccess (response, file, fileList) {
  const url = response.data.url
  fileList[0].url = url
}

function handleImageSuccessOne (response, file, fileList) {
  const url = response.data.url
  fileList[0].imgPath = url
}

const $emit = defineEmits(['close', 'success'])

function close () {
  $emit('close')
}

function reset () {
  treeData.value = []
}

function addClassification () {
  treeData.value.push({
    placeholder: '输入一级类别名称',
    addTips: '添加二级类别名称',
    categoryName: '',
    categoryPath: '',
    depth: 1,
    idx: idx++,
    categoryImgArray: [
      {
        id: imgId++,
        imgPath: '',
      },
    ],
  })
}

function append (data) {
  const { categoryName } = data
  const depth = data.depth + 1
  let newChild
  if (!data.childs) {
    // $set(data, 'childs', [])
    data.childs = []
  }
  if (depth < 3) {
    newChild = {
      placeholder: '输入二级类别名称',
      addTips: '添加三级类别名称',
      depth,
      parentName: categoryName,
      categoryName: '',
      categoryPath: '',
      categoryImgArray: [
        {
          id: imgId++,
          imgPath: '',
        },
      ],
      childs: [],
      idx: idx++,
    }
  } else {
    newChild = {
      parentName: categoryName,
      categoryImgArray: [
        {
          id: imgId++,
          url: '',
        },
      ],
      depth: 3,
      categoryName: '',
      idx: idx++,
    }
  }
  data.childs.push(newChild)

  treeData.value = JSON.parse(JSON.stringify(treeData.value))
}

const elTreeRef = ref();
function remove (node, data) {
  const parent = node.parent
  const children = parent.data.childs || parent.data
  const index = children.findIndex((d) => d.idx === data.idx)
  if (index !== -1) {
    deleteArr.value.push(data.id || '')
    elTreeRef.value.remove(node)
  } else {
    ElMessage.warning('数据错误，请重试')
  }
}

function onSubmit () {
  console.log(type)
  if (type.value === 'add') {
    addGroup()
  } else {
    updateGroup()
  }
}

function addGroup () {
  const treeFilter = (item) => {
    const {
      categoryName,
      categoryImgArray,
      categoryPath,
      parentName,
      depth,
      link,
    } = item
    const newMap = {
      depth: depth,
      categoryName,
      categoryPath: categoryPath || '',
      parentName,
      link,
    }
    if (categoryImgArray) {
      newMap.categoryImg = categoryImgArray[0].imgPath
    }
    if (depth === 3) {
      newMap.categoryImg = categoryImgArray[0].url
    }
    if (!newMap.categoryImg) {
      ElMessage.error('分类"' + categoryName + '"请上传分类图片')
      throw new Error('未上传分类图片')
    }
    if (item.childs && item.childs.length) {
      newMap.childs = item.childs.map(treeFilter)
    }
    return newMap
  }
  const params = treeData.value.map(treeFilter)
  if (params.length === 0) {
    ElMessage.error('请添加分类')
    return
  }
  const obj = {
    classifies: params,
  }
  const tertiaryClass = checkCategories(obj.classifies);
  if (!tertiaryClass) {
    return false
  }
  commdityClassAdd(obj).then(res => {
    if (res.code === '') {
      isVisible.value = false
      ElMessage.success('新增成功')
      $emit('success')
      deleteArr.value = []
    }
  })
}

async function updateGroup () {
  const treeFilter = (item) => {
    const {
      categoryName,
      categoryImgArray,
      categoryPath,
      parentName,
      depth,
      id,
      link,
    } = item
    const newMap = {
      depth: depth,
      categoryName,
      categoryPath: categoryPath || '',
      parentName,
      link,
      id,
    }
    if (categoryImgArray) {
      newMap.categoryImg = categoryImgArray[0].imgPath
    }
    if (depth === 3) {
      newMap.categoryImg = categoryImgArray[0].url
    }
    if (!newMap.categoryImg) {
      ElMessage.error('分类"' + categoryName + '"请上传分类图片')
      throw new Error('未上传分类图片')
    }
    if (item.childs && item.childs.length) {
      newMap.childs = item.childs.map(treeFilter)
    }
    return newMap
  }
  const params = treeData.value.map(treeFilter)
  const obj = {
    classifies: params,
    deleteIds: deleteArr.value,
  }
  const tertiaryClass = checkCategories(obj.classifies);
  if (!tertiaryClass) {
    return false
  }
  commdityClassUpdate(obj).then(res => {
    if (res.code === '') {
      isVisible.value = false
      ElMessage.success('成功')
      $emit('success')
      deleteArr.value = []
    }
  })
}

function setParams ({ id }) {
  queryOneCategory(id)
}

function addTips (depth) {
  depth = depth + ''
  const tipsMp = {
    1: '添加二级类别名称',
    2: '添加三级类别名称',
  }
  return tipsMp[depth]
}

function placeholderTips (depth) {
  depth = depth + ''
  const tipsMp = {
    1: '输入一级类别名称（最大6个字符）',
    2: '输入二级类别名称（最大6个字符）',
  }
  return tipsMp[depth]
}
// 判断是否存在三级类别
function checkCategories (categories) {
  for (let i = 0; i < categories.length; i++) {
    const parentCategory = categories[i];
    if (parentCategory.childs && parentCategory.childs.length > 0) {
      for (let j = 0; j < parentCategory.childs.length; j++) {
        let hasSecondLevelCategory = false;
        let hasThirdLevelCategory = false;
        const childCategory = parentCategory.childs[j];
        if (childCategory.depth === 2) {
          hasSecondLevelCategory = true;
          if (childCategory.childs && childCategory.childs.length > 0) {
            hasThirdLevelCategory = true;
          }
        }
        if (!hasSecondLevelCategory || !hasThirdLevelCategory) {
          ElMessage.error(`请在${childCategory.categoryName}分类下添加三级类别!`)
          return false;
        }
      }
    } else {
      ElMessage.error(`请在${parentCategory.categoryName}分类下添加二级类别!`)
      return false;
    }
  }
  return true;
}
</script>

<style lang="scss">
.add-dialog-component {
  .tree-box {
    .el-tree-node__content {
      margin-bottom: 15px;
      height: auto;
    }
  }
}
</style>

<style lang="scss" scoped>
.group-dialog {
  .el-dialog {
    min-width: 500px;
    max-width: 600px;
  }
}

.add-dialog-component {
  padding: 15px 20px;
  max-height: 60vh;
  overflow: auto;

  .el-tree-node__content {
    &:hover {
      background-color: #fff;
    }
  }

  .tree-box {
    margin: 15px 0;

    .custom-tree-node {
      display: flex;
      width: 100%;
      text-align: left;

      .content {
        flex: 1;
        display: flex;
        align-items: center;

        .input {
          width: 60%;
          margin-right: 20px;
        }

        .textarea-input {
          width: 100%;
          margin-left: 15px;

          textarea {
            height: 80px;
          }
        }
      }

      .level-3-wrap {
        display: flex;
        width: 300px;

        .upload-wrap {
          position: relative;

          &.disabled::after {
            content: '';
            position: absolute;
            left: 0;
            right: 0;
            top: 0;
            bottom: 0;
            z-index: 999;
            background-color: #f5f7fa;
            opacity: 0.5;
          }

          .el-upload {
            border: 1px dashed #d9d9d9;
          }

          i {
          }

          img {
            width: 80px;
            height: 80px;
          }
        }
      }
    }
  }

  .add-btn-wrap {
    text-align: center;
  }
}

.upload-uploader {
  margin-left: 30px;
}
</style>
