/**
 * @FileDescription:订单模块config
 * @Author: kahu
 * @Date: 2022/11/18
 * @LastEditors: kahu
 * @LastEditTime: 2022/11/18
 */
export const orderTypeEnum = {
    1:'待付款',
    2:'待发货',
    3:'待收货',
    4:'已完成',
    5:'交易关闭',
    6:'待成团'
}

export const orderTabList = [{
    name: '全部',
    number: 0
}, {
    name: '待付款',
    number: 1
}, {
    name: '待发货',
    number: 2
}, {
    name: '待收货',
    number: 3
}, {
    name: '待评价',
    number: 4
}, {
    name: '待成团',
    number: 6
}]
