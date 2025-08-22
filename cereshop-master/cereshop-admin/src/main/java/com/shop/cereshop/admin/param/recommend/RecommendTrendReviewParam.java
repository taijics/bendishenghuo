/*
 * Copyright (C) 2017-2021
 * All rights reserved, Designed By 深圳中科鑫智科技有限公司
 * Copyright authorization contact 18814114118
 */
package com.shop.cereshop.admin.param.recommend;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

/**
 * 种草动态审核请求
 */
@Data
@ApiModel(value = "RecommendTrendReviewParam", description = "种草动态审核请求")
public class RecommendTrendReviewParam{

    /**
     * 种草id
     */
    @ApiModelProperty(value = "种草id")
    private Long recommendId;
    /**
     * 审核失败内容
     */
    @ApiModelProperty(value = "审核失败内容")
    private String reviewContent;
    /**
     * 审核状态 0-未通过 1-通过
     */
    @ApiModelProperty(value = "审核状态 0-未通过 1-通过")
    private Integer reviewStatus;

}
