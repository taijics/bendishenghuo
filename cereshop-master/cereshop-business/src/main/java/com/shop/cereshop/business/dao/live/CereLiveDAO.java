/*
 * Copyright (C) 2017-2021
 * All rights reserved, Designed By 深圳中科鑫智科技有限公司
 * Copyright authorization contact 18814114118
 */
package com.shop.cereshop.business.dao.live;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.shop.cereshop.business.page.live.LiveProductPage;
import com.shop.cereshop.business.param.live.LiveGetAllParam;
import com.shop.cereshop.business.param.live.LiveProductPageParam;
import com.shop.cereshop.commons.domain.live.CereLive;
import com.shop.cereshop.commons.domain.live.CereLiveProduct;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface CereLiveDAO extends BaseMapper<CereLive> {

    List<CereLive> getAll(LiveGetAllParam param);

    int deleteByIdAndShopId(@Param("id")Long id, @Param("shopId")Long shopId);

    CereLive getByIdAndShopId(@Param("id")Long id, @Param("shopId")Long shopId);

    List<LiveProductPage> getLiveProductRelPageByLiveId(LiveProductPageParam param);
}
