<template>
  <!-- 编辑/添加地址 -->
  <view class="container flex-center flex-column">
    <!-- #ifdef MP-WEIXIN -->
    <!--    <view class="wxAddress flex-items flex-end" v-if="type == 1">-->
    <!--      <view class="wxBtnBox flex-items" @click="addAddressWx">-->
    <!--        <image class="" :src="`${VUE_APP_STATIC_URL}static/images/withdraw.png`"></image>-->
    <!--      </view>-->
    <!--    </view>-->
    <!-- #endif -->
    <view class="addressBack-box">
      <view class="consignee-box bor-line-F7F7F7">
        <input v-model="addressData.username" class="fs28"  placeholder-class="consignee" placeholder="收货人" />
      </view>
      <view class="iphoneNum-box bor-line-F7F7F7">
        <input type="number" v-model="addressData.phone" class="fs28" placeholder-class="iphoneNum" placeholder="手机号码" />
      </view>
      <view @click="locationClick" class="location-box bor-line-F7F7F7 flex-row-plus flex-sp-between flex-items">
        <view class="fs28 location">所在地</view>
        <view class="locationBox">
          <!--					<city-select v-model="locationShowFalg" @city-change="cityChange"></city-select>-->
          <u-picker-cere mode="region" v-model="locationShowFalg" @confirm="cityChange" :default-region='addressData.defaultRegion' title="所在地"></u-picker-cere>
          <text>{{addressData.ssqText}}</text>
          <image class="arrow mar-left-20" :src="`${VUE_APP_STATIC_URL}static/images/greyArrow.png`"></image>
        </view>
      </view>
      <view class="detailAddress-box">
        <input class="fs28" v-model="addressData.address" placeholder-class="detailAddress" placeholder="详细地址：如道路、门牌号、小区、楼栋号、单元等" />
      </view>
    </view>
    <view class="addressTagBack-box">
      <view @click="addressTagClick" class="addressTag-box bor-line-F7F7F7 flex-row-plus flex-sp-between flex-items">
        <view class="fs28 addressTag">地址标签</view>
        <view class="flex-items">
          <text >{{tag}}</text>
          <image class="arrow mar-left-20" :src="`${VUE_APP_STATIC_URL}static/images/greyArrow.png`"></image>
        </view>
      </view>
      <view class="defaultState-box flex-row-plus flex-sp-between flex-items">
        <view class="fs28 defaultState">设为默认地址</view>
        <u-switch v-model="ifDefault" active-color="#C5AA7B" inactive-color="#eee"></u-switch>
      </view>
    </view>
    <view class="deleteAddress-box" @click="delAddress" v-if="type == 2">
      <text class="font-color-C5AA7B">删除收货地址</text>
    </view>
    <view class="saveAddress-box">
      <submit-button width="690rpx" v-if="type == 1 || type == 3" text="保存" @submitEvent="addAddressClick"></submit-button>
      <submit-button width="690rpx" v-else text="保存" @submitEvent="saveAddressClick"></submit-button>
    </view>
    <!-- 所在地弹窗 -->
    <!-- <u-select v-model="locationShowFalg" safe-area-inset-bottom="true" mode="mutil-column-auto" :list="locationList" @confirm="locationConfirm" title="所在地"></u-select> -->
    <!-- 所在地弹窗 -->
    <!--		<u-select v-model="addressTagShowFalg" mode="single-column" :list="addressTagList" @confirm="addressTagconfirm" title="地址标签"></u-select>-->
    <u-picker-cere mode="selector" v-model="addressTagShowFalg" :range="addressTagList" range-key="label" @confirm="addressTagconfirm" title="地址标签" :default-selector="[addressTagIndex]"></u-picker-cere>
  </view>
</template>

<script setup>
import {ref} from "vue";
// import citySelect from './u-city-select.vue';
import {request} from "../../utils/request";
import API from "../../config/api";
import { onLoad } from "@dcloudio/uni-app";
import { VUE_APP_STATIC_URL } from "@/config/api";
import {btnUseLoading} from "../../hooks/bntUseLoading";

const { btnShowLoading } = btnUseLoading()
const show = ref(false)
const type = ref(1) // 1.添加新地址 2.编辑收货地址
const locationShowFalg = ref(false) // 所在地弹窗显示隐藏
// const locationList = ref([])
const provinceName = ref('')
const cityName = ref('')
const districtName = ref('')
const addressTagList = ref([
  {
    value: '1',
    label: '家'
  },
  {
    value: '2',
    label: '公司'
  },
  {
    value: '3',
    label: '学校'
  }
])
const addressTagShowFalg = ref(false) // 地址标签弹窗显示隐藏
const addressTagIndex = ref(0) // 当前地址标签索引
const tag = ref('') // 地址标签
const ifDefault = ref(0) // 是否默认地址
const id = ref('')
const ordertype = ref(0)
const editAddress = ref({})
// defaultRegion: []
const addressData = ref({
  username: '',
  phone: '',
  ssqText: '',
  address: '',
  defaultRegion: [],
  city:'',
  province:'',
})

