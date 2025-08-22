import request from '@/utils/request'

// 财务概况查询
export function overviewGetall(data) {
  return request({
    url: '/finance/getAllFinance',
    method: 'post',
    data,
  })
}

// 保证金查询
export function getAllBond(data) {
  return request({
    url: '/finance/getAllBond',
    method: 'post',
    data,
  })
}
