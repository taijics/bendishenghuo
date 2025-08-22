package com.shop.cereshop.app.utils.gust;

import java.util.HashMap;
import java.util.Map;

/**
 * 银联快捷支付-请求模型（/tgPosp/services/payApi/unionExpress）
 *
 * 必填字段：
 * - account         聚合支付账号
 * - payMoney        支付金额，单位：元（字符串格式）
 * - lowOrderId      下游订单号
 * - userNo          用户标识内容（同一用户后续快捷支付需传相同标识）
 * - userType        用户标识类型（IMEI/Mac/USER_ID/EMAIL/PHONE/ID_CARD）
 * - notifyUrl       支付异步回调通知地址
 * - returnUrl       支付完成前端返回地址
 *
 * 可选字段：
 * - csNotifyUrl     清算结果回调地址（仅限易宝分账使用）
 * - fundProcessType 易宝资金处理类型，可选：DELAY_SETTLE（延迟结算）
 * - bankCardNo      持卡人银行卡号
 * - idCardNo        持卡人身份证号
 * - cardName        持卡人姓名
 * - cardType        限制卡类型：DEBIT（借记卡）/ CREDIT（信用卡）；不传则不限制
 * - directPayType   银行直连或收银台展示控制，见 DirectPayType 常量
 * - isCashier       是否收银台支付：0否 1是（默认0）
 */
public class UnionExpressRequest {

    private String account;
    private String payMoney;
    private String lowOrderId;
    private String userNo;
    private String userType;
    private String notifyUrl;
    private String returnUrl;

    private String csNotifyUrl;
    private String fundProcessType;
    private String bankCardNo;
    private String idCardNo;
    private String cardName;
    private String cardType;      // DEBIT / CREDIT
    private String directPayType; // 见 DirectPayType
    private String isCashier;     // "0"/"1"

    public Map<String, Object> toParamMapWithoutSign() {
        Map<String, Object> m = new HashMap<>();
        putIfNotEmpty(m, "account", account);
        putIfNotEmpty(m, "payMoney", payMoney);
        putIfNotEmpty(m, "lowOrderId", lowOrderId);
        putIfNotEmpty(m, "userNo", userNo);
        putIfNotEmpty(m, "userType", userType);
        putIfNotEmpty(m, "notifyUrl", notifyUrl);
        putIfNotEmpty(m, "returnUrl", returnUrl);

        putIfNotEmpty(m, "csNotifyUrl", csNotifyUrl);
        putIfNotEmpty(m, "fundProcessType", fundProcessType);
        putIfNotEmpty(m, "bankCardNo", bankCardNo);
        putIfNotEmpty(m, "idCardNo", idCardNo);
        putIfNotEmpty(m, "cardName", cardName);
        putIfNotEmpty(m, "cardType", cardType);
        putIfNotEmpty(m, "directPayType", directPayType);
        putIfNotEmpty(m, "isCashier", isCashier);
        return m;
    }

    private static void putIfNotEmpty(Map<String, Object> map, String key, String val) {
        if (val != null && !val.isEmpty()) map.put(key, val);
    }

    // Getters & Setters
    public String getAccount() { return account; }
    public void setAccount(String account) { this.account = account; }
    public String getPayMoney() { return payMoney; }
    public void setPayMoney(String payMoney) { this.payMoney = payMoney; }
    public String getLowOrderId() { return lowOrderId; }
    public void setLowOrderId(String lowOrderId) { this.lowOrderId = lowOrderId; }
    public String getUserNo() { return userNo; }
    public void setUserNo(String userNo) { this.userNo = userNo; }
    public String getUserType() { return userType; }
    public void setUserType(String userType) { this.userType = userType; }
    public String getNotifyUrl() { return notifyUrl; }
    public void setNotifyUrl(String notifyUrl) { this.notifyUrl = notifyUrl; }
    public String getReturnUrl() { return returnUrl; }
    public void setReturnUrl(String returnUrl) { this.returnUrl = returnUrl; }
    public String getCsNotifyUrl() { return csNotifyUrl; }
    public void setCsNotifyUrl(String csNotifyUrl) { this.csNotifyUrl = csNotifyUrl; }
    public String getFundProcessType() { return fundProcessType; }
    public void setFundProcessType(String fundProcessType) { this.fundProcessType = fundProcessType; }
    public String getBankCardNo() { return bankCardNo; }
    public void setBankCardNo(String bankCardNo) { this.bankCardNo = bankCardNo; }
    public String getIdCardNo() { return idCardNo; }
    public void setIdCardNo(String idCardNo) { this.idCardNo = idCardNo; }
    public String getCardName() { return cardName; }
    public void setCardName(String cardName) { this.cardName = cardName; }
    public String getCardType() { return cardType; }
    public void setCardType(String cardType) { this.cardType = cardType; }
    public String getDirectPayType() { return directPayType; }
    public void setDirectPayType(String directPayType) { this.directPayType = directPayType; }
    public String getIsCashier() { return isCashier; }
    public void setIsCashier(String isCashier) { this.isCashier = isCashier; }

