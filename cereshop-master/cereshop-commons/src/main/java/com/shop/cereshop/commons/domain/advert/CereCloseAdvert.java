/*
* Copyright (C) 2017-2021
* All rights reserved, Designed By 深圳中科鑫智科技有限公司
* Copyright authorization contact 18814114118
*/
package com.shop.cereshop.commons.domain.advert;

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
import org.hibernate.validator.constraints.Length;

import javax.validation.constraints.NotNull;
import java.time.LocalDate;

import static com.baomidou.mybatisplus.annotation.SqlCondition.LIKE;

/**
 * <p>
 * 实体类
 * 关闭广告记录表
 * </p>
 *
 * @since 2021-12-12
 */
@Data
@NoArgsConstructor
@ToString(callSuper = true)
@Accessors(chain = true)
@TableName("cere_close_advert")
@ApiModel(value = "CereCloseAdvert", description = "关闭广告记录表")
@AllArgsConstructor
public class CereCloseAdvert {

    private static final long serialVersionUID = 1L;

    @TableId(type = IdType.AUTO)
    private Long id;

    /**
     * 用户id
     */
    @ApiModelProperty(value = "用户id")
    @TableField("buyer_user_id")
    private Long buyerUserId;

    /**
     * 设备id
     */
    @ApiModelProperty(value = "设备id")
    @Length(max = 64, message = "设备id长度不能超过64")
    @TableField(value = "device_id", condition = LIKE)
    private String deviceId;

    /**
     * 关闭日期
     */
    @ApiModelProperty(value = "关闭日期")
    @NotNull(message = "关闭日期不能为空")
    @TableField("close_date")
    private LocalDate closeDate;

    /**
     * 弹出页面 1-首页 2-支付完成页
     */
    @ApiModelProperty("弹出页面 1-首页 2-支付完成页")
    @NotNull(message = "弹出页面 1-首页 2-支付完成页不能为空")
    @TableField("trigger_condition")
    private Integer triggerCondition;

    /**
     * 创建时间
     */
    @ApiModelProperty(value = "创建时间")
    @TableField("create_time")
    private String createTime;

    /**
     * 修改时间
     */
    @ApiModelProperty(value = "修改时间")
    @TableField("update_time")
    private String updateTime;
}
