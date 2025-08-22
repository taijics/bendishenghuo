// 导入api接口模块
import home from './home'

// 获取当前环境变量 true => 生产环境 false => 开发环境
const BASEURL = (process.env.NODE_ENV === 'production') ? '/api' : '/api'

export const api = {
  // 登录模块
  ...home(BASEURL),
  // 图片上传
  upload: `${BASEURL}/file/upload`,
  // 商家入驻
  enterpriseCheck: `${BASEURL}/check/enterpriseCheck`,
  individualCheck: `${BASEURL}/check/individualCheck`,
  organizationsCheck: `${BASEURL}/check/organizationsCheck`,
  personalCheck: `${BASEURL}/check/personalCheck`,
  getByName: `${BASEURL}/app/getSelect`
}
export default api
