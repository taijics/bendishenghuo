<template>
  <div>
    <!-- 卡片 -->
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <!-- 选项卡 -->
        <div class="tabChange">
          <el-button class="uploadBtn" type="primary">上传</el-button>
          <el-tabs
            v-model="activeName"
            class="tabsRight"
            @tab-click="handleClick"
          >
            <el-tab-pane label="图片" name="first">图片</el-tab-pane>
            <el-tab-pane label="视频" name="second">视频</el-tab-pane>
          </el-tabs>
          <!-- 图片内容 -->
          <div class="imgOne">
            <div class="tagsList">
              <el-tag class="tagsBt">标签一</el-tag>
              <el-tag class="tagsBt">标签二</el-tag>
              <el-tag class="tagsBt">标签三</el-tag>
              <el-tag class="tagsBt">标签四</el-tag>
              <el-tag class="tagsBt">标签五</el-tag>
            </div>
            <div class="tagDetail">
              <div class="topTags" />
              <div class="tagsImgs">
                <img src="" alt="" />
              </div>
              <div class="tagBtns">
                <el-button type="text">添加</el-button>
                <el-button type="text">标签</el-button>
                <el-button type="text">删除</el-button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </el-card>
  </div>
</template>

<script>
export default {
  name: '',
  data() {
    return {
      activeName: 'first',
    }
  },
  methods: {
    //   点击选项卡
    handleClick(tab, event) {
      console.log(tab, event)
    },
  },
}
</script>

<style lang="scss" scoped>
.tabChange {
  padding: 10px;
}
.uploadBtn {
  float: right;
  width: 100px;
  height: 48px;
}
.tabsRight {
  margin: 10px 0 15px;
}
.tagsBt {
  margin-right: 20px;
}
.tagDetail {
  margin-top: 20px;
  .topTags {
    font-size: 16px;
    color: #333333;
  }
  .tagsImgs {
    width: 180px;
    height: 180px;
    background: #e0e5eb;
    border-radius: 8px;
  }
  .tagBtns {
    display: flex;
  }
}
</style>
