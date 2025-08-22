import { UserActionEnum, UserStoreEnum } from './state';
import { login, logout, resetPassword } from '@/api/user'
import {
  setToken,
  removeToken,
  setName,
  setUserId,
  setUserAvatar,
} from '@/utils/auth'
import { resetRouter } from '@/router'

export const actions = {
  [UserActionEnum.LOGIN] ({ commit }, userInfo) {
    const { username, password, code, rememberMe } = userInfo
    return new Promise((resolve, reject) => {
      login({
        username: username.trim(),
        password: password,
        code: code,
        rememberMe: rememberMe,
      })
        .then((response) => {
          const { data } = response
          // debugger;
          setName(data.name)
          setUserId(data.platformUserId)
          setUserAvatar(data.avatar)
          setToken(data.token)

          commit(UserStoreEnum.TOKEN, data.token)
          // 第一次加载菜单时用到， 具体见 src 目录下的 permission.js
          commit('SET_LOAD', true)
          resolve()
        })
        .catch((error) => {
          reject(error)
        })
    })
  },
  [UserActionEnum.LOGOUT] ({ commit, state }) {
    return new Promise((resolve, reject) => {
      logout(state.token)
        .then(() => {
          removeToken() // must remove  token  first
          // 路由重置
          resetRouter()
          commit('SET_LOAD', false)
          // -
          commit(UserStoreEnum.RESET_USER)
          resolve()
        })
        .catch((error) => {
          reject(error)
        })
    })
  },
  [UserActionEnum.RESET_PASSWORD] ({ commit }, authForm) {
    const { phone, password, newPassword, code } = authForm
    return new Promise((resolve, reject) => {
      resetPassword({
        username: phone.trim(),
        password: password,
        newPassword: newPassword,
        code: code,
      })
        .then((response) => {
          resolve()
        })
        .catch((error) => {
          reject(error)
        })
    })
  },
  [UserActionEnum.RESET_TOKEN] ({ commit }) {
    return new Promise((resolve) => {
      removeToken() // must remove  token  first
      commit(UserStoreEnum.RESET_USER)
      resolve()
    })
  }
}
