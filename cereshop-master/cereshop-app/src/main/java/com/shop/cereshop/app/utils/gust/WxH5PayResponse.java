package com.shop.cereshop.app.utils.gust;
import java.util.Map;

/**
 * 微信H5支付-返回模型
 * 字段说明：
 * - status: 100成功, 101失败（及其他失败码）
 * - message: 描述信息
 * - sign: 返回签名
 * - pay_url: 中间跳转页URL（5分钟有效，status=100时返回）
 * - lowOrderId: 下游订单号（status=100时返回）
 * - upOrderId: 通莞订单号（status=100时返回）
 * 附加：
 * - signatureValid: 是否通过验签
 * - rawBody: 原始响应字符串
 * - allFields: 原始解析后的键值对（用于排查）
 */
public class WxH5PayResponse {
    private int status;
    private String message;
    private String sign;
    private String pay_url;
    private String lowOrderId;
    private String upOrderId;

    private boolean signatureValid;
    private String rawBody;
    private Map<String, Object> allFields;

    public int getStatus() { return status; }
    public String getMessage() { return message; }
    public String getSign() { return sign; }
    public String getPay_url() { return pay_url; }
    public String getLowOrderId() { return lowOrderId; }
    public String getUpOrderId() { return upOrderId; }
    public boolean isSignatureValid() { return signatureValid; }
    public String getRawBody() { return rawBody; }
    public Map<String, Object> getAllFields() { return allFields; }

    public void setStatus(int status) { this.status = status; }
    public void setMessage(String message) { this.message = message; }
    public void setSign(String sign) { this.sign = sign; }
    public void setPay_url(String pay_url) { this.pay_url = pay_url; }
    public void setLowOrderId(String lowOrderId) { this.lowOrderId = lowOrderId; }
    public void setUpOrderId(String upOrderId) { this.upOrderId = upOrderId; }
    public void setSignatureValid(boolean signatureValid) { this.signatureValid = signatureValid; }
    public void setRawBody(String rawBody) { this.rawBody = rawBody; }
    public void setAllFields(Map<String, Object> allFields) { this.allFields = allFields; }

    @Override
    public String toString() {
        return "WxH5PayResponse{" +
                "status=" + status +
                ", message='" + message + '\'' +
                ", sign='" + sign + '\'' +
                ", pay_url='" + pay_url + '\'' +
                ", lowOrderId='" + lowOrderId + '\'' +
                ", upOrderId='" + upOrderId + '\'' +
                ", signatureValid=" + signatureValid +
                '}';
    }
}