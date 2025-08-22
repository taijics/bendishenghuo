import JSEncrypt from 'jsencrypt'

// 密钥对生成 http://web.chacuo.net/netrsakeypair

const publicKey ='MFwwDQYJKoZIhvcNAQEBBQADSwAwSAJBALKesIyWEz0IY1SPPFGMWBjfCWayuSL2UuVD1j+1YvdbizPh78v0K50Mw3HDinazJRomiQEN3LK5HJ9rIxjDcv8CAwEAAQ=='

const privateKey =''

// 加密
export function encrypt(txt) {
  const encryptor = new JSEncrypt()
  encryptor.setPublicKey(publicKey) // 设置公钥
  return encryptor.encrypt(txt) // 对需要加密的数据进行加密
}

// 解密
export function decrypt(txt) {
  const encryptor = new JSEncrypt()
  encryptor.setPrivateKey(privateKey)
  return encryptor.decrypt(txt)
}
