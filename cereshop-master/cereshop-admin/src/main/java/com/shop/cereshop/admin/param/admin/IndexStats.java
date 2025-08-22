package com.shop.cereshop.admin.param.admin;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

import java.math.BigDecimal;

@Data
@ApiModel("首页统计数据")
public class IndexStats {

    @ApiModelProperty("今日新增用户数")
    private int todayNewUser = 0;
    @ApiModelProperty("昨日新增用户数")
    private int yesterdayNewUser = 0;
    @ApiModelProperty("本周和上周新增用户数环比")
    private BigDecimal weekRelativeRatioNewUser = BigDecimal.ZERO.setScale(2, BigDecimal.ROUND_HALF_UP);

    @ApiModelProperty("今日访问量")
    private int todayVisitCount = 0;
    @ApiModelProperty("昨日访问量")
    private int yesterdayVisitCount = 0;
    @ApiModelProperty("本周和上周访问量环比")
    private BigDecimal weekRelativeRatioVisitCount = BigDecimal.ZERO.setScale(2, BigDecimal.ROUND_HALF_UP);

    @ApiModelProperty("今日访客")
    private int todayVisitUser = 0;
    @ApiModelProperty("昨日访客")
    private int yesterdayVisitUser = 0;
    @ApiModelProperty("本周和上周访客数环比")
    private BigDecimal weekRelativeRatioVisitUser = BigDecimal.ZERO.setScale(2, BigDecimal.ROUND_HALF_UP);

    @ApiModelProperty("今日新增店铺")
    private int todayShopCount = 0;
    @ApiModelProperty("昨日新增店铺")
    private int yesterdayShopCount = 0;
    @ApiModelProperty("本周和上周新增店铺环比")
    private BigDecimal weekRelativeRatioShopCount = BigDecimal.ZERO.setScale(2, BigDecimal.ROUND_HALF_UP);

}
