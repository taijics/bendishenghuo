<template>
  <div class="warp12">
    <div class="statusBox">
      <cent-logo></cent-logo>
      <div class="personal infoBox">
        <div class="title">企业商户</div>
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
                <span class="formName">主体信息</span>
              </div>
              <el-form-item label="企业名称" prop="enterpriseName">
                <el-input maxlength="100" placeholder="请输入企业名称" v-model="personalForm.enterpriseName"></el-input>
                <p>需与当地政府颁发的商业许可证书或企业注册证上的企业名称完全一致，信息审核审核成功后企业名称不可修改</p>
              </el-form-item>
              <el-form-item label="社会信用代码" prop="enterpriseCode">
                <el-input maxlength="100" placeholder="请输入社会信用代码" v-model="personalForm.enterpriseCode"></el-input>
              </el-form-item>
              <el-form-item label="注册地址" prop="enterpriseRegion">
                <el-cascader
                  size="large"
                  :options="options"
                  v-model="registeredAddress"
                  @change="registeredAddressChange">
                </el-cascader>
              </el-form-item>
              <el-form-item label="" prop="enterpriseAdress">
                <el-input maxlength="200" resize="none" placeholder="请输入详细地址" type="textarea" :rows="3" v-model="personalForm.enterpriseAdress"></el-input>
              </el-form-item>
              <div class="dateBox">
                <el-form-item label="营业期限" prop="enterpriseStartTime" class="businessDate">
                  <el-date-picker
                    v-model="personalForm.enterpriseStartTime"
                    type="date"
                    placeholder="选择日期"
                    format="yyyy 年 MM 月 dd 日"
                    value-format="yyyy-MM-dd">
                  </el-date-picker>
                  <span class="description">至</span>
                  <el-date-picker
                    v-model="personalForm.enterpriseEndTime"
                    type="date"
                    placeholder="选择日期"
                    format="yyyy 年 MM 月 dd 日"
                    value-format="yyyy-MM-dd">
                  </el-date-picker>
                </el-form-item>
              </div>
              <div class="describe"><p>请填写营业执照上的营业期限 注意参照示例中的格式 结束时间需大于开始时间 有效期必须大于60天</p></div>
              <el-form-item label="营业执照" prop="subjectLicense">
                <div class="idImgesBox">
                  <div class="idImgaeLeft">
                    <el-upload
                      list-type="picture-card"
                      :action="action"
                      :headers="myHeaders"
                      :show-file-list="false"
                      :on-success="handleHandHeld">
                      <img v-if="personalForm.enterpriseLicense" :src="personalForm.enterpriseLicense" class="avatar">
                      <div v-else class="noImg">
                        <div class="bgBox">
                          <img src="../../assets/images/yingyezhiz@2x.png" alt="">
                        </div>
                      </div>
                      <div class="changeImg">更换</div>
                      <div class="bgInfo">营业执照</div>
                    </el-upload>
                    <p>仅支持在有效期内的中国大陆工商局或市场监督管理局颁发的工商营业执照。格式要求：原证照片、扫描件或者 复印件加盖企业公章后的扫描</p>
                  </div>
                </div>
              </el-form-item>
              <div class="formTit">
                <span class="serialNumber">03</span>
                <span class="formName">经营者信息</span>
              </div>
              <el-form-item label="经营者姓名" prop="enterpriseOperator">
                <el-input maxlength="100" placeholder="请输入经营者姓名" v-model="personalForm.enterpriseOperator"></el-input>
              </el-form-item>
              <el-form-item label="证件类型" prop="enterpriseCardType" class="idType">
                <el-select v-model="personalForm.enterpriseCardType" placeholder="请选择">
                  <el-option
                    v-for="item in idCardList"
                    :key="item.dictId"
                    :label="item.dictName"
                    :value="item.dictId">
                  </el-option>
                </el-select>
              </el-form-item>
              <el-form-item label="身份证号码" prop="enterpriseIdCard">
                <el-input maxlength="100" placeholder="请输入身份证号码" v-model="personalForm.enterpriseIdCard"></el-input>
              </el-form-item>
              <div class="dateBox idDateBox">
                <el-form-item label="身份证有效期" prop="enterpriseCardStartTime" class="businessDate">
                  <el-date-picker
                    v-model="personalForm.enterpriseCardStartTime"
                    type="date"
                    placeholder="选择日期"
                    format="yyyy 年 MM 月 dd 日"
                    value-format="yyyy-MM-dd">
                  </el-date-picker>
                  <span class="description">至</span>
                  <el-date-picker
                    v-model="personalForm.enterpriseCardEndTime"
                    type="date"
                    placeholder="选择日期"
                    format="yyyy 年 MM 月 dd 日"
                    value-format="yyyy-MM-dd">
                  </el-date-picker>
                </el-form-item>
              </div>
              <el-form-item label="证件照片" prop="enterpriseCardPositive">
                <div class="idImgesBox">
                  <div class="idImgaeLeft">
                    <el-upload
                      list-type="picture-card"
                      :action="action"
                      :headers="myHeaders"
                      :show-file-list="false"
                      :on-success="handleIdPositive">
                      <img v-if="personalForm.enterpriseCardPositive" :src="personalForm.enterpriseCardPositive" class="avatar">
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
                      <img v-if="personalForm.enterpriseCardSide" :src="personalForm.enterpriseCardSide" class="avatar">
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
            </el-form>
          </div>
          <el-button @click="submitForm('ruleForm')" class="submitBtn" type="primary">提交</el-button>
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
        enterpriseName: '', // 企业名称
        enterpriseCode: '', // 统一社会信用代码
        enterpriseRegion: '', // 注册地址 省-市-区
        enterpriseAdress: '', // 注册地址详细
        enterpriseStartTime: '', // 营业期限开始时间
        enterpriseEndTime: '', // 营业期限结束时间
        enterpriseLicense: '', // 营业执照图片地址
        enterpriseOperator: '', // 经营者姓名
        enterpriseCardType: '', // 身份证类型
        enterpriseIdCard: '', // 经营者身份证号码
        enterpriseCardStartTime: '', // 证件有效开始时间
        enterpriseCardEndTime: '', // 证件有效结束时间
        enterpriseCardPositive: '', // 身份证正面照
        enterpriseCardSide: '' // 身份证反面照
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
              if (!/^1[34578]\d{9}$/.test(value) && !/^(\d{3,4}-)?\d{7,8}$/.test(value)) {
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
              if (/^1[34578]\d{9}$/.test(value) === false) {
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
        enterpriseName: [
          { required: true, message: '请输入企业名称', trigger: 'blur' }
        ],
        enterpriseCode: [
          { required: true, message: '请输入社会信用代码', trigger: 'blur' }
        ],
        enterpriseRegion: [
          { required: true, message: '请输入注册地址', trigger: 'change' }
        ],
        enterpriseAdress: [
          { required: true, message: '请输入注册详细地址', trigger: 'blur' }
        ],
        enterpriseStartTime: [{required: true, message: '请选择营业执照起始日期'}],
        enterpriseEndTime: [{required: true, message: '请选择营业执照到期时间'}],
        enterpriseLicense: [
          { required: true, message: '请选择上传营业执照', trigger: 'blur' }
        ],
        enterpriseOperator: [
          { required: true, message: '请输入经营者姓名', trigger: 'blur' }
        ],
        enterpriseIdCard: [
          { required: true, message: '请输入身份证号码', trigger: 'blur' },
          { pattern: /(^\d{15}$)|(^\d{18}$)|(^\d{17}(\d|X|x)$)/, message: '你的身份证格式不正确' }
        ],
        enterpriseCardStartTime: [{required: true, message: '请选择身份证起始日期'}],
        enterpriseCardEndTime: [{required: true, message: '请选择身份证到期时间'}],
        enterpriseCardType: [
          { required: true, message: '请选择证件类型' }
        ],
        enterpriseCardPositive: [
          { required: true, message: '请选择上传身份证正面照', trigger: 'change' }
        ],
        enterpriseCardSide: [
          { required: true, message: '请选择上传身份证反面照', trigger: 'change' }
        ]
      },
      dialogImageUrl: '',
      dialogVisible: false,
      imageUrl: '',
      action: api.upload,
      idTypeList: [],
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
          console.log(self.idCardList, 'idList')
        }
      })
    },
    handleIdPositive (res, file) {
      this.personalForm.enterpriseCardPositive = res.data.url
    },
    handleIdBack (res, file) {
      this.personalForm.enterpriseCardSide = res.data.url
    },
    handleHandHeld (res, file) {
      this.personalForm.enterpriseLicense = res.data.url
    },
    addressChange (arr) {
      this.personalForm.shopAdress = `${CodeToText[arr[0]]}-${CodeToText[arr[1]]}-${CodeToText[arr[2]]}`
      this.personalForm.shopAdressProvince = CodeToText[arr[0]]
      this.personalForm.shopAdressCity = CodeToText[arr[1]]
    },
    registeredAddressChange (arr) {
      this.personalForm.enterpriseRegion = `${CodeToText[arr[0]]}-${CodeToText[arr[1]]}-${CodeToText[arr[2]]}`
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
            url: api.enterpriseCheck,
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
