import { computed } from 'vue'
export function usePropsContent() {
  // 兼容低代码平台内容结构
  const props = defineProps({ data: Object })
  const componentData = computed(() => props.data || {})
  return { componentData }
}