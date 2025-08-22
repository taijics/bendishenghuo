/**
 * @typedef {import('./state').UserState} UserState
 */

import { UserStoreEnum } from './state';

export const getters = {
  /**
   * @param {UserState} state 
   * @returns 
   */
  [UserStoreEnum.TOKEN] (state) {
    return state.token
  },
  /**
   * @param {UserState} state 
   * @returns 
   */
  [UserStoreEnum.NAME] (state) {
    return state.name
  },
  /**
   * @param {UserState} state 
   * @returns 
   */
  [UserStoreEnum.AVATAR] (state) {
    return state.avatar
  }
}