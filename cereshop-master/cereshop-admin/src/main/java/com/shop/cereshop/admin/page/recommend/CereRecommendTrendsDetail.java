package com.shop.cereshop.admin.page.recommend;


import com.shop.cereshop.admin.page.product.RecommendProduct;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

import java.util.List;


/**
 * 种草动态明细
 *
 * @author
 */
@Data
@ApiModel(value = "CereRecommendTrendsDetail", description = "种草动态明细")
public class CereRecommendTrendsDetail {
    /**
     * 种草id
     */
    @ApiModelProperty(value = "种草id")
    private Long recommendId;
    /**
     * 店铺id
     */
    @ApiModelProperty(value = "店铺id")
    private Long shopId;
    /**
     * 店铺名称
     */
    @ApiModelProperty(value = "店铺名称")
    private String shopName;
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
     * 审核内容
     */
    @ApiModelProperty(value = "审核内容")
    private String reviewContent;
    /**
     * 发布状态 0-未审核 1-已发布 2-审核失败
     */
    @ApiModelProperty(value = "发布状态 0-未审核 1-已发布 2-审核失败")
    private Integer publishStatus;
    /**
     * 商品数量
     */
    @ApiModelProperty(value = "商品数量")
    private Integer productCount;
    /**
     * 点赞数
     */
    @ApiModelProperty(value = "点赞数")
    private Integer likeCount;
    /**
     * 评论数
     */
    @ApiModelProperty(value = "评论数")
    private Integer commentCount;
    /**
     * 浏览数
     */
    @ApiModelProperty(value = "浏览数")
    private Integer browseCount;
    /**
     * 分享数
     */
    @ApiModelProperty(value = "分享数")
    private Integer shareCount;
    /**
     * 发布时间
     */
    @ApiModelProperty(value = "发布时间")
    private String publishTime;
    /**
     * 创建时间
     */
    @ApiModelProperty(value = "创建时间")
    private String createTime;
    /**
     * 更新时间
     */
    @ApiModelProperty(value = "更新时间")
    private String updateTime;
    /**
     * 关联商品信息
     */
    @ApiModelProperty(value = "关联商品信息")
    private List<RecommendProduct> products;
}
