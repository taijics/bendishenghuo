<template>
  <view class="container">
    <view class="u-skeleton">
      <!-- 骨架屏 -->
      <Skeleton
          el-color="#efefef"
          bg-color="#fff"
          :loading="loading && isFirstComeIn"
          :animation="true"
      ></Skeleton>
      <!-- 我的评论 -->
      <view class="evaluateTitle-box flex-row-plus flex-sp-around">
        <view
            class="allEvaluate"
            :class="{'evaluateTitle-on' : evaluateTitleFlag == 1}"
            @click="evaluateTitleClick(1)"
        >全部评价({{ myCommentList.total || 0 }})
        </view>
        <view class="centerLine">|</view>
        <view
            :class="{'evaluateTitle-on' : evaluateTitleFlag == 2}"
            @click="evaluateTitleClick(2)"
        >有图({{ myCommentList.imageTotal || 0 }})
        </view>
      </view>
      <view
          v-if="evaluateTitleFlag == 1"
          class="mar-top-20"
      >
        <view
            class="evaluate-contentbox"
            v-for="(item, index) in commentVOList"
            :key="index"
            @click="commentDetails(index)"
        >
          <view class="evaluate-content flex-items flex-row flex-sp-between ">
            <view class="flex-items">
              <image
                  class="user-headSmallImg u-skeleton-circle"
                  v-if="item.headImage"
                  :src="item.headImage"
              ></image>
              <image
                  class="user-headSmallImg u-skeleton-circle"
                  :src="`${VUE_APP_STATIC_URL}static/images/storeLogo.png`"
                  v-else
              ></image>
              <view class="skuValue">
                <label
                    class="fs28 u-skeleton-rect"
                    v-if="item.name"
                >{{ item.name }}</label>
                <label
                    class="fs28 u-skeleton-rect"
                    v-else
                >匿名</label>
                <view class="fs22 font-color-999 mar-top-10 u-skeleton-rect sku-box">
                  {{ item.value }}
                </view>
              </view>
            </view>
            <view class="u-skeleton-rect skeleton-btn">
              <view
                  class="addCommentsBut u-skeleton-rect"
                  v-if="item.addComment == ''"
                  @click.stop="addCommentsClick(index)"
              >追加评价
              </view>
            </view>
          </view>
          <view
              class="fs26 pad-topbot-20 u-skeleton-rect"
              style="margin-top: 10rpx"
          >{{ item.comment }}
          </view>
          <view class="skeleton-item u-skeleton-rect" v-if="!item.image"></view>
          <view
              class="evaluateImg-box u-skeleton-rect"
              v-if="item.image"
          >
            <view
                v-for="(cItem, index) in commentImgData(item.image)"
                :key="index"
            >
              <image
                  class="evaluate-Img"
                  :src="cItem"
              ></image>
            </view>
          </view>
          <view
              class="addComments-box flex-column-plus"
              v-if="item.addComment"
          >
            <label class="font-color-C5AA7B mar-top-30 u-skeleton-rect">用户追评</label>
            <label class="mar-top-20 u-skeleton-rect">{{ item.addComment }}</label>
            <view
                class="evaluateImg-box mar-top-20 u-skeleton-rect"
                v-if="item.addImage"
            >
              <view
                  v-for="(dItem, index) in commentImgData(item.addImage)"
                  :key="index"
              >
                <image
                    class="evaluate-Img u-skeleton-rect"
                    :src="dItem"
                ></image>
              </view>
            </view>
          </view>
          <view class="goodsDes-box u-skeleton-rect flex-column-plus mar-top-30">
            <view
                class="flex-row-plus"
                @click.stop="goGoodsDetails(item.shopId,item.productId,item.skuId)"
            >
              <image
                  class="goodsDes-img default-img u-skeleton-rect"
                  :src="item.productImage"
              ></image>
              <view class="goodsDesText-box">
                <label class="fs26 goodsDes-text u-skeleton-rect">{{ item.productName }}</label>
                <view class="mar-top-70">
                  <label class="u-skeleton-rect">¥ {{ item.productPrice }}</label>
                </view>
              </view>
            </view>
          </view>
          <view class="flex-items flex-row mar-top-30 flex-sp-between">
            <view class="font-color-999 fs22 u-skeleton-rect order-time">{{ item.createTime }}</view>
            <view class="praise-box flex-items flex-row">
              <image
                  class="praise-icon u-skeleton-rect"
                  @click.stop="zanTap(index,item.commentId,0)"
                  :src="`${VUE_APP_STATIC_URL}static/images/praiseActiveIcon.png`"
                  v-if="item.ifLike"
              ></image>
              <image
                  class="praise-icon u-skeleton-rect"
                  @click.stop="zanTap(index,item.commentId,1)"
                  :src="`${VUE_APP_STATIC_URL}static/images/praiseIcon.png`"
                  v-else
              ></image>
              <label class="mar-left-10 u-skeleton-rect">{{ item.likes }}</label>
            </view>
          </view>
        </view>
      </view>
      <view
          v-if="evaluateTitleFlag == 2"
          class="mar-top-20"
      >
        <view
            class="evaluate-contentbox"
            v-for="(item, index) in commentVOList"
            :key="index"
        >
          <view
              class="evaluate-content flex-column"
              @click="commentDetails(index)"
          >
            <view class="flex-items">
              <image
                  class="user-headSmallImg u-skeleton-rect"
                  v-if="item.headImage"
                  :src="item.headImage"
              ></image>
              <image
                  class="user-headSmallImg u-skeleton-rect"
                  :src="`${VUE_APP_STATIC_URL}static/images/storeLogo.png`"
                  v-else
              ></image>
              <label
                  class="fs28 mar-left-20 u-skeleton-rect"
                  v-if="item.name"
              >{{ item.name }}</label>
              <label
                  class="fs28 mar-left-20 u-skeleton-rect"
                  v-else
              >匿名</label>
            </view>
            <view class="fs22 font-color-999 mar-top-10 u-skeleton-rect">
              {{ item.value }}
            </view>
            <view class="fs26 pad-topbot-20 u-skeleton-rect">{{ item.comment }}</view>
            <view
                class="evaluateImg-box u-skeleton-rect"
                v-if="item.image"
            >
              <view
                  v-for="(cItem, index) in commentImgData(item.image)"
                  :key="index"
              >
                <image
                    class="evaluate-Img"
                    :src="cItem"
                ></image>
              </view>
            </view>
            <view
                class="addComments-box flex-column-plus"
                v-if="item.addComment"
            >
              <label class="font-color-C5AA7B mar-top-30 u-skeleton-rect">用户追评</label>
              <label class="mar-top-20 u-skeleton-rect">{{ item.addComment }}</label>
              <view
                  class="evaluateImg-box mar-top-20 u-skeleton-rect"
                  v-if="item.addImage"
              >
                <view
                    v-for="(dItem, index) in commentImgData(item.addImage)"
                    :key="index"
                >
                  <image
                      class="evaluate-Img"
                      :src="dItem"
                  ></image>
                </view>
              </view>
            </view>

            <view class="flex-items flex-row mar-top-30 flex-sp-between">
              <view class="font-color-999 fs22 u-skeleton-rect">{{ item.createTime }}</view>
              <view class="praise-box flex-items flex-row">
                <image
                    class="praise-icon u-skeleton-rect"
                    @click.stop="zanTap(index,item.commentId,0)"
                    :src="`${VUE_APP_STATIC_URL}static/images/praiseActiveIcon.png`"
                    v-if="item.ifLike"
                ></image>
                <image
                    class="praise-icon u-skeleton-rect"
                    @click.stop="zanTap(index,item.commentId,1)"
                    :src="`${VUE_APP_STATIC_URL}static/images/praiseIcon.png`"
                    v-else
                ></image>
                <label class="mar-left-10 u-skeleton-rect">{{ item.likes }}</label>
              </view>
            </view>
          </view>
        </view>
      </view>
      <slide-loading />
      <view
          class="reachBottom"
          v-if="noMore && topLeft > 400"
      >
        <image
            class="reach-icon"
            :src="`${VUE_APP_STATIC_URL}static/img/reachBottom.png`"
            mode="widthFix"
        ></image>
        <text class="reach-text">这里到底了哦~~</text>
      </view>
      <view
          v-if="evaluateEmpty"
          class="emptyOrder-box flex-items-plus flex-column"
      >
        <image
            class="emptyOrder-img"
            :src="`${VUE_APP_STATIC_URL}static/img/bgnull.png`"
        ></image>
        <label class="font-color-999 fs26 mar-top-30">你还没有评论哦～</label>
      </view>
    </view>
    <!-- 回到顶部 -->
    <ReturnTop :returnTopFlag="returnTopFlag" />
  </view>
