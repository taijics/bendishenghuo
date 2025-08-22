/*
* Copyright (C) 2017-2021
* All rights reserved, Designed By 深圳中科鑫智科技有限公司
* Copyright authorization contact 18814114118
*/
package com.shop.cereshop.commons.domain.customer_service;

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
 * 店铺客服关联表
 * </p>
 *
 * @since 2022-08-10
 */
@Data
@NoArgsConstructor
@ToString(callSuper = true)
@TableName("cere_shop_customer_service")
@ApiModel(value = "ShopCustomerService", description = "店铺客服关联表")
@AllArgsConstructor
public class ShopCustomerService {

    private static final long serialVersionUID = 1L;

    /**
     * 主键id
     */
    @ApiModelProperty(value = "主键id")
    @NotNull(message = "主键id不能为空")
    @TableId(value = "id", type = IdType.AUTO)
    private Long id;


    /**
     * 店铺id
     */
    @ApiModelProperty(value = "店铺id")
    @NotNull(message = "店铺id不能为空")
    @TableField("shop_id")
    private Long shopId;


    /**
     * 客服id
     */
    @ApiModelProperty(value = "客服id")
    @NotEmpty(message = "客服id不能为空")
    @Length(max = 64, message = "客服id长度不能超过64")
    @TableField(value = "open_kfid", condition = LIKE)
    private String openKfid;


    /**
     * 创建时间
     */
    @ApiModelProperty(value = "创建时间")
    @Length(max = 20, message = "创建时间长度不能超过20")
    @TableField(value = "create_time", condition = LIKE)
    private String createTime;


    /**
     * 更新时间
     */
    @ApiModelProperty(value = "更新时间")
    @Length(max = 20, message = "更新时间长度不能超过20")
    @TableField(value = "update_time", condition = LIKE)
    private String updateTime;




}
