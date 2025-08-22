package com.shop.cereshop.commons.enums;

import java.util.Objects;

public enum PaymentModeEnum {
    // 支付方式 1-微信支付
    WX_PAY(1, "微信支付"),
    ZFB_PAY(2, "支付宝支付");

    private Integer code;
    private String msg;

    private PaymentModeEnum(Integer code, String msg) {
        this.code = code;
        this.msg = msg;
    }

    public Integer getCode() {
        return this.code;
    }

    public String getMsg() {
        return this.msg;
    }

    public static String getMsgByCode(Integer code) {
        if (Objects.isNull(code)) {
            return "";
        }
        PaymentModeEnum[] arr = PaymentModeEnum.values();
        for (int i = 0; i < arr.length; i++) {
            if (code.equals(arr[i].getCode())) {
                return arr[i].getMsg();
            }
        }
        return "";
    }
}
