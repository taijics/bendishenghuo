package com.shop.cereshop.admin.page.activity;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

import java.util.List;

@Data
@ApiModel("活动图表相关数据")
public class ActivityChartsData {

    /**
     * 分布情况
     */
    @ApiModelProperty(value = "分布情况")
    private List<Proportion> cities;

    /**
     * 前五省份访问占比
     */
    @ApiModelProperty(value = "前五省份访问占比")
    private List<Proportion> cityPeople;

    /**
     * 新老访客占比
     */
    @ApiModelProperty(value = "新老访客占比")
    private List<Proportion> newOlds;

    /**
     * 终端访客占比
     */
    @ApiModelProperty(value = "终端访客占比")
    private List<Proportion> terminals;

    /**
     * 系统访客占比
     */
    @ApiModelProperty(value = "系统访客占比")
    private List<Proportion> systems;

    /**
     * 趋势图
     */
    @ApiModelProperty(value = "趋势图")
    private Trend trend;

    /**
     * 商家成交排行榜
     */
    @ApiModelProperty(value = "商家成交排行榜")
    private List<ShopRanking> shopRankings;

    /**
     * 畅销商品排行榜
     */
    @ApiModelProperty(value = "畅销商品排行榜")
    private List<ProductRanking> productRankings;

    /**
     * 销售类别分布
     */
    @ApiModelProperty(value = "销售类别分布")
    private List<ActivityClassify> classifies;

}
