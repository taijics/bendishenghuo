import request from '@/util/server.js'

// 平台秒杀专区
export function getSeckill (data) {
  return request({
    url: '/platform-seckill/queryProductListBySession',
    method: 'post',
    data
  })
}

// 查询秒杀专区列表
export function getSeckillIndex (params) {
  return request({
    url: '/seckill/getIndex',
    method: 'get',
    params
  })
}

// 查询秒杀时间段
export function getSeckillTime () {
  return request({
    url: '/platform-seckill/querySession',
    method: 'get'
  })
}
