/**
 * 渠道活动相关API
 */
import request from '@/utils/request'

const API = {
  GET_ALL: '/shopChannelActivity/getAll',
  GET_BY_ID: '/shopChannelActivity/getById',
  GET_COUPON_BY_ACTIVITY_ID: '/shopChannelActivity/selectChannelCouponByActivityId',
  ADD: '/shopChannelActivity/save',
  UPDATE: '/shopChannelActivity/update',
  DELETE: '/shopChannelActivity/delete'
}

/**
 * 获取所有渠道活动
 * @param data {{page:number,pageSize:number}}
 * @returns {Promise}
 */
export function getAll(data) {
  return request({
    url: API.GET_ALL,
    method: 'POST',
    data
  })
}

/**
 * 根据活动ID获取活动详情
 * @param data {{id:number|string}}
 * @returns {*}
 */
export function getById(data) {
  return request({
    url: API.GET_BY_ID,
    method: 'POST',
    data
  })
}

/**
 * 根据活动ID获取渠道券列表
 * @param data {{channelActivityId: null, pageSize: number, page: number}}
 * @returns {*}
 */
export function getCouponsByActivityId(data) {
  return request({
    url: API.GET_COUPON_BY_ACTIVITY_ID,
    method: 'POST',
    data
  })
}

/**
 * 新增活动
 * @param data {{couponList: [], activityName: null, remark: null, startTime: null, id: null, endTime: null, publishCount: null}}
 * @returns {*}
 */
export function add(data) {
  return request({
    url: API.ADD,
    method: 'POST',
    data
  })
}

/**
 * 修改活动
 * @param data {{couponList: [], activityName: null, remark: null, startTime: null, id: null, endTime: null, publishCount: null}}
 * @returns {*}
 */
export function edit(data) {
  return request({
    url: API.UPDATE,
    method: 'POST',
    data
  })
}

/**
 * 删除活动
 * @param data {{id:number|string}}
 * @returns {*}
 */
export function del(data) {
  return request({
    url: API.DELETE,
    method: 'POST',
    data
  })
}
