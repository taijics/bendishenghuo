import request from '@/utils/request'

//* ******************** 财务统计  *********************
// 财务统计数据查询
export function getFinanceCount(data) {
  return request({
    url: '/finance/getFinanceCount',
    method: 'post',
    data
  })
}

// 提现明细查询
export function getWithdrawalDetails(data) {
  return request({
    url: '/finance/getWithdrawalDetails',
    method: 'post',
    data
  })
}

// 查询绑定银行卡
export function getBank(data) {
  return request({
    url: '/finance/getBank',
    method: 'post',
    data
  })
}

// 提现申请
export function withdrawal(data) {
  return request({
    url: '/finance/withdrawal',
    method: 'post',
    data
  })
}

// 提现明细查询
export function getDetails(data) {
  return request({
    url: '/finance/getDetails',
    method: 'post',
    data
  })
}

// 保证金查询
export function getAllBond(data) {
  return request({
    url: '/finance/getAllBond',
    method: 'post',
    data
  })
}

