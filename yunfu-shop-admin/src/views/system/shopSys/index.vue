<template>
  <div class="setting-shop-page">
    <el-form ref="ruleForm" :model="storeDetails" :rules="rules" label-width="100px">
      <div class="h5">
        <div class="title">店铺信息</div>
        <el-button
          v-if="!disabled1"
          type="text"
          @click="editDisabled1(0)"
        >取消</el-button>
        <el-button v-else type="text" @click="editDisabled1(1)">编辑</el-button>
        <el-button
          v-if="!disabled1"
          type="text"
          @click="updateStore('ruleForm')"
        >保存</el-button>
      </div>
      <div class="shop-details">
        <el-form-item label="店铺logo">
          <el-upload
            :class="[{ 'avatar-uploader': !storeDetails.shopLogo }]"
            :headers="headers"
            :data="dataObj"
            :action="action"
            :show-file-list="false"
            :on-success="handleAvatarSuccess"
            :disabled="disabled1"
          >
            <img
              v-if="storeDetails.shopLogo"
              :src="storeDetails.shopLogo"
              class="avatar"
              width="80"
              height="80"
            >
            <i v-else class="el-icon-plus avatar-uploader-icon" />
          </el-upload>
        </el-form-item>
        <el-form-item label="店铺名称">
          <el-input v-model="storeDetails.shopName" maxlength="20" :disabled="disabled1" />
        </el-form-item>
        <el-form-item label="发货地址">
          <el-input
            v-model="storeDetails.shopAdress"
            maxlength="60"
            :disabled="disabled1"
            :resize="`${disabled1 ? 'none' : ''}`"
            type="textarea"
          />
        </el-form-item>
        <el-form-item label="店铺简介">
          <el-input
            v-model="storeDetails.shopBrief"
            maxlength="50"
            :disabled="disabled1"
            :resize="`${disabled1 ? 'none' : ''}`"
            type="textarea"
          />
        </el-form-item>
        <el-form-item label="注册手机号" prop="shopPhone">
          <el-input
            v-if="shopPhoneShow"
            :value="hidden(storeDetails.shopPhone,3,4)"
            maxlength="11"
            :disabled="disabled1"
            @focus="focusShopPhoneInput"
          />
          <el-input
            v-else
            ref="userPhoneCls"
            v-model="storeDetails.shopPhone"
            maxlength="11"
            :disabled="disabled1"
          />
        </el-form-item>
      </div>
      <div class="h5">
        <div class="title">店铺认证</div>
      </div>
      <div class="shop-details" style="overflow: hidden; line-height: 40px">
        微信支付-商户认证
        <!-- <el-button type="primary" style="float:right" @click="approve">立即认证</el-button> -->
      </div>
      <div class="h5">
        <div class="title">退货地址</div>
      </div>
      <div class="shop-details">
        <el-form-item label="地址">
          <el-input
            v-model="storeDetails.shopReturn.returnAdress"
            maxlength="60"
            :disabled="disabled1"
          />
        </el-form-item>
        <el-form-item label="联系人">
          <el-input
            v-model="storeDetails.shopReturn.returnPerson"
            maxlength="20"
            :disabled="disabled1"
          />
        </el-form-item>
        <el-form-item label="联系电话">
          <el-input
            v-if="returnPhoneShow"
            :value="hidden(storeDetails.shopReturn.returnPhone,3,4)"
            maxlength="11"
            :disabled="disabled1"
            @focus="focusReturnPhoneInput"
          />
          <el-input
            v-else
            ref="returnPhoneCls"
            v-model="storeDetails.shopReturn.returnPhone"
            maxlength="11"
            :disabled="disabled1"
          />
        </el-form-item>
      </div>
    </el-form>
  </div>
