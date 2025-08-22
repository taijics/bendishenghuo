/*
 * Copyright (C) 2017-2021
 * All rights reserved, Designed By 深圳中科鑫智科技有限公司
 * Copyright authorization contact 18814114118
 */
package com.shop.cereshop.commons.domain.credit;

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
import java.util.Date;

/**
 * <p>
 * 实体类
 * 积分签到配置
 * </p>
 *
 * @author JustArgo
 * @since 2021-12-04
 */
@Data
@NoArgsConstructor
@ToString(callSuper = true)
@Accessors(chain = true)
@TableName("cere_credit_sign_setting")
@ApiModel(value = "CereCreditSignSetting", description = "积分签到配置")
@AllArgsConstructor
public class CereCreditSignSetting {

    private static final long serialVersionUID = 1L;

    @TableId(type = IdType.AUTO)
    private Long id;

    /**
     * 第几天
     */
    @ApiModelProperty(value = "第几天")
    @NotNull(message = "第几天不能为空")
    @TableField("day")
    private Integer day;

    /**
     * 赠送积分值
     */
    @ApiModelProperty(value = "赠送积分值")
    @NotNull(message = "赠送积分值不能为空")
    @TableField("credit")
    private Integer credit;

    /**
     * 是否显示 1-是 0-否
     */
    @ApiModelProperty(value = "是否显示 1-是 0-否")
    @NotNull(message = "是否显示 1-是 0-否不能为空")
    @TableField("display")
    private Integer display;

    /**
     * 排序
     */
    @ApiModelProperty(value = "排序")
    @NotNull(message = "排序不能为空")
    @TableField("sort")
    private Integer sort;

    /**
     * 创建时间
     */
    @ApiModelProperty(value = "创建时间")
    private Date createTime;

    /**
     * 修改时间
     */
    @ApiModelProperty(value = "修改时间")
    private Date updateTime;
}
