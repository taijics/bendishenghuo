package com.shop.cereshop.commons.domain.recommend;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

/**
 * cere_recommend_type 种草类型实体类
 *
 * @author
 */
@Data
@ApiModel(value = "CereRecommendType", description = "种草类型实体类")
public class CereRecommendType {
    /**
     * 种草id
     */
    @ApiModelProperty(value = "种草id")
    @TableId(type = IdType.AUTO)
    private Long recommendTypeId;
    /**
     * 类型名称
     */
    @ApiModelProperty(value = "类型名称")
    private String name;
    /**
     * 排序
     */
    @ApiModelProperty(value = "排序")
    private Integer sort;

}