</template>
<script>
import { shopSysGetById, shopSysUpdate } from '@/api/shopSys';
import { uploadUrl } from '@/utils/request';
import { getToken } from '@/utils/auth';
const PhoneRule = /^1(3\d|4[5-9]|5[0-35-9]|6[567]|7[0-8]|8\d|9[0-35-9])\d{8}$/
export default {
  data() {
    return {
      form: {
        name: '',
        region: '',
        date1: '',
        date2: '',
        delivery: false,
        type: [],
        resource: '',
        desc: '',
        logo: '',
      },
      headers: {
        'Authorization-business': getToken(),
      },
      shopPhone: '',
      userPhone: '',
      showUserPhone: false,
      action: uploadUrl,
      dataObj: {
        folderId: 1,
      },
      disabled1: true,
      storeDetails: {
        shopReturn: {},
      },
      privacyTime: 0,
      shopPhoneShow: true,
      returnPhoneShow: true,
      oldShopPhone: '',
      oldReturnPhone: '',
      rules: {
        shopPhone: [
          { required: true, message: '请输入注册手机号', trigger: 'blur' },
          {
            pattern: /^1[3456789]\d{9}$/,
            message: '目前只支持中国大陆的手机号码'
          }
        ],
        returnPhone: [
          { required: true, message: '请输入联系电话', trigger: 'blur' },
          {
            pattern: /^1[3456789]\d{9}$/,
            message: '目前只支持中国大陆的手机号码'
          }
        ],
      }
    };
  },
  created() {
    this.getStoreDetails();
    this.privacyTime = localStorage.getItem('privacyTime');
  },
  methods: {
    focusReturnPhoneInput() {
      // 处理后端没有返回shopReturn字段
      if (!this.storeDetails.shopReturn) {
        this.$set(this.storeDetails, 'shopReturn', {
          returnPhone: null
        })
      }
      this.oldReturnPhone = this.storeDetails.shopReturn.returnPhone
      this.returnPhoneShow = false
    },
    focusShopPhoneInput() {
      this.oldShopPhone = this.storeDetails.shopPhone
      this.shopPhoneShow = false
      this.storeDetails.shopPhone = ''
    },
    async getStoreDetails() {
      const res = await shopSysGetById({});
      if (res.code === '') {
        this.storeDetails = res.data;
      }
    },
    onSubmit() {
      console.log('submit!');
    },
    // 编辑取消
    editDisabled1(value) {
      this.disabled1 = !this.disabled1;
      this.showUserPhone = false;
      if (value === 0) {
        this.shopPhoneShow = true
        this.returnPhoneShow = true
        this.storeDetails.shopPhone = this.oldShopPhone ? this.oldShopPhone : this.storeDetails.shopPhone
        this.storeDetails.shopReturn.returnPhone = this.oldReturnPhone ? this.oldReturnPhone : this.storeDetails.shopReturn.returnPhone
      }
    },
    async updateStore(ruleForm) {
      this.$refs[ruleForm].validate(valid => {
        console.log(this.storeDetails, 'this.storeDetails999')
        if (!PhoneRule.test(this.storeDetails.shopReturn.returnPhone)) {
          return this.$message.warning('请输入正确联系电话');
        }
        if (valid) {
          shopSysUpdate(this.storeDetails).then(res => {
            if (res.code === '') {
              this.getStoreDetails()
              this.disabled1 = true;
              this.returnPhoneShow = true
              this.shopPhoneShow = true
              this.$message({
                message: '修改成功',
                type: 'success',
              });
            }
          })
        }
      })
    },
    handleAvatarSuccess(response) {
      const { url } = response.data;
      this.storeDetails.shopLogo = url;
    },
    approve() {
      this.$router.push({ path: '/setting/shop/wechat-approve' });
    },
    // 编辑号码
    inputShopPhone() {
      // this.showShopPhone = true;
      this.shopPhone = '';
      this.$nextTick(() => {
        this.$refs.phoneCls.focus();
      });
    },
    inputUserPhone() {
      this.showUserPhone = true;
      this.userPhone = '';
      this.$nextTick(() => {
        this.$refs.userPhoneCls.focus();
      });
    },
    // 中间部分
    hidden(str, frontLen, endLen) {
      if (!str) {
        return // 如果值为空，直接return
      }
      let endLenData = 0;
      if (str && str.length !== 2) {
        endLenData = endLen;
      }
      const len = str.length - frontLen - endLenData;
      let xing = '';
      for (let i = 0; i < len; i++) {
        xing += '*';
      }
      return (
        str.substring(0, frontLen) +
        xing +
        str.substring(str.length - endLenData)
      );
    },
  },
};
</script>
<style lang="scss" scoped>
@import url("../../../styles/elDialog.scss");
.setting-shop-page {
  margin-top: 20px;
  min-height: calc(100% - 20px);
  background-color: #ffffff;
  padding: 15px 20px;
  .h5 {
    max-width: 1000px;
    display: flex;
    font-size: 20px;
    margin: 20px auto;
    padding-left: 10px;
    padding-right: 300px;
    flex-wrap: 800;
    .title {
      flex: 1;
    }
  }
  .shop-details {
    max-width: 800px;
    margin: auto;
    .el-input,
    .el-textarea {
      width: 380px;
    }
    // 不能编辑样式
    .el-input.is-disabled .el-input__inner,
    .el-textarea.is-disabled .el-textarea__inner {
      cursor: inherit;
      background-color: #f8f8f8;
      border: 1px solid #f8f8f8;
      color: #606266;
    }
  }
  .avatar-uploader {
    width: 80px;
    height: 80px;
    border-radius: 6px;
    line-height: 80px;
    text-align: center;
    .el-upload {
      border: 1px dashed #d9d9d9;
      border-radius: 6px;
      cursor: pointer;
      position: relative;
      overflow: hidden;
      .avatar-uploader-icon {
        font-size: 28px;
        color: #8c939d;
        width: 80px;
        height: 80px;
        line-height: 80px;
        text-align: center;
      }
    }
  }
}
</style>
