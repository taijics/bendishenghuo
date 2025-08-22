import { encrypt, decrypt } from 'crypto-js/aes';
import ECB from 'crypto-js/mode-ecb'
import pkcs7 from 'crypto-js/pad-pkcs7'
import UTF8 from 'crypto-js/enc-utf8';
import Base64 from 'crypto-js/enc-base64'
import Hex from 'crypto-js/enc-hex'

const key = UTF8.parse('1234188912341889') // 十六位十六进制数作为密钥
const iv = UTF8.parse('ABCDEF12ABCDEF12') // 十六位十六进制数作为密钥偏移量

// 加密方法
export function Encrypt (word) {
  let srcs = UTF8.parse(word)
  let encrypted = encrypt(
    srcs,
    key,
    {
      iv: iv,
      mode: ECB, // cbc
      padding: pkcs7
    }
  )
  return encrypted.ciphertext.toString().toUpperCase()
}
// 解密方法
export function Decrypt (word) {
  let encryptedHexStr = Hex.parse(word)
  let srcs = Base64.stringify(encryptedHexStr)
  let aesDecrypt = decrypt(
    srcs,
    key,
    {
      iv: iv,
      mode: ECB, // cbc
      padding: pkcs7
    }
  )
  let decryptedStr = aesDecrypt.toString(UTF8)
  return decryptedStr.toString()
}
