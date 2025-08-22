<template>
  <div id="app">
    <el-dialog title="温馨提示" top="30vh" :visible.sync="tipShow" width="30%" center>
      <span
        >为保护个人隐私信息，系统自动对敏感数据进行脱敏。如需编辑、查看完整信息，可通过“用户隐私二次认证”功能进行验证，验证通过之后，24小时内可查看完整信息。</span
      >
      <span slot="footer" class="dialog-footer">
        <el-button @click="tipShow = false">关闭</el-button>
      </span>
    </el-dialog>
    <router-view />
  </div>
</template>

<script>
import { getPrivacySwitch } from "@/api/privacy";
export default {
  name: "App",
  data() {
    return {
      tipShow: false,
    };
  },
  created() {
    if (this.$store.state.user.token) {
      this.getPrivacySwitch();
    }
  },
  methods: {
    getPrivacySwitch() {
      getPrivacySwitch().then((res) => {
        var IsTipshow = localStorage.getItem("IsTipshow");
        localStorage.setItem('privacyTime', res.data)
        if (this.$store.state.user.token && !IsTipshow && res.data === 0) {
          this.tipShow = true;
          localStorage.setItem("IsTipshow", true);
        }
      });
    },
  },
};
</script>
<style lang="scss">
.el-dialog__header {
  background-color: #3A68F2;
  text-align: left;
}

.el-dialog__title {
  color: #FFFFFF;
}

</style>
