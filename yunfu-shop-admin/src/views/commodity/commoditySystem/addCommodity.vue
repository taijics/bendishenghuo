<template>
  <div>
    <el-card class="box-card">
      <div slot="header">
        <span v-if="!productId" class="addTitle">新增商品</span>
        <span v-else class="addTitle">编辑商品</span>
        <el-button v-if="active" class="btnList" @click="back">取消</el-button>
        <el-button v-if="active" type="primary" class="btnList" @click="next">下一步</el-button>
        <el-button v-if="!active" type="primary" class="btnList" @click="save">保存</el-button>
        <el-button v-if="!active" class="btnList" @click="last">上一步</el-button>
      </div>
      <!-- 步骤条 -->
      <div class="stepsColor common">
        <div class="stepsOne common">
          <div :class="active ? 'one_class common' : 't_class common'">1</div>
          <div :class="active ? 'two_class' : 'w_class'">基本属性&商品描述</div>
        </div>
        <div class="line" />
        <div class="stepsTwo common">
          <div :class="active ? 't_class common' : 'one_class common'">2</div>
          <div :class="active ? 'w_class' : 'two_class' ">基本属性&商品描述</div>
        </div>
      </div>
    </el-card>
    <!-- 商品 -->
    <div class="addCom common">
      <div v-if="active">
        <el-form ref="form" :model="form" :rules="rules" label-width="80px" style="padding: 40px 40px;">
          <div class="leftCom">
            <el-form-item label="商品名称" prop="productName">
              <el-input v-model="form.productName" maxlength="20" show-word-limit />
            </el-form-item>
            <el-form-item label="卖点简介">
              <el-input v-model="form.productBrief" maxlength="50" show-word-limit />
            </el-form-item>
            <el-form-item>
              <Tinymce v-if="showTinymce" ref="content" v-model="form.productText" class="tinymce-wrap" :height="200" />
            </el-form-item>
          </div>
          <div class="rightCom">
            <el-form-item label="官方分类" prop="classifyId">
              <el-cascader
                v-model="form.classifyId"
                :options="classifyList"
                clearable
                :props="{
                  checkStrictly: false,
                  label:'categoryName',
                  value:'id',
                  children:'childs'
                }"
                @change="handleChangeCascader"
              />
            </el-form-item>

            <el-form-item label="商品分组" prop="shopGroupId">
              <el-select v-model="form.shopGroupId" placeholder="请选择商品分组" clearable>
                <el-option
                  v-for="(item,index) in groupList"
                  :key="index"
                  :label="item.groupName"
                  :value="item.shopGroupId"
                />
              </el-select>
            </el-form-item>
            <el-form-item label="品牌">
              <el-select
                v-model="form.brandId"
                clearable
                placeholder="请选择品牌"
              >
                <el-option
                  v-for="item in brandList"
                  :key="item.id"
                  :label="item.brandName"
                  :value="item.id"
                />
              </el-select>
            </el-form-item>
            <el-form-item class="form-item-long" label="供应商">
              <el-input v-model="form.supplierName" maxlength="20" show-word-limit placeholder="请输入供应商名称" />
            </el-form-item>
            <el-form-item label="需要物流" prop="ifLogistics">
              <el-radio-group v-model="form.ifLogistics">
                <el-radio :label="1">是</el-radio>
                <el-radio :label="0">否</el-radio>
              </el-radio-group>
            </el-form-item>
            <el-form-item label="上架状态" prop="shelveState">
              <el-radio-group v-model="form.shelveState">
                <el-radio :label="1">上架</el-radio>
                <el-radio :label="0">下架</el-radio>
              </el-radio-group>
            </el-form-item>
            <el-form-item label="允许超卖" prop="ifOversold">
              <el-radio-group v-model="form.ifOversold">
                <el-radio :label="1">允许</el-radio>
                <el-radio :label="0">不允许</el-radio>
              </el-radio-group>
            </el-form-item>
            <el-form-item label="积分兑换" prop="ifCredit">
              <el-radio-group v-model="form.ifCredit">
                <el-radio :label="1">允许</el-radio>
                <el-radio :label="0">不允许</el-radio>
              </el-radio-group>
              <p style="color: #cf0f0f">开启积分兑换后，积分所抵扣的金额由商户承担</p>
            </el-form-item>
            <el-form-item v-if="form.ifCredit" class="form-item-long" label="单笔最大抵扣" prop="creditLimit">
              <!-- <el-input v-model="form.creditLimit" type="number" placeholder="请输入单笔最大抵扣" /> -->
              <el-input-number v-model="form.creditLimit" :controls="false" :max="999999999" :min="0" :precision="0" placeholder="请输入单笔最大抵扣" />
              <p style="color: #cf0f0f; height: 25px; line-height: 25px;margin-top: 10px">限制一笔订单中该商品最多抵扣多少积分</p>
              <p style="color: #cf0f0f; height: 25px; line-height: 25px">( 注：1积分 = {{ integralProportion }}元 请输入整数 )</p>
            </el-form-item>
          <!--            <el-form-item label="花呗分期">-->
          <!--              <el-radio-group v-model="form.ifHuabei">-->
          <!--                <el-radio :label="1">支持</el-radio>-->
          <!--                <el-radio :label="0">不支持</el-radio>-->
          <!--              </el-radio-group>-->
          <!--            </el-form-item>-->
          </div>
        </el-form>
      </div>
      <div v-if="!active" class="centerCom">
        <el-form ref="form" :model="params" label-width="80px">
          <StyleInformation :form="params" />
        </el-form>
      </div>
    </div>

    <!-- 弹窗 -->
    <el-dialog
      :visible.sync="dialogVisible"
      class="check-image-dialog"
      title="查看图片"
      center="center"
    >
      <img width="100%" :src="dialogImageUrl" alt>
    </el-dialog>
  </div>
