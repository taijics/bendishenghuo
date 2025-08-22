<template>
  <div class="module-box single-img">
    <div class="single-img__box">
      <el-upload
        drag
        :headers="headers"
        :action="fileUploadApi.fileUpload"
        :on-success="handleAvatarSuccess"
        :before-upload="beforeAvatarUpload"
        :show-file-list="false"
      >
        <img v-if="imageUrl" :src="imageUrl" class="single-img__img">
        <i v-else class="el-icon-upload">
          <div class="el-upload__text"><em>选择图片</em></div>
          <div class="el-upload__tip" slot="tip">{{tip}}</div>
        </i>
      </el-upload>
      <div class="overlay" v-if="imageUrl">
        <i class="iconfont icon-chakan" @click="showImage"></i>
        <i class="iconfont icon-shanchu1" @click="delImage"></i>
      </div>
    </div>
    <el-dialog title="图片展示" :visible.sync="dialogVisible">
      <img width="100%" :src="dialogImageUrl" alt="">
    </el-dialog>
  </div>
</template>

<script>
  import api from '@@/components/canvasShow/config/api'
  import {sendReqMixin} from '@@/components/canvasShow/config/mixin'
  import { getToken } from '@/utils/auth.js'
  export default {
    name: 'tool-single-img',
    mixins: [sendReqMixin],
    data () {
      return {
        dialogVisible: false,
        dialogImageUrl: '',
        fileUploadApi: {
          fileUpload: ''
        },
        headers: {
          'Authorization-business': getToken()
        },
      }
    },
    props: {
      imageUrl: {
        type: String,
        default: ''
      },
      tip: {
        type: String,
        default: '建议尺寸: 1080*900px, 高度自适应'
      }
    },
    mounted () {
      console.log(api)
      this.fileUploadApi = api
    },
    methods: {
      handleAvatarSuccess (res, file) {
        this.$emit('update:imageUrl', res.data.url)
      },
      beforeAvatarUpload (file) {
        const isLt1M = file.size / 1024 / 1024 < 1
        if (!isLt1M) {
          this.$message.error('上传图片大小不能超过 1MB!')
        }
        return isLt1M
      },
      showImage () {
        this.dialogImageUrl = this.imageUrl
        this.dialogVisible = true
      },
      delImage () {
        this.$emit('update:imageUrl', '')
      }
    }
  }
</script>

<style lang="scss" scoped>
  .single-img{
    &__box{
      position: relative;
       ::v-deep .el-upload{
        width: 100%;
      }
       ::v-deep .el-upload-dragger{
        width: 100%;
        .el-upload__text{
          line-height: 40px;
        }
        .el-upload__tip{
          line-height: 1em;
        }
      }
      .overlay{
        display: none;
      }
      &:hover .overlay{
        position: absolute;
        top:0;
        left: 0;
        width: 100%;
        height: 100%;
        background-color: rgba(0,0,0,0.3);
        color: #fff;
        display: flex;
        justify-content: center;
        align-items: center;
        .iconfont{
          padding: 5px;
          margin: 0 5px;
          font-size: 20px;
          cursor: pointer;
        }
      }
    }
    &__img{
      position: absolute;
      max-width: 100%;
      height: 100%;
      max-height: 100%;
      margin: auto;
      top: 0;
      right: 0;
      bottom: 0;
      left: 0;
    }
  }
</style>