</template>

<script setup>
import { request } from "@/utils/request";
import API from "../../config/api";
import { ref } from "vue";
import {onBackPress, onPageScroll, onReachBottom, onShow} from "@dcloudio/uni-app";
import Skeleton from "@/components/Skeleton/index.vue";
import { VUE_APP_STATIC_URL } from "@/config/api";

const topLeft = ref(0); // 无更多数据显示距离
const returnTopFlag = ref(false); // 返回顶部显示隐藏
const loading = ref(false);
const isFirstComeIn = ref(true);
const noMore = ref(false); // 没有更多数据显示隐藏
const evaluateTitleFlag = ref(1);
const myCommentList = ref([]);
const commentVOList = ref([]);
const total = ref(0); // 数据总数
const state = ref("");
const page = ref(1);//当前页
const pageSize = ref(10);//每页记录数
const loadingType = ref(0);
const evaluateEmpty = ref(false)

onShow(() => {
  commentVOList.value = [{
    isLoading: true,
    name: '',
    comment: ''
  }, {
    isLoading: true,
    name: '',
    comment: ''
  }, {
    isLoading: true,
    name: '',
    comment: ''
  }, {
    isLoading: true,
    name: '',
    comment: ''
  }, {
    isLoading: true,
    name: '',
    comment: ''
  }]
  getMyCommentList()
})
onReachBottom(() => {
  if (commentVOList.value.length >= total.value) {
    uni.stopPullDownRefresh()
  } else {
    page.value = page.value + 1
    getMyCommentList()
  }
})
// onBackPress(e => {
//   if (e.from === 'navigateBack') {
//     return false;
//   }
//   back();
//   return true;
// })

