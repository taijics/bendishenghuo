import request from '@/util/server.js'

export const settled = 'https://ceres.zkthink.com/settled-merchant/#/' // 商家入驻地址

// 获取首页导航栏分类
export function getCategory () {
  return request({
    url: '/classify/getFirstClassify',
    method: 'get'
  })
}
