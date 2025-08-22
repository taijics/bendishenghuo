package com.shop.cereshop.commons.domain.recommend;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

/**
 * cere_recommend_likes 种草点赞信息实体类
 *
 * @author
 */
@Data
@ApiModel(value = "CereRecommendLikes", description = "种草点赞信息实体类")
public class CereRecommendLikes {
    /**
     * 种草点赞id
     */
    @ApiModelProperty(value = "种草点赞id")
    @TableId(type = IdType.AUTO)
    private Long recommendLikeId;
    /**
     * 点赞用户id
     */
    @ApiModelProperty(value = "点赞用户id")
    private Long userId;
    /**
     * 种草id
     */
    @ApiModelProperty(value = "种草id")
    private Long recommendId;
    /**
     * 创建时间
     */
    @ApiModelProperty(value = "创建时间")
    private String createTime;
}