</template>

<script>
import Tinymce from '@/components/Tinymce'
import {
  getGroupSelect,
  getClassify,
  getClassifyAdd,
  getClassifyGetById,
  getClassifyUpdate,
  getBrandList
} from '@/api/commodity'
import {
  getSelect
} from '@/api/account';
import { uploadUrl } from '@/utils/request'
import StyleInformation from './addComponent'
export default {
  components: {
    Tinymce,
    StyleInformation
  },
  props: {
    productId: {
      type: Number,
      default: 0
    },
    showTinymce: {
      type: Boolean
    }
  },
  data() {
    // const checkCreditLimit = (rule, value, callback) => {
    //   console.log(this.form.ifCredit)
    //   if (this.form.ifCredit) {
    //     callback(new Error('当选择允许积分兑换时，必须填写该值'))
    //   }
    //   const reg = /^[1-9]\d*$/
    //   if (value === '' || value === undefined || value === null) {
    //     callback();
    //   } else {
    //     if ((!reg.test(value)) && value !== '') {
    //       callback(new Error('请输入正确的价格'));
    //     } else {
    //       callback();
    //     }
    //   }
    //   callback()
    // }
    return {
      brandList: [],
      active: 1,
      action: uploadUrl,
      form: {
        brandId: null, // 品牌ID
        productName: '', // 商品名称
        productBrief: '', // 商品简介
        shopGroupId: '', // 商品分组id
        classifyId: '', // 分类id
        supplierName: '', // 供应商名称
        ifLogistics: '', // 是否需要物流 1-是 0-否
        shelveState: '', // 是否上架 1-上架 0-不上架
        ifOversold: '', // 是否允许超卖 1-是 0-否
        ifCredit: '', // 是否支持积分兑换 1-是 0-否
        creditLimit: '', // 单笔订单限制使用多少积分
        ifHuabei: 1, // 是否支持花呗分期 1-是 0-否
        productText: '', // 商品描述（富文本）
        images: [], // "图片地址"
        deletes: [], // 删除的规格id数组
        names: [
          {
            code: '', // 级别
            skuName: '', // 规格名
            values: [
              {
                valueCode: '', // 级别
                skuValue: '', // 规格值
                image: '' // 图片
              }
            ]
          }
        ],
        skus: [
          {
            skuName: '', // 规格名称
            skuValue: '', // 规格值
            price: '', // 售价
            originalPrice: '', // 原价
            stockNumber: '', // 库存数量
            weight: '', // 重量
            skuImage: '', // 配图地址
            style: '' // 款式  1-单款式 2-多款式
          }
        ]
      },
      params: {
        applyPrice: 0,
        attrStyle: 0,
        categoryId: '',
        oversold: 1,
        collects: 0,
        groupId: '',
        imgs: [],
        deletes: [], // 删除规格数据
        isDelete: 0,
        limitCount: 0,
        minusStock: '',
        needLogistics: 1,
        platform: '',
        price: 0,
        productCode: '',
        productName: '',
        sellCount: 0,
        sellDesc: '',
        sellType: '',
        shortName: '',
        skuAttrList: [
          {
            code: '',
            skuName: '',
            needImg: false,
            values: [
              {
                skuValue: '',
                valueCode: '',
                image: ''
              }
            ]
          }
        ],
        skuList: [
          {
            isDelete: '',
            skuAttrCodeDTOList: [
              {
                code: '',
                valueCode: ''
              }
            ],
            skuAttrList: [],
            sku: '',
            skuImg: '',
            price: 0,
            originalPrice: 0,
            stockNumber: 0,
            weight: 0
          }
        ],
        sortOrder: '',
        status: '',
        stock: '',
        supplierName: '',
        views: '',
        weight: ''
      },
      imgList: [],
      groupList: [],
      classifyList: [],
      dialogImageUrl: '',
      dialogVisible: false,
      rules: {
        productName: [{ required: true, message: '请输入商品名称', trigger: 'blur' }],
        shopGroupId: [{ required: true, message: '请选择商品分组', trigger: 'change' }],
        classifyId: [{ required: true, message: '请选择商品分类', trigger: 'change' }],
        ifLogistics: [{ required: true, message: '请选择是否需要物流', trigger: 'change' }],
        shelveState: [{ required: true, message: '请选择是否上架', trigger: 'change' }],
        ifOversold: [{ required: true, message: '请选择是否允许超卖', trigger: 'change' }],
        ifCredit: [{ required: true, message: '请选择是否支持积分兑换', trigger: 'change' }],
        creditLimit: [{ required: true, message: '请输入单笔最大抵扣', trigger: 'blur' }]
      },
      integralList: [],
      integralProportion: '' // 积分兑换金额比例
    }
  },
  watch: {
    productId: {
      handler(nVal, oVal) {
        if (nVal) {
          // this.details()
        }
      }
    },
  },
  mounted() {
    this.groups()
    this.selectList()
    this.getBrandList()
    // if (this.productId) {
    //   this.details()
    // }
    this.getCredit()
  },
  methods: {
    handleChangeCascader() {
      console.log(this.form.classifyId)
    },
    async getBrandList() {
      const { data } = await getBrandList()
      this.brandList = data
    },
    async getCredit() {
      const res = await getSelect({ dictName: 'CREDIT_CONFIG' })
      this.integralList = res.data
      this.integralList.forEach((item) => {
        if (item.dictName === 'credit_exchange_rate') {
          this.integralProportion = item.dictDescribe
        }
      })
    },
    handleImageSuccess(response) {
      const { url } = response.data
      this.imgList.push(url)
    },
    handlePictureCardPreview(file) {
      this.dialogImageUrl = file.imgPath
      this.dialogVisible = true
    },
    // 移除图片
    handleRemove(file) {
      const { imgPath } = file
      this.form.imgs = this.form.imgs.filter(item => {
        return item.imgPath !== imgPath
      })
    },
    // 下一步
    next() {
      this.$refs['form'].validate((valid) => {
        console.log('val', valid)
        if (valid) {
          if (this.active === 1) {
            this.active = 0
            // console.log(this.form);
            sessionStorage.setItem('form', JSON.stringify(this.form.skus))
          }
        } else {
          this.$message({
            message: '请填写正确的信息',
            type: 'warning'
          })
          return false
        }
      })
    },
    // 点击新增商品时表单数据重置
    reset() {
      // this.form.productText = ''
      this.form = {
        productName: '',
        productBrief: '',
        shopGroupId: '',
        classifyId: '',
        supplierName: '',
        ifLogistics: '',
        shelveState: ' ',
        ifOversold: '',
        ifCredit: '',
        creditLimit: '',
        ifHuabei: 1,
        productText: '',
        images: [],
        deletes: [],
        names: [
          {
            code: '',
            skuName: '',
            values: [
              {
                valueCode: '',
                skuValue: '',
                image: ''
              }
            ]
          }
        ],
        skus: [
          {
            skuName: '',
            skuValue: '',
            price: '',
            originalPrice: '',
            stockNumber: '',
            weight: '',
            skuImage: '',
            style: ''
          }
        ]
      }
      this.params = {
        applyPrice: 0,
        attrStyle: 0,
        categoryId: '',
        oversold: 1,
        collects: 0,
        groupId: '',
        imgs: [],
        deletes: [],
        isDelete: 0,
        limitCount: 0,
        minusStock: '',
        needLogistics: 1,
        platform: '',
        price: 0,
        productCode: '',
        productName: '',
        sellCount: 0,
        sellDesc: '',
        sellType: '',
        shortName: '',
        skuAttrList: [
          {
            code: '',
            skuName: '',
            needImg: false,
            values: [
              {
                skuValue: '',
                valueCode: '',
                image: ''
              }
            ]
          }
        ],
        skuList: [
          {
            isDelete: '',
            skuAttrCodeDTOList: [
              {
                code: '',
                valueCode: ''
              }
            ],
            skuAttrList: [],
            sku: '',
            skuImg: '',
            price: 0,
            originalPrice: 0,
            stockNumber: 0,
            weight: 0
          }
        ],
        sortOrder: '',
        status: '',
        stock: '',
        supplierName: '',
        views: '',
        weight: ''
      }
      this.imgList = []
      this.dialogImageUrl = ''
      this.dialogVisible = false
      this.active = 1
    },
    // 返回
    back() {
      this.active = 1
      this.$emit('cancel')
    },
    // 上一步
    last() {
      if (this.active !== 1) {
        this.active = 1
      }
    },
    // 保存
    async save() {
      console.log(this.params.skuAttrList)
      if (this.params.attrStyle === 1) {
        for (let i = 0; i < this.params.skuAttrList.length; i++) {
          if (this.params.skuAttrList[i].skuName === '') {
            this.$message({
              message: '规格名不能为空',
              type: 'warning'
            })
            return false
          }
        }
      }
      this.form.names = this.params.skuAttrList
      this.params.skuList.forEach(element => {
        element.style = this.params.attrStyle
      })
      this.form.skus = this.params.skuList
      this.form.images = this.params.imgs
      this.form.deletes = this.params.deletes
      this.form.classifyId = Array.isArray(this.form.classifyId) ? this.form.classifyId[this.form.classifyId.length - 1] : this.form.classifyId
      if (this.productId) {
        this.form.productId = this.productId
        const sku = JSON.parse(sessionStorage.getItem('form'))
        console.log(sku)
        sku.forEach((element, i) => {
          for (let index = 0; index < this.form.skus.length; index++) {
            if (i === index) {
              this.form.skus[index].skuId = element.skuId
            }
          }
        })
        console.log(this.form, 'this.form')
        const res = await getClassifyUpdate(this.form)
        console.log(res)
        if (res.code === '') {
          this.$message({
            type: 'success',
            message: '成功!'
          })
          this.back()
        }
      } else {
        const res = await getClassifyAdd(this.form)
        if (res.code === '') {
          this.$message({
            type: 'success',
            message: '成功!'
          })
          this.reset()
          this.back()
        }
      }
    },
    // 获取商品分组
    async groups() {
      const res = await getGroupSelect({
      })
      this.groupList = res.data
    },
    // 获取详情
    async details() {
      const res = await getClassifyGetById({ productId: this.productId })
      this.form = res.data
      this.$set(this.form, 'productText', res.data.productText)
      // this.form.productText = res.data.productText
      // console.log(this.form.productText, 'productText')
      if (res.data.names.length !== 0) {
        this.params.skuAttrList = res.data.names
      }
      // this.params.skuAttrList.forEach((item) => {
      //   var data = {}
      //   var arr = Object.keys(res.data)
      //   if (arr.length === 0) {
      //     item.needImg = false
      //   }
      // })
      this.params.skuList = this.form.skus
      this.params.attrStyle = res.data.skus[0].style
      this.params.imgs = res.data.images
    },
    async selectList() {
      const res = await getClassify()
      this.classifyList = this.filterList(res.data)
    },
    filterList(data) {
      data.forEach(i => {
        if (i.childs.length) {
          this.filterList(i.childs)
        } else {
          i.childs = null
        }
      })
      return data
    }
  }
}
</script>

