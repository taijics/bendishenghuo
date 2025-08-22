/*
 * Copyright (C) 2017-2021
 * All rights reserved, Designed By 深圳中科鑫智科技有限公司
 * Copyright authorization contact 18814114118
 */
package com.shop.cereshop.commons.domain.label;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

import java.io.Serializable;

/**
 * cere_shop_label 店铺标签信息实体类
 * @author
 */
@Data
@ApiModel(value = "CereShopLabel", description = "店铺标签信息实体类")
public class CereShopLabel implements Serializable {
    /**
     * 标签id
     */
    @ApiModelProperty(value = "标签id")
    @TableId(type = IdType.AUTO)
    private Long labelId;

    /**
     * 关联店铺id
     */
    @ApiModelProperty(value = "关联店铺id")
    private Long shopId;

    /**
     * 标签名称
     */
    @ApiModelProperty(value = "标签名称")
    private String labelName;

    /**
     * 标签类型 1 图片。2 视频
     */
    @ApiModelProperty(value = "标签类型 1 图片。2 视频")
    private Integer labelType;

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

    private static final long serialVersionUID = 1L;

}
