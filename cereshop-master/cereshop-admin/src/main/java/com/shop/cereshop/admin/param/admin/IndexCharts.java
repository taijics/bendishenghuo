package com.shop.cereshop.admin.param.admin;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

import java.math.BigDecimal;
import java.util.List;

@Data
@ApiModel("首页统计图表")
public class IndexCharts {

    @ApiModelProperty("今日订单金额")
    private BigDecimal todayOrderAmount = BigDecimal.ZERO.setScale(2, BigDecimal.ROUND_HALF_UP);;

    @ApiModelProperty("过去一个月订单金额列表")
    private List<StatsAmountByDay> orderAmountList;

    @ApiModelProperty("日订单数")
    private Integer todayOrderCount = 0;

    @ApiModelProperty("订单日同比")
    private BigDecimal dayToDayOrderCountRelativeRate = BigDecimal.ZERO.setScale(2, BigDecimal.ROUND_HALF_UP);

    @ApiModelProperty("过去一个月订单量")
    private List<StatsByDay> orderCountList;

    @ApiModelProperty("月订单数")
    private Integer curMonthOrderCount = 0;

    @ApiModelProperty("订单月同比")
    private BigDecimal monthToMonthOrderCountRelativeRate = BigDecimal.ZERO.setScale(2, BigDecimal.ROUND_HALF_UP);


    @ApiModelProperty("当日支付人数")
    private Integer todayPayUserCount = 0;

    @ApiModelProperty("支付人数同比")
    private BigDecimal dayToDayPayUserCountRelativeRate = BigDecimal.ZERO.setScale(2, BigDecimal.ROUND_HALF_UP);

    @ApiModelProperty("过去一个月支付人数")
    private List<StatsByDay> payUserCountList;

    @ApiModelProperty("月支付人数")
    private Integer curMonthPayUserCount = 0;

    @ApiModelProperty("支付人数月同比")
    private BigDecimal monthToMonthPayUserCountRelativeRate = BigDecimal.ZERO.setScale(2, BigDecimal.ROUND_HALF_UP);
}
