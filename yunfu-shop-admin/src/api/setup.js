import request from '@/utils/request'

// *************用户管理*************
// 用户管理查询
export function getList(data) {
  return request({
    url: '/user/getAll',
    method: 'post',
    data
  })
}

// 新增账户
export function userAdd(data) {
  return request({
    url: '/user/save',
    method: 'post',
    data
  })
}

// 用户编辑查询
export function userGetById(data) {
  return request({
    url: '/user/getById',
    method: 'post',
    data
  })
}
// 修改账户
export function userUpdate(data) {
  return request({
    url: '/user/update',
    method: 'post',
    data
  })
}
// 删除账户
export function userDelete(data) {
  return request({
    url: '/user/delete',
    method: 'post',
    data
  })
}

// *************角色管理*************
// 角色管理查询
export function roleGetall(data) {
  return request({
    url: '/role/getAll',
    method: 'post',
    data
  })
}

// 新增角色
export function roleAdd(data) {
  return request({
    url: '/role/save',
    method: 'post',
    data
  })
}
// 编辑角色
export function roleUpdate(data) {
  return request({
    url: '/role/update',
    method: 'post',
    data
  })
}
// 角色详情查询
export function roleGetById(data) {
  return request({
    url: '/role/getById',
    method: 'post',
    data
  })
}
// 删除角色
export function roleDelete(data) {
  return request({
    url: '/role/delete',
    method: 'post',
    data
  })
}

// 菜单分配查询
export function getRolePermission(data) {
  return request({
    url: '/role/getRolePermission',
    method: 'post',
    data
  })
}

// 菜单分配
export function distribution(data) {
  return request({
    url: '/role/distribution',
    method: 'post',
    data
  })
}

// *************菜单管理*************
// 权限管理查询
export function tabsGetAll(data) {
  return request({
    url: '/permission/getAll',
    method: 'post',
    data
  })
}
// 添加菜单
export function tabsAdd(data) {
  return request({
    url: '/permission/save',
    method: 'post',
    data
  })
}
// 编辑菜单查询
export function tabsGetById(data) {
  return request({
    url: '/permission/getById',
    method: 'post',
    data
  })
}
// 查询当前最大排序值
export function getMaxSort(data) {
  return request({
    url: '/permission/getMaxSort',
    method: 'post',
    data
  })
}
// 编辑菜单
export function tabsUpdate(data) {
  return request({
    url: '/permission/update',
    method: 'post',
    data
  })
}
// 删除菜单
export function tabsDelete(data) {
  return request({
    url: '/permission/delete',
    method: 'post',
    data
  })
}

// *************字典管理*************
// 字典管理查询
export function dictGetAll(data) {
  return request({
    url: '/dict/getAll',
    method: 'post',
    data
  })
}

// 新增字典
export function dictAdd(data) {
  return request({
    url: '/dict/save',
    method: 'post',
    data
  })
}

// 字典编辑查询
export function dictGetById(data) {
  return request({
    url: '/dict/getById',
    method: 'post',
    data
  })
}
// 修改字典
export function dictUpdate(data) {
  return request({
    url: '/dict/update',
    method: 'post',
    data
  })
}

// 根据父节点id查询子级字典数据
export function dictGetChilds(data) {
  return request({
    url: '/dict/getChilds',
    method: 'post',
    data
  })
}
// 根据父节点id查询子级字典数据
export function dictDelete(data) {
  return request({
    url: '/dict/delete',
    method: 'post',
    data
  })
}
