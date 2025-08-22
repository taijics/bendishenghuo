package com.shop.cereshop.commons.enums;

import java.util.Objects;

public enum AfterTypeEnum {
    // 售后类型  1-仅退款  2-退货退款
    ONLY_REFUND(1, "仅退款 "),
    REFUNDS(2, "退货退款");

    private Integer code;
    private String msg;

    private AfterTypeEnum(Integer code, String msg) {
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
        AfterTypeEnum[] arr = AfterTypeEnum.values();
        for (int i = 0; i < arr.length; i++) {
            if (code.equals(arr[i].getCode())) {
                return arr[i].getMsg();
            }
        }
        return "";
    }
}
