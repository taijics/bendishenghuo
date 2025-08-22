import request from '@/utils/request'

// 发送二次隐私认证验证码
export function getPrivacyCode(data) {
    return request({
        url: 'user/getPrivacyCode',
        method: 'post',
        data
    })
}

// 填写验证码点击确认
export function verifyPrivacyCode(data) {
    return request({
        url: 'user/verifyPrivacyCode',
        method: 'post',
        data
    })
}

// 获取管理员手机号
export function getAdminPhone(data) {
    return request({
        url: 'user/getAdminPhone',
        method: 'post',
        data
    })
}

// 获取旧手机号
export function getCurrentUserPhone(data) {
    return request({
        url: 'user/getCurrentUserPhone',
        method: 'post',
        data
    })
}

// 发送修改管理员手机号验证码
export function getUpdatePhoneCode(data) {
    return request({
        url: 'user/getUpdatePhoneCode',
        method: 'post',
        data
    })
}

// 修改管理员手机号
export function updatePhone(data) {
    return request({
        url: 'user/updatePhone',
        method: 'post',
        data
    })
}

// 是否24小时内验证了
export function getPrivacySwitch(data) {
    return request({
        url: 'user/getPrivacySwitch',
        method: 'post',
        data
    })
}