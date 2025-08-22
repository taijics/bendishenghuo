<template>
  <div class="warp12">
    <div class="statusBox">
      <cent-logo></cent-logo>
      <div class="personal infoBox">
        <div class="title">个人商户</div>
        <div class="content">
          <div class="formBox">
            <el-form
            :model="personalForm"
            :rules="personalRules"
            :label-position="'top'"
            ref="ruleForm"
            label-width="150px"
            class="ruleForm">
              <div class="formTit">
                <span class="serialNumber">01</span>
                <span class="formName">店铺信息</span>
              </div>
              <el-form-item label="店铺名称" prop="shopName">
                <el-input maxlength="100" placeholder="请输入店铺名称" v-model="personalForm.shopName"></el-input>
              </el-form-item>
              <el-form-item label="客服电话" prop="servicePhone">
                <el-input maxlength="100" placeholder="请输入客服电话" @blur="changeShopPone" v-model="personalForm.servicePhone"></el-input>
              </el-form-item>
              <el-form-item label="店铺负责人" prop="chargePersonName">
                <el-input maxlength="100" placeholder="请输入店铺负责人" v-model="personalForm.chargePersonName"></el-input>
              </el-form-item>
              <el-form-item label="负责人电话" prop="chargePersonPhone">
                <el-input  maxlength="100" placeholder="请输入负责人电话" v-model="personalForm.chargePersonPhone"></el-input>
              </el-form-item>
              <el-form-item label="店铺地址" prop="shopAdressProvince">
                <el-cascader
                  size="large"
                  :options="options"
                  v-model="selectedOptions"
                  @change="addressChange">
                </el-cascader>
              </el-form-item>
              <el-form-item label="" prop="storeAddressDetail">
                <el-input maxlength="200" resize="none" placeholder="请输入详细地址" type="textarea" :rows="3" v-model="personalForm.storeAddressDetail"></el-input>
              </el-form-item>
              <div class="formTit">
                <span class="serialNumber">02</span>
                <span class="formName">经营者信息</span>
              </div>
              <el-form-item label="经营者姓名" prop="personalName">
                <el-input maxlength="100" placeholder="请输入经营者姓名" v-model="personalForm.personalName"></el-input>
              </el-form-item>
              <el-form-item label="证件类型" prop="personalCardType" class="idType">
                <el-select v-model="personalForm.personalCardType" placeholder="请选择">
                  <el-option
                    v-for="item in idCardList"
                    :key="item.dictId"
                    :label="item.dictName"
                    :value="item.dictId">
                  </el-option>
                </el-select>
              </el-form-item>
              <el-form-item label="身份证号码" prop="personalIdCard">
                <el-input maxlength="100" placeholder="请输入身份证号码" v-model="personalForm.personalIdCard"></el-input>
              </el-form-item>
              <div class="dateBox idDateBox">
                <el-form-item label="身份证有效期" prop="personalCardEndTime" class="businessDate">
                  <el-date-picker
                    v-model="personalForm.personalCardStartTime"
                    type="date"
                    placeholder="选择日期"
                    format="yyyy 年 MM 月 dd 日"
                    value-format="yyyy-MM-dd">
                  </el-date-picker>
                  <span class="description">至</span>
                  <el-date-picker
                    v-model="personalForm.personalCardEndTime"
                    type="date"
                    placeholder="选择日期"
                    format="yyyy 年 MM 月 dd 日"
                    value-format="yyyy-MM-dd">
                  </el-date-picker>
                </el-form-item>
              </div>
              <el-form-item label="证件照片" prop="personalCardPositive">
                <div class="idImgesBox">
                  <div class="idImgaeLeft">
                    <el-upload
                      list-type="picture-card"
                      :action="action"
                      :headers="myHeaders"
                      :show-file-list="false"
                      :on-success="handleIdPositive">
                      <img v-if="personalForm.personalCardPositive" :src="personalForm.personalCardPositive" class="avatar">
                      <div v-else class="noImg">
                        <div class="bgBox">
                          <img src="../../assets/images/shenfenz@2x.png" alt="">
                        </div>
                      </div>
                      <!--                      <div class="zoomImg" @click="handlePictureCardPreview()">放大</div>-->
                      <div class="changeImg">更换</div>
                      <div class="bgInfo">身份证人像面</div>
                    </el-upload>
                  </div>
                  <div class="idImgaeRight">
                    <el-upload
                      list-type="picture-card"
                      :action="action"
                      :headers="myHeaders"
                      :show-file-list="false"
                      :on-success="handleIdBack">
                      <img v-if="personalForm.personalCardSide" :src="personalForm.personalCardSide" class="avatar">
                      <div v-else class="noImg">
                        <div class="bgBox">
                          <img src="../../assets/images/shenfenzb@2x.png" alt="">
                        </div>
                      </div>
                      <div class="changeImg">更换</div>
                      <div class="bgInfo">身份证国徽面</div>
                    </el-upload>
                  </div>
                </div>
              </el-form-item>
              <el-form-item label="手持证件照" prop="personalCardHand">
                <div class="idImgesBox">
                  <div class="idImgaeLeft">
                    <el-upload
                      list-type="picture-card"
                      :action="action"
                      :headers="myHeaders"
                      :show-file-list="false"
                      :on-success="handleHandHeld">
                      <img v-if="personalForm.personalCardHand" :src="personalForm.personalCardHand" class="avatar">
                      <div v-else class="noImg">
                        <div class="bgBox">
                          <img src="../../assets/images/shouchishenfenz@2x.png" alt="">
                        </div>
                      </div>
                      <div class="changeImg">更换</div>
                      <div class="bgInfo">手持证件照</div>
                    </el-upload>
                  </div>
                </div>
              </el-form-item>
            </el-form>
          </div>
          <el-button
            class="submitBtn"
            @click="submitForm('ruleForm')"
          >提交</el-button>
        </div>
      </div>
    </div>
    <el-dialog :visible.sync="dialogVisible">
      <img width="100%" :src="dialogImageUrl" alt="">
    </el-dialog>
  </div>
