package com.shop.cereshop.business.page.index;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

@Data
@ApiModel("商家端首页数据统计导出")
public class VisitWeekExportDTO {

    @ApiModelProperty("访问时间")
    private String visitTime;

    @ApiModelProperty("用户id")
    private Long buyerUserId;

}
