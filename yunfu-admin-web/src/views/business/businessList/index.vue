<template>
  <div>
    <div class="pending">
      <!-- 搜索 -->
      <div class="formSearch">
        <el-form :inline="true" :model="searchData">
          <el-form-item label="店铺名称">
            <el-input
              v-model="searchData.shopName"
              maxlength="20"
              placeholder="请输入店铺名称"
            />
          </el-form-item>
          <el-form-item label="店铺编码">
            <el-input
              v-model="searchData.shopCode"
              maxlength="20"
              placeholder="请输入店铺编码"
            />
          </el-form-item>
          <el-form-item label="负责人">
            <el-input
              v-model="searchData.chargePersonName"
              maxlength="20"
              placeholder="请输入负责人"
            />
          </el-form-item>
          <el-form-item label="合同状态">
            <el-select v-model="searchData.contractState" placeholder="请选择">
              <el-option label="有效" value="1" />
              <el-option label="无效" value="0" />
            </el-select>
          </el-form-item>
          <el-form-item>
            <el-button type="primary" plain @click="search">查询 </el-button>
            <el-button type="success" plain @click="addbuss">新建商家</el-button>
          </el-form-item>
        </el-form>
      </div>
      <!-- 表格 -->
      <el-table
        v-loading="tableLoading"
        :data="tableData"
        border
        :header-cell-style="{ 'background': '#EEF3FF', 'color': '#333333' }"
        tooltip-effect="dark"
        :style="{ 'width': '100%' }"
        class="dataTable"
      >
        <el-table-column label="店铺名称" width="220">
          <template #default="scope">{{ scope.row.shopName }}</template>
        </el-table-column>
        <el-table-column prop="shopCode" label="店铺编码" />
        <el-table-column prop="chargePersonName" label="负责人" />
        <el-table-column prop="chargePersonPhone" label="联系电话" />
        <el-table-column label="合同状态">
          <template #default="scope">
            <span v-if="scope.row.contractState === 0">无效</span>
            <span v-if="scope.row.contractState === 1">有效</span>
          </template>
        </el-table-column>
        <el-table-column prop="createTime" label="创建时间" />
        <el-table-column label="操作">
          <template #default="scope">
            <div class="btnList">
              <el-button link type="primary" @click="seeMore(scope.row)">查看</el-button>
              <el-button link type="primary" @click="edit(scope.row)">编辑</el-button>
              <el-button v-if="scope.row.state == 1" link type="primary" @click="disableOrEnable(scope.row)">禁用</el-button>
              <el-button v-else link type="primary" @click="disableOrEnable(scope.row)">启用</el-button>
              <el-popconfirm title="确认删除？" @confirm="delBusiness(scope.row)">
                <template #reference>
                  <el-button type="danger" link>删除</el-button>
                </template>
              </el-popconfirm>
            </div>
          </template>
        </el-table-column>
      </el-table>
      <el-pagination
        v-model:current-page="searchData.page"
        :page-size="searchData.pageSize"
        :page-sizes="[10, 20, 50, 100]"
        layout="total, sizes, prev, pager, next, jumper"
        background
        :total="total"
        style="margin: 12px 0;"
        @size-change="handleSizeChange"
        @current-change="handleCurrentChange"
      />
      <!-- ******************************************************弹框开始****************************************************** -->
      <!-- 详情 -->
      <el-dialog
        v-model="detailsVisible"
        :align-center="true"
        title="查看商家"
        width="50%"
        center
      >
        <div>
          <el-descriptions v-loading="detailLoading">
            <el-descriptions-item label="账号">{{ hidden(formData.shopPhone, 3, 4) }}</el-descriptions-item>
            <el-descriptions-item label="店铺名称">{{ formData.shopName }}</el-descriptions-item>
            <el-descriptions-item label="店铺负责人">{{ formData.chargePersonName }}</el-descriptions-item>
            <el-descriptions-item label="负责人电话">{{ hidden(formData.chargePersonPhone, 3, 4) }}</el-descriptions-item>
            <el-descriptions-item label="店铺地址">{{ formData.shopAdress }}</el-descriptions-item>
            <el-descriptions-item label="生效日期">{{ formData.effectiveDate?moment(formData.effectiveDate).format('YYYY-MM-DD'):'无' }}</el-descriptions-item>
            <el-descriptions-item label="生效年限">{{ formData.effectiveYear?formData.effectiveYear+'年':'无' }}</el-descriptions-item>
            <el-descriptions-item label="合同状态">{{ formData.contractState?'有效':'无效' }}</el-descriptions-item>
            <el-descriptions-item label="直播间审核">{{ formData.auditLive?'开启':'关闭' }}</el-descriptions-item>
            <el-descriptions-item label="直播间商品审核">{{ formData.auditLiveProduct?'开启':'关闭' }}</el-descriptions-item>
          </el-descriptions>
        </div>
      </el-dialog>
      <!-- 新建\编辑商家弹框 -->
      <el-dialog
        v-model="dialogVisible"
        :title="userState?'修改商家':'新增商家'"
        width="35%"
        :align-center="true"
        center
        :close-on-click-modal="false"
        @closed="onClosed"
      >
        <div>
          <el-form
            ref="formRef"
            :model="formData"
            :rules="rules"
            label-width="120px"
          >
            <el-tabs v-model="activeName">
              <el-tab-pane label="授权信息" name="first">
                <el-form-item label="店铺名称" prop="shopName">
                  <el-input
                    v-model="formData.shopName"
                    maxlength="20"
                  />
                </el-form-item>
                <el-form-item label="店铺负责人" prop="chargePersonName">
                  <el-input
                    v-model="formData.chargePersonName"
                    maxlength="20"
                  />
                </el-form-item>
                <el-form-item label="负责人电话" prop="chargePersonPhone">
                  <el-input
                    v-if="cpPhoneShow"
                    :model-value="hidden(formData.chargePersonPhone, 3, 4)"
                    maxlength="11"
                    @focus="focuscpPhoneInput"
                  />
                  <el-input
                    v-else
                    ref="phoneRef"
                    v-model="formData.chargePersonPhone"
                    maxlength="11"
                    clearable
                  />
                </el-form-item>
                <el-form-item label="店铺地址" prop="shopAdress">
                  <el-input
                    v-model="formData.shopAdress"
                    maxlength="60"
                  />
                </el-form-item>
                <el-form-item label="生效日期" prop="effectiveDate">
                  <el-date-picker
                    v-model="formData.effectiveDate"
                    format="YYYY-MM-DD"
                    value-format="YYYY-MM-DD"
                    type="date"
                    placeholder="选择日期"
                  />
                </el-form-item>
                <el-form-item label="生效年限" prop="effectiveYear">
                  <el-input
                    v-model="formData.effectiveYear"
                    type="text"
                    placeholder="请输入内容"
                    maxlength="4"
                    class="elipt"
                    style="width: 50%"
                    show-word-limit
                  />
                  <span class="year">年</span>
                </el-form-item>
                <el-form-item label="合同状态" prop="contractState">
                  <el-radio-group v-model="formData.contractState">
                    <el-radio :label="1">有效 </el-radio>
                    <el-radio :label="0">无效 </el-radio>
                  </el-radio-group>
                </el-form-item>
                <el-form-item label="直播间审核" prop="auditLive">
                  <el-radio-group v-model="formData.auditLive">
                    <el-radio :label="1">开启 </el-radio>
                    <el-radio :label="0">关闭 </el-radio>
                  </el-radio-group>
                </el-form-item>
                <el-form-item label="直播间商品审核" prop="auditLiveProduct">
                  <el-radio-group v-model="formData.auditLiveProduct">
                    <el-radio :label="1">开启 </el-radio>
                    <el-radio :label="0">关闭 </el-radio>
                  </el-radio-group>
                </el-form-item>
              </el-tab-pane>
              <el-tab-pane label="客户信息" name="second">
                <el-form-item label="账号" prop="shopPhone">
                  <el-input
                    v-if="shopPhoneShow"
                    :model-value="hidden(formData.shopPhone, 3, 4)"
                    maxlength="20"
                    @focus="focusShopPhoneInput"
                  />
                  <el-input
                    v-else
                    ref="accountRef"
                    v-model="formData.shopPhone"
                    maxlength="20"
                  />
                </el-form-item>
                <el-form-item label="密码" prop="shopPassword">
                  <el-input
                    v-model="formData.shopPassword"
                    type="password"
                    maxlength="16"
                  />
                </el-form-item>
              </el-tab-pane>
            </el-tabs>
          </el-form>
        </div>
        <template #footer>
          <span class="dialog-footer">
            <el-button @click="dialogVisible=false">取 消</el-button>
            <el-button v-if="activeName == 'first'" type="primary" @click="next">下一步</el-button>
            <el-button v-else type="primary" :loading="submitLoading" @click="addCheck(formRef)">确 定</el-button>
          </span>
        </template>
      </el-dialog>
    </div>
  </div>
