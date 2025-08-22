/*
 * Copyright (C) 2017-2021
 * All rights reserved, Designed By 深圳中科鑫智科技有限公司
 * Copyright authorization contact 18814114118
 */
package com.shop.cereshop.commons.constant;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Getter;

import java.util.HashMap;
import java.util.Map;

@JsonFormat(shape = JsonFormat.Shape.OBJECT)
@Getter
public enum ParamEnum {

    BUY_NOW("结算类型-立即购买",1),
    CART_SETTLEMENT("结算类型-购物车结算",2),
    GROUP_WORK_ALONE("结算类型-拼团商品单独立即购买",3),
    CHARGE_TYPE_NUMBER("按件",1),
    CHARGE_TYPE_WEIGHT("按重量",2),
    CHARGE_TYPE("全国包邮",3),
    ORDER_TYPE_PARENT("订单类型-父订单",1),
    ORDER_TYPE_CHILD("订单类型-子订单",2),
    PAY_XCX("支付终端-小程序",1),
    PAY_APP("支付终端-APP",2),
    PAY_H5("H5支付终端",3),
    PAY_APP_V3("支付终端-APP-V3",4),
    CONVERSION_VISIT("店铺转化类型-访问人数",1),
    CONVERSION_CART("店铺转化类型-加购人数",2),
    CONVERSION_CHECK("店铺转化类型-结账人数",3),
    CONVERSION_PAY("店铺转化类型-调用支付人数",4),
    CONVERSION_PAY_SUCCESS("店铺转化类型-支付成功人数",5);

    String name;
    Integer code;

    private static Map<String, ParamEnum> valueMap = new HashMap<>();

    static {
        for(ParamEnum gender : ParamEnum.values()) {
            valueMap.put(gender.name, gender);
        }
    }

    ParamEnum(String name, Integer code) {
        this.code = code;
        this.name=name;
    }

    public static Integer getByName(String name) {
        ParamEnum result = valueMap.get(name);
        if(result == null) {
            throw new IllegalArgumentException("No element matches " + name);
        }
        return result.code;
    }

    public static String getByCode(Integer code) {
        ParamEnum[] values = ParamEnum.values();
        for (ParamEnum curEnum:values) {
            if (curEnum.getCode().equals(code)) {
                return curEnum.getName();
            }
        }
        return "";
    }
}
