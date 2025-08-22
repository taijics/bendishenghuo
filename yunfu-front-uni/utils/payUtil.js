/**
 * @FileDescription:
 * @Author: kahu
 * @Date: 2022/11/2
 * @LastEditors: kahu
 * @LastEditTime: 2022/11/2
 */
// const NET = require('./request')
// const API = require('../config/api')
import API from "@/config/api";
import { request } from "@/utils/request";
// #ifdef H5
// const jweixin = require('jweixin-module')
// import jweixin from 'jweixin-module'
/**
 * 普通H5处理
 * @param payInfo 结算返回的支付信息
 */
async function payH5InEquipment(payInfo) {
    try {
        const res = await request(API.gotoH5Pay, payInfo, 'POST')
        location.replace(res.data.mwebUrl)
    } catch (e) {
        this.submitActive = true
        uni.showToast({
            title: '支付失败',
            icon: 'none'
        })
        uni.navigateTo({
            url: '/pages_category_page1/orderModule/index?type=1'
        })
    } finally {
        uni.hideLoading()
    }
}

/**
 * 微信内H5处理
 * @param payInfo 结算返回的支付信息
 * @param orderId 订单ID
 */
async function payH5InWechat(payInfo) {
    payInfo.paymentMode = 1
    const res = await request(API.gotoPay, payInfo, 'POST')
    jweixin.config({
        debug: false, // 开启调试模式,调用的所有api的返回值会在客户端alert出来，若要查看传入的参数，可以在pc端打开，参数信息会通过log打出，仅在pc端时才会打印。
        appId: res.data.appId, // 必填，公众号的唯一标识
        timestamp: res.data.timeStamp, // 必填，生成签名的时间戳
        nonceStr: res.data.nonceStr, // 必填，生成签名的随机串
        signature: res.data.paySign, // 必填，签名，见附录1
        jsApiList: ['chooseWXPay'] // 必填，需要使用的JS接口列表，所有JS接口列表见附录2
    });
    jweixin.ready(function () {
        jweixin.checkJsApi({
            jsApiList: ['chooseWXPay'], // 需要检测的JS接口列表，所有JS接口列表见附录2,
            success: function (res) {
            },
            fail: function (res) {
            }
        });
        jweixin.chooseWXPay({
            timestamp: res.data
                .timeStamp, // 支付签名时间戳，注意微信jssdk中的所有使用timestamp字段均为小写。但最新版的支付后台生成签名使用的timeStamp字段名需大写其中的S字符
            nonceStr: res.data.nonceStr, // 支付签名随机串，不长于 32 位
            package: res.data
                .package, // 统一支付接口返回的prepay_id参数值，提交格式如：prepay_id=***）
            signType: res.data.signType, // 签名方式，默认为'SHA1'，使用新版支付需传入'MD5'
            paySign: res.data.paySign, // 支付签名
            success: function (res) {
                // 支付成功后的回调函数
                uni.showToast({
                    icon: 'none',
                    title: '支付成功'
                })
                uni.navigateTo({
                    url: '/pages_category_page1/orderModule/paySuccessful?orderId=' + payInfo.orderId
                })
            },
            cancel: function (r) {
                uni.showToast({
                    icon: 'none',
                    title: '用户取消支付'
                })
                uni.navigateTo({
                    url: '/pages_category_page1/orderModule/index?type=1'
                })
            },
            fail: function (res) {
                uni.showToast({
                    icon: 'none',
                    title: '微信内支付错误'
                })
                uni.navigateTo({
                    url: '/pages_category_page1/orderModule/index?type=1'
                })
            }
        });
    });
    jweixin.error(function (res) {
        uni.showToast({
            icon: 'none',
            title: '微信内支付加载失败',
            duration: 3000
        });
        uni.navigateTo({
            url: '/pages_category_page1/orderModule/index?type=1'
        })
    });
}

/**
 * H5拉起支付
 * @param payInfo 结算返回的支付信息
 */
async function h5Pay(payInfo) {
    let ua = navigator.userAgent.toLowerCase();
    if (ua.match(/MicroMessenger/i) == "micromessenger") {
        await payH5InWechat(payInfo)
    } else {
        await payH5InEquipment(payInfo)
    }
}

// #endif

// #ifdef MP-ALIPAY
/**
 * 支付宝小程序拉起支付
 * @param payInfo 结算返回的支付信息
 * @return {Promise<void>}
 */
