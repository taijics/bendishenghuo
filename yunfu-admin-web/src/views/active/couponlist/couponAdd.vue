<template>
  <el-dialog
    v-model="visible"
    :title="activityForm.activityId ? '修改优惠券活动' : '新增优惠券活动'"
    width="50%"
    center
    :close-on-click-modal="false"
    @closed="closed"
  >
    <div class="content">
      <el-form
        ref="formRef"
        :model="form"
        :rules="rules"
        label-width="150px"
      >
        <h2>基础信息</h2>
        <br />
        <el-form-item label="活动名称:" prop="activityName">
          <el-input
            v-model="form.activityName"
            maxlength="20"
            placeholder="请输入活动名称"
          />
        </el-form-item>

        <el-form-item label="活动介绍:">
          <el-input
            v-model="form.activityIntroduce"
            maxlength="200"
            type="textarea"
            placeholder="请输入活动介绍"
            :disabled="unStart"
            style="width: 400px"
          />
        </el-form-item>

        <el-form-item label="报名时间:" prop="signStartTime">
          <el-date-picker
            v-model="signDate"
            type="datetimerange"
            range-separator="至"
            start-placeholder="开始时间"
            end-placeholder="结束时间"
            value-format="YYYY-MM-DD HH:mm:ss"
            :clearable="false"
          />
          <p class="timeInfo">报名时间不能交叉且报名时间不能大于活动时间</p>
        </el-form-item>

        <el-form-item label="活动时间:" prop="activityStartTime">
          <el-date-picker
            v-model="activityDate"
            type="datetimerange"
            range-separator="至"
            start-placeholder="开始时间"
            end-placeholder="结束时间"
            value-format="YYYY-MM-DD HH:mm:ss"
            :disabled="applyEnd"
            :clearable="false"
          />
          <p class="timeInfo">
            平台活动时间不能交叉并且活动时间不能小于报名时间
          </p>
        </el-form-item>

        <el-form-item label="活动保证金:" prop="ifBond">
          <el-radio-group v-model="form.ifBond">
            <el-radio
              :label="1"
              :disabled="unStart"
            >需要
            </el-radio>
            <el-radio
              :label="0"
              :disabled="unStart"
            >不需要
            </el-radio>
          </el-radio-group>
        </el-form-item>

        <el-form-item v-if="form.ifBond === 1" label="保证金金额:" prop="bondMoney">
          <el-input-number
            v-model="form.bondMoney"
            :precision="2"
            :controls="false"
            :max="999999"
            :min="0"
            placeholder="请输入活动保证金金额"
            :disabled="unStart"
          />
        </el-form-item>

        <!-- <el-form-item label="活动标签">
            <el-input v-model="form.activityLabel" placeholder="请输入活动标签" :disabled="unStart" />
          </el-form-item> -->

        <h2>优惠规则</h2>
        <br />
        <el-form-item label="使用门槛:" prop="threshold">
          满
          <el-input-number
            v-model="form.threshold"
            :precision="2"
            :controls="false"
            :max="999999"
            :min="0"
            :disabled="unStart"
            style="width: 100px; margin: 0 12px"
          />
          元
        </el-form-item>
        <el-form-item label="优惠方式:" prop="discountMode">
          <el-radio-group v-model="form.discountMode">
            <el-radio
              :label="1"
              :disabled="unStart"
            >满减
            </el-radio>
            <el-radio
              :label="2"
              :disabled="unStart"
            >折扣
            </el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="优惠内容:" prop="couponContent">
          <div v-if="form.discountMode === 1">
            减
            <el-input-number
              v-model="form.couponContent"
              :precision="2"
              :controls="false"
              :max="999999"
              :min="0"
              :disabled="unStart"
              style="width: 100px; margin: 0 12px"
            />
            元
          </div>
          <div v-if="form.discountMode === 2">
            <el-input-number
              v-model="form.couponContent"
              :precision="0"
              :controls="false"
              :max="999999"
              :min="0"
              :disabled="unStart"
              style="width: 100px; margin-right: 12px"
            />
            折
          </div>
        </el-form-item>

        <el-form-item label="发放数量:" prop="number">
          <el-input-number
            v-model="form.number"
            :precision="0"
            :controls="false"
            :max="999999"
            :min="0"
            :disabled="unStart"
            style="width: 100px; margin-right: 12px"
          />
          张
        </el-form-item>
        <el-form-item label="是否限领:" prop="receiveType">
          <el-radio-group v-model="form.receiveType">
            <el-radio
              :label="1"
              :disabled="unStart"
            >不限制
            </el-radio>
            <el-radio
              :label="2"
              :disabled="unStart"
            >限制领取
            </el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item v-if="form.receiveType === 2" label="限制领取次数:" prop="frequency">
          <el-input-number
            v-model="form.frequency"
            :precision="0"
            :controls="false"
            :max="999999"
            :min="0"
            :disabled="unStart"
            style="width: 100px; margin-right: 12px"
          />
          次
        </el-form-item>
        <el-form-item label="是否开启积分兑换:" prop="ifCredit">
          <el-radio-group v-model="form.ifCredit">
            <el-radio
              :label="1"
              :disabled="unStart"
            >是
            </el-radio>
            <el-radio
              :label="0"
              :disabled="unStart"
            >否
            </el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item v-if="form.ifCredit" label="所需积分:" prop="credit">
          <el-input-number
            v-model="form.credit"
            :precision="0"
            :controls="false"
            :max="999999"
            :min="0"
            :disabled="unStart"
            style="width: 150px; margin-right: 12px"
          />
          分
        </el-form-item>
        <el-form-item label="可用范围:" prop="applyType">
          <el-radio-group v-model="form.applyType">
            <el-radio :label="1" :disabled="unStart">全部</el-radio>
            <el-radio :label="2" :disabled="unStart">选择类别</el-radio>
            <el-select
              v-if="form.applyType === 2"
              v-model="form.applyCategory"
              placeholder="请选择"
            >
              <el-option
                v-for="item in classList"
                :key="item.classifyId"
                :label="item.classifyName"
                :value="item.classifyId"
              />
            </el-select>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="微信卡券:" prop="syncCard">
          <el-checkbox
            v-model="form.syncCard"
            :true-label="1"
            :false-label="0"
            :disabled="unStart"
          >领取后可同步微信卡包</el-checkbox>
        </el-form-item>
        <div v-if="form.syncCard === 1">
          <h2>卡券同步设置</h2>
          <br />
          <!--          <el-form-item label="券跳转配置:">-->
          <!--            <div>券跳转路径</div>-->
          <!--            <el-input v-model="form.appletAppId" type="text" :disabled="unStart" placeholder="请输入券跳转路径" />-->
          <!--          </el-form-item>-->
          <el-form-item label="卡券标题:" prop="cardTitle">
            <el-input
              v-model="form.cardTitle"
              maxlength="21"
              show-word-limit
              type="text"
              :disabled="isEdit"
              placeholder="请输入卡券标题"
            />
          </el-form-item>
          <el-form-item label="券主题颜色:" prop="cardColor">
            <!--            <el-color-picker v-model="form.color" />-->
            <el-select
              v-model="form.cardColor"
              class="color-select"
              placeholder="请选择"
              :disabled="isEdit"
            >
              <el-option
                v-for="item in bgColors"
                :key="item.value"
                :label="item.value"
                :value="item.value"
              >
                <span
                  class="color-box"
                  :style="{
                    width: '30px',
                    height: '30px',
                    float: 'left',
                    backgroundColor: item.label,
                  }"
                ></span>
                <span
                  class="color-val"
                  :style="{ float: 'right' }"
                >{{
                  item.value
                }}</span>
              </el-option>
            </el-select>
          </el-form-item>
          <el-form-item label="使用须知:" prop="cardNotice">
            <el-input
              v-model="form.cardNotice"
              maxlength="15"
              show-word-limit
              type="textarea"
              placeholder="使用须知"
              :disabled="isEdit"
              style="width: 400px"
            />
          </el-form-item>
        </div>
      </el-form>
    </div>
    <template #footer>
      <div class="btn_list">
        <el-button @click="handleCancel">取消</el-button>
        <el-button type="primary" :loading="btnLoading" @click="save(formRef)">保存</el-button>
      </div>
    </template>
  </el-dialog>