onLoad((options) => {
  type.value = options.type
  if(options.ordertype == 1){
    ordertype.value = 1
  }
  let receiveId = options.receiveId
  id.value = receiveId
  // 如果是修改地址获取地址详细数据
  if(type.value == 2){
    request(API.receiveGetInfo,{receiveId:receiveId},"GET").then(res => {
      editAddress.value = res.data
      addressData.value.username = editAddress.value.receiveName
      addressData.value.phone = editAddress.value.receivePhone
      addressData.value.ssqText = editAddress.value.receiveAdress
      addressData.value.address = editAddress.value.address
      tag.value = editAddress.value.label
      for(let i=0;i<addressTagList.value.length;i++){
        if(addressTagList.value[i].label === tag.value){
          addressTagIndex.value = i
        }
      }
      ifDefault.value = editAddress.value.ifDefault
      addressData.value.defaultRegion = addressData.value.ssqText.split("-")
      addressData.value.province = addressData.value.defaultRegion[0]
      addressData.value.city = addressData.value.defaultRegion[1]
      addressData.value.area = addressData.value.defaultRegion[2]
      addressData.value.id = editAddress.value.receiveId
      uni.hideLoading()
    }).catch(res => {
    })
  }
  // 从微信导入数据
  if (type.value == 3) {
    let obj = JSON.parse(options.wxAddressData)
    addressData.value = obj
  }
  if(editAddress.value != ''){
    uni.removeStorageSync('editAddress')
  }
})

/**
 * 更改所在地数据
 * @param e
 */
const cityChange = (e) => {
  addressData.value.ssqText = e.province.label + '-' + e.city.label + '-' + e.area.label;
  addressData.value.province = e.province.label
  addressData.value.city = e.city.label
  addressData.value.area = e.area.label
}
/**
 * 显示更改所在地弹窗
 */
const locationClick = () => {
  locationShowFalg.value = true
}
/**
 * 确认所在地
 * @param e
 */
const locationConfirm = (e) => {
  provinceName.value = e[0].label
  cityName.value = e[1].label
  districtName.value = e[2].label
}
/**
 * 显示地址标签弹窗
 */
const addressTagClick = () => {
  addressTagShowFalg.value = true
}
/**
 * 确认地址标签
 * @param index
 */
const addressTagconfirm = (index) => {
  tag.value = addressTagList.value[index].label
}

/**
 * 编辑地址
 */
const saveAddressClick = async () => {
  let phoneCodeVerification = /^[1][3-9][0-9]{9}$/;
  if(addressData.value.username==''){
    uni.showToast({
      title: '请输入收货人！',
      duration: 2000,
      icon:'none'
    });
  }else if(addressData.value.phone ==''){
    uni.showToast({
      title: '请输入手机号！',
      duration: 2000,
      icon:'none'
    });
  }else if(!phoneCodeVerification.test(addressData.value.phone)){
    uni.showToast({
      title: '请输入正确的手机号！',
      duration: 2000,
      icon:'none'
    });
  }else if(addressData.value.province=='' || addressData.value.city==''){
    uni.showToast({
      title: '所在地不能为空！',
      duration: 2000,
      icon:'none'
    });
  }else if(addressData.value.address==''){
    uni.showToast({
      title: '请输入详细地址！',
      duration: 2000,
      icon:'none'
    });
  }else{
    btnShowLoading()
    try {
      const res = await request(API.AddresUpdate,{
        receiveId: id.value,
        receiveName: addressData.value.username,
        receivePhone: addressData.value.phone,
        receiveAdress: addressData.value.ssqText,
        address: addressData.value.address,
        label: tag.value,
        ifDefault: ifDefault.value ? 1 : 0
      },'POST')
      uni.navigateTo({
        url: 'address'
      })
      uni.removeStorageSync('editAddress');
    } catch (err) {}
  }
}

/**
 * 新增地址
 */
