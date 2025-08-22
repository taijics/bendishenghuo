/*
 * Copyright (C) 2017-2021
 * All rights reserved, Designed By 深圳中科鑫智科技有限公司
 * Copyright authorization contact 18814114118
 */
package com.shop.cereshop.admin.dao.live;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.shop.cereshop.admin.page.live.LiveProductPage;
import com.shop.cereshop.admin.param.live.LiveGetAllParam;
import com.shop.cereshop.admin.param.live.LiveProductPageParam;
import com.shop.cereshop.commons.domain.live.CereLive;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface CereLiveDAO extends BaseMapper<CereLive> {

    List<CereLive> getAll(LiveGetAllParam param);

    int audit(CereLive live);

    CereLive getById(@Param("id")Long id);

    List<LiveProductPage> getLiveProductRelPageByLiveId(LiveProductPageParam param);

    List<CereLive> selectLiveList(String nowTime);
}
