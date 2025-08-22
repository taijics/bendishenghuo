package com.shop.cereshop.business.param.order.applet;

import lombok.Data;

@Data
public class ShippingList {
    /***
     *订单单号类型，用于确认需要上传详情的订单。枚举值1，使用下单商户号和商户侧单号；枚举值2，使用微信支付单号。
     */
    private String tracking_no;
    /***
     * 微信订单id
     */
    private String express_company;

    private String item_desc;

    private Contact contact;
}

