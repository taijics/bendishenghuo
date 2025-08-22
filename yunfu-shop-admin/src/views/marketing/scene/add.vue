<template>
  <div class="addCoupon">
    <!-- 新增用户 -->
    <div class="addCouponBox">
      <el-form ref="ruleForm" class="formBox" :model="addForm" label-width="150px" :rules="couponRules">
        <el-form-item label="营销类型">
          <el-radio v-model="addForm.sceneType" :label="1">节日营销</el-radio>
          <el-radio v-model="addForm.sceneType" :label="2">会员日营销</el-radio>
          <el-radio v-model="addForm.sceneType" :label="3">生日营销</el-radio>
        </el-form-item>
        <el-form-item label="营销名称" prop="sceneName">
          <el-input v-model="addForm.sceneName" maxlength="20" placeholder="请输入营销名称" onblur="value=value.replace(/(^\s*)|(\s*$)/g, '')" />
        </el-form-item>
        <el-form-item class="item-time" label="营销时间" prop="sceneTime">
          <div v-if="addForm.sceneType === 1">
            <el-date-picker
              v-model="dateInfo"
              :disabled="addForm.timeType === '2'"
              type="datetimerange"
              range-separator="至"
              start-placeholder="开始日期"
              end-placeholder="结束日期"
              value-format="yyyy-MM-dd HH:mm:ss"
            />
          </div>
          <div v-if="addForm.sceneType === 2">
            <dl class="dl-month">
              <dt><el-radio v-model="addForm.sceneTimeType" :label="1">每月</el-radio></dt>
              <dd>
                每月<el-input v-model="monthStart" maxlength="9" oninput="value=value.replace(/[^\d]/g,'')" />日 至 每月<el-input v-model="monthEnd" maxlength="9" oninput="value=value.replace(/[^\d]/g,'')" />日
              </dd>
            </dl>
            <dl>
              <dt><el-radio v-model="addForm.sceneTimeType" :label="2">每周</el-radio></dt>
              <dd>
                <el-checkbox-group v-model="weekList">
                  <el-checkbox label="1">周一</el-checkbox>
                  <el-checkbox label="2">周二</el-checkbox>
                  <el-checkbox label="3">周三</el-checkbox>
                  <el-checkbox label="4">周四</el-checkbox>
                  <el-checkbox label="5">周五</el-checkbox>
                  <el-checkbox label="6">周六</el-checkbox>
                  <el-checkbox label="7">周日</el-checkbox>
                </el-checkbox-group>
              </dd>
            </dl>
            <dl>
              <dt><el-radio v-model="addForm.sceneTimeType" :label="3">每日</el-radio></dt>
              <dd>
                <el-time-picker
                  v-model="dayTime"
                  is-range
                  range-separator="至"
                  start-placeholder="开始时间"
                  end-placeholder="结束时间"
                  placeholder="选择时间范围"
                  value-format="HH:mm:ss"
                />
              </dd>
            </dl>
          </div>
          <div v-if="addForm.sceneType === 3">
            <el-radio-group v-model="addForm.sceneTimeType">
              <el-radio :label="4">生日当天</el-radio>
              <el-radio :label="5">生日当周</el-radio>
              <el-radio :label="6">生日当月</el-radio>
            </el-radio-group>
          </div>
        </el-form-item>
        <el-form-item class="item-rule" label="营销规则">
          <dl>
            <dt>
              <el-radio v-model="addForm.sceneRule" :label="1">所有等级会员，同一规则</el-radio>
            </dt>
            <dd>
              <el-table
                :data="vipList"
                border
              >
                <el-table-column
                  prop="memberLevelId"
                  label="会员等级"
                >
                  <template>
                    <span>全部等级</span>
                  </template>
                </el-table-column>
                <el-table-column
                  prop="ifFreeShipping"
                  label="包邮"
                >
                  <template slot-scope="scope">
                    <el-checkbox v-model="scope.row.ifFreeShipping" :true-label="1" :false-label="0">包邮</el-checkbox>
                  </template>
                </el-table-column>
                <el-table-column
                  prop="discount"
                  label="折扣"
                  show-overflow-tooltip
                >
                  <template slot-scope="scope">
                    <!-- <el-input v-model="scope.row.discount" type="number" oninput="value=value.replace(/([^\d|\.])/g, '')" /> 折 -->
                    <el-input-number v-model="scope.row.discount" :precision="1" :min="1" :max="9.9" /> 折
                  </template>
                </el-table-column>
                <el-table-column
                  prop="ids"
                  label="优惠券"
                  show-overflow-tooltip
                >
                  <template slot-scope="scope">
                    <span class="selectBtn" @click="selectCoupons(scope.row)">
                      请选择
                      <i v-if="scope.row.ids && scope.row.ids.length !== 0" class="selectNum">{{ scope.row.ids.length }}</i>
                    </span>
                  </template>
                </el-table-column>
              </el-table>
            </dd>
          </dl>
          <dl>
            <dt>
              <el-radio v-model="addForm.sceneRule" :label="2">不同等级会员，不同规则</el-radio>
            </dt>
            <dd>
              <el-table
                :data="vipList2"
                border
              >
                <el-table-column
                  prop="memberLevelName"
                  label="会员等级"
                />
                <el-table-column
                  prop="ifFreeShipping"
                  label="包邮"
                >
                  <template slot-scope="scope">
                    <el-checkbox v-model="scope.row.ifFreeShipping" :true-label="1" :false-label="0">包邮</el-checkbox>
                  </template>
                </el-table-column>
                <el-table-column
                  prop="discount"
                  label="折扣"
                  show-overflow-tooltip
                >
                  <template slot-scope="scope">
                    <!-- <el-input v-model="scope.row.discount" type="number" oninput="value=value.replace(/([^\d|\.])/g, '')" /> 折 -->
                    <el-input-number v-model="scope.row.discount" :precision="1" :min="1" :max="9.9" /> 折
                  </template>
                </el-table-column>
                <el-table-column
                  prop="ids"
                  label="优惠券"
                  show-overflow-tooltip
                >
                  <template slot-scope="scope">
                    <span class="selectBtn" @click="selectCoupons(scope.row)">
                      请选择
                      <i v-if="scope.row.ids && scope.row.ids.length !== 0" class="selectNum">{{ scope.row.ids.length }}</i>
                    </span>
                  </template>
                </el-table-column>
              </el-table>
            </dd>
          </dl>
        </el-form-item>
      </el-form>
    </div>
    <span slot="footer" class="dialog-footer">
      <el-button type="primary" @click="addCouponFn('ruleForm')">保 存</el-button>
      <el-button type="danger" @click="goToScene">取 消</el-button>
    </span>
    <!-- 新建分组弹框 -->
    <el-dialog
      title="选择优惠券"
      :visible.sync="isVisible"
      width="55%"
      top="50px"
      class="group-dialog"
      :close-on-click-modal="false"
      :modal-append-to-body="false"
      :modal="false"
    >
      <!-- 表格 -->
      <div class="tableBox">
        <el-table
          ref="multipleTable"
          :data="tableData"
          border
          :header-cell-style="{ background: '#EEF3FF', color: '#333333' }"
          tooltip-effect="dark"
          style="width: 100%"
          max-height="600"
          row-key="shopCouponId"
          @selection-change="handleSelectionChange"
        >
          <el-table-column
            type="selection"
            :reserve-selection="true"
            width="55"
          />
          <el-table-column label="优惠券名称" width="220">
            <template slot-scope="scope">{{ scope.row.couponName }}</template>
          </el-table-column>
          <el-table-column label="类型" show-overflow-tooltip>
            <template slot-scope="scope">
              <span v-if="scope.row.couponType === 1">满减券</span>
              <span v-if="scope.row.couponType === 2">折扣券</span>
            </template>
          </el-table-column>
          <el-table-column label="状态" show-overflow-tooltip>
            <template slot-scope="scope">
              <span v-if="scope.row.state === 0">未开始</span>
              <span v-if="scope.row.state === 1">进行中</span>
              <span v-if="scope.row.state === 2">已结束</span>
            </template>
          </el-table-column>
          <el-table-column prop="content" label="内容" show-overflow-tooltip />
          <el-table-column prop="createTime" label="创建时间" show-overflow-tooltip />
        </el-table>
        <div class="fenye">
          <el-pagination
            :current-page="proOption.page"
            :page-sizes="[10, 20, 50, 100]"
            :page-size="proOption.pageSize"
            layout="total, sizes, prev, pager, next, jumper"
            :total="total"
            @size-change="handleSizeChange"
            @current-change="handleCurrentChange"
          />
        </div>
        <div class="footBtnBox">
          <span slot="footer">
            <el-button type="primary" @click="saveIdList">确 定</el-button>
            <el-button @click="closeSelect">取 消</el-button>
          </span>
        </div>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import {
  getShopId
} from '@/utils/auth'
import { sceneUpate, sceneAdd, getMemberLevels, getCoupon, getSceneDetail } from '@/api/marketing'

