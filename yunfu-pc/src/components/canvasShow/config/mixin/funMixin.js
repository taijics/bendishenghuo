import {
  takeCoupon
} from '../api'
import router from '@/router'
import {sendReq} from './sendReqMixin'
import { mapMutations } from 'vuex'
import canvasConfig from '../config'
import Cookie from 'js-cookie'
import Cookies from 'js-cookie'
/*
 * 公共方法的 mixin
 */
export const tool = {
  mixins: [sendReq],
  props: {
    isNoData: {
      type: Boolean,
      default: false
    },
    comType: {
      type: String,
      default: ''
    }
  },
  methods: {
    ...mapMutations({
      setCurrentPro: 'SET_CURRENTPRO'
    }),
    // 判断url
    jumpLink (linkObj) {
      var link = ''
      if(linkObj && linkObj.typeText && linkObj.data){
        switch (linkObj.typeText) {
          case '类别':
            router.push({name:'category',query:{classifyData:JSON.stringify(linkObj.data)}})
            break
          case '店辅':
            router.push({
              path: '/store',
              query: {shopId: linkObj.data.shopId}
            });
            break
          case '商品':
            // this.setCurrentPro(linkObj.data)
            // router.push("/productDetail");
            let data = {
              productId: linkObj.data.productId,
              skuId: linkObj.data.skuId,
              shopId: linkObj.data.shopId
            }
            router.push({
              path: "/productDetail",
              query: {
                proData: JSON.stringify(data)
              }
            })
            break
          case '自定义':
            // router.push("/activity/category");
            break
        }
      } else if(linkObj.selsectValue==='/index'){
        router.push("/index");
      }
      return link
    },
    // 跳转到类别主页
    jumpCategory(item){
      router.push({name:'category',query:{classifyData:JSON.stringify(item)}})
    },
    // 跳转到店铺主页
    jumpStore(item){
      router.push({
        path: '/store',
        query: {shopId: item.shopId}
      });
    },
    // 跳转到产品详细
    jumpProductDetail(item){
      let data = {
        productId: item.productId,
        skuId: item.skuId,
        shopId: item.shopId
      }
      router.push({
        path: "/productDetail",
        query: {
          proData: JSON.stringify(data)
        }
      });
    },
    // 跳转到秒杀专区
    jumpSeckills(item,ids){
      if(item.shopId){
        router.push({
          path: '/activity/rabatt',
          query: {shopId: item.shopId,ids:ids}
        });
      } else {
        router.push({
          path: '/activity/rabatt',
          query: {id:item.seckillId}
        });
      }
    },
    // 跳转到拼团专区
    jumpGroupWorks(item){
      if(item.shopId){
        router.push({
          path: '/activity/groupBuy',
          query: {shopId: item.shopId,id:item.shopGroupWorkId}
        });
      } else {
        router.push({
          path: '/activity/groupBuy',
          query: {id:item.groupWorkId}
        });
      }

    },
    // 跳转到折扣列表
    jumpDiscount(item){
      if(item.shopId){
        router.push({
          path: '/activity/spitze',
          query: {shopId: item.shopId,id:item.shopDiscountId}
        });
      } else {
        router.push({
          path: '/activity/spitze',
          query: {id:item.discountId}
        });
      }

    },
    // 跳转到会员专区
    jumpVip(){
      router.push({
        path: '/activity/vip'
      });
    },
    // 定价捆绑跳转
    jumpPice(id) {
      router.push({
        path: '/activity/bind',
        query: {
          shopId: id
        }
      });
    },
    // 跳转到公告详情
    jumpNoticeDetail(item){
      this.$router.push({
        path: '/activity/notificationDetails',
        query: {
          id: item.noticeId
        }
      })
    },
    // 跳转到画布产品列表
    jumpProList(item) {
      if(item.sourceType === '1'){
        router.push({
          path: '/canvasGoods',
          query: {
            sourceType: item.sourceType,
            ids: item.productIdList.join(",")
          }
        });
      } else if(item.sourceType === '2'){
        router.push({
          path: '/canvasGoods',
          query: {
            sourceType: item.sourceType,
            classifyId: item.categoryId
          }
        });
      }

    },
    // 查询产品
    searchPro (key,type) {
      if (this.$route.name !== 'search') {
        this.$router.push({
          path: '/search',
          query: {
            keyword: key,
            searchVal: type
          }
        })
      } else {
        this.$emit('search', this.keyword, this.searchVal)
      }
    },
    // 领取优惠券
    async receiveCoupon(item) {
      var key = Cookies.get(canvasConfig.tokenKey)
      if (key) {
        var paramsData = {}
        if(this.typeId === 1){
          paramsData.couponId = item.couponId
        } else if(this.typeId === 3) {
          paramsData.shopCouponId = item.shopCouponId
          paramsData.shopId = this.shopId
        }
        const response = await takeCoupon(paramsData)
        const res = response.data
        this.$message({
          message: '领取成功！',
          type: 'success'
        })
        this.getData()
      } else {
        this.$message({
          message: '请先登录'
        })
        // 登录弹框
        store.commit('IS_LOGIN', false) // 清除顶部个人中心数据
        store.commit('SHOW_LOGIN') // 调用登录弹框
      }
    },
    // 加入购物车
    addCart(id){
      console.log(id)
    }
  }
}
