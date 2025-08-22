/*
 * Copyright (C) 2017-2021
 * All rights reserved, Designed By 深圳中科鑫智科技有限公司
 * Copyright authorization contact 18814114118
 */
package com.shop.cereshop.admin.dao.label;

import com.shop.cereshop.admin.param.buyer.BuyerSaveUserLabelParam;
import com.shop.cereshop.commons.domain.label.CereBuyerLabel;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface CereBuyerLabelDAO extends BaseMapper<CereBuyerLabel> {

    int insertSelective(CereBuyerLabel record);

    void deleteLabelUser(@Param("ids") List<Long> ids);

    void insertBatch(@Param("list") List<CereBuyerLabel> list);

    List<Long> findAlreadyByUser(BuyerSaveUserLabelParam param);

    List<Long> findByBuyerUserId(Long buyerUserId);
}
