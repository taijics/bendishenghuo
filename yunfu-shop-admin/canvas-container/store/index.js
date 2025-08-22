import Vue from 'vue'
import Vuex from 'vuex'
import * as getters from './getter'
import state from './state'
import mutations from './mutations'
Vue.use(Vuex)

console.log({
  getters,
  state,
  mutations
})
export default new Vuex.Store({
  getters,
  state,
  mutations
})
