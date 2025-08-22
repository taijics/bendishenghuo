<template>
  <div class="addGroupBuy">
    <!-- 新增用户 -->
    <div class="addGroupBuyBox">
      <el-form ref="ruleForm" class="formBox" :model="addForm" label-width="150px" :rules="seckillBuyRules" :disabled="visitDetail">
        <div class="flexBox">
          <el-form-item label="活动名称" prop="seckillName">
            <el-input v-model="addForm.seckillName" maxlength="15" placeholder="请输入活动名称" />
          </el-form-item>
        </div>
        <div class="flexBox">
          <el-form-item label="备注">
            <el-input v-model="addForm.remark" maxlength="200" placeholder="请输入备注" />
          </el-form-item>
        </div>
        <el-form-item class="timeDataBox" label="活动时间">
          <div class="dateBox">
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
        </el-form-item>
        <el-form-item class="boxWidth" label="商品限购" prop="proQuota">
          <el-radio v-model="addForm.ifLimit" label="1">不限购</el-radio>
          <el-radio v-model="addForm.ifLimit" label="2">限购</el-radio>
          <el-input v-model="addForm.limitNumber" maxlength="9" :disabled="addForm.ifLimit === '1'" oninput="value=value.replace(/[^\d]/g,'')" />件/人
        </el-form-item>
        <el-form-item class="boxWidth" label="活动商品限量" prop="proQuota">
          <el-radio v-model="addForm.ifNumber" label="0">不限量</el-radio>
          <el-radio v-model="addForm.ifNumber" label="1">限量</el-radio>
          <el-input v-model="addForm.number" maxlength="9" :disabled="addForm.ifNumber === '0'" oninput="value=value.replace(/[^\d]/g,'')" />件
        </el-form-item>
        <el-form-item class="boxWidth" label="活动预热" prop="preheat">
          <el-radio v-model="addForm.ifEnable" label="1">停用</el-radio>
          <el-radio v-model="addForm.ifEnable" label="2">启用</el-radio>
          <el-input v-model="addForm.enableTime" maxlength="9" :disabled="addForm.ifEnable === '1'" oninput="value=value.replace(/[^\d]/g,'')" />小时前
        </el-form-item>
        <el-form-item label="优惠券叠加" prop="overlying">
          <el-radio v-model="addForm.ifAdd" label="1">叠加</el-radio>
          <el-radio v-model="addForm.ifAdd" label="0">不叠加</el-radio>
        </el-form-item>
        <el-form-item class="applyType" label="活动商品" prop="commodity">
          <span class="selectBtn" @click="chooseProduct"><span v-if="!visitDetail">请选择</span><span v-else>查看商品</span><i v-if="addForm.details.length !== 0" class="selectNum">{{ addForm.details.length }}</i></span>
        </el-form-item>
      </el-form>
    </div>
    <span slot="footer" class="dialog-footer">
      <el-button v-show="!visitDetail" type="primary" @click="addSeckillFn('ruleForm')">保 存</el-button>
