<template>
  <view
      class="qaBox u-skeleton"
  >
    <Skeleton
        el-color="#efefef"
        bg-color="#fff"
        :loading="loading && isFirstComeIn"
        :animation="true"
    ></Skeleton>
    <view class="qaTopInfo">
      <view
          class="qaTopInfoBox"
          @click="goGoodsDetails"
      >
        <image class="u-skeleton-rect" :src="detailList.image"></image>
        <view class="qaInfoText">
          <h3 class="u-skeleton-rect">{{ detailList.productName }}</h3>
          <span class="u-skeleton-rect">共{{ detailList.count }}个问题</span>
        </view>
      </view>
      <view class="qaTitBox">
        <view class="qaTit">
          <i class="u-skeleton-rect">问</i>
          <h3 class="u-skeleton-rect">{{ detailList.problem }}</h3></view>
        <view class="qaTitTime">
          <image class="u-skeleton-rect" :src="detailList.headImage" />
          <span class="qaName u-skeleton-rect">{{ detailList.name }}</span>
          <span class="qaTimeInfo u-skeleton-rect">{{ detailList.createTime }}</span></view>
      </view>
    </view>
    <view class="answerListBox">
      <view class="answerNum u-skeleton-rect">共{{ answerslength }}条回答</view>
      <view
          class="answerList"
          v-for="item in detailList.answers"
          :key="item.answerId"
      >
        <view class="answerItem">
          <view class="itemTit">
            <view class="itemAvatarBox">
              <image
                  class="u-skeleton-rect"
                  :src="item.headImage"
                  alt=""
              />
              <span class="answerName u-skeleton-rect">{{ item.name }}</span>
            </view>
            <view class="answerTime u-skeleton-rect">{{ item.createTime }}</view>
          </view>
          <view class="answerInfo u-skeleton-rect">{{ item.answer }}</view>
        </view>
      </view>
    </view>
    <view
        v-if="detailList.ifExhibition==1"
        class="pad-bot-100"
    ></view>
    <view
        class="answerBtn"
        v-if="detailList.ifExhibition==1"
        :style="{'padding-bottom':(isIphone==true? 50:0)+'rpx'}"
    >
      <view class="uni-form-item uni-column answerBtnBox">
        <input
            class="uni-input"
            v-model="answerText"
            focus
            placeholder="被邀请的用户才能回答"
        />
<!--        <view-->
<!--            class="answerButton"-->
<!--            @click="answer"-->
<!--        >回答-->
<!--        </view>-->
        <submit-button width="172rpx" text="回答" height="84rpx" @submitEvent="answer"></submit-button>
      </view>
    </view>
  </view>
</template>

<script setup>
    import { onLoad } from "@dcloudio/uni-app";
    import API from "@/config/api";
    import { ref,inject } from "vue";
    import { request } from "@/utils/request";
    import Skeleton from "@/components/Skeleton/index.vue";
    import { btnUseLoading } from '../../hooks/bntUseLoading'

    const { btnShowLoading } = btnUseLoading()
    const detailList = ref( {
      answers: [{}, {}, {}, {}, {}, {}]
    }) // 商品问答详情
    const productId=ref( '')
    const images=ref( '')
    const productName=ref( '')
    const problemsData=ref( {})
    const answerText=ref( "")
    const answerslength=ref( 0)
    const num=ref( 0)
    const isIphone=ref( false)
    const ifShow=ref( false)
    const $getJumpParam = inject('$getJumpParam')
    const loading = ref(false)
    const isFirstComeIn = ref(true);
    onLoad((options)=>{
      detailList.value.answers = [{}, {}, {}, {}, {}, {}]
      isIphone.value = getApp().globalData.isIphone;
      problemsData.value = $getJumpParam(options)
      getProblems()
    })

    function goGoodsDetails() {
      let shopId = detailList.value.shopId
      let productId = detailList.value.productId
      let skuId = detailList.value.skuId
      uni.navigateTo({
        url: 'goodsDetails?shopId=' + shopId + '&productId=' + productId + '&skuId=' + skuId
      })
    }
    //商品问答数据
    function getProblems() {
      loading.value = true
      request(API.getProblemDetail, {
        problemId: problemsData.value.problemId,
        productId: problemsData.value.productId,
      }, 'GET').then(res => {
        detailList.value = res.data
        ifShow.value = true
        answerslength.value = detailList.value.answers.length
        uni.removeStorageSync('seeAllFnData')
      }).catch(res => {
        uni.showToast({
          title: '失败',
          icon: "none"
        })
      }).finally(() => {
        isFirstComeIn.value = false
        loading.value = false
      })
    }
    //回答
    function answer() {
      btnShowLoading()
      request(API.addAnswer, {
        productId: problemsData.value.productId,
        answer: answerText.value,
        problemId: problemsData.value.problemId
      }, 'POST').then(res => {
        getProblems()
        answerText.value = ""
        uni.showToast({
          title: '回答成功',
          icon: "success"
        })
      }).catch(res => {
        uni.showToast({
          title: '失败',
          icon: "none"
        })
      })
    }
