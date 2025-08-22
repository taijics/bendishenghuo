/*
 * 列表搜索的 mixin
 */
import request from './server'

/* eslint-disable */
export const listSearch = {
  data () {
    return {
      // 加载中
      loading: false,
    }
  },
  methods: {
    /*
     * 发送请求
     */
    sendReq (params, callback) {
      let self = this
      request({
        method: params.method || 'POST',
        url: params.url,
        data: params.data || {},
        withCredentials : true,
        headers: {
          'Content-Type': params.contentType || 'application/json;charset=utf-8'
        }
      }).then((res) => {
        if (res && res.data) {
          callback && callback(res.data)
        }
      }, (error) => {
        console.log(error)
      })
    }
  }
}
