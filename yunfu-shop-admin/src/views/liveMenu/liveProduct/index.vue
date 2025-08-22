<template>
  <div class="liveRoomPage">
    <nav>
      <el-form :inline="true" :model="listQuery" class="demo-form-inline">
        <el-form-item label="状态:" label-width="100px">
          <el-radio-group v-model="listQuery.state" @change="searchTypeChange">
            <el-radio-button
              v-for="item in searchType"
              :key="item.value"
              :label="item.value"
            >
              {{ item.label }}
            </el-radio-button>
          </el-radio-group>
        </el-form-item>
        <br>
        <el-form-item label="关键字:" label-width="100px">
          <el-input
            v-model="listQuery.search"
            maxlength="20"
            placeholder="请输入商品名称/ID"
            class="inputKeyWord"
            style="width:400px;"
          >
            <el-button slot="append" icon="el-icon-search" @click="getList" />
          </el-input>
        </el-form-item>
        <el-form-item>
          <el-button style="margin-left: 20px" type="success" @click="addPro">添加直播商品</el-button>
        </el-form-item>
      </el-form>
    </nav>
    <section>
      <el-table
        ref="multipleTable"
        :data="roomList"
        border
        :header-cell-style="{ background: '#EEF3FF', color: '#333333' }"
        tooltip-effect="dark"
        style="width: 100%"
      >
        <el-table-column prop="id" label="直播商品ID" />
        <el-table-column prop="productName" label="商品名称" />
        <el-table-column prop="productId" label="关联商品ID" />
        <el-table-column prop="productImage" width="100" label="商品图片">
          <template slot-scope="scope">
            <img
              style="width: 40px; height: 40px"
              :src="scope.row.productImage"
              alt=""
            >
          </template>
        </el-table-column>
        <el-table-column prop="startTime" label="商品小程序路径">
          <template slot-scope="scope">
            /pages_category_page1/goodsModule/goodsDetails?productId=
            {{ scope.row.productId }}
          </template>
        </el-table-column>
        <el-table-column label="价格类型" width="100">
          <template slot-scope="scope">
            <el-tag v-if="scope.row.priceType == 1">
              一口价
            </el-tag>
            <el-tag v-if="scope.row.priceType == 2" type="success">
              价格区间
            </el-tag>
            <el-tag v-if="scope.row.priceType == 3" type="danger">
              折扣价
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="审核状态" width="100">
          <template slot-scope="scope">
            <el-tag v-if="scope.row.state == 0" type="warning">
              待审核
            </el-tag>
            <el-tag v-if="scope.row.state == 1" type="success">
              已通过
            </el-tag>
            <el-tag v-if="scope.row.state == 2" type="danger">
              未通过
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="微信审核状态" width="120">
          <template slot-scope="scope">
            <el-tag v-if="scope.row.wxAuditStatus == 0" type="info">
              未审核
            </el-tag>
            <el-tag v-if="scope.row.wxAuditStatus == 1" type="success">
              审核中
            </el-tag>
            <el-tag v-if="scope.row.wxAuditStatus == 2" type="warning">
              审核通过
            </el-tag>
            <el-tag v-if="scope.row.wxAuditStatus == 3" type="danger">
              审核失败
            </el-tag>
            <el-tag v-if="scope.row.wxAuditStatus == -1">
              未提交
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="createTime" label="创建时间">
          <!-- 暂无 -->
        </el-table-column>
        <el-table-column
          fixed="right"
          label="操作"
          width="200"
          show-overflow-tooltip
        >
          <template slot-scope="scope">
            <div class="btnList">
              <el-button
                v-if="scope.row.state != 1"
                type="text"
                @click="edit(scope.row)"
              >编辑</el-button>
              <el-button type="text" @click="seeMore(scope.row)">详情</el-button>
              <el-button type="text" @click="del(scope.row)">删除</el-button>
              <el-button
                v-if="scope.row.state == 2"
                type="text"
                @click="reExamine(scope.row)"
              >重新审核</el-button>
            </div>
          </template>
        </el-table-column>
      </el-table>
      <div class="pagination">
        <el-pagination
          :current-page="listQuery.page"
          :page-sizes="[10, 20, 50, 100]"
          :page-size="10"
          layout="total, sizes, prev, pager, next, jumper"
          :total="total"
          @size-change="handleSizeChange"
          @current-change="handleCurrentChange"
        />
      </div>
    </section>

    <el-dialog
      :title="'直播间商品信息'"
      :visible.sync="DetailsShow"
      width="50%"
      center
      :close-on-click-modal="false"
    >
      <el-row>
        <el-col :span="12">
          <el-form :model="ProForm" size="mini" label-width="180px">
            <el-form-item label="商品名称:">
              {{ ProForm.productName }}
            </el-form-item>
            <el-form-item label="商品库存:">
              {{ ProForm.stockNumber }}
            </el-form-item>
            <el-form-item label="商品图片:">
              <img
                style="width: 120px; height: 120px"
                :src="ProForm.productImage"
                alt=""
                srcset=""
              >
            </el-form-item>
          </el-form>
        </el-col>
        <el-col :span="12">
          <el-form :model="ProForm" size="mini" label-width="180px">
            <el-form-item label="商品价格:">
              <span v-if="ProForm.priceType == 1">
                一口价: {{ ProForm.fixedPrice }}
              </span>
              <span v-if="ProForm.priceType == 2">
                最低价： {{ ProForm.minPrice }} - 最高价：{{ ProForm.maxPrice }}
              </span>
              <span v-if="ProForm.priceType == 3">
                现价: {{ ProForm.marketPrice }}
              </span>
            </el-form-item>
          </el-form>
        </el-col>
      </el-row>
      <div v-if="ProForm.remark" style="text-align: center; margin-top: 20px">
        <span style="color: red">备注：</span>
        {{ ProForm.remark }}
      </div>
      <span slot="footer" class="dialog-footer">
        <el-button @click="DetailsShow = false">关 闭</el-button>
      </span>
    </el-dialog>

    <!-- 添加直播间商品 -->
    <el-dialog
      :title="proShowState == 1 ? '新建直播间商品' : '编辑直播间商品'"
      :visible.sync="addProShow"
      width="50%"
      center
      :close-on-click-modal="false"
    >
      <div v-if="proShowState == 1">
        <el-form :inline="true" :model="productForm" class="demo-form-inline">
          <el-form-item class="inputWide" label="关键字：">
            <el-input v-model="productForm.search" maxlength="20" placeholder="请输入内容" />
          </el-form-item>
          <el-form-item>
            <el-button
              type="primary"
              plai
              @click="getClassifyGetAll"
            >查询</el-button>
          </el-form-item>
        </el-form>
        <el-table
          ref="singleTable"
          border
          :data="proTableData"
          highlight-current-row
          style="width: 100%"
          @current-change="selProduct"
        >
          <el-table-column property="productId" label="商品ID" />
          <el-table-column property="productImage" label="商品主图">
            <template slot-scope="scope">
              <img
                style="width: 40px; height: 40px"
                :src="scope.row.productImage"
                alt=""
              >
            </template>
          </el-table-column>
          <el-table-column property="productName" label="商品名称" />
          <el-table-column property="stockNumber" label="库存" />
        </el-table>
        <el-pagination
          style="margin-top: 20px"
          :current-page="productForm.page"
          :page-sizes="[5, 10, 20, 50, 100]"
          :page-size="5"
          layout="total, sizes, prev, pager, next, jumper"
          :total="proTotal"
          @size-change="handleSizeChange1"
          @current-change="handleCurrentChange1"
        />
      </div>
      <el-form
        ref="form"
        style="margin-top: 20px"
        :model="form"
        :rules="rules"
        size="small"
        label-width="100px"
      >
        <el-form-item
          v-if="proShowState == 1"
          label="选中的商品"
          prop="productImage"
        >
          <div class="uploadWidth">
            <el-upload
              class="avatar-uploader"
              :headers="headers"
              :action="uploadUrl"
              :show-file-list="false"
              :on-success="handlePictureCardPreview1"
              disabled
            >
              <img v-if="selImage" :src="selImage" class="avatar">
              <i v-else class="el-icon-plus avatar-uploader-icon" />
            </el-upload>
          </div>
          <span style="color: red">* 请选择商品商品</span>
        </el-form-item>
        <!-- <el-form-item v-if="proShowState!=2 || form.wxAuditStatus == -1" label="商品封面图" prop="productImage"> -->
        <el-form-item label="商品封面图" prop="productImage">
          <div class="uploadWidth">
            <el-upload
              class="avatar-uploader"
              :headers="headers"
              :action="uploadUrl"
              :show-file-list="false"
              :before-upload="beforeAvatarUpload"
              :on-success="handlePictureCardPreview1"
            >
              <img
                v-if="form.productImage"
                :src="form.productImage"
                class="avatar"
              >
              <i v-else class="el-icon-plus avatar-uploader-icon" />
            </el-upload>
          </div>
          <span style="color: red">* 图片规则：图片尺寸最大300像素*300像素</span>
        </el-form-item>
        <!-- <el-form-item v-if="proShowState!=2 || form.wxAuditStatus == -1" label="商品库存" prop="stockNumber"> -->
        <el-form-item label="商品库存" prop="stockNumber">
          <el-input
            v-model="form.stockNumber"
            maxlength="9"
            style="width: 60%"
            oninput="value=value.replace(/[^\d]/g,'')"
          />
        </el-form-item>
        <!-- <el-form-item v-if="proShowState!=2 || form.wxAuditStatus == -1" label="商品名称" prop="productName"> -->
        <el-form-item label="商品名称" prop="productName">
          <el-input v-model="form.productName" maxlength="20" style="width: 60%" />
        </el-form-item>
        <el-form-item label="价格类型" prop="priceType">
          <el-radio-group v-model="form.priceType">
            <el-radio :label="1">一口价</el-radio>
            <el-radio :label="2">价格区间</el-radio>
            <el-radio :label="3">折扣价</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="价格" prop="title">
          <el-input-number v-if="form.priceType == 1" v-model="form.fixedPrice" :max="999999999" :min="0" :precision="2" :step="1" placeholder="一口价" style="width:250px" />
          <el-input-number v-if="form.priceType == 2" v-model="form.minPrice" :max="999999999" :min="0" :precision="2" :step="1" placeholder="最低价" style="width:250px" />
          <el-input-number v-if="form.priceType == 2" v-model="form.maxPrice" :max="999999999" :min="0" :precision="2" :step="1" placeholder="最高价" style="margin-left:20px;width:250px" />
          <el-input-number v-if="form.priceType == 3" v-model="form.marketPrice" :max="999999999" :min="0" :precision="2" :step="1" placeholder="折扣价" style="width:250px" />
          <!-- <el-input
            v-if="form.priceType == 1"
            v-model="form.fixedPrice"
            placeholder="一口价"
            style="width: 160px"
          />
          <el-input
            v-if="form.priceType == 2"
            v-model="form.minPrice"
            placeholder="最低价"
            style="width: 160px"
          />
          <el-input
            v-if="form.priceType == 2"
            v-model="form.maxPrice"
            style="margin-left: 20px; width: 160px"
            placeholder="最高价"
          />
          <el-input
            v-if="form.priceType == 3"
            v-model="form.marketPrice"
            placeholder="折扣价"
            style="width: 160px"
          /> -->
        </el-form-item>
      </el-form>
      <span slot="footer" class="dialog-footer">
        <el-button @click="addProShow = false">取 消</el-button>
        <el-button
          v-if="proShowState == 1"
          type="success"
          @click="addProSubmit"
        >添 加</el-button>
        <el-button
          v-if="proShowState == 2"
          type="primary"
          @click="editProSubmit"
        >保 存</el-button>
      </span>
    </el-dialog>
  </div>
