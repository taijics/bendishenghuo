// 引入axios
import Vue from 'vue'
import promise from 'es6-promise'
import axios from 'axios'
import store from '@/store/index'
// import localStorage from '../storage/localStorage'
import Cookie from 'js-cookie'
promise.polyfill()

export const baseURL = (process.env.NODE_ENV === 'production') ? '/api' : '/api'
export const uploadURL = 'http://localhost:9007'

const service = axios.create({
  baseURL,
  headers: {
    'X-Requested-With': 'XMLHttpRequest'
  },
  withCredentials: true,
  timeout: 20000 // 请求超时 20s
})

// 请求拦截器
service.interceptors.request.use(config => {
  // 是否为当前的请求加上请求头 token
  // if (localStorage.get('token')) {
  //   config.headers['x-auth-token'] = localStorage.get('token')
  // }
  if (Cookie.get('token')) {
    config.headers['Authorization'] = Cookie.get('token')
  }
  return config
}, error => {
  return Promise.reject(error)
})

// 响应拦截器
service.interceptors.response.use(
  (response) => {
    if (response.data.code === '20005' || response.data.code === '20004') {
      store.commit('resetVuex')
      Cookie.remove('token')
      store.commit('IS_LOGIN', false) // 清除顶部导航栏数据
      store.commit('SHOW_LOGIN') // 展示登录弹框
    }
    return response
  },
  err => {
    // 失败响应
    if (err && err.response) {
      switch (err.response.status) {
        case 400:
          err.message = '请求无效，请检查参数是否正确!'
          break

        case 401:
          err.message = '未经授权，访问被拒!'
          break

        case 403:
          err.message = '拒绝访问!'
          break

        case 404:
          err.message = `地址不存在!`
          break

        case 408:
          err.message = '请求超时!'
          break

        case 500:
          err.message = '系统错误!'
          break

        case 501:
          err.message = '该方法未实现!'
          break

        case 502:
          err.message = '网管出错!'
          break

        case 503:
          err.message = '服务不可用!'
          break

        case 504:
          err.message = '网关请求超时'
          break

        case 505:
          err.message = 'HTTP版本不受支持'
          break

        default:
      }
      if (err.response.data.error) {
        err.message = err.response.data.error
      }
      Vue.prototype.$message.closeAll()
      // Vue.prototype.$message.error(err.message)
      // router.push({name: 'error', params: {message: err.message, status: err.response.status}})
    }
  }
)
export default service
