<template>
  <div class="content">
    <div class="inviteBox">
      <div class="leftBox">
        <div class="left">
          <div class="image">
            <img :src="PromConfigList.image" alt width="100%" height="100%">
          </div>
          <div class="user">
            <div style="width:80px;height:85px;">
              <img
                v-show="PromConfigList.ifHead==1"
                src="http://cereshop.oss-cn-shenzhen.aliyuncs.com/0000/2020/12/decef4c3-12bd-420e-9973-5c62f9b71b87.jpg"
                alt
                class="toux"
              >
            </div>
            <div style="width:200px;height:85px;">
              <p v-show="PromConfigList.ifHead==1">thomas</p>
              <p v-show="PromConfigList.ifHead==1">{{ PromConfigList.extensionReason }}</p>
            </div>
            <div style="width:94px;height:85px;">
              <img
                v-show="PromConfigList.ifLogo==1"
                src="http://cereshop.oss-cn-shenzhen.aliyuncs.com/0000/2020/12/decef4c3-12bd-420e-9973-5c62f9b71b87.jpg"
                alt
                class="erwei"
              >
            </div>
          </div>
        </div>
      </div>
      <div class="rightBox">
        <div class="flexBox">
          <span class="label">邀请下级：</span>
          <el-radio-group v-model="PromConfigList.ifLogo">
            <el-radio :label="1">展示二维码</el-radio>
            <el-radio :label="0">不展示</el-radio>
          </el-radio-group>
        </div>
        <div class="flexBox">
          <span class="label">头像昵称：</span>
          <el-radio-group v-model="PromConfigList.ifHead">
            <el-radio :label="1">展示</el-radio>
            <el-radio :label="0">不展示</el-radio>
          </el-radio-group>
        </div>
        <div class="flexBox">
          <span class="label">推荐语：</span>
          <el-input
            v-model="PromConfigList.extensionReason"
            type="textarea"
            :rows="4"
            :maxlength="50"
          />
        </div>
        <div class="backGroundBox">
          <div class="flexBox">
            <span class="label">背景图：</span>
            <el-upload
              :class="[{'avatar-uploader': !dialogImageUrl}]"
              :headers="headers"
              :data="dataObj"
              :action="action"
              :show-file-list="false"
              :on-success="handleAvatarSuccess"
            >
              <img
                v-if="PromConfigList.image"
                :src="PromConfigList.image"
                class="avatar"
                width="140"
                height="180"
              >
              <i v-else class="el-icon-plus avatar-uploader-icon" />
            </el-upload>
          </div>
          <div class="bgtext">最佳尺寸：875x1275像素。尺寸不匹配时，图片将被压缩或拉伸。</div>
          <div class="inviteBtnBox">
            <el-button type="primary" class="cancel" @click="cancel">取消</el-button>
            <el-button type="primary" class="subm" @click="subm">保存</el-button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { extensionGetAll, extensionSave } from '@/api/distributor'
import { uploadUrl } from '@/utils/request'
import { getToken } from '@/utils/auth'
export default {
  data() {
    return {
      action: uploadUrl,
      headers: {
        'Authorization-business': getToken()
      },
      dataObj: {
        folderId: 1
      },
      dialogImageUrl: '',
      PromConfigList: {
      },
      SalesQuery: {
        image: '',
        extensionReason: '',
        ifHead: 0,
        ifLogo: 0,
        type: 0
      }
    }
  },
  created() {
    this.getPromConfigList()
  },
  methods: {
    async getPromConfigList() {
      const res = await extensionGetAll({
        title: '推广店铺'
      })
      if (res.data.length === 0) {
        this.PromConfigList = this.SalesQuery
      } else {
        this.PromConfigList = res.data[0]
      }
    },
    cancel() {
      this.getPromConfigList()
    },

    subm() {
      this.updataSales()
    },
    async updataSales() {
      this.PromConfigList.title = '推广店铺'
      const res = await extensionSave(this.PromConfigList)
      if (res.code === '') {
        this.$message({
          message: '保存成功',
          type: 'success'
        })
      }
    },
    handleAvatarSuccess(response) {
      const url = response.data.url
      this.PromConfigList.image = url
    }
  }
}
</script>

<style lang='scss' scoped>
.content {
  padding: 40px 100px 40px;
  .inviteBtnBox {
    margin: 80px 0 0 150px;
  }
  .inviteBox {
    display: flex;
    .leftBox {
      margin-right: 80px;
    }
    .rightBox {
      flex: 1;
      .flexBox {
        display: flex;
        margin-bottom: 40px;
        .label {
          width: 150px;
          text-align: right;
        }
        .el-textarea {
          width: 350px;
        }
      }
    }
  }
  .left {
    width: 382px;
    height: 680px;
    background: #fefdfe;
    box-shadow: 0px 5px 10px 0px rgba(102, 102, 102, 0.1);
    border-radius: 10px;
    .image {
      width: 382px;
      height: 490px;
    }
    .user {
      width: 382px;
      margin-top: 40px;
      display: flex;
      padding: 10px;
      .toux {
        width: 70px;
        height: 70px;
        border-radius: 50%;
      }
      .erwei {
        width: 83px;
        height: 83px;
      }
    }
  }
  .left1 {
    width: 301px;
    height: 16px;
    font-size: 16px;
    font-family: PingFang SC;
    font-weight: 400;
    color: #666666;
    line-height: 36px;
  }
  .bgtext {
    width: 360px;
    height: 12px;
    font-size: 12px;
    font-family: PingFang SC;
    font-weight: 400;
    color: #666666;
    line-height: 18px;
    padding-left: 150px;
    display: block;
  }
  .cancel {
    width: 100px;
    height: 48px;
    background: #ffffff;
    border: 1px solid #e0e5eb;
    color: #333333;
    border-radius: 4px;
  }
  .subm {
    width: 100px;
    height: 48px;
    border-radius: 4px;
  }
}
::v-deep.avatar-uploader {
  width: 140px;
  height: 180px;
  border-radius: 6px;
  line-height: 180px;
  text-align: center;
  margin-bottom: 10px;
  .el-upload {
    border: 1px dashed #d9d9d9;
    border-radius: 6px;
    cursor: pointer;
    position: relative;
    overflow: hidden;
    height: 100%;
    .avatar-uploader-icon {
      font-size: 28px;
      color: #8c939d;
      width: 140px;
      height: 180px;
      line-height: 180px;
      text-align: center;
    }
  }
}
</style>

