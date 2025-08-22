<!--
    * @FileDescription: form
    * @Author: kahu
    * @Date: 2022/8/25
    * @LastEditors: kahu
    * @LastEditTime: 2022/8/25
-->
<template>
  <div class="form_content">
    <el-dialog
      :close-on-click-modal="false"
      :title="dialogOption.title"
      :visible.sync="diaShow"
      width="40%"
      :before-close="handleClose"
    >
      <el-form
        ref="form"
        :model="form"
        :rules="formRules"
        label-width="120px"
      >
        <el-form-item
          label="活动名称："
          prop="activityName"
        >
          <el-input
            v-model="form.activityName"
            show-word-limit
            maxlength="15"
            :disabled="form.isLook"
            clearable
            type="text"
            placeholder="请输入渠道名称"
          />
        </el-form-item>
        <el-form-item
          label="备注："
          prop="remark"
        >
          <el-input
            v-model="form.remark"
            maxlength="200"
            :disabled="form.isLook"
            clearable
            type="text"
            placeholder="请输入备注"
          />
        </el-form-item>
        <el-form-item
          label="活动时间："
          prop="startTime"
        >
          <el-date-picker
            v-model="activityTimeArr"
            :disabled="form.isLook"
            range-separator="至"
            type="datetimerange"
            start-placeholder="开始日期"
            end-placeholder="结束日期"
            value-format="yyyy-MM-dd HH:mm:ss"
          />
        </el-form-item>
        <el-form-item
          label="活动发放数量："
          prop="publishCount"
        >
          <el-input-number
            v-model="form.publishCount"
            :disabled="form.isLook"
            :controls="false"
            :max="999999999"
            :min="1"
          />
          份
        </el-form-item>
        <el-form-item label="发放渠道券" prop="couponList">
          <el-button
            :disabled="form.isLook"
            type="primary"
            @click="showCouponSelect"
          >请选择
          </el-button>
        </el-form-item>
        <el-form-item label=" ">
          <el-table
            ref="multipleTable"
            :data="form.couponList"
            border
            :header-cell-style="{ background: '#EEF3FF', color: '#333333' }"
            tooltip-effect="dark"
            style="width: 100%"
          >
            <el-table-column
              label="优惠券名称"
              width="220"
            >
              <template slot-scope="scope">{{ scope.row.couponName }}</template>
            </el-table-column>
            <el-table-column
              label="类型"
              show-overflow-tooltip
            >
              <template slot-scope="scope">
                <span v-if="scope.row.couponType === 1">满减券</span>
                <span v-if="scope.row.couponType === 2">折扣券</span>
              </template>
            </el-table-column>
            <el-table-column
              label="状态"
              show-overflow-tooltip
            >
              <template slot-scope="scope">
                <span v-if="scope.row.state === 0">未开始</span>
                <span v-if="scope.row.state === 1">进行中</span>
                <span v-if="scope.row.state === 2">已结束</span>
              </template>
            </el-table-column>
            <el-table-column
              prop="content"
              label="内容"
              show-overflow-tooltip
            />
            <el-table-column
              prop="createTime"
              label="创建时间"
              show-overflow-tooltip
            />
            <el-table-column
              label="操作"
              fixed="right"
            >
              <template v-slot="scope">
                <el-button type="danger" :disabled="form.isLook" @click="handleDelSelectCoupon(scope.row)">删除</el-button>
              </template>
            </el-table-column>
          </el-table>
        </el-form-item>
      </el-form>
      <span
        slot="footer"
        class="dialog-footer"
      >
        <el-button @click="handleClose">取 消</el-button>
        <el-button
          :loading="loading"
          type="primary"
          @click="handleConfirm"
        >确 定</el-button>
      </span>
    </el-dialog>
    <SelectChannelCoupons
      v-model="showSelect"
      :default-selection="form.couponList"
      :take-end="form.endTime"
      :stock-number="form.publishCount"
      @confirm="handleSelectChannelCoups"
    />
  </div>
</template>

