<!--
    * @FileDescription: QuestionsAndAnswersList
    * @Author: kahu
    * @Date: 2022/11/7
    * @LastEditors: kahu
    * @LastEditTime: 2022/11/7
-->
<template>
  <div class="content">
    <view class="listBox">
      <view
          class="itemBox"
          v-for="(problemItem,problemIndex) in problemsList"
          :key="problemIndex"
      >
        <view class="itemAsk">
          <view class="text">问</view><span>{{ problemItem.problem }}</span>
        </view>
        <view v-if="problemItem.answers.length>0">
          <view
              class="answer"
              v-for="(answerItem,answerIndex) in (problemItem.answers.slice(0,1))"
              :key="answerIndex"
          >
            <view class="answerBox">
              <view class="text">答</view><span>{{ answerItem.answer }}</span>
            </view>
            <view
                class="answerBtn"
                v-if="problemItem.ifAnswer === 1"
                @click="handleJumpAnswerByProblemId(problemItem.problemId)"
            >立即回答
            </view>
          </view>
        </view>
        <view v-else>
          <view class="answer">
            <view class="answerBox">
              <view class="text">答</view><span>暂无答复</span>
            </view>
            <view
                class="answerBtn"
                v-if="problemItem.ifAnswer === 1"
                @click="handleJumpAnswerByProblemId(problemItem.problemId)"
            >立即回答
            </view>
          </view>
        </view>
        <view
            v-if="problemItem.answers.length>1"
            class="seeAll"
            @click="handleJumpAnswerByProblemId(problemItem.problemId)"
        >查看全部答复
        </view>
      </view>
    </view>
  </div>
</template>


<script setup>
import { inject, toRefs } from "vue";
const $jump = inject('$jump')
const props = defineProps({
  problemsList:{
    type:Array,
    default:()=>[]
  },
  productInfo:{
    type:Object,
    default:()=>({})
  }
})
const {problemsList,productInfo} = toRefs(props)
/**
 * 跳转到该商品下所有问答
 */
function handleJumpAllAnswer() {
  const paramObj = Object.assign({},productInfo.value,{
    images: productInfo.value.images[0]
  })
  $jump('/pages_category_page1/goodsModule/answerList',paramObj)
}

/**
 * 跳转到问题的所有回答
 * @param problemId 问答ID
 */
function handleJumpAnswerByProblemId(problemId) {
  const paramObj = Object.assign({}, productInfo.value,{
    questionlength: problemsList.value.length,
    problemId: problemId,
    img: productInfo.value.images[0]
  })
  $jump('/pages_category_page1/goodsModule/qADetail',paramObj)
}
</script>

<style
    lang="scss"
    scoped
>

.listBox {
  padding: 0 30upx;
  //border-bottom: 20upx solid #EEEEEE;

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

      .text {
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

        .text {
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
</style>
