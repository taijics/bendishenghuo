<template>
  <el-dialog
    :close-on-click-modal="false"
    :title="title"
    :type="type"
    :visible.sync="isVisible"
    :modal-append-to-body="false"
    :center="true"
    width="80%"
    top="50px"
    class="dialog-wrap"
  >
    <el-form class="dialog-from" :model="params" label-width="120px">
      <el-form-item label="方案名称">
        <el-input
          v-model="params.logisticsName"
          maxlength="20"
          :readonly="isDisabled"
          onblur="value=value.replace(/(^\s*)|(\s*$)/g, '')"
        />
      </el-form-item>
      <el-form-item label="计费方式">
        <el-radio-group v-model="params.chargeType">
          <el-radio :disabled="isDisabled" :label="1">按件数</el-radio>
          <el-radio :disabled="isDisabled" :label="2">按重量</el-radio>
          <el-radio :disabled="isDisabled" :label="3">包邮</el-radio>
        </el-radio-group>
      </el-form-item>
      <template>
        <div
          v-for="(logisticsDetail, index) in params.charges"
          :key="index"
          class="delivery-area-item"
        >
          <i v-if="!isDisabled" class="delect-area el-icon-delete" @click="deleteLogistics(index)" />
          <el-form-item class="margin-bottom-0" label="可配送区域">
            <div
              class="add-area-btn text-overflow"
              :class="isDisabled?'disabled':''"
              :title="logisticsDetail.regions&&logisticsDetail.regions.toString()"
              @click="openAreaDialog(index)"
            >
              {{
                (logisticsDetail.regions &&
                  logisticsDetail.regions.length &&
                  logisticsDetail.regions.toString()) ||
                  '请选择'
              }}
            </div>
          </el-form-item>
          <el-form-item label="计费明细" v-if="params.chargeType!==3">
            <div class="form-item-row">
              <div class="el-row" style="margin-bottom: 10px;">
                首重/件费用 &nbsp;&nbsp;&nbsp;&nbsp;
                <el-input-number v-model="logisticsDetail.weight" :disabled="isDisabled" :controls="false" :max="999" :min="0" :precision="2" :step="0.01" />
                <!-- <el-input
                  v-model="logisticsDetail.weight"
                  maxlength="9"
                  :readonly="isDisabled"
                  placeholder="请输入内容"
                  oninput="value=value.replace(/^\D*(\d*(?:\.\d{0,2})?).*$/g, '$1')"
                /> -->
                KG/件
                <el-input-number v-model="logisticsDetail.price" :disabled="isDisabled" :controls="false" :max="999999999" :min="0" :precision="2" :step="0.01" />
                <!-- <el-input
                  v-model="logisticsDetail.price"
                  maxlength="9"
                  type="text"
                  :readonly="isDisabled"
                  placeholder="请输入内容"
                  oninput="value=value.replace(/^\D*(\d*(?:\.\d{0,2})?).*$/g, '$1')"
                /> -->
                元
              </div>
              <div class="el-row">
                续重/件费用 每
                <el-input-number v-model="logisticsDetail.secondWeight" :disabled="isDisabled" :controls="false" :max="999" :min="0" :precision="2" :step="0.01" />
                <!-- <el-input
                  v-model="logisticsDetail.secondWeight"
                  maxlength="9"
                  :readonly="isDisabled"
                  placeholder="请输入内容"
                  oninput="value=value.replace(/^\D*(\d*(?:\.\d{0,2})?).*$/g, '$1')"
                /> -->
                KG/件
                <el-input-number v-model="logisticsDetail.secondPrice" :disabled="isDisabled" :controls="false" :max="999999999" :min="0" :precision="2" :step="0.01" />
                <!-- <el-input
                  v-model="logisticsDetail.secondPrice"
                  maxlength="9"
                  :readonly="isDisabled"
                  placeholder="请输入内容"
                  oninput="value=value.replace(/^\D*(\d*(?:\.\d{0,2})?).*$/g, '$1')"
                /> -->
                元
              </div>
            </div>
          </el-form-item>
        </div>
      </template>
    </el-form>
    <div v-if="params.chargeType!==3" class="delivery-area-btn">
      <el-button v-if="!isDisabled" type="primary" @click="addArea">继续添加区域</el-button>
    </div>
    <div slot="footer" class="btn-wrap">
      <el-button type="primary" @click="onSubmit">确定</el-button>
      <el-button @click="isVisible = false">取消</el-button>
    </div>
    <el-dialog
      width="60%"
      title="选择配送区域"
      class="address-dialog"
      :visible.sync="areaVisible"
      append-to-body
    >
      <div class="area-dialog">
        <el-row>
          <template v-for="(province, index) in areaList">
            <el-col v-if="province.list.length > 0" :key="index" class="province-wrap" :span="8">
              <el-checkbox-group
                v-model="province.selected"
                @change="checkboxChange(province.keyId, province.selected)"
              >
                <el-checkbox>{{ province.provinceName }}</el-checkbox>
              </el-checkbox-group>
              <el-cascader
                v-model="province.selectCity"
                :options="province.list"
                :props="{
                  multiple: true,
                  children: 'list',
                  label: 'city',
                  value: 'city'
                }"
                collapse-tags
                filterable
                @change="changeCity(province)"
              />
            </el-col>
          </template>
        </el-row>
      </div>
      <div slot="footer" class="dialog-footer">
        <el-button @click="areaVisible = false">取 消</el-button>
        <el-button type="primary" @click="getSelectData">确 定</el-button>
      </div>
    </el-dialog>
  </el-dialog>
