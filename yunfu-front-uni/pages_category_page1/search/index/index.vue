<template>
  <view>
    <!-- 搜索商品 -->
    <view>
      <view class="flex-items-plus flex-row mar-top-20">
        <view class="searchImg-box flex-items-plus">
          <image
              class="searchImg"
              :src="`${VUE_APP_STATIC_URL}static/img/searchImg.png`"
          ></image>
          <input
              class="search-box"
              v-model="keyword"
              placeholder-class="searchboxPlace"
              placeholder="请输入您想要的宝贝"
          />
        </view>
        <view
            class="mar-left-40 fs26"
            @click="searchByKeyword"
        >搜索
        </view>
      </view>
    </view>

    <!-- 热门搜索 -->
    <view class="hotSearchBox tipsBox">
      <view
          class="boxTitle mar-leftgetList-30"
          v-if="hotSearchList.length>0"
      >
        <label class="fs30 font-color-999 fs-weight-300">热门搜索</label>
        <image
            class="seeIcon hotSearchListSee-icon"
            :src="!hideHotFlag ? `${VUE_APP_STATIC_URL}static/img/see.png` : `${VUE_APP_STATIC_URL}static/img/notSee.png`"
            @click="hideHotFlag = !hideHotFlag"
        />
      </view>
      <view
          class="flex-wrap-1 flex-row"
          v-if="!hideHotFlag"
      >
        <view
            v-for="(item, index) in hotSearchList"
            :key="index"
            class="historySearDel-box flex-items-plus mar-right-30"
        >
          <view
              class="boxContent"
              @click="handleClickHistoryOrHot(item)"
          >{{ item }}
          </view>
        </view>
      </view>
      <view
          v-else
          class="notSeeContent"
      >当前热门搜索已隐藏
      </view>
    </view>
    <view
        class="line"
        color="#F3F4F5"
    />

    <!-- 历史搜索 -->
    <view class="historyBox tipsBox">
      <view
          class="boxTitle mar-leftgetList-30"
          v-if="historyList.length>0"
      >
        <label class="fs30 font-color-999 fs-weight-300 ">历史搜索</label>
        <image
            class="historyDel-icon"
            @click="delSearchHistory(1)"
            :src="`${VUE_APP_STATIC_URL}static/img/index/historyDel_icon.png`"
        />
      </view>
      <view class="historySear-box flex-wrap-1 flex-row">
        <view
            v-for="item in historyList"
            :key="item.searchId"
            class="historySearDel-box flex-items-plus flex-sp-between mar-right-30"
        >
          <view
              class="boxContent historyText line1"
              @click="handleClickHistoryOrHot(item.search)"
          >{{ item.search }}
          </view>
          <label class="font-color-DDD fs22 pad-topbot-10 text-align">|</label>
          <view
              class="historyIconBox"
              @click="delSearchHistory(2,item.searchId)"
          >
            <image
                class="historySearDel-icon text-align"
                :src="`${VUE_APP_STATIC_URL}static/img/index/historySearDel_icon.png`"
            />
          </view>
        </view>
      </view>
    </view>

  </view>
</template>

<script setup>
import { ref } from "vue";
import { onShow } from "@dcloudio/uni-app";
import { request } from "@/utils/request";
import API from "@/config/api";
import { useLoading } from "@/hooks/useLoading";
import { VUE_APP_STATIC_URL } from "@/config/api";
const {showLoading,hideLoading} = useLoading()

// ==================================== 搜索相关 ==========================================
const keyword = ref(''); // 搜索关键字
function searchByKeyword() {
  if (!keyword.value) {
    return uni.showToast({
      title: '请输入要搜索内容！',
      duration: 2000,
      icon: 'none'
    });
  }
  uni.navigateTo({
    url: '../../goodsModule/goodsList?keyWord=' + keyword.value,
  })
}

function handleClickHistoryOrHot(key) {
  keyword.value = key
  searchByKeyword()
}

// ==================================== 热门相关 ========================================
const hideHotFlag = ref(false); // 是否隐藏热门
const hotSearchList = ref([]); // 热门搜索

function getHotKeywordList() {
  return request(API.SelectHotSearch, {}, 'GET').then(res => {
    hotSearchList.value = res.data
  })
}

// ==================================== 历史记录 ========================================
const historyList = ref([]); // 历史记录

function getHistoryKeywordList() {
  return request(API.SearchHistory, {}, 'GET').then(res => {
    historyList.value = res.data
  })
}

/**
 * 删除历史记录
 * @param status 1全部 2单条
 * @param searchId
 */
function delSearchHistory(status = 1, searchId = undefined) {
  const tips = status === 1 ? '您确定要清空搜索记录吗？' : '您确定要删除这一条记录吗？'
  uni.showModal({
    title: '温馨提示',
    content: tips,
    confirmText: '确定',
    cancelText: '点错了',
    success: (res) => {
      if (!res.confirm) return
      if (status === 1) {
        request(API.DeleteAllSearch, {}, 'POST').then(res => {
          historyList.value = res.data
        })
      } else {
        request(API.DeleteSearch, {
          searchId: searchId
        }, 'POST').then(res => {
          getHistoryKeywordList()
        })
      }
    }
  })
}

// ========================================== 生命周期 =========================================================
onShow(() => {
    Promise.all([getHotKeywordList(), getHistoryKeywordList()])
})

</script>

<style
    lang="scss"
    scoped
>
input {
  padding-left: 80upx;
}

.searchImg-box {
  .searchImg {
    width: 36upx;
    height: 36upx;
    position: absolute;
    left: 60upx;
  }

  .search-box {
    background-color: #F1F1F1;
    width: 530upx;
    height: 66upx;
  }

  .searchboxPlace {
    font-size: 26upx;
    color: #A9A9A9;
    padding-right: 30upx;
  }

  .searchClose-icon {
    width: 30upx;
    height: 30upx;
    margin-left: -50upx;
    z-index: 99999;
  }
}

// 热门搜索
.hotSearchBox {
  padding: 0 36upx;

  .historyText {
    flex: 1;
  }

  .hotSearchListSee-icon {
    height: 24upx;
  }

  .hotSearchListNotSee-icon {
    height: 36upx;
  }

  .seeIcon {
    width: 40upx;
    position: absolute;
    right: 30upx;
  }

  .notSeeContent {
    margin-top: 20upx;
    text-align: center;
    font-size: 24upx;
    color: #CCCCCC;
  }
}

.line {
  margin: 70upx 0;
  height: 2upx;
  background: #F3F4F5;
}

// 历史搜索
.historyBox {
  padding: 0 36upx;

  .historySear-box {
    width: 100%;
  }

  .historyDel-icon {
    width: 30upx;
    height: 30upx;
    position: absolute;
    right: 30upx;
  }

  .historyIconBox {
    width: 50upx;

    .historySearDel-icon {
      position: relative;
      width: 16upx;
      height: 16upx;
    }
  }
}

.tipsBox {
  padding: 15rpx 24rpx;
}

.boxTitle {
  margin: 30rpx 0;
}

.historySearDel-box {
  height: 54upx;
  line-height: 54upx;
  margin: 15rpx 15rpx;
  background-color: #F1F1F1;
  text-align: center;
  overflow: hidden;

  .boxContent {
    font-size: 28rpx;
    padding: 0 30rpx;
  }
}
</style>
