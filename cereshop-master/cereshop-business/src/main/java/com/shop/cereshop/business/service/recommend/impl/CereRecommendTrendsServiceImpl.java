package com.shop.cereshop.business.service.recommend.impl;

import cn.hutool.core.collection.CollectionUtil;
import cn.hutool.core.util.ObjectUtil;
import com.github.houbb.sensitive.word.core.SensitiveWordHelper;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.shop.cereshop.business.dao.recommend.CereRecommendRelationDAO;
import com.shop.cereshop.business.dao.recommend.CereRecommendTrendsDAO;
import com.shop.cereshop.business.page.recommend.CereRecommendTrendsDetail;
import com.shop.cereshop.business.page.recommend.CereRecommendTrendsPage;
import com.shop.cereshop.business.param.recommend.RecommendTrendPageParam;
import com.shop.cereshop.business.param.recommend.RecommendTrendsSaveParam;
import com.shop.cereshop.business.param.recommend.RecommendTrendsUpdateParam;
import com.shop.cereshop.business.redis.service.api.StringRedisService;
import com.shop.cereshop.business.service.recommend.CereRecommendTrendsService;
import com.shop.cereshop.commons.constant.RedisConstants;
import com.shop.cereshop.commons.domain.common.Page;
import com.shop.cereshop.commons.domain.recommend.CereRecommendRelation;
import com.shop.cereshop.commons.domain.recommend.CereRecommendTrends;
import com.shop.cereshop.commons.exception.CoBusinessException;
import com.shop.cereshop.commons.utils.TimeUtils;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;


@Service
public class CereRecommendTrendsServiceImpl implements CereRecommendTrendsService {

    @Autowired
    private CereRecommendTrendsDAO cereRecommendTrendsDAO;

    @Autowired
    private CereRecommendRelationDAO cereRecommendRelationDAO;

    @Autowired
    private StringRedisService stringRedisService;

    @Override
    @Transactional(isolation = Isolation.DEFAULT, propagation = Propagation.REQUIRED, rollbackFor = {CoBusinessException.class, Exception.class})
    public Long saveTrends(RecommendTrendsSaveParam param) {
        CereRecommendTrends trends = new CereRecommendTrends();
        BeanUtils.copyProperties(param, trends);
        trends.setProductCount(CollectionUtil.isNotEmpty(param.getProductIds()) ? param.getProductIds().size() : 0);
        cereRecommendTrendsDAO.saveTrends(trends);
        Long recommendId = trends.getRecommendId();
        // 自动审核
        autoAudit(recommendId, param.getRemark());
        if (CollectionUtil.isNotEmpty(param.getProductIds())) {
            List<CereRecommendRelation> recommendRelationList = new ArrayList<>();
            for (Long productId : param.getProductIds()) {
                CereRecommendRelation recommendRelation = new CereRecommendRelation();
                recommendRelation.setRecommendId(recommendId);
                recommendRelation.setProductId(productId);
                recommendRelationList.add(recommendRelation);
            }
            cereRecommendRelationDAO.batchInsertRelation(recommendRelationList);
        }
        return recommendId;
    }

    @Override
    @Transactional(isolation = Isolation.DEFAULT, propagation = Propagation.REQUIRED, rollbackFor = {CoBusinessException.class, Exception.class})
    public void updateTrends(RecommendTrendsUpdateParam param) {
        CereRecommendTrends trends = new CereRecommendTrends();
        BeanUtils.copyProperties(param, trends);
        trends.setProductCount(CollectionUtil.isNotEmpty(param.getProductIds()) ? param.getProductIds().size() : 0);
        cereRecommendTrendsDAO.updateTrends(trends);
        // 自动审核
        autoAudit(param.getRecommendId(), param.getRemark());
        cereRecommendRelationDAO.deleteRelation(param.getRecommendId());
        if (CollectionUtil.isNotEmpty(param.getProductIds())) {
            trends.setProductCount(param.getProductIds().size());
            List<CereRecommendRelation> recommendRelationList = new ArrayList<>();
            for (Long productId : param.getProductIds()) {
                CereRecommendRelation recommendRelation = new CereRecommendRelation();
                recommendRelation.setRecommendId(param.getRecommendId());
                recommendRelation.setProductId(productId);
                recommendRelationList.add(recommendRelation);
            }
            cereRecommendRelationDAO.batchInsertRelation(recommendRelationList);
        }

    }

    private void autoAudit(Long recommendId, String remark) {
        // 自动审核
        if (Boolean.TRUE.equals(stringRedisService.get(RedisConstants.RISK_CONTROL))) {
            CereRecommendTrends updateTrends = new CereRecommendTrends();
            updateTrends.setRecommendId(recommendId);
            // 判断是否包含敏感词
            if (!SensitiveWordHelper.contains(remark)) {
                updateTrends.setPublishStatus(1);
                updateTrends.setPublishTime(TimeUtils.yyMMddHHmmss());
            } else {
                updateTrends.setPublishStatus(2);
                List<String> wordList = SensitiveWordHelper.findAll(remark);
                updateTrends.setReviewContent("文案包含敏感词汇：" + wordList.stream().map(element -> "[" + element + "]")
                        .collect(Collectors.joining(", ")));
            }
            cereRecommendTrendsDAO.audit(updateTrends);
        }
    }

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
    public int deleteTrends(Long recommendId) {
        return cereRecommendTrendsDAO.deleteTrends(recommendId);
    }
}
