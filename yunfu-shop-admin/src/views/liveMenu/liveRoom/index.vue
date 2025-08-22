<template>
  <div class="liveRoomPage">
    <nav>
      <el-form :inline="true" :model="listQuery" class="demo-form-inline">
        <el-form-item label="状态：" label-width="100px">
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
        <el-form-item label="关键字：" label-width="100px">
          <el-input
            v-model="listQuery.search"
            maxlength="20"
            placeholder="请输入直播间名称/ID/主播昵称/微信号"
            class="inputKeyWord"
            style="width:400px;"
          >
            <el-button slot="append" icon="el-icon-search" @click="getList" />
          </el-input>
        </el-form-item>
        <el-form-item>
          <el-button style="margin-left: 20px" type="success" @click="add">创建直播间</el-button>
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
        <el-table-column prop="id" label="直播间id" />
        <el-table-column prop="title" label="直播间标题" />
        <el-table-column prop="anchorNickname" label="主播昵称" />
        <el-table-column prop="anchorWechat" label="主播微信号" />
        <el-table-column prop="startTime" label="直播开始时间" />
        <el-table-column prop="endTime" label="预计结束时间" />
        <el-table-column prop="createTime" label="创建时间" />
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
        <el-table-column
          fixed="right"
          width="200"
          label="操作"
          show-overflow-tooltip
        >
          <template slot-scope="scope">
            <div class="btnList">
              <el-button
                v-if="scope.row.state == 1"
                type="text"
                @click="addPro(scope.row)"
              >导入</el-button>
              <el-button type="text" @click="edit(scope.row)">编辑</el-button>
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
      :title="'直播间信息'"
      :visible.sync="DetailsLiveShow"
      width="50%"
      center
      :close-on-click-modal="false"
    >
      <el-row>
        <el-col :span="12">
          <el-form :model="liveForm" size="mini" label-width="180px">
            <el-form-item label="直播间标题:">
              {{ liveForm.title }}
            </el-form-item>
            <el-form-item label="直播间id:">
              {{ liveForm.id }}
            </el-form-item>
            <el-form-item label="直播间开始时间:">
              {{ liveForm.startTime }}
            </el-form-item>
            <el-form-item label="背景图:">
              <img :src="liveForm.coverImg" alt="" srcset="">
            </el-form-item>
            <el-form-item label="直播间类型:">
              {{ liveForm.liveType == 1 ? "推流" : "手机" }}
            </el-form-item>
            <el-form-item label="是否开启点赞:">
              {{ liveForm.closeLike == 0 ? "是" : "否" }}
            </el-form-item>
            <el-form-item label="是否开启评论:">
              {{ liveForm.closeComment == 0 ? "是" : "否" }}
            </el-form-item>
          </el-form>
        </el-col>
        <el-col :span="12">
          <el-form :model="liveForm" size="mini" label-width="180px">
            <el-form-item label="主播微信号:">
              {{ liveForm.anchorWechat }}
            </el-form-item>
            <el-form-item label="主播昵称:">
              {{ liveForm.anchorNickname }}
            </el-form-item>
            <el-form-item label="直播间结束时间:">
              {{ liveForm.endTime }}
            </el-form-item>
            <el-form-item label="分享图:">
              <img :src="liveForm.shareImg" alt="" srcset="">
            </el-form-item>
            <el-form-item label="是否开启回放:">
              {{ liveForm.closePlayback == 0 ? "是" : "否" }}
            </el-form-item>
            <el-form-item label="是否开启预约:">
              {{ liveForm.closeAppointment == 0 ? "是" : "否" }}
            </el-form-item>
          </el-form>
        </el-col>
      </el-row>
      <div>
        <el-table
          ref="multipleTable"
          :data="roomProList"
          border
          :header-cell-style="{ background: '#EEF3FF', color: '#333333' }"
          tooltip-effect="dark"
          style="width: 100%"
        >
          <el-table-column prop="productId" label="商品ID" />
          <el-table-column prop="productImage" label="商品图片">
            <template slot-scope="scope">
              <img
                style="width: 40px; height: 40px"
                :src="scope.row.productImage"
                alt=""
              >
            </template>
          </el-table-column>
          <el-table-column prop="productName" label="商品名称" />
          <el-table-column prop="stockNumber" label="库存" />
          <el-table-column label="价格">
            <template slot-scope="scope">
              <span v-if="scope.row.priceType == 1">
                一口价: {{ scope.row.fixedPrice }}
              </span>
              <span v-if="scope.row.priceType == 2">
                最低价：{{ scope.row.minPrice }} <br>
                最高价：{{ scope.row.maxPrice }}
              </span>
              <span v-if="scope.row.priceType == 3">
                现价: {{ scope.row.marketPrice }}
              </span>
            </template>
          </el-table-column>
          <el-table-column prop="saleNumber" label="销售数量" />
          <el-table-column prop="saleAmount" label="销售金额" />
        </el-table>
        <el-pagination
          style="margin-top: 20px"
          :current-page="proListQuery.page"
          :page-sizes="[10, 20, 50, 100]"
          :page-size="10"
          layout="total, sizes, prev, pager, next, jumper"
          :total="proTotal"
          @size-change="handleSizeChange1"
          @current-change="handleCurrentChange1"
        />
      </div>
      <div v-if="liveForm.remark" style="text-align: center; margin-top: 20px">
        <span style="color: red">备注：</span>
        {{ liveForm.remark }}
      </div>
      <span slot="footer" class="dialog-footer">
        <el-button @click="closeFn">关 闭</el-button>
      </span>
    </el-dialog>
    <!--表单组件-->
    <el-dialog
      :close-on-click-modal="false"
      :visible.sync="addLiveShow"
      :title="LiveShowState == 1 ? '创建直播间' : '编辑直播间'"
      width="800px"
      center
    >
      <el-form
        ref="form"
        :model="form"
        :rules="rules"
        size="small"
        label-width="140px"
      >
        <el-form-item label="直播间标题" prop="title">
          <el-input
            v-model="form.title"
            maxlength="20"
            style="width: 370px"
            :disabled="isDisabled"
          />
        </el-form-item>
        <el-form-item label="直播间背景图" prop="coverImg">
          <div class="uploadWidth">
            <el-upload
              class="avatar-uploader1"
              :headers="headers"
              :action="uploadUrl"
              :show-file-list="false"
              :on-success="handlePictureCardPreview1"
            >
              <img
                v-if="form.coverImg"
                :src="form.coverImg"
                class="avatar"
              >
              <i v-else class="el-icon-plus avatar-uploader-icon" />
            </el-upload>
          </div>
          <p style="color: #cf0f0f">直播间背景图，图片规则：建议像素1080*1920，大小不超过2M</p>
        </el-form-item>
        <el-form-item label="直播间分享图片" prop="shareImg">
          <div class="uploadWidth">
            <el-upload
              class="avatar-uploader2"
              :headers="headers"
              :action="uploadUrl"
              :show-file-list="false"
              :on-success="handlePictureCardPreview2"
            >
              <img v-if="form.shareImg" :src="form.shareImg" class="avatar">
              <i v-else class="el-icon-plus avatar-uploader-icon" />
            </el-upload>
          </div>
          <p style="color: #cf0f0f">直播分享图 ，建议像素800*640，大小不超过1M</p>
        </el-form-item>
        <el-form-item label="封面图" prop="feedsImg">
          <div class="uploadWidth">
            <el-upload
              class="avatar-uploader3"
              :headers="headers"
              :action="uploadUrl"
              :show-file-list="false"
              :on-success="handlePictureCardPreview3"
            >
              <img v-if="form.feedsImg" :src="form.feedsImg" class="avatar">
              <i v-else class="el-icon-plus avatar-uploader-icon" />
            </el-upload>
          </div>
          <p style="color: #cf0f0f">购物直播封面图 ，建议尺寸800*800</p>
        </el-form-item>
        <el-form-item label="计划直播开始时间" prop="startTime">
          <el-date-picker
            v-model="form.startTime"
            type="datetime"
            style="width: 370px"
            :disabled="isDisabled"
            format="yyyy-MM-dd HH:mm:ss"
            value-format="yyyy-MM-dd HH:mm:ss"
          />
          <p style="color: #cf0f0f">
            开播时间需要在当前时间的50分钟左右,并且开始时间不能在6个月后
          </p>
        </el-form-item>
        <el-form-item label="计划直播结束时间" prop="endTime">
          <el-date-picker
            v-model="form.endTime"
            type="datetime"
            style="width: 370px"
            :disabled="isDisabled"
            format="yyyy-MM-dd HH:mm:ss"
            value-format="yyyy-MM-dd HH:mm:ss"
          />
          <p style="color: #cf0f0f">
            开播时间和结束时间间隔不得短于30分钟,不得超过24小时
          </p>
        </el-form-item>
        <el-form-item
          label="主播昵称"
          prop="anchorNickname"
          :disabled="isDisabled"
        >
          <el-input
            v-model="form.anchorNickname"
            maxlength="20"
            style="width: 370px"
            :disabled="isDisabled"
          />
        </el-form-item>
        <el-form-item
          label="主播微信号"
          prop="anchorWechat"
          :disabled="isDisabled"
        >
          <el-input
            v-model="form.anchorWechat"
            maxlength="20"
            style="width: 370px"
            :disabled="isDisabled"
          />
          <p style="color: #cf0f0f">
            主播微信号需要实名，搜索微信官方小程序【小程序直播】进行认证
          </p>
        </el-form-item>
        <el-form-item label="主播头像" prop="anchorImge">
          <div class="uploadWidth">
            <el-upload
              class="avatar-uploader3"
              :headers="headers"
              :action="uploadUrl"
              :show-file-list="false"
              :on-success="handlePictureCardPreview4"
            >
              <img
                v-if="form.anchorHeadImg"
                :src="form.anchorHeadImg"
                class="avatar"
              >
              <i v-else class="el-icon-plus avatar-uploader-icon" />
            </el-upload>
          </div>
        </el-form-item>

        <el-form-item label="直播间类型" prop="liveType">
          <el-radio-group v-model="form.liveType" :disabled="isDisabled">
            <el-radio :label="1" class="radio">推流</el-radio>
            <el-radio :label="0">手机直播</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="横屏、竖屏" prop="screenType">
          <el-radio-group v-model="form.screenType" :disabled="isDisabled">
            <el-radio :label="1" class="radio">横屏</el-radio>
            <el-radio :label="0">竖屏</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="是否关闭点赞" prop="closeLike">
          <el-radio-group v-model="form.closeLike" :disabled="isDisabled">
            <el-radio :label="1" class="radio">关闭</el-radio>
            <el-radio :label="0">开启</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="是否关闭货架" prop="closeGoodsShelf">
          <el-radio-group v-model="form.closeGoodsShelf" :disabled="isDisabled">
            <el-radio :label="1" class="radio">关闭</el-radio>
            <el-radio :label="0">开启</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="是否关闭评论" prop="closeComment">
          <el-radio-group v-model="form.closeComment" :disabled="isDisabled">
            <el-radio :label="1" class="radio">关闭</el-radio>
            <el-radio :label="0">开启</el-radio>
          </el-radio-group>
        </el-form-item>

        <el-form-item label="是否关闭回放" prop="closePlayback">
          <el-radio-group v-model="form.closePlayback" :disabled="isDisabled">
            <el-radio :label="1" class="radio">关闭</el-radio>
            <el-radio :label="0">开启</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="是否关闭分享" prop="closeShare">
          <el-radio-group v-model="form.closeShare" :disabled="isDisabled">
            <el-radio :label="1" class="radio">关闭</el-radio>
            <el-radio :label="0">开启</el-radio>
          </el-radio-group>
        </el-form-item>
        <!-- <el-form-item label="是否关闭客服" prop="closeService">
          <el-radio-group v-model="form.closeService" :disabled="isDisabled">
            <el-radio :label="1" class="radio">关闭</el-radio>
            <el-radio :label="0">开启</el-radio>
          </el-radio-group>
        </el-form-item> -->
        <el-form-item label="是否关闭预约" prop="closeAppointment">
          <el-radio-group
            v-model="form.closeAppointment"
            :disabled="isDisabled"
          >
            <el-radio :label="1" class="radio">关闭</el-radio>
            <el-radio :label="0">开启</el-radio>
          </el-radio-group>
        </el-form-item>
      </el-form>
      <span slot="footer" class="dialog-footer">
        <el-button @click="addLiveShow = false">取 消</el-button>
        <el-button
          v-if="LiveShowState == 1"
          type="success"
          :disabled="isDisabled"
          @click="submitCU"
        >确 认</el-button>
        <el-button
          v-if="LiveShowState == 2"
          type="primary"
          :disabled="isDisabled"
          @click="submitCU"
        >保 存</el-button>
      </span>
    </el-dialog>
    <!-- 导入商品 -->
    <el-dialog
      title="导入商品"
      :visible.sync="addProShow"
      width="60%"
      center
      :close-on-click-modal="false"
    >
      <el-form
        :inline="true"
        :model="proListPassQuery"
        class="demo-form-inline"
      >
        <el-form-item class="inputWide" label="关键字">
          <el-input
            v-model="proListPassQuery.search"
            maxlength="20"
            placeholder="请输入关键字搜索"
          />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" plain @click="getProPassList">查询</el-button>
        </el-form-item>
      </el-form>
      <!-- 表格 -->
      <div class="tableBox">
        <el-table
          ref="multipleTable"
          :data="proListPassData"
          border
          :header-cell-style="{ background: '#EEF3FF', color: '#333333' }"
          tooltip-effect="dark"
          style="width: 100%"
          @selection-change="handleSelectionChange"
        >
          <el-table-column type="selection" width="55" />
          <el-table-column prop="productId" label="商品ID" />
          <el-table-column prop="productImage" label="商品图片">
            <template slot-scope="scope">
              <img
                style="width: 40px; height: 40px"
                :src="scope.row.productImage"
                alt=""
              >
            </template>
          </el-table-column>
          <el-table-column prop="productName" label="商品名称" />
          <el-table-column prop="stockNumber" label="库存" />
          <el-table-column label="价格">
            <template slot-scope="scope">
              <span v-if="scope.row.priceType == 1">
                一口价: {{ scope.row.fixedPrice }}
              </span>
              <span v-if="scope.row.priceType == 2">
                最低价：{{ scope.row.minPrice }} <br>
                最高价：{{ scope.row.maxPrice }}
              </span>
              <span v-if="scope.row.priceType == 3">
                现价: {{ scope.row.marketPrice }}
              </span>
            </template>
          </el-table-column>
        </el-table>
        <el-pagination
          style="margin-top: 20px"
          :page-sizes="[10, 20, 50, 100]"
          :page-size="10"
          layout="total, sizes, prev, pager, next, jumper"
          :total="proListPassTotal"
          @size-change="handleSizeChange3"
          @current-change="handleCurrentChange3"
        />
      </div>
      <!-- 新增用户 -->
      <span slot="footer" class="dialog-footer">
        <el-button @click="addProShow = false">取 消</el-button>
        <el-button type="success" @click="addproSubmit">确 定</el-button>
      </span>
    </el-dialog>
  </div>
