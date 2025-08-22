<template>
  <div>
    <!-- 卡片 -->
    <div>
      <el-card class="box-card" shadow="never">
        <div slot="header" class="clearfix">
          <el-button class="btn" type="primary">保存</el-button>
          <el-button class="btn">取消</el-button>
        </div>
        <div class="phoneAll">
          <!-- 手机端布局 -->
          <div class="phoneStyle">
            <div class="phoneTop">这是一张图片</div>
          </div>
          <!-- 样式设置 -->
          <div class="phoneRight">
            <div class="r_top">
              <span class="cen_title">banner设置</span>
            </div>
            <div class="r_cen">
              <div class="cen_title">样式</div>
              <div class="r_select">
                <el-select v-model="value" placeholder="填充">
                  <el-option
                    v-for="item in options"
                    :key="item.value"
                    :label="item.label"
                    :value="item.value"
                  />
                </el-select>
              </div>
            </div>
            <div class="r_top">
              <span class="cen_title">内容</span>
            </div>
          </div>
        </div>
      </el-card>
    </div>
  </div>
</template>

<script>
export default {
  name: '',
  data() {
    return {
      options: [
        {
          value: '选项1',
          label: '黄金糕'
        },
        {
          value: '选项2',
          label: '双皮奶'
        },
        {
          value: '选项3',
          label: '蚵仔煎'
        },
        {
          value: '选项4',
          label: '龙须面'
        },
        {
          value: '选项5',
          label: '北京烤鸭'
        }
      ],
      value: ''
    }
  },
  methods: {}
}
</script>

<style scoped lang='scss'>
.btn {
  margin-right: 20px;
  float: right;
  width: 100px;
  height: 48px;
  border-radius: 4px;
}
.cen_title {
  margin: 10px 20px;
  font-size: 18px;
  color: #333333;
}
.phoneAll {
  display: flex;
  justify-content: space-around;
  .phoneStyle {
    width: 480px;
    height: 854px;
    border-radius: 10px;
    border: 1px solid red;
    .phoneTop {
    }
  }
  .phoneRight {
    width: 360px;
    height: 917px;
    background: #f7f7f7;
    .r_top {
      width: 360px;
      height: 70px;
      background: #e0e5eb;
      display: flex;
      align-items: center;
    }
    .r_cen {
      width: 360px;
      height: 106px;
      background: #f7f7f7;
    }
    .r_select {
      margin: 10px 20px;
    }
  }
}
</style>
