/*
 * Copyright (C) 2017-2021
 * All rights reserved, Designed By 深圳中科鑫智科技有限公司
 * Copyright authorization contact 18814114118
 */
package com.shop.cereshop.business.param.recommend;

import com.shop.cereshop.commons.domain.common.PageParam;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

/**
 * 获取种草动态列表请求
 */
@Data
@ApiModel(value = "RecommendTrendPageParam", description = "获取种草动态列表请求")
public class RecommendTrendPageParam extends PageParam {
    /**
     * 店铺id
     */
    @ApiModelProperty(value = "店铺id")
    private Long shopId;
    /**
     * 种草类型
     */
    @ApiModelProperty(value = "种草类型")
    private Integer recommendType;
    /**
     * 文件类型 1-图文 2-视频
     */
    @ApiModelProperty(value = "文件类型 1-图文 2-视频")
    private Integer fileType;

    /**
     * 发布状态 0-未审核 1-已发布 2-审核失败
     */
    @ApiModelProperty(value = "发布状态 0-未审核 1-已发布 2-审核失败")
    private Integer publishStatus;

    /**
     * 发布开始时间
     */
    @ApiModelProperty(value = "发布开始时间")
    private String publishStartTime;

    /**
     * 发布结束时间
     */
    @ApiModelProperty(value = "发布结束时间")
    private String publishEndTime;

}
