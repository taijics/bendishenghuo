<template>
  <view class="wid bor-line-F7F7F7">
    <view class="qaBox">
      <view class="qaTopInfo">
        <view class="qaTopInfoBox">
          <image :src="productInfo.images"></image>
          <view class="qaInfoText">
            <h3>{{ productInfo.productName }}</h3>
            <span>共{{ getProblemsList.length }}个问题</span>
          </view>
        </view>
      </view>
      <QuestionsAndAnswersList :problems-list="getProblemsList" :product-info="productInfo" />
      <view class="putQuestionsBox">
        <view
            class="putQuestionsBtn"
            @click="goToQuestions"
        >去提问
        </view>
      </view>
    </view>
  </view>
</template>
<script setup>
import { inject, ref } from "vue";
import { onLoad, onReachBottom } from "@dcloudio/uni-app";
import QuestionsAndAnswersList from "./components/QuestionsAndAnswersList";
import API from "@/config/api";
import { request } from "@/utils/request";
const productInfo=ref({})
const getProblemsList=ref([])//商品问答数据
const problemsPage=ref(1)
const problemsPageSize=ref(10)
const loadingType=ref(0)


onReachBottom(()=>{
  if (loadingType.value === 1) {
    uni.stopPullDownRefresh()
  } else {
    problemsPage.value = problemsPage.value + 1
    getProblems()
  }
})
const $getJumpParam = inject('$getJumpParam')
onLoad((options)=>{
  productInfo.value = $getJumpParam(options)
  getProblems()
})

//商品问答数据
const getProblems = ()=> {
  request(API.getProblems, {
    productId: productInfo.value.productId,
    page: problemsPage.value,
    pageSize: problemsPageSize.value
  }, 'GET').then(res => {
    if (res.data.length == 0) {
      loadingType.value = 1
      problemsPage.value = problemsPage.value
    } else {
      getProblemsList.value = getProblemsList.value.concat(res.data.list)
    }
  }).catch(res => {
    uni.showToast({
      title: '失败',
      icon: "none"
    })
  })
}
// 提问
const $jump = inject('$jump')
const goToQuestions = ()=> {
  const paramObj = Object.assign({}, productInfo.value, {
    questionNumber: getProblemsList.value.length,
    images: productInfo.value.images,
  })
  $jump('/pages_category_page1/goodsModule/putQuestions', paramObj)
}
</script>

<style
    lang="scss"
    scoped
>
.qaBox {
  padding-bottom: 140upx;

  .ianswer {
    font-style: normal;
    width: 38upx;
    height: 38upx;
    line-height: 38upx;
    background: linear-gradient(0deg, #2DB76F 0%, #67C192 100%);
    border-radius: 4upx;
    display: block;
    text-align: center;
    margin-right: 30upx;
    color: #FFFFFF;
  }

  .qaTopInfo {
    margin-top: 20upx;
    margin-bottom: 30upx;
    padding: 0 40upx;

    .qaTopInfoBox {
      border-radius: 10upx;
      display: flex;
      align-items: center;
      padding: 15upx 20upx;
      margin-bottom: 55upx;
      background: #F6F6F6;

      image {
        width: 60upx;
        height: 60upx;
        border-radius: 5upx;
        margin-right: 20upx;
      }

      .qaInfoText {
        h3 {
          font-size: 30upx;
          font-weight: 500;
          color: #333333;
        }

        span {
          font-size: 24upx;
          color: #999999;
        }
      }
    }

    .qaTitBox {
      padding-bottom: 30upx;
      border-bottom: 1upx solid #EEEEEE;

      .qaTit {
        display: flex;
        align-items: center;
        margin-bottom: 35upx;

        i {
          width: 38upx;
          height: 38upx;
          background: linear-gradient(0deg, #FF7800 0%, #F79D4D 100%);
          border-radius: 4upx;
          font-style: normal;
          text-align: center;
          color: #FFFFFF;
          font-size: 28upx;
          margin-right: 30upx;
        }

        h3 {
          font-size: 28upx;
          font-family: PingFang SC;
          font-weight: 500;
          color: #333333;
        }
      }

      .qaTitTime {
        display: flex;
        align-items: center;

        img {
          width: 44upx;
          height: 44upx;
          margin-right: 20upx;
        }

        .qaName {
          font-size: 28upx;
          color: #666666;
          margin-right: 35upx;
        }

        .qaTimeInfo {
          color: #999999;
          font-size: 22upx;
        }
      }
    }
  }

  .qaListBox {
    .listBox {
      padding: 20upx 60upx 20upx 60upx;
      border-bottom: 1upx solid #EEEEEE;

      .itemBox {
        padding-bottom: 30upx;
        border-bottom: 1upx solid #EEEEEE;
        margin-top: 10rpx;

        &:last-child {
          border-bottom: none;
        }

        .itemAsk {
          display: flex;
          align-items: center;
          margin-bottom: 42upx;

          .text {
            font-style: normal;
            width: 38upx;
            height: 38upx;
            line-height: 38upx;
            background: #C83732;
            display: block;
            margin-right: 30upx;
            font-size: 24rpx;
            color: #EEEEEE;
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
          // margin-bottom: 30upx;
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
              color: #EEEEEE;
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
            background: #C5AA7B;
            text-align: center;
            color: #FFFFFF;
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

  .putQuestionsBox {
    position: fixed;
    bottom: 0;
    left: 0;
    width: 100%;
    background: #FFFFFF;
    padding: 0 32rpx;
  }

  .putQuestionsBtn {
    width: 100%;
    height: 100rpx;
    line-height: 100rpx;
    text-align: center;
    background: #333333;
    display: block;
    margin: 0 auto 70rpx auto;
    color: #FFEBC4;
  }
}
</style>
