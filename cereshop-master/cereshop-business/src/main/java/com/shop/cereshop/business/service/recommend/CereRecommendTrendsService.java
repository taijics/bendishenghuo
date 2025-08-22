package com.shop.cereshop.business.service.recommend;

import com.shop.cereshop.business.page.recommend.CereRecommendTrendsDetail;
import com.shop.cereshop.business.page.recommend.CereRecommendTrendsPage;
import com.shop.cereshop.business.param.recommend.RecommendTrendPageParam;
import com.shop.cereshop.business.param.recommend.RecommendTrendsSaveParam;
import com.shop.cereshop.business.param.recommend.RecommendTrendsUpdateParam;
import com.shop.cereshop.commons.domain.common.Page;

public interface CereRecommendTrendsService {

    Long saveTrends(RecommendTrendsSaveParam param);

    void updateTrends(RecommendTrendsUpdateParam param);

    Page<CereRecommendTrendsPage> trendsPage(RecommendTrendPageParam param);

    CereRecommendTrendsDetail getTrendsDetail(Long recommendId);

    int deleteTrends(Long recommendId);

}
