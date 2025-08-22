/**
 * @FileDescription:
 * @Author: kahu
 * @Date: 2022/11/3
 * @LastEditors: kahu
 * @LastEditTime: 2022/11/3
 */
/**
 * 跳转非tabbar页面
 * @param url 路径
 * @param param 参数对象
 * @param timeout 延时时间，默认0
 * @param type default普通跳转 redirect关闭当前页面跳转  reLaunch关闭所有页面跳转 默认default
 */
export const jump = (url, param, timeout = 0, type = "default") => {
    setTimeout(() => {
        if (param) {
            url = `${url}?detail=${encodeURIComponent(JSON.stringify(param))}`
        }
        if (type === 'default') {
            uni.navigateTo({url})
        } else if (type === 'redirect') {
            uni.redirectTo({url})
        } else {
            uni.reLaunch({url})
        }
    }, timeout)
}

/**
 * 跳转到tabbar页面
 * @param url 路径
 * @param timeout 延时时间，默认0
 */
export const jumpToTabbar = (url, timeout = 0) => {
    setTimeout(() => {
        uni.switchTab({url})
    }, timeout)
}

/**
 * 关闭当前页面，返回上一级或者多级页面
 * @param delta 级数，默认1
 */
export const goBack = (delta = 1) => {
    uni.navigateBack({delta})
}

/**
 * 获取跳转参数
 * @param loadParam
 * @return {{}|any}
 */
export const getJumpParam = (loadParam) => {
    if (typeof loadParam === "object" && loadParam?.detail) {
        let data = loadParam.detail
        // #ifdef H5
        if(data.indexOf('%') > -1) { // 如果url中存在 '%'
            data = data.replace(/%/g, '%25'); // 进行替换操作
        }
       // #endif
        return JSON.parse(decodeURIComponent(data))
    }
    return {}
}
