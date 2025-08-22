package com.shop.cereshop.app.utils.gust;
import java.util.HashMap;
import java.util.Map;

/**
 * 全额退款（撤销）- 请求模型
 * 接口路径：POST /tgPosp/services/payApi/reverse
 *
 * 必填字段：
 * - account      聚合账号
 * - lowOrderId   下游订单号
 * - upOrderId    通莞订单号
 *
 * 可选字段：
 * - refundAccountType FUND_ACCOUNT：资金账户余额；不传默认为未结算资金退款
 */
public class ReverseRequest {

    private String account;
    private String lowOrderId;
    private String upOrderId;
    private String refundAccountType; // 可选：FUND_ACCOUNT

    public Map<String, Object> toParamMapWithoutSign() {
        Map<String, Object> m = new HashMap<>();
        putIfNotEmpty(m, "account", account);
        putIfNotEmpty(m, "lowOrderId", lowOrderId);
        putIfNotEmpty(m, "upOrderId", upOrderId);
        putIfNotEmpty(m, "refundAccountType", refundAccountType);
        return m;
    }

    private static void putIfNotEmpty(Map<String, Object> map, String key, String val) {
        if (val != null && !val.isEmpty()) map.put(key, val);
    }

    // Getters & Setters
    public String getAccount() { return account; }
    public void setAccount(String account) { this.account = account; }
    public String getLowOrderId() { return lowOrderId; }
    public void setLowOrderId(String lowOrderId) { this.lowOrderId = lowOrderId; }
    public String getUpOrderId() { return upOrderId; }
    public void setUpOrderId(String upOrderId) { this.upOrderId = upOrderId; }
    public String getRefundAccountType() { return refundAccountType; }
    public void setRefundAccountType(String refundAccountType) { this.refundAccountType = refundAccountType; }

    public static Builder builder() { return new Builder(); }

    public static class Builder {
        private final ReverseRequest r = new ReverseRequest();
        public Builder account(String v) { r.setAccount(v); return this; }
        public Builder lowOrderId(String v) { r.setLowOrderId(v); return this; }
        public Builder upOrderId(String v) { r.setUpOrderId(v); return this; }
        public Builder refundAccountType(String v) { r.setRefundAccountType(v); return this; }
        public ReverseRequest build() { return r; }
    }
}