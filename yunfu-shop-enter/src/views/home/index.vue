<template>
  <div class="login">
    <div class="pc">
      <div class="loginTop">
        <div class="loginLogo warp">
          <div class="leftBox">
            <div class="loginImgBox">
              <img src="@/assets/images/logo.webp" alt="">
            </div>
          </div>
          <!-- <div class="rightBox" v-if="userName !== ''">
            欢迎您{{userName == 'undefined' ? '' : userName}}
          </div>
          <div v-else class="rightBox">
            我已有CERESHOP<span>快捷登录</span>
          </div> -->
        </div>
      </div>
      <div class="loginCent">
        <div class="entrance">
          <div class="entranceInfo">
            <img src="../../assets/images/title.webp" alt="">
            <p>用心开好店，打造大事业，与CERESHOP共同展望美好未来。</p>
          </div>
          <!-- 申请跳转按钮 -->
          <div class="entranceBtn">
            <div
              class="btnContainer"
              v-for="item in pcBtnList"
              :key="item.value"
              @click="goToApplication(type = item.type)"
            >
              <img :src="item.img" alt="">
              <span>{{ item.label }}</span>
            </div>
          </div>
        </div>
      </div>
    </div>
    <!-- 手机端 -->
    <div class="wap">
      <div class="wapTop">
        商家入驻
      </div>
      <div class="wapBan">
      </div>
      <div class="wapCent">
        <div class="wapCentBox">
          <div class="wapItemBox"
            v-for="item in mbBtnList"
            :key="item.value">
            <span>
              <img :src="item.img">{{ item.label }}
            </span>
            <el-button @click="goToApplication(type = item.type)" type="primary">去申请</el-button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { Decrypt } from '@/util/secret.js'
import Cookie from 'js-cookie'
export default {
  name: 'login',
  data () {
    return {
      userName: '',
      // pc端列表渲染
      pcBtnList: [
        {
          value: 0,
          img: 'static/imgs/pc/pc-personal.svg',
          label: '个人商户',
          type: 'personal'
        },
        {
          value: 1,
          img: 'static/imgs/pc/pc-IndividualBusiness.svg',
          label: '个体工商户',
          type: 'IndividualBusiness'
        },
        {
          value: 2,
          img: 'static/imgs/pc/pc-enterprisesApply.svg',
          label: '企业商户',
          type: 'enterprisesApply'
        },
        {
          value: 3,
          img: 'static/imgs/pc/pc-organization.svg',
          label: '其他组织',
          type: 'organization'
        }
      ],
      // 手机端列表渲染
      mbBtnList: [
        {
          value: 0,
          img: 'static/imgs/mb/mb-personal.svg',
          label: '个人商户',
          type: 'mPersonal'
        },
        {
          value: 1,
          img: 'static/imgs/mb/mb-mUinitBusiness.svg',
          label: '个体工商户',
          type: 'mUinitBusiness'
        },
        {
          value: 2,
          img: 'static/imgs/mb/mb-mEnterprise.svg',
          label: '企业商户',
          type: 'mEnterprise'
        },
        {
          value: 3,
          img: 'static/imgs/mb/mb-mOtherOrg.svg',
          label: '其他组织',
          type: 'mOtherOrg'
        }
      ]
    }
  },
  created () {
    if (this.userName === '') {
      let data = this.getQueryString('user')
      if (data !== '' && data !== undefined) {
        let user = Decrypt(data)
        console.log(user, 'token')
        Cookie.set('token', user)
      }
      // let userName = this.getQueryString('username')
      // let userInfo = decodeURI(userName)
      // if (userInfo !== '') {
      //   this.setUserName(userInfo)
      // }
    }
  },
  methods: {
    goToApplication (type) {
      if (type === 'IndividualBusiness') {
        this.$router.push({path: '/individualBusiness'})
      }
      if (type === 'personal') {
        this.$router.push({path: '/personal'})
      }
      if (type === 'enterprisesApply') {
        this.$router.push({path: '/enterprisesApply'})
      }
      if (type === 'organization') {
        this.$router.push({path: '/organization'})
      }
      if (type === 'mUinitBusiness') {
        this.$router.push({path: '/mUinitBusiness'})
      }
      if (type === 'mEnterprise') {
        this.$router.push({path: '/mEnterprise'})
      }
      if (type === 'mPersonal') {
        this.$router.push({path: '/mPersonal'})
      }
      if (type === 'mOtherOrg') {
        this.$router.push({path: '/mOtherOrg'})
      }
    },
    getQueryString (name) {
      const reg = new RegExp('(^|&)' + name + '=([^&]*)(&|$)', 'i')
      const urlObj = window.location
      const url = window.location.href
      if (url.indexOf(name) !== -1) {
        let r = urlObj.href.indexOf('#') > -1 ? urlObj.hash.split('?')[1].match(reg) : urlObj.search.substr(1).match(reg)
        if (r != null) return unescape(r[2]); return null
      }
    }
  }
}
</script>

