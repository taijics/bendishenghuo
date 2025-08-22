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
 * 评论回复
 */
@Data
@ApiModel(value = "RecommendCommentReplyParam", description = "评论回复")
public class RecommendCommentReplyParam extends PageParam {
    /**
     * 目标评论id
     */
    @ApiModelProperty(value = "目标评论id")
    private Long targetCommentId;
    /**
     * 评论内容
     */
    @ApiModelProperty(value = "评论内容")
    private String content;
    /**
     * 评论用户id
     */
    @ApiModelProperty(value = "评论用户id")
    private Long userId;



}
