<template>
  <div class="evaluationBox">
    <div class="evaluateType"  v-if="evaluateTotal > 0">
      <span :class="{typeActive: currentType === 0}" @click="changeEvaType('全部', 0)">
        全部（{{evaluateTotal}}
      </span>
      <span
        :class="{typeActive: currentType === index + 1}"
        v-for="(item, index) of evaluateParam.words"
        :key="item.keyWord"
        @click="changeEvaType(item, index + 1)"
      >{{item.keyWord}}（{{item.count}}）</span>
    </div>
    <div class="evaluateList" v-if="evaluateTotal > 0">
      <div class="evaluateItem" v-for="(item) of evaluateList.list" :key="item.commentId">
        <div class="leftAvatarBox">
          <img :src="item.headImage" alt="">
          <span>{{item.name}}</span>
        </div>
        <div class="evaluateInfo">
          <p>{{item.comment}}</p>
          <div class="evaluateImgList">
            <div class="imgItemBox" v-for="(imgItem, index) of item.images" :key="index">
              <el-image
                style="width: 100px; height: 100px"
                :src="imgItem"
                :preview-src-list="[imgItem]">
              </el-image>
            </div>
          </div>
          <div class="evaluateTime">{{item.createTime}}</div>
          <div class="addToEvaInfo" v-if="item.addComment">
            <span>{追加评论}</span>
            <span>{{item.addComment}}</span>
          </div>
          <div class="evaluateImgList">
            <div class="imgItemBox" v-for="(imgItem, index) of item.addImages" :key="index">
              <el-image
                style="width: 100px; height: 100px"
                :src="imgItem"
                :preview-src-list="[imgItem]">
              </el-image>
            </div>
          </div>
          <div class="receiptTime" v-if="item.day">确认收货后{{item.day}}天追加</div>
        </div>
      </div>
      <el-pagination
        class="evaluationPage"
        background
        layout="prev, pager, next, jumper"
        :page-size="5"
        :current-page="listPage"
        @current-change="handleCurrentChange"
        :total="pageTotal">
      </el-pagination>
    </div>
    <div class="nodata" v-else>
      <icon-svg
        style="width: 240px; height: 240px; margin-bottom: 20px"
        icon-class="user-wenda-nodata"
      />
      <p>暂无评论信息~~</p>
    </div>
  </div>
</template>

<script>
import {
  getProductEvaluate
} from '@/api/user/evaluate.js'
export default {
  name: 'evaluation',
  props: {
    evaluateParam: {
      type: Object,
      default: () => ({})
    }
  },
  data () {
    return {
      productId: 0,
      evaluateTotal: 0,
      evaluateList: [],
      currentType: 0,
      listPage: 1,
      currentWord: '全部',
      pageTotal: 0
    }
  },
  watch: {
    'evaluateParam.productId': {
      handler (nVal, oVal) {
        if (nVal !== this.productId) {
          this.productId = nVal
          this.getEvaluateList()
        }
      }
    }
  },
  mounted () {
    this.getEvaluateList()
  },
  methods: {
    // 获取商品评价列表
    async getEvaluateList () {
      if (!this.evaluateParam.productId) { return }
      const response = await getProductEvaluate({
          productId: this.evaluateParam.productId,
          word: this.currentWord === '全部' ? '' : this.currentWord,
          page: this.listPage,
          pageSize: 5
        })
      const res = response.data
      if (res.code === '200') {
        this.evaluateList = res.data // 商品评论
        if (this.currentWord === '全部') {
          this.evaluateTotal = res.data.total
        }
        this.pageTotal = res.data.total
      } else {
        this.$message.warning(res.message)
      }
    },
    // 切换评价类型
    changeEvaType (item, index) {
      this.listPage = 1
      this.currentType = index
      this.currentWord = item
      // console.log(this.currentWord, 'currentWord')
      this.getEvaluateList()
    },
    // 翻页
    handleCurrentChange (val) {
      this.listPage = val
      this.getEvaluateList()
    }
  }
}
</script>

<style lang="scss" scoped>
.evaluationBox {
  .evaluateType {
    display: flex;
    span {
      height: 36px;
      line-height: 36px;
      width: 120px;
      border-radius: 18px;
      text-align: center;
      font-size: 14px;
      color: #333333;
      font-weight: 400;
      margin-right: 20px;
      cursor: pointer;
    }
    .typeActive {
      color: $mainGlod;
    }
  }
  .evaluateList {
    .evaluateItem {
      padding: 20px;
      margin-bottom: 15px;
      display: flex;
      .leftAvatarBox {
        width: 100px;
        float: left;
        text-align: center;
        margin-right: 20px;
        img {
          width: 64px;
          height: 64px;
        }
        span {
          margin-top: 10px;
          color: #333333;
          font-size: 16px;
          display: block;
        }
      }
      .evaluateInfo {
        flex: 1;
        background-color: #FAFAFA;
        font-size: 16px;
        padding: 25px;
        p {
          line-height: 25px;
          color: #333333;
        }
        .evaluateTime {
          color: #999999;
        }
        .addToEvaInfo {
          padding-top: 20px;
          border-top: 1px solid #E5E5E5;
          display: flex;
          span {
            color: #999999;
            font-size: 16px;
            line-height: 25px;
          }
          span:nth-child(1) {
            margin-right: 15px;
          }
          span:nth-child(2) {
            flex: 1;
            color: #333333;
          }
        }
        .receiptTime {
          color: #999999;
          font-size: 16px;
        }
      }
      .evaluateImgList {
        display: flex;
        margin-bottom: 20px;
        .imgItemBox {
          width: 100px;
          height: 100px;
          background: #EEEEEE;
          display: flex;
          align-items: center;
          margin-right: 20px;
          overflow: hidden;
          img {
            width: 100%;
          }
        }
      }
    }
  }
  .evaluationPage {
    margin-top: 30px;
  }
  .nodata{
    text-align: center;
  }
}
</style>
