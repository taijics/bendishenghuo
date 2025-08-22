package com.shop.cereshop.commons.enums;

import java.util.Objects;

public enum OrderStateEnum {
    // 订单状态 1-待付款 2-待发货 3-待收货 4-已完成 5-已取消 6-待成团 7-待售后
    PENDING_PAY(1, "待付款"),
    PENDING_SEND(2, "待发货"),
    PENDING_RECEIVE(3, "待收货"),
    COMPLETED(4, "已完成"),
    CANCELLED(5, "已取消"),
    PENDING_GROUP(6, "待成团"),
    PENDING_AFTER(7, "待售后");

    private Integer code;
    private String msg;

    private OrderStateEnum(Integer code, String msg) {
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
        OrderStateEnum[] arr = OrderStateEnum.values();
        for (int i = 0; i < arr.length; i++) {
            if (code.equals(arr[i].getCode())) {
                return arr[i].getMsg();
            }
        }
        return "";
    }
}
