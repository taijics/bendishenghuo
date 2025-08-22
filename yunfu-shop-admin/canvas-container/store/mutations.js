import * as types from './mutation-types'
import {
  SET_COUPONNUM,
  SET_DISCOUNTNUM,
  SET_GROUPNUM,
  SET_NEWPRODUCTNUM,
  SET_PRICENUM,
  SET_PRODUCTNUM, SET_SPIKENUM, SET_VIPNUM
} from "./mutation-types";
import {couponNum, discountNum, groupNum, newProductNum, priceNum, productNum, spikeNum, vipNum} from "./getter";

const mutations = {
  [types.SET_TERMINAL] (state, terminal) {
    state.terminal = terminal
  },
  [types.SET_ACTIVECOMPONENT] (state, activeComponent) {
    state.activeComponent = activeComponent
  },
  [types.SET_COMPONENTSDATA] (state, componentsData) {
    state.componentsData = componentsData
  },
  [types.SET_TYPEID] (state, typeId) {
    state.typeId = typeId
  },
  [types.SET_COUPONNUM] (state) {
    state.couponNum = state.couponNum + 1
  },
  [types.SET_DISCOUNTNUM] (state) {
    state.discountNum = state.discountNum + 1
  },
  [types.SET_GROUPNUM] (state) {
    state.groupNum = state.groupNum + 1
  },
  [types.SET_NEWPRODUCTNUM] (state) {
    state.newProductNum = state.newProductNum + 1
  },
  [types.SET_PRICENUM] (state) {
    state.priceNum = state.priceNum + 1
  },
  [types.SET_PRODUCTNUM] (state) {
    state.productNum = state.productNum + 1
  },
  [types.SET_SPIKENUM] (state) {
    state.spikeNum = state.spikeNum + 1
  }
}

export default mutations
