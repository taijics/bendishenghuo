<template>
  <div>
    <!-- 卡片 -->
    <el-card class="box-card">
      <div slot="header">
        <!-- 选项卡 -->
        <div class="tabChange">
          <div class="cardBtn">
            <span v-for="(item,index) in btnList" :key="index" class="promissStyle">
              <el-button type="primary" @click="btnClick(item)">{{ item.permissionName }}</el-button>
            </span>
          </div>
          <el-tabs v-model="activeName" class="tabsRight" @tab-click="handleClick">
            <el-tab-pane label="图片" name="1" />
            <el-tab-pane label="视频" name="2" />
          </el-tabs>
          <!-- 图片内容 -->
          <div v-if="tipsList.length" class="imgOne">
            <div class="tagsList">
              <el-tag
                v-for="(item,index) in tipsList"
                :key="index"
                class="tagsBt"
                :effect="findIndex === index ? 'dark' :'plain'"
                @click="getTips(index,item)"
              >{{ item.labelName }}</el-tag>
            </div>
            <div v-if="tipsShow" class="tipsName">
              <div class="name">{{ tipsName }}</div>
              <div class="btns">
                <el-button type="text" @click="edit">编辑</el-button>
                <el-button type="text" @click="del">删除</el-button>
              </div>
            </div>
            <div v-if="tipsShow" class="tagBox">
              <div v-for="(item,index) in lableList" :key="index" class="tagDetail">
                <div class="topTags" />
                <div v-if="item.image.includes('mp4')" class="tagsImgs">
                  <video ref="videos" controls="controls" loop="loop">
                    <source :src="item.image" type="video/mp4">
                  </video>
                </div>
                <div v-else class="tagsImgs">
                  <img :src="item.image" alt>
                </div>
                <div class="tagBtns">
                  <el-button type="text" @click="link(item.image)">链接</el-button>
                  <el-button type="text" @click="changeTips(item.labelId)">标签</el-button>
                  <el-button type="text" @click="delTips(item)">删除</el-button>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </el-card>

    <!-- 新增标签弹框 -->
    <el-dialog
      :title="addtips.title"
      :visible.sync="addtips.show"
      width="30%"
      center
      :close-on-click-modal="false"
    >
      <div>
        <el-input v-model="tipsName" maxlength="10" placeholder="请输入标签名称" />
      </div>
      <span slot="footer" class="dialog-footer">
        <el-button @click="addtips.show = false">取 消</el-button>
        <el-button type="primary" @click="addTipsEnter">确 定</el-button>
      </span>
    </el-dialog>

    <!-- 上传素材弹框 -->
    <el-dialog
      :close-on-click-modal="false"
      title="上传素材"
      :visible.sync="isVisible"
      width="500px"
      class="dialog-wrap"
    >
      <el-form ref="form" :model="sizeForm" :rules="rules" label-width="100px">
        <el-form-item label="标签选择">
          <el-row class="tag-list">
            <el-tag
              v-for="(item, index) in tipsList"
              :key="index"
              :class="currentIndex === index ? 'active' : ''"
              class="margin-5"
              @click="clickIndex(index, item)"
            >{{ item.labelName }}</el-tag>
          </el-row>
        </el-form-item>
        <!--        <el-form-item label="网络图片">-->
        <!--          <el-input v-model="sizeForm.value" />-->
        <!--          <el-button type="primary" class="upload-btn" @click="extractUrl">提取</el-button>-->
        <!--        </el-form-item>-->
        <el-form-item label="本地上传" prop="fileLength">
          <fileUpload
            ref="fileRef"
            :accept-size="2*1024*1024"
            :auto-upload="false"
            :limit="5"
            :accept="typeList"
            :upload-ref="also"
            @fileLengthVaild="fileLengthVaild"
            @setId="setIdAndSubmit"
            @getImgList="getImgMpList"
          >
            <el-button slot="trigger" size="small" type="primary">选取文件</el-button>
            <div slot="tip" class="el-upload__tip">文件不超过2MB</div>
          </fileUpload>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="isVisible= false">取 消</el-button>
        <el-button type="primary" @click="onSubmit">确定</el-button>
      </div>
    </el-dialog>

    <!-- 更新素材 -->
    <el-dialog
      title="更新素材标签"
      :visible.sync="tipsDio"
      width="30%"
      center
      :close-on-click-modal="false"
    >
      <div>
        <el-row class="tag-lists">
          <el-tag
            v-for="(item, index) in tipsList"
            :key="index"
            :class="currentIndexs === index ? 'active' : ''"
            class="margin-5"
            @click="clickIndexs(index, item)"
          >{{ item.labelName }}</el-tag>
        </el-row>
      </div>
      <span slot="footer" class="dialog-footer">
        <el-button @click="tipsDio = false">取 消</el-button>
        <el-button type="primary" @click="tipsDioEn">确 定</el-button>
      </span>
    </el-dialog>
  </div>
</template>

