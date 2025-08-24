/*
 * Copyright (C) 2017-2021
 * All rights reserved, Designed By 深圳中科鑫智科技有限公司
 * Copyright authorization contact 18814114118
 */
package com.shop.cereshop.app.page.shop;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
	
/**
 * 店铺商品数据
 */
@Data
@ApiModel(value = "ShopIndexVo", description = "商家")
public class ShopIndexVo {

	/**
	 * 店铺id
	 */
	@ApiModelProperty(value = "店铺id")
	private Long shopId;

	/**
	 * 店铺名称
	 */
	@ApiModelProperty(value = "店铺名称")
	private String shopName;

	/**
	 * 店铺log
	 */
	@ApiModelProperty(value = "店铺log")
	private String shopLogo;

	/**
	 * 已售件数
	 */
	@ApiModelProperty(value = "已售件数")
	private Integer number;
	/**
	 * 营业状态 1. 营业中，0.已打烊
	 */
	@ApiModelProperty(value = "营业状态")
	private Integer businessStatus;

	/**
	 * 积分分利比例
	 */
	@ApiModelProperty(value = "营业状态")
	private Double integrationRatio;
	/**
	 * 商家类别
	 */
	@ApiModelProperty(value = "商家类别")
	private String typeName;
	/**
	 * 商家地址
	 */
	@ApiModelProperty(value = "商家地址")
	private String address;
	/**
	 * 商家地址经纬度 json {}
	 */
	@ApiModelProperty(value = "商家地址经纬度")
	private String gis;

	/**
	 * 月销量
	 */
	@ApiModelProperty(value = "月销量")
	private Integer monthlySales;

	/**
	 * 距离(km)
	 */
	@ApiModelProperty(value = "距离")
	private Double distance;

	// Convenience getters for frontend compatibility
	public Integer getSoldCount() {
		return this.number;
	}

	public Integer getStatus() {
		return this.businessStatus;
	}

	public Double getIntegralRate() {
		return this.integrationRatio;
	}

	public String getCategoryName() {
		return this.typeName;
	}

}
