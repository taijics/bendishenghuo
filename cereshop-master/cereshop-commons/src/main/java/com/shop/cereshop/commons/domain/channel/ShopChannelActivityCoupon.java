/*
* Copyright (C) 2017-2021
* All rights reserved, Designed By 深圳中科鑫智科技有限公司
* Copyright authorization contact 18814114118
*/
package com.shop.cereshop.commons.domain.channel;

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
 * 渠道活动关联渠道券表
 * </p>
 *
 * @since 2022-08-25
 */
@Data
@NoArgsConstructor
@ToString(callSuper = true)
@TableName("cere_shop_channel_activity_coupon")
@ApiModel(value = "ShopChannelActivityCoupon", description = "渠道活动关联渠道券表")
@AllArgsConstructor
public class ShopChannelActivityCoupon {

    private static final long serialVersionUID = 1L;

    /**
     * 渠道活动id
     */
    @ApiModelProperty(value = "渠道活动id")
    @NotNull(message = "渠道活动id不能为空")
    @TableId(value = "id", type = IdType.INPUT)
    private Long id;


    /**
     * 渠道券id
     */
    @ApiModelProperty(value = "渠道券id")
    @NotNull(message = "渠道券id不能为空")
    @TableField("coupon_id")
    private Long couponId;

    /**
     * 店铺id
     */
    @ApiModelProperty("店铺id")
    private Long shopId;


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