<script>
// import {getBtnList} from '@/utils/auth'
import fileUpload from './fileUpload'
import {
  tipsGetAll,
  tipsAdd,
  getAllByLabel,
  tipsUpdate,
  tipsDelete,
  saveSource,
  updateSource,
  deleteSource
} from '@/api/shop'
export default {
  name: '',
  components: { fileUpload },
  data() {
    return {
      btnList: [
        {
          permissionName: '新增标签'
        },
        {
          permissionName: '上传'
        }
      ],
      also: 'fileRef',
      activeName: '1',
      addtips: {},
      tipsName: '',
      tipsList: '',
      findIndex: 0,
      tipsShow: false,
      isVisible: false,
      tipsDio: false,
      typeList: '.jpg,.jpeg,.png,.gif,.JPG,.JPEG,.PBG,.GIF,.mp4,.MP4',
      attachment: this.initAttachment(),
      currentIndex: '',
      sizeForm: {},
      dataObj: {
        folderId: 1
      },
      params: {
        tagId: '',
        id: 0
      },
      currentIndexs: '',
      lableList: [],
      tipsImgLsit: [],
      imageUrl: '',
      fileLength: 0,
      disabled: false,
      rules: {
        fileLength: {
          required: true,
          trigger: 'change',
          validator: (rule, value, callback) => {
            const vm = this
            if (vm.fileLength === 0) {
              callback(new Error('请上传文件'))
            } else if (vm.fileLength > 5) {
              callback(new Error('一次性只能上传5个文件'))
            } else {
              callback()
            }
          }
        }
      }
    }
  },
  mounted() {
    this.getAllTips()
  },
  methods: {
    btnClick(id) {
      if (id.permissionName === '新增标签') {
        this.add()
      } else if (id.permissionName === '上传') {
        this.uploadMEtal()
      }
    },
    //   点击选项卡
    async handleClick(tab, event) {
      console.log(tab, 'tab')
      console.log(event, 'event')
      this.activeName = tab.name
      const res = await tipsGetAll({
        labelType: tab.name
      })
      this.tipsList = res.data
      console.log(res)
    },
    // 查询标签
    async getAllTips() {
      const res = await tipsGetAll({
        labelType: this.activeName
      })
      this.tipsList = res.data
      console.log(res)
    },
    // 点击标签
    async getTips(index, arr) {
      console.log(index)
      this.findIndex = index
      this.tipsName = arr.labelName
      this.tipsShow = true
      const res = await getAllByLabel({
        labelId: arr.labelId,
        labelType: this.activeName
      })
      if (res.code === '') {
        this.lableList = res.data
      }
      console.log(res)
    },
    // 新增
    add() {
      this.tipsName = ''
      this.addtips = {
        title: '新增标签',
        show: true,
        index: 1
      }
    },
    // 编辑
    edit(row) {
      this.tipsName = this.tipsList[this.findIndex].labelName
      this.addtips = {
        title: '编辑标签',
        show: true,
        index: 2
      }
    },
    // 删除
    async del() {
      if (this.tipsList[this.findIndex].labelId === 1) {
        this.$message.error('默认分组不能删除')
        return
      }
      const res = await tipsDelete({
        labelId: this.tipsList[this.findIndex].labelId
      })
      if (res.code === '') {
        this.$message.success('删除成功')
        this.getAllTips()
        this.tipsShow = false
      }
    },
    // 链接
    link(url) {
      const input = document.createElement('input')
      const vm = this
      document.body.appendChild(input)
      input.setAttribute('value', url)
      input.select()
      if (document.execCommand('copy')) {
        document.execCommand('copy')
      }
      document.body.removeChild(input)
      vm.$message({
        message: '复制链接成功',
        type: 'success'
      })
    },
    // 标签
    changeTips(labelId) {
      this.tipsDio = true
    },
    async tipsDioEn() {
      console.log(this.lableList, this.currentIndexs)
      const res = await updateSource({
        labelId: this.tipsList[this.currentIndexs].labelId,
        image: this.lableList[0].image
      })
      if (res.code === '') {
        this.$message.success('修改成功')
        this.getAllTips()
        this.tipsDio = false
        this.getTips(this.findIndex, {
          labelName: this.tipsName,
          labelId: this.tipsList[this.currentIndexs].labelId
        })
      }
    },
    // 删除素材
    async delTips(arr) {
      console.log(arr)
      const res = await deleteSource({
        labelId: arr.labelId,
        image: arr.image,
        link: arr.link
      })
      if (res.code === '') {
        this.$message.success('删除成功')
        this.getAllTips()
        this.getTips(this.findIndex, {
          labelName: this.tipsName,
          labelId: arr.labelId
        })
      }
    },
    // 新增标签
    async addTipsEnter() {
      if (this.addtips.index === 1) {
        const res = await tipsAdd({
          labelName: this.tipsName,
          labelType: this.activeName,
        })
        if (res.code === '') {
          this.$message({
            message: '新增成功',
            type: 'success'
          })
          this.tipsName = ''
          this.addtips.show = false
          this.getAllTips()
        }
      } else if (this.addtips.index === 2) {
        const res = await tipsUpdate({
          labelId: this.tipsList[this.findIndex].labelId,
          labelName: this.tipsName
        })
        if (res.code === '') {
          this.$message.success('编辑成功')
          this.getAllTips()
          this.addtips.show = false
        }
      }
    },
    // 上传素材
    uploadMEtal() {
      this.isVisible = true
      // this.$refs.fileRef.clearFiles();
      this.$refs.fileRef.init({
        id: ''
      })
    },
    // 点击标签
    clickIndex(index, id) {
      this.currentIndex = index
      this.params.tagId = id
    },
    initAttachment() {
      return {
        id: '',
        bizId: '',
        bizType: '',
        file: null,
        isSingle: false
      }
    },
    clickIndexs(index, id) {
      this.currentIndexs = index
    },
    extractUrl() {},
    handleImageSuccess(response) {
      const { url, id } = response.data
      this.imageUrl = url
      this.params.id = id
    },
    handleRemove(file, fileList) {
      console.log(file, fileList)
    },
    reset() {
      this.params = {}
      this.$refs.form.clearValidate()
      this.$refs.form.resetFields()
      this.attachment = this.initAttachment()
      if (!this.id) {
        this.$refs.fileRef.init({
          id: '',
          bizId: '',
          bizType: ''
        })
      }
    },
    async onSubmit() {
      this.addGroup()
    },
    async addGroup() {
      console.log(this.params)
      const vm = this
      vm.disabled = true
      if (vm.params.tagId.labelId) {
        this.$refs.form.validate(valid => {
          if (valid) {
            console.log('test')
            vm.$refs.fileRef.submitFile(0, '', '', this.params.tagId.labelId)
          } else {
            return false
          }
        })
      } else {
        vm.$message({
          message: '请选择标签',
          type: 'error'
        })
      }
    },
    delectGroupImg() {
      this.params.groupImg = ''
    },
    setParams(val = {}) {
      const vm = this
      if (val['params']) {
        vm.params = val['params']
      }
    },
    // 图片内容
    getImgMpList(data) {
      console.log(data)
      this.tipsImgLsit = data
    },
    // 附件长度校验
    fileLengthVaild(data) {
      const vm = this
      vm.fileLength = data || 0
    },
    setIdAndSubmit(isUploadCompleted) {
      console.log(isUploadCompleted)
      const vm = this
      if (isUploadCompleted) {
        vm.$emit('success')
        saveSource({
          labelId: vm.params.tagId.labelId,
          images: vm.tipsImgLsit
        }).then(res => {
          if (res.code === '') {
            vm.$message.success('新增成功')
            vm.disabled = false
            vm.isVisible = false
          }
        })
      }
    }
  }
}
</script>

