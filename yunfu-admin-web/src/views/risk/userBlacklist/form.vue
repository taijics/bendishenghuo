<template>
  <el-dialog
    v-model="visible"
    :close-on-click-modal="false"
    :title="isAdd ? '新建用户黑名单' : '编辑用户黑名单'"
    width="500px"
  >
    <div class="user-search">
      <el-select
        v-model="searchKey"
        filterable
        remote
        reserve-keyword
        placeholder="请输入关键词"
        :remote-method="userQuery"
        :loading="userLoading"
        value-key="buyerUserId"
        @change="userSelectChane"
      >
        <el-option
          v-for="item in userOptions"
          :key="item.buyerUserId"
          :label="item.name"
          :value="item"
        />
      </el-select>
    </div>
    <div class="user-result">
      <el-descriptions
        v-if="JSON.stringify(resultData) !== '{}'"
        class="margin-top"
        title=""
        :column="1"
        border
      >
        <el-descriptions-item>
          <template #label> userid</template>
          {{ resultData.buyerUserId }}
        </el-descriptions-item>
        <el-descriptions-item>
          <template #label> openid</template>
          {{ resultData.wechatOpenId }}
        </el-descriptions-item>
        <el-descriptions-item>
          <template #label> 昵称</template>
          {{ resultData.name }}
        </el-descriptions-item>
        <el-descriptions-item>
          <template #label> 手机号</template>
          {{ resultData.phone }}
        </el-descriptions-item>
      </el-descriptions>
    </div>
    <template #footer>
      <div
        class="dialog-footer"
      >
        <el-button
          type="primary"
          link
          @click="doCancel"
        >取消
        </el-button>
        <el-button
          type="primary"
          @click="doSubmit"
        >确认
        </el-button>
      </div>
    </template>

  </el-dialog>
</template>

<script setup>
import { addBlack, searchUser } from '@/api/risk'
import { ref } from 'vue';

const visible = ref(false)
const isAdd = ref(false)
const searchKey = ref('')
const userParams = ref({
  searchKey: '',
  page: 1,
  pageSize: 10,
})
const userLoading = ref(false)
const userOptions = ref([])
const resultData = ref({})

function show (row) {
  isAdd.value = !row
  if (isAdd.value) {
    searchKey.value = ''
    resultData.value = {}
  } else {
    resultData.value = JSON.parse(JSON.stringify(row))
  }
  visible.value = true
}

function doCancel () {
  visible.value = false
}
const $emit = defineEmits(['reset'])

function doSubmit () {
  if (JSON.stringify(resultData.value) === '{}') {
    ElMessage({
      message: '请先查找用户',
      type: 'warning',
    })
    return false
  }
  const params = {
    type: 2,
    buyerUserId: resultData.value.buyerUserId,
  }
  addBlack(params)
    .then((res) => {
      ElMessage({
        message: '新增成功',
        type: 'success',
      })
      $emit('reset')
    }).finally(() => {
      visible.value = false
    })
}

// 用户搜索
function userQuery (val) {
  if (val) {
    userLoading.value = true
    userParams.value.searchKey = val
    searchUser(userParams.value)
      .then((res) => {
        userOptions.value = res.data.list
      }).finally(() => {
        userLoading.value = false
      })
  }
}

function userSelectChane (val) {
  resultData.value = val || {}
}

defineExpose({ show })
</script>

<style
    lang="scss"
    scoped
>
.user-search {
  margin-bottom: 10px;
}

.head-container .el-form-item {
  margin-bottom: 0px;
}
</style>
