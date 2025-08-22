<template>
  <div class="mUinitBusiness">
    <div class="topTitle">
      <h3>个体商户入驻</h3>
      <p>请认真填写申请信息，以便我们为您提供更好的服务！</p>
    </div>
    <div class="centBox">
      <el-steps :active="active" align-center>
        <el-step @click.native="changeActive(index = 1)" title="店铺信息"></el-step>
        <el-step @click.native="changeActive(index = 2)" title="经营者信息"></el-step>
      </el-steps>
      <div class="mFormBox">
        <div class="shopInfo" v-show="active === 1">
          <div class="form">
            <div class="inputItem">
              <div class="labelTit"><label><i>*</i>店铺名称：</label></div>
              <input type="text" v-model="personalForm.shopName" placeholder="请输入店铺名称">
            </div>
            <div class="inputItem">
              <div class="labelTit"><label><i>*</i>客服电话：</label></div>
              <input type="text" v-model="personalForm.servicePhone" placeholder="请输入客服电话">
            </div>
            <div class="inputItem">
              <div class="labelTit"><label><i>*</i>店铺负责人：</label></div>
              <input type="text" v-model="personalForm.chargePersonName" placeholder="请输入店铺负责人">
            </div>
            <div class="inputItem">
              <div class="labelTit"><label><i>*</i>负责人电话：</label></div>
              <input type="text" v-model="personalForm.chargePersonPhone" placeholder="请输入负责人电话">
            </div>
            <div class="inputItem arrow">
              <div class="labelTit"><label><i>*</i>店铺地址：</label></div>
              <input @click="showPopup" @focus="noBomBox" v-model="shopAdress" type="text" placeholder="请选择所在地区">
              <span class="iconfont">&#xe6ab;</span>
              <input type="text" v-model="personalForm.storeAddressDetail" placeholder="请输入详细地址">
            </div>
          </div>
        </div>
        <div class="subjectInfo" v-show="active === 2">
          <div class="form">
            <div class="inputItem">
              <div class="labelTit"><label><i>*</i>经营者姓名：</label></div>
              <input v-model="personalForm.personalName" type="text" placeholder="请输入经营者姓名">
            </div>
            <div class="inputItem arrow">
              <div class="labelTit"><label><i>*</i>证件类型：</label></div>
              <input @focus="noBomBox" v-model="idType" type="text" placeholder="请选择证件类型" @click="idTypeShowFn">
              <span class="iconfont">&#xe6ab;</span>
            </div>
            <div class="inputItem">
              <div class="labelTit"><label><i>*</i>身份证号码：</label></div>
              <input v-model="personalForm.personalIdCard" type="text" placeholder="请输入居民身份证号">
            </div>
            <div class="inputItem arrow">
              <div class="labelTit"><label><i>*</i>身份证有效期：</label></div>
              <input @focus="noBomBox" v-model="personalForm.personalCardStartTime" type="text" placeholder="请选择身份证开始时间" @click="selectIdStartDateBtn">
              <span class="iconfont">&#xe6ab;</span>
            </div>
            <div class="inputItem arrowTime">
              <input @focus="noBomBox" v-model="personalForm.personalCardEndTime" type="text" placeholder="请选择身份证有效期结束时间" @click="selectIdEndDateBtn">
              <span class="iconfont">&#xe6ab;</span>
            </div>
            <div class="inputItem">
              <div class="labelTit"><label><i>*</i>证件照片：</label></div>
              <div class="businessLicense">
                <van-uploader v-model="positive" :max-count="1" :after-read="(file)=>{return afterRead(file, type = 'positive')}" @oversize="onOversize">
                  <div icon="plus" type="primary">
                    <div class="updateLicense">
                      <div class="updateTop">
                        <img src="../../assets/images/shenfenz@2x.png" alt="">
                      </div>
                      <div class="updateBottom">身份证人像面</div>
                    </div>
                  </div>
                  <template #preview-cover="{ file }">
                    <div class="preview-cover van-ellipsis">身份证人像面</div>
                  </template>
                </van-uploader>
              </div>
              <div class="businessLicense">
                <van-uploader v-model="backIdImg" :max-count="1" :after-read="(file)=>{return afterRead(file, type = 'back')}" @oversize="onOversize">
                  <div icon="plus" type="primary">
                    <div class="updateLicense">
                      <div class="updateTop">
                        <img src="../../assets/images/shenfenzb@2x.png" alt="">
                      </div>
                      <div class="updateBottom">身份证国徽面</div>
                    </div>
                  </div>
                  <template #preview-cover="{ file }">
                    <div class="preview-cover van-ellipsis">身份证国徽面</div>
                  </template>
                </van-uploader>
              </div>
              <div class="businessLicense">
                <van-uploader v-model="handHeld" :max-count="1" :after-read="(file)=>{return afterRead(file, type = 'handHeld')}" @oversize="onOversize">
                  <div icon="plus" type="primary">
                    <div class="updateLicense">
                      <div class="updateTop">
                        <img src="../../assets/images/shouchishenfenz@2x.png" alt="">
                      </div>
                      <div class="updateBottom">手持证件照</div>
                    </div>
                  </div>
                  <template #preview-cover="{ file }">
                    <div class="preview-cover van-ellipsis">手持证件照</div>
                  </template>
                </van-uploader>
              </div>
            </div>
          </div>
        </div>
      </div>
      <button class="nextBtn" @click="next" v-show="active < 2">下一步</button>
      <button class="nextBtn" @click="submitForm" v-show="active > 1">提交</button>
    </div>
    <van-popup v-model="show" round position="bottom" :style="{ height: '40%' }">
      <van-area title="请选择地区" :area-list="areaList" @confirm="selectArea" @cancel="closeSelect"/>
    </van-popup>
    <van-popup v-model="idCardStartShow" round position="bottom" :style="{ height: '40%' }">
      <van-datetime-picker
        v-model="idCardStartDate"
        type="date"
        title="请选择身份证开始时间"
        :min-date="minDate"
        :max-date="maxDate"
        :formatter="formatter"
        @confirm="selectIdCardStartTime"
        @cancel="closeIdCardStartTime"
      />
    </van-popup>
    <van-popup v-model="idCardEndShow" round position="bottom" :style="{ height: '40%' }">
      <van-datetime-picker
        v-model="idCardEndDate"
        type="date"
        title="请选择身份证到期时间"
        :min-date="minDate"
        :max-date="maxDate"
        :formatter="formatter"
        @confirm="selectIdCardEndTime"
        @cancel="closeIdCardEndTime"
      />
    </van-popup>
    <van-popup v-model="idTypeShow" round position="bottom" :style="{ height: '40%' }">
      <van-picker
        title="请选择证件类型"
        show-toolbar
        :columns="columns"
        @confirm="onConfirm"
        @cancel="onCancel"
      />
    </van-popup>
  </div>
