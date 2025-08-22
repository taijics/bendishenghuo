<template>
  <div class="attentionds">
    <div class="attentiondsTit">
      <div class="attentionBox">
        <div class="">
          <div class="searchRight">
            <span v-if="!edit" class="batch" @click="showEdit">批量管理</span>
            <div v-else class="saveList">
              <el-checkbox v-model="selectAll" @change="changeChecked" :true-label='1' :false-label='0'>全选</el-checkbox>
              <span class="delete" @click="cancelFun">取消收藏</span>
              <span class="save" @click="saveList">保存</span>
            </div>
            <input v-if="activeName==='commodity'" type="text" v-model="keyword" @keyup.enter="searchPro" placeholder="请输入搜索商品">
            <input v-else type="text" v-model="keyword" @keyup.enter="searchPro" placeholder="请输入搜索店铺">
            <span class="searchBtn" @click="searchPro">
              <icon-svg icon-class="search" />
            </span>
          </div>
        </div>
      </div>
      <el-tabs v-model="activeName" @tab-click="handleClick">
        <el-tab-pane label="收藏的商品" name="commodity">
          <div class="list sub-main" v-if="flag" v-loading="loading">
            <div class="attentiondsList">
              <div class="listBox">
                <div class="attentiondsItem" v-for="(item,index) of attentiondList" :key="item.collectId" :class="{selected: item.selected === 1, edit: edit}"  @click="selectPro(index,item.selected)">
                  <div class="mc" v-if="edit"></div>
                  <div class="imgBox" :class="{offShelf: item.shelveState === 0}">
                    <div class="tipText" v-if="item.shelveState === 0">
                      <span>已下架</span>
                    </div>
                    <img :src="item.image" alt="">
                  </div>
                  <div class="info">
                    <h3 class="overflow">{{ item.productName }}</h3>
                    <span class="price">¥{{ item.price }}</span>
                  </div>
                  <div class="btnBox">
                    <span @click="cancelSingle(item.collectId)">取消收藏</span>
                    <span @click="toProductDetail(item)">查看详情</span>
                  </div>
                </div>
                <div class="clearfix"></div>
              </div>
            </div>
            <el-pagination
              v-if="attentiondList.length>0"
              background
              layout="prev, pager, next, jumper"
              :page-size="10"
              :current-page="page"
              @current-change="handleCurrentChange"
              :total="total">
            </el-pagination>
          </div>
          <div class="nothing sub-main" v-else>
            <icon-svg style="width: 240px; height: 240px; margin-bottom: 20px;" icon-class="user-favorite-nodata" />
            <p class="fs20 font-color-999">你还没有收藏的商品～</p>
          </div>
        </el-tab-pane>
        <el-tab-pane label="收藏的店铺" name="shop">
          <div class="list sub-main" v-if="flag" v-loading="loading">
            <div class="attentiondsList">
              <div class="listBox">
                <div class="attentiondsItem" v-for="(item,index) of shopList" :key="item.id" :class="{selected: item.selected === 1, edit: edit}"  @click="selectShop(index,item.selected)">
                  <div class="mc" v-if="edit"></div>
                  <div class="imgBox">
                    <img :src="item.shopLogo" alt="">
                  </div>
                  <div class="info">
                    <h3>{{ item.shopName }}</h3>
                  </div>
                  <div class="btnBox">
                    <span @click="cancelSingle(item.collectId)">取消收藏</span>
                    <span @click="toStore(item.shopId)">进入店铺</span>
                  </div>
                </div>
                <div class="clearfix"></div>
              </div>
            </div>
            <el-pagination
              v-if="shopList.length>0"
              background
              layout="prev, pager, next, jumper"
              :page-size="10"
              :current-page="page"
              @current-change="handleCurrentChange"
              :total="total">
            </el-pagination>
          </div>
          <div class="nothing sub-main" v-else>
            <icon-svg style="width: 240px; height: 240px; margin-bottom: 20px;" icon-class="user-favorite-nodata" />
            <p class="fs20 font-color-999">你还没有收藏的店铺～</p>
          </div>
        </el-tab-pane>
      </el-tabs>
    </div>
  </div>
</template>

