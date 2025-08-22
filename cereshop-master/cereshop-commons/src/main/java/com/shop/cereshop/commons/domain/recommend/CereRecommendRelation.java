package com.shop.cereshop.commons.domain.recommend;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

/**
 * cere_recommend_relation 种草商品关联实体类
 *
 * @author
 */
@Data
@ApiModel(value = "CereRecommendRelation", description = "种草商品关联实体类")
public class CereRecommendRelation {
    /**
     * 关联id
     */
    @ApiModelProperty(value = "关联id")
    @TableId(type = IdType.AUTO)
    private Long recommendRelationId;
    /**
     * 种草id
     */
    @ApiModelProperty(value = "种草id")
    private Long recommendId;
    /**
     * 商品id
     */
    @ApiModelProperty(value = "商品id")
    private Long productId;
}
