/*
 * 列表搜索的 mixin
 */
import { mapGetters, mapMutations } from 'vuex'

/* eslint-disable */
export const tool = {
  computed: {
    ...mapGetters([
      'activeComponent',
      'componentsData'
    ])
  },
  methods: {
    ...mapMutations({
      setComponentsData: 'SET_COMPONENTSDATA'
    })
  },
  beforeDestroy(){

  },
  watch: {
    'activeComponent.componentContent': {
      handler (newVal, oldVal) {
        console.log(newVal)
        // localStorage.setItem('componentsData', JSON.stringify(this.componentsData))
      },
      deep: true
    }
  }
}
