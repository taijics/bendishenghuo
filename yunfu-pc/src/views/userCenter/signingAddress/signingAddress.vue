<template>
  <div class="addressBox">
    <div class="addAddressBox">
      <span class="addAddressBtn" @click="addAddressBtn">新增收货地址</span>
    </div>
    <div class="addressList clearfix sub-main" v-loading="loading" v-if="flag">
      <div class="addressItem" :class="{active:item.ifDefault}" v-for="(item) of addressData.list" :key="item.receiveId">
        <div class="listItemInfoBox">
          <div class="isDefault">
            <span>设为默认地址</span>
            <el-switch
              v-model="item.ifDefault"
              :active-value="1"
              :inactive-value="0"
              @change="changeDefultAd(item)"
              active-color="#C5AA7B"
              inactive-color="#c1c1c1">
            </el-switch>
          </div>
          <div class="addressInfo">
            <div class="infoItem infoName" :title="item.receiveName">{{item.receiveName}}</div>
            <div class="infoItem">{{item.receiveAdress}}-{{item.address}}</div>
            <!-- <div class="infoItem"></div> -->
            <div class="infoItem infoPhone">{{item.receivePhone}}</div>
            <div class="btns">
              <span class="btnItem" @click="showDelete(item)"><i class="iconfont">&#xe62c;</i></span>
              <span class="btnItem" @click="changeAddress(item)"><i class="iconfont">&#xe605;</i></span>
              <div v-show="item.ifDefault" class="iconfont defaultActive">&#xe612;</div>
            </div>
          </div>
        </div>
      </div>
      <div class="clearfix"></div>
      <el-pagination
        class=""
        background
        layout="prev, pager, next, jumper"
        :page-size="4"
        :current-page="page"
        @current-change="handleCurrentChange"
        :total="addressData.total">
      </el-pagination>
    </div>
    <div class="nothing sub-main" v-else>
      <icon-svg style="width: 240px; height: 240px; margin-bottom: 20px;" icon-class="user-dingwei-nodata" />
      <p class="fs20 font-color-999">你还没有收货地址～</p>
    </div>
    <el-dialog
      :title="addTitle"
      :visible.sync="addAddressShow"
      :close-on-click-modal="false"
      width="750px">
      <AddAddress @hideAddDialog="hideAddDialog" @cancelAdd="closeAdd" />
    </el-dialog>
    <el-dialog
      title="是否删除此项"
      :visible.sync="showDeleteAdd"
      width="30%">
      <div class="deleteAddInfo">
        <p>收货人： {{delCurrentAdd.receiveName}}</p>
        <p>手机号码： {{delCurrentAdd.receivePhone}}</p>
        <p>收货地址： {{delCurrentAdd.receiveAdress}} {{delCurrentAdd.address}}</p>
      </div>
      <span slot="footer" class="dialog-footer">
        <el-button type="primary" @click="deleteAdd" v-throttle>确 定</el-button>
        <el-button @click="showDeleteAdd = false">取 消</el-button>
      </span>
    </el-dialog>
  </div>
</template>

