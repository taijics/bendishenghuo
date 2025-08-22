/*
 * Copyright (C) 2017-2021
 * All rights reserved, Designed By 深圳中科鑫智科技有限公司
 * Copyright authorization contact 18814114118
 */
package com.shop.cereshop.business.dao.shop;

import com.shop.cereshop.business.page.shop.ShopBankDetail;
import com.shop.cereshop.commons.domain.shop.CerePlatformShop;
import com.shop.cereshop.commons.domain.shop.CereShopBank;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface CereShopBankDAO extends BaseMapper<CereShopBank> {

    int insertSelective(CereShopBank record);

    void updateData(CereShopBank bank);

    void deleteData(CereShopBank bank);

    ShopBankDetail getById(@Param("shopId") Long shopId);

    CerePlatformShop findByPhone(@Param("shopId") Long shopId, @Param("phone") String phone);
}
