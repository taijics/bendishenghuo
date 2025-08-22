import { initStore, UserStoreEnum } from './state'

/**
 * @typedef {import('./state').UserState} UserState
 */

export const mutations = {
  /**
   * @param {UserState} state 
   */
  [UserStoreEnum.RESET_USER] (state) {
    Object.assign(state, initStore())
  },
  /**
   * @param {UserState} state 
   * @param {string} token 
   */
  [UserStoreEnum.TOKEN] (state, token) {
    state.token = token
  },
  /**
   * @param {UserState} state 
   * @param {string} name 
   */
  [UserStoreEnum.NAME] (state, name) {
    state.name = name
  },
  /**
   * @param {UserState} state 
   * @param {string} avatar 
   */
  [UserStoreEnum.AVATAR] (state, avatar) {
    state.avatar = avatar
  },
}