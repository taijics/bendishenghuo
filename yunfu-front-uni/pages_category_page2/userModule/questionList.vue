<template>
  <view class="question-box u-skeleton">
    <view class="tabsbox">
      <view class="tab-center">
        <u-tabs
            :list="questionTypeList"
            bar-width="140"
            :bold="false"
            active-color="#C5AA7B"
            inactive-color="#999999"
            :is-scroll="false"
            :current="questionTypeFlag"
            @change="questionTypeActive"
        >
        </u-tabs>
      </view>
    </view>
    <Skeleton
        el-color="#efefef"
        bg-color="#F7F7F7"
        :loading="loading && isFirstComeIn"
        :animation="true"
    />
    <view v-if="questionTypeFlag == 0">
      <view v-if="problemList.length>0">
        <view class="wid function-box">
          <view
              class="finishbox"
              @click="finishClick"
              v-if="allCheckShow"
          >完成
          </view>
          <view
              v-else
              class="flex-row-plus editicon-box flex-items fs28"
              @click="editClick"
          >
            <view class="u-skeleton-rect flex-items">
              <image
                  class="editicon"
                  :src="`${VUE_APP_STATIC_URL}static/images/collectionEditicon.png`"
              >
              </image>
              <text class="mar-left-10">编辑</text>
            </view>
          </view>
        </view>
        <view class="swipe-box">
          <u-swipe-action
              :show="item.show"
              :index="index"
              v-for="(item, index) in problemList"
              :key="item.problemId"
              :disabled="allCheckShow"
              ref="problemActionSwipe"
              @click="problemClick"
              :autoClose="false"
              @open="problemOpen"
              :options="options"
          >
            <view
                class="flex-item itemBox u-skeleton-rect"
                @click="goQuestionDetails(item.productId,item.problemId)"
            >
              <view class="item u-border-bottom wid flex-row-plus flex-items">
                <view v-show="allCheckShow">
                  <image
                      mode="aspectFill"
                      v-if="item.selected == 1"
                      @click.stop="problemItemSel(index,0)"
                      :src="`${VUE_APP_STATIC_URL}static/images/selectActive.png`"
                      class="cart-select-img"
                  ></image>
                  <image
                      mode="aspectFill"
                      v-else
                      @click.stop="problemItemSel(index,1)"
                      :src="`${VUE_APP_STATIC_URL}static/images/selectEmpty.png`"
                      class="cart-select-img"
                  ></image>
                </view>
                <!-- <image class="product-img" mode="aspectFill" :src="item.image" />-->
                <!-- 此层wrap在此为必写的，否则可能会出现标题定位错误 -->
                <view class="title-wrap replynum-box">
                  <view class="flex-items">
                    <label>问</label>
                    <text class="title u-line-2 font-weight-bold fs28">{{ item.problem }}</text>
                  </view>
                  <view class="flex-items reply">
                    <label>答</label>
                    <text
                        class="font-color-666 fs24"
                        v-if="item.count>0"
                    >{{ item.count }}条回复
                    </text>
                    <text
                        class="font-color-666 fs24"
                        v-else
                    >暂无回复
                    </text>
                  </view>
                </view>
              </view>
            </view>
            <!-- <view class="borRig-line-20"></view> -->
          </u-swipe-action>
        </view>
        <view
            v-show="allCheckShow"
            class="allcheck-box flex-row-plus flex-sp-between flex-items"
        >
          <view class="left">
            <image
                mode="aspectFill"
                v-if="isAllProblemCheck"
                :src="`${VUE_APP_STATIC_URL}static/images/selectActive.png`"
                class="cart-select-img"
                @click="allProblemSel(0)"
            ></image>
            <image
                mode="aspectFill"
                v-else
                :src="`${VUE_APP_STATIC_URL}static/images/selectEmpty.png`"
                class="cart-select-img"
                @click="allProblemSel(1)"
            ></image>
            <text>全选</text>
          </view>
          <view class="right">
            <view
                class="btn-delete"
                @click="questionDel(0)"
            >删除
            </view>
          </view>
        </view>
        <view
            v-if="allCheckShow"
            class="pad-bot-140"
        ></view>
      </view>
      <view
          v-if="ifEmpty"
          class="empty-box"
      >
        <image
            class="question-empty"
            :src="`${VUE_APP_STATIC_URL}static/img/bgnull.png`"
        ></image>
        <view class="tohome-box flex-items-plus">暂无提问内容</view>
      </view>
    </view>
    <view v-if="questionTypeFlag == 1">
      <view v-if="answerList.length > 0">
        <view
            class="finishbox"
            @click="finishClick"
            v-if="allCheckShow"
        >完成
        </view>
        <view
            v-else
            class="flex-row-plus editicon-box flex-items fs28"
            @click="editClick"
        >
          <image
              class="editicon"
              :src="`${VUE_APP_STATIC_URL}static/images/collectionEditicon.png`"
          >
          </image>
          <text class="mar-left-10">编辑</text>
        </view>
        <view class="swipe-box u-skeleton">
          <u-swipe-action
              :show="item.show"
              :index="index"
              v-for="(item, index) in answerList"
              :key="item.answerId"
              :disabled="allCheckShow"
              ref="answerActionSwipe"
              :autoClose="false"
              @click="answerClick"
              @open="answerOpen"
              :options="options"
          >
            <view
                class="item itemBox u-border-bottom flex-item u-skeleton-rect"
                @click="goQuestionDetails(item.productId,item.problemId)"
            >
              <view
                  class="wid"
                  style="border-radius: 50%;"
              >
                <view class="flex-items-plus flex-row wid">
                  <view v-show="allCheckShow">
                    <image
                        mode="aspectFill"
                        v-if="item.selected == 1"
                        @click.stop="answerItemSel(index,0)"
                        :src="`${VUE_APP_STATIC_URL}static/images/selectActive.png`"
                        class="cart-select-img"
                    ></image>
                    <image
                        mode="aspectFill"
                        v-else
                        @click.stop="answerItemSel(index,1)"
                        :src="`${VUE_APP_STATIC_URL}static/images/selectEmpty.png`"
                        class="cart-select-img"
                    ></image>
                  </view>
                  <!--									<image class="product-img" mode="aspectFill" :src="item.image" />-->
                  <view class="title-wrap replynum-box wid">
                    <view class="flex-items">
                      <label>问</label>
                      <text class="title u-line-2 fs28 font-weight-bold">{{ item.problem }}</text>
                    </view>
                    <view class="replyBox">
                      <view class="flex-items reply">
                        <label>答</label>
                        <text
                            v-if="allCheckShow"
                            style="width: 270rpx;"
                            class="font-color-666 fs24 overflow"
                        >{{ item.name }} :
                          {{ item.answer }}
                        </text>
                        <text
                            v-else
                            style="width: 360rpx;"
                            class="font-color-999 fs24 overflow"
                        >{{ item.name }} :
                          {{ item.answer }}
                        </text>
                      </view>
                      <view class="qAarrow mar-top-30 flex-items">
                        <text class="fs24 font-color-C5AA7B">共{{ item.count }}个回答</text>
                        <image
                            class="item-btn-right"
                            :src="`${VUE_APP_STATIC_URL}static/img/user/arrow.png`"
                            mode="widthFix"
                        ></image>
                      </view>
                    </view>
                  </view>
                </view>
              </view>
            </view>
            <!-- <view class="borRig-line-20"></view> -->
          </u-swipe-action>
        </view>
        <view
            v-show="allCheckShow"
            class="allcheck-box flex-row-plus flex-sp-between flex-items"
        >
          <view class="left">
            <image
                mode="aspectFill"
                v-if="isAllAnswerCheck"
                :src="`${VUE_APP_STATIC_URL}static/images/selectActive.png`"
                class="cart-select-img"
                @click="allAnswerSel(0)"
            ></image>
            <image
                mode="aspectFill"
                v-else
                :src="`${VUE_APP_STATIC_URL}static/images/selectEmpty.png`"
                class="cart-select-img"
                @click="allAnswerSel(1)"
            ></image>
            <text>全选</text>
          </view>
          <view class="right">
            <view
                class="btn-delete"
                @click="questionDel(1)"
            >删除
            </view>
          </view>
        </view>
        <view
            v-if="allCheckShow"
            class="pad-bot-140"
        ></view>
      </view>
      <view
          v-if="ifEmpty"
          class="empty-box"
      >
        <image
            class="question-empty"
            :src="`${VUE_APP_STATIC_URL}static/img/bgnull.png`"
        ></image>
        <view class="tohome-box flex-items-plus">暂无问答内容</view>
      </view>
    </view>
    <!-- <u-popup v-model="delshow" class="" mode="center" border-radius="14">
      <view class="pad-topbot-50 del-box flex-items-plus flex-column-plus">
        <label class="font-weight-bold font-color-222 fs36">删除回答？</label>
        <label class="fs28 font-color-222 mar-top-50">删除回答后无法恢复</label>
        <view class="flex-row-plus mar-top-60">
          <view class="del-but" @click="delClick">继续删除</view>
        </view>
      </view>
      <view class="cancel-but" @click="cancelClick">
        <image :src="`${VUE_APP_STATIC_URL}static/images/cancelClose.png`" mode=""></image>
      </view>
    </u-popup> -->
    <!-- 删除确认弹窗 -->
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
    <tui-modal
        :show="delshow"
        :custom="true"
        :fadein="true"
    >
      <view class="Put-box1">
        <view class="text-align fs34 fs-bold">
          删除回答？
        </view>
        <view class="mar-top-40 text-align">
          删除回答后无法恢复
        </view>
        <view class="flex-display flex-sp-between">
          <view
              class="btn submit"
              @click="delClick"
          >继续删除
          </view>
        </view>
      </view>
      <view
          @click="cancelClick"
          class="cancelDel"
      >
        <image
            :src="`${VUE_APP_STATIC_URL}static/images/cancelClose.png`"
            mode=""
        ></image>
      </view>
    </tui-modal>
    <!-- 回到顶部 -->
    <ReturnTop :returnTopFlag="returnTopFlag" />
  </view>
