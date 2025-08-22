/*
* Copyright (C) 2017-2021
* All rights reserved, Designed By 深圳中科鑫智科技有限公司
* Copyright authorization contact 18814114118
*/
package com.shop.cereshop.commons.domain.customer_service;

import com.baomidou.mybatisplus.annotation.TableField;
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
import java.util.List;

import static com.baomidou.mybatisplus.annotation.SqlCondition.LIKE;

/**
 * <p>
 * 实体类
 * 客服接待员表
 * </p>
 *
 * @author JustArgo
 * @since 2021-12-08
 */
@Data
@NoArgsConstructor
@ToString(callSuper = true)
@Accessors(chain = true)
@TableName("cere_customer_service_receptionist")
@ApiModel(value = "CereCustomerServiceReceptionist", description = "客服接待员表")
@AllArgsConstructor
public class CereCustomerServiceReceptionist {

    private static final long serialVersionUID = 1L;

    /*@ApiModelProperty("主键id")
    @TableId(type = IdType.AUTO)
    private Long id;*/

    /*@ApiModelProperty("客服id")
    private String kfId;*/

    @ApiModelProperty("开放客服id,调用接口专用")
    private String openKfId;

    @ApiModelProperty("外部userId列表")
    private List<String> userIdList;

    /**
     * 客服id
     */
    /*@ApiModelProperty(value = "客服id")
    @NotNull(message = "客服id不能为空")
    @TableField("service_id")
    private Long serviceId;*/

    /**
     * 接待员名称
     */
    @ApiModelProperty(value = "接待员名称")
    @NotEmpty(message = "接待员名称不能为空")
    @Length(max = 128, message = "接待员名称长度不能超过128")
    @TableField(value = "name", condition = LIKE)
    private String name;

    /**
     * 状态 1-接线中 0-空闲
     */
    @ApiModelProperty(value = "状态 1-接线中 0-空闲")
    @NotNull(message = "状态 1-接线中 0-空闲不能为空")
    @TableField("state")
    private Integer state;

    /*
    @ApiModelProperty(value = "创建时间")
    @TableField("create_time")
    private String createTime;

    @ApiModelProperty(value = "修改时间")
    @TableField("update_time")
    private String updateTime;
    */

}
