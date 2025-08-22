/**
 * @FileDescription:我的页面相关对象
 * @Author: kahu
 * @Date: 2022/11/4
 * @LastEditors: kahu
 * @LastEditTime: 2022/11/4
 */
import {VUE_APP_STATIC_URL} from "../../../config/api";
export const orderCardList = [
    {
        id:1,
        label:'待付款',
        key:'waitPayOrderCount',
        icon:`${VUE_APP_STATIC_URL}static/img/user/daifukuan1.png`,
        jumpUrl:'../../../pages_category_page1/orderModule/index?type=1'
    },
    {
        id:2,
        label:'待发货',
        key:'waitSendOrderCount',
        icon:`${VUE_APP_STATIC_URL}static/img/user/daifahuo1.png`,
        jumpUrl:'../../../pages_category_page1/orderModule/index?type=2'
    },
    {
        id:3,
        label:'待收货',
        key:'waitReceiveOrderCount',
        icon:`${VUE_APP_STATIC_URL}static/img/user/daishouhuo.png`,
        jumpUrl:'../../../pages_category_page1/orderModule/index?type=3'
    },
    {
        id:4,
        label:'全部订单',
        key:'',
        icon:`${VUE_APP_STATIC_URL}static/img/user/daifukuan1.png`,
        jumpUrl:'../../../pages_category_page1/orderModule/index'
    }
]

export const fastCardOneList = [
    {
        id:1,
        label:'我的收藏',
        icon:`${VUE_APP_STATIC_URL}static/img/user/mycollectionIcon.png`,
        jumpUrl:'../../../pages_category_page2/userModule/collection'
    },
    {
        id:2,
        label:'我的问答',
        icon:`${VUE_APP_STATIC_URL}static/img/user/myQuestionIcon.png`,
        jumpUrl:'../../../pages_category_page2/userModule/questionList'
    },
    {
        id:3,
        label:'浏览足迹',
        icon:`${VUE_APP_STATIC_URL}static/img/user/myfootprintIcon.png`,
        jumpUrl:'../../../pages_category_page2/userModule/footprintList'
    },
    {
        id:4,
        label:'我的评价',
        icon:`${VUE_APP_STATIC_URL}static/img/user/pingjia.png`,
        jumpUrl:'../../../pages_category_page1/goodsModule/userEvaluate'
    },
    {
        id:5,
        label:'我的账户',
        icon:`${VUE_APP_STATIC_URL}static/img/user/account.png`,
        jumpUrl:'../../../pages_category_page2/userModule/memberAccount'
    },
    {
        id:6,
        label:'我的卡券',
        icon:`${VUE_APP_STATIC_URL}static/img/user/kaquan.png`,
        jumpUrl:'../../../pages_category_page2/userModule/coupon'
    }, {
        id:7,
        label:'分销中心',
        icon:`${VUE_APP_STATIC_URL}static/img/user/fenxiao.png`,
        jumpUrl:'../../../pages_category_page1/distributionModule/index'
    },
    {
        id:8,
        label:'商家入驻',
        icon:`${VUE_APP_STATIC_URL}static/img/user/Settled.png`,
        jumpUrl:'function:handleApplySettle'
    }
]

export const fastCardTwoList = [
    {
        id:1,
        label:'地址管理',
        icon:`${VUE_APP_STATIC_URL}static/img/user/dizhi1.png`,
        jumpUrl:'../../../pages_category_page2/userModule/address'
    },
    {
        id:2,
        label:'我的售后',
        icon:`${VUE_APP_STATIC_URL}static/img/user/shouhou.png`,
        jumpUrl:'../../../pages_category_page2/orderModule/afterSale'
    },
    {
        id:3,
        label:'会员中心',
        icon:`${VUE_APP_STATIC_URL}static/img/user/VIP.png`,
        jumpUrl:'../../../pages_category_page1/memberCenter/index'
    },
    {
        id:4,
        label:'银行卡',
        icon:`${VUE_APP_STATIC_URL}static/img/user/kaquan.png`,
        jumpUrl:'../../../pages_category_page2/userModule/bankcard'
    },
    {
        id:5,
        label:'我的积分',
        icon:`${VUE_APP_STATIC_URL}static/img/user/myIntegral.png`,
        jumpUrl:'../../../pages_category_page1/integral/index'
    },
    {
        id:6,
        label:'签到',
        icon:`${VUE_APP_STATIC_URL}static/img/user/signIcon.png`,
        jumpUrl:'../../../pages_category_page1/integral/sign'
    }, {
        id:7,
        label:'优惠券',
        icon:`${VUE_APP_STATIC_URL}static/img/user/userCouponIcon.png`,
        jumpUrl:'../../../pages_category_page1/coupon/list'
    },
    {
        id:8,
        label:'平台客服',
        icon:`${VUE_APP_STATIC_URL}static/img/user/service.png`,
        jumpUrl:'function:flyToService'
    }
]
