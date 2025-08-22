/*
* Copyright (C) 2017-2021
* All rights reserved, Designed By 深圳中科鑫智科技有限公司
* Copyright authorization contact 18814114118
*/
package com.shop.cereshop.commons.domain.tool;

import com.baomidou.mybatisplus.annotation.TableField;
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
 * 渠道券表
 * </p>
 *
 * @since 2021-12-12
 */
@Data
@NoArgsConstructor
@ToString(callSuper = true)
@Accessors(chain = true)
@TableName("cere_channel_coupon")
@ApiModel(value = "CereChannelCoupon", description = "渠道券表")
@AllArgsConstructor
public class CereChannelCoupon {

    private static final long serialVersionUID = 1L;

    /**
     * 优惠券id
     */
    @ApiModelProperty(value = "优惠券id")
    @NotNull(message = "优惠券id不能为空")
    @TableField("shop_coupon_id")
    private Long shopCouponId;

    /**
     * 商品id
     */
    @ApiModelProperty(value = "商品id")
    @NotNull(message = "商品id不能为空")
    @TableField("product_id")
    private Long productId;

    /**
     * 店铺id
     */
    @ApiModelProperty(value = "店铺id")
    @NotNull(message = "店铺id不能为空")
    @TableField("shop_id")
    private Long shopId;


    @ApiModelProperty("创建时间")
    private String createTime;

    @ApiModelProperty("更新时间")
    private String updateTime;

}
