package com.shop.cereshop.business.param.order.applet;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class Contact {

    /***
     * 联系方式，当发货的物流公司为顺丰时，联系方式为必填，收件人或寄件人联系方式二选一
     * 寄件人联系方式，寄件人联系方式，采用掩码传输，最后4位数字不能打掩码
     * 示例值: `189****1234, 021-****1234, ****1234,
     * 0**2-***1234, 0**2-******23-10, ****123-8008` 值限制: 0 ≤ value ≤ 1024
     */
    private String consignor_contact;

    /***
     * 收件人联系方式，收件人联系方式为，采用掩码传输，最后4位数字不能打掩码 示例值: `189****1234, 021-****1234,
     * ****1234, 0**2-***1234, 0**2-******23-10, ****123-8008` 值限制: 0 ≤ value ≤ 1024
     */
    private String receiver_contact;
}
