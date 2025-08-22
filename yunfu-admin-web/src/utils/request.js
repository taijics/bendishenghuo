import axios from 'axios'
import { ElMessageBox as MessageBox, ElMessage as Message } from 'element-plus'
import store from '@/store'
import router from '@/router'
import { getToken, removeToken } from '@/utils/auth'
import { UserActionEnum } from '@/store/modules/user/state'

const baseURL = import.meta.env.VITE_ENV === 'development' ? '/api' : import.meta.env.VITE_BASE_URL
// create an axios instance
axios.defaults.timeout = 30000
const service = axios.create({
  // baseURL: "http://172.16.101.241:8003", // url = base url + request url
  baseURL, // url = base url + request url
  // withCredentials: true, // send cookies when cross-domain requests
  timeout: 30000, // request timeout
})

export const uploadUrl = `${baseURL}/file/upload`
export const token = getToken()

// request interceptor
service.interceptors.request.use(
  (config) => {
    // console.log(config)
    if (store.getters.token) {
      config.headers['Authorization-admin'] = getToken()
      config.headers['Content-Type'] = 'application/json; charset=UTF-8'
      // config.headers['type'] = ' admin'
    }
    return config
  },
  (error) => {
    console.log(error) // for debug
    return Promise.reject(error)
  }
)

// response interceptor
service.interceptors.response.use(
  (response) => {
    const res = response.data
    if (response.config.responseType === 'blob') {
      console.log(response.data)
      return response.data
    }
    if (res.code !== '') {
      Message({
        message: res.message || 'Error',
        type: 'error',
        duration: 5 * 1000,
      })

      // 50008: Illegal token; 50012: Other clients logged in; 50014: Token expired;
      /**
        token为空 20003
        public static final String TOKEN_IS_NULL = "20003";
        token认证失败
        public static final String TOKEN_APPROVE_ERROR = "20004";
        请先登录
        public static final String USER_NOT_LOGIN = "20005";
       */
      const tokenerr = [20003, '20003', 20004, '20004', 20005, '20005']
      if (tokenerr.includes(res.code)) {
        localStorage.clear()
        removeToken()
        router.push({ path: '/login' })
        location.reload()
      }
      if (res.code === 50008 || res.code === 50012 || res.code === 50014) {
        // to re-login
        MessageBox.confirm(
          'You have been logged out, you can cancel to stay on this page, or log in again',
          'Confirm logout',
          {
            confirmButtonText: 'Re-Login',
            cancelButtonText: 'Cancel',
            type: 'warning',
          }
        ).then(() => {
          store.dispatch(UserActionEnum.RESET_TOKEN).then(() => {
            location.reload()
          })
        })
      }
      return Promise.reject(new Error(res.message || 'Error'))
    } else {
      return res
    }
  },
  (error) => {
    if (!error.message.includes('timeout')) {
      Message({
        message: '服务器暂无响应，请稍后重试',
        type: 'error',
        duration: 5 * 1000,
      })
    }
    return Promise.reject(error)
  }
)

export default service
