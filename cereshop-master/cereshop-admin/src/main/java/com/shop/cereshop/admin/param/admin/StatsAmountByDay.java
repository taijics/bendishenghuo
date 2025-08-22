package com.shop.cereshop.admin.param.admin;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

import java.math.BigDecimal;

@Data
@ApiModel("金额统计")
public class StatsAmountByDay {

    @ApiModelProperty("统计日期")
    private String statsDate;

    @ApiModelProperty("金额")
    private BigDecimal amount;

}
