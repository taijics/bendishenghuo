/*
 * Copyright (C) 2017-2021
 * All rights reserved, Designed By 深圳中科鑫智科技有限公司
 * Copyright authorization contact 18814114118
 */
package com.shop.cereshop.app.param.shop;

import com.shop.cereshop.commons.domain.common.PageParam;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

/**
 * 商品搜索请求
 */
@Data
@ApiModel(value = "ShopIndexParam", description = "首页商家列表")
public class ShopIndexParam extends PageParam {

	/**
	 * 1. 根据距离排序
	 * 2. 根据字段sort顺序排序
	 * 3. 根据销量排序
	 * 4. 根据好评倒序排序
	 */
	@ApiModelProperty(value = "搜索类别")
	private Integer type;

}