<style lang="scss" scoped>
.login {
  height: 100%;
  min-height: 870px;
  display: flex;
  flex-direction: column;
  background-image: url('../../assets/images/background.webp');
  background-repeat: no-repeat;
  background-size: 100% 100%;
  .loginTop {
    background-color: #333333;
    position: relative;
    z-index: 999;
    .loginLogo {
      height: 50px;
      color: #fff;
      display: flex;
      align-items: center;
      justify-content: space-between;
      img {
        width: 180px;
        margin-right: 30px;
      }
      span {
        font-size: 18px;
        color: $fontColor;
      }
      .loginImgBox {
        width: 51px;
        height: 40px;
        align-items: center;
        display: flex;
        margin-right: 20px;
        cursor: pointer;
        img {
          width: 100%;
        }
      }
      .leftBox {
        display: flex;
        align-items: center;
        font-weight: 400;
      }
      .rightBox {
        font-size: 16px;
        span {
          color: #C5AA7B;
          padding-left: 10px;
          cursor: pointer;
        }
      }
    }
  }
  .loginCent {
    margin-top: 100px;
    font-family: Microsoft YaHei;
    display: flex;
    justify-content: center;
    align-items: center;
    .entrance {
      .entranceInfo{
        img{
          display: block;
          width: 480px;
          margin: auto;
        }
        p{
          margin: 30px 0;
          font-size: 16px;
          text-align: center;
          color: #FFFFFF;
        }
      }
    }
    .entranceBtn {
      width: 700px;
      display: flex;
      justify-content: space-around;
      .btnContainer{
        width: 80px;
        cursor: pointer;
        img{
          display: block;
          width: 80px;
          height: 80px;
        }
        span{
          display: block;
          margin-top: 18px;
          text-align: center;
          color: #FFEBC4;
        }
      }
    }
  }
  .wap {
    display: none;
  }
  .pc {
    height: 100%;
    display: flex;
    flex-direction: column;
    min-height: 768px;
  }
}
@media screen and (max-width: 750px) {
  .warp {
    width: 100%;
  }
  .login {
    background: #F8F8F8;
    position: relative;

    .pc {
      display: none;
    }

    .wap {
      display: block;

      .wapTop {
        height: 60px;
        line-height: 60px;
        color: #FFF;
        background-color: #333333;
        font-size: 18px;
        text-align: center;
      }
      .wapBan {
        width: 100%;
        background: url("../../assets/images/mb-background.png") no-repeat top center;
        background-size: contain;
        height: 300px;
      }
      .wapCent {
        position: absolute;
        top: 25%;
        width: 100%;
        .wapCentBox {
          width: 94%;
          margin: -50px auto 0 auto;
          padding: 5%;
          background: #FFFFFF;
          // box-shadow: 0px 1px 32px 2px #F4F4F4;
          // border-radius: 10px;
          .wapItemBox {
            display: flex;
            height: 90px;
            align-items: center;
            justify-content: space-between;
            width: 100%;
            border-bottom: 1px solid #F6F4F7;
            >>> .el-button--primary {
              width: 80px;
              color: #FFEBC4;
              background-color: #333333;
              border-radius: 0;
            }
          }
          .wapItemBox:last-child {
            border-bottom: none;
          }
          span {
            display: flex;
            align-items: center;
            img {
              width: 35px;
              height: 35px;
              margin-right: 12px;
            }
          }
        }
      }
    }
  }
}
</style>
