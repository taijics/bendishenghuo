<template>
  <div class="category">
    <div class='banxin'>
      <div class='head'>
        <div class='all'>全部结果</div>
        <i class="el-icon-arrow-right" />
        <div class='keyword'>{{classifyName}}</div>
<!--         <i v-if="classifyName" class="el-icon-arrow-right" />-->
      </div>
      <img class="banner" v-if="classifyBanner !== ''" :src="classifyBanner" alt="">
      <div class="content">
        <div class='sort'>
          <div>排序：</div>
          <div class='default' :class="index=='1'?'active':''" @click="defaultSort()">默认</div>
          <div class='price' :class="index=='2'?'active':''" @click="priceSort()">
              价格
              <div class='arr'>
                <div class='up' :class="type==1?'low':''"></div>
                <div class='down' :class="type==2?'high':''"></div>
              </div>
          </div>
          <div class='sales' :class="index=='3'?'active':''" @click="salesSort()">
              销量
              <div class='arr'>
                <div class='up' :class="index=='3' && volume==1?'low':''"></div>
                <div class='down' :class="index=='3' && volume==2?'high':''"></div>
              </div>
          </div>
        </div>
        <div class="proList" v-loading="loading">
            <div v-if="noProduct==false">
              <h3 style="margin-bottom:80px;margin-top:50px;">{{classifyName}}</h3>
              <ProductList :productList='productList'></ProductList>
            </div>
            <div v-else class="noproduct">
              <icon-svg style="width: 240px; height: 240px; margin-bottom: 20px;" icon-class="user-order-nodata" />
              <p class="fs20 font-color-999">该分类没有商品～</p>
            </div>
        </div>
        <el-pagination
          v-if="noProduct==false"
          :current-page="page"
          :page-size="12"
          @current-change="handleCurrentChange"
          background
          layout='prev, pager, next' :total='total'>
        </el-pagination>
      </div>
    </div>
  </div>
</template>
<script>
import ProductList from '@/components/base/productList'
import {
  getClaasifyProducts
} from '@/api/product.js'
export default {
  components: {
    ProductList
  },
  data () {
    return {
      page: 1,
      index: '1',
      type: '',
      volume: '',
      total: 0,
      classifyId: 0,
      classifyName: '',
      noProduct: false,
      productList: [],
      classifyBanner: '',
      loading: false
    }
  },
  mounted () {
    var classifyData = JSON.parse(this.$route.query.classifyData)
    this.classifyBanner = classifyData.classifyImage
    this.classifyName = classifyData.categoryName || classifyData.classifyName
    this.classifyId = classifyData.id || classifyData.classifyId
    this.getClaasifyProducts()
  },
  methods: {
    // 获取分类商品
    async getClaasifyProducts () {
      this.loading = true
      const response = await getClaasifyProducts({
        classifyId: this.classifyId,
        type: this.type,
        volume: this.volume,
        page: this.page,
        pageSize: '12'
      })
      const res = response.data
      if (res.code === '200') {
        // console.log(res)
        this.productList = res.data.list
        this.total = res.data.total
        if (res.data.list.length < 1) {
          this.noProduct = true
        } else {
          this.noProduct = false
        }
        this.loading = false
      } else {
          this.$message({
            message: res.message,
            type: 'warning'
          })
        }
    },
    // 分页器跳转
    handleCurrentChange (val) {
      this.page = val
      this.getClaasifyProducts()
    },
    // 默认排序
    defaultSort () {
      this.type = ''
      this.volume = ''
      this.index = '1'
      this.page = 1
      this.getClaasifyProducts()
    },
    // 价格排序
    priceSort () {
      if (this.type !== 1) {
        this.type = 1
      } else {
        this.type = 2
      }
      this.page = 1
      this.volume = ''
      this.index = '2'
      this.getClaasifyProducts()
    },
    // 销量排序
    salesSort () {
      if (this.volume !== 1) {
        this.volume = 1
      } else {
        this.volume = 2
      }
      this.page = 1
      this.type = ''
      this.index = '3'
      this.getClaasifyProducts()
    }
  }
}
</script>
<style lang="scss" scoped>
.category{
    width: 100%;
  height: 100%;
  background-color: #f0f0f0;
  padding-bottom: 143px;
  text-align: center;
  .banxin {
    width: 1252px;
    height: 100%;
    margin: 0 auto;
    .head {
      width: 100%;
      height: 64px;
      line-height: 64px;
      font-size: 16px;
      display: flex;
      align-items: center;
      .all {
        margin-right: 20px;
      }
      .keyword {
        margin: 0 20px;
        color: #C83732;
      }
    }
    .banner{
        width: 100%;
        height: 356px;
        margin-bottom: 25px;
    }
    .content{
      background-color: #FFFFFF;
      width: 100%;
      padding: 0 45px 30px;
      box-sizing: border-box;
      .sort {
        width: 100%;
        height: 63px;
        line-height: 27px;
        display: flex;
        align-items: center;
        border-bottom: 1px solid #f1f1f1;
        color: #666666;
        .default {
          margin-left: 20px;
          cursor: pointer;
        }
        .sales {
          display: flex;
          cursor: pointer;
          // img{
          //   width: 9px;
          //   height: 16px;
          //   vertical-align: middle;
          // }
        }
        .price {
          display: flex;
          margin: 0 20px;
          cursor: pointer;
        }
        .arr {
          vertical-align: middle;
          width: 12px;
          margin-left: 3px;
          .up {
            width: 0;
            height: 0;
            border: 6px solid transparent;
            border-bottom-color: #999999;
          }
          .down {
            width: 0;
            height: 0;
            border: 6px solid transparent;
            border-top-color: #999999;
            margin-top: 3px;
          }
        }
        .active{
          color: #C83732;
          .arr{
            .high{
              border-top-color: #C83732;
            }
            .low{
              border-bottom-color: #C83732;
            }
          }
        }
      }
      h3{
          font-size: 24px;
          font-weight: bold;
          margin-bottom: 30px;
      }
      .noproduct{
          width: 100%;
          text-align: center;
          padding: 200px 0;
      }
      >>>.el-pagination{
        text-align: right;
        .el-pager{
          li:not(.disabled):hover{
            color: $mainGlod;
          }
          li:not(.disabled).active{
            background-color: $mainGlod;
          }
          li:not(.disabled).active:hover{
            color: #F4F4F5;
          }
        }
      }
    }
  }
  .proList{
    min-height: 500px;
  }
}
</style>
