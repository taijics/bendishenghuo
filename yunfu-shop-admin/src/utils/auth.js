import Cookies from 'js-cookie'

const TokenKey = 'cereShopBussesToken'
const shopID = 'cereShopId'
const roleName = 'roleName'
const avatar = 'avatar'
const roleUserId = 'roleUserId'
const btns = 'buttonList'

export function getToken() {
  return Cookies.get(TokenKey)
}
export function getShopId() {
  return Cookies.get(shopID)
}
export function getUserId() {
  return Cookies.get(roleUserId)
}
export function getBtns() {
  return sessionStorage.getItem(btns)
}

export function setToken(token) {
  return Cookies.set(TokenKey, token)
}
export function setUserId(token) {
  return Cookies.set(roleUserId, token)
}
export function setShopId(id) {
  return Cookies.set(shopID, id)
}
export function setName(name) {
  return localStorage.setItem(roleName, name)
}
export function setAvatar(userAvatar) {
  return localStorage.setItem(avatar, userAvatar)
}
export function setBtns(name) {
  return sessionStorage.setItem(btns, name)
}

export function removeToken() {
  return Cookies.remove(TokenKey)
}
export function removeshopID() {
  return Cookies.remove(shopID)
}
export function removeUserId() {
  return Cookies.remove(roleUserId)
}

export function getBtnList() {
  const list = JSON.parse(getBtns())
  return list
}
