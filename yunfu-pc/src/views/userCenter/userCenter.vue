<template>
  <div>
    <div class="public-notice">
      <el-carousel
        direction="vertical"
        :autoplay="true"
        indicator-position="none"
      >
        <el-carousel-item v-for="item in noticesList" :key="item.noticeId">
          <div class="medium" @click="jumpNoticeDetail(item)">
            <icon-svg icon-class="notice-public" style="margin: 0 12px;"/>{{ item.noticeTitle }}
          </div>
        </el-carousel-item>
      </el-carousel>
    </div>
    <div class="userCenter warp">
      <div class="leftMenu">
        <div class="leftMenuBox">
          <el-menu :default-active="defaultActive" active-text-color="#C5AA7B" router>
            <el-menu-item class="flex-start" index="userInfo">
              <span class="title">
                <icon-svg style="width: 30px; height:30px;" icon-class="user-info" />
                个人信息
              </span>
            </el-menu-item>
            <!-- <el-menu-item class="flex-start" index="message"><el-badge :value="userInfo.notRead" class="item"><span class="title">我的消息</span></el-badge></el-menu-item> -->
            <el-menu-item class="flex-start" index="message">
              <span class="title">
                <icon-svg style="width: 30px; height:30px;" icon-class="user-notice" />
                我的消息<span class="tip" v-if="userInfo.notRead">{{userInfo.notRead}}</span>
              </span>
            </el-menu-item>
            <el-menu-item class="flex-start" index="myOrder">
              <span class="title">
                <icon-svg style="width: 30px; height:30px;" icon-class="user-order" />
                我的订单
              </span>
            </el-menu-item>
            <el-menu-item class="flex-start" index="qaList">
              <span class="title">
                <icon-svg style="width: 30px; height:30px;" icon-class="user-wenda" />
                我的问答
              </span>
            </el-menu-item>
            <el-menu-item class="flex-start" index="orderAfterSale">
              <span class="title">
                <icon-svg style="width: 30px; height:30px;" icon-class="user-shouhou" />
                售后订单
              </span>
            </el-menu-item>
            <el-menu-item class="flex-start" index="myEvaluate">
              <span class="title">
                <icon-svg style="width: 30px; height:30px;" icon-class="user-pingjia" />
                我的评价
              </span>
            </el-menu-item>
            <el-menu-item class="flex-start" index="signingAddress">
              <span class="title">
                <icon-svg style="width: 30px; height:30px;" icon-class="user-dingwei" />
                收货地址
              </span>
            </el-menu-item>
            <!-- <el-menu-item class="flex-start" index="changePwd"><span class="title">更改密码</span></el-menu-item> -->
            <el-menu-item class="flex-start" index="favorites">
              <span class="title">
                <icon-svg style="width: 30px; height:30px;" icon-class="user-favorite" />我的收藏
              </span>
            </el-menu-item>
            <el-menu-item class="flex-start" index="browseRecords">
              <span class="title">
                <icon-svg style="width: 30px; height:30px;" icon-class="user-foot" />浏览足迹
              </span>
            </el-menu-item>
            <el-menu-item class="flex-start" index="couponPackage">
              <span class="title">
                <icon-svg style="width: 30px; height:30px;" icon-class="user-coupon" />我的卡券
              </span>
            </el-menu-item>
            <el-menu-item class="flex-start" index="changePhone">
              <span class="title">
                <icon-svg style="width: 30px; height:30px;" icon-class="user-resetphone" />更换手机号
              </span>
            </el-menu-item>
            <!-- <el-menu-item class="flex-start" index="unbindPhone"><span class="title">解绑手机</span></el-menu-item> -->
          </el-menu>
        </div>
      </div>
      <div class="userCenterInfo">
        <router-view></router-view>
      </div>
    </div>
  </div>
</template>

<script>
import Cookie from 'js-cookie'
import {mapGetters} from 'vuex'
import {
  getGongGaoAll
} from '@/api/user/notice.js'
export default {
  name: 'userCenter',
  data () {
    return {
      noticesList: [],
      swiperOption: {
        autoplay: true, // 可选选项，自动滑动
        loop: true,
        pagination: {
          el: '.swiper-pagination'
        }
      }
    }
  },
  created () {
    if (!Cookie.get('token')) {
      this.$message.warning('请先登录')
      this.$store.commit('resetVuex')
      // this.$router.push({path: '/login'})
      this.$store.commit('IS_LOGIN', false)
      this.$store.commit('SHOW_LOGIN')
      return
    }
    this.getNoticesData()
  },
  computed: {
    ...mapGetters([
      'userInfo'
    ]),
    defaultActive: function () {
      return this.$route.path.replace('/', '')
    }
  },
  methods: {
    async getNoticesData () {
      const response = await getGongGaoAll()
      const res = response.data
      this.noticesList = res.data
    },
    jumpNoticeDetail (item) {
      this.$router.push({
        path: '/activity/notificationDetails',
        query: {
          id: item.noticeId
        }
      })
    }
  }
}
</script>

<style lang="scss" scoped>
.public-notice{
  width: 100%;
  height: 50px;
  line-height: 50px;
  background-color: #666666;
  .el-carousel{
    max-width: 1250px;
    height: 100%;
    margin: auto;
    color: #FFF;
    cursor: pointer;
  }
}
.userCenter {
  margin-top: 30px;
  display: flex;
  margin-bottom: 140px;
  .leftMenu {
    width: 186px;
    border: 1px solid #E5E5E5;
    margin-right: 16px;
    .leftMenuBox {
      >>> .el-menu {
        border-right: none;
      }
      >>> .el-menu-item {
        padding: 0 !important;
        display: block;
        .title {
          width: 100%;
          height: 40px;
          line-height: 40px;
          padding-left: 50px;
          border-left: 4px solid #ffffff;
          position: relative;
          .svg-icon{
            position: absolute;
            top: -6px;
            left: 20px;
          }
        }
        .tip{
          height: 18px;
          line-height: 18px;
          border-radius: 9px;
          color: #ffffff;
          font-size: 12px;
          padding: 0 5px;
          background-color: $mainGlod;
          position: absolute;
          right: -18px;
          top: -8px;
        }
      }
      >>> .el-menu-item:focus, .el-menu-item:hover {
        background: none;
      }
      >>> .is-active {
        .title {
          border-left: 4px solid $mainGlod;
          box-sizing: content-box;
        }
      }
    }
  }
  .userCenterInfo {
    flex: 1;
  }
}
</style>
