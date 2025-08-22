/*
 * Copyright (C) 2017-2021
 * All rights reserved, Designed By 深圳中科鑫智科技有限公司
 * Copyright authorization contact 18814114118
 */
package com.shop.cereshop.business.dao.buyer;

import com.shop.cereshop.commons.domain.buyer.CereBuyerShopCoupon;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface CereBuyerShopCouponDAO extends BaseMapper<CereBuyerShopCoupon> {
    int deleteByPrimaryKey(Long id);

    int insertSelective(CereBuyerShopCoupon record);

    CereBuyerShopCoupon selectByPrimaryKey(Long id);

    int updateByPrimaryKeySelective(CereBuyerShopCoupon record);

    int updateByPrimaryKey(CereBuyerShopCoupon record);

    void insertBatch(@Param("list") List<CereBuyerShopCoupon> list);

    void updateState(CereBuyerShopCoupon cereBuyerShopCoupon);
}