<script>
import {
  getCollectShop,
  getCollectProduct,
  cancelCollect
} from '@/api/user/user.js'
export default {
  name: 'favorites',
  data () {
    return {
      page: 1,
      pageSize: 10,
      total: 0,
      edit: false,
      attentiondChecked: 0,
      selectAll: 0,
      activeName: 'commodity',
      keyword: '',
      attentiondList: [],
      shopList: [],
      flag: true,
      loading: false
    }
  },
  mounted () {
    this.getAllProduct()
  },
  methods: {
    // 收藏店铺查询
    async getAllShop () {
      this.loading = true
      const response = await getCollectShop({
        page: this.page,
        pageSize: this.pageSize,
        search: this.keyword
      })
      const res = response.data
      if (res.code === '200') {
        this.shopList = res.data.list
        this.total = res.data.total
        this.flag = res.data.list.length > 0
        this.loading = false
      } else {
        this.$message.warning(res.message)
      }
    },
    // 收藏商品查询
    async getAllProduct () {
      const response = await getCollectProduct({
        page: this.page,
        pageSize: this.pageSize,
        search: this.keyword
      })
      const res = response.data
      if (res.code === '200') {
        this.attentiondList = res.data.list
        this.total = res.data.total
        this.flag = res.data.list.length > 0
        this.loading = false
      } else {
        this.$message.warning(res.message)
      }
    },
    handleCurrentChange (val) {
      this.page = val
      if (this.activeName === 'commodity') {
        this.getAllProduct()
      } else {
        this.getAllShop()
      }
    },
    saveList () {
      if (this.activeName === 'commodity') {
        this.attentiondList.forEach(i => {
          this.$set(i, 'selected', 0)
        })
      } else {
        this.shopList.forEach(i => {
          this.$set(i, 'selected', 0)
        })
      }
      this.selectAll = 0
      this.edit = false
    },
    handleClick () {
      this.page = 1
      this.keyword = ''
      this.edit = false
      this.selectAll = 0
      if (this.activeName === 'commodity') {
        this.getAllProduct()
      } else {
        this.getAllShop()
      }
    },
    // 跳转到商品详情
    toProductDetail (item) {
      let data = {
        shopId: item.shopId,
        skuId: item.skuId,
        productId: item.productId
      }
      this.$router.push({
        path: '/productDetail',
        query: {
          proData: JSON.stringify(data)
        }
      })
    },
    // 跳转到店铺
    toStore (id) {
      this.$router.push({
        path: '/store', query: {shopId: id}
      })
    },
    // 商品单个选中
    selectPro (index, selected) {
      if (selected === 1) {
        this.attentiondList[index].selected = 0
      } else {
        this.attentiondList[index].selected = 1
      }
      this.selectAll = 1
      this.attentiondList.map(item => {
        if (item.selected === 0) {
          this.selectAll = 0
        }
      })
    },
    // 店铺单个选中
    selectShop (index, selected) {
      if (selected === 1) {
        this.shopList[index].selected = 0
      } else {
        this.shopList[index].selected = 1
      }
      this.selectAll = 1
      this.shopList.map(item => {
        if (item.selected === 0) {
          this.selectAll = 0
        }
      })
    },
    // 全选
    changeChecked () {
      if (this.activeName === 'commodity') {
        this.attentiondList.forEach(i => {
          this.$set(i, 'selected', this.selectAll)
        })
        console.log(this.attentiondList)
      } else {
        this.shopList.forEach(i => {
          this.$set(i, 'selected', this.selectAll)
        })
        console.log(this.shopList)
      }
    },
    // 批量管理
    showEdit () {
      if (this.activeName === 'commodity') {
        if (this.attentiondList.length === 0) {
          return
        }
      } else {
        if (this.shopList.length === 0) {
          return
        }
      }
      this.edit = true
    },
    // 搜索
    searchPro () {
      this.page = 1
      if (this.activeName === 'commodity') {
        this.getAllProduct()
      } else {
        this.getAllShop()
      }
    },
    // 取消收藏请求
    async unfavorite (ids) {
      const response = await cancelCollect({ ids: ids })
      const res = response.data
      if (res.code === '200') {
        this.$message.success('取消成功')
        this.edit = false
        if (this.activeName === 'commodity') {
          this.getAllProduct()
        } else {
          this.getAllShop()
        }
      }
    },
    // 取消单个收藏
    cancelSingle (id) {
      let ids = [id]
      this.unfavorite(ids)
    },
    // 取消选中收藏
    cancelFun () {
      let flag2 = false
      let ids = []
      if (this.activeName === 'commodity') {
        this.attentiondList.forEach(item => {
          if (item.selected === 1) {
            flag2 = true
            ids.push(item.collectId)
          }
        })
        if (flag2 === false) {
          return this.$message.warning('请先选择需要取消的收藏')
        }
      } else {
        this.shopList.forEach(item => {
          if (item.selected === 1) {
            flag2 = true
            ids.push(item.collectId)
          }
        })
        if (flag2 === false) {
          return this.$message.warning('请先选择需要取消的收藏')
        }
      }
      this.$confirm('此操作将取消选中的收藏, 是否继续?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        this.unfavorite(ids)
      }).catch(() => {
      })
    }
  }
}
</script>

