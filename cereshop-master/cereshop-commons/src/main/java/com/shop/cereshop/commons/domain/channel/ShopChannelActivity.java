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
 * 渠道活动表
 * </p>
 *
 * @since 2022-08-25
 */
@Data
@NoArgsConstructor
@ToString(callSuper = true)
@TableName("cere_shop_channel_activity")
@ApiModel(value = "ShopChannelActivity", description = "渠道活动表")
@AllArgsConstructor
public class ShopChannelActivity {

    private static final long serialVersionUID = 1L;

    /**
     * 渠道活动id
     */
    @ApiModelProperty(value = "渠道活动id")
    @NotNull(message = "渠道活动id不能为空")
    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    /**
     * 店铺id
     */
    @ApiModelProperty("店铺id")
    private Long shopId;


    /**
     * 活动名称
     */
    @ApiModelProperty(value = "活动名称")
    @NotEmpty(message = "活动名称不能为空")
    @Length(max = 64, message = "活动名称长度不能超过64")
    @TableField(value = "activity_name", condition = LIKE)
    private String activityName;


    /**
     * 备注
     */
    @ApiModelProperty(value = "备注")
    @Length(max = 512, message = "备注长度不能超过512")
    @TableField(value = "remark", condition = LIKE)
    private String remark;

    @TableField(exist = false)
    private String activityUrl = "";


    /**
     * 开始时间
     */
    @ApiModelProperty(value = "开始时间")
    @NotEmpty(message = "开始时间不能为空")
    @Length(max = 20, message = "开始时间长度不能超过20")
    @TableField(value = "start_time", condition = LIKE)
    private String startTime;


    /**
     * 结束时间
     */
    @ApiModelProperty(value = "结束时间")
    @NotEmpty(message = "结束时间不能为空")
    @Length(max = 20, message = "结束时间长度不能超过20")
    @TableField(value = "end_time", condition = LIKE)
    private String endTime;


    /**
     * 活动发放数量
     */
    @ApiModelProperty(value = "活动发放数量")
    @NotNull(message = "活动发放数量不能为空")
    @TableField("publish_count")
    private Integer publishCount;

    /**
     * 剩余数量
     */
    @ApiModelProperty(value = "剩余数量")
    @TableField("remain_count")
    private Integer remainCount;

    @TableField(exist = false)
    private Integer releaseCount;

    /**
     * 状态
     */
    @ApiModelProperty(value = "状态 0-未开始 1-进行中 2-已结束")
    @NotNull(message = "状态不能为空")
    @TableField("state")
    private Integer state = 0;


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