<style scoped lang='scss'>
@import url("../../../styles/elDialog.scss");
.btnList {
  float: right;
  padding: 3px 0;
  width: 100px;
  height: 40px;
  border-radius: 4px;
  margin-right: 30px;
}
.addTitle {
  font-size: 20px;
  color: #333333;
  line-height: 50px;
}
.stepsColor{
  font-size: 20px;
  line-height: 40px;
  .one_class {
    width: 40px;
    background: #3a68f2;
    border-radius: 50%;
    color: #ffffff;
    margin: 0 10px;
  }
  .two_class {
    color: #3a68f2;
  }
  .line {
    width: 230px;
    height: 2px;
    background: #e0e5eb;
    margin: 0 20px;
  }
  .t_class {
    width: 40px;
    background: #dddddd;
    border-radius: 50%;
    color: #333333;
    margin: 0 10px;
  }
  .w_class {
    color: #666666;
  }
}
.common {
  display: flex;
  justify-content: center;
  align-items: center;
}

.addCom {
  margin: 10px 0;
  justify-content: space-around;
  align-items: unset;
  .el-form{
    display: flex;
    padding: 40px 0;
  }
  .leftCom {
    width: 65%;
    background: #ffffff;
  }
  .rightCom {
    width: 35%;
    background: #ffffff;
    margin-left: 80px;
  }
}
.centerCom {
  width: 1660px;
  background: #ffffff;
  box-shadow: 0px 5px 20px 0px rgba(51, 51, 51, 0.15);
  border-radius: 4px;
}
</style>
<style scoped>
.form-item-long >>> .el-input {
  width: 100%;
}
</style>
