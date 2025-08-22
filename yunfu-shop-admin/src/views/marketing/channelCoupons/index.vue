<!--  -->
<template>
  <div class="userStyle">
    <!-- 搜索 -->
    <div class="topSearch">
      <div class="formSearch">
        <el-form :inline="true" :model="formInline">
          <el-form-item label="渠道券名称">
            <el-input v-model="formInline.search" maxlength="20" clearable placeholder="请输入渠道券名称" style="width: 200px;" class="filter-item" @keyup.enter.native="search" />
          </el-form-item>
          <el-form-item>
            <el-button type="primary" plain @click="search">查询</el-button>
            <el-button plain @click="clear">重置</el-button>
          </el-form-item>
        </el-form>
      </div>
      <div class="rightBTn">
        <el-button type="primary" @click="add">新增</el-button>
      </div>
    </div>
    <!-- 表格 -->
    <div class="tableBox">
      <el-table
        ref="multipleTable"
        :data="tableData"
        border
        :header-cell-style="{ background: '#EEF3FF', color: '#333333' }"
        tooltip-effect="dark"
        style="width: 100%"
      >
        <el-table-column prop="shopCouponId" label="优惠券id" />
        <el-table-column prop="couponName" label="优惠券名称" width="150" />
        <el-table-column label="类型" align="center" prop="status">
          <template slot-scope="scope">
            <div>
              <span v-if="scope.row.couponType === 1">满减券</span>
              <span v-if="scope.row.couponType === 2">折扣券</span>
            </div>
          </template>
        </el-table-column>

        <el-table-column prop="couponContent" label="面额" />
        <el-table-column prop="threshold" label="最低消费" />
        <el-table-column label="有效期">
          <template slot-scope="scope">
            <span>{{ scope.row.couponTime }}天</span>
          </template>
        </el-table-column>
        <el-table-column ref="table" prop="image" label="商品图">
          <template slot-scope="scope">
            <a :href="scope.row.productImage" style="color: #42b983" target="_blank"><img :src="scope.row.productImage" class="el-avatar"></a>
          </template>
        </el-table-column>
        <el-table-column prop="productName" label="商品名称" />
        <el-table-column prop="price" label="商品价格" />
        <el-table-column label="开始时间" width="140">
          <template slot-scope="scope">
            <span>{{ scope.row.effectiveStart }}</span>
          </template>
        </el-table-column>
        <el-table-column label="结束时间" width="140">
          <template slot-scope="scope">
            <span>{{ scope.row.effectiveEnd }}</span>
          </template>
        </el-table-column>
        <el-table-column label="发布数量" prop="totalCount">
          <template slot-scope="scope">
            <div>
              <p>发布:{{ scope.row.number }}</p>
              <p>剩余:{{ scope.row.stockNumber }}</p>
            </div>
          </template>
        </el-table-column>
        <el-table-column label="券状态" align="center" prop="status">
          <template slot-scope="scope">
            <div>
              <span v-if="scope.row.state === 0">未开始</span>
              <span v-if="scope.row.state === 1">进行中</span>
              <span v-if="scope.row.state === 2">已结束</span>
            </div>
          </template>
        </el-table-column>
        <el-table-column width="200" label="操作" align="center" fixed="right">
          <template slot-scope="scope">
            <el-button
              size="mini"
              type="primary"
              :loading="getLinkLoading === scope.row.shopCouponId"
              @click="getLink(scope.row)"
            >
              生成短链接
            </el-button>
          </template>
        </el-table-column>
      </el-table>
      <div class="fenye">
        <el-pagination
          :current-page="currentPage"
          :page-sizes="[10, 20, 50, 100]"
          :page-size="10"
          layout="total, sizes, prev, pager, next, jumper"
          :total="total"
          @size-change="handleSizeChange"
          @current-change="handleCurrentChange"
        />
      </div>
    </div>
    <el-dialog
      title="短链接"
      center
      :visible.sync="dialogVisible"
      width="30%"
    >
      <div>{{ linkData }}</div>
      <span slot="footer" class="dialog-footer">
        <el-button @click="dialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="copyLink(linkData)">复制链接</el-button>
      </span>
    </el-dialog>
    <ad-form ref="adForm" @reset="getAll" />
  </div>
