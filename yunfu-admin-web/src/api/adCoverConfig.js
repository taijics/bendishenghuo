import request from '@/utils/request'

export function getList(query) {
  return request({
    url: '/mall/adCoverConfig',
    method: 'get',
    params: query,
  })
}

export function add(data) {
  return request({
    url: `mall/adCoverConfig`,
    method: 'post',
    data,
  })
}

export function del(ids) {
  return request({
    url: 'mall/adCoverConfig',
    method: 'delete',
    data: ids,
  })
}

export function edit(data) {
  return request({
    url: 'mall/adCoverConfig',
    method: 'put',
    data,
  })
}

export function publish(id) {
  return request({
    url: `mall/adCoverConfig/publish/${id}`,
    method: 'put',
  })
}

export function off(id) {
  return request({
    url: `mall/adCoverConfig/off/${id}`,
    method: 'put',
  })
}

export default { getList, del, add, edit, publish, off }
