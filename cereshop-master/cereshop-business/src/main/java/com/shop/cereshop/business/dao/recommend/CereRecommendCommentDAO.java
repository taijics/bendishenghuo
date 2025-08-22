/*
 * Copyright (C) 2017-2021
 * All rights reserved, Designed By 深圳中科鑫智科技有限公司
 * Copyright authorization contact 18814114118
 */
package com.shop.cereshop.business.dao.recommend;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.shop.cereshop.business.page.recommend.CereRecommendCommentPage;
import com.shop.cereshop.business.param.recommend.RecommendCommentPageParam;
import com.shop.cereshop.commons.domain.recommend.CereRecommendComment;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface CereRecommendCommentDAO extends BaseMapper<CereRecommendComment> {
    List<CereRecommendCommentPage> commentPage(RecommendCommentPageParam param);

    void deleteComment(@Param("recommendCommentId") Long recommendCommentId);

    CereRecommendComment getCommentById(@Param("recommendCommentId") Long recommendCommentId);

    void addReplyCount(@Param("recommendCommentId") Long recommendCommentId);

    void subReplyCount(@Param("recommendCommentId") Long recommendCommentId, @Param("count") Integer count);

    Integer deleteCommentByRootCommentId(@Param("rootCommentId") Long rootCommentId);

    Integer deleteCommentByParentCommentId(@Param("parentCommentId") Long parentCommentId);

    void saveComment(CereRecommendComment comment);
}
