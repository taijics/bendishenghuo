<template>
  <el-dialog :close-on-click-modal="false" :title="isAdd ? '新增运营计划' : '修改运营计划'" width="80%" :visible.sync="visible">
    <div>
      <div class="addOperate">
        <div class="addOperateBox">
          <el-form ref="ruleForm" class="formBox" :model="addForm" label-width="150px" :rules="operateRules">
            <el-form-item label="计划名称" prop="operateName" class="inputW">
              <el-input v-model="addForm.operateName" placeholder="请输入计划名称" oninput="value=value.replace(/\s+/g, '')" maxlength="20" />
            </el-form-item>
            <el-form-item label="计划人群" prop="couponName">
              <div class="selectCrowd">
                <span @click="selectCrowdFn">选择人群</span>
                <div v-if="currentName !== ''" class="currentCrowd">已选人群：{{ currentName }}</div>
                <p>每次推送人数建议小于10万，否则容易出现延时的情况</p>
              </div>
            </el-form-item>
            <el-form-item label="计划方式" prop="couponName">
              <div class="planningMethod">
                <div class="autoPlan">
                  <el-radio v-model="addForm.planMode" label="1">自动长期计划</el-radio>
                  <p>人群中如果有满足条件的新增客户，新增的客户会自动收到营销通知。</p>
                </div>
                <div v-show="addForm.planMode === '1'" class="autoTimeBox">
                  <span class="autoTimeText">计划执行时间</span>
                  <el-form-item>
                    <el-date-picker
                      v-model="dateInfo"
                      type="datetimerange"
                      range-separator="至"
                      start-placeholder="开始日期"
                      end-placeholder="结束日期"
                      value-format="yyyy-MM-dd HH:mm:ss"
                    />
                  </el-form-item>
                </div>
                <div class="mtPlan">
                  <el-radio v-model="addForm.planMode" label="2">手动定时计划</el-radio>
                  <p>在指定时间向计划人群发送营销通知</p>
                  <div v-show="addForm.planMode === '2'" class="timeSelectBox">
                    <el-radio v-model="timeType" label="1">立即执行</el-radio>
                    <el-radio v-model="timeType" label="2">选择执行</el-radio>
                    <el-date-picker
                      v-model="addForm.manualTime"
                      type="datetime"
                      placeholder="选择日期时间"
                      :disabled="timeType === '1'"
                      value-format="yyyy-MM-dd HH:mm:ss"
                    />
                  </div>
                </div>
              </div>
            </el-form-item>
            <el-form-item label="优惠券配置" prop="couponName">
              <div class="couponBox">
                <el-checkbox v-model="couponChecked">发放优惠券</el-checkbox>
                <p class="info">发放优惠券能有效刺激转化（优惠券将直接发放给客户，不需要领取）</p>
                <div class="couponList" v-if="addForm.coupons && addForm.coupons.length > 0">
                  <el-table
                    :data="addForm.coupons"
                    border
                    :header-cell-style="{ background: '#EEF3FF', color: '#333333' }"
                    tooltip-effect="dark"
                    style="width: 700px"
                  >
                    <el-table-column prop="couponName" label="优惠券" align="center" width="220" />
                    <el-table-column prop="content" label="优惠内容" align="center" show-overflow-tooltip />
                    <el-table-column prop="stockNumber" label="库存" align="center" show-overflow-tooltip />
                    <el-table-column prop="number" align="center" label="赠券数"/>
                  </el-table>
                </div>
                <span v-if="couponChecked" class="selectCoupon" @click="selectCoupon">选择优惠券</span>
              </div>
            </el-form-item>
          </el-form>
          <div class="btnBox">
            <el-button type="primary" @click="savaSubmit">提交</el-button>
            <el-button @click="goToList">取消</el-button>
          </div>
        </div>
      </div>
      <el-dialog
        :close-on-click-modal="false"
        title="选择人群"
        append-to-body
        :visible.sync="isVisible"
        width="50%"
        top="50px"
        class="dialogOperate"
      >
        <div class="formSearch">
          <el-form :inline="true" :model="formInline" class="demo-form-inline">
            <el-form-item label="分组名称">
              <el-input v-model="formInline.search" maxlength="20" placeholder="请输入人群名称" />
            </el-form-item>
            <el-form-item>
              <el-button type="primary" plain @click="search">查询</el-button>
            </el-form-item>
          </el-form>
        </div>
        <!-- 表格 -->
        <div class="tableBox">
          <el-table
            ref="operateTable"
            :data="tableData"
            border
            :header-cell-style="{ background: '#EEF3FF', color: '#333333' }"
            tooltip-effect="dark"
            style="width: 100%"
          >
            <el-table-column label="选择" width="55" align="center">
              <template slot-scope="scope">
                <el-radio v-model="currentData" :label="scope.$index" @change.native="getCurrentRow(scope.row)" />
              </template>
            </el-table-column>
            <el-table-column prop="crowdName" label="人群名称" width="220" align="center" />
            <el-table-column prop="content" label="人群定义" align="center" show-overflow-tooltip />
            <el-table-column prop="users" label="人群人数" align="center" show-overflow-tooltip />
          </el-table>
          <div class="fenye">
            <el-pagination
              :current-page="formInline.page"
              :page-sizes="[5, 20, 50, 100]"
              :page-size="formInline.pageSize"
              layout="total, sizes, prev, pager, next, jumper"
              :total="crowdTotal"
              @size-change="handleSizeChange"
              @current-change="handleCurrentChange"
            />
            <span slot="footer" class="dialog-footer">
              <el-button type="primary" @click="saveCrowdId">确 定</el-button>
              <el-button @click="closeSelect">取 消</el-button>
            </span>
          </div>
        </div>
      </el-dialog>
      <!--    选择优惠券弹窗-->
      <el-dialog
        :close-on-click-modal="false"
        title="选择优惠券"
        :visible.sync="couponIsVisible"
        width="50%"
        top="50px"
        append-to-body
        class="group-dialog"
      >
        <!-- 表格 -->
        <div class="tableBox">
          <el-table
            ref="couponTable"
            :data="couponTableData"
            border
            :header-cell-style="{ background: '#EEF3FF', color: '#333333' }"
            tooltip-effect="dark"
            style="width: 100%"
            row-key="shopCouponId"
            @selection-change="selectCouponChange"
          >
            <el-table-column
              type="selection"
              :reserve-selection="true"
              width="55"
            />
            <el-table-column prop="couponName" label="优惠券" align="center" width="220" />
            <el-table-column prop="content" label="优惠内容" align="center" show-overflow-tooltip />
            <el-table-column prop="stockNumber" label="库存" align="center" show-overflow-tooltip />
            <el-table-column prop="number" align="center" label="赠券数" width="220">
              <template slot-scope="scope">
                <el-input-number v-model="scope.row.number" controls-position="right" :min="1" :max="99" @change="handleNumChange" />
              </template>
            </el-table-column>
          </el-table>
          <div class="fenye">
            <el-pagination
              :current-page="couponOption.page"
              :page-sizes="[5, 20, 50, 100]"
              :page-size="couponOption.pageSize"
              layout="total, sizes, prev, pager, next, jumper"
              :total="couponTotal"
              @size-change="handleSizeChange"
              @current-change="handleCurrentChange"
            />
            <span slot="footer" class="dialog-footer">
              <el-button type="primary" @click="saveIdCouponList">确 定</el-button>
              <el-button @click="closeSelectCoupon">取 消</el-button>
            </span>
          </div>
        </div>
      </el-dialog>
    </div>
  </el-dialog>