</template>

<script setup>
import { encrypt } from '@/utils/rsaEncrypt.js'
import { ref, onBeforeMount, nextTick } from 'vue'
import moment from 'moment'
import {
  businessListGetAll,
  businessListSave,
  businessListGetById,
  businessListUpdate,
  businessListStart,
  delBusinessById,
} from '@/api/business'

// 新建商家弹框
const formRef = ref(null)
const accountRef = ref(null)
const phoneRef = ref(null)
const detailsVisible = ref(false)
const dialogVisible = ref(false)
const activeName = ref('first')
const tableLoading = ref(false)
const detailLoading = ref(false)
const submitLoading = ref(false)
const searchData = ref({
  shopName: '', // 店铺名称
  shopCode: '', // 店铺编码
  chargePersonName: '', // 店铺负责人
  contractState: '', // 合同状态 1-有效 0-无效
  page: 1, // 当前页
  pageSize: 10 // 每页记录数
})
const formData = ref({
  shopName: '', // 店铺名称
  chargePersonName: '', // 店铺负责人
  chargePersonPhone: '', // 负责人电话
  shopAdress: '', // 地址
  effectiveDate: '', // 生效日期
  effectiveYear: '', // 生效年限
  contractState: 1, // 合同状态 1-有效 0-无效
  auditLive: 1,
  auditLiveProduct: 1,
  shopPhone: '', // 账号
  shopPassword: '' // 密码
})
const rules = ref({
  effectiveYear: [
    { required: true, message: '请输入生效时限', trigger: 'blur' },
  ],
  shopName: [
    { required: true, message: '请输入店铺名称', trigger: 'blur' },
  ],
  chargePersonName: [
    { required: true, message: '请输入店铺负责人', trigger: 'blur' },
  ],
  chargePersonPhone: [
    { required: true, message: '请输入负责人电话', trigger: 'blur' },
    {
      pattern: /^1[3456789]\d{9}$/,
      message: '目前只支持中国大陆的手机号码',
    },
  ],
  shopAdress: [
    { required: true, message: '请输入地址', trigger: 'blur' },
  ],
  contractState: [
    {
      required: true,
      message: '请选择合同状态',
      trigger: 'change',
    },
  ],
  auditLive: [
    {
      required: true,
      message: '请选择状态',
      trigger: 'change',
    },
  ],
  auditLiveProduct: [
    {
      required: true,
      message: '请选择状态',
      trigger: 'change',
    },
  ],
  effectiveDate: [
    {
      required: true,
      message: '请选择日期',
      trigger: 'change',
    },
  ],
  shopPhone: [
    { required: true, message: '请输入账号', trigger: 'blur' },
    {
      pattern: /^1[3456789]\d{9}$/,
      message: '目前只支持中国大陆的手机号码',
    },
  ],
  shopPassword: [
    { required: true, message: '请输入密码', trigger: 'blur' },
    {
      pattern: /^[~!@#$%^&*\-+=_.0-9a-zA-Z]{8,16}$/,
      message: '8-16密码数字英文混合',
    },
  ],
})
const total = ref(1)
const tableData = ref([])
const userState = ref(1)
const privacyTime = ref(0)
const cpPhoneShow = ref(true) // 是否显示脱敏负责人手机号
const shopPhoneShow = ref(true) // 是否显示脱敏账号

onBeforeMount(() => {
  getAll(searchData.value)
  privacyTime.value = localStorage.getItem('privacyTime')
})
// 方法集合
const focusShopPhoneInput = () => {
  shopPhoneShow.value = false
  formData.value.shopPhone = ''
  // 自动获取焦点
  nextTick(() => {
    accountRef.value.focus()
  })
}
const focuscpPhoneInput = () => {
  cpPhoneShow.value = false
  formData.value.chargePersonPhone = ''
  // 自动获取焦点
  nextTick(() => {
    phoneRef.value.focus()
  })
}
// 分页
const handleSizeChange = (val) => {
  searchData.value.pageSize = val
  getAll(searchData.value)
}
const handleCurrentChange = (val) => {
  searchData.value.page = val
  getAll(searchData.value)
}
// 查询
const search = () => {
  getAll(searchData.value)
}
// 新建商家
const addbuss = () => {
  activeName.value = 'first'
  userState.value = 0
  cpPhoneShow.value = false
  shopPhoneShow.value = false
  formData.value = {
    shopName: '', // 店铺名称
    chargePersonName: '', // 店铺负责人
    chargePersonPhone: '', // 负责人电话
    shopAdress: '', // 地址
    effectiveDate: '', // 生效日期
    effectiveYear: '', // 生效年限
    contractState: 1, // 合同状态 1-有效 0-无效
    auditLive: 1,
    auditLiveProduct: 1,
    shopPhone: '', // 账号
    shopPassword: '', // 密码
  }
  dialogVisible.value = true
}
// 下一步
const next = () => {
  activeName.value = 'second'
}
// 弹窗关闭
const onClosed = () => {
  cpPhoneShow.value = true
  shopPhoneShow.value = true
  formRef.value.resetFields()
}
// 提交
const addCheck = async (formEl) => {
  if (!formEl) return
  await formEl.validate((valid, fields) => {
    if (valid) {
      submitLoading.value = true
      if (!userState.value) {
        businessListSave(formData.value).then((res) => {
          if (res.code === '') {
            ElMessage({
              message: '新增成功',
              type: 'success',
            })
            getAll(searchData.value)
            dialogVisible.value = false
          }
        }).finally(() => {
          submitLoading.value = false
        })
      } else {
        const tmpData = {}
        Object.assign(tmpData, formData.value)
        tmpData.shopPassword = encrypt(tmpData.shopPassword)
        businessListUpdate(tmpData).then((res) => {
          if (res.code === '') {
            ElMessage({
              message: '修改成功',
              type: 'success',
            })
            getAll(searchData.value)
            dialogVisible.value = false
          }
        }).finally(() => {
          submitLoading.value = false
        })
      }
    } else {
      ElMessage.error('请填写完整')
      return false
    }
  })
}
// 查看
const seeMore = async (row) => {
  detailsVisible.value = true
  detailLoading.value = true
  try {
    const res = await businessListGetById({ shopId: row.shopId })
    if (res.code === '') {
      formData.value = res.data
    }
  } finally {
    detailLoading.value = false
  }
}
// 编辑
const edit = async (row) => {
  activeName.value = 'first'
  userState.value = 1
  const res = await businessListGetById({ shopId: row.shopId })
  if (res.code === '') {
    formData.value = res.data
    dialogVisible.value = true
  }
}
// 停用/启动
const disableOrEnable = async (row) => {
  if (row.state === 1) {
    const res = await businessListStart({
      shopName: row.shopName,
      state: 0,
      shopId: row.shopId,
    })
    if (res.code === '') {
      ElMessage({
        message: '停用成功',
        type: 'success',
      })
      getAll(searchData.value)
    }
  } else {
    const res = await businessListStart({
      shopName: row.shopName,
      state: 1,
      shopId: row.shopId,
    })
    if (res.code === '') {
      ElMessage({
        message: '启用成功',
        type: 'success',
      })
      getAll(searchData.value)
    }
  }
}
// 删除
const delBusiness = (row) => {
  ElMessageBox.confirm(
    '此操作将永久删除该商家, 是否继续?',
    '提示',
    {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning',
    }
  )
    .then(() => {
      delBusinessById({
        shopId: row.shopId,
      }).then(res => {
        if (res.code === '') {
          ElMessage({
            type: 'success',
            message: '删除成功',
          })
          getAll(searchData.value)
        }
      })
    })
    .catch(() => {})
}
// 初始化查询所有数据
const getAll = async (data) => {
  tableLoading.value = true
  try {
    const res = await businessListGetAll(data)
    total.value = res.data.total
    tableData.value = res.data.list
  } finally {
    tableLoading.value = false
  }
}
// 中间部分
const hidden = (str, frontLen, endLen) => {
  let endLenData = 0
  if (str.length !== 2) {
    endLenData = endLen
  }
  const len = str.length - frontLen - endLenData
  let xing = ''
  for (let i = 0; i < len; i++) {
    xing += '*'
  }
  return (
    str.substring(0, frontLen) +
    xing +
    str.substring(str.length - endLenData)
  )
}

</script>

<style lang="scss" scoped>
.pending {
  padding: 20px;
  margin-top: 20px;
  background-color: #FFFFFF;
}

.fenye {
  margin-top: 20px;
}

.elipt {
  width: 50%;
}

:deep(.el-descriptions__label) {
  font-weight: bold;
}
.year {
  margin-left: 10px;
}
</style>
