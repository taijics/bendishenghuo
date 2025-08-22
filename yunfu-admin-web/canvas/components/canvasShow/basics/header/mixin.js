import api from '../../config/api'
import { funMixin } from '../../config/mixin'
import { ref, onMounted } from 'vue';

export default function () {
  const { sendReq, beforeGetData, afterGetData, jumpCategory } = funMixin()
  const classifyData = ref([])

  onMounted(() => {
    getData()
  })

  function getData () {
    beforeGetData()
    sendReq(
      {
        url: `${api.getClassify}?page=1&pageSize=20`,
        method: 'GET',
      },
      (res) => {
        afterGetData()
        classifyData.value = res.data
        console.log(classifyData.value)
      },
      () => {
        afterGetData()
      }
    )
  }

  return {
    classifyData,
    jumpCategory
  }
}