</template>

<script>
import {
  getList,
  generateLink
} from '@/api/channelCoupons'

import AdForm from './form'
import Cookies from 'js-cookie';
export default {
  components: { AdForm },
  data() {
    // 这里存放数据
    return {
      formInline: {
        page: 1, // 当前页
        pageSize: 10 // 每页记录数
      },
      total: 1,
      tableData: [],
      currentPage: 1,
      getLinkLoading: '',
      shopId: 0,
      dialogVisible: false,
      linkData: ''
    }
  },
  mounted() {
    this.shopId = parseInt(Cookies.get('cereShopId'))
    this.formInline.shopId = this.shopId
    this.getAll()
  },
  // 方法集合
  methods: {
    // 初始化查询列表数据
    async getAll() {
      const formInline = this.formInline
      const res = await getList(formInline)
      this.tableData = res.data.list
      this.total = res.data.total
    },
    // 页码每页页数修改回调
    handleSizeChange(val) {
      this.formInline.pageSize = val
      this.getAll(this.formInline)
    },
    // 页码当前页修改回调
    handleCurrentChange(val) {
      this.formInline.page = val
      this.getAll()
    },
    // 查询
    search() {
      this.total = 1
      this.formInline.page = 1
      this.getAll()
    },
    // 清除
    clear() {
      this.formInline = {
        search: '', // 搜索字段
        page: 1, // 当前页
        pageSize: 10 // 每页记录数
      }
      this.getAll()
    },
    // 新增
    add() {
      this.$refs.adForm.show()
    },
    // 删除
    // async del(id) {
    //   this.$confirm('是否确认删除该内容？', '提示', {
    //     confirmButtonText: '确定',
    //     cancelButtonText: '取消',
    //     type: 'warning'
    //   })
    //     .then(() => {
    //       del({ id }).then(res => {
    //         this.$message({
    //           type: 'success',
    //           message: '删除成功!'
    //         })
    //         this.getAll()
    //       })
    //     })
    //     .catch(() => {
    //       return false
    //     })
    // },
    // 复制链接
    copyLink(url) {
      const input = document.createElement('input')
      document.body.appendChild(input)
      input.setAttribute('value', url)
      input.select()
      if (document.execCommand('copy')) {
        document.execCommand('copy')
      }
      document.body.removeChild(input)
      this.$message({
        message: '复制链接成功',
        type: 'success'
      })
    },
    // 生成链接
    getLink(row) {
      this.getLinkLoading = row.shopCouponId
      // const params = {
      //   envVersion: 'develop', // 体验版为"trial"，开发版为"develop"
      //   path: `pages/extend/index?channelId=${row.id}&pid=${row.pid}&cid=${row.cid}`
      // }
      const params = {
        productId: row.productId,
        shopId: this.shopId,
        shopCouponId: row.shopCouponId
      }
      generateLink(params).then(res => {
        this.getLinkLoading = ''
        if (res && res.data) {
          this.dialogVisible = true
          this.linkData = res.data.replace(/(^")|("$)/g, '')
        } else {
          this.$message({
            message: '生成失败',
            type: 'warning'
          })
        }
      }).catch(err => {
        console.log(err.response.data.message)
        this.getLinkLoading = ''
      })
    }
  }
}
</script>
<style lang='scss' scoped>
//@import url(); 引入公共css类
@import url("../../../styles/elDialog.scss");
.userStyle {
  padding: 20px;
  .topSearch {
    display: flex;
    justify-content: space-between;
    //align-items: center;
    .formSearch,
    .rightBTn {
      margin-left: 20px;
    }
  }
  .btnList .el-popover__reference{
    margin-left: 10px;
  }
}
</style>
<style>
.avatar-uploader .el-upload {
  border: 1px dashed #d9d9d9;
  border-radius: 6px;
  cursor: pointer;
  position: relative;
  overflow: hidden;
}
.avatar-uploader .el-upload:hover {
  border-color: #409EFF;
}
.avatar-uploader-icon {
  font-size: 28px;
  color: #8c939d;
  width: 120px;
  height: 120px;
  line-height: 120px;
  text-align: center;
}
.avatar {
  width: 120px;
  height: 120px;
  display: block;
}
</style>
