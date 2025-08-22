package com.shop.cereshop.commons.domain.recommend;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

/**
 * cere_recommend_comment 种草评论实体类
 *
 * @author
 */
@Data
@ApiModel(value = "CereRecommendComment", description = "种草评论实体类")
public class CereRecommendComment {
    /**
     * 种草评论id
     */
    @ApiModelProperty(value = "种草评论id")
    @TableId(type = IdType.AUTO)
    private Long recommendCommentId;
    /**
     * 最上级评论ID
     */
    @ApiModelProperty(value = "最上级评论ID")
    private Long rootCommentId;
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
     * 评论用户类型：1、用户，2、商家'
     */
    @ApiModelProperty(value = "评论用户类型：1、用户，2、商家'")
    private Integer userType;
    /**
     * 目标评论用户id
     */
    @ApiModelProperty(value = "目标评论用户id")
    private Long targetUserId;
    /**
     * 目标评论用户类型：1、用户，2、商家
     */
    @ApiModelProperty(value = "目标评论用户类型：1、用户，2、商家")
    private Integer targetUserType;
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
     * 是否已读：0、未读 1、已读
     */
    @ApiModelProperty(value = "是否已读：0、未读 1、已读")
    private Integer readStatus;
    /**
     * 创建时间
     */
    @ApiModelProperty(value = "创建时间")
    private String createTime;
}