function goGoodsDetails(shopId, productId, skuId) {
  uni.navigateTo({
    url: 'goodsDetails?shopId=' + shopId + '&productId=' + productId + '&skuId=' + skuId
  })
}

function back() {
  uni.switchTab({
    url: '../../pages/tabbar/user/index'
  });
}

function commentImgData(imgData) {
  let imgDataResult = []
  imgDataResult = imgData.split(",");
  return imgDataResult
}

function evaluateTitleClick(type) {
  evaluateTitleFlag.value = type
  evaluateEmpty.value = false
  noMore.value = false
  if (type == 1) {
    state.value = ''
  } else {
    state.value = "1"
  }
  total.value = 0
  page.value = 1
  commentVOList.value = []
  isFirstComeIn.value = true
  getMyCommentList()
}


//我的评价列表
function getMyCommentList() {
  loading.value = true
  request(API.MyCommentList, {
    page: page.value,
    pageSize: pageSize.value,
    state: state.value
  }, 'GET').then(res => {
    if (res.data.page.list.length == 0) {
      loadingType.value = 1
    }
    myCommentList.value = res.data
    commentVOList.value = commentVOList.value.concat(res.data.page.list).filter(item => !item.isLoading)
    total.value = res.data.page.total
    console.log(commentVOList.value)
    if (commentVOList.value.length === 0) {
      evaluateEmpty.value = true
    }
    if (commentVOList.value.length >= res.data.total) {
      noMore.value = true
    }
  }).catch(err => {
    uni.hideLoading()
    uni.showToast({
      title: res.data.message,
      duration: 2000,
      icon: 'none'
    });
    throw Error(err)
  }).finally(() => {
    loading.value = false
    isFirstComeIn.value = false
  })
}