</template>

<script setup>
import { computed, defineComponent, ref, shallowRef } from 'vue'
import { activeAdd, activeGetById, activeUpdate } from '@/api/active'
import { commdityClassGetAll } from '@/api/renovation'
// import shopList from '@/views/active/couponlist/component/shopList';
import Form from './module'
import { bgColors } from './couponColor.js'

defineComponent({
  name: 'CouponEdit'
})

const emit = defineEmits(['refersh'])
// 报名时间校验
const enrollmentTime = (rule, value, callback) => {
  let startTime = Date.parse(signDate.value[1])
  let timestamp = Date.parse(new Date())
  if (signDate.value.length < 2) {
    return callback(new Error('请选择报名时间'))
  } else if (startTime < timestamp) {
    return callback(new Error('报名结束时间不能小于当前时间'))
  } else {
    callback()
  }
}
// 活动时间校验
const activityTime = (rule, value, callback) => {
  let signStartTime = Date.parse(activityDate.value[1])
  let timestamp = Date.parse(new Date())
  if (activityDate.value.length < 2) {
    return callback(new Error('请选择活动时间'))
  } else if (signStartTime < timestamp) {
    return callback(new Error('活动结束时间不能小于当前时间'))
  } else {
    callback()
  }
}
// 可用范围校验
const checkApplyType = (rule, value, callback) => {
  if (!value || value === 2 && !form.value.applyCategory) {
    return callback(new Error('请选择可用范围'))
  } else {
    callback()
  }
}

