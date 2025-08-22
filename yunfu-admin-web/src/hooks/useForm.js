import { ref, shallowRef } from 'vue';

export function useForm (
  rules
) {
  let visible = shallowRef(false);
  let loading = shallowRef(false);
  let form = ref({})
  // let rules = {}

  function getDetail () {
    loading.value = true
    loading.value = false
  }

  function open ({
    id,
    status,
  }) {}

  function cancel () {
    visible.value = false
  }

  function onSubmit () {}

  return {
    visible,
    form,
    open,
    cancel,
  }
}