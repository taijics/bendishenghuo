import sendReqMixin from './sendReqMixin'

export default function () {
  const { sendReq } = sendReqMixin()
  // 判断url
  function jumpLink (linkObj) {
    var link = ''
    console.log(linkObj.data)
    if(linkObj && linkObj.typeText && linkObj.data){
      switch (linkObj.typeText) {
        case '类别':
          jumpCategory(linkObj.data)
          break
        case '店辅':
          jumpStore(linkObj.data)
          break
        case '商品':
          jumpProductDetail(linkObj.data)
          break
        case '自定义':
          // router.push("/category");
        case '公告':
          jumpNoticeDetail(linkObj.data)
          break
      }
    } else if(linkObj.selsectValue==='/index'){
      uni.navigateTo({
        url: `/pages/index/index`
      })
    }
    return link
  }
  // 跳转到类别主页
  function jumpCategory(item){
    uni.navigateTo({
      url: `/pages_category_page1/goodsModule/goodsList?category3Id=${item.id}&classifyLevel=${item.depth}`
    })
  }
  // 跳转到产品列表
  function jumpProList(item){
    if(item.sourceType === '1'){
      uni.navigateTo({
        url: `/pages_category_page1/goodsModule/canvasGoods?sourceType=${item.sourceType}&ids=${item.productIdList}`
      })
    } else if(item.sourceType === '2'){
      uni.navigateTo({
        url: `/pages_category_page1/goodsModule/canvasGoods?sourceType=${item.sourceType}&classifyId=${item.categoryId}`
      })
    }
  }
  // 跳转到店铺主页
  function jumpStore(item){
    uni.navigateTo({
      url: `/pages_category_page1/store/index?storeId=${item.shopId}`
    })
  }
  // 跳转到商品详情
  function jumpProductDetail(item){
    uni.navigateTo({
      url: '/pages_category_page1/goodsModule/goodsDetails?shopId=' + item.shopId + '&productId=' + item.productId + '&skuId=' + item
          .skuId
    })
  }
  // 跳转到秒杀专区
  function jumpSeckills(item){
    if(item.shopId){
      uni.navigateTo({
        url: '/pages_category_page1/discount/spikeList?shopId=' + item.shopId + '&shopSeckillId=' + item.shopSeckillId
      })
    } else {
      uni.navigateTo({
        url: '/pages_category_page1/discount/spikeList'
      })
    }
  }
  // 跳转到拼团专区
  function jumpGroupWorks(item){
    if(item.shopId){
      uni.navigateTo({
        url: '/pages_category_page1/discount/groupBuy?shopId=' + item.shopId + '&shopGroupWorkId=' + item.shopGroupWorkId
      })
    } else {
      uni.navigateTo({
        url: '/pages_category_page1/discount/groupBuy?'
      })
    }
  }
  // 跳转到折扣专区
  function jumpDiscount(item){
    if(item.shopId){
      if (item.shopDiscountId) {
        uni.navigateTo({
          url: '/pages_category_page1/discount/discount?shopId=' + item.shopId + '&shopDiscountId=' + item.shopDiscountId
        })
      } else {
        uni.showToast({
          title: '暂无活动',
          icon: "none"
        });
      }
    } else {
      if (item.discountId) {
        uni.navigateTo({
          url: '/pages_category_page1/discount/platformDiscount?discountId=' + item.discountId
        })
      } else {
        uni.showToast({
          title: '暂无活动',
          icon: "none"
        });
      }
    }
  }
  // 跳转到会员专区
  function jumpVip(){
    uni.navigateTo({
      url: '/pages_category_page1/memberCenter/activityList',
      success: res => {},fail: () => {},complete: () => {}
    })
  }
  // 跳转组合支付
  function jumpCombination(item){
    if (item.priceId) {
      uni.navigateTo({
        url: '/pages_category_page1/goodsModule/combination?priceId=' + item.priceId
      })
    } else {
      uni.showToast({
        title: '暂无活动',
        icon: "none"
      });
    }
  }
  // 跳转到公告详情
  function jumpNoticeDetail(item){
    uni.navigateTo({
      url: '/pages_category_page2/userModule/messageDetail?noticeId=' + item.noticeId
    })
  }
  // 跳转到直播列表
  function jumpLive(){
    uni.navigateTo({
      url: '/pages_category_page2/livePage/index'
    })
  }
  // 加入购物车
  function addCart(id){
    console.log(id)
  }

  return {
    sendReq,
    jumpLink,
    jumpCategory,
    jumpStore,
    jumpProductDetail,
    jumpSeckills,
    jumpGroupWorks,
    jumpDiscount,
    jumpVip,
    jumpNoticeDetail,
    addCart,
    jumpProList,
    jumpLive,
    jumpCombination
  }
}