<style lang="scss">
@import url("../../../styles/elDialog.scss");
</style>
<style scoped lang='scss'>
.tabChange {
  padding: 10px;
}
.uploadBtn {
  float: right;
  width: 100px;
  height: 48px;
  margin-right: 20px;
}
.cardBtn {
  position: absolute;
  right: 35px;
  z-index: 999;
}
.tabsRight {
  margin: 10px 0 15px;
}
.tagsBt {
  margin-right: 20px;
  cursor: pointer;
}
.tagBox {
  display: flex;
  flex-wrap: wrap;
  .tagDetail {
    margin-top: 20px;
    margin-right: 20px;
    .topTags {
      font-size: 16px;
      color: #333333;
    }
    .tagsImgs {
      width: 180px;
      height: 180px;
      background: #e0e5eb;
      border-radius: 8px;
      img,
      video {
        width: 180px;
        height: 180px;
      }
    }
    .tagBtns {
      display: flex;
    }
  }
}

.tipsName {
  padding: 20px;
  display: flex;
  align-items: center;
  .name {
    margin-right: 20px;
  }
}
.dialog-wrap {
  .margin-5 {
    margin-right: 5px;
    cursor: pointer;
    &.active {
      background-color: #3a68f2;
      color: #fff;
    }
  }
  .btn-wrap {
    text-align: center;
  }
  ::v-deep .el-input {
    margin-right: 10px;
    width: 270px;
    vertical-align: top;
  }
  .upload-wrap {
    margin-bottom: 25px;
    ::v-deep .el-upload,
    ::v-deep .el-upload-list__item {
      width: 80px;
      height: 80px;
      line-height: 80px;
    }
    ::v-deep .el-progress,
    ::v-deep .el-progress-circle {
      width: 60px !important;
      height: 60px !important;
    }
  }
  .upload-wrap {
    width: 100%;
    display: flex;
    align-items: flex-end;
    ::v-deep .el-upload {
      border: 1px dashed #d9d9d9;
      border-radius: 6px;
      cursor: pointer;
      position: relative;
      overflow: hidden;
      img {
        width: 100%;
        height: 100%;
      }
    }
    .image-wrap {
      width: 120px;
      height: 120px;
      line-height: 120px;
      margin-right: 15px;
      margin-bottom: 15px;
      text-align: center;
      border: 1px dashed #d9d9d9;
      img {
        width: 100%;
        height: 100%;
      }
    }
  }
}
.tag-lists {
  display: flex;
  flex-wrap: wrap;
  .margin-5 {
    margin-right: 20px;
    margin-bottom: 16px;
  }
  .active {
    background-color: #3a68f2;
    color: #fff;
  }
}
</style>
