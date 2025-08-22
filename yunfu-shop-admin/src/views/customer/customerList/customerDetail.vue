<template>
  <el-dialog :close-on-click-modal="false" title="客户详情" width="80%" :visible.sync="visible">
    <div class="customerDetail">
      <div class="detailBox">
        <div class="infoTit">基本信息 <i class="el-icon-edit" @click="changeInfo" /></div>
        <div class="itemBox">
          <div class="itemInfo"><label>客户手机号：</label>{{ customerInfo.phone }}</div>
          <div class="itemInfo"><label>客户昵称：</label>{{ customerInfo.name }}</div>
          <div class="itemInfo"><label>成为客户时间：</label>{{ customerInfo.time }}</div>
        </div>
        <div class="itemBox">
          <div class="itemInfo"><label>来源方式：</label>{{ customerInfo.source }}</div>
          <div class="itemInfo"><label>性别：</label>{{ customerInfo.sex }}</div>
          <div class="itemInfo"><label>生日：</label>{{ customerInfo.birthday ? customerInfo.birthday : '—' }}</div>
        </div>
        <div class="itemBox">
          <div class="itemInfo"><label>客户标签：</label>{{ customerInfo.labelName ? customerInfo.labelName : '—' }}</div>
          <div class="itemInfo"><label>备注：</label>{{ customerInfo.remark ? customerInfo.remark : '无' }}</div>
        </div>
        <div class="tradeInfoTit">交易信息</div>
        <div class="tradeInfo">
          <div class="tradeItem">
            <div class="tradeTit">累积消费金额（元）</div>
            <div class="tradeValue">{{ customerInfo.total ? customerInfo.total : '0' }}</div>
          </div>
          <div class="tradeItem">
            <div class="tradeTit">累计消费订单数</div>
            <div class="tradeValue">{{ customerInfo.frequency ? customerInfo.frequency : '0' }}</div>
          </div>
          <div class="tradeItem">
            <div class="tradeTit">最近下单时间</div>
            <div class="tradeValue">{{ customerInfo.lastTime ? customerInfo.lastTime : '—' }}</div>
          </div>
          <div class="tradeItem">
            <div class="tradeTit">累计退款金额</div>
            <div class="tradeValue">{{ customerInfo.refundMoney ? customerInfo.refundMoney : '0' }}</div>
          </div>
          <div class="tradeItem">
            <div class="tradeTit">累计退款订单数</div>
            <div class="tradeValue">{{ customerInfo.refunds ? customerInfo.refunds : '0' }}</div>
          </div>
        </div>
      </div>
      <!-- 详情弹窗 -->
      <el-dialog
        title="修改客户基本信息"
        :visible.sync="isDataVisible"
        width="30%"
        top="50px"
        class="group-dialog"
        :close-on-click-modal="false"
        :modal-append-to-body="false"
        :modal="false"
      >
        <div class="changeCustomer">
          <el-form ref="form" :model="basicInfo" label-width="100px">
            <el-form-item label="客户手机号">
              <span>{{ basicInfo.phone }}</span>
            </el-form-item>
            <el-form-item class="inputWide" label="客户昵称">
              <el-input v-model="basicInfo.name" placeholder="请输入内容" maxlength="10" onblur="value=value.replace(/(^\s*)|(\s*$)/g, '')" show-word-limit />
            </el-form-item>
            <el-form-item class="inputWide" label="性别">
              <el-radio v-model="basicInfo.sex" label="男">男</el-radio>
              <el-radio v-model="basicInfo.sex" label="女">女</el-radio>
            </el-form-item>
            <el-form-item class="inputWide" label="生日">
              <el-date-picker
                v-model="basicInfo.birthday"
                type="date"
                value-format="yyyy-MM-dd"
                placeholder="选择日期"
                style="width: 100%;"
              />
            </el-form-item>
            <el-form-item class="inputWide" label="标签">
              <el-select
                v-model="basicInfo.ids"
                multiple
                collapse-tags
                placeholder="请选择"
                style="width: 100%;"
              >
                <el-option
                  v-for="item in tagList"
                  :key="item.labelId"
                  :label="item.labelName"
                  :value="item.labelId"
                />
              </el-select>
            </el-form-item>
            <el-form-item class="inputWide" label="备注">
              <el-input
                v-model="basicInfo.remark"
                maxlength="200"
                type="textarea"
                :rows="4"
                placeholder="请输入内容"
              />
            </el-form-item>
          </el-form>
        </div>
        <span slot="footer" class="dialog-footer">
          <el-button type="primary" @click="saveChangeCustomer">保 存</el-button>
          <el-button @click="closeChange">取 消</el-button>
        </span>
      </el-dialog>
    </div>
  </el-dialog>
