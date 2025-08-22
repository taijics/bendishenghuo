/*
 * Copyright (C) 2017-2021
 * All rights reserved, Designed By 深圳中科鑫智科技有限公司
 * Copyright authorization contact 18814114118
 */
package com.shop.cereshop.admin.dao.buyer;

import com.shop.cereshop.admin.page.buyer.BuyerWithdrawal;
import com.shop.cereshop.admin.param.withdrawal.BuyerWithdrawalGetAllParam;
import com.shop.cereshop.commons.domain.buyer.CereBuyerWithdrawal;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface CereBuyerWithdrawalDAO extends BaseMapper<CereBuyerWithdrawal> {
    int deleteByPrimaryKey(Long withdrawalId);

    int insertSelective(CereBuyerWithdrawal record);

    CereBuyerWithdrawal selectByPrimaryKey(Long withdrawalId);

    int updateByPrimaryKeySelective(CereBuyerWithdrawal record);

    int updateByPrimaryKey(CereBuyerWithdrawal record);

    List<BuyerWithdrawal> getAll(BuyerWithdrawalGetAllParam param);

    BuyerWithdrawal getById(@Param("withdrawalId") Long withdrawalId);
}