</template>

<script>
import CentLogo from '@/components/centLogo'
import api from '@/api'
import { listSearchMixin } from '@/config/mixin'
import { regionData, CodeToText } from 'element-china-area-data'
import Cookie from 'js-cookie'
export default {
  name: 'individualBusiness',
  mixins: [listSearchMixin],
  components: {CentLogo},
  data () {
    return {
      options: regionData,
      selectedOptions: [],
      registeredAddress: [],
      personalForm: {
        shopName: '', // 店铺名称
        shopPhone: '', // 手机号
        servicePhone: '', // 客服电话
        chargePersonName: '', // 店铺负责人
        chargePersonPhone: '', // 负责人电话
        shopAdress: '', // 店铺地址
        shopAdressProvince: '', // 店铺地址省
        shopAdressCity: '', // 店铺地址市
        storeAddressDetail: '', // 店铺详细地址
        personalName: '', // 经营者姓名
        personalCardType: '', // 身份证类型
        personalIdCard: '', // 经营者身份证号码
        personalCardStartTime: '', // 证件有效开始时间
        personalCardEndTime: '', // 证件有效结束时间
        personalCardPositive: '', // 身份证正面照
        personalCardSide: '', // 身份证反面照
        personalCardHand: '' // 手持证件照
      },
      idCardList: [],
      dictName: '证件类型',
      isShowImg: true,
      personalRules: {
        shopName: [
          { required: true, message: '请输入店铺名称', trigger: 'blur' }
        ],
        servicePhone: [
          { required: true, message: '请输入客服电话', trigger: 'blur' },
          { validator: function (rule, value, callback) {
              if (!/^1[345789]\d{9}$/.test(value) && !/^(\d{3,4}-)?\d{7,8}$/.test(value)) {
                callback(new Error('请输入正确的客服电话'))
              } else {
                callback()
              }
            },
            trigger: 'blur' }
        ],
        chargePersonName: [
          { required: true, message: '请输入店铺负责人', trigger: 'blur' }
        ],
        chargePersonPhone: [
          { required: true, message: '请输入店铺负责人电话', trigger: 'blur' },
          { validator: function (rule, value, callback) {
              if (/^1[345789]\d{9}$/.test(value) === false) {
                callback(new Error('请输入正确的手机号'))
              } else {
                callback()
              }
            },
            trigger: 'blur' }
        ],
        shopAdressProvince: [
          { required: true, message: '请选择省份和城市', trigger: 'change' }
        ],
        storeAddressDetail: [
          { required: true, message: '请输入详细地址', trigger: 'blur' }
        ],
        personalName: [
          { required: true, message: '请输入经营者姓名', trigger: 'blur' }
        ],
        personalIdCard: [
          { required: true, message: '请输入身份证号码', trigger: 'blur' },
          { pattern: /(^\d{15}$)|(^\d{18}$)|(^\d{17}(\d|X|x)$)/, message: '你的身份证格式不正确' }
        ],
        personalCardStartTime: [{required: true, message: '请选择身份证起始日期'}],
        personalCardEndTime: [{required: true, message: '请选择身份证到期时间'}],
        personalCardType: [
          { required: true, message: '请选择证件类型' }
        ],
        personalCardPositive: [
          { required: true, message: '请选择上传身份证正反面照片', trigger: 'change' }
        ],
        personalCardSide: [
          { required: true, message: '请选择上传身份证正反面照片', trigger: 'change' }
        ],
        personalCardHand: [
          { required: true, message: '请选择上传手持证件照', trigger: 'blur' }
        ]
      },
      dialogImageUrl: '',
      dialogVisible: false,
      imageUrl: '',
      action: api.upload,
      myHeaders: {}
    }
  },
  mounted () {
    if (Cookie.get('token')) {
      this.myHeaders.Authorization = Cookie.get('token')
    }
    this.getDictList()
  },
  methods: {
    getDictList () {
      let self = this
          let params = {
            url: api.getByName + '?dictName=' + self.dictName,
            method: 'GET'
          }
          self.sendReq(params, (res) => {
            if (res.code === '') {
              self.idCardList = res.data
            }
          })
    },
    handleIdPositive (res, file) {
      this.personalForm.personalCardPositive = res.data.url
    },
    handleIdBack (res, file) {
      this.personalForm.personalCardSide = res.data.url
    },
    handleHandHeld (res, file) {
      this.personalForm.personalCardHand = res.data.url
    },
    addressChange (arr) {
      this.personalForm.shopAdress = `${CodeToText[arr[0]]}-${CodeToText[arr[1]]}-${CodeToText[arr[2]]}`
      this.personalForm.shopAdressProvince = CodeToText[arr[0]]
      this.personalForm.shopAdressCity = CodeToText[arr[1]]
    },
    handlePictureCardPreview () {
      this.dialogImageUrl = this.idPositive
      this.dialogVisible = true
    },
    changeShopPone () {
      this.personalForm.shopPhone = this.personalForm.servicePhone
    },
    // 提交入驻
    submitForm (formName) {
      this.$refs[formName].validate(valid => {
        if (valid) {
          this.personalForm.shopAdress = `${this.personalForm.shopAdress}，${this.personalForm.storeAddressDetail}`
          // alert('submit!')
          let params = {
            url: api.personalCheck,
            method: 'POST',
            data: this.personalForm
          }
          this.sendReq(params, (res) => {
            if (res.code === '200') {
              this.$message({
                message: '提交成功',
                type: 'success'
              })
              this.$router.push({path: '/status'})
            } else {
              this.$message({
                message: res.message,
                type: 'error'
              })
            }
          })
        } else {
          this.$message({
            message: '信息填写不完整！',
            type: 'warning'
          })
          return false
        }
      })
    },
    resetForm (formName) {
      this.$refs[formName].resetFields()
    }
  }
}
</script>

