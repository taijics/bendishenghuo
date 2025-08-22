export function formateIdInfo (res) {
  let status = res.state
  let type = 0
  if (res.collageId) {
    type = 1
    status = res.collageDetail.state
  }
  if (res.afterState) {
    type = 3
    status = parseInt(res.afterState)
    // if (res.orderState === 5) {
    //   status = 9
    // }
  }
  return {
    id: res.orderId || 0,
    orderId: res.orderFormid || '',
    payment: res.paymentState,
    resetTime: res.time || '',
    type,
    status
  }
}
// 1-待付款 2-待发货 3-待收货 4-已完成 5-已关闭
export function formateStatusInfo (res) {
  let status = res.state
  let type = 0
  if (res.collageId) {
    type = 1 // 拼团
    status = parseInt(res.collageDetail.state)
    if (res.collageDetail.state === 1) {
      status = parseInt(res.state)
    }
    if (res.collageDetail.state === 2) {
      status = 1.5 // 拼团失败
    }
  }
  if (res.afterState) {
    type = 3 // 售后
    status = parseInt(res.afterState)
    // if (res.orderState === 5) {
    //   status = 9
    // }
    return {
      afterType: res.afterType,
      isPay: false,
      type,
      status
    }
  }
  return {
    isPay: false,
    type,
    status
  }
}
export function formatePinInfo (res) {}
export function formateExpressInfo (res) {
  if (res.afterState) {
    return {
      receiveName: res.returnPerson || '',
      receivePhone: res.returnPhone || '',
      receiveAdress: res.returnAdress || '',
      address: res.address || '',
      shopName: res.shopName || '',
      chargePersonPhone: res.shopPhone || '',
      type: 3
    }
  }
  return {
    receiveName: res.receiveName || '',
    receivePhone: res.receivePhone || '',
    receiveAdress: res.receiveAdress || '',
    address: res.address || '',
    shopName: res.shopName || '',
    chargePersonPhone: res.chargePersonPhone || ''
  }
}
export function formateAddressInfo (res) {}
export function formateOrderInfo (res) {
  return {
    orderId: res.orderFormid,
    des: res.remark,
    createTime: res.createTime,
    deliverFormid: res.deliverFormid,
    express: res.express
  }
}
export function formateProductInfo (res) {}
export function formatePayInfo (res) {
  return {
    total: res.orderPrice || 0,
    expressPrice: res.logisticsPrice || 0,
    discount: res.discountPrice || 0,
    payPrice: res.price,
    paymentState: res.paymentState
  }
}
export function formateASInfo (res) {
  if (!res.afterState || !res.afterId) {
    return res
  }
  return {
    type: res.afterType,
    goodsState: res.goodsState,
    returnReason: res.returnReason,
    explain: res.explain,
    image: res.images
  }
}
export function formateASEasonInfo (res) {}
export function formateASExpressInfo (res) {}
