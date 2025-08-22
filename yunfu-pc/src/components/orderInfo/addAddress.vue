<template>
    <div class="editAddressBox">
      <div class="editArea itemStyle">
        <span><i>*</i>所在地区：</span>
        <div class="rightForm">
          <el-cascader
            size="large"
            :options="options"
            v-model="$store.state.areaCode"
            @change="addressChange">
          </el-cascader>
        </div>
      </div>
      <div class="itemStyle">
        <span><i>*</i>详细地址：</span>
        <div class="rightForm">
          <el-input
            type="textarea"
            :rows="2"
            placeholder="请输入地址"
            resize="none"
            v-model="newAddress.address">
          </el-input>
        </div>
      </div>
      <div class="itemStyle">
        <span><i>*</i>收货人姓名：</span>
        <div class="rightForm">
          <el-input v-model="newAddress.receiveName" placeholder="请输入内容"></el-input>
        </div>
      </div>
      <div class="itemStyle">
        <span><i>*</i>手机号码：</span>
        <div class="rightForm">
          <el-input v-model="newAddress.receivePhone" placeholder="请输入内容"></el-input>
        </div>
      </div>
      <div class="itemStyle">
        <span></span>
        <div class="rightForm">
          <el-checkbox :false-label="0" :true-label="1" v-model="newAddress.ifDefault">设置为默认收货地址</el-checkbox>
        </div>
      </div>
      <div class="dialogFooter">
        <el-button @click="cancelAdd">取 消</el-button>
        <el-button class="saveBtn" @click="newAddressData">确 定</el-button>
      </div>
    </div>
</template>

<script>
import { regionData, CodeToText } from 'element-china-area-data'
import { mapGetters, mapMutations } from 'vuex'

// import selectData from '@/assets/data.js'
export default {
  name: 'addAddress',
  data () {
    return {
      options: regionData,
      areaData: ''
    }
  },
  computed: {
    ...mapGetters([
      'newAddress' // 新增修改收货地址
    ])
  },
  methods: {
    ...mapMutations({
      seNewAddress: 'SET_NEWADDRESS', // 新增修改收货地址
      setAreacode: 'SET_AREACODE' // 新增地区编码
    }),
    addressChange (arr) {
      this.areaData = `${CodeToText[arr[0]]}-${CodeToText[arr[1]]}-${CodeToText[arr[2]]}`
    },
    newAddressData () {
      if (this.newAddress.receiveAdress !== '') {
        if (this.newAddress.address === '') {
          this.$message.error('请填写详细地址!')
        } else if (this.newAddress.receiveName === '') {
          this.$message.error('请填写收件人姓名!')
        } else if (this.newAddress.receivePhone === '') {
          this.$message.error('请填写手机号码!')
        } else {
          let reg = /^1[13456789]\d{9}$/
          if (!reg.test(this.newAddress.receivePhone)) {
            this.$message.error('手机号格式错误')
            return
          }
          this.newAddress.receiveAdress = this.areaData
          this.$emit('hideAddDialog')
        }
      } else {
        if (this.areaData === '') {
          this.$message.error('请选择地区!')
        } else if (this.newAddress.address === '') {
          this.$message.error('请填写详细地址!')
        } else if (this.newAddress.receiveName === '') {
          this.$message.error('请填写收件人姓名!')
        } else if (this.newAddress.receivePhone === '') {
          this.$message.error('请填写手机号码!')
        } else {
          let reg = /^1[13456789]\d{9}$/
          if (!reg.test(this.newAddress.receivePhone)) {
            this.$message.error('手机号格式错误')
            return
          }
          this.newAddress.receiveAdress = this.areaData
          this.$emit('hideAddDialog')
        }
      }
    },
    cancelAdd () {
      this.$emit('cancelAdd')
    }
  }
}
</script>

<style lang="scss" scoped>
.editAddressBox {
  padding: 0 100px;
  .itemStyle {
    display: flex;
    margin-bottom: 20px;
    span {
      width: 100px;
      margin-right: 20px;
      text-align: right;
      padding-top: 5px;
    }
    i {
      color: red;
      margin-right: 3px;
    }
    .rightForm {
      flex: 1;
      >>> .el-cascader {
        width: 100%;
      }
      >>> .el-checkbox__label {
        font-size: 12px;
        font-family: Microsoft YaHei;
        color: #C5AA7B;
      }
    }
  }
    .dialogFooter {
      display: flex;
      justify-content: center;
      width: 100%;
      .el-button{
        width: 200px;
        height: 50px;
        background: #F3F4F5;
        border-radius: 0px;
        padding: 0;
      }
      .saveBtn{
        color: $mainGlod;
        background-color: #333333;
        border: 1px solid transparent;
      }
    }
}
</style>
