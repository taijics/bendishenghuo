/*
 * Copyright (C) 2017-2021
 * All rights reserved, Designed By 深圳中科鑫智科技有限公司
 * Copyright authorization contact 18814114118
 */
package com.shop.cereshop.admin.dao.recommend;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.shop.cereshop.admin.page.recommend.CereRecommendTrendsDetail;
import com.shop.cereshop.admin.page.recommend.CereRecommendTrendsPage;
import com.shop.cereshop.admin.param.recommend.RecommendTrendPageParam;
import com.shop.cereshop.commons.domain.recommend.CereRecommendTrends;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface CereRecommendTrendsDAO extends BaseMapper<CereRecommendTrends> {

    List<CereRecommendTrendsPage> trendsPage(RecommendTrendPageParam param);

    CereRecommendTrendsDetail getTrendsDetail(@Param("recommendId") Long recommendId);

    int updateTrends(CereRecommendTrends trends);

    int deleteTrends(@Param("recommendId") Long recommendId);

}
