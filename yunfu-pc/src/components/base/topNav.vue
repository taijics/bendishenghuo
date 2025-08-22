<template>
  <div class="topNav">
    <div class="content warp">
      <div class="indexPage" v-if="!this.$route.meta.hiddenLogo">
        <router-link to="/">
          <!-- <icon-svg icon-class="logo" /> -->
          <img src="static\image\nav-logo.png" alt="">
        </router-link>
      </div>
      <div v-else></div>
      <div class="right">
        <div class="item">
          <a class="hover-item" @click="applySettle">申请入驻</a>
        </div>
        <div class="item">
          <a class="hover-item" @click="goToUserOrder">我的订单</a>
        </div>
        <!-- 购物车 -->
        <div class="item item-select">
          <span class="hover-item" @click="goToShopCart">
            <i class="iconfont icon-shoppingCart"></i>购物车
            <span v-if="isShowNum">
              (<b v-text="cartNumber === 0 ? '0' : cartNumber"></b>)
            </span>
            <i class="ico-arrow el-icon-arrow-down"></i>
          </span>
          <div v-if="!isLogin" class="cart-box cart-no-login">
            <a class="loginBtn" @click="loginBtn">登录</a>
            <p class="p">登录后查看商品</p>
          </div>
          <div v-else-if="shoppingCart.length === 0" class="cart-box cart-no-data">
            <img src="static\image\gouwuche_no.webp" alt="">
            <p class="p">购物车还没有商品，赶紧选购吧！</p>
          </div>
          <div v-else class="cart-box cart-list">
            <div class="cartItem" v-for="shop in shoppingCart" :key="shop.shopId">
              <dl v-for="(item, index) in shop.skus" :key="index" v-show="index<3">
                <dt>
                  <div class="cartImgBox" style="width: 42px;height: 42px;background: #F5F5F5;" @click="$router.push('/shopping-trolley')">
                    <img :src="item.image" alt="">
                  </div>
                </dt>
                <dd>
                  <h4 class="h4" @click="$router.push('/shopping-trolley')">{{item.productName}}</h4>
                  <p>{{item.SKU}}</p>
                  <span>￥{{item.price}}</span>
                  <a class="btn-del" @click="deleteCartItem(item)"><i class="el-icon-delete" /></a>
                </dd>
              </dl>
            </div>
            <a class="btn-view-all" @click="goToShopCart" v-if="cartNumber>3">查看全部</a>
          </div>
        </div>
        <!-- 我的 -->
        <div class="item item-select">
          <span class="hover-item"><i class="iconfont icon-user"></i>我的<i class="ico-arrow el-icon-arrow-down"></i></span>
          <div class="cart-box user-box">
            <div v-if="!isLogin">
              <div class="loginBtn" @click="loginBtn">登录账号</div>
            </div>
            <div v-if="isLogin" class="info">
              <div class="avatar" @click="goToUserInfo">
                <img :src="userInfoData.headImage" alt="">
              </div>
              <div class="vip">
                <div class="top">
                  <div class="level">{{ userInfoData.memberLevelName}} </div>
                  <div class="logout" @click="outLoginBtn">退出登录</div>
                </div>
                <div class="bottom">
                  <p>会员成长值：<span>{{ userInfoData.growth }}/{{ userInfoData.nextLevelGrowth }}</span></p>
                  <el-progress
                    :show-text="false"
                    :percentage="parseInt(userInfoData.growth / userInfoData.nextLevelGrowth) * 100 || 0">
                  </el-progress>
                  <!-- <el-progress
                    :show-text="false"
                    :percentage="70"></el-progress> -->
                </div>
              </div>
            </div>
            <ul v-if="isLogin" class="personal">
              <li @click="goToUserAddress">
                <icon-svg
                  style="font-size: 54px;"
                  icon-class="nav-addres"
                />
                收货地址
              </li>
              <li @click="gotoUserCoupon">
                <icon-svg
                  style="font-size: 54px;"
                  icon-class="nav-coupon"
                />
                券包
              </li>
              <li @click="goToAfterOrder">
                <icon-svg
                  style="font-size: 54px;"
                  icon-class="nav-aftersale"
                />
                售后订单
              </li>
            </ul>
          </div>
        </div>
      </div>
    </div>
    <el-dialog
      title="提示"
      :visible.sync="outLoginDialog"
      width="30%">
      <span>确定退出登录吗？</span>
      <span slot="footer" class="dialog-footer">
        <el-button @click="outLoginDialog = false">取 消</el-button>
        <el-button class="checkOut" @click="outLogin">确 定</el-button>
      </span>
    </el-dialog>
  </div>
