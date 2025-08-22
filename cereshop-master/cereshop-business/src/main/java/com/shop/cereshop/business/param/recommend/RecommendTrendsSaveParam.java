package com.shop.cereshop.business.param.recommend;


import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

import java.util.List;

/**
 * 种草动态新增
 *
 * @author
 */
@Data
@ApiModel(value = "RecommendTrendsSaveParam", description = "种草动态新增")
public class RecommendTrendsSaveParam {
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
     * 封面
     */
    @ApiModelProperty(value = "封面")
    private String cover;
    /**
     * 文件地址
     */
    @ApiModelProperty(value = "文件地址")
    private String fileUrl;
    /**
     * 文案
     */
    @ApiModelProperty(value = "文案")
    private String remark;
    /**
     * 关联商品id集合
     */
    @ApiModelProperty(value = "关联商品id集合")
    private List<Long> productIds;
}