</template>

<script setup>
import { request } from "@/utils/request";
import API from "@/config/api";
import {onLoad, onPageScroll, onReachBottom} from "@dcloudio/uni-app";
import { inject,ref } from "vue";
import TuiModal from "@/components/modal/modal.vue";
import Skeleton from "@/components/Skeleton/index.vue";
import { VUE_APP_STATIC_URL } from "@/config/api";

const questionTypeList = ref([{
  name: '我的提问(0)'
}, {
  name: '我的回答(0)'
}])

const loading = ref(false);
const isFirstComeIn = ref(true);
const questionTypeFlag = ref(0)
const noMore = ref(false); // 没有更多数据显示隐藏
const disabled = ref(false)
const btnWidth = ref(180)
const show = ref(false)
const options = ref([{
  text: ' ',
  style: {
    backgroundColor: '#C83732'
  }
}])
const isAllProblemCheck = ref(false)
const isAllAnswerCheck = ref(false)
const allCheckShow = ref(false)
const delshow = ref(false)
const problemPage = ref(1)
const problemPageSize = ref(10)
const proloadingType = ref(0)
const topLeft = ref(0); // 无更多数据显示距离
const returnTopFlag = ref(false); // 返回顶部显示隐藏
const total = ref(0)
const problemList = ref([])
const answerList = ref([])
const answerPage = ref(1)
const answerPageSize = ref(10)
const answerloadingType = ref(0)
const delType = ref(0)
const ifEmpty = ref(false)

