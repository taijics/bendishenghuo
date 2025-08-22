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
          <img :src="userAvatar" class="user-avatar" />
          <span class="user-name">{{ name }}</span>
        </div>
        <template #dropdown>
          <el-dropdown-menu class="user-dropdown">
            <!-- <router-link to="/">
                <el-dropdown-item>Home</el-dropdown-item>
              </router-link>
              <a target="_blank" href="https://github.com/PanJiaChen/vue-admin-template/">
                <el-dropdown-item>Github</el-dropdown-item>
              </a>
              <a target="_blank" href="https://panjiachen.github.io/vue-element-admin-site/#/">
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
            <el-dropdown-item @click.native="changePassword">
              <span style="display: block">修改密码</span>
            </el-dropdown-item>
            <el-dropdown-item divided @click.native="logout">
              <span style="display: block">退出登录</span>
            </el-dropdown-item>
          </el-dropdown-menu>
        </template>
      </el-dropdown>
    </div>
    <!--  修改密码  -->
    <el-dialog
      v-model="changePwdShow"
      title="修改密码"
      width="30%"
      :before-close="handleClose"
    >
      <el-form
        ref="formRef"
        :model="ruleForm"
        status-icon
        :rules="rules"
        label-width="100px"
      >
        <el-form-item label="密码" prop="password">
          <el-input
            v-model="ruleForm.password"
            maxlength="16"
            type="password"
            autocomplete="off"
          />
        </el-form-item>
        <el-form-item label="新密码" prop="newPassword">
          <el-input
            v-model="ruleForm.newPassword"
            maxlength="16"
            type="password"
            autocomplete="off"
          />
        </el-form-item>
        <el-form-item label="确认密码" prop="confirmPass">
          <el-input
            v-model="ruleForm.confirmPass"
            maxlength="16"
            type="password"
            autocomplete="off"
          />
        </el-form-item>
      </el-form>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="handleClose">取 消</el-button>
          <el-button type="primary" @click="confirmChangePwd">确 定</el-button>
        </span>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, onBeforeMount, computed, nextTick } from 'vue'
import { useStore } from 'vuex'
import { useRouter, useRoute } from 'vue-router'
import Breadcrumb from '@/components/Breadcrumb/index.vue'
import Hamburger from '@/components/Hamburger/index.vue'
import Screenfull from '@/components/Screenfull/index.vue'
import defaultAvatar from '@/assets/images/logo.png'
// import Search from '@/components/HeaderSearch/index.vue'
import {
  getToken,
  getUserAvatar,
  removeToken,
  setUserAvatar,
} from '@/utils/auth'
import { changePwd, changeHeader } from '@/api/user'
import { uploadUrl } from '@/utils/request'

// const newPassFn = (rule, value, callback) => {
//   if (value === '') {
//     callback(new Error('请输入新密码'))
//   } else {
//     formRef.value.validateField('confirmPass')
//     callback()
//   }
// }
const confirmPassFn = (rule, value, callback) => {
  if (value === '') {
    callback(new Error('请再次输入密码'))
  } else if (value !== ruleForm.value.newPassword) {
    callback(new Error('两次输入密码不一致!'))
  } else {
    callback()
  }
}

const router = useRouter()
const route = useRoute()
const store = useStore()
const { getters } = useStore()
const formRef = ref(null)
const userAvatar = ref(null)
const changePwdShow = ref(false)
const name = computed(() => localStorage.getItem('roleName'))
const sidebar = computed(() => getters['sidebar'])
const device = computed(() => getters['device'])
const action = uploadUrl
const headers = {
  'Authorization-admin': getToken()
}
const dataObj = {
  folderId: 1
}
const ruleForm = ref({
  password: '',
  newPassword: '',
  confirmPass: ''
})
const rules = {
  password: [
    { required: true, message: '请输入旧密码', trigger: 'blur' },
  ],
  newPassword: [
    { required: true, message: '请输入新密码', trigger: 'blur' },
  ],
  confirmPass: [
    { required: true, validator: confirmPassFn, trigger: 'blur' }
  ]
}

onBeforeMount(() => {
  userAvatar.value = getUserAvatar() || defaultAvatar
})

const toggleSideBar = () => {
  store.commit('app/TOGGLE_SIDEBAR')
}
// 更换头像
const handleImageSuccess = (response) => {
  const url = response.data.url
  userAvatar.value = url
  changeHeader({ avatar: userAvatar.value, name: name.value }).then(res => {
    if (res.code === '') {
      ElMessage.success('更换成功')
      setUserAvatar(userAvatar.value)
    }
  })
}
const changePassword = () => {
  ruleForm.value.newPassword = ''
  ruleForm.value.password = ''
  ruleForm.value.confirmPass = ''
  changePwdShow.value = true
}
// 修改密码
const confirmChangePwd = () => {
  formRef.value.validate((valid) => {
    if (valid) {
      const obj = {
        password: ruleForm.value.password,
        newPassword: ruleForm.value.newPassword,
      }
      changePwd(obj)
        .then((res) => {
          if (res.code === '') {
            changePwdShow.value = false
            ElMessage({
              message: '修改成功，请重新登录！',
              type: 'success',
            })
            nextTick(() => {
              formRef.value.clearValidate()
            })
            setTimeout(() => {
              localStorage.clear()
              removeToken()
              router.push(`/login?redirect=${route.fullPath}`)
            }, 2000)
          }
        })
        .catch(() => {})
    } else {
      return false
    }
  })
}
const handleClose = () => {
  changePwdShow.value = false
  nextTick(() => {
    formRef.value.clearValidate()
  })
}
const logout = async () => {
  localStorage.clear()
  removeToken()
  router.push(`/login?redirect=${route.fullPath}`)
}
</script>

<style lang="scss" scoped>
.navbar {
  height: 50px;
  overflow: hidden;
  position: relative;
  background: #fff;
  box-shadow: 0 1px 4px rgba(0, 21, 41, 0.08);
  border-bottom: 1px solid #E0E5EB;

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
    display: flex;

    &:focus {
      outline: none;
    }

    .right-menu-item {
      display: flex;
      align-items: center;
      padding: 0 8px;
      height: 100%;
      font-size: 18px;
      color: #5a5e66;

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
        display: flex;
        align-items: center;
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

.el-icon-plus {
  width: 160px;
  height: 160px;
  display: flex;
  align-items: center;
  justify-content: center;
  border: 1px solid #a1a0a0;
  border-radius: 5px;
}

.center-content {
  display: flex;
  align-items: center;
  justify-content: center;
}
</style>
