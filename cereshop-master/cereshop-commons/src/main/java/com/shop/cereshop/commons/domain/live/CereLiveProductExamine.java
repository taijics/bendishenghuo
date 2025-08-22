/*
* Copyright (C) 2017-2021
* All rights reserved, Designed By 深圳中科鑫智科技有限公司
* Copyright authorization contact 18814114118
*/
package com.shop.cereshop.commons.domain.live;

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
import java.time.LocalDate;

/**
 * <p>
 * 实体类
 * 直播间商品重新审核表
 * </p>
 *
 * @author JustArgo
 * @since 2021-12-11
 */
@Data
@NoArgsConstructor
@ToString(callSuper = true)
@Accessors(chain = true)
@TableName("cere_live_product_examine")
@ApiModel(value = "CereLiveProductExamine", description = "直播间商品重新审核表")
@AllArgsConstructor
public class CereLiveProductExamine {

    private static final long serialVersionUID = 1L;

    @ApiModelProperty("主键id")
    @TableId(type = IdType.AUTO)
    private Long id;

    /**
     * 直播商品id
     */
    @ApiModelProperty(value = "直播商品id")
    @NotNull(message = "直播商品id不能为空")
    @TableField("live_product_id")
    private Long liveProductId;

    /**
     * 重新审核日期
     */
    @ApiModelProperty(value = "重新审核日期")
    @NotNull(message = "重新审核日期不能为空")
    @TableField("re_examine_date")
    private LocalDate reExamineDate;

    @ApiModelProperty("创建时间")
    private String createTime;

    @ApiModelProperty("修改时间")
    private String updateTime;

}
