<!--
    * @FileDescription:商品评价和问答
    * @Author: kahu
    * @Date: 2022/11/7
    * @LastEditors: kahu
    * @LastEditTime: 2022/11/7
-->
<template>
  <div class="content">
    <view class="evaQaTab flex-items flex-sp-around">
      <view
          :class="{active: activeTab === 1}"
          class="evaBtn"
          @click="activeTab = 1"
      >
        <view class="tabTit">宝贝评价（{{ commentList.length }}）</view>
      </view>
      <view
          :class="{active: activeTab === 2}"
          class="qaBtn"
          @click="activeTab = 2"
      >
        <view class="tabTit">商品问答（{{ problemsTotal }}）</view>
      </view>
    </view>
    <!-- 评价 -->
    <view class="borRig-line-20"></view>
    <view
        class="evaluate-box flex-start flex-column"
        v-show="activeTab === 1"
    >
      <view
          class="evaluateTag-box"
          v-if="commentList.length>0"
      >
        <view class="evaluateTag-text">
          全部({{ commentList.length }})
        </view>
      </view>
      <view
          class="evaluate-contentbox mar-top-30"
          v-for="(commentItem, commentIndex) in commentList.slice(0,2)"
          :key="commentIndex"
      >
        <view class="evaluate-content flex-items flex-row flex-sp-between">
          <view class="flex-items">
            <image
                class="user-headSmallImg"
                :src="commentItem.headImage"
            ></image>
            <label class="fs28 mar-left-20">{{ commentItem.name }}</label>
          </view>
          <label class="font-color-999 fs22">{{ commentItem.createTime }}</label>
        </view>
        <view class="evaluateDes-box">
          <label class="evaluateDes">{{ commentItem.comment }}</label>
        </view>
        <view
            class="item-image-box"
            v-if="commentItem.image"
        >
          <view
              v-for="(imgItem, imgIndex) in (commentItem.image.split(',')||[])"
              :key="imgIndex"
          >
            <image
                @click="handlePreviewImage(commentList[commentIndex].images,imgIndex)"
                class="img-item"
                :src="imgItem"
            ></image>
          </view>
        </view>
        <view class="item-line"></view>
        <view
            class="item-like-box"
            v-if="commentItem.addComment !== ''"
        >
          <view class="addEvaluate">
            <view>追加评价：{{ commentItem.addComment }}</view>
            <view
                class="item-image-box"
                v-if="commentItem.addImages"
            >
              <view
                  v-for="(itemAddImg, imgIndex) in commentItem.addImages"
                  :key="imgIndex"
              >
                <image
                    @click="handlePreviewImage(commentList[commentIndex].addImages,imgIndex)"
                    class="img-item"
                    :src="itemAddImg"
                >
                </image>
              </view>
            </view>
          </view>
        </view>
        <view class="like-box">
          <image
              class="like-img"
              @click="handlePraise(commentItem,0)"
              :src="`${VUE_APP_STATIC_URL}static/images/praiseActiveIcon.png`"
              v-if="commentItem.ifLike === 1"
          ></image>
          <image
              class="like-img"
              @click="handlePraise(commentItem,1)"
              :src="`${VUE_APP_STATIC_URL}static/images/praiseIcon.png`"
              v-else
          ></image>
          <view class="like-num">{{ commentItem.likes }}</view>
        </view>
      </view>
      <view
          class="moreBox"
          v-if="commentList.length>0"
          @click="handleJumpToComments"
      >
        <label class="fs24">查看全部</label>
        <image
            class="evaluateAllArrow-icon mar-left-10"
            :src="`${VUE_APP_STATIC_URL}static/img/user/arrow.png`"
        ></image>
      </view>
    </view>
    <!-- 问答 -->
    <view class="borRig-line-20"></view>
    <view
        class="questions"
        v-show="activeTab === 2"
    >
      <view class="questionInfo flex-items flex-row flex-sp-between">
        <view class="infoTit">宝贝好不好，问问已买过的人</view>
        <view
            class="putQuestion"
            @click="handleJumpToQuestion"
        >去提问
        </view>
      </view>
      <view class="listBox">
        <QuestionsAndAnswersList
            :product-info="productInfo"
            :problems-list="problemsList"
        />
        <view
            class="moreBox"
            v-if="problemsList.length>0"
            @click="handleJumpAllAnswer"
        >
          <label class="fs24">查看全部</label>
          <image
              class="evaluateAllArrow-icon mar-left-10"
              :src="`${VUE_APP_STATIC_URL}static/img/user/arrow.png`"
          ></image>
        </view>
      </view>
    </view>
  </div>