</template>
<script>
import { Area, Popup, DatetimePicker, Uploader, Toast, Picker } from 'vant'
import api from '@/api'
import { listSearchMixin } from '@/config/mixin'
import AreaList from '../../util/area'
export default {
  mixins: [listSearchMixin],
  name: 'mPersonalBusiness',
  components: {
    [Area.name]: Area,
    [Popup.name]: Popup,
    [DatetimePicker.name]: DatetimePicker,
    [Uploader.name]: Uploader,
    [Toast.name]: Toast,
    [Picker.name]: Picker
  },
  data () {
    return {
      active: 1,
      areaList: AreaList,
      show: false,
      minDate: new Date(1960, 1, 1),
      maxDate: new Date(2077, 12, 31),
      idCardStartDate: '',
      idCardEndDate: '',
      startDateShow: false,
      endDateShow: false,
      idCardStartShow: false,
      idCardEndShow: false,
      idTypeShow: false,
      idType: '',
      backIdImg: [],
      positive: [],
      handHeld: [],
      shopAdress: '', // 店铺地区
      subjectRegion: '', // 注册地址地区
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
      columns: []
    }
  },
  mounted () {
    this.getDictList()
    this.idCardStartDate = new Date()
    this.idCardEndDate = new Date()
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
          self.idCardList.forEach((item) => {
            var dictData = {}
            dictData['text'] = item.dictName
            dictData['value'] = item.dictId
            self.columns.push(dictData)
            console.log(self.columns, 'idList')
          })
        }
      })
    },
    showPopup () {
      this.show = true
    },
    next () {
      this.active++
      // if (this.active === 4) {
      // }
    },
    selectArea (address) {
      this.shopAdress = `${address[0].name}-${address[1].name}-${address[2].name}`
      this.personalForm.shopAdressProvince = address[0].name
      this.personalForm.shopAdressCity = address[1].name
      console.log(address)
      this.show = false
    },
    closeSelect () {
      this.show = false
    },
    selectIdStartDateBtn () {
      this.idCardStartShow = true
    },
    selectIdEndDateBtn () {
      this.idCardEndShow = true
    },
    dateTime (value) {
      let date = value
      let m = date.getMonth() + 1
      let d = date.getDate()
      if (m >= 1 && m <= 9) {
        m = '0' + m
      }
      if (d >= 0 && d <= 9) {
        d = '0' + d
      }
      return date.getFullYear() + '年-' + m + '月-' + d + '日'
    },
    idTypeShowFn () {
      this.idTypeShow = true
    },
    // 选择证件类型
    onConfirm (type) {
      this.idType = type.text
      this.personalForm.personalCardType = type.value
      this.idTypeShow = false
    },
    onCancel () {
      this.personalForm.personalCardType = ''
      this.idTypeShow = false
    },
    // 选择证件日期开始时间
    selectIdCardStartTime (value) {
      this.personalForm.personalCardStartTime = this.dateTime(value)
      this.idCardStartShow = false
    },
    // 取消选择身份证开始时间
    closeIdCardStartTime () {
      this.idCardStartShow = false
    },
    // 证件到期时间
    selectIdCardEndTime (value) {
      this.personalForm.personalCardEndTime = this.dateTime(value)
      this.idCardEndShow = false
    },
    // 取消选择身份证到期时间
    closeIdCardEndTime () {
      this.idCardEndShow = false
    },
    changeActive (index) {
      this.active = index
    },
    formatter (type, val) {
      if (type === 'year') {
        return `${val}年`
      } else if (type === 'month') {
        return `${val}月`
      } else if (type === 'day') {
        return `${val}日`
      }
      return val
    },
    // 禁止弹出键盘
    noBomBox (Event) {
      document.activeElement.blur()
    },
    afterRead (file, type) {
      // console.log(file.content, file.file.name)
      // let fileData = this.dataURLtoFileFun(file.content, file.file.name)
      let formData = new FormData()
      formData.append('file', this.dataURLtoFileFun(file.content, file.file.name))
      // console.log(fileData, 'fileData')
      let self = this
      let params = {
        url: api.upload,
        method: 'POST',
        contentType: 'multipart/form-data',
        data: formData
      }
      self.sendReq(params, (res) => {
        if (res.code === '200') {
          console.log(res.code)
          if (type === 'positive') {
            self.personalForm.personalCardPositive = res.data.url
          } else if (type === 'back') {
            self.personalForm.personalCardSide = res.data.url
          } else if (type === 'handHeld') {
            self.personalForm.personalCardHand = res.data.url
          }
        } else {
          Toast.fail(res.message)
        }
      })
      // file.status = 'uploading'
      // file.message = '上传中...'
      // setTimeout(() => {
      //   file.status = 'failed'
      //   file.message = '上传失败'
      // }, 1000)
    },
    dataURLtoFileFun (dataurl, filename) {
      // 将base64转换为文件，dataurl为base64字符串，filename为文件名（必须带后缀名，如.jpg,.png）
      let arr = dataurl.split(',')
      let mime = arr[0].match(/:(.*?);/)[1]
      let bstr = atob(arr[1])
      let n = bstr.length
      let u8arr = new Uint8Array(n)
      while (n--) {
        u8arr[n] = bstr.charCodeAt(n)
      }
      return new File([u8arr], filename, { type: mime })
    },
    onOversize (file) {
      console.log(file)
      Toast.fail('文件大小不能超过 500kb')
    },
    // 提交申请
    submitForm () {
      let self = this
      self.personalForm.shopAdress = ''
      let reg = /^1[13456789]\d{9}$/
      var idReg = /(^\d{15}$)|(^\d{18}$)|(^\d{17}(\d|X|x)$)/
      self.personalForm.shopPhone = self.personalForm.servicePhone
      self.personalForm.shopAdress = `${self.shopAdress}，${self.personalForm.storeAddressDetail}`
      // alert('submit!')
      if (self.personalForm.shopName === '') {
        Toast.fail('请输入店铺名称')
        return false
      }
      if (self.personalForm.servicePhone === '') {
        Toast.fail('请输入客服电话')
        return false
      } else if (!reg.test(self.personalForm.servicePhone)) {
        Toast.fail('客服电话号格式错误')
        return false
      }
      if (self.personalForm.chargePersonName === '') {
        Toast.fail('请输入店铺负责人')
        return false
      }
      if (self.personalForm.chargePersonPhone === '') {
        Toast.fail('请输入负责人电话')
        return false
      } else if (!reg.test(self.personalForm.chargePersonPhone)) {
        Toast.fail('负责人电话式错误')
        return false
      }
      if (self.personalForm.shopAdress === '') {
        Toast.fail('请选择所在地区')
        return false
      }
      if (self.personalForm.storeAddressDetail === '') {
        Toast.fail('请输入详细地址')
        return false
      }
      if (self.personalForm.personalName === '') {
        Toast.fail('请输入经营者姓名')
        return false
      }
      if (self.personalForm.personalCardType === '') {
        Toast.fail('请选择证件类型')
        return false
      }
      if (self.personalForm.personalIdCard === '') {
        Toast.fail('请输入居民身份证号')
        return false
      } else if (!idReg.test(self.personalForm.personalIdCard)) {
        Toast.fail('身份证号码格式错误')
        return false
      }
      if (self.personalForm.personalCardStartTime === '') {
        Toast.fail('请选择身份证开始时间')
        return false
      }
      if (self.personalForm.personalCardEndTime === '') {
        Toast.fail('请选择身份证有效期结束时间')
        return false
      }
      if (self.personalForm.personalCardPositive === '') {
        Toast.fail('请上传身份证正面照1')
        return false
      }
      if (self.personalForm.personalCardSide === '') {
        Toast.fail('请上传身份证背面照')
        return false
      }
      if (self.personalForm.personalCardHand === '') {
        Toast.fail('请上传手持身份证照片')
        return false
      }
      let params = {
        url: api.personalCheck,
        method: 'POST',
        data: self.personalForm
      }
      self.sendReq(params, (res) => {
        if (res.code === '200') {
          Toast.success('提交成功')
          self.$router.push({path: '/mStatus'})
        } else {
          Toast.fail(res.message)
        }
      })
    }
  }
}
</script>