onLoad(() => {
  getProblemList()
  getAnswerList()
})


onReachBottom(() => {
  if (questionTypeFlag.value == 0) {
    if (proloadingType.value == 1) {
      uni.stopPullDownRefresh()
    } else {
      problemPage.value = problemPage.value + 1
      getProblemList()
    }
  } else if (questionTypeFlag.value == 1) {
    if (answerloadingType.value == 1) {
      uni.stopPullDownRefresh()
    } else {
      answerPage.value = answerPage.value + 1
      getAnswerList()
    }
  }
})

const $jump = inject('$jump')

function goQuestionDetails(productId, problemId) {
  let data = {
    productId: productId,
    problemId: problemId
  }
  $jump('/pages_category_page1/goodsModule/qADetail', data)
}

// 确定批量删除
function delClick() {
  delshow.value = false
  if (delType.value == 0) {
    problemPage.value = 1
    problemPageSize.value = 10
    problemDel()
  } else if (delType.value == 1) {
    answerPage.value = 1
    answerPageSize.value = 10
    answerDel()
  }
}

//批量删除
function problemDel() {
  let ids = []
  problemList.value.forEach((value, index) => {
    if (value.selected == 1) {
      ids.push(value.problemId)
    }
  })
  request(API.deleteProblem, {
    ids: ids
  }, 'POST').then(res => {
    problemList.value = []
    uni.showToast({
      icon: 'none',
      title: '删除成功'
    })
    getProblemList()
  })
}

