import { request } from "@/utils/request";
import API from "@/config/api";
import {showLoading,hideLoading} from "@/utils/plugIn/globalLoading.js";

/**
 * 根据选中的购物车数据获取价格和过滤后的用于结算购物车的post数据
 * @param dataList
 * @return {Promise<{shopList: *[], money: number}>}
 */
export async function getPriceBySelect(dataList) {
    showLoading()
    let addCart = []
    // 遍历店铺，获取选中的sku组装数据
    for (let i = 0; i < dataList.length; i++) {
        let shopObj = {}
        const theCurrentShop = dataList[i]
        shopObj["shopId"] = theCurrentShop.shopId
        shopObj["skus"] = []
        for (let j = 0; j < theCurrentShop.skus.length; j++) {
            const theCurrentSku = dataList[i].skus[j]
            // 如果是选中的才往当前店铺塞
            if (theCurrentSku.selected) {
                let skusObj = {}
                skusObj["ifLogistics"] = theCurrentSku.ifLogistics
                skusObj["number"] = theCurrentSku.number
                skusObj["selected"] = theCurrentSku.selected
                skusObj["skuId"] = theCurrentSku.skuId
                shopObj.skus.push(skusObj)
            }
        }
        // 过滤掉sku为空的店铺
        if (shopObj.skus.length > 0) {
            addCart.push(shopObj)
        }
    }
    try {
        const postData = {
            type: 2,
            shops: addCart
        }
        const res = await request(API.Settlement, postData, 'POST')
        const money = res.data.shops.reduce((previousValue, currentValue) => (previousValue + currentValue.total), 0)
        return {
            money: money.toFixed(2),
            shopList: addCart
        }
    } finally {
        hideLoading()
    }
}

/**
 * 根据选中的购物车数据获取购物车数量
 * @param dataList
 * @return {Promise<{allNumber: number, isAllCheck: boolean}>}
 */
export async function getCartNumberBySelect(dataList) {
    let allNumber = 0, checkNumber = 0, isAllCheck = true
    // 遍历店铺
    for (let i = 0; i < dataList.length; i++) {
        // 当前店铺
        let shopObj = dataList[i]
        // 遍历店铺内部的商品
        for (let j = 0; j < shopObj.skus.length; j++) {
            let good = dataList[i].skus[j]
            allNumber += good.number
            if (good.selected === 1) {
                checkNumber += +good.number
            } else {
                // 如果商品没有选中，但是又勾选了全选
                if (isAllCheck) {
                    isAllCheck = false
                }
            }
        }
    }
    // 更新缓存
    uni.setStorageSync('allCartNum', allNumber)
    // 设置导航条
    if (allNumber > 0) {
        uni.setTabBarBadge({
            index: 3,
            text: (allNumber).toString()
        })
    } else {
        uni.removeTabBarBadge({
            index: 2
        })
    }
    return {
        allNumber, checkNumber, isAllCheck
    }
}

/**
 * 默认购物车，供骨架屏使用
 * @type {[{skus: [{image: string, number: number, productId: number, price: number, productName: string, selected: number},{image: string, number: number, productId: number, price: number, productName: string, selected: number},{image: string, number: number, productId: number, price: number, productName: string, selected: number}], shopName: string, shopId: number, selected: number}]}
 */
export const defaultCartList = []
