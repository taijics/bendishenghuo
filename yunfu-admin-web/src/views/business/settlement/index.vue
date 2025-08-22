<template>
  <div class="pdl">
    <!-- 选项卡 -->
    <el-tabs v-model="activeName" @tab-click="handleClick">
      <el-tab-pane label="待处理" :name="0" />
      <el-tab-pane label="已通过" :name="1" />
      <el-tab-pane label="已拒绝" :name="2" />
    </el-tabs>
    <!-- 搜索 -->
    <div class="formSearch">
      <el-form :inline="true" :model="searchData">
        <el-form-item label="商家名称">
          <el-input
            v-model="searchData.shopName"
            maxlength="20"
            placeholder="请输入商家名称"
          />
        </el-form-item>
        <el-form-item label="注册手机号">
          <el-input
            v-model="searchData.shopPhone"
            maxlength="11"
            placeholder="请输入注册手机号"
          />
        </el-form-item>
        <el-form-item label="店铺类型">
          <el-select
            v-model="searchData.authenType"
            clearable
            placeholder="请选择"
          >
            <el-option label="个人" value="1" />
            <el-option label="个体工商户" value="2" />
            <el-option label="企业" value="3" />
            <el-option label="其他组织" value="4" />
          </el-select>
        </el-form-item>
        <el-form-item label="申请时间">
          <el-date-picker
            v-model="searchData.dates"
            type="datetimerange"
            format="YYYY-MM-DD HH:mm:ss"
            value-format="YYYY-MM-DD HH:mm:ss"
            range-separator="至"
            start-placeholder="开始日期"
            end-placeholder="结束日期"
          />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" plain @click="search">查询</el-button>
        </el-form-item>
      </el-form>
    </div>
    <!-- 表格 -->
    <el-table
      v-loading="loading.table"
      :data="tableData"
      border
      :header-cell-style="{ 'background': '#EEF3FF', 'color': '#333333' }"
      tooltip-effect="dark"
      :style="{ 'width': '100%' }"
      class="dataTable"
    >
      <el-table-column label="商家名称" width="220">
        <template #default="scope">{{ scope.row.shopName }}</template>
      </el-table-column>
      <el-table-column label="店铺类型">
        <template #default="scope">
          <span v-if="scope.row.authenType == 1">个人</span>
          <span v-else-if="scope.row.authenType == 2">个体工商户</span>
          <span v-else-if="scope.row.authenType == 3">企业</span>
          <span v-else-if="scope.row.authenType == 4">其他组织</span>
          <span v-else>-</span>
        </template>
      </el-table-column>
      <el-table-column prop="shopPhone" label="注册手机号" />
      <el-table-column prop="createTime" label="申请时间" />
      <el-table-column label="操作">
        <template #default="scope">
          <div class="btnList">
            <el-button v-if="activeName === 0" link type="primary" @click="handle(scope.row)">处理</el-button>
            <el-button v-if="activeName === 1 || activeName === 2" link type="primary" @click="handle(scope.row)">查看</el-button>
            <el-button v-if="activeName === 1 || activeName === 2" link type="primary" @click="delet(scope.row)">删除</el-button>
          </div>
        </template>
      </el-table-column>
    </el-table>
    <el-pagination
      v-model:current-page="searchData.page"
      :page-sizes="[10, 20, 50, 100]"
      :page-size="searchData.pageSize"
      layout="total, sizes, prev, pager, next, jumper"
      background
      :total="total"
      style="margin: 12px 0;"
      @size-change="handleSizeChange"
      @current-change="handleCurrentChange"
    />

    <el-dialog
      v-model="addVisible"
      :title="shopDetails.checkState==0?'商家入驻审核':'商家入驻详情'"
      :align-center="true"
      width="60%"
      center
      :close-on-click-modal="false"
      @closed="onClosed"
    >
      <div v-loading="loading.detail">
        <el-card>
          <el-descriptions title="审核状态" :column="1">
            <el-descriptions-item class-name="check-item">
              <div class="checkState">
                <span :class="shopDetails.checkState==1?'success':shopDetails.checkState==2?'failed':''">{{ shopDetails.checkState==0?'未处理':shopDetails.checkState==1?'已通过':'已拒绝' }}</span>
              </div>
              <div v-if="shopDetails.checkState==0" class="checkBtn">
                <el-button @click="addVisible=false">取消</el-button>
                <el-button type="primary" @click="handleCheck">处理</el-button>
              </div>
            </el-descriptions-item>
          </el-descriptions>
        </el-card>
        <el-card>
          <el-descriptions title="店铺信息" :column="1">
            <el-descriptions-item label="店铺名称：">{{ shopDetails.shopName }}</el-descriptions-item>
            <el-descriptions-item label="店铺类型：">{{ shopDetails.authenType==1?'个人':shopDetails.authenType==2?'个体工商户':shopDetails.authenType==3?'企业':shopDetails.authenType==4?'其他组织':'-' }}</el-descriptions-item>
            <el-descriptions-item label="客服电话：">{{ shopDetails.shopName }}</el-descriptions-item>
            <el-descriptions-item label="店铺负责人：">{{ shopDetails.chargePersonName }}</el-descriptions-item>
            <el-descriptions-item label="负责人电话：">{{ shopDetails.chargePersonPhone }}</el-descriptions-item>
            <el-descriptions-item label="店铺地址：">{{ shopDetails.shopAdress }}</el-descriptions-item>
          </el-descriptions>
        </el-card>
        <el-card>
          <el-descriptions title="个人信息" :column="1">
            <el-descriptions-item label="名称：">{{ shopDetails.name }}</el-descriptions-item>
            <el-descriptions-item label="证件信息：">{{ shopDetails.cardTypeName }}</el-descriptions-item>
            <el-descriptions-item label="身份证号码：">{{ shopDetails.idCard }}</el-descriptions-item>
            <el-descriptions-item label="身份证有效期：">{{ shopDetails.cardTime }}</el-descriptions-item>
            <el-descriptions-item label="证件照片：">
              <el-image
                v-if="shopDetails.cardPositive"
                class="img_box"
                :preview-src-list="[shopDetails.cardPositive]"
                :src="shopDetails.cardPositive"
              />
              <el-image
                v-if="shopDetails.cardSide"
                class="img_box"
                :preview-src-list="[shopDetails.cardSide]"
                :src="shopDetails.cardSide"
              />
            </el-descriptions-item>
            <el-descriptions-item v-if="shopDetails&&shopDetails.authenType===1" label="手持证件照：">
              <el-image
                v-if="shopDetails.cardHand"
                class="img_box"
                :src="shopDetails.cardHand"
                :preview-src-list="[shopDetails.cardHand]"
              />
            </el-descriptions-item>
          </el-descriptions>
        </el-card>
        <el-card v-if="shopDetails.authenType!==1">
          <el-descriptions title="主体信息" :column="1">
            <el-descriptions-item :label="shopDetails.authenType==2?'商户名称：':shopDetails.authenType==3?'企业名称：':'组织名称：'">{{ shopDetails.subjectName }}</el-descriptions-item>
            <el-descriptions-item :label="shopDetails.authenType==4?'组织机构代码：':'社会信用代码：'">{{ shopDetails.subjectCode }}</el-descriptions-item>
            <el-descriptions-item label="注册地址：">{{ shopDetails.subjectAdress }}</el-descriptions-item>
            <el-descriptions-item label="营业期限：">{{ shopDetails.subjectStartTime + ' - ' + shopDetails.subjectEndTime }}</el-descriptions-item>
            <el-descriptions-item :label="shopDetails.authenType==4?'机构证明材料：':'营业执照：'">
              <el-image
                v-for="(img, index) in shopDetails.subjectLicense"
                :key="index"
                class="img_box"
                :preview-src-list="shopDetails.subjectLicense"
                :src="img"
              />
            </el-descriptions-item>
          </el-descriptions>
        </el-card>
        <el-card>
          <el-descriptions title="授权信息" :column="1">
            <el-descriptions-item label="生效日期：">{{ shopDetails.effectiveDate }}</el-descriptions-item>
            <el-descriptions-item label="生效时限：">{{ shopDetails.effectiveYear?shopDetails.effectiveYear+'年':'' }}</el-descriptions-item>
          </el-descriptions>
        </el-card>
      </div>
    </el-dialog>
    <el-dialog
      v-model="checkVisible"
      title="处理申请"
      :align-center="true"
      width="30%"
      center
      :close-on-click-modal="false"
      @closed="checkClosed"
    >
      <el-form ref="checkRef" :model="checkForm" :rules="rules" label-width="80px">
        <el-form-item label="入驻处理" prop="checkHandle">
          <el-radio-group v-model="checkForm.checkHandle">
            <el-radio label="1">同意入驻</el-radio>
            <el-radio label="0">拒绝入驻</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item v-if="checkForm.checkHandle==0" label="拒绝原因" prop="reason">
          <el-input
            v-model="checkForm.reason"
            maxlength="200"
            type="textarea"
          />
        </el-form-item>
        <el-form-item v-if="checkForm.checkHandle==1" label="生效日期" prop="effectiveDate">
          <el-radio-group v-model="checkForm.effectiveDate">
            <el-radio :label="null">即时生效</el-radio>
            <el-radio label="1">指定日期</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item v-if="checkForm.effectiveDate==1&&checkForm.checkHandle==1" label="" prop="chooseDate">
          <el-date-picker
            v-model="checkForm.chooseDate"
            format="YYYY-MM-DD"
            value-format="YYYY-MM-DD"
            type="date"
            placeholder="选择日期"
          />
        </el-form-item>
        <el-form-item v-if="checkForm.checkHandle==1" label="生效时限" prop="effectiveYear">
          <el-input
            v-model="checkForm.effectiveYear"
            input-style="width: 55%"
            maxlength="4"
            oninput="value=value.replace(/[^\d]/g,'')"
          >
            <template #append>年</template>
          </el-input>
        </el-form-item>
      </el-form>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="checkVisible=false">取 消</el-button>
          <el-button type="primary" @click="submit(checkRef)">确 定</el-button>
        </span>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, onBeforeMount, reactive } from 'vue'
