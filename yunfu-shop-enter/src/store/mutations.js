import * as types from './mutation-types'

const mutations = {
  [types.SET_MSEID] (state, mseId) {
    state.mseId = mseId
  },
  [types.SET_USERNAME] (state, name) {
    state.userName = name
  }
}

export default mutations