</template>

<script>
import {mapGetters, mapMutations} from 'vuex'
import Cookie from 'js-cookie'
import { Encrypt } from '@/util/secret'

import {
  getUserInfo
} from '@/api/user/user.js'
import {
  getGongGaoAll
} from '@/api/user/notice.js'
import {
  getCartList,
  deleteCartItem
} from '@/api/user/cart.js'
import {
  settled
} from '@/api/nav.js'

export default {
  name: 'siteNav',
  props: {
    componentContent: {
      type: Object
    }
  },
  computed: {
    ...mapGetters([
      'userInfo',
      'shoppingCart',
      'cartNumber'
    ])
  },
  data () {
    return {
      userInfoData: '',
      searchVal: '宝贝',
      keyword: '',
      isShowOut: false,
      menuOpen: false,
      isLogin: false,
      outLoginDialog: false,
      isShowNum: false,
      deleteOpt: {
        visiable: false
      },
      proList: [],
      noticeList: []
    }
  },
  watch: {
    '$store.state.isLogin': {
      handler (nVal, oVal) {
        this.isLogin = nVal
        this.isShowNum = nVal
        if (this.isLogin) {
          this.getUserInfoData()
          this.getTrolleyList()
        }
      }
    }
  },
  created () {
    if (Cookie.get('token')) {
      this.isLogin = true
      this.isShowNum = true
      this.getTrolleyList()
      this.getGongGao()
      this.getUserInfoData()
    }
  },
  methods: {
    ...mapMutations({
      setSearchObj: 'SET_SEARCHOBJ',
      setUserInfo: 'SET_USERINFO',
      setCartNumber: 'SET_CARTNUMBER',
      setShoppingCart: 'SET_SHOPPINGCART',
      setNewAddress: 'SET_NEWADDRESS',
      setAreaCode: 'SET_AREACODE',
      setNoticeId: 'SET_NOTICEID',
      IS_LOGIN: 'IS_LOGIN'
    }),
    searchCommand (command) {
      this.searchVal = command
    },
    // 查找
    searchPro () {
      this.setSearchObj({
        keyword: this.keyword,
        searchVal: this.searchVal
      })
      if (this.$route.name !== 'search') {
        this.$router.push({
          path: '/activity/search'
        })
      }
    },
    // 个人信息
    async getUserInfoData () {
      const response = await getUserInfo()
      const res = response.data
      if (res.code === '200') {
        this.setUserInfo(res.data)
        this.userInfoData = res.data
      } else {
        this.$message.error('获取个人信息失败！')
      }
    },
    // 购物车列表
    async getTrolleyList () {
      const response = await getCartList()
      const res = response.data
      let cartNumber = 0
      if (res.data && res.data.length) {
        res.data.forEach(j => {
          cartNumber = cartNumber + j.skus.length
        })
      }
      this.setShoppingCart(res.data)
      this.setCartNumber(cartNumber)
    },
    // 公告
    async getGongGao () {
      const response = await getGongGaoAll()
      const res = response.data
      if (res.code === '200') {
        this.noticeList = res.data
      } else {
        this.$message.warning(res.message)
      }
    },
    // 删除单个商品
    async deleteCartItem (item) {
      let ids = []
      ids.push(item.skuId)
      await deleteCartItem({ ids })
      let id = item.skuId
      this.shoppingCart.map(j => {
        j.skus.map(k => {
          if (k.skuId === id) {
            j.skus.splice(j.skus.findIndex(item => item.skuId === id), 1)
          }
        })
      })
      this.setCartNumber(this.cartNumber - 1)
      this.getTrolleyList()
      this.$message.success('删除成功')
    },
    outLoginBtn () {
      this.outLoginDialog = true
    },
    outLogin () {
      this.outLoginDialog = false
      Cookie.remove('token')
      this.setUserInfo({})
      this.setCartNumber('')
      this.setShoppingCart({})
      this.setNewAddress({})
      this.setAreaCode([])
      // this.$router.push({path: '/login', query: {type: 2}})
      this.$router.push({path: '/index'})
      this.$store.commit('IS_LOGIN', false) // 清除登录状态
      this.isLogin = false
      this.isShowNum = false
    },
    // 申请入驻
    applySettle () {
      let token
      if (Cookie.get('token')) {
        token = Encrypt(Cookie.get('token'))
      } else {
        this.$store.commit('SHOW_LOGIN')
        return
      }
      let username = encodeURI(this.userInfo.name)
      let userInfo = encodeURI(username)
      // let test = Decrypt(token)
      window.open(`${settled}?username=${userInfo}&user=${token}`)
    },
    goToUserInfo () {
      if (Cookie.get('token')) {
        this.$router.push({path: '/userInfo'})
      } else {
        this.$store.commit('SHOW_LOGIN')
      }
    },
    goToUserOrder () {
      if (Cookie.get('token')) {
        this.$router.push({path: '/myOrder'})
      } else {
        this.$store.commit('SHOW_LOGIN')
      }
    },
    goToAfterOrder () {
      if (Cookie.get('token')) {
        this.$router.push({path: '/orderAfterSale'})
      } else {
        this.$store.commit('SHOW_LOGIN')
      }
    },
    loginBtn (type) {
      this.$store.commit('SHOW_LOGIN')
      // this.$router.push({path: '/login', query: {type: type}})
    },
    goToUserAddress () {
      if (Cookie.get('token')) {
        this.$router.push({path: '/signingAddress'})
      } else {
        this.$store.commit('SHOW_LOGIN')
      }
    },
    gotoUserCoupon () {
      if (Cookie.get('token')) {
        this.$router.push({path: '/couponPackage'})
      } else {
        this.$store.commit('SHOW_LOGIN')
      }
    },
    goToShopCart () {
      if (Cookie.get('token')) {
        this.$router.push({path: '/shopping-trolley'})
      } else {
        this.$store.commit('SHOW_LOGIN')
      }
    },
    hover () {
      this.isShowOut = true
    },
    // 跳转到公告详情
    goToDetail (id) {
      this.$router.push({
        path: '/activity/notificationDetails',
        query: {
          id: id
        }
      })
      this.setNoticeId(id)
    }
  }
}
</script>

