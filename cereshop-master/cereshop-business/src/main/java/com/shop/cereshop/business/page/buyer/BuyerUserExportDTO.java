package com.shop.cereshop.business.page.buyer;

import com.shop.cereshop.commons.poi.export.ExcelResources;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

import java.math.BigDecimal;

@Data
public class BuyerUserExportDTO {

    /**
     * 客户id
     */
    @ApiModelProperty(value = "客户id")
    @ExcelResources(order=0,title = "客户id",cloumn = 15)
    private Long buyerUserId;

    /**
     * 客户昵称
     */
    @ApiModelProperty(value = "客户昵称")
    @ExcelResources(order=1,title = "客户昵称",cloumn = 15)
    private String name;

    /**
     * 手机号
     */
    @ApiModelProperty(value = "手机号")
    @ExcelResources(order=2,title = "手机号",cloumn = 15)
    private String phone;

    /**
     * 消费次数
     */
    @ApiModelProperty(value = "消费次数")
    @ExcelResources(order=3,title = "消费次数",cloumn = 15)
    private Integer frequency;

    /**
     * 累计消费金额
     */
    @ApiModelProperty(value = "累计消费金额")
    @ExcelResources(order=4,title = "累计消费金额",cloumn = 15)
    private BigDecimal total;

    /**
     * 上次消费时间
     */
    @ApiModelProperty(value = "上次消费时间")
    @ExcelResources(order=5,title = "上次消费时间",cloumn = 15)
    private String lastTime;

    /**
     * 成为客户时间
     */
    @ApiModelProperty(value = "成为客户时间")
    @ExcelResources(order=6,title = "成为客户时间",cloumn = 15)
    private String time;

    /**
     * 客户关联标签
     */
    @ApiModelProperty(value = "客户关联标签")
    @ExcelResources(order=7,title = "客户关联标签",cloumn = 15)
    private String labelName;

}