const addAddressClick = async () => {
  let phoneCodeVerification = /^[1][3-9][0-9]{9}$/;
  if(addressData.value.username==''){
    uni.showToast({
      title: '请输入收货人！',
      duration: 2000,
      icon:'none'
    });
  }else if(addressData.value.phone==''){
    uni.showToast({
      title: '请输入手机号！',
      duration: 2000,
      icon:'none'
    });
  }else if(!phoneCodeVerification.test(addressData.value.phone)){
    uni.showToast({
      title: '请输入正确的手机号！',
      duration: 2000,
      icon:'none'
    });
  }else if(addressData.value.province == '' || addressData.value.city==''){
    uni.showToast({
      title: '所在地不能为空！',
      duration: 2000,
      icon:'none'
    });
  }else if(addressData.value.address==''){
    uni.showToast({
      title: '请输入详细地址！',
      duration: 2000,
      icon:'none'
    });
  }else{
    btnShowLoading()
    try {
      const res = await request(API.AddresAdd, {
        receiveName: addressData.value.username,
        receivePhone: addressData.value.phone,
        receiveAdress: addressData.value.ssqText,
        address: addressData.value.address,
        label: tag.value,
        ifDefault: ifDefault.value ? 1 : 0
      },'POST')
      if(ordertype.value == 1){
        uni.setStorageSync('receiveItem', res.data)
        uni.navigateBack({
          delta: 2
        });
      }else{
        uni.navigateTo({
          url: 'address'
        })
      }
    } catch (err) {}
  }
}

/**
 * 删除地址
 */
const delAddress = () =>{
  uni.showModal({
    title: '温馨提示',
    content: '是否删除此地址？',
    confirmText:'确定',
    cancelText:'取消',
    success: (res)=> {
      if (res.confirm) {
        subm()
      } else if (res.cancel) {
      }
    }
  })
}

const subm = () => {
  request(API.AddresDelete,{
    receiveId: id.value
  },'POST').then(res => {
    if(res.code === "200"){
      uni.navigateTo({
        url: 'address'
      })
    }
  }).catch(res => {})
}
</script>

<style lang="scss">
page{
  background-color: #F7F7F7;
}
.container{
  .addressBack-box{
    background-color: #FFFFFF;
    padding: 30upx 30upx;
    .consignee-box{
      padding-bottom: 36upx;
      width: 690upx;
      margin-top: 20upx;
      .consignee{
        color: #999999;
        font-size: 28upx;
      }
    }
    .iphoneNum-box{
      padding-bottom: 36upx;
      width: 690upx;
      margin-top: 36upx;
      .iphoneNum{
        color: #999999;
        font-size: 28upx;
      }
    }
    .location-box{
      padding-bottom: 36upx;
      width: 690upx;
      margin-top: 36upx;
      .location{
        color: #999999;
        font-size: 28upx;
      }
      .locationBox {
        display: flex;
        align-items: center;
      }
    }
    .detailAddress-box{
      padding-bottom: 36upx;
      width: 690upx;
      margin-top: 36upx;
      input{
        width: 100%;
      }
      .detailAddress{
        color: #999999;
        font-size: 28upx;
      }
    }
  }
  .addressTagBack-box{
    background-color: #FFFFFF;
    padding: 30upx 30upx;
    margin-top: 20upx;
    .addressTag-box{
      padding-bottom: 36upx;
      width: 690upx;
      .addressTag{
        color: #999999;
        font-size: 28upx;
      }
    }
    .defaultState-box{
      padding-bottom: 10upx;
      width: 690upx;
      margin-top: 36upx;
      .defaultState{
        color: #999999;
        font-size: 28upx;
      }
    }
  }
  .arrow{
    width: 62upx;
    height: 62upx;
  }
  .saveAddress-box{
    position: fixed;
    bottom: 10rpx;
    left: 30upx;
    width: 100%;
    .saveAddress{
      width: 690upx;
      height: 100upx;
      text-align: center;
      line-height: 100upx;
      background: #333333;
      color: #FFEBC4;
    }
  }
  .wxAddress {
    height: 80rpx;
    text-align: center;
    line-height: 80rpx;
    color: #999999;
    .wxBtnBox {
      width: 100rpx;
      height: 80rpx;
      image {
        width: 80rpx;
        height: 80rpx;
      }
    }
  }
}
.deleteAddress-box{
  background-color: #FFFFFF;
  padding: 30upx 30upx;
  margin-top: 20upx;
}
.content{
  font-size: 35rpx;
  width: 500rpx;
  .btn{
    margin-bottom: 20rpx;
    width: 200rpx;
    background-image: linear-gradient( 135deg, #FFA100 10%, #FF7911 100%);
  }
}
</style>
<style scoped>
.addressBack-box /deep/ .u-tab-item{
  color: #C5AA7B !important;
  font-weight: 400 !important;
}
.addressBack-box /deep/ .u-tab-bar {
  background-color: #C5AA7B !important;
}
</style>
