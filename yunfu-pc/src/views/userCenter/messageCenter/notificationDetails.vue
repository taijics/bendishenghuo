<template>
  <div class="notificationDetails warp">
    <div class="head">
      <!-- <router-link to="/message"> -->
        <div class="mar-right-10">消息中心</div>
      <!-- </router-link> -->
      <div class='arrow'></div>
      <div class="mar-right-10">公告详情</div>
    </div>
    <div class="messageDetail" v-loading="loading">
      <h1>{{ detail.noticeTitle }}</h1>
      <div class="date">{{ detail.createTime }}</div>
      <el-divider />
      <div class="messageInfo" v-html="detail.noticeContent"></div>
    </div>
  </div>
</template>

<script>
import Cookie from 'js-cookie'
import {mapGetters, mapMutations} from 'vuex'
import {
  getUserInfo
} from '@/api/user/user.js'
import {
  getNoticeDetail
} from '@/api/user/notice.js'
export default {
  name: 'notificationDetails',
  data () {
    return {
      detail: {},
      loading: false
    }
  },
  mounted () {
    this.getDetail()
  },
  computed: {
    ...mapGetters([
      'noticeId'
    ])
  },
  watch: {
    noticeId: {
      handler (newVal, oldVal) {
        if (newVal !== oldVal) {
          this.getDetail()
        }
      }
    }
  },
  methods: {
    ...mapMutations({
      setUserInfo: 'SET_USERINFO'
    }),
    async getDetail () {
      this.loading = true
      const response = await getNoticeDetail({ noticeId: this.$route.query.id })
      const res = response.data
      if (res.code === '200') {
        this.detail = res.data
        if (Cookie.get('token')) {
          this.getUserInfoData()
        }
        this.loading = false
      } else {
        this.$message.warning(res.message)
      }
    },
    async getUserInfoData () {
      const response = await getUserInfo()
      const res = response.data
      if (res.code === '200') {
        this.setUserInfo(res.data)
      } else {
        this.$message.warning(res.message)
      }
    }
  }
}
</script>

<style lang="scss" scoped>
.notificationDetails {
  .head {
    width: 100%;
    height: 50px;
    line-height: 50px;
    font-size: 16px;
    display: flex;
    align-items: center;
    .arrow {
      background-image: url('../../../../static/image/xiangyou@2x.png');
      width: 5px;
      height: 10px;
      margin-right: 10px;
    }
  }
  .messageDetail {
    background: #FFFFFF;
    padding: 50px 0;
    min-height: 500px;
    h1 {
      font-size: 40px;
      font-weight: bold;
      color: #333333;
      text-align: center;
      margin-bottom: 20px;
    }
    .date {
      font-size: 14px;
      font-weight: 400;
      color: #666666;
      text-align: center;
      margin-bottom: 25px;
    }
    .messageInfo {
      min-height: 500px;
      p {
        font-size: 14px;
        color: #666666;
      }
    }
    .messageInfo >>> img{ // 修改v-html渲染的样式
      max-width: 100%;
      height: auto;
    }
  }
}
</style>
