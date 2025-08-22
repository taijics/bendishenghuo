package com.shop.cereshop.admin.service.recommend;

import com.shop.cereshop.admin.page.recommend.CereRecommendTrendsDetail;
import com.shop.cereshop.admin.page.recommend.CereRecommendTrendsPage;
import com.shop.cereshop.admin.param.recommend.RecommendTrendPageParam;
import com.shop.cereshop.admin.param.recommend.RecommendTrendReviewParam;
import com.shop.cereshop.commons.domain.common.Page;

public interface CereRecommendTrendsService {

    Page<CereRecommendTrendsPage> trendsPage(RecommendTrendPageParam param);

    CereRecommendTrendsDetail getTrendsDetail(Long recommendId);

    int trendsReview(RecommendTrendReviewParam param);

    int deleteTrends(Long recommendId);

}
