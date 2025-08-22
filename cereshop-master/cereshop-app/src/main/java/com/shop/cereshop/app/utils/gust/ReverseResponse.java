package com.shop.cereshop.app.utils.gust;
import java.util.Map;

/**
 * 全额退款（撤销）- 返回模型
 *
 * 返回数据字段：
 * - status     100成功，101失败
 * - message    信息描述
 * - account    聚合账户
 * - upOrderId  通莞订单号
 * - lowOrderId 下游订单号
 * - state      0成功，1失败，2已撤销，5已退款申请成功，6已转入部分退款申请成功
 * - sign       签名
 *
 * 附加：
 * - signatureValid 验签是否通过
 * - rawBody        原始响应字符串
 * - allFields      全量字段Map
 */
public class ReverseResponse {

    private Integer status;
    private String message;
    private String account;
    private String upOrderId;
    private String lowOrderId;
    private String state;
    private String sign;

    private boolean signatureValid;
    private String rawBody;
    private Map<String, Object> allFields;

    public Integer getStatus() { return status; }
    public void setStatus(Integer status) { this.status = status; }
    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }
    public String getAccount() { return account; }
    public void setAccount(String account) { this.account = account; }
    public String getUpOrderId() { return upOrderId; }
    public void setUpOrderId(String upOrderId) { this.upOrderId = upOrderId; }
    public String getLowOrderId() { return lowOrderId; }
    public void setLowOrderId(String lowOrderId) { this.lowOrderId = lowOrderId; }
    public String getState() { return state; }
    public void setState(String state) { this.state = state; }
    public String getSign() { return sign; }
    public void setSign(String sign) { this.sign = sign; }

    public boolean isSignatureValid() { return signatureValid; }
    public void setSignatureValid(boolean signatureValid) { this.signatureValid = signatureValid; }
    public String getRawBody() { return rawBody; }
    public void setRawBody(String rawBody) { this.rawBody = rawBody; }
    public Map<String, Object> getAllFields() { return allFields; }
    public void setAllFields(Map<String, Object> allFields) { this.allFields = allFields; }

    @Override
    public String toString() {
        return "ReverseResponse{" +
                "status=" + status +
                ", state='" + state + '\'' +
                ", message='" + message + '\'' +
                ", upOrderId='" + upOrderId + '\'' +
                ", lowOrderId='" + lowOrderId + '\'' +
                ", signatureValid=" + signatureValid +
                '}';
    }
}