import api from '../../config/api'
import {
  funMixin
} from '../../config/mixin'
import {
  ref,
  onMounted
} from 'vue';

export default function (componentContent, typeId, shopId) {
  const {
    sendReq,
    jumpProductDetail,
    jumpGroupWorks
  } = funMixin()
  const productData = ref({})

  onMounted(() => {
    getData()
  })

  function getData() {
    if(typeId.value === 1){
      const params = {
        method: 'GET',
        url: `${api.getAdminGroupWorks}`,
      }
      sendReq(params, (res) => {
        productData.value.products = res.data
        if (productData.value.products.length > 2) {
          productData.value.show = true
        } else {
          productData.value.show = false
        }
      })
    } else if(typeId.value === 3) {
      if(componentContent.value.shopGroupWorkId){
        const params = {
          method: 'GET',
          url: `${api.getGroupWorks}?shopId=${shopId.value}&ids=${componentContent.value.shopGroupWorkId}`,
        }
        sendReq(params, (res) => {
          productData.value = res.data[0]
        })
      } else {
        productData.value = {
          products:[]
        }
      }
    }
  }

  return {
    productData,
    jumpProductDetail,
    jumpGroupWorks
  }
}
