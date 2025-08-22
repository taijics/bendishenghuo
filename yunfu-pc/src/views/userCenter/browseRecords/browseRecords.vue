<template>
  <div class="records">
    <div class="recordsTit">
      <span>浏览足迹</span>
      <span v-if="!edit" class="batch" @click="showEdit">批量管理</span>
      <div v-else class="saveList">
        <el-checkbox v-model="selectAll" @change="changeChecked" :true-label='1' :false-label='0'>全选</el-checkbox>
        <span class="delete" @click="deleteFun">删除</span>
        <span class="save" @click="saveList">保存</span>
      </div>
    </div>
    <div class="list sub-main" v-if="flag" v-loading="loading">
      <div class="recordsList" v-for="(item,index) of recordList" :key="index">
        <div class="topTime">{{ item.createTime }}</div>
        <div class="listBox">
          <div class="recordsItem"
            v-for="(child,inx) of item.products"
            :key="child.footprintId"
            :class="{selected: child.selected === 1, edit: edit}"
            @click="select(index,inx)"
          >
            <div class="mc" v-if="edit"></div>
            <div class="imgBox">
              <span class="delBtn hiddenBtn" @click="del(child.productId,item.createTime)">
                <icon-svg icon-class="del" />
              </span>
              <img :src="child.image" alt="">
              <span class="detailBtn hiddenBtn" @click="toProductDetail(child)">查看详情</span>
            </div>
            <div class="info">
              <h3 class="overflow">{{ child.productName }}</h3>
              <span class="price">¥{{ child.price }}</span>
            </div>
          </div>
          <div class="clearfix"></div>
        </div>
      </div>
      <el-pagination
        v-if="recordList.length>0"
        class=""
        background
        layout="prev, pager, next, jumper"
        :page-size="4"
        :current-page="page"
        @current-change="handleCurrentChange"
        :total="total">
      </el-pagination>
    </div>
    <div class="nothing sub-main" v-else>
      <icon-svg style="width: 240px; height: 240px; margin-bottom: 20px;" icon-class="user-foot-nodata" />
      <p class="fs20 font-color-999">你还没有浏览记录～</p>
    </div>
  </div>
</template>

<script>
import {
  getFoots,
  deleteFoots
} from '@/api/user/user.js'
export default {
  name: 'browseRecords',
  data () {
    return {
      page: 1,
      pageSize: 4,
      total: 0,
      edit: false,
      recordChecked: 0,
      selectAll: 0,
      ids: [],
      times: [],
      recordList: [],
      flag: true,
      loading: false
    }
  },
  mounted () {
    this.getFootprint()
  },
  methods: {
    // 我的足迹
    async getFootprint () {
      this.loading = true
      const response = await getFoots({
        page: this.page,
        pageSize: this.pageSize
      })
      const res = response.data
      if (res.code === '200') {
        this.recordList = res.data.list
        this.total = res.data.total
        if (res.data.list.length) {
          this.flag = true
        } else {
          this.flag = false
        }
      } else {
        this.$message.warning(res.message)
      }
      this.loading = false
    },
    // 翻页
    handleCurrentChange (val) {
      this.page = val
      this.getFootprint()
    },
    // 保存
    saveList () {
      this.edit = false
    },
    // 选择
    select (index, inx) {
      if (this.recordList[index].products[inx].selected === 1) {
        this.recordList[index].products[inx].selected = 0
      } else {
        this.recordList[index].products[inx].selected = 1
      }
      this.selectAll = 1
      this.recordList.map(i => {
        i.products.map(j => {
          if (j.selected === 0) {
            this.selectAll = 0
          }
        })
      })
    },
    // 全选
    changeChecked () {
      this.recordList.forEach(i => {
        i.products.forEach(j => {
          this.$set(j, 'selected', this.selectAll)
        })
      })
      console.log(this.recordList)
    },
    // 编辑
    showEdit () {
      if (this.recordList.length === 0) {
        return
      }
      this.edit = true
    },
    // 商品详情
    toProductDetail (item) {
      let data = {
        productId: item.productId,
        shopId: item.shopId,
        skuId: item.skuId
      }
      this.$router.push({
        path: '/productDetail',
        query: {
          proData: JSON.stringify(data)
        }
      })
    },
    // 删除浏览记录请求
    async delFootprint (ids, times) {
      const response = await deleteFoots({
        ids: ids,
        times: times
      })
      const res = response.data
      if (res.code === '200') {
        this.$message.success('删除成功')
        this.edit = false
        this.getFootprint()
      } else {
        this.$message.error(res.message)
      }
    },
    // 删除单个浏览记录
    del (id, time) {
      let ids = [id]
      let times = [time]
      this.delFootprint(ids, times)
    },
    // 删除选中浏览记录
    deleteFun () {
      let flag = false
      for (var i in this.recordList) {
        for (var k in this.recordList[i].products) {
          if (this.recordList[i].products[k].selected === 1) {
            flag = true
          }
        }
      }
      if (flag === false) {
        return this.$message.warning('请先选中需要删除的记录')
      }
      this.$confirm('此操作将删除选中的记录, 是否继续?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        let ids = []
        let times = []
        for (var i in this.recordList) {
          for (var k in this.recordList[i].products) {
            if (this.recordList[i].products[k].selected === 1) {
              ids.push(this.recordList[i].products[k].productId)
              times.push(this.recordList[i].createTime)
            }
          }
        }
        this.delFootprint(ids, times)
      }).catch(() => {
      })
    }
  }
}
</script>