import { settlementGetAll, settlementDelete, settlementHandle } from '@/api/business'
import { settlementGetById } from '@/api/business'
import { ElLoading } from 'element-plus';

let activeName = ref(0)
let searchData = ref({
  shopName: '', // 商家名称
  shopPhone: '', // 注册手机号
  authenType: '', // 店铺类型 1-个人 2-个体工商户 3-企业 4-其他组织
  dates: [], // 时间数组
  checkState: 0, // 入驻处理状态 0-未处理 1-通过 2-拒绝
  page: 1,
  pageSize: 10,
})
let total = ref(10)
let tableData = ref([])
let addVisible = ref(false)
let detailsLoading = ref(false)
let loading = reactive({
  table: false,
  detail: false
})
const shopDetails = ref({})
const checkVisible = ref(false)
const checkRef = ref(null)
const checkForm = ref({
  shopId: '', // 店铺id
  checkHandle: '', // 1-同意入驻 0-拒绝入驻
  effectiveDate: '', // 生效日期  null-即时生效 有值-指定日期生效
  effectiveYear: '', // 生效时限（年）
  reason: '', // 处理原因
  chooseDate: ''
})
const checkEffectiveDate = (rule, value, callback) => {
  if (value === '') {
    return callback(new Error('请选择生效日期'))
  } else {
    callback()
  }
}
const rules = ref({
  checkHandle: [
    { required: true, message: '请选择入驻处理', trigger: 'change' },
  ],
  effectiveDate: [
    { required: true, validator: checkEffectiveDate, trigger: 'change' },
  ],
  effectiveYear: [
    { required: true, message: '请输入生效时限', trigger: 'blur' },
  ],
  chooseDate: [
    { required: true, message: '请选择日期', trigger: 'change' },
  ]
})