</template>

<script>
import { getClassifyGetAll } from '@/api/commodity';
import {
  liveProGetAll,
  delLiveProduct,
  addProductSave,
  editProductSave,
  ProReExamine,
} from '@/api/live';
import { WXuploadUrl } from '@/utils/request';
import { getToken } from '@/utils/auth';
export default {
  data() {
    return {
      uploadUrl: WXuploadUrl,
      headers: {
        'Authorization-business': getToken()
      },
      searchType: [
        {
          label: '全部',
          value: null,
        },
        {
          label: '待审核',
          value: 0,
        },
        {
          label: '审核已通过',
          value: 1,
        },
        {
          label: '审核未通过',
          value: 2,
        },
      ],
      listQuery: {
        state: null,
        search: '',
        page: 0,
        pageSize: 10,
        shopId: null,
      },
      proListQuery: {
        liveId: null,
        page: 0,
        pageSize: 10,
        shopId: null,
      },
      roomList: [], // 直播间列表
      roomProList: [], // 直播相关产品列表
      total: 0,
      DetailsShow: false,
      auditShow: false,
      activeName: 'first',
      disabled: false,
      ProForm: {}, // 添加直播间
      liveRules: [], // 直播间添加验证
      auditForm: {},
      auditFormState: 1,
      addProShow: false,
      proShowState: 1,
      productForm: {
        search: '', // 搜索字段
        shelveState: 1, // 上架状态 1-上架 0-不上架 null-全部
        stock: 1, // 库存状态 1-有库存 0-无库存 null-全部
        page: 1, // 当前页
        pageSize: 5,
      },
      proTotal: 0,
      proTableData: [],
      form: {
        productImage: null,
        productMediaId: null,
        stockNumber: null,
        productName: null,
        priceType: 1,
        productId: null,
        total: null,
      },
      rules: {
        stockNumber: [
          { required: true, message: '商品库存不能为空', trigger: 'blur' },
        ],
        productName: [
          { required: true, message: '商品名称不能为空', trigger: 'blur' },
        ],
      },
      selImage: '', // 选中的商品图片
    };
  },
  created() {
    this.getList();
  },
  methods: {
    // 获取商品列表
    async getList() {
      const res = await liveProGetAll(this.listQuery);
      this.total = res.data.total;
      this.roomList = res.data.list;
    },
    seeMore(row) {
      this.ProForm = row;
      this.DetailsShow = true;
    },
    del(row) {
      this.$confirm('是否确认删除该内容?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
      }).then(() => {
        delLiveProduct(row)
          .then((res) => {
            this.closeDialogVisible = false;
            this.$message.success('删除成功');
            this.getList();
          })
          .catch(err => {
            this.$message.error(err.msg);
          })
      });
    },
    // 选择查询状态
    searchTypeChange(e) {
      this.listQuery.state = e;
      this.getList();
    },
    // 分页
    handleCurrentChange(e) {
      this.listQuery.page = e;
      this.getList();
    },
    handleSizeChange(e) {
      this.listQuery.pageSize = e;
      this.getList();
    },
    // 添加商品
    addPro() {
      this.proShowState = 1;
      this.addProShow = true;
      this.getClassifyGetAll();
      this.selImage = ''
      this.form = {
        productImage: null,
        stockNumber: null,
        productName: null,
        priceType: 1,
        productId: null,
        total: null,
      };
    },
    edit(row) {
      this.proShowState = 2;
      this.addProShow = true;
      const data = Object.assign({}, row)
      this.form = data;
    },
    async getClassifyGetAll() {
      const res = await getClassifyGetAll(this.productForm);
      this.proTotal = res.data.total;
      this.proTableData = res.data.list;
    },
    handleSizeChange1(e) {
      this.productForm.pageSize = e;
      this.getClassifyGetAll();
    },
    handleCurrentChange1(e) {
      this.productForm.page = e;
      this.getClassifyGetAll();
    },
    handlePictureCardPreview1(file) {
      if (file.code === '200') {
        this.form.productImage = file.data.url;
        this.form.productMediaId = file.data.mediaId
      } else {
        this.$message.error('图片超出规定像素，上传失败！')
      }
    },
    async beforeAvatarUpload(file) {
      const istype = file.type === 'image/jpeg' || file.type === 'image/png'
      const isLt2M = file.size / 1024 / 1024 < 2;
      const isSize = await new Promise(function(resolve, reject) {
        const width = 300
        const height = 300
        const _URL = window.URL || window.webkitURL
        const image = new Image()
        image.onload = function() {
          const valid =
            image.width <= width &&
            image.height <= height
          valid ? resolve() : reject()
        }
        image.src = _URL.createObjectURL(file)
      }).then(
        () => {
          return file
        },
        () => {
          this.$message.error(
            '上传的图片最大分辨率不超过300*300'
          )
          return Promise.reject(false)
        }
      )
      if (!istype) {
        this.$message.error('上传图片只能是 JPG 或 PNG格式!')
      }
      if (!isLt2M) {
        this.$message.error('上传图片大小不能超过 2MB!')
      }
      return isSize && istype && isLt2M
    },
    // 选中的商品
    selProduct(e) {
      console.log(e);
      this.selImage = e.productImage;
      this.form.productId = e.productId;
      this.form.total = e.stockNumber;
      this.form.stockNumber = e.stockNumber;
      this.form.productImage = e.productImage;
      this.form.productName = e.productName;
    },
    addProSubmit() {
      addProductSave(this.form).then((res) => {
        console.log(res);
        if (res.code === '') {
          this.addProShow = false;
          this.getList();
          this.$message.success('添加成功');
        }
      });
    },
    editProSubmit() {
      editProductSave(this.form).then((res) => {
        console.log(res);
        if (res.code === '') {
          this.addProShow = false;
          this.getList();
          this.$message.success('编辑成功');
        }
      });
    },
    // 重新审核
    reExamine(row) {
      ProReExamine({ id: row.id }).then((res) => {
        if (res.code === '') {
          this.$message.success('已重新提交');
          this.getList();
        }
      });
    },
  },
};
</script>

<style lang="scss" scpoed>
.liveRoomPage {
  padding: 32px 20px;
  nav {
    .search {
      line-height: 40px;
      margin: 10px 0;
      display: flex;
      .title {
        min-width: 120px;
        text-align: right;
      }
      .inputKeyWord {
        max-width: 400px;
        min-width: 200px;
      }
    }
  }
  section {
    padding: 12px 8px;
    background-color: #fff;
    .pagination {
      margin-top: 30px;
    }
  }
}
.search {
  line-height: 40px;
  margin: 10px 0;
  display: flex;
  .title {
    min-width: 120px;
    text-align: right;
  }
  .inputKeyWord {
    max-width: 400px;
    min-width: 200px;
  }
}
.avatar-uploader .el-upload {
  border: 1px dashed #d9d9d9;
  border-radius: 6px;
  cursor: pointer;
  position: relative;
  overflow: hidden;
}
.avatar-uploader .el-upload:hover {
  border-color: #409eff;
}
.avatar-uploader-icon {
  font-size: 28px;
  color: #8c939d;
  width: 140px;
  height: 140px;
  line-height: 140px;
  text-align: center;
}
.avatar {
  width: 140px;
  height: 140px;
  display: block;
}
</style>
