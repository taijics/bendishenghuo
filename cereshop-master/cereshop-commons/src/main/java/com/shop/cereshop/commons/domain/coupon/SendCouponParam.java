package com.shop.cereshop.commons.domain.coupon;

import lombok.Data;

@Data
public class SendCouponParam {
    /**
     * 批次号
     */
    private String stock_id;

    /**
     * 发券凭证
     */
    private String out_request_no;
}
