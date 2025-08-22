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
 * 渠道表
 * </p>
 *
 * @since 2022-08-25
 */
@Data
@NoArgsConstructor
@ToString(callSuper = true)
@TableName("cere_channel")
@ApiModel(value = "Channel", description = "渠道表")
@AllArgsConstructor
public class Channel {

    private static final long serialVersionUID = 1L;

    /**
     * 渠道id
     */
    @ApiModelProperty(value = "渠道id")
    @NotNull(message = "渠道id不能为空")
    @TableId(value = "id", type = IdType.AUTO)
    private Long id;


    /**
     * 渠道名称
     */
    @ApiModelProperty(value = "渠道名称")
    @NotEmpty(message = "渠道名称不能为空")
    @Length(max = 32, message = "渠道名称长度不能超过32")
    @TableField(value = "channel_name", condition = LIKE)
    private String channelName;


    /**
     * 渠道注册链接
     */
    @ApiModelProperty(value = "渠道注册链接")
    @NotEmpty(message = "渠道注册链接不能为空")
    @Length(max = 1024, message = "渠道注册链接长度不能超过1024")
    @TableField(value = "register_url", condition = LIKE)
    private String registerUrl;


    /**
     * 渠道码
     */
    @ApiModelProperty(value = "渠道码")
    @NotEmpty(message = "渠道码不能为空")
    @Length(max = 64, message = "渠道码长度不能超过64")
    @TableField(value = "channel_code", condition = LIKE)
    private String channelCode;


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