</template>

<script>
import { selectCrowdData, getSelectCoupon, saveOperate, operateUpdate, getOperateDetail } from '@/api/customer'
export default {
  name: 'AddOperate',
  data() {
    return {
      visible: false,
      isAdd: false,
      timeType: '1', // 手动执行类型
      addForm: {
        operateName: '',
        planMode: '1', // 计划方式 1-自动长期计划 2-手动定时计划
        shopCrowdId: '', // 店铺人群ID
        planStart: '', // 长期计划开始时间
        planEnd: '', // 长期计划结束时间
        manualTime: '', // 手动执行时间
        coupons: [], // 优惠券列表
        shopOperateId: null
      },
      couponChecked: false,
      dateInfo: [],
      tableData: [], // 人群数据
      idList: [], // 优惠期ID
      multipleSelection: [],
      currentCrowd: {
        name: '',
        id: ''
      }, // 当前选择人群
      currentData: '',
      currentName: '',
      total: 1,
      // operateRules: {
      //   operateName: [
      //     { required: true, message: '请输入计划名称！', trigger: 'blur' }
      //   ],
      // },
      formInline: {
        crowdName: '', // 人群名称
        max: null,
        min: null,
        page: 1, // 当前页
        pageSize: 10 // 每页记录数
      },
      crowdTotal: 0,
      couponData: [], // 优惠券数据
      isVisible: false,
      couponIsVisible: false,
      couponOption: {
        endTime: '',
        page: 1,
        pageSize: 10,
        startTime: ''
      },
      couponTotal: 0,
      couponTableData: [], // 优惠券表格数据
      shopOperateId: '',
      operateRules: {
        operateName: [
          { required: true, message: '请输入计划名称', trigger: 'blur' }
        ]
      }
    }
  },
  mounted() {
    this.getCrowdData(this.formInline)
    this.getCouponData(this.couponOption)
  },
  methods: {
    show(id) {
      this.visible = true
      if (id) {
        this.isAdd = false
        this.shopOperateId = id
        this.getOperateInfo()
      } else {
        this.isAdd = true
        this.currentName = ''
        this.dateInfo = []
        this.addForm = {
          operateName: '',
          planMode: '1', // 计划方式 1-自动长期计划 2-手动定时计划
          shopCrowdId: '', // 店铺人群ID
          planStart: '', // 长期计划开始时间
          planEnd: '', // 长期计划结束时间
          manualTime: '', // 手动执行时间
          coupons: [], // 优惠券列表
          shopOperateId: null
        }
      }
    },
    // 初始化查询所有数据
    async getCrowdData(formInline) {
      const res = await selectCrowdData(formInline)
      this.crowdTotal = res.data.total
      this.tableData = res.data.list
    },
    // 初始化查询优惠券
    async getCouponData(couponOption) {
      const res = await getSelectCoupon(couponOption)
      this.couponTotal = res.data.total
      this.couponTableData = res.data.list
      const _coupons = this.addForm.coupons
      if (_coupons.length > 0) {
        this.couponTableData.forEach(row => {
          for (let i = 0; i < _coupons.length; i++) {
            if (_coupons[i].shopCouponId === row.shopCouponId) {
              this.$refs.couponTable.toggleRowSelection(row, true)
            }
          }
        })
      }
    },
    async getOperateInfo() {
      const res = await getOperateDetail({ shopOperateId: this.shopOperateId })
      this.addForm = res.data
      this.addForm.planMode = this.addForm.planMode.toString()
      this.timeType = res.data.ifImplement.toString()
      console.log(res, 'res')
    },
    // 选择人群
    selectCrowdFn() {
      this.isVisible = true
    },
    getCurrentRow(row) {
      this.currentCrowd.name = row.crowdName
      this.currentCrowd.id = row.shopCrowdId
      console.log(row)
    },
    // 确认选择人群
    saveCrowdId() {
      this.currentName = this.currentCrowd.name
      this.addForm.shopCrowdId = this.currentCrowd.id
      this.isVisible = false
    },
    // 选中优惠券
    selectCouponChange(val) {
      console.log(val, 'val')
      this.multipleSelection = val
    },
    // 取消选择
    closeSelect() {
      this.isVisible = false
    },
    handleSizeChange(val) {
      this.proOption.pageSize = val
      this.getProList()
    },
    handleCurrentChange(val) {
      this.proOption.page = val
      this.getProList()
    },
    search() {
      this.getCrowdData(this.formInline)
    },
    // 选择优惠券
    selectCoupon() {
      this.couponIsVisible = true
      this.couponOption.startTime = this.dateInfo[0]
      this.couponOption.endTime = this.dateInfo[1]
      this.getCouponData(this.couponOption)
    },
    // 保存选择优惠券
    saveIdCouponList() {
      // const idList = []
      // console.log(this.multipleSelection, 'multipleSelection')
      // this.multipleSelection.forEach(i => {
      //   idList.push(i.shopCouponId)
      // })
      this.addForm.coupons = this.multipleSelection
      this.$refs.couponTable.clearSelection()
      this.$message({
        message: '选择优惠券保存成功',
        type: 'success'
      })
      this.couponIsVisible = false
    },
    // 取消选择优惠券
    closeSelectCoupon() {
      this.couponIsVisible = false
    },
    handleNumChange(value) {
      console.log(value)
    },
    // 返回列表
    goToList() {
      this.visible = false
    },
    // 保存提交
    savaSubmit() {
      console.log(this.addForm, 'this.addForm')
      if (this.addForm.operateName === '') {
        this.$message({
          message: '请输入计划名称',
          type: 'warning'
        })
        return false
      }
      if (this.addForm.shopCrowdId === '') {
        this.$message({
          message: '请选择店铺人群',
          type: 'warning'
        })
        return false
      }
      if (this.addForm.planMode === '1') {
        if (this.dateInfo === []) {
          this.$message({
            message: '请选择计划执行时间',
            type: 'warning'
          })
          return false
        } else {
          this.addForm.planStart = this.dateInfo[0]
          this.addForm.planEnd = this.dateInfo[1]
        }
      }
      if (this.addForm.planMode === '2') {
        if (this.timeType === '2') {
          if (this.addForm.manualTime === '') {
            this.$message({
              message: '请选择手动计划时间',
              type: 'warning'
            })
            return false
          }
        }
      }
      if (this.couponChecked) {
        if (this.addForm.coupons.length === 0) {
          this.$message({
            message: '请选择优惠券',
            type: 'warning'
          })
          return false
        }
      }
      if (this.shopOperateId) {
        operateUpdate(this.addForm).then(res => {
          console.log(res)
          if (res.code === '') {
            this.$message({
              message: '修改成功',
              type: 'success'
            })
            this.visible = false
          } else {
            this.$message({
              message: res.message,
              type: 'error'
            })
          }
        })
      } else {
        saveOperate(this.addForm).then(res => {
          console.log(res)
          if (res.code === '') {
            this.$message({
              message: '提交成功',
              type: 'success'
            })
            this.visible = false
          } else {
            this.$message({
              message: res.message,
              type: 'error'
            })
          }
        })
      }
    }
  }
}
</script>