</template>
<script>
// import Setting from "@/api/Setting";
import { logisticsGetById, logisticsAdd, logisticsUpdate } from '@/api/shopSys'
import areaJSON from '@/assets/area'

export default {
  props: {
    dialogVisible: {
      type: Boolean,
      default: false
    },
    type: {
      type: String,
      default: 'add'
    }
  },
  data() {
    return {
      sizeForm: {},
      headers: {
        Authorization: ''
      },
      dataObj: {
        folderId: 1
      },
      params: {
        logisticsName: '',
        chargeType: 1,
        charges: [
          {
            weight: '',
            price: '',
            secondWeight: '',
            secondPrice: '',
            regions: []
          }
        ]
      },
      selectArea: [],
      areaVisible: false,
      areaList: [],
      areaFilter: [],
      currentSelectCity: [],
      currentAreaIndex: 0,
      checkId: null
    }
  },
  computed: {
    isVisible: {
      get() {
        return this.dialogVisible
      },
      set() {
        this.close()
        this.reset()
      }
    },
    isDisabled() {
      return this.type === 'check'
    },
    title() {
      const titleMap = {
        add: '新建方案',
        check: '查看方案',
        edit: '修改方案'
      }
      return titleMap[this.type]
    }
  },
  watch: {
    areaList: {
      handler() {
        // this.areaList.map(item => {
        //   const { selected, list } = item
        //   const allCity = list.map(cityItem => {
        //     const { city } = cityItem
        //     return city
        //   })
        //   if (selected) {
        //     this.selectArea = this.selectArea.concat(allCity)
        //   }
        // })
      },
      deep: true
    }
  },
  created() {
  },
  methods: {
    // 初始化地区
    initArea() {
      const { province_list, city_list } = areaJSON
      const provinceKeys = Object.keys(province_list)
      const cityKeys = Object.keys(city_list)
      this.areaList = provinceKeys.map(provinceKey => {
        provinceKey += ''
        let provinceList = []
        const provinceKeyId = provinceKey.slice(0, 2)
        const provinceName = province_list[provinceKey]
        let provinceSelected = false
        cityKeys.map(cityKey => {
          const cityKeyId = cityKey.slice(0, 2)
          const cityName = city_list[cityKey]
          if (
            provinceKeyId === cityKeyId &&
            this.areaFilter.indexOf(cityName) === -1
          ) {
            provinceList.push({
              id: cityKey,
              selected: false,
              city: cityName
            })
          }
        })
        // 回显
        let currentSelectCity = []
        if (this.currentSelectCity.indexOf(provinceName) > -1) {
          currentSelectCity = provinceList.map(cityItem => {
            return [cityItem.city]
          })
          provinceSelected = true
        } else {
          provinceList.map(cityItem => {
            if (this.currentSelectCity.indexOf(cityItem.city) > -1) {
              currentSelectCity.push([cityItem.city])
            }
          })
        }
        if (this.areaFilter.indexOf(provinceName) > -1) {
          provinceList = []
        }
        return {
          selectCity: currentSelectCity,
          keyId: provinceKeyId,
          selected: provinceSelected,
          provinceName: provinceName,
          list: provinceList
        }
      })
    },
    changeCity(item) {
      console.log(item, 'item')
      if (item.selectCity.length !== 0) {
        if (!item.selected) {
          item.selected = true
        }
      } else {
        item.selected = false
      }
    },
    // 全选省级
    checkboxChange(provincekeyId, selected) {
      this.areaList.map(item => {
        const { keyId, list } = item
        const allCity = list.map(cityItem => {
          const { city } = cityItem
          return [city]
        })
        if (keyId === provincekeyId && selected) {
          item.selectCity = allCity
        }
        if (keyId === provincekeyId && !selected) {
          item.selectCity = []
        }
        return item
      })
    },
    close() {
      this.$emit('close')
    },
    reset() {
      this.params = {
        logisticsName: '',
        chargeType: 1,
        chargingWay: 0,
        charges: [
          {
            weight: '',
            price: '',
            secondWeight: '',
            secondPrice: '',
            regions: []
          }
        ]
      }
    },
    // 添加地区
    addArea() {
      this.params.charges.push({
        weight: '',
        price: '',
        secondWeight: '',
        secondPrice: '',
        regions: []
      })
    },
    // 删除地区
    deleteLogistics(index) {
      console.log(this.params.charges)
      this.params.charges.splice(index, 1)
    },
    // 打开选择地区弹框
    openAreaDialog(index) {
      if (this.type === 'check') {
        return false
      }
      this.areaVisible = true
      this.currentAreaIndex = index
      // 获取已选择的城市
      this.areaFilter = []
      this.currentSelectCity = []
      this.params.charges.map((logisticsDetail, logisticsDetailIndex) => {
        // 获取其他可配送区域已选的城市
        const { regions } = logisticsDetail || ''

        if (index !== logisticsDetailIndex) {
          regions.map(region => {
            if (region.indexOf('-') > -1) {
              const regionSplit = region.split('-')
              const province = regionSplit[0]
              const citys = regionSplit[1] && regionSplit[1].split(',')
              if (province) {
                if (citys) {
                  this.areaFilter = this.areaFilter.concat(citys)
                }
              }
            } else {
              this.areaFilter.push(region)
            }
          })
        } else {
          regions.map(region => {
            if (region.indexOf(':') > -1) {
              const regionSplit = region.split(':')
              const province = regionSplit[0]
              const citys = regionSplit[1] && regionSplit[1].split(',')
              if (province) {
                if (citys) {
                  this.currentSelectCity = this.currentSelectCity.concat(citys)
                }
              }
            } else {
              this.currentSelectCity.push(region)
            }
          })
        }
      })
      this.initArea()
    },
    // 获取选择的地区
    getSelectedArea() {
      const selectAddressList = []
      this.areaList.map(areaItem => {
        const { selectCity, provinceName, list } = areaItem
        const citys = selectCity.map(city => {
          return city[0]
        })
        if (selectCity.length) {
          // 判断是否全选，全选就直接获取省级
          if (selectCity.length === list.length) {
            selectAddressList.push(provinceName)
          } else {
            const addressStr = provinceName + ':' + citys.toString()
            selectAddressList.push(addressStr)
          }
        }
      })
      return selectAddressList
    },
    getSelectData() {
      const selectedArea = this.getSelectedArea()
      this.params.charges[this.currentAreaIndex].regions = selectedArea
      this.areaVisible = false
    },
    // 查看详情
    async getDetails() {
      const res = await logisticsGetById({ logisticsId: this.checkId })
      if (res.code === '') {
        this.params = res.data
        // this.isVisible = false
        // this.$message({
        //   message: this.$t('tips.createSuccess'),
        //   type: 'success'
        // })
        // this.$emit('success')
      }
    },
    async onSubmit() {
      if (this.params.logisticsName === '') {
        this.$message.error('请输入方案名称')
      } else if (this.type === 'add') {
        this.add()
      } else if (this.type === 'edit') {
        this.update()
      } else {
        this.isVisible = false
      }
    },
    async add() {
      const res = await logisticsAdd(this.params)
      if (res.code === '') {
        this.isVisible = false
        this.$message({
          message: '成功添加',
          type: 'success'
        })
        this.$emit('success')
      }
    },
    async update() {
      const res = await logisticsUpdate(this.params)
      if (res.code === '') {
        this.isVisible = false
        this.$message({
          message: '成功',
          type: 'success'
        })
        this.$emit('success')
      }
    },
    handleImageSuccess(response) {
      const { url } = response.data
      this.params.productImg = url
    },
    delectProductImg() {
      this.params.productImg = ''
    },
    setParams(val = {}) {
      if (val['params']) {
        this.params = val['params']
      }
      if (val['checkId']) {
        this.checkId = val['checkId']
        this.getDetails()
      }
    }
  }
}
</script>
<style lang="scss" scoped>
.dialog-wrap {
  ::v-deep .el-dialog {
    display: flex;
    flex-direction: column;
    max-height: 80vh;
    max-width: 900px;
    overflow: hidden;

    .el-dialog__body {
      flex: 1;
      overflow: auto;
    }
  }

  .dialog-from {
    width: 80%;
    margin: auto;
  }

  .btn-wrap {
    margin: 45px auto 0;
    text-align: right;
  }

  .form-item-row {
    // padding-top: 40px;
    ::v-deep .el-input,.el-input-number {
      width: 100px;
      margin: 0 5px;
    }
  }
}

.delivery-area-item {
  position: relative;
  padding: 10px 25px 10px 0;
  background-color: #f7f8fa;
  border-bottom: 2px solid #fff;

  .margin-bottom-0 {
    margin-bottom: 0px;
  }

  .delect-area {
    position: absolute;
    top: 10px;
    right: 10px;
    font-size: 20px;
    z-index: 999;
  }

  .add-area-btn {
    overflow: hidden;
    color: #409eff;

    &.disabled {
      color: #c0c4cc;
    }
  }
}

.delivery-area-btn {
  margin: 15px auto;
  text-align: center;
}

.address-dialog {
  .province-wrap {
    position: relative;
    margin-bottom: 15px;
    display: flex;
    align-items: center;
    // 重写el-cascader样式
    ::v-deep .el-cascader {
      width: 100% !important;
      line-height: normal;

      .el-input {
        cursor: pointer;
        width: 100% !important;
        height: 28px !important;

        span.el-input__suffix {
          position: inherit !important;

          i.el-input__icon {
            line-height: inherit;
            margin-left: 5px;
          }
        }
      }

      input,
      .el-cascader__tags {
        display: none !important;
      }
    }
  }
}
</style>
