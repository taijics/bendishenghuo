<template>
  <div class="userInfo">
    <div class="rowBox">
      <div class="changeAvatar">
        <el-upload
          class="avatar-uploader"
          :action="action"
          :show-file-list="false"
          :on-success="handleAvatarSuccess"
        >
          <img v-if="userInfo.headImage" :src="userInfo.headImage" class="avatar">
          <i v-else class="el-icon-plus avatar-uploader-icon"></i>
        </el-upload>
        <!-- <span class="avatarTit">更换头像</span> -->
      </div>
      <div class="mid">
        <div class="userNameBox userBlock">
          <label>昵称：</label>
          <el-input v-model="userInfo.name" placeholder="请输入内容"></el-input>
        </div>
        <div class="userNameBox userBlock">
          <label>性别：</label>
          <el-radio v-model="userInfo.sex" label="男">男</el-radio>
          <el-radio v-model="userInfo.sex" label="女">女</el-radio>
        </div>
      </div>
      <div class="right">
        <div class="birthTimeBox userBlock">
          <label>出生日期：</label>
          <el-date-picker
            v-model="userInfo.birthday"
            type="date"
            placeholder="选择日期"
            format="yyyy 年 MM 月 dd 日"
            value-format="yyyy-MM-dd">
          </el-date-picker>
        </div>
        <div class="bindPhoneBox userBlock">
          <label>绑定手机号：</label>
          <div class="phoneInfo">
            <span>{{ userInfo.phone }}</span>
            <span @click="$router.push('/changePhone')">更换</span>
          </div>
        </div>
      </div>
    </div>
    <el-button class="userInfoSave"
      :loading="loading"
      @click="saveUserInfo"
    >保存</el-button>
  </div>
</template>

<script>
import {
  getUserInfo,
  changeUserInfo
} from '@/api/user/user.js'
import {
  upload
} from '@/api/upload.js'
import {mapGetters, mapMutations} from 'vuex'

export default {
  name: 'userInfo',
  data () {
    return {
      userName: 'Curmudgeons',
      gender: '1',
      birthTime: '',
      userInfoData: {},
      avatarImg: '',
      action: upload,
      loading: false
    }
  },
  computed: {
    ...mapGetters([
      'userInfo' // 用户信息
    ])
  },
  methods: {
    ...mapMutations({
      setUserInfo: 'SET_USERINFO', // 修改用户信息
      setAVATR: 'SET_AVATAR' // 修改用户信息
    }),
    async getUserInfoData () {
      const response = await getUserInfo()
      const res = response.data
      if (res.code === '200') {
        this.setUserInfo(res.data)
      } else {
        this.$message.error(res.message)
      }
    },
    async saveUserInfo () {
      this.loading = true
      let errMsg = ''
      if (!this.userInfo.name) {
        errMsg += ' 请输入昵称 '
      }
      if (!this.userInfo.birthday) {
        errMsg += ' 请输入生日 '
      }
      if (errMsg.length !== 0) {
        this.$message.error(errMsg)
        this.loading = false
        return
      }
      const response = await changeUserInfo({
        name: this.userInfo.name,
        sex: this.userInfo.sex,
        birthday: this.userInfo.birthday,
        headImage: this.userInfo.headImage
      })
      const res = response.data
      if (res.code === '200') {
        this.$message({
          message: '修改成功！',
          type: 'success'
        })
        this.getUserInfoData()
      }
      this.loading = false
    },
    // 上传头像
    handleAvatarSuccess (res) {
      this.setAVATR(res.data.url)
      this.$message({
        message: '上传成功，请保存修改！',
        type: 'success'
      })
  }
  }
}
</script>

<style lang="scss" scoped>
.userInfo {
  max-width: 1000px;
  padding: 30px;
  border: 1px solid #E5E5E5;
  .rowBox{
    min-height: 500px;
    display: flex;
    justify-content: space-between;
  }
  .changeAvatar {
    width: 134px;
    height: 134px;
    position: relative;
    .avatar {
      width: 100%;
      max-width: 120px;
      max-height: 120px;
    }
    .avatarTit {
      height: 30px;
      line-height: 30px;
      position: absolute;
      bottom: 0;
      font-size: 16px;
      background: rgba(84, 84, 84, 0.5);
      width: 100%;
      text-align: center;
      color: #ffffff;
      cursor: pointer;
    }
  }
  .mid{
    min-width: 230px;
    margin: 0 20px;
    .userNameBox {
      >>> .el-input {
        width: 180px;
      }
    }
  }
  .userBlock {
    margin-top: 30px;
    display: flex;
    align-items: center;
    label {
      font-weight: normal;
      font-size: 16px;
      color: #666666;
    }
  }
  .right{
    min-width: 230px;
    .bindPhoneBox {
      .phoneInfo {
        font-size: 16px;
        span {
          margin-right: 15px;
          text-decoration: underline;
          cursor: pointer;
        }
        span:nth-child(1) {
          color: #333333;
          text-decoration: none;
          cursor: default;
        }
        span:nth-child(2) {
          color: $mainGlod;
        }
        span:nth-child(3) {
          color: #666666;
        }
      }
    }
  }
  .userInfoSave {
    display: block;
    width: 200px;
    height: 50px;
    margin: 50px auto;
    padding: 0;
    line-height: 50px;
    background: #333333;
    border: 1px solid #333333;
    border-radius: 0px;
    text-align: center;
    color: $mainGlod;
    font-size: 16px;
    cursor: pointer;
    &:hover{
      color: #FFF;
      background: $mainGlod;
      border: 1px solid $mainGlod;
    }
  }
}
</style>
