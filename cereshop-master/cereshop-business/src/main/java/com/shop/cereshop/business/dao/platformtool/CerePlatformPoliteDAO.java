/*
 * Copyright (C) 2017-2021
 * All rights reserved, Designed By 深圳中科鑫智科技有限公司
 * Copyright authorization contact 18814114118
 */
package com.shop.cereshop.business.dao.platformtool;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.shop.cereshop.commons.domain.platformtool.CerePlatformPolite;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface CerePlatformPoliteDAO extends BaseMapper<CerePlatformPolite> {
    int deleteByPrimaryKey(Long politeId);

    int insertSelective(CerePlatformPolite record);

    CerePlatformPolite selectByPrimaryKey(Long politeId);

    int updateByPrimaryKeySelective(CerePlatformPolite record);

    int updateByPrimaryKey(CerePlatformPolite record);

    List<CerePlatformPolite> findPlatformPolite();

    void updatePoliteEndState(@Param("list") List<CerePlatformPolite> list,@Param("time") String time);
}
