import api from '../../config/api'
import {
  funMixin
} from '../../config/mixin'
import {
  ref,
  onMounted
} from 'vue';

export default function () {
  const {
    sendReq
  } = funMixin()
  const classifyData = ref([])

  onMounted(() => {
    getData()
  })

  function getData() {
    sendReq({
      url: `${api.getClassify}?page=1&pageSize=20`,
      method: 'GET'
    }, (res) => {
      classifyData.value = res.data
    },(err)=>{
    })
  }

  return {
    classifyData
  }
}
