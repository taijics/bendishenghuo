<template>
  <div class="navbar">
    <hamburger
      :is-active="sidebar.opened"
      class="hamburger-container"
      @toggleClick="toggleSideBar"
    />
    <breadcrumb class="breadcrumb-container" />
    <div class="right-menu">
      <template v-if="device !== 'mobile'">
        <!-- <search id="header-search" class="right-menu-item" /> -->
        <screenfull id="screenfull" class="right-menu-item hover-effect" />
      </template>
      <el-dropdown class="avatar-container" trigger="click">
        <div class="avatar-wrapper" style="margin-left: 20px">
          <img
            :src="userAvatar"
            class="user-avatar"
          >
          <span class="user-name">{{ name }}</span>
        </div>
        <el-dropdown-menu slot="dropdown" class="user-dropdown">
          <!-- <router-link to="/">`
            <el-dropdown-item> Home </el-dropdown-item>
          </router-link>
          <a
            target="_blank"
            href="https://github.com/PanJiaChen/vue-admin-template/"
          >
            <el-dropdown-item>Github</el-dropdown-item>
          </a>
          <a
            target="_blank"
            href="https://panjiachen.github.io/vue-element-admin-site/#/"
          >
            <el-dropdown-item>Docs</el-dropdown-item>
          </a>-->
          <el-upload
            list-type="text"
            :headers="headers"
            :data="dataObj"
            :limit="100"
            :on-success="handleImageSuccess"
            :action="action"
            :show-file-list="false"
          >
            <el-dropdown-item divided>
              <span style="display: block">修改头像</span>
            </el-dropdown-item>
          </el-upload>
          <el-dropdown-item divided @click.native="changePwd">
            <span style="display: block">修改密码</span>
          </el-dropdown-item>
          <el-dropdown-item divided @click.native="logout">
            <span style="display: block">退出登录</span>
          </el-dropdown-item>
        </el-dropdown-menu>
      </el-dropdown>
    </div>
    <el-dialog
      title="修改密码"
      :visible.sync="changePwdShow"
      width="30%"
      :before-close="handleClose"
    >
      <el-form ref="ruleForm" :model="ruleForm" status-icon :rules="rules" label-width="100px" class="demo-ruleForm">
        <el-form-item label="密码" prop="password">
          <el-input v-model="ruleForm.password" maxlength="16" type="password" autocomplete="off" />
        </el-form-item>
        <el-form-item label="新密码" prop="newPassword">
          <el-input v-model="ruleForm.newPassword" maxlength="16" type="password" autocomplete="off" />
        </el-form-item>
        <el-form-item label="确认密码" prop="confirmPass">
          <el-input v-model="ruleForm.confirmPass" maxlength="16" type="password" autocomplete="off" />
        </el-form-item>
      </el-form>
      <span slot="footer" class="dialog-footer">
        <el-button @click="handleClose">取 消</el-button>
        <el-button type="primary" @click="confirmChangePwd">确 定</el-button>
      </span>
    </el-dialog>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'
import { removeToken, removeshopID, removeUserId, setAvatar, getToken } from '@/utils/auth'
import Breadcrumb from '@/components/Breadcrumb'
import Hamburger from '@/components/Hamburger'
import Screenfull from '@/components/Screenfull'
import { updatePassword, updateAvatar } from '@/api/user'
// import Search from '@/components/HeaderSearch'
import defaultAvatar from '@/assets/images/logo.png'
import { uploadUrl } from '@/utils/request'

export default {
  components: {
    Breadcrumb,
    Hamburger,
    Screenfull
  },
  data() {
    const newPassFn = (rule, value, callback) => {
      if (value === '') {
        callback(new Error('请输入新密码'))
      } else {
        if (this.ruleForm.newPassword !== '') {
          this.$refs.ruleForm.validateField('checkPass')
        }
        callback()
      }
    }
    const confirmPassFn = (rule, value, callback) => {
      if (value === '') {
        callback(new Error('请再次输入密码'))
      } else if (value !== this.ruleForm.newPassword) {
        callback(new Error('两次输入密码不一致!'))
      } else {
        callback()
      }
    }
    return {
      changePwdShow: false,
      ruleForm: {
        password: '',
        newPassword: '',
        confirmPass: ''
      },
      userAvatar: defaultAvatar,
      action: uploadUrl,
      headers: {
        'Authorization-business': getToken()
      },
      dataObj: {
        folderId: 1
      },
      rules: {
        password: [
          { required: true, message: '请输入旧密码', trigger: 'blur' }
        ],
        newPassword: [
          { required: true, validator: newPassFn, trigger: 'blur' }
        ],
        confirmPass: [
          { required: true, validator: confirmPassFn, trigger: 'blur' }
        ]
      }
    }
  },
  computed: {
    name() {
      return localStorage.getItem('roleName')
    },
    ...mapGetters(['sidebar', 'avatar', 'device'])
  },
  created() {
    const avatar = localStorage.getItem('avatar')
    if (avatar) {
      this.userAvatar = avatar
    }
  },
  methods: {
    toggleSideBar() {
      this.$store.dispatch('app/toggleSideBar')
    },
    changePwd() {
      this.ruleForm.newPassword = ''
      this.ruleForm.password = ''
      this.ruleForm.confirmPass = ''
      this.changePwdShow = true
    },
    // 修改密码
    confirmChangePwd() {
      this.$refs.ruleForm.validate(valid => {
        if (valid) {
          const obj = {
            password: this.ruleForm.password,
            newPassword: this.ruleForm.newPassword
          }
          updatePassword(obj).then(res => {
            if (res.code === '') {
              this.changePwdShow = false
              this.$message({
                message: '修改成功，请重新登录！',
                type: 'success'
              })
              this.$nextTick(() => {
                this.$refs['ruleForm'].clearValidate()
              })
              setTimeout(() => {
                localStorage.clear()
                removeToken()
                removeshopID()
                removeUserId()
                this.$router.push(`/login?redirect=${this.$route.fullPath}`)
              }, 2000)
            }
          }).catch(() => {
          })
        } else {
          console.log('error submit!!')
          return false
        }
      })
    },
    handleClose() {
      this.changePwdShow = false
      this.$nextTick(() => {
        this.$refs['ruleForm'].clearValidate()
      })
    },
    async logout() {
      localStorage.clear()
      removeToken()
      removeshopID()
      removeUserId()
      this.$router.push(`/login?redirect=${this.$route.fullPath}`)
    },
    handleImageSuccess(response) {
      const url = response.data.url
      this.userAvatar = url
      updateAvatar({ 'avatar': this.userAvatar, 'name': this.name }, 'POST')
      setAvatar(this.userAvatar)
      console.log('upload success', url)
    }
  }
}
</script>

<style lang="scss" scoped>
.navbar {
  height: 50px;
  overflow: hidden;
  position: relative;
  background: #fff;
  box-shadow: 0 1px 4px rgba(0, 21, 41, 0.08);

  .hamburger-container {
    line-height: 46px;
    height: 100%;
    float: left;
    cursor: pointer;
    transition: background 0.3s;
    -webkit-tap-highlight-color: transparent;

    &:hover {
      background: rgba(0, 0, 0, 0.025);
    }
  }

  .breadcrumb-container {
    float: left;
  }

  .right-menu {
    float: right;
    height: 100%;
    line-height: 50px;

    &:focus {
      outline: none;
    }

    .right-menu-item {
      display: inline-block;
      padding: 0 8px;
      height: 100%;
      font-size: 18px;
      color: #5a5e66;
      vertical-align: text-bottom;

      &.hover-effect {
        cursor: pointer;
        transition: background 0.3s;

        &:hover {
          background: rgba(0, 0, 0, 0.025);
        }
      }
    }

    .avatar-container {
      margin-right: 30px;

      .avatar-wrapper {
        margin-top: 5px;
        position: relative;

        .user-avatar {
          cursor: pointer;
          width: 40px;
          height: 40px;
          border-radius: 10px;
        }

        .el-icon-caret-bottom {
          cursor: pointer;
          position: absolute;
          right: -20px;
          top: 25px;
          font-size: 12px;
        }
      }
    }
  }
}
.user-name {
  vertical-align: top;
  font-size: 1rem;
  margin-left: 5px;
  margin-top: -4px;
  display: inline-block;
}
</style>
