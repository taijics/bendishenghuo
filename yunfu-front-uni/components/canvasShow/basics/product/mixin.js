import api from '../../config/api'
import { funMixin } from '../../config/mixin'
import { ref, onMounted } from 'vue';
import { useLoading } from "../../../../hooks/useLoading";

export default function (componentContent) {
  const { sendReq, jumpProductDetail, jumpProList } = funMixin()
  const productData = ref([])

  onMounted(() => {
    getData(true)
  })

  const loading = ref(false)
  const pageObj = ref({
    page:1,
    pageSize:12
  })
  const total = ref(0)
  const {showLoading,hideLoading} = useLoading()

  function getData(isFirst) {
    if(isFirst){
      productData.value = [{},{},{},{},{},{},{},{}]
    }
    if (componentContent.value.productData.sourceType === '1') {
      loading.value = true
      showLoading()
      if(componentContent.value.productData.productIdList && componentContent.value.productData.productIdList.length>0){
        sendReq({
          url: `${api.getProductsV2}?page=${pageObj.value.page}&pageSize=${pageObj.value.pageSize}&ids=${componentContent.value.productData.productIdList}`,
          method: 'GET'
        }, (proRes) => {
          productData.value = [...productData.value,...proRes.data.list ].filter(item=>!!item.productId)
          total.value = proRes.data.total
          if(isFirst){
            componentContent.value.productData.imgTextData = productData.value
          }
          loading.value = false
          hideLoading()
        })
      } else {
        hideLoading()
        productData.value = []
        loading.value = false
      }
    } else if(componentContent.value.productData.sourceType === '2'){
      if(componentContent.value.productData.categoryId) {
        sendReq({
          url: `${api.getProductsV2}?page=1&pageSize=99&classifyId=${componentContent.value.productData.categoryId}`,
          method: 'GET'
        }, (proRes) => {
          productData.value = proRes.data.list
          productData.value = productData.value.filter(item=>JSON.stringify(item) !== '{}')
          if(isFirst){
            componentContent.value.productData.imgTextData = productData.value
          }
          // _.swiper.update()
        })
      } else {
        productData.value = {
          products:[]
        }
      }
    }
  }

  function loadNext(){
    if(loading.value)return
    if(productData.value.length>=total.value && total.value!==0)return;
    pageObj.value.page++
    getData(false)
  }

  return {
    productData,
    total,
    jumpProductDetail,
    jumpProList,
    loadNext
  }
}
