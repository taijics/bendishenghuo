package com.shop.cereshop.commons.enums;

import java.util.Objects;

public enum ReviewEnum {
    // 审核状态  1-通过  2-未通过
    PASS(1, "通过 "),
    FAIL(2, "未通过");

    private Integer code;
    private String msg;

    private ReviewEnum(Integer code, String msg) {
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
        ReviewEnum[] arr = ReviewEnum.values();
        for (int i = 0; i < arr.length; i++) {
            if (code.equals(arr[i].getCode())) {
                return arr[i].getMsg();
            }
        }
        return "";
    }
}
