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
import lombok.experimental.Accessors;

import javax.validation.constraints.NotNull;

/**
 * <p>
 * 实体类
 * 商家客服配置表
 * </p>
 *
 * @since 2021-12-13
 */
@Data
@NoArgsConstructor
@ToString(callSuper = true)
@Accessors(chain = true)
@TableName("cere_customer_service_config")
@ApiModel(value = "CereCustomerServiceConfig", description = "商家客服配置表")
@AllArgsConstructor
public class CereCustomerServiceConfig {

    private static final long serialVersionUID = 1L;

    @ApiModelProperty("主键id")
    @TableId(type = IdType.AUTO)
    private Long id;

    /**
     * 店铺id
     */
    @ApiModelProperty(value = "店铺id")
    @NotNull(message = "店铺id不能为空")
    @TableField("shop_id")
    private Long shopId;

    /**
     * 需要appId吗
     */
    @TableField(value = "permanent_code")
    private String permanentCode;

    /**
     * 授权企业的id
     */
    @TableField(value = "auth_corp_id")
    private String authCorpId;

    @ApiModelProperty(value = "创建时间")
    @TableField("create_time")
    private String createTime;

    @ApiModelProperty(value = "修改时间")
    @TableField("update_time")
    private String updateTime;

}