<!--      <el-button v-if="visitDetail" type="primary" @click="goToSpike">取 消</el-button>-->
      <el-button type="danger" @click="goToSpike">取 消</el-button>
    </span>
    <!-- 新建分组弹框 -->
    <el-dialog
      :title="visitDetail ? '查看商品' : '选择商品'"
      :visible.sync="isVisible"
      width="58%"
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
          :row-key="getRowKeys"
          max-height="600"
          @selection-change="handleSelectionChange"
        >
          <el-table-column
            v-if="!visitDetail"
            type="selection"
            :reserve-selection="true"
            width="55"
          />
          <el-table-column label="商品信息" width="150" align="center">
            <template slot-scope="scope">
              <img height="80" width="80" :src="scope.row.image " alt srcset>
            </template>
          </el-table-column>
          <el-table-column prop="productName" label="" />
          <el-table-column prop="originalPrice" label="原价（元）" width="120" />
          <el-table-column prop="value" label="规格" width="120" />
          <el-table-column label="直降（元）" width="153">
            <template scope="scope">
              <el-input-number v-model="scope.row.downPrice" :disabled="visitDetail" size="small" :controls="false" :max="scope.row.originalPrice-0.01" :min="0.01" :precision="2" @input.native="changeCode(scope.row)" @blur="blurInput(scope.row)" />
            </template>
          </el-table-column>
          <el-table-column label="秒杀价（元）" width="150">
            <template scope="scope">
              <span v-if="scope.row.downPrice">{{ (scope.row.originalPrice - scope.row.downPrice).toFixed(2) }}</span>
            </template>
          </el-table-column>
          <el-table-column prop="stockNumber" label="库存" width="120" show-overflow-tooltip />
          <!--          <el-table-column width="80" label="操作" show-overflow-tooltip>-->
          <!--            <template slot-scope="scope">-->
          <!--              <div class="btnList">-->
          <!--                <el-popconfirm title="确定删除此活动？" @onConfirm="deleteSeckillFn(scope.row)">-->
          <!--                  <el-button slot="reference" class="delCls" type="text">删除</el-button>-->
          <!--                </el-popconfirm>-->
          <!--              </div>-->
          <!--            </template>-->
          <!--          </el-table-column>-->
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
            <el-button v-if="!visitDetail" type="primary" @click="saveIdList">确 定</el-button>
            <el-button @click="closeSelect">取 消</el-button>
          </span>
        </div>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { addSeckill, getSpikeList, seckillUpdate, seckillDetail } from '@/api/marketing'

