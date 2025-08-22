/*
 * Copyright (C) 2017-2021
 * All rights reserved, Designed By 深圳中科鑫智科技有限公司
 * Copyright authorization contact 18814114118
 */
package com.shop.cereshop.commons.domain.business;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

import java.io.Serializable;

@Data
@ApiModel("scrm同步配置对象")
public class CereScrmVerify implements Serializable {

    @ApiModelProperty("店铺id")
    @TableId(value = "shop_id", type = IdType.INPUT)
    private Long shopId;

    @ApiModelProperty("编码后的秘钥")
    private String encodeSecret;

}
