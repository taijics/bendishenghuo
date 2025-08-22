import request from '@/utils/request';

/* ------内容分类------ */
export function classifyAdd(data) {
  return request({
    url: '/recommend/type/save',
    method: 'post',
    data,
  })
}

export function classifyEdit(data) {
  return request({
    url: '/recommend/type/update',
    method: 'post',
    data,
  })
}

export function classifyQuery(params) {
  return request({
    url: '/recommend/type/page',
    method: 'get',
    params,
  })
}

export function classifyDelete(params) {
  return request({
    url: '/recommend/type/delete',
    method: 'delete',
    params,
  })
}

/* ------种草动态管理------ */
export function contentQuery(params) {
  return request({
    url: 'recommend/trends/page',
    method: 'get',
    params
  })
}

export function contentInfo(params) {
  return request({
    url: 'recommend/trends/get',
    method: 'get',
    params
  })
}

export function contentDel(params) {
  return request({
    url: 'recommend/trends/delete',
    method: 'delete',
    params
  })
}
export function contentAudit(data) {
  return request({
    url: 'recommend/trends/review',
    method: 'post',
    data
  })
}

/* ------内容风控------ */
export function controlConfig(params) {
  return request({
    url: '/recommend/risk-control/set',
    method: 'get',
    params
  })
}

export function getControl() {
  return request({
    url: '/recommend/risk-control/get',
    method: 'get'
  })
}