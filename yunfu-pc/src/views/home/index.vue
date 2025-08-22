<template>
  <div>
    <hom-header></hom-header>
    <CanvasPage :terminal="4" :typeId="1"></CanvasPage>
  </div>
</template>

<script>
  import CanvasPage from '@/components/canvasShow/canvasShowPage'
  import HomHeader from '@/components/base/homHeader'
  export default {
    name: 'index',
    components: { HomHeader, CanvasPage },
    data () {
      return {
        canvasData: []
      }
    },
    mounted () {
    }
  }
</script>
