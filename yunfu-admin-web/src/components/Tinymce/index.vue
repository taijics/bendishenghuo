<template>
  <div class="tinymce_box">
    <editor id="tinymce" v-model="tinymceHtml" :init="init" />
  </div>
</template>
<script setup>
import { onMounted } from 'vue'
import tinymce from 'tinymce/tinymce'
import { useVModel } from '@vueuse/core'
import { uploadFileApi } from '@/api/file'
import 'tinymce/models/dom'; // 特别注意 tinymce 6.0.0 版本之后必须引入，否则不显示
import 'tinymce/themes/silver/theme'
import Editor from '@tinymce/tinymce-vue' // 引入组件
// 都是富文本插件
import 'tinymce/icons/default'
import 'tinymce/plugins/image'
import 'tinymce/plugins/link'
import 'tinymce/plugins/code'
import 'tinymce/plugins/table'
import 'tinymce/plugins/lists'
import 'tinymce/plugins/wordcount'
// 以上所有的样式在 node_modules 下面 tinymce 里面的 plugins 都能找到。
const props = defineProps({
  modelValue: {
    type: [String],
    default: '',
  },
  height: {
    type: Number,
    default: 500
  }
});
const emit = defineEmits(['update:modelValue']);
const publicPath = import.meta.env.VITE_BASE_PREFIX || '/';
const tinymceHtml = useVModel(props, 'modelValue', emit);
const init = {
  // 初始化数据
  selector: '#tinymce',
  language_url: publicPath + 'resource/tinymce/langs/zh_CN.js', // 引入语言包（该语言包在public下，注意文件名称）
  language: 'zh_CN', // 这里名称根据 zh-Hans.js 里面写的名称而定
  skin_url: publicPath + 'resource/tinymce/skins/ui/oxide', // 这里引入的样式
  height: props.height, // 限制高度
  plugins: 'link lists image code table wordcount', // 富文本插件
  toolbar:
    'undo redo | bold italic underline strikethrough | fontsizeselect | forecolor backcolor | alignleft aligncenter alignright alignjustify | bullist numlist | outdent indent blockquote | link unlink image code | removeformat | fontselect',
  branding: false, // //是否禁用“Powered by TinyMCE”
  menubar: true, // 顶部菜单栏显示
  placeholder: '请输入内容',
  fontsize_formats: '12px 14px 16px 18px 20px 22px 24px 28px 32px 36px 48px 56px 72px', // 字体大小
  font_formats: '微软雅黑=Microsoft YaHei,Helvetica Neue,PingFang SC,sans-serif;苹果苹方=PingFang SC,Microsoft YaHei,sans-serif;宋体=simsun,serif;仿宋体=FangSong,serif;黑体=SimHei,sans-serif;Arial=arial,helvetica,sans-serif;Arial Black=arial black,avant garde;Book Antiqua=book antiqua,palatino;',
  // paste_convert_word_fake_lists: false, // 插入word文档需要该属性
  content_css: publicPath + 'resource/tinymce/skins/content/default/content.css', // 以css文件方式自定义可编辑区域的css样式，css文件需自己创建并引入
  images_upload_handler: (blobInfo, success, failure) => {
    // console.log(blobInfo.blob());
    // 上传图片需要，FormData 格式的文件；
    const formDataUp = new FormData();
    // img  是接口需要的上传的属性名，一般属性名是 file
    formDataUp.append('file', blobInfo.blob());
    // // console.log(formDataUp);
    uploadFileApi(formDataUp).then(res => {
      success(res.data.url)
    })
  }
};
onMounted(() => {
  tinymce.init({}); // 初始化富文本
});
</script>
<style>
.tinymce_box {
  width: 100%;
  .tox-promotion {
    display: none;
  }
}
</style>
