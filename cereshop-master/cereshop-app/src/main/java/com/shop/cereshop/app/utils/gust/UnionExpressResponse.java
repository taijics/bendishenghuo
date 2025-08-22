package com.shop.cereshop.app.utils.gust;
import java.util.Map;

/**
 * 银联快捷支付-返回模型
 *
 * 字段（部分为可选）：
 * - codeUrl        可能返回的二维码或跳转链接
 * - upOrderId      通莞金服订单号
 * - sign           签名
 * - state          交易状态：0成功，1失败，2已撤销，4待支付
 * - upperOrderId   上游订单号
 * - message        信息描述
 * - account        聚合支付账号
 * - status         应答码状态：100成功，101失败
 *
 * 附加字段：
 * - signatureValid 是否通过验签
 * - rawBody        原始响应文本
 * - allFields      全量字段Map
 */
public class UnionExpressResponse {

    private String codeUrl;
    private String upOrderId;
    private String sign;
    private String state;
    private String upperOrderId;
    private String message;
    private String account;
    private Integer status;

    private boolean signatureValid;
    private String rawBody;
    private Map<String, Object> allFields;

    public String getCodeUrl() { return codeUrl; }
    public void setCodeUrl(String codeUrl) { this.codeUrl = codeUrl; }
    public String getUpOrderId() { return upOrderId; }
    public void setUpOrderId(String upOrderId) { this.upOrderId = upOrderId; }
    public String getSign() { return sign; }
    public void setSign(String sign) { this.sign = sign; }
    public String getState() { return state; }
    public void setState(String state) { this.state = state; }
    public String getUpperOrderId() { return upperOrderId; }
    public void setUpperOrderId(String upperOrderId) { this.upperOrderId = upperOrderId; }
    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }
    public String getAccount() { return account; }
    public void setAccount(String account) { this.account = account; }
    public Integer getStatus() { return status; }
    public void setStatus(Integer status) { this.status = status; }

    public boolean isSignatureValid() { return signatureValid; }
    public void setSignatureValid(boolean signatureValid) { this.signatureValid = signatureValid; }
    public String getRawBody() { return rawBody; }
    public void setRawBody(String rawBody) { this.rawBody = rawBody; }
    public Map<String, Object> getAllFields() { return allFields; }
    public void setAllFields(Map<String, Object> allFields) { this.allFields = allFields; }

    @Override
    public String toString() {
        return "UnionExpressResponse{" +
                "status=" + status +
                ", state='" + state + '\'' +
                ", message='" + message + '\'' +
                ", upOrderId='" + upOrderId + '\'' +
                ", upperOrderId='" + upperOrderId + '\'' +
                ", codeUrl='" + codeUrl + '\'' +
                ", signatureValid=" + signatureValid +
                '}';
    }
}