function answerDel() {
  let ids = []
  answerList.value.forEach((value, index) => {
    if (value.selected == 1) {
      ids.push(value.answerId)
    }
  })
  request(API.deleteAnswer, {
    ids: ids
  }, 'POST').then(res => {
    answerList.value = []
    uni.showToast({
      icon: 'none',
      title: '删除成功'
    })
    getAnswerList()
  })
}


//全选
function allProblemSel(type) {
  isAllProblemCheck.value = !isAllProblemCheck.value
  problemList.value.forEach((value, index) => {
    problemList.value[index].selected = type
  })
}

function allAnswerSel(type) {
  isAllAnswerCheck.value = !isAllAnswerCheck.value
  answerList.value.forEach((value, index) => {
    answerList.value[index].selected = type
  })
}

//单个选中
function problemItemSel(index, number) {
  problemList.value[index].selected = number
  let proSelectNum = 0
  problemList.value.forEach((value, index) => {
    if (problemList.value[index].selected == 0) {
      isAllProblemCheck.value = false
    } else {
      proSelectNum++
    }
  })
  if (problemList.value.length == proSelectNum) {
    isAllProblemCheck.value = true
  }
}

function answerItemSel(index, number) {
  answerList.value[index].selected = number
  let ansSelectNum = 0
  answerList.value.forEach((value, index) => {
    if (answerList.value[index].selected == 0) {
      isAllAnswerCheck.value = false
    } else {
      ansSelectNum++
    }
  })
  if (answerList.value.length == ansSelectNum) {
    isAllAnswerCheck.value = true
  }
}

//删除提问
function problemClick(index, index1) {
  if (index1 == 0) {
    let ids = problemList.value[index].problemId
    request(API.deleteProblem, {
      ids: [ids]
    }, 'POST').then(res => {
      problemPage.value = 1
      problemList.value = []
      proloadingType.value = 0
      getProblemList()
      uni.showToast({
        title: '删除成功',
        icon: "none"
      })
    })
  }
}

//删除回答
function answerClick(index, index1) {
  if (index1 == 0) {
    let ids = answerList.value[index].answerId
    request(API.deleteAnswer, {
      ids: [ids]
    }, 'POST').then(res => {
      answerPage.value = 1
      answerList.value = []
      answerloadingType.value = 0
      getAnswerList()
      uni.showToast({
        title: '删除成功',
        icon: "none"
      })
    })
  }
}

function problemOpen(index) {
  problemList.value[index].show = true;
  problemList.value.map((val, idx) => {
    if (index != idx) problemList.value[idx].show = false;
  })
}

function answerOpen(index) {
  answerList.value[index].show = true;
  answerList.value.map((val, idx) => {
    if (index != idx) answerList.value[idx].show = false;
  })
}