<script>
import SelectChannelCoupons from '@/views/marketing/channelActivity/selectChannelCoupons';
import { add, edit, getCouponsByActivityId } from '@/api/channelActivity';
const Form = function() {
  this.id = null
  this.activityName = null
  this.remark = null
  this.startTime = null
  this.endTime = null
  this.publishCount = null
  this.couponList = []
  this.isLook = false
}
export default {
  name: 'Form',
  components: { SelectChannelCoupons },
  model: {
    prop: 'show',
    event: 'change'
  },
  props: {
    show: {
      type: Boolean,
      default: () => false
    },
    item: {
      // eslint-disable-next-line vue/require-prop-type-constructor
      type: Object | null,
      default: () => ({
        id: null,
        name: null
      })
    }
  },
  data() {
    const validateCouponList = (rule, value, callback) => {
      if (this.form.couponList.length <= 0) {
        callback(new Error('请选择渠道优惠券'))
        return
      }
      callback()
    }
    return {
      loading: false,
      dialogOption: {
        title: '新增渠道券活动'
      },
      form: {
        id: null,
        activityName: null,
        remark: null,
        startTime: null,
        endTime: null,
        publishCount: null,
        couponList: [],
        isLook: false
      },
      formRules: {
        activityName: [
          { required: true, message: '请输入活动名称', trigger: 'blur' },
          { min: 1, max: 15, message: '活动名称长度在1-15个字符', trigger: 'blur' }
        ],
        startTime: [
          { required: true, message: '请选择活动时间', trigger: 'blur' }
        ],
        publishCount: [
          { required: true, message: '请输入活动发放数量', trigger: 'blur' }
        ],
        couponList: [
          { validator: validateCouponList, trigger: 'blur' }
        ]
      },
      // 是否显示选择券
      showSelect: false
    }
  },
  computed: {
    diaShow: {
      get() {
        return this.show
      },
      set(value) {
        this.$emit('change', value)
      }
    },
    activityTimeArr: {
      get() {
        if (!this.form.startTime || !this.form.endTime) return []
        return [this.form.startTime, this.form.endTime]
      },
      set(val) {
        if (!val) {
          this.form.startTime = null
          this.form.endTime = null
          return
        }
        this.form.startTime = val[0]
        this.form.endTime = val[1]
      }
    }
  },
  watch: {
    'item': {
      deep: true,
      handler() {
        if (this.item?.id) {
          this.dialogOption.title = '修改渠道券活动'
          this.form = JSON.parse(JSON.stringify(this.item))
        } else {
          this.dialogOption.title = '新增渠道券活动'
          this.form = new Form()
          this.handleResetForm()
        }
      }
    },
    'diaShow'(val) {
      if (this.item.id && val) {
        // 编辑查询优惠券
        this.handleGetCouponsByActivityId()
      }
    }
  },
  methods: {
    showCouponSelect() {
      if (!this.form.startTime || !this.form.endTime) {
        this.$message.warning('请先选择活动时间')
        return
      }
      this.showSelect = true
    },
    handleSelectChannelCoups(selection) {
      this.form.couponList = selection
    },
    handleDelSelectCoupon(item) {
      const { couponList } = this.form
      const spliceIndex = couponList.findIndex(e => e.shopCouponId === item.shopCouponId);
      couponList.splice(spliceIndex, 1)
    },
    handleConfirm() {
      if (this.form.isLook) {
        this.diaShow = false
        this.handleResetForm()
        this.form.couponList = []
        return
      }
      this.$refs.form.validate(async validate => {
        if (!validate) return this.$message.error('请完善表单')
        this.loading = true
        this.form.couponList.forEach(item => {
          item.couponId = item.shopCouponId
        })
        try {
          if (this.form.id) {
            this.form.couponList.forEach(item => {
              item.id = this.form.id
            })
            // 修改
            await edit(this.form)
          } else {
            await add(this.form)
          }
        } finally {
          this.loading = false
        }
        this.$message.success('操作成功')
        this.diaShow = false
        this.handleResetForm()
        this.form.couponList = []
        this.$emit('confirm', this.form)
      })
    },

    // 获取活动优惠券
    async handleGetCouponsByActivityId() {
      const { data } = await getCouponsByActivityId({ channelActivityId: this.form.id, page: 1, pageSize: 10000 });
      this.$set(this.form, 'couponList', data.list)
    },
    handleClose() {
      this.handleResetForm()
      this.$emit('close', this.form)
      this.form.couponList = []
      this.diaShow = false
    },
    handleResetForm() {
      this.$refs.form?.resetFields()
    }
  }
}
</script>

<style
  lang="scss"
  scoped
>
.form_content {

}
</style>

