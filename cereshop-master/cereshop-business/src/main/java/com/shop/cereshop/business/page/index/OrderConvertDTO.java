package com.shop.cereshop.business.page.index;

import com.shop.cereshop.commons.poi.export.ExcelResources;
import lombok.Data;

@Data
public class OrderConvertDTO {

    @ExcelResources(order = 0, title = "日期", cloumn = 15)
    private String date;

    @ExcelResources(order = 1, title = "待支付", cloumn = 15)
    private Integer waitToPayCount;

    @ExcelResources(order = 2, title = "已支付", cloumn = 15)
    private Integer payCount;

    @ExcelResources(order = 3, title = "已发货", cloumn = 15)
    private Integer deliverCount;

    @ExcelResources(order = 4, title = "申请售后(退/换货)", cloumn = 15)
    private Integer afterSaleCount;

}
