/*
* Copyright (C) 2017-2021
* All rights reserved, Designed By 深圳中科鑫智科技有限公司
* Copyright authorization contact 18814114118
*/
package com.shop.cereshop.commons.domain.brand;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;
import org.hibernate.validator.constraints.Length;

import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.NotNull;

import static com.baomidou.mybatisplus.annotation.SqlCondition.LIKE;

/**
 * <p>
 * 实体类
 * 品牌表
 * </p>
 *
 * @since 2022-08-26
 */
@Data
@NoArgsConstructor
@ToString(callSuper = true)
@TableName("cere_brand")
@ApiModel(value = "Brand", description = "品牌表")
@AllArgsConstructor
public class Brand {

    private static final long serialVersionUID = 1L;

    /**
     * 品牌id
     */
    @ApiModelProperty(value = "品牌id")
    @NotNull(message = "品牌id不能为空")
    @TableId(value = "id", type = IdType.AUTO)
    private Long id;


    /**
     * 品牌名称
     */
    @ApiModelProperty(value = "品牌名称")
    @NotEmpty(message = "品牌名称不能为空")
    @Length(max = 64, message = "品牌名称长度不能超过64")
    @TableField(value = "brand_name", condition = LIKE)
    private String brandName;


    /**
     * 品牌图标
     */
    @ApiModelProperty(value = "品牌图标")
    @NotEmpty(message = "品牌图标不能为空")
    @Length(max = 1024, message = "品牌图标长度不能超过1024")
    @TableField(value = "brand_logo", condition = LIKE)
    private String brandLogo;


    /**
     * 创建时间
     */
    @ApiModelProperty(value = "创建时间")
    @NotEmpty(message = "创建时间不能为空")
    @Length(max = 20, message = "创建时间长度不能超过20")
    @TableField(value = "create_time", condition = LIKE)
    private String createTime;


    /**
     * 更新时间
     */
    @ApiModelProperty(value = "更新时间")
    @NotEmpty(message = "更新时间不能为空")
    @Length(max = 20, message = "更新时间长度不能超过20")
    @TableField(value = "update_time", condition = LIKE)
    private String updateTime;

}