<style lang="scss" scoped>
$lightBlack: #666666;
$navSearchHeight: 39px;
.topNav{
  height: 50px;
  background: #333333;
  .content{
    display: flex;
    justify-content: space-between;
    align-items: center;
    .search{
      width: 430px;
      max-width: 100%;
      height: $navSearchHeight;
      margin: 5px;
      border: 1px solid $lightBlack;
      border-radius: 0px;
      overflow: hidden;
      position: relative;
      display: flex;
      .searchSelect{
        margin: 10px 10px 10px 0;
        padding: 0 12px;
        border-right: 1px  solid #E5E5E5;
        >>> .el-dropdown-link{
          font-size: 16px;
          color: #fff;
        }
      }
      .searchRight{
        flex: 1;
        input{
          width: 100%;
          height: $navSearchHeight;
          color: #CCCCCC;
          padding: 0 60px 0 15px;
          font-size: 14px;
          box-sizing: border-box;
          background-color: $lightBlack;
        }
      }
      .btn{
        width: 25px;
        height: 100%;
        padding-right: 12px;
        background-color: $lightBlack;
        color: #fff;
        line-height: $navSearchHeight;
        text-align: center;
        cursor: pointer;
      }
    }
    .indexPage{
      .svg-icon{
        margin-left: 12px;
        font-size: 40px;
        cursor: pointer;
      }
      img{
        width: 50px;
        height: 42px;
      }
    }
    .right{
      display: flex;
      .item{
        padding: 0 15px;
        display: inline-block;
        color: #FFFFFF;
        line-height: 50px;
        span{
          cursor: pointer;
          b{
            color: $mainGlod;
            padding: 0 2px;
          }
        }
        .iconfont{
          margin-right: 5px;
        }
        .icon-user{
          font-size: 14px;
        }
        &.item-select{
          padding-right: 33px;
          position: relative;
          .ico-arrow{
            position: relative;
            position: absolute;
            right: 15px;
            top: 5px;
            margin-right: 0;
            // margin: 0 3px;
            line-height: 43px;
          }
        }
        &:hover{
          background-color: #fff;
          .cart-no-data,.cart-no-login{
            display: flex;
          }
          .cart-list,.user-box{
            display: block;
          }
          .hover-item{
            color: $mainGlod;
          }
        }
      }
    }
    .cart-box{
      position: absolute;
      top: 49px;
      // top: 100%;
      background-color: #fff;
      z-index: 999;
      border-radius: 5px;
      box-shadow: 0px 0px 24px 3px rgba(0, 0, 0, 0.06);
      .cartImgBox {
        img {
          width: 100%;
        }
      }
      &.cart-no-login{
        min-width: 200px;
        left: -100px;
        height: 160px;
        display: none;
        flex-direction: column;
        justify-content: center;
        align-items: center;
        .btn{
          display: inline-block;
          padding: 0 15px;
          height: 26px;
          line-height: 26px;
          text-align: center;
          color: #fff;
          background-color: $mainColor;
          border-radius: 4px;
          margin-bottom: 40px;
        }
        .p{
          color: #666666;
          line-height: 1em;
        }
      }
      &.cart-no-data{
        width: 264px;
        height: 110px;
        left: 50%;
        margin-left: -132px;
        display: none;
        flex-direction: column;
        justify-content: center;
        align-items: center;
        color: #666;
      }
      &.cart-list{
        width: 348px;
        left: 50%;
        margin-left: -174px;
        display: none;
        padding: 10px;
        .cartItem{
          border-bottom: 1px solid #F5F5F5;
          display: flex;
          flex-direction: column;
          align-items: center;
        }
        dl{
          flex: 1;
          width: 100%;
          height: 70px;
          margin: 5px 0;
          dt{
            float: left;
            cursor: pointer;
          }
          dd{
            margin-left: 54px;
            position: relative;
            padding-right: 60px;
            min-height: 42px;
            line-height: 21px;
            h4{
              color: #333;
              cursor: pointer;
              font-size: 14px;
              @include ellipsis;
            }
            p{
              color: #333;
              font-size: 14px;
              @include ellipsis;
            }
            span{
              color: #C83732;
              position: absolute;
              top: 0;
              right: 0;
              font-size: 14px;
            }
            .btn-del{
              color: #333;
              position: absolute;
              top: 20px;
              right: 0;
              font-size: 14px;
            }
          }
        }
        .btn-view-all{
          display: block;
          margin: auto;
          // float: right;
          padding: 0 15px;
          height: 26px;
          line-height: 26px;
          text-align: center;
          color: #fff;
          background-color: $mainGlod;
          border-radius: 4px;
          margin-top: 10px;
          cursor: pointer;
        }
      }
      &.user-box{
        width: 400px;
        top: 48px;
        left: -315px;
        // padding: 18px 0;
        display: none;
        .info{
          display: flex;
          margin: 15px;
          height: 60px;
          .avatar{
            background-color: #666666;
            cursor: pointer;
            img{
              width: 54px;
              height: 54px;
            }
          }
          .vip{
            margin-left: 10px;
            flex: 1;
            cursor: default;
            .top{
              height: 35px;
              display: flex;
              justify-content: space-between;
              .level{
                display: block;
                width: 86px;
                height: 22px;
                color: $mainGlod;
                position: relative;
                top: -15px;
              }
              .logout{
                width: 115px;
                height: 30px;
                line-height: 30px;
                text-align: center;
                font-size: 14px;
                font-family: Microsoft YaHei;
                color: $mainGlod;
                background: #333333;
                box-shadow: 0px 5px 10px rgba(0, 0, 0, 0.16);
                border-radius: 3px;
                cursor: pointer;
              }
            }
            .bottom{
              p{
                font-size: 12px;
                line-height: 16px;
                color: #999999;
                span{
                  color: $mainGlod;
                }
              }
            }
          }
        }
        .personal{
          display: flex;
          justify-content: space-around;
          li{
            flex: 1;
            font-size: 16px;
            padding-top: 12px;
            cursor: pointer;
            color: #333;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            &:hover{
              color: $mainGlod;
              background-color: #F5F5F5;
            }
          }
        }
      }
    }
  }
  .loginBtn{
    width: 115px;
    margin: 15px auto;
    line-height: 30px;
    text-align: center;
    color: $mainGlod;
    background: #333333;
    border: 1px solid #333333;
    cursor: pointer;
    &:hover{
      background: #FFFFFF;
      border-color: $mainGlod;
    }
  }
  .checkOut{
    color: #FFF;
    background-color: #333;
    &:hover{
      background-color: $mainGlod;
    }
  }
}
</style>
