/*
 * Copyright (C) 2017-2021
 * All rights reserved, Designed By 深圳中科鑫智科技有限公司
 * Copyright authorization contact 18814114118
 */
package com.shop.cereshop.commons.domain.live;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

import java.math.BigDecimal;

@Data
@ApiModel("直播间商品对象")
public class CereLiveProduct {

    @ApiModelProperty("主键id")
    @TableId(type = IdType.AUTO)
    private Long id;

    @ApiModelProperty("店铺id")
    private Long shopId;

    @ApiModelProperty("商品id")
    private Long productId;

    @ApiModelProperty("微信直播商品Id")
    private Integer goodsId;

    @ApiModelProperty("商品名称")
    private String productName;

    @ApiModelProperty("商品封面图")
    private String productImage;

    /**
     * 商品封面图媒体id
     */
    @ApiModelProperty(value = "商品封面图媒体id")
    @TableField(value = "product_image_media_id")
    private String productImageMediaId;

    @ApiModelProperty("价格类型 1- 一口价 2-价格区间 3-折扣价")
    private Integer priceType;

    @ApiModelProperty("一口价 当priceType = 1时有值")
    private BigDecimal fixedPrice;

    @ApiModelProperty("市场价当priceType = 3时有值")
    private BigDecimal marketPrice;

    @ApiModelProperty("现价")
    private BigDecimal originalPrice;

    @ApiModelProperty("价格区间最低值 当priceType = 2时有值")
    private BigDecimal minPrice;

    @ApiModelProperty("价格区间最高值 当priceType = 2时有值")
    private BigDecimal maxPrice;

    @ApiModelProperty("商品库存")
    private Integer stockNumber;

    @ApiModelProperty("商品初始库存")
    private Integer total;

    @ApiModelProperty("状态 0-待审核 1-审核通过 2-审核不通过")
    private Integer state;

    @ApiModelProperty("备注")
    private String remark;

    @ApiModelProperty("创建时间")
    private String createTime;

    @ApiModelProperty("修改时间")
    private String updateTime;

    @ApiModelProperty("微信审核状态 0：未审核，1：审核中，2:审核通过，3审核失败")
    @TableField(exist = false)
    private Integer wxAuditStatus;

}