<style lang="less" scoped>
.statusBox {
  .infoBox {
    width: 100%;
    height: 700px;
    background: #ffffff;
    .title {
      background: #FAFAFA;
      width: 100%;
      height: 42px;
      line-height: 42px;
      text-align: center;
      border-bottom: 1px solid #E6E6E6;
    }
    .content {
      width: 100%;
      padding: 0 80px 50px 80px;
      height: 650px;
      overflow-y: auto;
      .formTit {
        height: 55px;
        display: flex;
        align-items: center;
        width: 100%;
        margin: 50px 0;
        border-bottom: 1px solid #E6E6E6;
        .serialNumber {
          width: 24px;
          height: 24px;
          color: #C5AA7B;
          border: 1px solid #C5AA7B;
          border-radius: 4px;
          margin-right: 10px;
          text-align: center;
          line-height: 24px;
          font-size: 12px;
        }
        .formName {
          font-size: 20px;
          font-weight: 400;
          color: #333333;
          width: 200px;
        }
      }
      .formBox {
        width: 100%;
        /deep/ .ruleForm {
          .el-form-item{
            padding: 0 170px;
          }
        }
        /deep/ .el-cascader {
          width: 100%;
        }
        .idDateBox {
          margin-bottom: 30px;
          /deep/.el-form-item__content{
            display: flex;
          }
        }
        .describe {
          margin: 15px 0 30px 0;
          p {
            // padding-left: 150px;
            font-size: 12px;
            color: #999999;
          }
        }
        .idImgesBox {
          display: flex;
          justify-content: space-between;
          .idImgaeLeft {
            width: 50%;
          }
          .idImgaeRight {
            width: 50%;
            text-align: right;
          }
          /deep/ .el-upload-list--picture-card {
            width: 284px;
            height: 180px;
          }
          /deep/ .el-upload--picture-card {
            width: 284px;
            height: 180px;
            position: relative;
            .avatar {
              width: 100%;
              max-height: 178px;
            }
            .noImg {
              position: absolute;
              left: 0;
              top: 0;
              bottom: 0;
              right: 0;
              background: #F7F7F7;
              .bgBox {
                height: 149px;
                align-items: center;
                display: flex;
                justify-content: center;
              }
            }
            .bgInfo {
              color: #FFFFFF;
              font-size: 14px;
              height: 39px;
              line-height: 39px;
              background: #A0C1FF;
              position: absolute;
              left: 0;
              bottom: 0;
              width: 100%;
            }
            .changeImg {
              display: none;
              position: absolute;
              top: 40px;
              left: 112px;
              width: 60px;
              height: 60px;
              line-height: 60px;
              background: #000000;
              opacity: 0.6;
              border-radius: 50%;
              color: #FFFFFF;
            }
            .zoomImg {
              position: absolute;
              top: 40px;
              left: 50px;
              width: 60px;
              height: 60px;
              line-height: 60px;
              background: #000000;
              opacity: 0.6;
              border-radius: 50%;
              color: #FFFFFF;
            }
            &:hover {
              .changeImg {
                display: block;
              }
            }
          }
          /deep/ .el-upload-list--picture-card .el-upload-list__item {
            width: 284px;
            height: 180px;
          }
        }
        .businessDate {
          span {
            display: inline-block;
            text-align: center;
            width: 50px;
            color: #666666;
          }
          .el-date-editor--date {
            width: 268px;
          }
        }
        .idType {
          /deep/ .el-select {
            width: 100%;
          }
        }
      }
      .submitBtn {
        display: block;
        width: 750px;
        height: 50px;
        margin: 40px auto 0 auto;
        color: #FFEBC4;
        background: #333333;
        box-shadow: 0px 20px 30px rgba(0, 0, 0, 0.2);
      }
    }
  }
  /deep/ .el-form-item__content {
    p {
      font-size: 12px;
      color: #999999;
      line-height: 20px;
      margin-top: 8px;
    }
    .el-input__inner,.el-textarea__inner{
      border-radius: 0;
      border: 1px solid transparent;
      color: #333;
      background: #F9F9F9;
      &:focus{
        border-color: #C5AA7B;
      }
    }
  }
}
.hide {
  /deep/ .el-upload--picture-card {
    display: none;
  }
}
.avatar-uploader {
  img {
    width: 100%;
  }
}

</style>
