import request from '@/utils/request'

// ******积分管理******
// 积分签到配置
export function creditSignGetAll(data) {
  return request({
    url: '/creditSignSetting/getAll',
    method: 'post',
    data,
  })
}

// 新增积分签到配置
export function creditSignSave(data) {
  return request({
    url: '/creditSignSetting/save',
    method: 'post',
    data,
  })
}

// 修改积分签到配置
export function creditSignUpdate(data) {
  return request({
    url: '/creditSignSetting/update',
    method: 'post',
    data,
  })
}

// 删除积分签到配置
export function deleteCreditSign(data) {
  return request({
    url: '/creditSignSetting/delete',
    method: 'post',
    data,
  })
}

// 积分记录
export function recordGetAll(data) {
  return request({
    url: '/creditRecord/getAll',
    method: 'post',
    data,
  })
}
