import getters from '@/store/getters'
import app from '@/store/modules/app'
import settings from '@/store/modules/settings'
import { store as user } from '@/store/modules/user/index'
import permission from '@/store/modules/permission.js'
import { createStore } from 'vuex';

const store = createStore({
  modules: {
    app,
    settings,
    user,
    permission,
  },
  getters,
})

export default store
