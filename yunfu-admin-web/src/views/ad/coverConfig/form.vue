<template>
  <el-dialog
    v-model="visible"
    :close-on-click-modal="false"
    :title="isAdd ? '新建弹窗广告' : '编辑弹窗广告'"
    width="800px"
    top="5vh"
  >
    <el-form
      ref="formRef"
      class="dialog-form"
      :model="form"
      :rules="rules"
      label-width="80px"
    >
      <el-form-item label="广告名称" prop="name">
        <el-input v-model="form.name" maxlength="20" />
      </el-form-item>
      <el-form-item label="上线时间" prop="onlineTime">
        <el-date-picker
          v-model="form.onlineTime"
          type="datetimerange"
          value-format="YYYY-MM-DD HH:mm:ss"
          range-separator="至"
          start-placeholder="开始日期"
          end-placeholder="结束日期"
        />
      </el-form-item>
      <el-form-item label="弹窗图片" prop="popupImg">
        <el-upload
          class="avatar-uploader"
          :action="action"
          :headers="myHeaders"
          :show-file-list="false"
          :on-success="
            (res) => {
              handleAvatarSuccess(res, 'popupImg')
            }
          "
        >
          <img v-if="form.popupImg" :src="form.popupImg" class="avatar" />
          <el-icon v-else class="avatar-uploader-icon"><Plus /></el-icon>
        </el-upload>
        <span class="tips">建议尺寸：500*700px</span>
      </el-form-item>
      <el-form-item label="关闭按钮" prop="closeImg">
        <el-upload
          class="avatar-uploader"
          :action="action"
          :headers="myHeaders"
          :show-file-list="false"
          :on-success="
            (res) => {
              handleAvatarSuccess(res, 'closeImg')
            }
          "
        >
          <img v-if="form.closeImg" :src="form.closeImg" class="avatar" />
          <el-icon v-else class="avatar-uploader-icon"><Plus /></el-icon>
        </el-upload>
        <span class="tips">建议尺寸：60*60px</span>
      </el-form-item>
      <el-form-item label="跳转类型" prop="jumpType">
        <el-radio-group
          v-model="form.jumpType"
          class="radio-link-type"
          @change="jumpTypeChange"
        >
          <el-radio class="radio" :label="0">不跳转</el-radio>
          <el-radio class="radio" :label="1">商品</el-radio>
          <el-radio class="radio" :label="2">分类</el-radio>
          <el-radio class="radio" :label="3">平台券</el-radio>
          <el-radio class="radio" :label="4">小程序</el-radio>
          <!--<el-radio class="radio" :label="5">公众号文章</el-radio>-->
        </el-radio-group>
      </el-form-item>
      <el-form-item
        v-if="form.jumpType !== 0"
        label="链接配置"
        prop="jumpContent"
      >
        <LinkConfig :data="jumpContent" :link-type="form.jumpType" @update:data="updateData" />
      </el-form-item>
      <el-form-item label="触发条件" prop="triggerCondition">
        <el-radio-group v-model="form.triggerCondition">
          <el-radio :label="1">每天进入商城首页</el-radio>
          <el-radio :label="2">支付成功后</el-radio>
        </el-radio-group>
      </el-form-item>
      <el-form-item label="针对会员" prop="applyGroup">
        <el-radio-group v-model="form.applyGroup">
          <el-radio :label="1">全体成员</el-radio>
          <el-radio :label="2">会员</el-radio>
        </el-radio-group>
      </el-form-item>
      <!--      <el-form-item label="权重" prop="weight">-->
      <!--        <el-input v-model="form.weight" class="input-num" type="number" placeholder="输入数字" />-->
      <!--      </el-form-item>-->
    </el-form>
    <template #footer>
      <div class="dialog-footer">
        <el-button @click="doCancel">取消</el-button>
        <el-button type="primary" @click="doSubmit">确认</el-button>
      </div>
    </template>
  </el-dialog>
</template>

