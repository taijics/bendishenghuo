/*
 * Copyright (C) 2017-2021
 * All rights reserved, Designed By 深圳中科鑫智科技有限公司
 * Copyright authorization contact 18814114118
 */
package com.shop.cereshop.business.dao.shop;

import com.shop.cereshop.business.page.shop.ShopBanner;
import com.shop.cereshop.commons.domain.shop.CereShopBanner;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface CereShopBannerDAO extends BaseMapper<CereShopBanner> {
    int deleteByPrimaryKey(Long bannerId);

    int insertSelective(CereShopBanner record);

    CereShopBanner selectByPrimaryKey(Long bannerId);

    int updateByPrimaryKeySelective(CereShopBanner record);

    int updateByPrimaryKey(CereShopBanner record);

    ShopBanner getById(@Param("bannerId") Long bannerId);
}
