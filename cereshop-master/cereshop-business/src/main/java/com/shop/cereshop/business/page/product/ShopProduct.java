/*
 * Copyright (C) 2017-2021
 * All rights reserved, Designed By 深圳中科鑫智科技有限公司
 * Copyright authorization contact 18814114118
 */
package com.shop.cereshop.business.page.product;

import com.shop.cereshop.business.param.product.SkuNameParam;
import com.shop.cereshop.commons.domain.image.Image;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

import java.math.BigDecimal;
import java.util.List;

/**
 * 商品返回数据实体类
 */
@Data
@ApiModel(value = "ShopProduct", description = "商品返回数据实体类")
public class ShopProduct {

    /**
     * 商品id
     */
    @ApiModelProperty(value = "商品id")
    private Long productId;

    /**
     * 关联店铺id
     */
    @ApiModelProperty(value = "关联店铺id")
    private Long shopId;

    /**
     * 商品名称
     */
    @ApiModelProperty(value = "商品名称")
    private String productName;

    /**
     * 卖点简介
     */
    @ApiModelProperty(value = "卖点简介")
    private String productBrief;

    /**
     * 关联商品分组id
     */
    @ApiModelProperty(value = "关联商品分组id")
    private Long shopGroupId;

    /**
     * 关联分类id
     */
    @ApiModelProperty(value = "关联分类id")
    private Long classifyId;

    /**
     * 关联供应商id
     */
    @ApiModelProperty(value = "关联供应商id")
    private Long supplierId;

    /**
     * 供应商名称
     */
    @ApiModelProperty(value = "供应商名称")
    private String supplierName;

    /**
     * 是否需要物流 1-是 0-否
     */
    @ApiModelProperty(value = "是否需要物流 1-是 0-否")
    private Integer ifLogistics;

    /**
     * 商品状态 0-已下架 1-已上架 2-待审核 3-审核失败
     */
    @ApiModelProperty(value = "商品状态 0-已下架 1-已上架 2-待审核 3-审核失败")
    private Integer shelveState;

    /**
     * 是否允许超卖 1-是 0-否
     */
    @ApiModelProperty(value = "是否允许超卖 1-是 0-否")
    private Integer ifOversold;

    /**
     * 是否支持花呗分期 1-是 0-否
     */
    @ApiModelProperty(value = "是否支持花呗分期 1-是 0-否")
    private Integer ifHuabei;

    /**
     * 商品描述（富文本）
     */
    @ApiModelProperty(value = "商品描述（富文本）")
    private String productText;

    /**
     * 商品图片数组
     */
    @ApiModelProperty(value = "商品图片数组")
    private List<Image> images;

    /**
     * 规格数据
     */
    @ApiModelProperty(value = "规格数据")
    private List<Sku> skus;

    /**
     * 商品图片第一张
     */
    @ApiModelProperty(value = "商品图片第一张")
    private String productImage;

    /**
     * 规格图片第一张
     */
    @ApiModelProperty(value = "规格图片第一张")
    private String skuImage;

    /**
     * 售价区间
     */
    @ApiModelProperty(value = "售价区间")
    private String section;

    /**
     * 会员价区间
     */
    @ApiModelProperty(value = "会员价区间")
    private String memberSection;

    /**
     * 售价
     */
    @ApiModelProperty(value = "售价")
    private BigDecimal price;

    /**
     * 原价
     */
    @ApiModelProperty(value = "原价")
    private BigDecimal originalPrice;

    /**
     * 库存
     */
    @ApiModelProperty(value = "库存")
    private Integer stockNumber;

    /**
     * 销量
     */
    @ApiModelProperty(value = "销量")
    private Integer volume;

    /**
     * 创建时间
     */
    @ApiModelProperty(value = "创建时间")
    private String createTime;

    /**
     * 规格名和值数据
     */
    @ApiModelProperty(value = "规格名和值数据")
    private List<SkuNameParam> names;

    @ApiModelProperty("是否支持积分抵扣")
    private Integer ifCredit;

    @ApiModelProperty("单笔订单最多抵扣多少积分")
    private Integer creditLimit;

    @ApiModelProperty("sku最高价格")
    private BigDecimal maxPrice;

    @ApiModelProperty("驳回原因")
    private String reject;

    @ApiModelProperty("品牌id")
    private Long brandId;

    @ApiModelProperty("一级分类id")
    private Long classifyId1;

    @ApiModelProperty("二级分类id")
    private Long classifyId2;

    @ApiModelProperty("三级分类id")
    private Long classifyId3;
}
