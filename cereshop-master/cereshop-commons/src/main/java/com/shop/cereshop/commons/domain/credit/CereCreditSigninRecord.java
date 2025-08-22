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
 * 积分签到表
 * </p>
 *
 * @author JustArgo
 * @since 2021-12-04
 */
@Data
@NoArgsConstructor
@ToString(callSuper = true)
@Accessors(chain = true)
@TableName("cere_credit_signin_record")
@ApiModel(value = "CereCreditSigninRecord", description = "积分签到表")
@AllArgsConstructor
public class CereCreditSigninRecord {

    private static final long serialVersionUID = 1L;

    @ApiModelProperty("主键id")
    @TableId(type = IdType.AUTO)
    private Long id;

    /**
     * 客户id
     */
    @ApiModelProperty(value = "客户id")
    @NotNull(message = "客户id不能为空")
    @TableField("buyer_user_id")
    private Long buyerUserId;

    /**
     * 轮询id,第一天签到则为1，第2天签到则为2，连续签到值越来越大
     */
    @ApiModelProperty(value = "轮询id,第一天签到则为1，第2天签到则为2，连续签到值越来越大")
    @NotNull(message = "轮询id,第一天签到则为1，第2天签到则为2，连续签到值越来越大不能为空")
    @TableField("term_id")
    private Integer termId;

    /**
     * 连续第几天签到
     */
    @ApiModelProperty(value = "连续第几天签到")
    @NotNull(message = "连续第几天签到")
    @TableField("continue_day")
    private Integer continueDay;

    /**
     * 奖励的积分
     */
    @ApiModelProperty(value = "奖励的积分")
    @NotNull(message = "奖励的积分不能为空")
    @TableField("credit")
    private Integer credit;

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