function InitSpikeForm() {
  this.details = [] // 商品明细数据
  this.enableTime = '' // 预热几小时前
  this.effectiveEnd = '' // 秒杀活动结束时间
  this.seckillName = '' // 秒杀活动名称
  this.ifAdd = '1' // 优惠券是否叠加 1-是 0-否
  this.ifEnable = '1' // 秒杀活动预热 1-停用 2-启用
  this.ifLimit = '1' // 商品限购 1-不限购 2-限购
  this.limitNumber = '' // 限购几件/人
  this.person = null // 成团人数
  this.remark = '' // 备注
  this.ifNumber = '0' // 是否限量
  this.number = null // 限制数量
  this.effectiveStart = '' // 活动开始时间
}
export default {
  name: 'AddGroupBuy',
  props: {
    spikeId: {
      type: Number,
      default: 0
    },
    visitDetail: {
      type: Boolean,
      default: false
    }
  },
  data() {
    return {
      // 新增
      getRowKeys(row) {
        return row.skuId
      },
      addForm: new InitSpikeForm(),
      dateInfo: [], // 时间选择数组
      proOption: {
        page: 1,
        pageSize: 10
      },
      details: [],
      total: 0,
      tableData: [],
      shopSeckillId: '', // 秒杀ID
      seckillBuyRules: {
        seckillName: [
          { required: true, message: '请输入活动名称', trigger: 'blur' }
        ]
      },
      multipleSelection: [],
      roleList: [],
      isVisible: false, // 选择商品弹窗
      inputSpikeTableData: [],
    }
  },
  watch: {
    spikeId: {
      handler(nVal, oVal) {
        this.shopSeckillId = nVal
        if (!nVal) {
          this.dateInfo = []
          this.inputSpikeTableData = []
          this.addForm = new InitSpikeForm()
        } else {
          this.getSeckillInfo()
        }
      }
    }
  },
  mounted() {
    this.getProList()
    this.shopSeckillId = this.spikeId
    if (this.shopSeckillId) {
      this.getSeckillInfo()
    }
  },
  methods: {
    // 重制表单数据
    resetData() {
      if (this.shopSeckillId === 0) {
        this.addForm = new InitSpikeForm()
        this.dateInfo = []
        this.inputSpikeTableData = []
      }
      if (this.$refs.multipleTable) {
        this.$refs.multipleTable.clearSelection()
      }
    },
    blurInput(data) {
      console.log(data, 'data')
      const index = this.inputSpikeTableData.findIndex(item => item.skuId === data.skuId)
      if (index === -1) {
        this.inputSpikeTableData.push(data)
      } else {
        this.inputSpikeTableData[index].downPrice = data.downPrice
      }
    },
    addSeckillFn(ruleForm) {
      this.$refs[ruleForm].validate(valid => {
        if (valid) {
          if (this.dateInfo.length === 0) {
            this.$message.warning('请选择用券时间开始和结束日期')
            return false
          }
          if (this.addForm.ifLimit === '2' && this.addForm.limitNumber === '' || this.addForm.limitNumber === '0') {
            this.$message.warning('请填写正确的活动限购数')
            return false
          }
          if (this.addForm.ifNumber === '2' && this.addForm.number === '' || this.addForm.number === '0') {
            this.$message.warning('请填写正确的活动限制数量')
            return false
          }
          if (this.addForm.ifEnable === '2' && this.addForm.enableTime === '' || this.addForm.enableTime === '0') {
            this.$message.warning('请填写正确的活动预热前时间')
            return false
          }
          this.addForm.effectiveStart = this.dateInfo[0]
          this.addForm.effectiveEnd = this.dateInfo[1]
          if (this.shopSeckillId) {
            seckillUpdate(this.addForm).then(res => {
              if (res.code === '') {
                this.$message.success('修改成功')
                this.addForm = new InitSpikeForm()
                this.dateInfo = []
                this.$emit('reset')
              } else {
                this.$message.error(res.message)
              }
            })
          } else {
            addSeckill(this.addForm).then(res => {
              if (res.code === '') {
                this.$message.success('提交成功')
                this.addForm = new InitSpikeForm()
                this.dateInfo = []
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
    changeCode(item) {
      this.$nextTick(() => {
        if (item.downPrice >= item.originalPrice) {
          item.downPrice = item.originalPrice - 0.01
        }
      })
    },
    handleSizeChange(val) {
      this.proOption.pageSize = val
      this.getProList()
    },
    handleCurrentChange(val) {
      this.proOption.page = val
      this.getProList()
    },
    // 选择商品
    chooseProduct(type) {
      this.isVisible = true
      if (this.visitDetail) {
        this.proOption.activityId = this.shopSeckillId
      } else {
        this.proOption.activityId = null
      }
      this.getProList()
    },
    getProList() {
      getSpikeList(this.proOption).then(res => {
        if (res.code === '') {
          const dataList = res.data.list
          if (this.inputSpikeTableData.length > 0) {
            dataList.forEach(item => {
              const index = this.inputSpikeTableData.findIndex(cItem => cItem.skuId === item.skuId)
              if (index !== -1) {
                item.downPrice = this.inputSpikeTableData[index].downPrice
              }
            })
          }
          this.tableData = dataList
          this.total = res.data.total
          // if (this.$refs.multipleTable) {
          //   for (let i = 0; i < this.tableData.length; i++) {
          //     for (let j = 0; j < this.addForm.details.length; j++) {
          //       if (this.tableData[i].productId === this.addForm.details[j].productId && this.tableData[i].skuId === this.addForm.details[j].skuId) {
          //         this.$refs.multipleTable.toggleRowSelection(this.tableData[i]);
          //       }
          //     }
          //   }
          // }
        }
      })
    },
    // 选中商品
    handleSelectionChange(val) {
      this.multipleSelection = val
    },
    // 保存选择商品ID
    saveIdList() {
      try {
        const idList = []
        this.multipleSelection.forEach(item => {
          if (!item.downPrice) {
            this.$message.warning('请输入价格')
            throw new Error()
          }
          idList.push({
            downPrice: item.downPrice,
            seckillPrice: item.originalPrice - item.downPrice,
            productId: item.productId,
            skuId: item.skuId
          })
        })
        this.addForm.details = idList
        this.isVisible = false
      } catch (e) {
        console.log(e)
      }
    },
    // 取消选择
    closeSelect() {
      this.isVisible = false
    },
    // 跳转秒杀列表
    goToSpike() {
      this.$emit('reset')
    },
    async getSeckillInfo() {
      const res = await seckillDetail({ shopSeckillId: this.shopSeckillId })
      this.addForm.ifEnable = res.data.ifEnable.toString()
      this.addForm.enableTime = res.data.enableTime
      this.addForm.effectiveTime = res.data.effectiveTime
      this.addForm.seckillName = res.data.seckillName
      this.addForm.effectiveStart = res.data.effectiveStart
      this.addForm.effectiveEnd = res.data.effectiveEnd
      this.addForm.person = res.data.person
      this.addForm.ifAdd = res.data.ifAdd.toString()
      this.addForm.ifNumber = res.data.ifNumber.toString()
      this.addForm.ifLimit = res.data.ifLimit.toString()
      this.addForm.number = res.data.number
      this.addForm.limitNumber = res.data.limitNumber
      this.addForm.remark = res.data.remark
      this.addForm.shopSeckillId = res.data.shopSeckillId
      const idList = res.data.products
      idList.forEach(i => {
        this.addForm.details.push({
          downPrice: i.downPrice,
          seckillPrice: i.originalPrice - i.downPrice,
          productId: i.productId,
          skuId: i.skuId
        })
      })
      this.dateInfo = [this.addForm.effectiveStart, this.addForm.effectiveEnd]
    },
    // 删除
    deleteSeckillFn() {
    }
  }
}
</script>
<style lang='scss' scoped>
//@import url(); 引入公共css类
@import url("../../../styles/elDialog.scss");
.addGroupBuy {
  margin-top: 20px;
  background: #FFFFFF;
  .dialog-footer {
    display: flex;
    justify-content: center;
    .el-button {
      margin: 0px 16px;
    }
  }
  .formBox {
    margin-top: 20px;
    .flexBox {
      display: flex;
    }
    .applyType {
      span {
        width: 100px;
        height: 30px;
        line-height: 30px;
        background: #66b1ff;
        color: #FFFFFF;
        text-align: center;
        display: inline-block;
        font-size: 14px;
        margin-right: 30px;
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
    }
  }
  .footBtnBox {
    width: 100%;
    display: flex;
    justify-content: center;
    margin-top: 50px;
  }
  .dateBox {
    display: flex;
    align-items: center;
    .description {
      width: 59px;
      text-align: center;
      display: block;
      font-size: 14px;
      color: #999999;
    }
  }
}
</style>
<style scoped>
.flexBox /deep/ .el-input {
  width: 500px;
}
.inputW /deep/ .el-input {
  width: 100px;
  margin: 0 8px 0 0;
}
.inputW /deep/ .el-input .el-input__inner {
  text-align: center;
}
.inputW /deep/ .el-form-item__error {
  padding-left: 0;
}
.inputW /deep/ .el-checkbox {
  margin-left: 20px;
}
.inputW /deep/ .el-radio {
  margin-left: 30px;
}
.boxWidth /deep/ .el-input {
  width: 100px;
  margin-right: 15px;
}
.boxWidth /deep/ .el-input .el-input__inner {
  text-align: center;
}
.addGroupBuy /deep/ .el-button--primary {
  background: #409EFF;
  border-color: #409EFF;
}
.addGroupBuy /deep/ .el-dialog__header {
  background-color: #409EFF;
}
.addGroupBuy /deep/ .el-dialog__headerbtn .el-dialog__close {
  color: #FFFFFF;
}
.addGroupBuy .timeDataBox /deep/ .el-form-item__content {
  display: flex;
  align-items: center;
}
.addGroupBuy .timeDataBox /deep/ .el-form-item__label {}
input::-webkit-outer-spin-button,
input::-webkit-inner-spin-button {
  -webkit-appearance: none;
}
input[type="number"]{
  -moz-appearance: textfield;
}
</style>
