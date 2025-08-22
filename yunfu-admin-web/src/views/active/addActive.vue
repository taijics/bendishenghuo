<template>
  <div class="edit_add_page">
    <div class="content">
      <div class="title">
        <span>{{ title }}</span>
        <div class="btn_list">
          <span @click="cancel">取消</span>
          <span @click="save">保存</span>
        </div>
      </div>
      <el-col :span="12">
        <el-form ref="form" :model="form" label-width="100px">
          <h2>基础信息</h2>
          <el-form-item label="活动名称:">
            <el-input
              v-model="form.activityName"
              maxlength="20"
              placeholder="请输入活动名称"
              :disabled="unStart"
            />
          </el-form-item>

          <el-form-item label="活动介绍:">
            <el-input
              v-model="form.activityIntroduce"
              maxlength="200"
              type="textarea"
              placeholder="请输入活动介绍"
              :disabled="unStart"
            />
          </el-form-item>
          <!-- :picker-options="pickerOptions" -->

          <el-form-item label="报名时间:">
            <el-date-picker
              :shortcuts="pickerOptions1 && pickerOptions1.shortcuts"
              :disabled-date="pickerOptions1 && pickerOptions1.disabledDate"
              :cell-class-name="pickerOptions1 && pickerOptions1.cellClassName"
              v-model="date2"
              type="datetimerange"
              range-separator="至"
              start-placeholder="开始时间"
              end-placeholder="结束时间"
              value-format="yyyy-MM-dd HH:mm:ss"
            ></el-date-picker>
            <p class="timeInfo">报名时间不能交叉且报名时间不能大于活动时间</p>
          </el-form-item>

          <el-form-item label="活动时间:">
            <el-date-picker
              :shortcuts="pickerOptions && pickerOptions.shortcuts"
              :disabled-date="pickerOptions && pickerOptions.disabledDate"
              :cell-class-name="pickerOptions && pickerOptions.cellClassName"
              v-model="date1"
              type="datetimerange"
              range-separator="至"
              start-placeholder="开始时间"
              end-placeholder="结束时间"
              value-format="yyyy-MM-dd HH:mm:ss"
              :disabled="applyEnd"
            ></el-date-picker>
            <p class="timeInfo">
              平台活动时间不能交叉并且活动时间不能小于报名时间
            </p>
          </el-form-item>

          <el-form-item label="活动保证金:">
            <el-radio-group v-model="form.ifBond">
              <el-radio :label="1" :disabled="unStart">需要</el-radio>
              <el-radio :label="0" :disabled="unStart">不需要</el-radio>
            </el-radio-group>
          </el-form-item>

          <el-form-item v-if="form.ifBond === 1" label="保证金金额:">
            <el-input
              v-model="form.bondMoney"
              maxlength="9"
              placeholder="请输入活动保证金金额"
              :disabled="unStart"
            />
          </el-form-item>

          <el-form-item label="活动标签">
            <el-input
              v-model="form.activityLabel"
              maxlength="20"
              placeholder="请输入活动标签"
              :disabled="unStart"
            />
          </el-form-item>

          <h2>优惠规则</h2>
          <el-form-item label="优惠方式:">
            <el-radio-group
              v-model="form.discountMode"
              @change="selectDiscount"
            >
              <el-radio :label="1" :disabled="unStart">满减</el-radio>
              <el-radio :label="2" :disabled="unStart">优惠券</el-radio>
            </el-radio-group>
          </el-form-item>

          <el-form-item label="优惠方案:">
            <el-radio-group
              v-model="form.discountProgramme"
              @change="selectPreScheme"
            >
              <el-radio
                :label="1"
                :disabled="form.discountMode === 2 || unStart"
                >叠加优惠</el-radio
              >
              <el-radio :label="2" :disabled="unStart">阶梯优惠</el-radio>
            </el-radio-group>
          </el-form-item>

          <el-form-item v-for="(item, index) in list" :key="index">
            <el-col :span="10">
              满
              <el-input
                v-model="item.fullMoney"
                maxlength="9"
                style="width: 80%"
                :disabled="unStart"
              />
            </el-col>
            <el-col :span="10">
              减
              <el-input
                v-model="item.reduceMoney"
                maxlength="9"
                style="width: 80%"
                :disabled="unStart"
              />
            </el-col>
          </el-form-item>

          <el-form-item v-if="form.discountProgramme === 2">
            <el-button type="primary" :disabled="unStart" @click="add"
              >添加层级</el-button
            >
          </el-form-item>
        </el-form>
      </el-col>
      <el-col :span="12">
        <div class="photo">
          <el-upload
            class="avatar-uploader"
            :data="dataObj"
            :action="action"
            :show-file-list="false"
            :on-success="handleAvatarSuccess"
            :disabled="unStart"
          >
            <img
              v-if="form.image != ''"
              :src="form.image"
              class="avatar"
              width="80"
              height="80"
            />
            <el-icon class="avatar-uploader-icon"><el-icon-plus /></el-icon>
            <el-button size="small" type="primary" :disabled="unStart"
              >点击上传</el-button
            >
          </el-upload>
        </div>
      </el-col>
    </div>
  </div>
