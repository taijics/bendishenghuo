// const NET = require("./request");
// const API = require("../config/api");
import {request} from "./request";
import API from "../config/api";

/**
 * @FileDescription:客服相关函数
 * @Author: kahu
 * @Date: 2022/11/4
 * @LastEditors: kahu
 * @LastEditTime: 2022/11/4
 */

export function Services(shopId) {
    let corpId = null, serviceURL = null

    const getServiceUrl = async () => {
        uni.showLoading({
            title:'加载中...'
        })
        const shopIds = uni.getStorageSync('service_shopids') || []
        const corpIds = uni.getStorageSync('service_corpIds') || []
        const urls = uni.getStorageSync('service_urls') || []
        let params = shopId?{id:shopId}:{}
        try {
            const res = await request(API.CustomerService, params, 'get')
            if (res.code === '' && res.data.corpId && res.data.url) {
                shopIds.push(shopId)
                corpIds.push(res.data.corpId)
                urls.push(res.data.url)
                uni.setStorageSync('service_shopids', shopIds);
                uni.setStorageSync('service_corpIds', corpIds);
                uni.setStorageSync('service_urls', urls);
                corpId = res.data.corpId
                serviceURL = res.data.url
            }
        } finally {
            uni.hideLoading()
        }
    }

    const flyToService = ()=>{
        if (!serviceURL || !corpId) {
            return uni.showToast({
                icon:'none',
                title:'暂无客服~'
            })
        }
        // #ifdef MP-WEIXIN
        wx.openCustomerServiceChat({
            extInfo: {
                url: serviceURL
            },
            corpId: corpId
        })
        // #endif
        // #ifdef APP-PLUS
        try {
            let wechatServices = null
            plus.share.getServices(res => {
                wechatServices = res.find(wechatItem => wechatItem.id === 'weixin')
                if (wechatServices) {
                    wechatServices.openCustomerServiceChat({
                        corpid: corpId,
                        url: serviceURL,
                    }, success => {
                        console.log("success", JSON.stringify(success))
                    }, err => {
                        console.log("error", JSON.stringify(err))
                    })
                } else {
                    plus.nativeUI.alert('当前环境不支持微信操作!')
                }
            },  err=>{
                console.log(err)
                uni.showToast({title: "获取服务失败，不支持该操作。" + JSON.stringify(err), icon: 'none'})
            })
        } catch (err) {
            uni.showToast({title: "调用失败，不支持该操作。" + JSON.stringify(err), icon: 'none'})
            throw Error(err)
        }
        // #endif
        // #ifdef H5
        // window.open(serviceURL) safari浏览器不支持window.open
        window.location.href = serviceURL
        // #endif
    }


    return  getServiceUrl().then(res=>{
        return {
            flyToService
        }
    })

}