</script>
<style
    lang="scss"
    scoped
>
.qaBox {
  padding: 0 30upx;

  .qaTopInfo {
    margin-top: 20upx;

    .qaTopInfoBox {
      border-radius: 10upx;
      display: flex;
      align-items: center;
      padding: 15upx 20upx;
      margin-bottom: 55upx;

      image {
        border: 2px solid #E4E5E6;
        width: 120upx;
        height: 120upx;
        margin-right: 20upx;
      }

      .qaInfoText {
        h3 {
          min-width: 90rpx;
          min-height: 36rpx;
          font-size: 30upx;
          font-weight: 500;
          color: #333333;
          margin-bottom: 20rpx;
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
          line-height: 38upx;
          background: #C83732;
          font-style: normal;
          text-align: center;
          color: #FFFFFF;
          font-size: 20upx;
          margin-right: 30upx;
        }

        h3 {
          min-width: 140rpx;
          min-height: 38rpx;
          font-size: 28upx;
          font-weight: 500;
          color: #333333;
        }
      }

      .qaTitTime {
        display: flex;
        align-items: center;

        image {
          width: 44upx;
          height: 44upx;
          margin-right: 20upx;
        }

        .qaName {
          font-size: 28upx;
          color: #666666;
          margin-right: 35upx;
          display: inline-block;
          min-width: 130rpx;
          min-height: 44rpx;
        }

        .qaTimeInfo {
          color: #CCCCCC;
          font-size: 22upx;
          display: inline-block;
          min-width: 250rpx;
          min-height: 32rpx;
        }
      }
    }
  }

  .answerListBox {
    .answerNum {
      font-size: 24upx;
      color: #CCCCCC;
      margin-bottom: 40upx;
      margin-top: 30upx;
    }

    .answerList {
      min-height:110rpx;
      margin-bottom: 50upx;

      .answerItem {
        margin-bottom: 10upx;

        .itemTit {
          display: flex;
          align-items: center;
          justify-content: space-between;

          .itemAvatarBox {
            display: flex;

            image {
              width: 46upx;
              height: 46upx;
              margin-right: 20upx;
            }

            .answerName {
              font-size: 26upx;
              color: #333333;
              font-weight: bold;
              display: inline-block;
              min-width: 100rpx;
              min-height: 44rpx;
            }
          }

          .answerTime {
            color: #CCCCCC;
            font-size: 20upx;
            min-width: 226rpx;
            min-height: 24rpx;
          }
        }

        .answerInfo {
          color: #333333;
          font-size: 28upx;
          margin-top: 20upx;
          font-weight: 400;
          min-width: 200rpx;
          min-height: 44rpx;
        }
      }
    }
  }

  .answerBtn {
    position: fixed;
    width: 100%;
    bottom: 0;
    left: 0;

    .answerBtnBox {
      display: flex;
      align-items: center;
      justify-content: space-between;
      width: 100%;
      padding: 30upx;
      background: #FFFFFF;

      input {
        margin-right: 30upx;
        width: 530upx;
        background: #F1F1F1;
        min-height: 84upx;
        padding-left: 30upx;
        font-size: 28upx;
        color: #999999;
      }

      .input-placeholder {
        font-size: 24upx;
        color: #999999;
      }

      .answerButton {
        width: 172upx;
        height: 84upx;
        background: #333333;
        text-align: center;
        line-height: 84upx;
        font-size: 30upx;
        color: #FFEBC4;
      }
    }
  }
}
</style>
