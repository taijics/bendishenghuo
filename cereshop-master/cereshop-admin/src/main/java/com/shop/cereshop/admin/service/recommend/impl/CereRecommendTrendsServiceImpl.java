package com.shop.cereshop.admin.service.recommend.impl;

import cn.hutool.core.util.ObjectUtil;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.shop.cereshop.admin.dao.recommend.CereRecommendRelationDAO;
import com.shop.cereshop.admin.dao.recommend.CereRecommendTrendsDAO;
import com.shop.cereshop.admin.page.recommend.CereRecommendTrendsDetail;
import com.shop.cereshop.admin.page.recommend.CereRecommendTrendsPage;
import com.shop.cereshop.admin.param.recommend.RecommendTrendPageParam;
import com.shop.cereshop.admin.param.recommend.RecommendTrendReviewParam;
import com.shop.cereshop.admin.service.recommend.CereRecommendTrendsService;
import com.shop.cereshop.commons.domain.common.Page;
import com.shop.cereshop.commons.domain.recommend.CereRecommendTrends;
import com.shop.cereshop.commons.enums.ReviewEnum;
import com.shop.cereshop.commons.utils.TimeUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;


@Service
public class CereRecommendTrendsServiceImpl implements CereRecommendTrendsService {

    @Autowired
    private CereRecommendTrendsDAO cereRecommendTrendsDAO;

    @Autowired
    private CereRecommendRelationDAO cereRecommendRelationDAO;

    @Override
    public Page<CereRecommendTrendsPage> trendsPage(RecommendTrendPageParam param) {
        PageHelper.startPage(param.getPage(), param.getPageSize());
        PageInfo<CereRecommendTrendsPage> pageInfo = new PageInfo<>(cereRecommendTrendsDAO.trendsPage(param));
        Page page = new Page(pageInfo.getList(), pageInfo.getTotal());
        return page;
    }

    @Override
    public CereRecommendTrendsDetail getTrendsDetail(Long recommendId) {
        CereRecommendTrendsDetail detail = cereRecommendTrendsDAO.getTrendsDetail(recommendId);
        if (ObjectUtil.isNotNull(detail))
            detail.setProducts(cereRecommendRelationDAO.getRecommendProducts(recommendId));
        return detail;
    }

    @Override
    public int trendsReview(RecommendTrendReviewParam param) {
        CereRecommendTrends trends = new CereRecommendTrends();
        trends.setRecommendId(param.getRecommendId());
        trends.setPublishStatus(param.getReviewStatus());
        if (ReviewEnum.FAIL.getCode().equals(param.getReviewStatus())) {
            trends.setReviewContent(param.getReviewContent());
        } else {
            trends.setPublishTime(TimeUtils.yyMMddHHmmss());
        }
        return cereRecommendTrendsDAO.updateTrends(trends);
    }

    @Override
    public int deleteTrends(Long recommendId) {
        return cereRecommendTrendsDAO.deleteTrends(recommendId);
    }
}