</template>

<script>
import { updateCustomer, getCustomerDetail, getLabelData } from '@/api/customer'
function InitUserInfo() {
  this.birthday = ''
  this.buyerUserId = ''
  this.ids = []
  this.name = ''
  this.phone = ''
  this.remark = ''
  this.sex = ''
}
export default {
  name: 'CustomerDetail',
  data() {
    return {
      visible: false,
      isDataVisible: false,
      userId: 0,
      customerInfo: {}, // 客户详情
      basicInfo: new InitUserInfo(),
      tagList: [] // 标签列表
    }
  },
  methods: {
    show(id) {
      this.visible = true
      if (id) {
        this.userId = id
        this.getCustomerInfo()
        this.getTagList()
      } else {
        this.customerInfo = {}
        this.basicInfo = new InitUserInfo()
      }
    },
    // 修改基本信息
    changeInfo() {
      this.isDataVisible = true
    },
    getCustomerInfo() {
      getCustomerDetail({ buyerUserId: this.userId }).then(res => {
        if (res.code === '') {
          this.customerInfo = res.data
          this.basicInfo.birthday = this.customerInfo.birthday
          this.basicInfo.buyerUserId = this.customerInfo.buyerUserId
          this.basicInfo.ids = this.customerInfo.ids
          this.basicInfo.name = this.customerInfo.name
          this.basicInfo.phone = this.customerInfo.phone
          this.basicInfo.remark = this.customerInfo.remark
          this.basicInfo.sex = this.customerInfo.sex
        } else {
          this.$message({
            message: res.message,
            type: 'error'
          })
        }
      })
    },
    async getTagList() {
      const res = await getLabelData()
      if (res.code === '') {
        this.tagList = res.data
        console.log(this.tagList, 'taglist')
      } else {
        this.$message({
          message: res.message,
          type: 'error'
        })
      }
    },
    saveChangeCustomer() {
      updateCustomer(this.basicInfo).then(res => {
        if (res.code === '') {
          this.$message({
            message: '修改成功',
            type: 'success'
          })
          this.getCustomerInfo()
          this.isDataVisible = false
        } else {
          this.$message({
            message: res.message,
            type: 'error'
          })
        }
      })
    },
    closeChange() {
      this.isDataVisible = false
    }
  }
}
</script>

<style lang='scss' scoped>
//@import url(); 引入公共css类
@import url("../../../styles/elDialog.scss");

.pending {
  margin: 20px;
}
.customerDetail {
  padding: 0px 0px 100px 0px;
  background: #FFFFFF;
  height: 100%;
  .title {
    font-size: 24px;
    font-weight: 500;
    color: #333333;
  }
  .detailBox {
    .infoTit {
      margin: 30px 0;
      font-size: 20px;
      color: #333333;
      height: 50px;
      line-height: 50px;
      i {
        cursor: pointer;
      }
    }
    .tradeInfoTit {
      margin: 50px 0 30px 0;
      font-size: 20px;
      color: #333333;
      height: 50px;
      line-height: 50px;
    }
    .itemBox {
      display: flex;
      margin-bottom: 30px;
      .itemInfo {
        width: 350px;
        display: flex;
        color: #666666;
        font-size: 16px;
        label {
          width: 120px;
          text-align: right;
          display: block;
          color: #333333;
        }
      }
    }
    .tradeInfo {
      display: flex;
      .tradeItem {
        width: 250px;
        text-align: center;
        .tradeTit {
          font-size: 16px;
          margin-bottom: 25px;
        }
        .tradeValue {
          font-size: 16px;
        }
      }
    }
  }
}
</style>
<style scoped>
/* .changeCustomer .inputWide /deep/ .el-form-item__content {
  width: 280px;
}
.changeCustomer .inputWide /deep/ .el-select {
  width: 280px;
} */
.customerDetail /deep/ .el-dialog__headerbtn .el-dialog__close {
  color: #FFFFFF;
}
/* .changeCustomer /deep/ .el-date-editor--date {
  width: 280px;
} */
</style>
