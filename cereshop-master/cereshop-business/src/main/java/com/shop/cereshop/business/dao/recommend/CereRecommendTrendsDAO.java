/*
 * Copyright (C) 2017-2021
 * All rights reserved, Designed By 深圳中科鑫智科技有限公司
 * Copyright authorization contact 18814114118
 */
package com.shop.cereshop.business.dao.recommend;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.shop.cereshop.business.page.recommend.CereRecommendTrendsDetail;
import com.shop.cereshop.business.page.recommend.CereRecommendTrendsPage;
import com.shop.cereshop.business.param.recommend.RecommendTrendPageParam;
import com.shop.cereshop.commons.domain.recommend.CereRecommendTrends;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface CereRecommendTrendsDAO extends BaseMapper<CereRecommendTrends> {

    void saveTrends(CereRecommendTrends trends);

    List<CereRecommendTrendsPage> trendsPage(RecommendTrendPageParam param);

    CereRecommendTrendsDetail getTrendsDetail(@Param("recommendId") Long recommendId);

    Long updateTrends(CereRecommendTrends trends);

    int deleteTrends(@Param("recommendId") Long recommendId);

    void addCommentCount(@Param("recommendId") Long recommendId);

    void subCommentCount(@Param("recommendId") Long recommendId, @Param("count") Integer count);

    void audit(CereRecommendTrends trends);

    CereRecommendTrends getTrendById(@Param("recommendId") Long recommendId);
}
