/*
 * Copyright (C) 2017-2021
 * All rights reserved, Designed By 深圳中科鑫智科技有限公司
 * Copyright authorization contact 18814114118
 */
package com.shop.cereshop.admin.dao.shop;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.shop.cereshop.admin.page.shop.Shop;
import com.shop.cereshop.admin.param.shopcheck.CheckGetAllParam;
import com.shop.cereshop.commons.domain.shop.CereShopCheck;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface CereShopCheckDAO extends BaseMapper<CereShopCheck> {

    int insertSelective(CereShopCheck record);

    List<Shop> getAll(CheckGetAllParam param);

    List<Shop> getStayAll(CheckGetAllParam param);
}