//我的提问列表
function getProblemList() {
  loading.value = true
  request(API.getProblemList, {
        page: problemPage.value,
        pageSize: problemPageSize.value
      },
      'GET').then(res => {
    let listNum = res.data.total
    total.value = res.data.total
    questionTypeList.value[0].name = '我的提问(' + listNum + ')'
    if (res.data.list.length === 0) {
      proloadingType.value = 1
      problemPage.value = problemPage.value
    } else {
      problemList.value = problemList.value.concat(res.data.list).filter(item => JSON.stringify(item) !== '{}')
    }
    if (problemList.value.length >= total.value) {
      proloadingType.value = 1
      noMore.value = true
    }
    if (problemList.value.length === 0) {
      ifEmpty.value = true
    } else {
      ifEmpty.value = false
    }
    isFirstComeIn.value = false
    loading.value = false
  }).catch(res => {
    uni.showToast({
      title: '我的提问查询失败',
      icon: "none"
    })
  })
}

//我的回答列表
function getAnswerList() {
  loading.value = true
  request(API.getAnswerList, {
        page: answerPage.value,
        pageSize: answerPageSize.value
      },
      'GET').then(res => {
    uni.hideLoading()
    let listNum = res.data.total
    total.value = res.data.total
    questionTypeList.value[1].name = '我的回答(' + listNum + ')'
    if (res.data.list.length == 0) {
      answerloadingType.value = 1
      answerPage.value = answerPage.value
    } else {
      answerList.value = answerList.value.concat(res.data.list).filter(item => JSON.stringify(item) !== '{}')
    }
    if (answerList.value.length >= total.value) {
      answerloadingType.value = 1
      noMore.value = true
    }
    if (answerList.value.length === 0) {
      ifEmpty.value = true
    } else {
      ifEmpty.value = false
    }
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

function questionTypeActive(index) {
  ifEmpty.value = false
  questionTypeFlag.value = index
  allCheckShow.value = false
  isAllAnswerCheck.value = false
  isFirstComeIn.value = true
  noMore.value = false
  if (index == 0) {
    problemPage.value = 1
    problemList.value = []
    proloadingType.value = 0
    getProblemList()
  } else if (index == 1) {
    answerPage.value = 1
    answerList.value = []
    answerloadingType.value = 0
    getAnswerList()
  }
}

const problemActionSwipe = ref()
const answerActionSwipe = ref()

function editClick() {
  allCheckShow.value = true
  let problemActionSwipe = problemActionSwipe.value
  let answerActionSwipe = answerActionSwipe.value
  if (problemActionSwipe) {
    problemActionSwipe.forEach(item => item.close())
  }
  if (answerActionSwipe) {
    answerActionSwipe.forEach(item => item.close())
  }
}

function finishClick() {
  allCheckShow.value = false
}

function cancelClick() {
  delshow.value = false
}

function questionDel(num) {
  let quNum = 0
  let anNum = 0
  problemList.value.forEach((value, index) => {
    if (problemList.value[index].selected == 1) {
      quNum++
    }
  })
  answerList.value.forEach((value, index) => {
    if (answerList.value[index].selected == 1) {
      anNum++
    }
  })
  if (num == 0) {
    if (quNum < 1) {
      uni.showToast({
        title: '至少选择一条提问！',
        icon: "none"
      })
    } else {
      delType.value = num
      delshow.value = true
    }
  } else {
    if (anNum < 1) {
      uni.showToast({
        title: '至少选择一条回答！',
        icon: "none"
      })
    } else {
      delType.value = num
      delshow.value = true
    }
  }
}
onPageScroll(e => {
  returnTopFlag.value = e.scrollTop > 600;
  topLeft.value = e.scrollTop
})
</script>


<style lang="scss">
page {
  background-color: #F7F7F7;
}

.question-box {
  .empty-box {
    display: flex;
    justify-content: center;
    flex-direction: column;
    align-items: center;
    padding-top: 40%;

    .tohome-box {
      color: #999999;
      margin-top: 50rpx;
    }

    .question-empty {
      width: 198rpx;
      height: 183rpx;
    }
  }

  .Put-box1 {
    .btn {
      text-align: center;
      margin-top: 40rpx;
      border: 1px solid #333333;
      height: 80upx;
      line-height: 80upx;
      width: 100%;
      color: #333333;
    }

    .submit {
      background-color: #333333;
      color: #FFEBC4;
    }
  }

  .cancelDel {
    position: absolute;
    bottom: -50px;
    left: 45%;

    image {
      width: 60upx;
      height: 60upx;

    }
  }

  .function-box {
    background-color: #F7F7F7;
  }

  .tabsbox {
    margin-top: 4rpx;
    background-color: #FFFFFF;
    padding: 0 24rpx;
    position: relative;
    z-index: 9999;
  }

  .editicon-box {
    display: flex;
    justify-content: flex-end;
    position: relative;
    left: -30rpx;
    padding: 16rpx 0;
  }

  .finishbox {
    display: flex;
    justify-content: flex-end;
    position: relative;
    left: -30rpx;
    padding: 16rpx 0;
  }

  .editicon {
    width: 50rpx;
    height: 50rpx;
  }

  .swipe-box {
    width: 100%;
    padding: 0 24rpx;

    .itemBox {
      background: #FFFFFF;
    }

    .replynum-box {
      display: flex;
      flex-direction: column;
      justify-content: space-between;
      padding: 10rpx 0;

      .item-btn-right {
        margin-left: 15rpx;
        width: 14upx;
        height: 24upx !important;
      }
    }

    .item {
      display: flex;
      padding: 20rpx 20rpx 20rpx 40rpx;
      width: 700rpx;

      .qAarrow {
        image {
          width: 16rpx;
          height: 24rpx;
          margin-left: 10rpx;
        }
      }
    }

    .product-img {
      width: 180rpx;
      flex: 0 0 180rpx;
      height: 180rpx;
    }

    .head-img {
      width: 80rpx;
      flex: 0 0 80rpx;
      height: 80rpx;
      border-radius: 50%;
    }

    label {
      width: 36rpx;
      height: 36rpx;
      display: block;
      line-height: 36rpx;
      text-align: center;
      background: #C83732;
      color: #FFFFFF;
      font-size: 20rpx;
      margin-right: 20rpx;
    }

    .replyBox {
    }

    .reply {
      margin-top: 20rpx;

      label {
        background: #C5AA7B;
      }
    }

    .title {
      text-align: left;
      font-size: 28rpx;
      color: $u-content-color;
    }

    .cart-select-img {
      width: 40upx;
      height: 40upx;
      margin: 0upx 30upx 0upx 0upx;
      box-sizing: border-box;
    }

    .toStore {
      border: 1rpx #C5AA7B solid;
      color: #C5AA7B;
      padding: 0rpx 20rpx;
      border-radius: 5rpx;
      height: 52rpx;
    }
  }

  .allcheck-box {
    background-color: #FFFFFF;
    width: 100%;
    position: fixed;
    bottom: 0upx;

    .left {
      display: flex;
      flex-direction: row;
      align-items: center;
      font-size: 28upx;
      color: #666;

      .cart-select-img {
        width: 40upx;
        height: 40upx;
        margin: 30upx;
        box-sizing: border-box;
      }
    }

    .right {
      display: flex;
      flex-direction: row;
      align-items: center;
      box-sizing: border-box;
    }

    .btn-delete {
      width: 230upx;
      height: 100upx;
      line-height: 100upx;
      text-align: center;
      font-size: 30upx;
      color: #FFFFFF;
      background: #C83732;
    }
  }
}
</style>
<style lang="scss">
@import "../../style/images";
.question-box ::v-deep .u-tabs #u-tab-item-0 {
  position: relative;
}

.question-box ::v-deep .u-tabs #u-tab-item-0:before {
  content: '';
  display: block;
  width: 2rpx;
  height: 30rpx;
  position: absolute;
  right: 0;
  top: 25rpx;
  background: #CCCCCC;
}

.swipe-box ::v-deep .u-swipe-del {
  align-items: center;
  justify-content: center;
  width: 120rpx !important;
}

.swipe-box ::v-deep .u-btn-text {
  width: 60rpx;
  height: 60rpx;
  display: block;
  background: $delIcon no-repeat center center;
  background-size: contain;
}

.swipe-box ::v-deep .u-swipe-action {
  background: none !important;
  margin-bottom: 20rpx;
}
</style>
