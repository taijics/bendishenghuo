<template>
  <div>
    <!-- 卡片栏 -->
    <div class="cardStyle">
      <el-card class="box-card">
        <div slot="header" class="clearfix">
          <span class="card_span">店铺设置</span>
          <el-button class="btnShop" type="text" @click="edit">编辑</el-button>
        </div>
        <!-- 详情 -->
        <div class="shopDetail">
          <div class="shopDetail_l">
            <div class="shopMsg">店铺信息</div>
            <div class="logo">店铺logo</div>
            <div class="shopLogon">
              <img
                src="https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1605506967950&di=7692fca791ebfc8f4f15b548fc876199&imgtype=0&src=http%3A%2F%2Fc-ssl.duitang.com%2Fuploads%2Fitem%2F202005%2F13%2F20200513211905_wiMQM.thumb.400_0.jpeg"
                width="100"
                height="100"
              />
            </div>
            <div class="common">
              <span class="span_1">店铺名称：</span>
              <span class="span_2">哈子2号店</span>
            </div>
            <div class="common">
              <span class="span_1">发货地址：</span>
              <span class="span_2">广东省深圳市龙华区</span>
            </div>
            <div class="common span_f">
              <div class="span_1">店铺简介：</div>
              <div class="span_2">
                店铺简介店铺简介店铺简介店铺简介店铺简介店铺简介店铺简介店铺
                店铺简介店铺简介店铺简介店铺简介店铺简介店铺简介店铺简介店铺
              </div>
            </div>
            <div class="common">
              <span class="span_1">注册手机号：</span>
              <span class="span_2">13444444444</span>
            </div>
          </div>
          <div class="shopDetail_r">
            <div class="shopMsg">退货地址</div>
            <div class="common">
              <span class="span_1">退货地址：</span>
              <span class="span_2">广东省深圳市龙华区</span>
            </div>
            <div class="common">
              <span class="span_1">联系人</span>
              <span class="span_2">安安</span>
            </div>
            <div class="common">
              <span class="span_1">联系电话</span>
              <span class="span_2">1344444444</span>
            </div>
          </div>
        </div>
      </el-card>
    </div>
  </div>
</template>

<script>
export default {
  // import引入的组件需要注入到对象中才能使用
  components: {},
  data() {
    // 这里存放数据
    return {}
  },
  // 监听属性 类似于data概念
  computed: {},
  // 监控data中的数据变化
  watch: {},
  // 生命周期 - 创建完成（可以访问当前this实例）
  created() {},
  // 生命周期 - 挂载完成（可以访问DOM元素）
  mounted() {},
  // 方法集合
  methods: {
    // 编辑
    edit() {
      this.$router.push({ name: 'editShopSys', params: { id: '1' } })
    },
  },
}
</script>

<style lang="scss" scoped>
//@import url(); 引入公共css类
.shopDetail {
  display: flex;
  margin: 50px 50px;
}
.shopDetail_l {
  width: 49%;
}
.shopDetail_r {
  width: 49%;
}
.btnShop {
  float: right;
  width: 100px;
  height: 48px;
  background: #409eff;
  border-radius: 4px;
  color: #ffffff;
}
.common {
  padding: 10px;
}
.span_f {
  display: flex;
}
.card_span {
  font-size: 24px;
  color: #333333;
}
.shopMsg {
  font-size: 24px;
  color: #333333;
  padding: 10px;
}
.logo {
  font-size: 16px;
  color: #333333;
  padding: 10px;
}
.shopLogon {
  padding: 10px;
  img {
    width: 100px;
    height: 100px;
    border-radius: 50%;
  }
}
.span_1 {
  font-size: 16px;
  color: #333333;
}
.span_2 {
  font-size: 16px;
  color: #666666;
  width: 500px;
}
</style>
