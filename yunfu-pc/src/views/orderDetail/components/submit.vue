<template>
  <div class="submitAS">
    <div class="itemBox">
        <div class="title">售后方式：</div>
        <el-select
          v-model="mode"
          placeholder="请选择售后方式"
          style="width:500px;"
        >
            <el-option
            v-for="item in modes"
            :key="item.value"
            :label="item.label"
            :value="item.value">
            </el-option>
        </el-select>
    </div>
    <div class="itemBox">
        <div class="title">货物状态：</div>
        <el-select
          v-model="goodsState"
          placeholder="请选择货物状态"
          style="width:500px;"
        >
            <el-option
            v-for="item in goodsStatus"
            :key="item.value"
            :label="item.label"
            :value="item.value">
            </el-option>
        </el-select>
    </div>
    <div class="itemBox">
        <div class="title">售后理由：</div>
        <el-select
          v-model="reason"
          placeholder="请选择售后理由"
          style="width:500px;"
        >
            <el-option
            v-for="item in reasons"
            :key="item"
            :label="item"
            :value="item">
            </el-option>
        </el-select>
    </div>
    <div class="itemBox reason">
        <div class="title">原因描述：</div>
        <el-input
            type="textarea"
            :rows="6"
            placeholder="输入申请退货原因描述"
            v-model="textarea"
            style="width:500px;">
        </el-input>
    </div>
    <div class="upload">
        <div class="title">上传凭证：</div>
        <el-upload
            :action="action"
            list-type="picture-card"
            :limit="3"
            :on-success="handleSuccess"
            :on-remove="handleRemove">
            <i class="el-icon-camera"></i>
            <p>最多上传3张</p>
        </el-upload>
    </div>
    <div class="submit">
        <el-button plain @click="submit" v-throttle>提交申请</el-button>
    </div>
  </div>
</template>

<script>
import {
  upload
} from '@/api/upload.js'
import {
  submitAfter
} from '@/api/user/afterSale.js'
export default {
  data () {
    return {
      modes: [{
          value: 1,
          label: '仅退款'
      }, {
          value: 2,
          label: '退货退款'
      }],
      goodsStatus: [{
          value: 1,
          label: '已收到货'
      }, {
          value: 0,
          label: '未收到货'
      }],
      reasons: [],
      // 请求内容
      mode: '',
      goodsState: '',
      reason: '',
      textarea: '',
      action: upload,
      urls: [],
      productPrice: 0, // 退款金额
      skus: []
    }
  },
  methods: {
    // 申请售后
    async submit () {
      let errMsg = ''
      if (this.mode === '') {
        errMsg += ' 请选择售后方式 '
      }
      if (this.goodsState === '') {
        errMsg += ' 请选择货物状态 '
      }
      if (this.reason === '') {
        errMsg += ' 请选择售后理由 '
      }
      if (errMsg.length !== 0) {
        this.$message.warning(errMsg)
        return
      }
      for (var i in this.orderData.skus) {
          this.skus[i] = {
            number: this.orderData.skus[i].number,
            skuId: this.orderData.skus[i].skuId
          }
          this.productPrice += (this.orderData.skus[i].price * this.orderData.skus[i].number)
      }
      const response = await submitAfter({
        afterType: this.mode,
        explain: this.textarea,
        goodsState: this.goodsState,
        image: this.urls.join(','),
        // orderId: this.orderData.orderId,
        price: this.productPrice,
        returnReason: this.reason,
        skus: this.skus
      })
      const res = response.data
      if (res.code === '200') {
          this.$message.success('售后申请成功')
          setTimeout(() => {
              this.$router.push('/orderAfterSale')
          }, 1000)
      } else {
        this.$message.warning(res.message)
      }
    },
    handleSuccess (res) {
      this.urls.push(res.data.url)
    },
    handleRemove (file, fileList) {
      this.urls = []
      for (var i in fileList) {
        this.urls.push(fileList[i].response.data.url)
      }
    }
  }
}
</script>

<style lang="scss" scoped>
.submitAS{
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  position: relative;
  .itemBox{
    width: 580px;
    display: flex;
    margin: 10px;
    .title{
      min-width: 80px;
      line-height: 40px;
      text-align: right;
    }
    >>> .el-input__icon{
      color: $mainGlod;
    }
  }
  .reason{
    position: relative;
  }
  .upload{
    display: flex;
    position: absolute;
    right: 60px;
    bottom: 120px;
    .title{
      line-height: 40px;
    }
    >>> .el-upload--picture-card{
      height: 140px;
      background-color: #FFF;
      display: flex;
      flex-direction: column;
      justify-content: center;
      align-items: center;
      i{
        font-size: 32px;
      }
      p{
        margin: 10px 0;
        font-size: 12px;
        line-height: 0;
      }
      &:hover{
        i{
          color: $mainGlod;
        }
      }
  }
  }
  .submit{
    margin: 30px 0;
    .el-button{
      width: 200px;
      height: 50px;
      color: #FFF;
      background-color: #333333;
      border-radius: 0px;
    }
  }
  >>> .el-select-dropdown__item{
    &:hover{
      background: $mainGlod;
    }
  }
}
</style>
