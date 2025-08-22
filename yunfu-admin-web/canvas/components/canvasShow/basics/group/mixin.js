import api from '../../config/api'
import {
  funMixin
} from '../../config/mixin'
import {
  ref,
  watch,
  onMounted
} from 'vue';
import {
  canvasStore
} from '@@/store/canvas'
import {
  storeToRefs
} from 'pinia';
const canvasStoreObj = canvasStore();

export default function (componentContent, typeId, shopId) {
  const {
    sendReq,
    beforeGetData,
    afterGetData,
    jumpProductDetail,
    jumpGroupWorks
  } = funMixin()
  const productData = ref([])
  const {
    groupNum
  } = storeToRefs(canvasStoreObj);

  onMounted(() => {
    getData()
  })

  function getData () {
    if (typeId.value === 1) {
      beforeGetData()
      const params = {
        method: 'GET',
        url: `${api.getAdminGroupWorks}`,
      }
      sendReq(
        params,
        (res) => {
          afterGetData()
          productData.value.products = res.data
          // _.$forceUpdate()
        },
        () => {
          afterGetData()
          // _.afterGetData()
        }
      )
    } else if (typeId.value === 3) {
      if (componentContent.value.shopGroupWorkId) {
        beforeGetData()
        const params = {
          method: 'GET',
          url: `${api.getGroupWorks}?shopId=${shopId.value}&ids=${componentContent.value.shopGroupWorkId}`,
        }
        sendReq(
          params,
          (res) => {
            afterGetData()
            productData.value = res.data[0]
          },
          () => {
            afterGetData()
          }
        )
      } else {
        productData.value = {
          products: [],
        }
      }
    }
  }

  watch(() =>
    groupNum,
  (newVal) => {
    getData()
  }, {
    immediate: false,
    deep: true
  })

  return {
    productData,
    jumpProductDetail,
    jumpGroupWorks
  }
}