//点赞
function zanTap(index, likeId, actionType) {
  request(API.LikeOrUnLikeComment, {
    commentId: likeId,
    ifLike: actionType
  }, 'POST').then(res => {
    commentVOList.value[index].ifLike = !commentVOList.value[index].ifLike
    commentVOList.value[index].likes = commentVOList.value[index].ifLike ? commentVOList.value[index].likes + 1 : commentVOList[index].value.likes - 1
  }).catch(err => {
    // uni.hideLoading()
    throw Error(err)
  })
}

function commentDetails(id) {
  uni.setStorageSync('commentVOList', commentVOList.value[id]);
  uni.navigateTo({
    url: 'evaluateDetails'
  })
}

//追加评论
function addCommentsClick(id) {
  uni.setStorageSync('addCommentVOList', commentVOList.value[id]);
  uni.navigateTo({
    url: 'addEvaluate?type=2'
  })
}

onPageScroll(e => {
  returnTopFlag.value = e.scrollTop > 600;
  topLeft.value = e.scrollTop
})
</script>

<style
    lang="scss"
    scoped
>
page {
  background-color: #FFFFFF;
}

.container {
  .emptyOrder-box {
    margin-top: 70upx;

    .emptyOrder-img {
      margin-top: 45%;
      width: 113upx;
      height: 98upx;
    }
  }

  .evaluateTitle-box {
    color: #CCCCCC;
    margin-top: 26upx;
    border-bottom: 2rpx solid #F3F4F5;
    position: relative;
    z-index: 9999;
    .evaluateTitle-on {
      padding-bottom: 20upx;
      border-bottom: 4upx solid #C5AA7B;
      color: #333333;
    }
  }

  .evaluate-contentbox {
    display: flex;
    justify-content: center;
    flex-direction: column;
    padding: 30upx 30upx;
    margin: 10rpx 10rpx;
    background-color: #FFFFFF;
    border-bottom: 2rpx solid #F3F4F5;

    .evaluate-content {
      width: 670upx;
      display: flex;
      justify-content: space-between;
      .user-headSmallImg {
        width: 66rpx;
        height: 66upx;
        border-radius: 50%;
      }

      .skuValue {
        text-align: left;
        padding-left: 30rpx;
        label {
          display: block;
          min-width: 120rpx;
          min-height: 40rpx;
        }
        .sku-box {
          min-height: 30rpx;
          min-width: 90rpx;
        }
      }
    }

    .evaluateImg-box {
      display: flex;
      flex-direction: row;
      flex-wrap: wrap;
      margin-left: -9upx;

      .evaluate-Img {
        width: 224upx;
        height: 224upx;
        border-radius: 10upx;
        margin-left: 9upx;
        margin-top: 9upx;
      }
    }
    .skeleton-item {
      display: block;
      width: 232rpx;
      height: 232rpx;
      margin-top: 20rpx;
    }
    .goodsDes-box {
      background-color: #F7F7F7;
      padding: 20upx 44upx 20upx 20upx;

      .goodsDes-img {
        width: 180upx;
        height: 180upx;
        border-radius: 10upx;
      }

      .goodsDesText-box {
        width: 416upx;
        margin-left: 30upx;
      }


      .praise-box {
        .praise-icon {
          width: 50upx;
          height: 50upx;
        }

      }
    }

    .addComments-box {
      border-top: 1upx solid #EEEEEE;
      margin-top: 35upx;
    }
    .order-time {
      min-width: 215rpx;
      min-height: 35rpx;
    }
  }
}

.praise-icon {
  width: 50upx;
  height: 50upx;
}

.addCommentsBut {
  width: 140upx;
  height: 58upx;
  background: #333333;
  font-size: 26upx;
  line-height: 58upx;
  text-align: center;
  color: #C5AA7B;
}
.skeleton-btn {
  width: 140upx;
  height: 58upx;
}
.addCommentsBut1 {
  width: 140upx;
  height: 58upx;
  font-size: 26upx;
  background: #333333;
  line-height: 58upx;
  text-align: center;
}
</style>