const visible = shallowRef(false)
const activityForm = ref({})
const btnLoading = shallowRef(false)
const isEdit = computed(() => !!activityForm.value.activityId)
// 其他修改
const unStart = computed(() => {
  const t = activityForm.value.activityId ? activityForm.value : null
  return t && !(t.state === 0)
})
// 时间修改
const applyEnd = computed(() => {
  const t = activityForm.value.activityId ? activityForm.value : null
  return t && (t.state === 3 || t.state === 4)
})
const formRef = ref(null)
const form = ref(new Form())
// 活动时间
const activityDate = ref([])
// 报名时间
const signDate = ref([])
const rules = {
  activityName: [{ required: true, message: '请输入活动名称', trigger: 'blur' }],
  signStartTime: [{ required: true, validator: enrollmentTime, trigger: 'change' }],
  activityStartTime: [{ required: true, validator: activityTime, trigger: 'change' }],
  ifBond: [{ required: true, message: '请选择是否需要活动保证金', trigger: 'change' }],
  bondMoney: [{ required: true, message: '请输入保证金金额', trigger: 'blur' }],
  threshold: [{ required: true, message: '请输入使用门槛', trigger: 'blur' }],
  discountMode: [{ required: true, message: '请选择优惠方式', trigger: 'change' }],
  couponContent: [{ required: true, message: '请输入优惠内容', trigger: 'blur' }],
  number: [{ required: true, message: '请输入发放数量', trigger: 'blur' }],
  receiveType: [{ required: true, message: '请选择是否限领', trigger: 'change' }],
  frequency: [{ required: true, message: '请输入限领次数', trigger: 'blur' }],
  ifCredit: [{ required: true, message: '请选择是否开启积分兑换', trigger: 'change' }],
  credit: [{ required: true, message: '请输入所需积分', trigger: 'blur' }],
  applyType: [{ required: true, validator: checkApplyType, trigger: 'change' }],
  cardTitle: [{ required: true, message: '请输入卡券标题', trigger: 'blur' }],
  cardColor: [{ required: true, message: '请选择券主题颜色', trigger: 'change' }],
  cardNotice: [{ required: true, message: '请输入使用须知', trigger: 'blur' }]
}