<script setup>
import LinkConfig from '@/components/adCoverConfig/linkConfig.vue'
import { uploadUrl, token } from '@/utils/request'
import { add, update } from '@/api/advert'
import { getCoupons } from '@/api/public'
import { nextTick, ref } from 'vue'
const visible = ref(false)
const action = ref(uploadUrl)
const myHeaders = ref({
  'Authorization-admin': token,
})
const form = ref({
  popupImg: '',
  name: '',
  closeImg: '',
  customerType: 1,
  triggerCondition: 1,
  jumpContent: '',
  jumpType: 0,
  status: 1,
  weight: 0,
})
const rules = {
  name: [
    { required: true, message: '广告名称不能为空', trigger: 'blur' },
  ],
  onlineTime: [
    { required: true, message: '上线时间不能为空', trigger: 'change' },
  ],
  jumpType: [
    { required: true, message: '跳转类型不能为空', trigger: 'change' },
  ],
  popupImg: [
    { required: true, message: '弹窗图片不能为空', trigger: 'none' },
  ],
  closeImg: [
    { required: true, message: '关闭按钮不能为空', trigger: 'none' },
  ],
  jumpContent: [
    { required: true, message: '链接配置不能为空', trigger: 'none' },
  ],
  triggerCondition: [
    { required: true, message: '触发条件不能为空', trigger: 'change' },
  ],
  applyGroup: [
    { required: true, message: '针对会员不能为空', trigger: 'change' },
  ],
  weight: [{ required: true, message: '权重不能为空', trigger: 'blur' }],
}
const isAdd = ref(false)
const jumpContent = ref({})
const onlineTime = ref([])
function handleAvatarSuccess (response, key) {
  const { url } = response.data
  form.value[key] = url
}
const formRef = ref()
function show (row) {
  isAdd.value = !row
  visible.value = true
  if (isAdd.value) {
    form.value = {
      popupImg: '',
      name: '',
      closeImg: '',
      applyGroup: 1,
      triggerCondition: 1,
      jumpContent: '',
      jumpType: 0,
      status: 1,
      weight: 0,
    }
    jumpContent.value = {}
    onlineTime.value = []
    nextTick(function () {
      formRef.value.clearValidate()
    })
  } else {
    form.value = JSON.parse(JSON.stringify(row))
    jumpContent.value = row.jumpContent ? JSON.parse(row.jumpContent) : {}
    if (form.value.jumpType === 3) {
      handleGetCoupons(jumpContent.value.items.map(item => item.activityId).join(','))
    }
    nextTick(function () {
      form.value['onlineTime'] = [row.startTime, row.endTime]
    })
  }
}
function jumpTypeChange () {
  jumpContent.value = {}
}
function updateData (data) {
  jumpContent.value = data
}
function doCancel () {
  visible.value = false
}
const $emit = defineEmits(['reset'])
function doSubmit () {
  // if (form.value.jumpType === 3) {
  //   const ids = jumpContent.value.items
  //     .map((item) => {
  //       return item.activityId
  //     })
  //     .join(',')
  //   jumpContent.value.items = ids
  // }
  // var _jumpContent = JSON.stringify(jumpContent.value)
  // if (_jumpContent && _jumpContent !== '{}') {
  //   form.value.jumpContent = _jumpContent
  // }
  form.value.jumpContent = JSON.stringify(jumpContent.value)
  formRef.value.validate((valid) => {
    if (valid) {
      form.value.startTime = form.value.onlineTime[0]
      form.value.endTime = form.value.onlineTime[1]
      delete form.value.onlineTime
      if (isAdd.value) {
        add(form.value)
          .then(() => {
            ElMessage({
              message: '新增成功',
              type: 'success',
            })
            $emit('reset')
          })
          .finally(() => {
            visible.value = false
          })
      } else {
        update(form.value)
          .then(() => {
            ElMessage({
              message: '修改成功',
              type: 'success',
            })
            $emit('reset')
          })
          .finally(() => {
            visible.value = false
          })
      }
    }
  })
}

// 获取优惠券信息
function handleGetCoupons (ids) {
  const params = {
    page: 1,
    pageSize: 999,
    ids,
  }
  getCoupons(params).then((res) => {
    jumpContent.value.items = res.data.list
  })
}
defineExpose({ show })
</script>

<style scoped>
.radio-link-type .el-radio {
  padding: 5px 0;
}
.tips {
  font-size: 12px;
  color: #8c8c8c;
}
</style>