<style lang="scss" scoped>
.mUinitBusiness {
  padding-bottom: 60px;
  .topTitle {
    padding: 0 5%;
    h3 {
      font-size: 21px;
      color: #333333;
      margin-bottom: 22px;
    }
    p {
      font-size: 12px;
      color: #676870;
    }
    margin:50px 0 28px 0;
  }
  >>> .el-step__head {
    color: #E9EAEB;
    .el-step__icon {
      background: #FFFFFF;
      width: 50px;
      height: 50px;
      border-radius: 0;
      border: 1px solid #F3F4F5;
    }
  }
  >>> .el-step__head.is-process {
    border-color: #CDCDCD
  }
  >>> .el-step__line {
    background-color: #F3F4F5;
    height: 1px !important;
    top: 50% !important;
    overflow: hidden;
  }
  >>> .is-finish {
    border-color: #C5AA7B;
    color: #FFFFFF;
    font-weight: 500 !important;
    .el-step__icon {
      background: #FFFFFF;
      height: 50px;
      width: 50px;
      color: #C5AA7B;
      border: 1px solid #C5AA7B;
      border-radius: 0;
    }
  }
  >>> .el-step__main {
    .is-finish {
      color: #333333;
    }
  }
  >>> .el-step__title.is-process {
    font-size: 14px;
    color: #999999;
    font-weight: 500;
  }
  >>> .el-step__title.is-wait {
    font-size: 14px;
    color: #676870;
    font-weight: 500;
  }
  >>> .el-step__main {
    .el-step__title {
      font-size: 14px;
    }
    .is-success {
      color: $mainColor;
    }
  }
  .mFormBox {
    padding: 0 5%;
    margin-top: 41px;
    .formTit {
      span {
        font-size: 17px;
        font-weight: bold;
        color: #444444;
        line-height: 18px;
        position: relative;
        i {
          background: linear-gradient(267deg, #FF8F25 0%, rgba(254, 179, 24, 0.48) 52%, rgba(255, 255, 255, 0) 100%);
          opacity: 0.7;
          display: block;
          height: 11px;
          width: 100%;
          bottom: -2px;
          position: absolute;
        }
      }
    }
    .form {
      margin-top: 25px;
      .inputItem {
        margin-top: 20px;
        .labelTit {
          display: flex;
          label {
            color: #333333;
            font-weight: 500;
            font-size: 14px;
            i {
              color: $mainColor;
              font-size: 15px;
              margin-right: 5px;
            }
          }
        }
        input {
          width: 100%;
          border-bottom: 1px solid #F6F4F7;
          height: 50px;
          line-height: 50px;
          font-size: 13px;
          color: #666666;
          padding-left: 10px;
        }
        input::placeholder {
          color: #999999;
        }
      }
      .arrow {
        position: relative;
        span {
          position: absolute;
          right: 5px;
          top: 30px;
          color: #999999;
        }
      }
      .arrowTime {
        position: relative;
        span {
          position: absolute;
          right: 5px;
          top: 20px;
          color: #999999;
        }
      }
      .describe {
        color: #BBBBBB;
        font-size: 12px;
        margin-top: 10px;
        line-height: 20px;
      }
    }
  }
  .nextBtn {
    display: block;
    margin: 50px auto 0 auto;
    width: 315px;
    height: 42px;
    background: #333333;
    color: $mainColor;
  }
  .businessLicense {
    width: 100%;
    background: #F3F4F5;
    margin-top: 10px;
    display: flex;
    .van-uploader {
      margin: 10px auto;
    }
    >>> .van-uploader__preview-image {
      width: 162px;
      height: 135px;
    }
    .updateLicense {
      width: 162px;
      height: 135px;
      .updateTop {
        display: flex;
        justify-content: center;
        height: 110px;
        align-items: center;
        img {
          width: 169px;
          height: 100px;
        }
      }
      .updateBottom {
        width: 162px;
        height: 25px;
        font-size: 13px;
        line-height: 25px;
        color: #999999;
        text-align: center;
      }
    }
  }
}
.preview-cover {
  position: absolute;
  bottom: 0;
  box-sizing: border-box;
  width: 100%;
  padding: 4px;
  color: #fff;
  font-size: 12px;
  text-align: center;
  background: rgba(0, 0, 0, 0.3);
}

.centBox {
  > > > .el-step {
    .el-step:nth-child(1) {
      .el-step__icon-inner {
      }
    }
  }
}
</style>