<style lang="scss" scoped>
  .records {
    border: 1px solid #E5E5E5;
    .recordsTit {
      padding: 0 25px;
      background-color: #F3F4F5;
      border-bottom: 1px solid #F5F5F5;
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 15px;
      span {
        display: block;
        height: 60px;
        line-height: 60px;
      }
      span:first-child {
        color: #333;
        font-size: 18px;
        // border-bottom: 3px solid $mainGlod;
      }
      .batch {
        width: 104px;
        height: 40px;
        line-height: 40px;
        color: #333;
        font-size: 12px;
        text-align: center;
        background: #FFF;
        cursor: pointer;
      }
      .saveList {
        display: flex;
        align-items: center;
        span {
          margin-left: 50px;
          cursor: pointer;
          color: #333333;
          font-size: 14px;
        }
        span.save {
          width: 104px;
          height: 40px;
          background: #FFFFFF;
          color: $mainGlod;
          text-align: center;
          line-height: 40px;
        }
      }
    }
    .list {
      .recordsList {
        margin-bottom: 20px;
        background-color: #F5F5F5;
        .topTime {
          padding: 15px 30px;
          color: #FFF;
          background-color: #333;
          font-size: 14px;
          font-weight: bold;
        }
        .listBox {
          padding: 10px;
          .recordsItem {
            width: 18%;
            // height: 330px;
            float: left;
            margin: 10px;
            position: relative;
            border: 1px solid transparent;
            .imgBox {
              width: 100%;
              height: 240px;
              // border: 1px dashed #333;
              box-sizing: border-box;
              position: relative;
              &:hover .hiddenBtn{
                display: block;
              }
              .hiddenBtn{
                display: none;
              }
              .delBtn{
                font-size: 32px;
                cursor: pointer;
                position: absolute;
                right: 5px;
                top: 5px;
              }
              .detailBtn{
                width: 100%;
                height: 40px;
                line-height: 40px;
                text-align: center;
                color: #FFF;
                background-color: rgba($color: #333, $alpha: .8);
                cursor: pointer;
                position: absolute;
                left: 0;
                bottom: 0;
              }
              img {
                width: 100%;
                height: 99%;
              }
            }
            .info {
              border: 1px solid #E5E5E5;
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
          }
          .recordsItem:nth-child(5n) {
            margin-right: 0;
          }
          // .edit:before {
          //   content: "";
          //   background: url("./../../../assets/images/noEdit.png");
          //   width: 58px;
          //   height: 58px;
          //   position: absolute;
          //   right: 0;
          //   top: 0;
          //   display: block;
          //   background-size: contain;
          // }
          // .selected:before {
          //   background: url("./../../../assets/images/edit.png");
          //   background-size: contain;
          // }
          .selected{
            border-color: $mainGlod;
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
      text-align: center;
      min-height: 400px;
      p{
          margin-bottom: 20px;
      }
      .el-button{
          background-color: #FF7800;
          color: #FFFFFF;
          font-weight: normal;
          border-radius: 0;
      }
    }
    .mc{
      position: absolute;
      width: 100%;
      height: 100%;
      opacity: 0;
    }
  }
</style>
