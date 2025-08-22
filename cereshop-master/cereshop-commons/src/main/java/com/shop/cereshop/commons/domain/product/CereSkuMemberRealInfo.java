/*
 * Copyright (C) 2017-2021
 * All rights reserved, Designed By 深圳中科鑫智科技有限公司
 * Copyright authorization contact 18814114118
 */
package com.shop.cereshop.commons.domain.product;

import com.baomidou.mybatisplus.annotation.TableField;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;
import org.hibernate.validator.constraints.Length;

import javax.validation.constraints.NotNull;
import java.math.BigDecimal;

import static com.baomidou.mybatisplus.annotation.SqlCondition.LIKE;

/**
 * <p>
 * 实体类
 *
 * </p>
 *
 * @since 2022-07-17
 */
@Data
@NoArgsConstructor
@ToString(callSuper = true)
@ApiModel(value = "CereSkuMemberRealInfo", description = "")
@AllArgsConstructor
public class CereSkuMemberRealInfo {

    private static final long serialVersionUID = 1L;

    /**
     * skuId
     */
    @ApiModelProperty(value = "skuId")
    private Long skuId;

    /**
     * 商品id
     */
    @ApiModelProperty(value = "商品id")
    private Long productId;

    /**
     * 会员等级id
     */
    @ApiModelProperty(value = "会员等级id")
    private Long memberLevelId;

    /**
     * 参考IntegerEnum.ACTIVITY_TYPE_XXX
     */
    @ApiModelProperty(value = "参考IntegerEnum.ACTIVITY_TYPE_XXX")
    @NotNull(message = "参考IntegerEnum.ACTIVITY_TYPE_XXX不能为空")
    @TableField("activity_type")
    private Integer activityType;


    /**
     * 活动id
     */
    @ApiModelProperty(value = "活动id")
    @NotNull(message = "活动id不能为空")
    @TableField("activity_id")
    private Long activityId;


    /**
     * 当前价格
     */
    @ApiModelProperty(value = "当前价格")
    @NotNull(message = "当前价格不能为空")
    @TableField("cur_price")
    private BigDecimal curPrice;

    /**
     * 当前原价
     */
    @ApiModelProperty(value = "当前原价")
    @NotNull(message = "当前原价不能为空")
    @TableField("cur_original_price")
    private BigDecimal curOriginalPrice;


    /**
     * 最小价格
     */
    @ApiModelProperty(value = "最小价格")
    @NotNull(message = "最小价格不能为空")
    @TableField("min_price")
    private BigDecimal minPrice;


    /**
     * 最大价格
     */
    @ApiModelProperty(value = "最大价格")
    @NotNull(message = "最大价格不能为空")
    @TableField("max_price")
    private BigDecimal maxPrice;

    /**
     * 限购数量
     */
    @ApiModelProperty(value = "限购数量")
    @NotNull(message = "限购数量不能为空")
    @TableField("limit_number")
    private Integer limitNumber;

    /**
     * 活动预热   1-停用  2-启用
     */
    @ApiModelProperty(value = "活动预热   1-停用  2-启用")
    @NotNull(message = "活动预热不能为空")
    @TableField("if_enable")
    private Integer ifEnable;

    /**
     * 预热几小时前
     */
    @ApiModelProperty(value = "预热几小时前")
    @NotNull(message = "预热几小时前不能为空")
    @TableField("enable_time")
    private Integer enableTime;

    /**
     * 是否可以叠加优惠券 1-是 0-否
     */
    @ApiModelProperty(value = "是否可以叠加优惠券 1-是 0-否")
    @NotNull(message = "是否可以叠加优惠券不能为空")
    @TableField("if_add")
    private Integer ifAdd;

    /**
     * 成团人数
     */
    @ApiModelProperty(value = "成团人数")
    @NotNull(message = "成团人数")
    @TableField("person")
    private Integer person;

    /**
     * 商品维度的下单人数 只要下过单的都算
     */
    @ApiModelProperty(value = "下单人数")
    @NotNull(message = "下单人数")
    @TableField("sales_user_count")
    private Integer salesUserCount;

    /**
     * 当前销量,根据activityType不同而有变化
     */
    @ApiModelProperty(value = "当前销量,根据activityType不同而有变化")
    @NotNull(message = "当前销量,根据activityType不同而有变化不能为空")
    @TableField("sales_volume")
    private Integer salesVolume;


    /**
     * 该sku总销量
     */
    @ApiModelProperty(value = "该sku总销量")
    @NotNull(message = "该sku总销量不能为空")
    @TableField("sku_sales_volume")
    private Integer skuSalesVolume;


    /**
     * 商品总销量
     */
    @ApiModelProperty(value = "商品总销量")
    @NotNull(message = "商品总销量不能为空")
    @TableField("product_sales_volume")
    private Integer productSalesVolume;

    /**
     * 活动开始时间
     */
    @ApiModelProperty(value = "活动开始时间")
    @Length(max = 20, message = "活动开始时间长度不能超过20")
    @TableField(value = "start_time", condition = LIKE)
    private String startTime;

    /**
     * 活动结束时间
     */
    @ApiModelProperty(value = "活动结束时间")
    @Length(max = 20, message = "活动结束时间长度不能超过20")
    @TableField(value = "end_time", condition = LIKE)
    private String endTime;

    /**
     * 活动状态 对于平台端 0-报名未开始 1-报名进行中 2-活动待开始 3-活动进行中 4-活动已结束; 对于商家端  0-未开始 1-进行中 2-已结束
     */
    @ApiModelProperty(value = "活动状态")
    @NotNull(message = "活动状态不能为空")
    @TableField("state")
    private Integer state;

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


}
