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
import lombok.*;
import lombok.experimental.Accessors;
import org.hibernate.validator.constraints.Length;

import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.NotNull;

import static com.baomidou.mybatisplus.annotation.SqlCondition.LIKE;

/**
 * <p>
 * 实体类
 * 弹窗广告表
 * </p>
 *
 * @author JustArgo
 * @since 2021-12-04
 */
@Data
@NoArgsConstructor
@ToString(callSuper = true)
@Accessors(chain = true)
@TableName("cere_popup_advert")
@ApiModel(value = "CerePopupAdvert", description = "弹窗广告表")
@AllArgsConstructor
public class CerePopupAdvert {

    private static final long serialVersionUID = 1L;

    @TableId(type = IdType.AUTO)
    @ApiModelProperty("主键id")
    private Long id;

    /**
     * 广告名称
     */
    @ApiModelProperty(value = "广告名称")
    @NotEmpty(message = "广告名称不能为空")
    @Length(max = 64, message = "广告名称长度不能超过64")
    @TableField(value = "name", condition = LIKE)
    private String name;

    /**
     * 开始时间
     */
    @ApiModelProperty(value = "开始时间")
    @Length(max = 32, message = "开始时间长度不能超过32")
    @TableField(value = "start_time", condition = LIKE)
    private String startTime;

    /**
     * 结束时间
     */
    @ApiModelProperty(value = "结束时间")
    @Length(max = 32, message = "结束时间长度不能超过32")
    @TableField(value = "end_time", condition = LIKE)
    private String endTime;

    /**
     * 弹窗广告图片
     */
    @ApiModelProperty(value = "弹窗广告图片")
    @Length(max = 256, message = "弹窗广告图片长度不能超过256")
    @TableField(value = "popup_img", condition = LIKE)
    private String popupImg;

    /**
     * 关闭图片
     */
    @ApiModelProperty(value = "关闭图片")
    @Length(max = 256, message = "关闭图片长度不能超过256")
    @TableField(value = "close_img", condition = LIKE)
    private String closeImg;

    /**
     * 跳转类型 1-商品 2-分类 3-优惠券 4-小程序 5-公众号文章
     */
    @ApiModelProperty(value = "跳转类型 1-商品 2-分类 3-优惠券 4-小程序 5-公众号文章")
    @NotNull(message = "跳转类型 1-商品 2-分类 3-优惠券 4-小程序 5-公众号文章不能为空")
    @TableField("jump_type")
    private Integer jumpType;

    /**
     * 跳转内容，根据jump_type不同存储不同的内容
     */
    @ApiModelProperty(value = "跳转内容，根据jump_type不同存储不同的内容")
    @Length(max = 256, message = "跳转内容，根据jump_type不同存储不同的内容长度不能超过256")
    @TableField(value = "jump_content", condition = LIKE)
    private String jumpContent;

    /**
     * 触发条件 1-首页 2-支付完成页
     */
    @ApiModelProperty(value = "触发条件 1-首页 2-支付完成页")
    @NotNull(message = "触发条件 1-首页 2-支付完成页不能为空")
    @TableField("trigger_condition")
    private Integer triggerCondition;

    /**
     * 应用人群 1-所有人 2-会员
     */
    @ApiModelProperty(value = "应用人群 1-所有人 2-会员")
    @NotNull(message = "应用人群 1-所有人 2-会员不能为空")
    @TableField("apply_group")
    private Integer applyGroup;

    @NotNull(message = "状态不能为空")
    @ApiModelProperty(value = "状态 1-上架 0-下架")
    private Integer state;

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
