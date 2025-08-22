import request from '@/utils/request'

const API = {
  GET_ALL: '/channel/getAll',
  ADD: '/channel/save',
  EDIT: '/channel/update',
  DELETE: '/channel/delete',
}

export function getList(data) {
  return request({
    url: API.GET_ALL,
    method: 'POST',
    data,
  })
}

export function add(data) {
  return request({
    url: API.ADD,
    method: 'POST',
    data,
  })
}

export function edit(data) {
  return request({
    url: API.EDIT,
    method: 'POST',
    data,
  })
}

export function del(data) {
  return request({
    url: API.DELETE,
    method: 'POST',
    data,
  })
}
