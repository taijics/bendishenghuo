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
import org.hibernate.validator.constraints.Length;

import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.NotNull;
import java.util.Date;

import static com.baomidou.mybatisplus.annotation.SqlCondition.LIKE;

/**
 * <p>
 * 实体类
 * 积分流水表
 * </p>
 *
 * @author JustArgo
 * @since 2021-12-04
 */
@Data
@NoArgsConstructor
@ToString(callSuper = true)
@Accessors(chain = true)
@TableName("cere_credit_record")
@ApiModel(value = "CereCreditRecord", description = "积分流水表")
@AllArgsConstructor
public class CereCreditRecord {

    private static final long serialVersionUID = 1L;

    @TableId(type = IdType.AUTO)
    @ApiModelProperty(value = "id")
    private Long id;

    /**
     * 用户id
     */
    @ApiModelProperty(value = "用户id")
    @NotNull(message = "用户id不能为空")
    @TableField("buyer_user_id")
    private Long buyerUserId;

    /**
     * 流水类型 1-收入 2-支出
     */
    @ApiModelProperty(value = "流水类型 1-收入 2-支出")
    @NotNull(message = "流水类型 1-收入 2-支出不能为空")
    @TableField("record_type")
    private Integer recordType;

    /**
     * 操作类型 参考OptTypeEnum
     */
    @ApiModelProperty(value = "操作类型 参考OptTypeEnum")
    @NotNull(message = "操作类型 参考OptTypeEnum不能为空")
    @TableField("opt_type")
    private Integer optType;

    /**
     * 操作描述
     */
    @ApiModelProperty(value = "操作描述")
    @NotEmpty(message = "操作描述不能为空")
    @Length(max = 256, message = "操作描述长度不能超过256")
    @TableField(value = "record_content", condition = LIKE)
    private String recordContent;

    /**
     * 本次收入或支出积分
     */
    @ApiModelProperty(value = "本次收入或支出积分")
    @NotNull(message = "本次收入或支出积分不能为空")
    @TableField("credit")
    private Integer credit;

    /**
     * 剩余积分
     */
    @ApiModelProperty(value = "剩余积分")
    @NotNull(message = "剩余积分不能为空")
    @TableField("remain_credit")
    private Integer remainCredit;

    /**
     * 创建时间
     */
    @ApiModelProperty(value = "创建时间")
    private String createTime;

    /**
     * 修改时间
     */
    @ApiModelProperty(value = "修改时间")
    private String updateTime;

}
