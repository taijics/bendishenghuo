/*
 * Copyright (C) 2017-2021
 * All rights reserved, Designed By 深圳中科鑫智科技有限公司
 * Copyright authorization contact 18814114118
 */
package com.shop.cereshop.admin.dao.recommend;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.shop.cereshop.admin.page.recommend.CereRecommendTypePage;
import com.shop.cereshop.admin.param.recommend.RecommendTypePageParam;
import com.shop.cereshop.admin.param.recommend.RecommendTypeUpdateParam;
import com.shop.cereshop.commons.domain.recommend.CereRecommendType;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;


@Mapper
public interface CereRecommendTypeDAO extends BaseMapper<CereRecommendType> {

    int insertRecommendType(CereRecommendType type);

    int updateRecommendType(RecommendTypeUpdateParam param);

    CereRecommendType checkName(CereRecommendType type);

    CereRecommendTypePage getRecommendTypeById(@Param("recommendTypeId") Long recommendTypeId);

    List<CereRecommendTypePage> recommendTypePage(RecommendTypePageParam param);

    int deleteRecommendType(@Param("recommendTypeId") Long recommendTypeId);
}