</template>

<script>
import { Plus as ElIconPlus } from '@element-plus/icons-vue'
import { activeAdd, activeUpdate, activeGetById } from '@/api/active'
import { uploadUrl } from '@/utils/request'
export default {
  components: {
    ElIconPlus,
  },
  data() {
    return {
      form: {
        activityName: '', // 活动名称
        activityIntroduce: '', // 活动介绍
        ifBond: 0, // 活动保证金
        bondMoney: '', // 保证金金额
        activityLabel: '', // 活动标签
        discountMode: 1, // 优惠方式
        discountProgramme: 1, // 优惠方案
        image: '',
      },
      list: [{ fullMoney: '', reduceMoney: '' }],
      date1: [], // 活动时间
      date2: [], // 报名时间
      type: false,
      title: '',
      headers: {
        Authorization: '',
      },
      action: uploadUrl,
      dataObj: {
        folderId: 1,
      },
      pickerOptions: {
        // disabledDate: time => {
        //   const t = this.$route.query.info;
        //   console.log(this.date1)
        //   if (this.date1[0] !== "" && t && t.status === 2) {
        //     return time.getTime() ;
        //   }
        //   return "";
        // }
      },
      pickerOptions1: {
        // disabledDate: time => {
        //   const t = this.$route.query.info;
        //   if (this.date2[0] !== "" && t && (t.status === 3 || t.status === 4)) {
        //     return time.getTime() < new Date(this.date2[0]).getTime();
        //   }
        //   return "";
        // }
      },
    }
  },
  computed: {
    info() {
      return this.$route.query.info || {}
    },
    unStart() {
      const t = this.$route.query.info
      return t && !(t.state === 1 || t.state === 0 || t.state === 2)
    },
    applyEnd() {
      const t = this.$route.query.info
      return t && (t.state === 3 || t.state === 4)
    },
  },
  created() {
    console.log(this.info)
    this.getDetails()
  },
  methods: {
    async getDetails() {
      this.title = this.info.activityId ? '修改活动' : '新增活动'
      const res = await activeGetById({ activityId: this.info.activityId })
      if (JSON.stringify(res.data) !== '{}') {
        this.form = res.data
        this.date1 = [res.data.activityStartTime, res.data.activityEndTime]
        this.date2 = [res.data.signStartTime, res.data.signEndTime]
        const list = res.data.promotionDetail
        console.log(list)
        if (list.length) {
          list.map((item) => {
            item.fullMoney /= 1
            item.reduceMoney /= 1
          })
          this.list = list
        }
      }
    },
    selectDiscount(v) {
      if (v === 2) {
        this.form.discountProgramme = 2
      }
    },
    selectPreScheme(v) {
      if (v === 1) {
        this.list = [{ fullMoney: '', reduceMoney: '' }]
      }
    },
    add() {
      if (this.form.discountProgramme === 2) {
        this.list.push({ fullMoney: '', reduceMoney: '' })
      }
    },
    cancel() {
      this.$router.go(-1)
    },
    save() {
      const vm = this
      const temp = []
      vm.list.forEach((item) => {
        temp.push({
          fullMoney: item.fullMoney * 1,
          reduceMoney: item.reduceMoney * 1,
        })
      })
      const params = Object.assign({}, vm.form, {
        activityStartTime: vm.date1[0] || '',
        activityEndTime: vm.date1[1] || '',
        signStartTime: vm.date2[0] || '',
        signEndTime: vm.date2[1] || '',
        promotionDetail: temp,
        bondMoney: vm.form.bondMoney * 1,
      })
      console.log(params)
      console.log(vm.date1, vm.date2)
      if (params.activityName === '') {
        this.$message.error('请输入活动名称')
        return
      }
      if (params.activityIntroduce === '') {
        this.$message.error('请输入活动介绍')
        return
      }
      if (vm.date2.length === 0) {
        this.$message.error('请选择报名时间')
        return
      }
      if (vm.date1.length === 0) {
        this.$message.error('请选择活动时间')
        return
      }
      if (params.activityLabel === '') {
        this.$message.error('请输入活动标签')
        return
      }
      if (vm.info.activityId) {
        params.details = params.promotionDetail
        return activeUpdate(
          Object.assign(params, { id: vm.info.activityId })
        ).then((res) => {
          if (res.code === '') {
            this.$message({
              message: '修改成功',
              type: 'success',
            })
            vm.reset()
            vm.cancel()
          }
        })
      }
      console.log(222)
      return activeAdd(params).then((res) => {
        if (res.code === '') {
          this.$message({
            message: '新增成功',
            type: 'success',
          })
          vm.reset()
          vm.cancel()
        }
      })
    },
    handleAvatarSuccess(response) {
      console.log(response)
      const url = response.data.url
      this.form.image = url
      console.log(this.form)
    },
    reset() {
      this.form = {
        activityName: '',
        activityIntroduce: '',
        ifBond: 2,
        bondMoney: '',
        activityLabel: '',
        discountMode: 1,
        discountProgramme: 1,
        image: '',
        promotionDetail: '',
        activityStartTime: '',
        activityEndTime: '',
        signStartTime: '',
        signEndTime: '',
      }
      this.list = [{ fullMoney: '', reduceMoney: '' }]
      this.date1 = []
      this.date2 = []
    },
  },
}
</script>

<style lang="scss" scoped>
.edit_add_page {
  padding: 20px;
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
    .title {
      height: 100px;
      line-height: 100px;
      font-size: 24px;
      position: relative;
      border-bottom: 1px solid #e0e5eb;
      .btn_list {
        position: absolute;
        right: 0;
        top: 0;
        height: 50px;
        span {
          padding: 0;
          margin: 0;
          width: 100px;
          height: 50px;
          line-height: 50px;
          text-align: center;
          display: inline-block;
          font-size: 16px;
          border-radius: 4px;
          box-sizing: border-box;
          &:hover {
            cursor: pointer;
          }
          &:nth-child(1) {
            background: rgba(255, 255, 255, 1);
            order: 1px solid rgba(224, 229, 235, 1);
            margin-right: 20px;
            border: 1px solid rgba(224, 229, 235, 1);
          }
          &:nth-child(2) {
            background: rgba(58, 104, 242, 1);
            color: #fff;
          }
        }
      }
    }
    .el-form {
      .el-form-item {
        label.el-form-item__label {
          font-size: 16px !important;
          color: red !important;
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
  .timeInfo {
    font-size: 12px;
    color: #999999;
  }
}
</style>
