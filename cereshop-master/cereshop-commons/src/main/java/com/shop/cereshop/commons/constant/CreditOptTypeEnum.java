package com.shop.cereshop.commons.constant;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.shop.cereshop.commons.domain.credit.CereCreditRecord;
import lombok.Getter;

@JsonFormat(shape = JsonFormat.Shape.OBJECT)
@Getter
public enum CreditOptTypeEnum {

    POLITE_GIFT(1, 1, "支付有礼"),
    DAILY_SIGN_IN(2, 1, "每日签到"),
    ADMIN_ADD(3, 1, "管理员增加积分"),
    ADMIN_SUB(4, 2, "管理员扣减积分"),
    EXCHANGE_COUPON(5, 2, "积分兑换优惠券"),
    ORDER_DEDUCT(6, 2, "订单抵扣积分"),
    ORDER_ROLLBACK_CREDIT(7, 1, "订单积分回流"),
    PLACE_ORDER(8, 1, "下单增加积分");

    private int optType;
    private int recordType;
    private String recordContent;

    CreditOptTypeEnum(int optType, int recordType, String recordContent) {
        this.optType = optType;
        this.recordType = recordType;
        this.recordContent = recordContent;
    }

    public static CereCreditRecord initRecord(CreditOptTypeEnum typeEnum) {
        CereCreditRecord record = new CereCreditRecord();
        record.setOptType(typeEnum.getOptType());
        record.setRecordType(typeEnum.getRecordType());
        record.setRecordContent(typeEnum.getRecordContent());
        return record;
    }
}
