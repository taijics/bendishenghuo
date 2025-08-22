import {
  getToken
} from '@/utils/auth'

export function initStore () {
  return {
    token: getToken(),
    name: '',
    avatar: '',
  }
}

/**
 * user state类型
 * @typedef UserState
 * @type {object}
 * @property {string} token
 * @property {string} name 用户名
 * @property {string} avatar 用户头像
 */
export const state = initStore();

/**
 * user模块 mutations/getters映射
 * @enum
 * @property {string} UserStoreEnum.TOKEN
 * @property {string} UserStoreEnum.NAME 用户名
 * @property {string} UserStoreEnum.AVATAR 评价订单
 */
export const UserStoreEnum = {
  RESET_USER: 'RESET_USER',
  TOKEN: 'TOEKN',
  NAME: 'NAME',
  AVATAR: 'AVATAR',
}

/**
 * user模块 actions映射
 * @enum
 * @property {string} UserActionEnum.LOGIN
 * @property {string} UserActionEnum.LOGOUT
 * @property {string} UserActionEnum.RESET_PASSWORD
 * @property {string} UserActionEnum.RESET_TOKEN
 */
export const UserActionEnum = {
  LOGIN: 'LOGIN',
  LOGOUT: 'LOGOUT',
  RESET_PASSWORD: 'RESET_PASSWORD',
  RESET_TOKEN: 'RESET_TOKEN',
}