</template>

<script setup>
import { request } from "@/utils/request";
import API from "@/config/api";
import lodash from 'lodash'
import QuestionsAndAnswersList from "./QuestionsAndAnswersList";
import { inject, ref, toRefs } from "vue";
import { VUE_APP_STATIC_URL } from "@/config/api";

const $jump = inject('$jump')

const props = defineProps({
  commentList: {
    type: Array,
    default: () => []
  },
  productInfo: {
    type: Object,
    default: () => ({})
  }
})

const {commentList,productInfo} = toRefs(props)
const activeTab =ref(1)  // 1评价 2问答
const problemsList=ref([]) // 问题列表
const problemsTotal=ref(0) //问题总数

/**
 * 获取问答数据
 * @return {Promise<void>}
 */
const handleGetProblemList = async()=> {
  const {productId } = productInfo.value
  if(!productId){
    return
  }
  const res = await request(API.getProblems, {
    productId: productId,
    page: 1,
    pageSize: 2
  }, 'GET')
  problemsList.value = res.data.list
  problemsTotal.value = res.data.total
}

/**
 * 放大查看照片
 * @param dataList 所有照片
 * @param currentIndex 选中索引
 */
const handlePreviewImage = (dataList, currentIndex) => {
  uni.previewImage({
    current: dataList[currentIndex],
    urls: dataList
  })
}

/**
 * 点赞
 * @param commentItem 当前评论项
 * @param action 0取消1点赞
 */
const handlePraise = lodash.debounce(async function (commentItem, actionType) {
  try {
    await request(API.LikeOrUnLikeComment, {
      commentId: commentItem.commentId,
      ifLike: actionType
    }, 'POST')
    if (commentItem.ifLike === 1) {
      commentItem.ifLike = 0
      commentItem.likes--
    } else {
      commentItem.ifLike = 1
      commentItem.likes++
    }
  } finally {
  }
}, 500)

/**
 * 跳转到全部评论
 */
const handleJumpToComments=()=> {
  $jump('/pages_category_page1/goodsModule/evaluateList', commentList.value)
}

/**
 * 跳转到提问
 */
const handleJumpToQuestion=()=> {
  const paramObj = Object.assign({}, productInfo.value, {
    questionNumber: problemsList.value.length,
    images: productInfo.value.images[0],
  })
  $jump('/pages_category_page1/goodsModule/putQuestions', paramObj)
}

/**
 * 跳转到该商品下所有问答
 */
const handleJumpAllAnswer=()=> {
  const paramObj = Object.assign({}, productInfo.value, {
    images: productInfo.value.images[0]
  })
  $jump('/pages_category_page1/goodsModule/answerList', paramObj)
}
defineExpose({handleGetProblemList })
</script>

<style
    lang="scss"
    scoped
>
@import "../../../style/images";
.evaQaTab {
  height: 82rpx;
  line-height: 82rpx;
  border-bottom: #F3F4F5 solid 2rpx;
  font-size: 30rpx;
  color: #CCCCCC;

  .evaBtn {
    width: 50%;
    position: relative;
    text-align: center;

    &:before {
      content: '';
      width: 2rpx;
      height: 30rpx;
      background: #CCCCCC;
      display: block;
      position: absolute;
      right: 0;
      top: 20rpx;
    }
  }

  .qaBtn {
    width: 50%;
    text-align: center;
  }

  .tabTit {
    display: inline-block;
    height: 82rpx;
    line-height: 82rpx;
  }

  .active {
    color: #333333;

    .tabTit {
      border-bottom: 4rpx solid #444444;
    }
  }
}

