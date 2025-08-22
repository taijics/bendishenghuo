package com.shop.cereshop.business.service.recommend.impl;

import cn.hutool.core.util.ObjectUtil;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.shop.cereshop.business.dao.recommend.CereRecommendCommentDAO;
import com.shop.cereshop.business.dao.recommend.CereRecommendTrendsDAO;
import com.shop.cereshop.business.page.recommend.CereRecommendCommentPage;
import com.shop.cereshop.business.param.recommend.RecommendCommentPageParam;
import com.shop.cereshop.business.param.recommend.RecommendCommentReplyParam;
import com.shop.cereshop.business.service.recommend.CereRecommendCommentService;
import com.shop.cereshop.commons.domain.common.Page;
import com.shop.cereshop.commons.domain.recommend.CereRecommendComment;
import com.shop.cereshop.commons.domain.recommend.CereRecommendTrends;
import com.shop.cereshop.commons.exception.CoBusinessException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

@Service
public class CereRecommendCommentServiceImpl implements CereRecommendCommentService {

    @Autowired
    private CereRecommendCommentDAO cereRecommendCommentDAO;

    @Autowired
    private CereRecommendTrendsDAO cereRecommendTrendsDAO;

    @Override
    public Page<CereRecommendCommentPage> commentPage(RecommendCommentPageParam param) {
        PageHelper.startPage(param.getPage(), param.getPageSize());
        PageInfo<CereRecommendCommentPage> pageInfo = new PageInfo<>(cereRecommendCommentDAO.commentPage(param));
        Page page = new Page(pageInfo.getList(), pageInfo.getTotal());
        return page;
    }

    @Override
    @Transactional(isolation = Isolation.DEFAULT, propagation = Propagation.REQUIRED, rollbackFor = {CoBusinessException.class, Exception.class})
    public void deleteComment(Long recommendCommentId) {
        CereRecommendComment comment = cereRecommendCommentDAO.getCommentById(recommendCommentId);
        CereRecommendTrends trends = cereRecommendTrendsDAO.getTrendById(comment.getRecommendId());
        Integer count;
        // 当前评论为根评论，删除包含自己的下级所有评论
        if (ObjectUtil.isNull(comment.getRootCommentId())) {
            count = cereRecommendCommentDAO.deleteCommentByRootCommentId(comment.getRecommendCommentId());
        } else {
            count = cereRecommendCommentDAO.deleteCommentByParentCommentId(comment.getRecommendCommentId());
            // 减少根评论回复数
            cereRecommendCommentDAO.subReplyCount(comment.getRootCommentId(), count);
            if (!comment.getRootCommentId().equals(comment.getParentCommentId())) {
                // 减少父评论回复数
                cereRecommendCommentDAO.subReplyCount(comment.getParentCommentId(), 1);
            }
        }
        cereRecommendTrendsDAO.subCommentCount(comment.getRecommendId(), trends.getCommentCount() - count >= 0 ? count : 0);
    }

    @Override
    @Transactional(isolation = Isolation.DEFAULT, propagation = Propagation.REQUIRED, rollbackFor = {CoBusinessException.class, Exception.class})
    public void replyComment(RecommendCommentReplyParam param) {
        CereRecommendComment targetCommentInfo = cereRecommendCommentDAO.getCommentById(param.getTargetCommentId());
        CereRecommendComment replyComment = new CereRecommendComment();
        replyComment.setParentCommentId(targetCommentInfo.getRecommendCommentId());
        replyComment.setRootCommentId(ObjectUtil.isNotNull(targetCommentInfo.getRootCommentId()) ?
                targetCommentInfo.getRootCommentId() : targetCommentInfo.getRecommendCommentId());
        replyComment.setRecommendId(targetCommentInfo.getRecommendId());
        replyComment.setContent(param.getContent());
        replyComment.setUserId(param.getUserId());
        replyComment.setUserType(2);
        replyComment.setTargetUserId(targetCommentInfo.getUserId());
        replyComment.setTargetUserType(targetCommentInfo.getUserType());
        cereRecommendCommentDAO.saveComment(replyComment);
        if (ObjectUtil.isNotNull(targetCommentInfo.getRootCommentId())) {
            cereRecommendCommentDAO.addReplyCount(targetCommentInfo.getRootCommentId());
        }
        cereRecommendCommentDAO.addReplyCount(param.getTargetCommentId());
        cereRecommendTrendsDAO.addCommentCount(targetCommentInfo.getRecommendId());
    }
}
