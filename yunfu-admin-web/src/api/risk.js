import request from '@/utils/request'

// 查询ip黑名单列表
export function getIpBlackList(data) {
  return request({
    url: '/risk/getAllIpBlackList',
    method: 'post',
    data,
  })
}

// 查询用户黑名单列表
export function getUserBlackList(data) {
  return request({
    url: '/risk/getAllUserBlackList',
    method: 'post',
    data,
  })
}

// 新增ip或用户黑名单
export function addBlack(data) {
  return request({
    url: '/risk/saveRiskBlack',
    method: 'post',
    data,
  })
}

// 更新ip或用户黑名单
export function updateBlack(data) {
  return request({
    url: '/risk/updateRiskBlack',
    method: 'post',
    data,
  })
}

// 删除ip或用户黑名单
export function delBlack(data) {
  return request({
    url: '/risk/deleteRiskBlack',
    method: 'post',
    data,
  })
}

// 搜索用户信息
export function searchUser(data) {
  return request({
    url: '/buyer/searchUser',
    method: 'post',
    data,
  })
}

// 查询规则列表
export function getRuleList(data) {
  return request({
    url: '/risk/getAllRiskRule',
    method: 'post',
    data,
  })
}

// 新增规则配置
export function addRule(data) {
  return request({
    url: '/risk/saveRiskRule',
    method: 'post',
    data,
  })
}

// 更新规则配置
export function updateRule(data) {
  return request({
    url: '/risk/updateRiskRule',
    method: 'post',
    data,
  })
}

// 删除规则配置
export function delRule(data) {
  return request({
    url: '/risk/deleteRiskRule',
    method: 'post',
    data,
  })
}
