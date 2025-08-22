/*
 * Copyright (C) 2017-2021
 * All rights reserved, Designed By 深圳中科鑫智科技有限公司
 * Copyright authorization contact 18814114118
 */
package com.shop.cereshop.admin.dao.shop;

import com.shop.cereshop.admin.page.finance.Finance;
import com.shop.cereshop.admin.page.shop.Shop;
import com.shop.cereshop.admin.page.shop.ShopGetAll;
import com.shop.cereshop.admin.param.finance.FinanceParam;
import com.shop.cereshop.admin.param.shop.ShopGetAllParam;
import com.shop.cereshop.commons.domain.business.CerePlatformBusiness;
import com.shop.cereshop.commons.domain.shop.CerePlatformShop;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.math.BigDecimal;
import java.util.List;

@Mapper
public interface CerePlatformShopDAO extends BaseMapper<CerePlatformShop> {

    CerePlatformShop findByShopName(@Param("shopName") String shopName);

    CerePlatformShop findByPhone(@Param("shopPhone") String shopPhone);

    CerePlatformShop checkShopIdByName(@Param("shopName") String shopName,@Param("shopId") Long shopId);

    CerePlatformShop checkShopIdByPhone(@Param("shopPhone") String shopPhone,@Param("shopId") Long shopId);

    CerePlatformBusiness findBusinessByShopId(@Param("shopId") Long shopId);

    ShopGetAll getById(@Param("shopId") Long shopId);

    List<ShopGetAll> getAll(ShopGetAllParam param);

    Shop findShop(@Param("shopId") Long shopId);

    void updateDate(CerePlatformShop cerePlatformShop);

    List<Finance> getAllFinance(FinanceParam param);

    BigDecimal finFrozen(@Param("shopId") Long shopId);

    BigDecimal findHaveWithdrawal(@Param("shopId") Long shopId);

    BigDecimal findRefund(@Param("shopId") Long shopId);

    BigDecimal findRevenue();

    BigDecimal getAllWithdrawableMoney();

    BigDecimal getWithdrawableStayMoney();

    Long findBusinessId(@Param("shopId") Long shopId);

    CerePlatformBusiness findBusiness(@Param("businessUserId") Long businessUserId);

    List<CerePlatformShop> findAll();

    void updateShopStop(CerePlatformShop shop);

    /** 查询商家提现中的金额 */
    BigDecimal findWithdrawing(Long shopId);

    Boolean cleanShop(Long shopId);
}
