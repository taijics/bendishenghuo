import request from '@/utils/request'

//* ******************** 素材管理  *********************
// 标签管理查询
export function tipsGetAll(data) {
  return request({
    url: '/shop_label/getAll',
    method: 'post',
    data
  })
}

// 素材查询
export function getAllByLabel(data) {
  return request({
    url: '/shop_label/getAllByLabel',
    method: 'post',
    data
  })
}

// 添加标签
export function tipsAdd(data) {
  return request({
    url: '/shop_label/save',
    method: 'post',
    data
  })
}

// 标签编辑查询
export function tipsGetById(data) {
  return request({
    url: '/shop_label/getById',
    method: 'post',
    data
  })
}

// 修改标签
export function tipsUpdate(data) {
  return request({
    url: '/shop_label/update',
    method: 'post',
    data
  })
}

// 删除标签
export function tipsDelete(data) {
  return request({
    url: '/shop_label/delete',
    method: 'post',
    data
  })
}

// 上传素材
export function saveSource(data) {
  return request({
    url: '/shop_label/saveSource',
    method: 'post',
    data
  })
}

// 素材图片删除
export function deleteSource(data) {
  return request({
    url: '/shop_label/deleteSource',
    method: 'post',
    data
  })
}

// 更新素材绑定标签
export function updateSource(data) {
  return request({
    url: '/shop_label/updateSource',
    method: 'post',
    data
  })
}

export const copy = msg => {
  if (msg) {
    const oInput = document.createElement('input') // 创建一个隐藏input（重要！）
    oInput.value = msg // 赋值
    document.body.appendChild(oInput)
    oInput.select() // 选择对象
    document.execCommand('Copy') // 执行浏览器复制命令
    oInput.className = 'oInput'
    oInput.style.display = 'none'
  }
}