async function aliPay(payInfo) {
    try {
        const res = await request(API.gotoPay, payInfo, 'POST')
        uni.requestPayment({
            provider: 'alipay',
            orderInfo: res.data.tradeNo,
            success: function (payRes) {
                if (payRes.resultCode == '6001') {
                    uni.showToast({
                        icon: 'none',
                        title: '取消支付'
                    })
                    uni.navigateTo({
                        url: '/pages_category_page1/orderModule/index?type=1'
                    })
                }
                if (payRes.resultCode == '9000') {
                    uni.showToast({
                        icon: 'none',
                        title: '支付成功'
                    })
                    uni.navigateTo({
                        url: '/pages_category_page1/orderModule/paySuccessful?orderId=' + orderId
                    })
                }
            },
            fail: function (err) {
                uni.showToast({
                    icon: 'none',
                    title: '支付取消'
                })
                uni.navigateTo({
                    url: '/pages_category_page1/orderModule/index?type=1'
                })
            }
        });
    } catch (e) {
        uni.showToast({
            title: '支付宝支付异常',
            icon: 'none'
        })
        uni.navigateTo({
            url: '/pages_category_page1/orderModule/index?type=1'
        })
    } finally {
        uni.hideLoading()
    }
}

// #endif

// #ifdef MP-WEIXIN
/**
 * 微信小程序拉起支付
 * @param payInfo
 * @return {Promise<void>}
 */
async function wechatPay(payInfo) {
    console.log('进入微信支付')
    try {
        const res = await request(API.gotoPay, payInfo, 'POST')
        uni.requestPayment({
            provider: 'wxpay',
            timeStamp: res.data.timeStamp,
            nonceStr: res.data.nonceStr,
            package: res.data.package,
            signType: res.data.signType,
            paySign: res.data.paySign,
            success: async (payRes) => {
                // 拼团微信支付成功回调
                if (payInfo.collageId) {
                    await request(API.paySuccess, {
                        orderId: payInfo.orderId,
                        collageId: payInfo.collageId
                    }, 'POST')
                }
                uni.showToast({
                    icon: 'none',
                    title: '支付成功'
                })
                //console.log(submitResult.orderId, 'order Id')
                uni.navigateTo({
                    url: '/pages_category_page1/orderModule/paySuccessful?orderId=' + payInfo.orderId
                })
            },
            fail: function (err) {
                uni.showToast({
                    icon: 'none',
                    title: '用户取消支付'
                })
                uni.navigateTo({
                    url: '/pages_category_page1/orderModule/index?type=1'
                })
            }
        })
    } catch (e) {
        uni.showToast({
            title: '微信支付拉起失败',
            icon: 'none'
        })
        uni.navigateTo({
            url: '/pages_category_page1/orderModule/index?type=1'
        })
    }
}

// #endif

// #ifdef APP-PLUS
/**
 * App拉起微信支付
 * @param payInfo
 * @return {Promise<void>}
 */
async function appWechatPay(payInfo) {
    try {
        const res = await request(API.gotoAppPay, payInfo, 'POST')
        const obj = {
            appid: res.data.appId,
            noncestr: res.data.nonceStr,
            package: 'Sign=WXPay',
            prepayid: res.data.prepayId,
            timestamp: res.data.timeStamp,
            sign: res.data.paySign,
            partnerid: res.data.partnerId
        }
        uni.requestPayment({
            provider: 'wxpay',
            orderInfo: obj,
            success: function (payRes) {
                uni.showToast({
                    icon: 'none',
                    title: '支付成功'
                })
                uni.navigateTo({
                    url: '/pages_category_page1/orderModule/paySuccessful?orderId=' + payInfo.orderId
                })
            },
            fail: function (err) {
                uni.showToast({
                    icon: 'none',
                    title: '用户取消支付'
                })
                uni.navigateTo({
                    url: '/pages_category_page1/orderModule/index?type=1'
                })
            }
        })
    } catch (e) {
        console.log(e)
        uni.showToast({
            title: 'APP拉起微信支付失败',
            icon: 'none'
        })
        uni.navigateTo({
            url: '/pages_category_page1/orderModule/index?type=1'
        })
    } finally {
        uni.hideLoading()
    }
}

// #endif

/**
 * 处理支付
 * @param submitResult 结算结果
 */
export async function handleDoPay(submitResult) {
    uni.showLoading({
        mask: true,
        title: '支付中...',
    })
    console.log('进入支付')
    const {paymentMode} = submitResult
    if (paymentMode === 1) {
        // 微信支付
        // #ifdef APP-PLUS
        await appWechatPay(submitResult)
        // #endif
        // #ifdef MP-WEIXIN
        console.log('进入微信支付')
        await wechatPay(submitResult)
        // #endif
        // #ifdef H5
        await h5Pay(submitResult)
        // #endif
    } else if ([2, 3].includes(paymentMode)) {
        // 支付宝
        // #ifdef MP-ALIPAY
        await aliPay(submitResult)
        // #endif
        // #ifndef MP-ALIPAY
        // await appWechatPay(submitResult,this.orderId)
        console.error("支付宝相关支付暂时只支持支付宝小程序")
        throw new Error('支付宝相关支付暂时只支持支付宝小程序')
        // #endif
    }
    setTimeout(()=>{
        uni.navigateTo({
            url: '/pages_category_page1/orderModule/index?type=2'
        })
    },1000)
    /*  uni.navigateTo({
          url: '/pages_category_page1/orderModule/index?type=2'
      })*/
    // uni.hideLoading()


}
