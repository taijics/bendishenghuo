package com.shop.cereshop.business.page.index;

import com.shop.cereshop.commons.poi.export.ExcelResources;
import lombok.Data;

@Data
public class HotProductDTO {

    @ExcelResources(order = 0, title = "日期", cloumn = 15)
    private String date;

    @ExcelResources(order = 1, title = "商品id", cloumn = 15)
    private Long productId;

    @ExcelResources(order = 2, title = "销量", cloumn = 15)
    private Integer salesVolume;

    @ExcelResources(order = 3, title = "访问量", cloumn = 15)
    private Integer visitCount;

    @ExcelResources(order = 4, title = "加购量", cloumn = 15)
    private Integer addCartCount;

}