    public static Builder builder() { return new Builder(); }

    public static class Builder {
        private final UnionExpressRequest r = new UnionExpressRequest();
        public Builder account(String v) { r.setAccount(v); return this; }
        public Builder payMoney(String v) { r.setPayMoney(v); return this; }
        public Builder lowOrderId(String v) { r.setLowOrderId(v); return this; }
        public Builder userNo(String v) { r.setUserNo(v); return this; }
        public Builder userType(String v) { r.setUserType(v); return this; }
        public Builder notifyUrl(String v) { r.setNotifyUrl(v); return this; }
        public Builder returnUrl(String v) { r.setReturnUrl(v); return this; }
        public Builder csNotifyUrl(String v) { r.setCsNotifyUrl(v); return this; }
        public Builder fundProcessType(String v) { r.setFundProcessType(v); return this; }
        public Builder bankCardNo(String v) { r.setBankCardNo(v); return this; }
        public Builder idCardNo(String v) { r.setIdCardNo(v); return this; }
        public Builder cardName(String v) { r.setCardName(v); return this; }
        public Builder cardType(String v) { r.setCardType(v); return this; }
        public Builder directPayType(String v) { r.setDirectPayType(v); return this; }
        public Builder isCashier(String v) { r.setIsCashier(v); return this; }
        public UnionExpressRequest build() { return r; }
    }

    /**
     * directPayType 可选值常量
     * 包含：银行直连（B2C/B2B）与收银台 EBANK 系列。
     * 如不传 directPayType，则走快捷支付；传银行编码则走网银直连；传 EBANK* 则走收银台展示网银。
     */
    public static final class DirectPayType {
        private DirectPayType() {}
        // B2C
        public static final String ICBC_B2C = "ICBC_B2C";
        public static final String CMBCHINA_B2C = "CMBCHINA_B2C";
        public static final String CCB_B2C = "CCB_B2C";
        public static final String CIB_B2C = "CIB_B2C";
        public static final String CMBC_B2C = "CMBC_B2C";
        public static final String CEB_B2C = "CEB_B2C";
        public static final String BOC_B2C = "BOC_B2C";
        public static final String SZPA_B2C = "SZPA_B2C";
        public static final String ECITIC_B2C = "ECITIC_B2C";
        public static final String SHB_B2C = "SHB_B2C";
        public static final String SPDB_B2C = "SPDB_B2C";
        public static final String HXB_B2C = "HXB_B2C";
        public static final String BCCB_B2C = "BCCB_B2C";
        public static final String ABC_B2C = "ABC_B2C";
        public static final String PSBC_B2C = "PSBC_B2C";
        public static final String HSB_B2C = "HSB_B2C";
        public static final String CZ_B2C = "CZ_B2C";
        public static final String QLYH_B2C = "QLYH_B2C";
        public static final String JSHB_B2C = "JSHB_B2C";
        // B2B
        public static final String ICBC_B2B = "ICBC_B2B";
        public static final String CMBCHINA_B2B = "CMBCHINA_B2B";
        public static final String CCB_B2B = "CCB_B2B";
        public static final String CIB_B2B = "CIB_B2B";
        public static final String CMBC_B2B = "CMBC_B2B";
        public static final String CEB_B2B = "CEB_B2B";
        public static final String BOC_B2B = "BOC_B2B";
        public static final String SZPA_B2B = "SZPA_B2B";
        public static final String ECITIC_B2B = "ECITIC_B2B";
        public static final String SHB_B2B = "SHB_B2B";
        public static final String SPDB_B2B = "SPDB_B2B";
        public static final String HXB_B2B = "HXB_B2B";
        public static final String BCCB_B2B = "BCCB_B2B";
        public static final String ABC_B2B = "ABC_B2B";
        public static final String PSBC_B2B = "PSBC_B2B";
        public static final String HSB_B2B = "HSB_B2B";
        public static final String QDYH_B2B = "QDYH_B2B";
        public static final String CZ_B2B = "CZ_B2B";
        public static final String QLYH_B2B = "QLYH_B2B";
        public static final String ISBC_B2B = "ISBC_B2B";
        public static final String XMCCB_B2B = "XMCCB_B2B";
        // 收银台控制
        public static final String EBANK_B2B = "EBANK_B2B";
        public static final String EBANK_B2C = "EBANK_B2C";
        public static final String EBANK = "EBANK";
    }
}