<style lang="scss" scoped>
$searchHeight: 37px;
.attentionds {
  border: 1px solid #E5E5E5;
  .attentiondsTit {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 30px;
    position: relative;
    >>> .el-tabs__nav-wrap::after {
      height: 1px;
    }
    >>> .el-tabs--top {
      width: 100%;
    }
    .attentionBox {
      position: absolute;
      top: 10px;
      right: 25px;
      z-index: 99;
      .searchRight {
        display: flex;
        input {
          margin-left: 16px;
          border: 1px solid #E5E5E5;
          padding-left: 10px;
          font-size: 14px;
          width: 280px;
        }
        span {
          display: block;
          height: 30px;
          line-height: 30px;
        }
        .batch {
          color: #FFFFFF;
          font-size: 12px;
          width: 78px;
          text-align: center;
          height: $searchHeight;
          line-height: $searchHeight;
          background: $mainGlod;
          cursor: pointer;
        }
        .searchBtn {
          // width: 64px;
          height: $searchHeight;
          line-height: $searchHeight;
          // background: $mainGlod;
          color: #FFFFFF;
          font-size: 25px;
          text-align: center;
          cursor: pointer;
          position: absolute;
          right: 10px;
        }
      }
    }
    span {
      display: block;
      height: 30px;
      line-height: 30px;
    }
    .saveList {
      display: flex;
      align-items: center;
      span {
        margin-left: 36px;
        cursor: pointer;
        color: #333333;
        font-size: 14px;
      }
      span.save {
        width: 104px;
        height: $searchHeight;
        background: #FFFFFF;
        color: #333333;
        border: 1px solid $mainGlod;
        text-align: center;
        line-height: $searchHeight;
      }
    }
    >>> .el-tabs__nav-scroll {
      padding: 0 25px;
      height: 60px;
      line-height: 60px;
      background-color: #FAFAFA;
    }
  }
  .list {
    padding: 10px 20px 20px 20px;
    .attentiondsList {
      .topTime {
        color: #333333;
        font-size: 18px;
        margin-bottom: 30px;
      }
      .listBox {
        .attentiondsItem {
          width: 186px;
          float: left;
          margin:0 18px 20px 0;
          position: relative;
          .imgBox {
            width: 186px;
            height: 186px;
            border: 1px solid #E5E5E5;
            border-bottom: 0;
            box-sizing: border-box;
            img {
              width: 100%;
              height: 100%;
            }
          }
          .info {
            border: 1px solid #E5E5E5;
            box-sizing: border-box;
            text-align: center;
            padding: 0 15px 15px;
            h3 {
              font-size: 14px;
              color: #333333;
              height: 30px;
              line-height: 30px;
              margin-top: 10px;
            }
            span {
              color: $mainGlod;
              font-size: 14px;
            }
          }
          .btnBox {
            border: 1px solid #E5E5E5;
            display: flex;
            border-top: none;
            span {
              width: 50%;
              display: block;
              text-align: center;
              font-size: 14px;
              color: #333333;
              height: 30px;
              line-height: 30px;
              cursor: pointer;
            }
            span:first-child {
              border-right: 1px solid #E5E5E5;
              box-sizing: border-box;
            }
          }
          .offShelf {
            position: relative;
            z-index: 99;
            .tipText {
              top: 0;
              position: absolute;
              left: 0;
              right: 0;
              bottom: 0;
              display: flex;
              align-items: center;
              justify-content: center;
              background: rgba(28,28,28,0.5);
              color: #fff;
            }
          }
        }
        .attentiondsItem:nth-child(5n) {
          margin-right: 0;
        }
        .edit:before {
          content: "";
          background: url("./../../../assets/images/user-unselected.svg");
          width: 24px;
          height: 24px;
          position: absolute;
          right: 10px;
          top: 10px;
          display: block;
          background-size: contain;
          z-index: 999;
        }
        .selected:before {
          background: url("./../../../assets/images/user-selected.svg");
          background-size: contain;
        }
      }
    }
    >>> .el-pagination {
      margin: 30px 0 20px 0;
    }
  }
  .sub-main{
    min-height: 400px;
  }
  .nothing{
    width: 100%;
    margin-top: 30px;
    text-align: center;
    min-height: 400px;
    p{
        margin-bottom: 20px;
    }
    .el-button{
        background-color: $mainGlod;
        color: #FFFFFF;
        font-weight: normal;
        border-radius: 0;
    }
  }
  .mc{
    width: 100%;
    height: 100%;
    position: absolute;
    opacity: 0;
  }
}
</style>