<script>
import AddAddress from '@/components/orderInfo/addAddress'
import { TextToCode } from 'element-china-area-data'
import {mapGetters, mapMutations} from 'vuex'
import {
  getAllAddressList,
  addAddress,
  updateAddress,
  deleteAddress
} from '@/api/user/address.js'
export default {
  name: 'signingAddress',
  components: {
    AddAddress
  },
  data () {
    return {
      ifDefault: false,
      showDeleteAdd: false,
      addAddressShow: false,
      addTitle: '新建收货地址',
      page: 1,
      pageSize: 4,
      addressData: [],
      delCurrentAdd: {},
      loading: false,
      flag: false
    }
  },
  mounted () {
    this.getAddressList()
  },
  computed: {
    ...mapGetters([
      'newAddress' // 新增修改收货地址
    ])
  },
  methods: {
    ...mapMutations({
      seNewAddress: 'SET_NEWADDRESS', // 新增修改收货地址
      setAreacode: 'SET_AREACODE' // 新增修改收货地址
    }),
    // 获取地址列表
    async getAddressList () {
      this.loading = true
      const response = await getAllAddressList({
        page: this.page,
        pageSize: this.pageSize
      })
      const res = response.data
      if (res.code === '200') {
        this.addressData = res.data
        if (res.data.list.length === 0) {
          this.flag = false
        } else {
          this.flag = true
        }
        this.loading = false
      } else {
        this.$message.warning(res.message)
      }
    },
    handleCurrentChange (val) {
      this.page = val
      this.getAddressList()
    },
    showDelete (item) {
      this.showDeleteAdd = true
      this.delCurrentAdd = item
    },
    // 删除地址
    async deleteAdd () {
      const response = await deleteAddress({ receiveId: this.delCurrentAdd.receiveId })
      const res = response.data
      if (res.code === '200') {
        this.showDeleteAdd = false
        this.$message.success('删除成功')
        this.page = 0
        this.addressData = []
        this.getAddressList()
      } else {
        this.$message.error(res.message)
      }
      this.showDeleteAdd = false
    },
    // 修改默认地址
    changeDefultAd (item) {
      this.seNewAddress(item)
      this.updateAddressFun()
    },
    // 修改地址信息
    changeAddress (item) {
      let addressData = item.receiveAdress.split('-')
      let areaData = []
      areaData.push(TextToCode[addressData[0]].code)
      areaData.push(TextToCode[addressData[0]][addressData[1]].code)
      areaData.push(TextToCode[addressData[0]][addressData[1]][addressData[2]].code)
      let currentItem = JSON.parse(JSON.stringify(item))
      // console.log(areaData)
      this.seNewAddress(currentItem)
      this.setAreacode(areaData)
      this.addTitle = '修改收货地址'
      this.addAddressShow = true
    },
    addAddressBtn () {
      let obj = {
        receiveName: '',
        receivePhone: '',
        receiveAdress: '',
        address: '',
        label: '',
        isDefault: false
      }
      this.setAreacode([])
      this.seNewAddress(obj)
      this.addTitle = '新增收货地址'
      this.addAddressShow = true
    },
    // 新增地址
    async hideAddDialog () {
      this.addAddressShow = false
      if (this.newAddress.receiveId) {
        this.updateAddressFun()
      } else {
        const response = await addAddress({
          receiveName: this.newAddress.receiveName,
          receivePhone: this.newAddress.receivePhone,
          receiveAdress: this.newAddress.receiveAdress,
          address: this.newAddress.address,
          label: '',
          ifDefault: this.newAddress.ifDefault ? 1 : 0
        })
        const res = response.data
        if (res.code === '200') {
          this.$message({
            message: '地址添加成功',
            type: 'success'
          })
          this.page = 1
          this.addressData = []
          this.setAreacode([])
          this.getAddressList()
        } else {
          this.$message.error(res.message)
        }
      }
    },
    // 修改地址
    async updateAddressFun () {
      this.addAddressShow = false
      const response = await updateAddress({
        receiveId: this.newAddress.receiveId,
        receiveName: this.newAddress.receiveName,
        receivePhone: this.newAddress.receivePhone,
        receiveAdress: this.newAddress.receiveAdress,
        address: this.newAddress.address,
        label: '',
        ifDefault: this.newAddress.ifDefault ? 1 : 0
      })
      const res = response.data
      if (res.code === '200') {
        this.$message({
          message: '地址修改成功',
          type: 'success'
        })
        this.page = 1
        this.addressData = []
        this.setAreacode([])
        this.getAddressList()
      } else {
        this.$message.error(res.message)
      }
    },
    closeAdd () {
      this.addAddressShow = false
    },
    handleClose (done) {
      this.$confirm('确认关闭？')
        .then(_ => {
          done()
        })
        .catch(_ => {})
    }
  }
}
</script>

<style lang="scss" scoped>
.addressBox {
  border: 1px solid #E5E5E5;
  min-height: 500px;
  .addAddressBox{
    height: 50px;
    background-color: #FAFAFA;
    .addAddressBtn {
      font-size: 16px;
      color: $mainGlod;
      line-height: 50px;
      // background: #FFFFFF;
      // border: 1px solid $mainGlod;
      border-radius: 4px;
      padding: 4px 20px;
      cursor: pointer;
    }
  }
  .addressList {
    margin-top: 20px;
    .addressItem {
      // width: 477px;
      border: 2px solid #DDDDDD;
      border-radius: 4px;
      box-sizing: border-box;
      margin: 20px;
      .listItemInfoBox {
        padding: 20px;
        .isDefault {
          display: flex;
          align-items: center;
          height: 35px;
          // justify-content: flex-end;
          span {
            color: #333333;
            font-size: 16px;
            margin-right: 5px;
          }
        }
        .addressInfo {
          display: flex;
          .infoItem {
            flex: 10;
            color: #333333;
            font-size: 16px;
            margin: 30px;
          }
          .infoName{
            flex: 5;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
          }
          .infoPhone{
            flex: 5;
          }
          .infoItem:last-child {
            margin-bottom: 0;
          }
          .btns{
            width: 100px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            i{
              font: 20px !important;
            }
            .btnItem{
              cursor: pointer;
            }
          }
        }
      }
      .addressChange {
        border-top: #CCCCCC solid 1px;
        height: 45px;
        line-height: 45px;
        position: relative;
        i {
          margin-right: 5px;
        }
        .defaultActive {
          position: absolute;
          right: -1px;
          bottom: -3px;
          width: 46px;
          height: 46px;
          color: $mainGlod;
          font-size: 46px;
        }
        span {
          display: block;
          float: left;
          width: 50%;
          color: #666666;
          text-align: center;
          cursor: pointer;
        }
        span:nth-child(2) {
          border-left: 1px solid #CCCCCC;
          color: $mainGlod;
          box-sizing: border-box;
        }
      }
    }
    .active {
      border: 2px solid $mainGlod;
    }
  }
  >>> .el-dialog {
    .el-dialog__body {
      // background: #F8F8F8;
    }
    .el-dialog__header {
      text-align: center;
    }
    .dialog-footer {
      display: flex;
      justify-content: center;
      width: 100%;
      button {
        width: 200px;
        height: 50px;
      }
    }
  }
  .deleteAddInfo {
    width: 70%;
    margin: 0 auto;
    p {
      line-height: 30px;
    }
  }
  >>> .el-pagination {
    text-align: right;
    margin: 20px;
  }
}
.sub-main{
  min-height: 400px;
}
.nothing{
  width: 100%;
  margin: 20px;
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
</style>