.questions {
  .questionInfo {
    padding: 0 30upx;
    min-height: 150upx;

    .infoTit {
      font-size: 28upx;
    }

    .putQuestion {
      width: 140upx;
      height: 60upx;
      background: #333333;
      line-height: 60upx;
      font-size: 24upx;
      color: #FFEBC4;
      padding-left: 20rpx;
      position: relative;

      &:before {
        content: '';
        width: 60rpx;
        height: 60rpx;
        background: $smallArrowR no-repeat center center;
        background-size: contain;
        display: block;
        position: absolute;
        right: 0;
      }
    }
  }

  .listBox {
    padding: 0 30upx;
    border-bottom: 20upx solid #EEEEEE;

    .itemBox {
      padding-bottom: 30upx;
      border-bottom: 1upx solid #EEEEEE;
      margin-bottom: 30upx;

      &:last-child {
        border-bottom: none;
      }

      .itemAsk {
        display: flex;
        align-items: center;
        margin-bottom: 42upx;

        i {
          font-style: normal;
          width: 38upx;
          height: 38upx;
          line-height: 38upx;
          background: #C5AA7B;
          display: block;
          margin-right: 30upx;
          font-size: 24upx;
          color: #FFFFFF;
          text-align: center;
        }

        span {
          font-size: 28upx;
          color: #333333;
        }
      }

      .answer {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 30upx;

        .answerBox {
          display: flex;
          align-items: center;

          i {
            font-style: normal;
            width: 38upx;
            height: 38upx;
            line-height: 38upx;
            background: #C5AA7B;
            display: block;
            text-align: center;
            margin-right: 30upx;
            font-size: 24rpx;
            color: #FFFFFF;
          }

          span {
            font-size: 26upx;
            color: #666666;
          }
        }

        .answerBtn {
          width: 130upx;
          height: 50upx;
          line-height: 50upx;
          border: #333333 2rpx solid;
          text-align: center;
          color: #333;
          font-size: 24upx;
        }
      }

      .seeAll {
        margin-left: 68upx;
        font-size: 28upx;
        color: #C5AA7B;
      }
    }
  }
}

.evaluate-box {
  background-color: #FFFFFF;
  margin-top: 20upx;

  .evaluate {
    width: 690upx;
    padding: 20upx 0;
    border-bottom: 1upx solid #EDEDED;
  }

  .evaluateTitle-box {
    width: 690upx;
    border-bottom: 1upx solid #EDEDED;
    padding-bottom: 20upx;
  }

  .evaluateAllArrow-icon {
    width: 13upx;
    height: 22upx;
  }

  .evaluateTag-box {
    margin-top: 10upx;
    margin-left: 10upx;
    padding-bottom: 10upx;
    display: flex;
    flex-wrap: wrap;

    .evaluateTag-text {
      background-color: #F4F4F4;
      border-radius: 6upx;
      padding: 16upx 14upx;
      color: #656565;
      margin-left: 20upx;
      margin-top: 20upx;
    }
  }

  .evaluate-contentbox {
    display: flex;
    justify-content: center;
    flex-direction: column;
    margin-left: 30upx;
    // border-bottom: 1upx solid #EDEDED;
    padding-bottom: 50upx;

    .evaluate-content {
      width: 670upx;
      display: flex;
      justify-content: space-between;

      .user-headSmallImg {
        width: 46upx;
        height: 46upx;
        border-radius: 50%;
      }
    }

    .evaluateDes-box {
      width: 670upx;
      margin-top: 30upx;

      .evaluateDes {
        width: 670upx;
      }
    }

    .addEvaluate {
      padding-top: 30upx;
    }
  }
}


.item-image-box {
  width: 700upx;
  display: flex;
  flex-direction: row;
  flex-wrap: wrap;

  .img-item {
    width: 223upx;
    height: 223upx;
    border-radius: 10upx;
    margin-right: 10upx;
    margin-top: 10upx;
  }
}


.item-line {
  width: 690upx;
  height: 1px;
  background: rgba(238, 238, 238, 1);
  margin-top: 20upx;
}

.item-like-box {
  display: flex;
  flex-direction: row;
  width: 690upx;
  align-items: center;
  justify-content: space-between;
}

.like-box {
  display: flex;
  flex-direction: row;
  padding-top: 30upx;
  align-items: center;
  justify-content: flex-end;
  margin-right: 50upx;

  .like-img {
    width: 48upx;
    height: 48upx;
  }

  .like-num {
    font-size: 28upx;
    font-weight: 500;
    color: rgba(51, 51, 51, 1);
    margin-left: 30upx;
  }
}

.moreBox {
  width: 170rpx;
  height: 54rpx;
  line-height: 54rpx;
  margin: 0 auto 50rpx auto;
  border: 2rpx solid #C5AA7B;
  color: #C5AA7B;
  display: flex;
  align-items: center;
  justify-content: center;

  image {
    width: 10rpx;
    height: 20rpx;
  }
}
</style>