// 打开弹窗
function open (row) {
  if (row) {
    activityForm.value = row
    getDetails()
  } else {
    activityForm.value = {}
  }
  getAll()
  visible.value = true
}
defineExpose({ open })

function getDetails () {
  activeGetById({
    activityId: activityForm.value.activityId,
  }).then(res => {
    if (JSON.stringify(res.data) !== '{}') {
      form.value = res.data
      activityDate.value = [res.data.activityStartTime, res.data.activityEndTime] // 活动时间
      signDate.value = [res.data.signStartTime, res.data.signEndTime] // 报名时间
    }
  })
}

/** 类别 */
const classList = ref([])
// 获取类别
function getAll () {
  commdityClassGetAll({
    page: 1,
    pageSize: 10,
  }).then(res => {
    classList.value = res.data.list
  })
}
// 保存
function save (formEl) {
  if (!formEl) return
  formEl.validate(valid => {
    if (valid) {
      btnLoading.value = true
      const params = Object.assign(
        {},
        form.value,
        {
          activityStartTime: activityDate.value[0] || '',
          activityEndTime: activityDate.value[1] || '',
          signStartTime: signDate.value[0] || '',
          signEndTime: signDate.value[1] || '',
          bondMoney: form.value.bondMoney * 1,
        }
      )
      if (activityForm.value.activityId) {
        params.activityId = activityForm.value.activityId
      }
      // if (this.shopList.length) {
      //   this.shopList.forEach((item) => {
      //     this.form.shopIdList.push(item.shopId)
      //   })
      // }
      const fn = activityForm.value.activityId ? activeUpdate : activeAdd
      fn(params).then((res) => {
        if (res.code === '') {
          ElMessage.success('新增成功')
          emit('refersh')
          handleCancel();
        }
      }).finally(() => {
        btnLoading.value = false
      })
    }
  })
}
function handleCancel () {
  visible.value = false
}

function closed () {
  formRef.value.resetFields()
  form.value = new Form()
  activityDate.value = []
  signDate.value = []
}
// let shopList = ref([]);
// function selectShop (val) {
//   shopList.value = val
// }
</script>

<style lang="scss" scoped>
  h2 {
    font-size: 24px;
    font-weight: 500;
    position: relative;

    &::before {
      content: '';
      height: 24px;
      width: 4px;
      background-color: #3a68f2;
      position: absolute;
      left: -10px;
      top: 2px;
      display: block;
    }
  }

  .content {
    background-color: #fff;
    padding: 0 50px 20px;
    overflow: hidden;

    .el-form {
      .el-form-item {
        :deep(.el-form-item__label) {
          font-weight: bold;
        }
      }
    }

    .photo {
      padding: 70px 100px;

      .avatar-uploader {
        width: 180px;

        .el-icon-plus,
        img {
          width: 180px;
          height: 180px;
          line-height: 180px;
          border: 1px #bbb solid;
          border-radius: 4px 4px 0px 4px;
          margin-bottom: 10px;
          text-align: center;
        }

        img {
          border: none;
        }
      }
    }
  }

    .btn_list {
      height: 80px;
      line-height: 80px;
      border-top: 1px solid #e0e5eb;
      text-align: right;
      .el-button {
        height: 38px;
      }
    }

  .timeInfo {
    font-size: 12px;
    color: #999999;
  }

  .el-input {
    width: 400px;
  }

  .addShop {
    color: #409eff;
    cursor: pointer;
  }

  .arrow {
    display: inline-block;
    width: 10px;
    height: 10px;
    border-top: 1px solid #cccccc;
    border-right: 1px solid #cccccc;
  }

  .arrowUp {
    transform: rotate(-45deg);
  }

  .arrowDown {
    transform: rotate(135deg);
  }

  .selectShopBox {
    .leftTit {
      font-size: 14px;
      color: #666666;
      float: left;
      margin-right: 15px;
    }

    .rightBox {
      float: left;

      span {
        padding: 5px 8px;
        border: 1px solid #e1e1e1;
        color: #999999;
        font-size: 12px;
        margin-right: 10px;
      }
    }
  }
</style>
