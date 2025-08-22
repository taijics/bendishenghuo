package com.shop.cereshop.business.param.order.applet;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class OrderKey {
    /***
     *订单单号类型，用于确认需要上传详情的订单。枚举值1，使用下单商户号和商户侧单号；枚举值2，使用微信支付单号。
     */
    private Integer order_number_type;
    /***
     * 微信订单id
     */
    private String transaction_id;
}
