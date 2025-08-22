<template>
  <div class="messageBox sub-main" v-loading="loading">
    <div v-if="flag">
      <div class="messageList">
        <div class="itemBox"
          v-for="item of messageList"
          :key="item.noticeId"
          @click="goToDetail(item)"
        >
          <div class="icon" :class="{color: item.noticeType === 3}">
            <icon-svg style="font-size: 36px" icon-class="user-notice-icon" />
            <div class="point" v-if="item.ifRead === 0"></div>
          </div>
          <div class="messageTitle">
            <h3
              v-if="item.noticeType === 1"
            >
              {{item.noticeContent}}
            </h3>
            <h3
              v-if="[2,3].includes(item.noticeType)"
            >
              {{item.noticeTitle}}
            </h3>
            <span>{{ item.createTime }}</span>
          </div>
          <el-button
            class="delBtn"
            v-if="item.notice_type !== 3"
            @click.stop="delNotice(item)"
          >
            <icon-svg style="font-size: 32px" icon-class="del" />
          </el-button>
        </div>
      </div>
      <div class="pageBox">
        <el-pagination
          v-if="messageList.length"
          background
          layout="prev, pager, next, jumper"
          :page-size="pageSize"
          :current-page="page"
          @current-change="handleCurrentChange"
          :total="total">
        </el-pagination>
        <el-button type="primary" size="mini" style="margin-left:10px;">确定</el-button>
      </div>
    </div>
    <div class="nothing" v-else>
      <icon-svg style="width: 240px; height: 240px; margin: 40px;" icon-class="user-notice-nodata" />
      <p class="fs20 font-color-999">你还没有消息～</p>
      <!-- <router-link to="/">
          <el-button>去首页看看</el-button>
      </router-link> -->
    </div>
  </div>
</template>

<script>
import { mapMutations } from 'vuex'
import {
  getUserInfo
} from '@/api/user/user.js'
import {
  getNoticeAll,
  readNotice,
  noticeDel
} from '@/api/user/notice.js'
export default {
  name: 'message',
  data () {
    return {
      messageList: [],
      page: 1,
      pageSize: 10,
      total: 1,
      flag: true,
      loading: false
    }
  },
  mounted () {
    this.getAll()
    this.getUserInfoData()
  },
  methods: {
    ...mapMutations({
      setUserInfo: 'SET_USERINFO'
    }),
    // 获取消息列表
    async getAll () {
      this.loading = true
      const response = await getNoticeAll({
        page: this.page,
        pageSize: this.pageSize
      })
      const res = response.data
      if (res.code === '200') {
        this.messageList = res.data.list
        this.total = res.data.total
        if (res.data.list.length) {
          this.flag = true
        } else {
          this.flag = false
        }
        this.loading = false
      } else {
        this.$message.warning(res.message)
      }
    },
    // 获取用户信息
    async getUserInfoData () {
      const response = await getUserInfo()
      const res = response.data
      if (res.code === '200') {
        this.setUserInfo(res.data)
      } else {
        this.$message.warning(res.message)
      }
    },
    // 翻页
    handleCurrentChange (val) {
      this.page = val
      this.getAll()
    },
    // 查看详情
    async goToDetail (item) {
      const response = await readNotice({ noticeId: item.noticeId })
      const res = response.data
      if (res.code === '200') {
        this.noticeJump(item)
      } else {
        this.$message.warning(res.message)
      }
    },
    // 详情跳转
    noticeJump (item) {
      if (item.noticeType === 1) {
        if (item.jump === 0) {
          this.$router.push({
            path: '/activity/notificationDetails',
            query: {
              id: item.noticeId
            }
          })
        } else if (item.jump === 1) {
          this.$router.push({
            path: '/activity/notificationDetails',
            query: {
              id: item.noticeId
            }
          })
        } else if (item.jump === 2) {
          this.$router.push({
            path: '/orderDetail',
            query: {
              orderId: item.only,
              noticeId: item.noticeId
            }
          })
        }
      } else if (item.noticeType === 3 || 2) {
        this.$router.push({
          path: '/activity/notificationDetails',
          query: {
            id: item.noticeId
          }
        })
      }
    },
    async delNotice (item) {
      if (!item.noticeId) {
        this.$message.error('选中消息异常！')
        return
      }
      const response = await noticeDel({ noticeId: item.noticeId })
      const res = response.data
      if (res.code === '200') {
        this.$message.success('删除成功')
        this.getAll()
      } else {
        this.$message.error(res.msg)
      }
    }
  }
}
</script>

<style lang="scss" scoped>
.messageBox {
  background: #FAFAFA;
  border: 1px solid #E5E5E5;
  padding: 25px;
  .pageBox {
    display: flex;
    justify-content: flex-end;
    .el-button{
      border-radius: 0;
    }
  }
  .messageList {
    .itemBox {
      height: 80px;
      padding: 10px 20px;
      margin-bottom: 30px;
      background-color: #FFF;
      display: flex;
      justify-content: space-between;
      align-items: center;
      transition: all 0.3s linear;
      cursor: pointer;
      &:hover{
        box-shadow: 0px 0px 20px rgba(0, 0, 0, 0.2);
        .delBtn{
          display: block;
        }
      }
      .icon {
        width: 56px;
        height: 56px;
        border-radius: 50%;
        background: #333333;
        display: flex;
        align-items: center;
        justify-content: center;
        color: #FFFFFF;
        font-size: 26px;
        margin-right: 30px;
        position: relative;
        .point{
          width: 10px;
          height: 10px;
          border-radius: 5px;
          background-color: red;
          position: absolute;
          top: 10px;
          right: 10px;
        }
      }
      .color {
        background: #C5AA7B;
      }
      .messageTitle {
        flex: 1;
        h3 {
          color: #333333;
          font-size: 14px;
          margin-bottom: 20px;
          white-space: nowrap;
          overflow: hidden;
          text-overflow: ellipsis;
        }
        span {
          color: #666666;
          font-size: 12px;
        }
      }
      .delBtn{
        display: none;
        animation: s 1.5s;
      }
      @keyframes s {
        from {
          opacity: 0;
        }
        to {
          opacity: 1;
        }
      }
    }
  }
}
.sub-main{
  min-height: 400px;
}
.nothing{
  width: 100%;
  text-align: center;
  min-height: 400px;
  p{
      margin-bottom: 20px;
  }
  .el-button{
      background-color: #FF7800;
      color: #FFFFFF;
      font-weight: normal;
      border-radius: 0;
  }
}
</style>