function InitSceneForm() {
  this.sceneType = 1
  this.sceneRule = 1
  this.sceneTimeType = 1
  this.shopId = 0
}
export default {
  name: 'AddScene',
  props: {
    sceneId: {
      type: Number,
      default: 0
    }
  },
  data() {
    return {
      addForm: new InitSceneForm(),
      proOption: {
        page: 1,
        pageSize: 10
      },
      monthStart: '',
      monthEnd: '',
      weekList: [],
      dayTime: ['00:00:00', '23:59:59'],
      vipList: [{
        // memberLevelId: 0,
        ifFreeShipping: 0,
        discount: '',
        ids: []
      }],
      vipList2: [],
      dateInfo: [],
      total: 0,
      tableData: [],
      currentPage: 1,
      couponRules: {
        sceneName: [
          { required: true, message: '请输入营销名称', trigger: 'blur' }
        ]
      },
      multipleSelection: [],
      roleList: [],
      isVisible: false, // 选择商品弹窗
      Row: {},
    }
  },
  watch: {
    sceneId: {
      handler(nVal, oVal) {
        if (!nVal) {
          this.addForm = new InitSceneForm()
          this.dateInfo = [] // 清除时间
          this.vipList = [{
            // memberLevelId: 0,
            ifFreeShipping: 0,
            discount: '',
            ids: []
          }]
          this.getMemberLevels()
        } else {
          this.vipList = [{
            ifFreeShipping: 0,
            discount: '',
            ids: []
          }]
          this.getCouponInfo()
        }
      }
    }
  },
  mounted() {
    this.addForm.shopId = parseInt(getShopId())
    if (this.sceneId) {
      this.getCouponInfo()
    } else {
      this.getMemberLevels()
    }
  },
  methods: {
    // 选择优惠券
    async selectCoupons(row) {
      this.Row = row
      this.curVipId = row.memberLevelId
      this.getCouponList()
      this.multipleSelection = []
      this.isVisible = true
    },
    addCouponFn(ruleForm) {
      this.$refs[ruleForm].validate(valid => {
        if (valid) {
          console.log(this.addForm.sceneType, this.addForm.sceneTimeType)
          switch (this.addForm.sceneType) {
            // 节日营销
            case 1:
              if (this.dateInfo.length === 0) {
                this.$message.warning('节日营销时间不能为空！')
                return false
              } else {
                this.addForm.startTime = this.dateInfo[0]
                this.addForm.endTime = this.dateInfo[1]
              }
              break
            // 会员日营销
            case 2:
              if (this.addForm.sceneTimeType !== 1 && this.addForm.sceneTimeType !== 2 && this.addForm.sceneTimeType !== 3) {
                this.$message.warning('请选择营销时间！')
                return false
              }
              switch (this.addForm.sceneTimeType) {
                // 1-每月 2-每周 3-每日
                case 1:
                  if (!this.monthStart) {
                    this.$message.warning('请填写每月多少日开始！')
                    return false
                  } else if (!this.monthEnd) {
                    this.$message.warning('请填写每月多少日结束！')
                    return false
                  } else {
                    this.addForm.sceneTime = this.monthStart + '-' + this.monthEnd
                  }
                  break
                case 2:
                  if (this.weekList.length === 0) {
                    this.$message.warning('请选择每周多选框！')
                    return false
                  } else {
                    this.addForm.sceneTime = ''
                    for (let i = 1; i < 8; i++) {
                      var flag = false
                      for (let j = 0; j < this.weekList.length; j++) {
                        if (parseInt(this.weekList[j]) === i) {
                          flag = true
                          break
                        }
                      }
                      if (i === 1) {
                        this.addForm.sceneTime = flag ? i : 0
                      } else {
                        this.addForm.sceneTime += '-' + (flag ? i : 0)
                      }
                      console.log(this.addForm.sceneTime)
                    }
                  }
                  break
                case 3:
                  if (this.dayTime.length === 0) {
                    this.$message.warning('每日时间不能为空！')
                    return false
                  } else {
                    this.addForm.sceneTime = this.dayTime[0] + '至' + this.dayTime[1]
                  }
                  break
              }
              break
            // 生日营销
            case 3:
              if (this.addForm.sceneTimeType !== 4 && this.addForm.sceneTimeType !== 5 && this.addForm.sceneTimeType !== 6) {
                this.$message.warning('请选择营销时间！')
                return false
              }
              break
          }
          if (this.addForm.sceneRule === 1) {
            this.addForm.memberParams = this.vipList.map(item => {
              item.discount = parseInt(item.discount)
              return item
            })
          } else {
            var discountRule = true
            // var couponRule = true
            this.addForm.memberParams = this.vipList2.map(item => {
              const newItem = {
                memberLevelId: item.memberLevelId
              }
              newItem.ifFreeShipping = item.ifFreeShipping === 1 ? 1 : 0
              if (item.discount) {
                newItem.discount = parseInt(item.discount)
              } else {
                discountRule = false
              }
              if (item.ids && item.ids.length !== 0) {
                newItem.ids = item.ids
              }
              // else {
              //   couponRule = false
              // }
              return newItem
            })

            if (!discountRule) {
              this.$message.warning('折扣不能为空！')
              return false
            }
            // if (!couponRule) {
            //   this.$message({
            //     message: '请选择优惠券！',
            //     type: 'warning'
            //   })
            //   return false
            // }
          }
          if (this.sceneId) {
            sceneUpate(this.addForm).then(res => {
              if (res.code === '') {
                this.$message.success('修改成功')
                this.$emit('reset')
              } else {
                this.$message.error(res.message)
              }
            })
          } else {
            sceneAdd(this.addForm).then(res => {
              if (res.code === '') {
                this.$message.success('提交成功')
                this.$emit('reset')
              } else {
                this.$message.error(res.message)
              }
            })
          }
        } else {
          console.log('error submit!!')
          return false
        }
      })
    },
    handleSizeChange(val) {
      this.proOption.pageSize = val
      this.getCouponList()
    },
    handleCurrentChange(val) {
      this.proOption.page = val
      this.getCouponList()
    },
    getCouponList() {
      getCoupon(this.proOption).then(res => {
        if (res.code === '') {
          this.total = res.data.total
          this.tableData = res.data.list
          this.$refs.multipleTable.clearSelection()
          for (let i = 0; i < this.Row.ids.length; i++) {
            this.tableData.forEach(item => {
              if (item.shopCouponId === this.Row.ids[i]) {
                this.$refs.multipleTable.toggleRowSelection(item, true)
              }
            })
          }
        }
      })
    },
    // 选中商品
    handleSelectionChange(val) {
      this.multipleSelection = val
    },
    // 保存选择商品ID
    saveIdList() {
      const idList = []
      this.multipleSelection.forEach(i => {
        idList.push(i.shopCouponId)
      })
      var curIndex = 0
      var curItem = ''
      this.vipList2.forEach((item, index) => {
        console.log(item.memberLevelId, this.curVipId)
        if (item.memberLevelId === this.curVipId) {
          curIndex = index
          curItem = item
        }
      })
      if (curItem) {
        curItem.ids = idList
        this.$set(this.vipList2, curIndex, curItem)
      } else {
        this.vipList[0].ids = idList
      }
      this.isVisible = false
      // this.$forceUpdate()
    },
    // 取消选择
    closeSelect() {
      this.isVisible = false
    },
    // 跳转列表
    goToScene() {
      this.$emit('reset')
    },
    async getCouponInfo() {
      const res = await getSceneDetail({ sceneId: this.sceneId, shopId: this.addForm.shopId })
      this.addForm = res.data
      this.dateInfo = [this.addForm.startTime, this.addForm.endTime]
      switch (this.addForm.sceneTimeType) {
        case 1:
          const monthArr = this.addForm.sceneTime.split('-')
          this.monthStart = monthArr[0]
          this.monthEnd = monthArr[1]
          break
        case 2:
          this.weekList = this.addForm.sceneTime.split('-').filter((item) => {
            return item !== 0
          })
          break
        default:
          break;
      }
      if (this.addForm.sceneRule === 1) {
        this.vipList = this.addForm.members.splice(0, 1)
        getMemberLevels().then(res => {
          console.log(res)
          if (res.code === '') {
            this.vipList2 = res.data
          }
        })
      } else {
        this.vipList2 = this.addForm.members
      }
    },
    changeThreshold(val) { // 输入框值改变
      if (val) {
        this.addForm.threshold = 0
      }
    },
    // 查询会员等级数据
    getMemberLevels() {
      getMemberLevels().then(res => {
        if (res.code === '') {
          this.vipList2 = res.data
        }
      })
    }
  }
}
</script>
<style lang='scss' scoped>
//@import url(); 引入公共css类
@import url("../../../styles/elDialog.scss");
.addCoupon {
  background: #FFFFFF;
  .dialog-footer {
    display: flex;
    justify-content: space-around;
  }
  .formBox {
    margin-top: 20px;
    .el-input{
      width: 240px;
    }
    .item-rule{
      .el-input-number{
        width: 150px;
      }
      dl{
        dd{
          margin-left: 0;
          .el-input{
            width: 100px;
          }
        }
      }
    }
  }
  .selectBtn {
    width: 100px;
    height: 30px;
    line-height: 30px;
    background: #66b1ff;
    color: #FFFFFF;
    text-align: center;
    display: inline-block;
    font-size: 14px;
    margin: 10px auto;
    border-radius: 4px;
    cursor: pointer;
    position: relative;
    i {
      position: absolute;
      right: -10px;
      top: -10px;
      width: 25px;
      height: 25px;
      line-height: 25px;
      background: #FFFFFF;
      border-radius: 50%;
      border: 1px solid #66b1ff;
      text-align: center;
      color: #409EFF;
      font-style: normal;
      font-size: 12px;
    }
  }
  .footBtnBox {
    width: 100%;
    display: flex;
    justify-content: center;
    margin-top: 50px;
  }
}
</style>
