<template>
  <div class="toolWarp">
    <div class="toolPanel">
      <component :is="componentMap.get(activeComponent.type)"></component>
    </div>
  </div>
</template>
<script>
import componentMap from './componentMap'
import { mapGetters } from 'vuex'
  export default {
    name: 'toolPanel',
    data () {
      return {
        componentMap: componentMap
      }
    },
    computed: {
      ...mapGetters([
        'activeComponent',
        'typeId'
      ])
    }
  }
</script>

<style lang="scss" scoped>
  .toolWarp{
    width: 320px;
  }
  .toolPanel {
    width: 320px;
  }
  .toolPanel::-webkit-scrollbar {
    width: 4px;
    height: 1px;
  }

  .toolPanel::-webkit-scrollbar-thumb {
    border-radius: 4px;
    -webkit-box-shadow: inset 0 0 5px rgba(156, 148, 148, 0.2);
    background: #cdcdcd;
  }
  .toolPanel::-webkit-scrollbar-track {
    -webkit-box-shadow: inset 0 0 5px rgba(158, 150, 150, 0.2);
    border-radius: 4px;
    background: #EDEDED;
  }
</style>