onBeforeMount(() => {
  getAll(searchData.value)
})
// 方法集合
const handleSizeChange = (val) => {
  searchData.value.pageSize = val
  getAll(searchData.value)
}
const handleCurrentChange = (val) => {
  searchData.value.page = val
  getAll(searchData.value)
}
const handleClick = (tab, event) => {
  searchData.value.checkState = tab.index
  getAll(searchData.value)
}
// 查询
const search = () => {
  total.value = 1
  searchData.value.page = 1
  getAll(searchData.value)
}
// 处理
const handle = (row) => {
  addVisible.value = true
  getShopDetails(row.shopId)
}
// 查询店铺详情
const getShopDetails = (shopId) => {
  loading.detail = true
  settlementGetById({ shopId })
    .then((res) => {
      shopDetails.value = res.data
    })
    .finally(() => {
      loading.detail = false
    })
}
// 弹窗关闭
const onClosed = () => {
  shopDetails.value = {}
}
// 删除
const delet = (row) => {
  ElMessageBox.confirm(
    '此操作将永久删除, 是否继续?',
    '提示',
    {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning',
    }
  )
    .then(() => {
      settlementDelete({ checkId: row.checkId }).then(res => {
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
// 处理
const handleCheck = () => {
  checkForm.value.shopId = shopDetails.value.shopId
  checkVisible.value = true
}
// 弹窗关闭
const checkClosed = () => {
  checkForm.value.shopId = ''
  checkRef.value.resetFields()
}
// 处理确认
const submit = (formEl) => {
  if (!formEl) return
  formEl.validate((valid) => {
    if (valid) {
      const submitLoading = ElLoading.service({
        lock: true,
        background: 'rgba(0, 0, 0, 0.7)',
      })
      const params = {
        shopId: checkForm.value.shopId,
        checkHandle: checkForm.value.checkHandle,
        effectiveDate: checkForm.value.effectiveDate === null ? checkForm.value.effectiveDate : checkForm.value.chooseDate,
        effectiveYear: checkForm.value.effectiveYear,
        reason: checkForm.value.reason
      }
      settlementHandle(params).then(res => {
        if (res.code === '') {
          checkVisible.value = false
          addVisible.value = false
          ElMessage({
            message: '处理成功',
            type: 'success',
          })
          getAll(searchData.value)
        }
      }).finally(() => {
        submitLoading.close()
      })
    } else {
      return false
    }
  })
}
// 初始化查询所有数据
const getAll = async (data) => {
  loading.table = true
  try {
    const res = await settlementGetAll(data)
    tableData.value = res.data.list
    total.value = res.data.total
  } finally {
    loading.table = false
  }
}

</script>

<style lang="scss" scoped>
.pdl {
  padding: 20px;
  margin-top: 20px;
  background-color: #FFFFFF;
}
:deep(.el-form) {
  .el-form-item {
    margin-right: 22px;
    .el-form-item__label {
      font-weight: bold;
    }
  }
}
:deep(.el-card) {
  margin-top: 10px;
  .el-descriptions {
    .el-descriptions__header {
      padding-left: 10px;
      border-left: 4px solid #3A68F2;
    }
    .el-descriptions__cell {
      display: flex;
    }
    .el-descriptions__label {
      width: 100px;
      text-align: right;
      font-weight: bold;
    }
    .check-item {
      width: 100%;
    }
    .checkState {
      text-align: center;
      color: #3A68F2;
      font-size: 24px;
      margin-bottom: 20px;
      .success {
        color: #67C23A
      }
      .failed {
        color: #F56C6C;
      }
    }
    .checkBtn {
      text-align: center;
    }
  }
}
.img_box {
  width: 265px;
  height: 170px;
  margin-right: 10px;
}
.pdl {
  padding-left: 20px;
}
</style>
