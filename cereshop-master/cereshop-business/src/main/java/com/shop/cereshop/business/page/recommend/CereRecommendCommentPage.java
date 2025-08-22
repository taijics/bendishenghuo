package com.shop.cereshop.business.page.recommend;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;


/**
 * 种草评论分页
 *
 * @author
 */
@Data
@ApiModel(value = "CereRecommendCommentPage", description = "种草评论分页")
public class CereRecommendCommentPage {
    /**
     * 种草评论id
     */
    @ApiModelProperty(value = "种草评论id")
    private Long recommendCommentId;
    /**
     * 父评论ID，若为一级评论则为NUL
     */
    @ApiModelProperty(value = "父评论ID，若为一级评论则为NUL")
    private Long parentCommentId;
    /**
     * 种草id
     */
    @ApiModelProperty(value = "种草id")
    private Long recommendId;
    /**
     * 评论用户id
     */
    @ApiModelProperty(value = "评论用户id")
    private Long userId;
    /**
     * 评论用户名称
     */
    @ApiModelProperty(value = "评论用户名称")
    private String name;
    /**
     * 回复用户id
     */
    @ApiModelProperty(value = "回复用户id")
    private Long targetUserId;
    /**
     * 评论内容
     */
    @ApiModelProperty(value = "评论内容")
    private String content;
    /**
     * 回复数
     */
    @ApiModelProperty(value = "回复数")
    private Integer replyCount;
    /**
     * 创建时间
     */
    @ApiModelProperty(value = "创建时间")
    private String createTime;

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
     * 文案
     */
    @ApiModelProperty(value = "文案")
    private String remark;
}