</template>

<script>
import {
  liveGetList,
  liveGetProduct,
  addLiveSave,
  updateLive,
  deleteLive,
  liveProGetAll,
  importProduct,
  reExamine,
} from '@/api/live';
import { WXuploadUrl } from '@/utils/request';
import { getToken } from '@/utils/auth.js'
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
      proTotal: 0,
      DetailsLiveShow: false,
      activeName: 'first',
      disabled: false,
      liveForm: {}, // 添加直播间
      // 添加直播间部分
      addLiveShow: false,
      isDisabled: false,
      LiveShowState: false,
      form: {
        anchorHeadImg: '',
        anchorNickname: '',
        anchorWechat: '',
        coverImg: '',
        coverMediaId: '',
        closeAppointment: 0,
        closeComment: 0,
        closeGoodsShelf: 0,
        closeLike: 0,
        closePlayback: 0,
        closeService: 0,
        closeShare: 0,
        feedsImg: '',
        feedsMediaId: '',
        endTime: '',
        id: 0,
        liveType: 0,
        remark: '',
        screenType: 0,
        shareImg: '',
        shareMediaId: '',
        shopId: 0,
        startTime: '',
        state: 0,
        title: '',
      },
      rules: {
        title: [
          { required: true, message: '直播间标题不能为空', trigger: 'blur' },
          { min: 3, max: 17, message: '最短3个汉字，最长17个汉字', trigger: 'blur' }
        ],
        coverImg: [
          { required: true, message: '背景图不能为空', trigger: 'blur' },
        ],
        feedsImg: [
          { required: true, message: '封面图不能为空', trigger: 'blur' },
        ],
        shareImg: [
          { required: true, message: '分享图片不能为空', trigger: 'blur' },
        ],
        startTime: [
          { required: true, message: '开始时间不能为空', trigger: 'blur' },
        ],
        endTime: [
          { required: true, message: '预计结束时间不能为空', trigger: 'blur' },
        ],
        anchorNickname: [
          { required: true, message: '主播昵称不能为空', trigger: 'blur' },
          { min: 2, max: 15, message: '最短2个汉字，最长15个汉字', trigger: 'blur' }
        ],
        anchorWechat: [
          { required: true, message: '主播微信号不能为空', trigger: 'blur' },
        ],
        liveType: [
          {
            required: true,
            message: '直播间类型 1：推流 0：手机直播不能为空',
            trigger: 'blur',
          },
        ],
        screenType: [
          {
            required: true,
            message: '横屏、竖屏 【1：横屏，0：竖屏】不能为空',
            trigger: 'blur',
          },
        ],
        closeGoodsShelf: [
          {
            required: true,
            message: '是否关闭货架 【0：开启，1：关闭】不能为空',
            trigger: 'blur',
          },
        ],
        closeComment: [
          {
            required: true,
            message: '是否关闭评论 【0：开启，1：关闭】不能为空',
            trigger: 'blur',
          },
        ],
        closeAppointment: [
          {
            required: true,
            message: '是否关闭预约 【0：开启，1：关闭】不能为空',
            trigger: 'blur',
          },
        ],
      },
      addProShow: false,
      proListPassData: [],
      proListPassQuery: {
        liveId: null,
        page: 0,
        pageSize: 10,
        shopId: null,
        search: null,
      },
      proListPassTotal: 0,
      proPassFrom: {
        liveId: null,
        liveProductIdList: [],
        shopId: null,
      },
      isAllow: true,
    };
  },
  created() {
    this.getList();
  },
  methods: {
    // 获取直播间列表
    async getList() {
      const res = await liveGetList(this.listQuery);
      this.total = res.data.total;
      this.roomList = res.data.list;
    },
    // 获取直播间相关产品信息
    async getProList() {
      this.proListQuery.shopId = this.liveForm.shopId;
      this.proListQuery.liveId = this.liveForm.id;
      const res = await liveGetProduct(this.proListQuery);
      this.roomProList = res.data.list;
      this.proTotal = res.data.total;
    },
    seeMore(row) {
      this.liveForm = row;
      this.DetailsLiveShow = true;
      this.getProList();
    },
    del(row) {
      this.$confirm('是否确认删除该内容?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
      }).then(() => {
        deleteLive(row)
          .then((res) => {
            this.closeDialogVisible = false;
            this.$message.success('删除成功');
            this.getList();
          })
          .catch((err) => {
            this.$message.error(err.msg);
          });
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
    handleCurrentChange1(e) {
      this.proListQuery.page = e;
      this.getProList();
    },
    handleSizeChange1(e) {
      this.proListQuery.pageSize = e;
      this.getProList();
    },
    closeFn() {
      this.DetailsLiveShow = false;
    },
    // 添加直播间
    // 图片上传
    handlePictureCardPreview1(file) {
      console.log(file);
      if(file.code==='200'){
        this.form.coverImg = file.data.url;
        this.form.coverMediaId = file.data.mediaId
      }else{
        this.$message.error('图片超出规定像素，上传失败！')
      }
      
    },
    handlePictureCardPreview2(file) {
      if(file.code==='200'){
        this.form.shareImg = file.data.url;
        this.form.shareMediaId = file.data.mediaId
      }else{
        this.$message.error('图片超出规定像素，上传失败！')
      }
    },
    handlePictureCardPreview3(file) {
      if(file.code==='200'){
        this.form.feedsImg = file.data.url;
        this.form.feedsMediaId = file.data.mediaId
      }else{
        this.$message.error('图片超出规定像素，上传失败！')
      }
    },
    handlePictureCardPreview4(file) {
      if(file.code==='200'){
        this.form.anchorHeadImg = file.data.url;
      }else{
        this.$message.error('图片超出规定像素，上传失败！')
      }
    },
    add() {
      this.addLiveShow = true;
      this.LiveShowState = 1;
      this.form = {
        anchorHeadImg: '',
        anchorNickname: '',
        anchorWechat: '',
        coverImg: '',
        coverMediaId: '',
        closeAppointment: 0,
        closeComment: 0,
        closeGoodsShelf: 0,
        closeLike: 0,
        closePlayback: 0,
        closeService: 0,
        closeShare: 0,
        feedsImg: '',
        feedsMediaId: '',
        endTime: '',
        id: 0,
        liveType: 0,
        remark: '',
        screenType: 0,
        shareImg: '',
        shareMediaId: '',
        shopId: 0,
        startTime: '',
        state: 0,
        title: '',
      };
    },
    edit(row) {
      this.addLiveShow = true;
      this.LiveShowState = 2;
      const data = Object.assign({}, row)
      this.form = data;
    },
    // 添加直播间
    submitCU() {
      this.$refs.form.validate((valid) => {
        if (valid) {
          if (this.LiveShowState === 1) {
            if(this.isAllow){
              this.isAllow = false
              addLiveSave(this.form).then((res) => {
                if (res.code === '') {
                  this.$message({
                    message: '创建成功',
                    type: 'success',
                  });
                  this.addLiveShow = false;
                  this.getList();
                }
              });
              setTimeout(()=>{
                this.isAllow = true
              },1000)
            }
          } else {
            updateLive(this.form).then((res) => {
              if (res.code === '') {
                this.$message({
                  message: '修改成功',
                  type: 'success',
                });
                this.addLiveShow = false;
                this.getList();
              }
            });
          }
        }
      });
    },
    // 导入商品
    addPro(row) {
      this.proPassFrom.liveId = row.id;
      this.proPassFrom.shopId = row.shopId;
      this.proListPassQuery.search = '';
      this.proListPassQuery.liveId = row.id;
      this.proListPassQuery.shopId = row.shopId;
      this.addProShow = true;
      this.getProPassList();
    },
    async getProPassList() {
      this.proListPassQuery.state = 1;
      const res = await liveProGetAll(this.proListPassQuery);
      this.proListPassTotal = res.data.total;
      this.proListPassData = res.data.list;
    },
    handleSizeChange3(e) {
      this.proListPassQuery.pageSize = e;
      this.getProPassList();
    },
    handleCurrentChange3(e) {
      this.proListPassQuery.page = e;
      this.getProPassList();
    },
    // 选中的
    handleSelectionChange(val) {
      this.proPassFrom.liveProductIdList = val.map((el) => {
        return el.id;
      });
    },
    // 导入操作
    addproSubmit() {
      if (this.proPassFrom.liveProductIdList.length === 0) {
        this.$message.warning('请选择导入的商品');
      } else {
        importProduct(this.proPassFrom).then((res) => {
          if (res.code === '') {
            this.$message({
              message: '导入成功',
              type: 'success',
            });
            this.addProShow = false;
            this.getList();
          }
        });
      }
    },
    // 重新审核
    reExamine(row) {
      reExamine({ id: row.id }).then((res) => {
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
img {
  width: 100px;
  height: 100px;
}
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
.avatar-uploader .el-upload {
  border: 1px dashed #d9d9d9;
  border-radius: 6px;
  cursor: pointer;
  position: relative;
  overflow: hidden;
}
.avatar-uploader1{
  border: 1px dashed #d9d9d9;
  width: 108px;
  height: 192px;
  .avatar-uploader-icon {
    font-size: 28px;
    color: #8c939d;
    width: 108px;
    height: 192px;
    line-height: 192px;
    text-align: center;
  }
  .avatar {
    width: 108px;
    height: 192px;
    display: block;
  }
}

.avatar-uploader2{
  border: 1px dashed #d9d9d9;
  width: 180px;
  height: 148px;
  .avatar-uploader-icon {
    font-size: 28px;
    color: #8c939d;
    width: 180px;
    height: 148px;
    line-height: 148px;
    text-align: center;
  }
  .avatar {
    width: 180px;
    height: 148px;
    display: block;
  }
}

.avatar-uploader3{
  border: 1px dashed #d9d9d9;
  width: 140px;
  height: 140px;
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
}
</style>
