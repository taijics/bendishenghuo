/*
* Copyright (C) 2017-2021
* All rights reserved, Designed By 深圳中科鑫智科技有限公司
* Copyright authorization contact 18814114118
*/
package com.shop.cereshop.commons.domain.risk;

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

import static com.baomidou.mybatisplus.annotation.SqlCondition.LIKE;

/**
 * <p>
 * 实体类
 * 黑名单表
 * </p>
 *
 * @author JustArgo
 * @since 2021-12-06
 */
@Data
@NoArgsConstructor
@ToString(callSuper = true)
@Accessors(chain = true)
@TableName("cere_risk_black")
@ApiModel(value = "CereRiskBlack", description = "黑名单表")
@AllArgsConstructor
public class CereRiskBlack {

    private static final long serialVersionUID = 1L;

    @ApiModelProperty("主键id")
    @TableId(type = IdType.AUTO)
    private Long id;

    /**
     * 类型 1：ip  2:用户
     */
    @ApiModelProperty(value = "类型 1：ip  2:用户")
    @NotNull(message = "类型 1：ip  2:用户不能为空")
    @TableField("type")
    private Integer type;

    /**
     * ip地址
     */
    @ApiModelProperty(value = "ip地址")
    @Length(max = 100, message = "ip地址长度不能超过100")
    @TableField(value = "ip", condition = LIKE)
    private String ip;

    /**
     * 用户id
     */
    @ApiModelProperty(value = "用户id")
    @TableField("buyer_user_id")
    private Long buyerUserId;

    /**
     * 是否有效，0否 1是
     */
    @ApiModelProperty(value = "是否有效，0否 1是")
    @TableField("state")
    private Boolean state;

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