<style lang="scss" scoped>
.padding {
  padding: 30px;
}
.addOperateBox {
  margin-left: 200px;
  .btnBox {
    margin: 50px 0 0 150px;
  }
}
.addOperate {
  background: #FFFFFF;
  h3 {
    margin-bottom: 80px;
  }
  .selectCrowd {
    span {
      color: #409EFF;
      cursor: pointer;
      font-weight: 500;
    }
    p {
      height: 30px;
      line-height: 30px;
      margin: 0;
      color: #666666;
      font-size: 12px;
    }
  }
  .autoTimeBox {
    display: flex;
    span{
      margin-right: 20px;
    }
  }
  .couponBox {
    .info {
      color: #666666;
      font-size: 12px;
      margin: 0;
    }
    .selectCoupon {
      cursor: pointer;
      color: #409EFF;
      font-size: 14px;
      font-weight: 500;
    }
  }
}
</style>
<style scoped>
.fenye {
  margin-top: 30px;
}
.formSearch /deep/ .el-form {
  display: flex;
  flex-wrap: wrap;
}
.btnBox /deep/ .el-radio {
  margin-right: 8px;
}
.btnBox /deep/ .el-radio__label {
  display: none;
}
.fenye /deep/ .dialog-footer {
  margin: 30px auto 0 auto;
  display: flex;
  justify-content: center;
}
.inputW /deep/ .el-form-item__content {
  width: 300px;
  margin: 0 8px;
}
.dialogOperate /deep/ .el-radio .el-radio__label {
  display: none;
}
</style>
