import Vue from 'vue'
import Router from 'vue-router'
import layout from '@/views/layout'
import index from '@/views/home/index'
import custom from '@/views/custom/index'

// 用户中心中心
import userCenter from '@/views/userCenter/userCenter'
// import changePwd from '@/views/userCenter/changeInfo/changePwd'
// import unbindPhone from '@/views/userCenter/changeInfo/unbindPhone'

// const error = (resolve) => {
//   import('@/components/error/error').then((module) => {
//     resolve(module)
//   })
// }
Vue.use(Router)

const router = new Router({
  routes: [
    {
      path: '/',
      name: 'layout',
      component: layout,
      redirect: { name: 'index' },
      children: [
        // 首页
        {
          path: '/index',
          name: 'index',
          component: index,
          meta: {
            logoText: '',
            searchVisible: false
          }
        },
        // 自定义页面
        {
          path: '/custom',
          name: 'custom',
          component: custom,
          meta: {
            logoText: '',
            searchVisible: true
          }
        },
        // 用户中心
        {
          path: '/userCenter',
          name: 'userCenter',
          component: userCenter,
          meta: {
            logoText: '',
            searchVisible: false
          },
          children: [
            // 优惠券商品
            {
              path: '/couponPackage',
              name: 'couponPackage',
              component: () => import('@/views/userCenter/couponPackage/couponPackage'),
              meta: {
                logoText: '',
                searchVisible: false
              }
            },
            // 订单中心
            {
              path: '/myOrder',
              name: 'myOrder',
              component: () => import('@/views/userCenter/myOrder/myOrder'),
              meta: {
                logoText: '',
                searchVisible: false
              }
            },
            // 售后订单
            {
              path: '/orderAfterSale',
              name: 'orderAfterSale',
              component: () => import('@/views/userCenter/orderAfterSale/orderAfterSale'),
              meta: {
                logoText: '',
                searchVisible: false
              }
            },
            // 地址
            {
              path: '/signingAddress',
              name: 'signingAddress',
              component: () => import('@/views/userCenter/signingAddress/signingAddress'),
              meta: {
                logoText: '',
                searchVisible: false
              }
            },
            // 用户信息
            {
              path: '/userInfo',
              name: 'userInfo',
              component: () => import('@/views/userCenter/userInfo/userInfo'),
              meta: {
                logoText: '',
                searchVisible: false
              }
            },
            // 更换手机号
            {
              path: '/changePhone',
              name: 'changePhone',
              component: () => import('@/views/userCenter/changeInfo/changePhone'),
              meta: {
                logoText: '',
                searchVisible: false
              }
            },
            // 评论
            {
              path: '/myEvaluate',
              name: 'myEvaluate',
              component: () => import('@/views/userCenter/myEvaluate/index'),
              meta: {
                logoText: '',
                searchVisible: false
              }
            },
            {
              path: '/browseRecords',
              name: 'browseRecords',
              component: () => import('@/views/userCenter/browseRecords/browseRecords'),
              meta: {
                logoText: '',
                searchVisible: false
              }
            },
            {
              path: '/favorites',
              name: 'favorites',
              component: () => import('@/views/userCenter/favorites/favorites'),
              meta: {
                logoText: '',
                searchVisible: false
              }
            },
            {
              path: '/message',
              name: 'message',
              component: () => import('@/views/userCenter/messageCenter/message'),
              meta: {
                logoText: '',
                searchVisible: false
              }
            },
            {
              path: '/qaList',
              name: 'qaList',
              component: () => import('@/views/userCenter/messageCenter/qalist'),
              meta: {
                logoText: '',
                searchVisible: false
              }
            }
            // {
            //   path: '/changePwd',
            //   name: 'changePwd',
            //   component: changePwd,
            //   meta: {
            //     logoText: '',
            //     searchVisible: false
            //   }
            // },
            // {
            //   path: '/unbindPhone',
            //   name: 'unbindPhone',
            //   component: unbindPhone,
            //   meta: {
            //     logoText: '',
            //     searchVisible: false
            //   }
            // }
          ]
        },
        // 活动页面
        {
          path: '/activity',
          name: 'activity',
          component: () => import('@/views/home/activity.vue'),
          meta: {
            logoText: '',
            searchVisible: true
          },
          children: [
            // 搜索
            {
              path: '/activity/search',
              name: 'search',
              component: () => import('@/views/search/index'),
              meta: {
                logoText: '',
                searchVisible: false,
                hiddenLogo: true
              }
            },
            // 分类页面
            {
              path: '/activity/category',
              name: 'category',
              component: () => import('@/views/category/index'),
              meta: {
                logoText: '',
                searchVisible: false,
                hiddenLogo: true
              }
            },
            // 优惠券商品
            {
              path: '/activity/couponProList',
              name: 'couponProList',
              component: () => import('@/views/promotions/couponProlist/index.vue'),
              meta: {
                logoText: '',
                searchVisible: false,
                hiddenLogo: true
              }
            },
            // 类别商品
            {
              path: '/canvasGoods',
              name: 'canvasGoods',
              component: () => import('@/views/canvasGoods/index'),
              meta: {
                logoText: '',
                searchVisible: false,
                hiddenLogo: true
              }
            },
            // 秒杀专区
            {
              path: '/activity/rabatt',
              name: 'rabatt',
              component: () => import('@/views/promotions/rabatt/index.vue'),
              meta: {
                logoText: '',
                searchVisible: false,
                hiddenLogo: true
              }
            },
            // 折扣专区
            {
              path: '/activity/spitze',
              name: 'spitze',
              component: () => import('@/views/promotions/spitze/index.vue'),
              meta: {
                logoText: '',
                searchVisible: false,
                hiddenLogo: true
              }
            },
            // 团购
            {
              path: '/activity/groupBuy',
              name: 'groupBuy',
              component: () => import('@/views/promotions/groupBuy/index.vue'),
              meta: {
                logoText: '',
                searchVisible: false,
                hiddenLogo: true
              }
            },
            // 领取优惠券
            {
              path: '/activity/coupon',
              name: 'coupon',
              component: () => import('@/views/promotions/coupon/index.vue'),
              meta: {
                logoText: '',
                searchVisible: false,
                hiddenLogo: true
              }
            },
            // vip专区
            {
              path: '/activity/vip',
              name: 'vip',
              component: () => import('@/views/promotions/vip/index.vue'),
              meta: {
                logoText: '',
                searchVisible: false,
                hiddenLogo: true
              }
            },
            // 组合捆绑
            {
              path: '/activity/bind',
              name: 'Bind',
              component: () => import('@/views/promotions/bind/index.vue'),
              meta: {
                logoText: '',
                searchVisible: false,
                hiddenLogo: true
              }
            },
            // 公告
            {
              path: '/activity/notificationDetails',
              name: 'notificationDetails',
              component: () => import('@/views/userCenter/messageCenter/notificationDetails'),
              meta: {
                logoText: '',
                searchVisible: false,
                hiddenLogo: true
              }
            }
          ]
        },
        // 店铺主页
        {
          path: '/store',
          name: 'store',
          component: () => import('@/views/store/index'),
          meta: {
            logoText: '',
            searchVisible: true
          }
        },
        // 评价
        {
          path: '/evaluate',
          name: 'evaluate',
          component: () => import('@/views/evaluate/index'),
          meta: {
            logoText: '',
            searchVisible: true
          }
        },
        // 购物车
        {
          path: '/shopping-trolley',
          name: 'shoppingTrolley',
          component: () => import('@/views/shopping-trolley/index'),
          meta: {
            logoText: '',
            searchVisible: true
          }
        },
        // 订单详情
        {
          path: '/orderDetail',
          name: 'orderDetail',
          component: () => import('@/views/orderDetail/index'),
          meta: {
            logoText: '',
            searchVisible: false
          }
        },
        // 商品详情
        {
          path: '/productDetail',
          name: 'productDetail',
          component: () => import('@/views/product/productDetail'),
          meta: {
            logoText: '',
            searchVisible: true
          }
        },
        // 下单页面
        {
          path: '/placeOrder',
          name: 'placeOrder',
          component: () => import('@/views/placeOrder/index'),
          meta: {
            logoText: '收银台',
            searchVisible: true
          }
        },
        // 支付结果页面——支付有礼
        {
          path: '/orderResult',
          component: () => import('@/views/placeOrder/orderResult.vue'),
          meta: {
            searchVisible: true
          }
        },
        // 售后
        {
          path: '/afterSale',
          name: 'afterSale',
          component: () => import('@/views/afterSale/index'),
          meta: {
            logoText: '',
            searchVisible: true
          }
        },
        // 评价详情
        {
          path: '/evaluateDetail',
          name: 'evaluateDetail',
          component: () => import('@/views/evaluateDetail/index'),
          meta: {
            logoText: '',
            searchVisible: true
          }
        },
        // 追评
        {
          path: '/addEvaluate',
          name: 'addEvaluate',
          component: () => import('@/views/addEvaluate/index'),
          meta: {
            logoText: '',
            searchVisible: true
          }
        }
      ]
    }
  ]
})

const originalPush = Router.prototype.push
Router.prototype.push = function push (location) {
  return originalPush.call(this, location).catch(err => err)
}

router.beforeEach((to, from, next) => {
  // cookie没有值就跳到登陆页
  // let area = sessionStorage.getItem('area')
  // if (area === null && to.name !== 'login' && to.name !== 'overview') {
  //   // Vue.prototype.$message.error('用户未登陆')
  //   next('/login')
  // } else {
  next()
  // }
})

export default router
