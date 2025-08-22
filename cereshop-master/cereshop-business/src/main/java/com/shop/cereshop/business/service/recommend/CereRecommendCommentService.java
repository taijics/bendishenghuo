package com.shop.cereshop.business.service.recommend;

import com.shop.cereshop.business.page.recommend.CereRecommendCommentPage;
import com.shop.cereshop.business.param.recommend.RecommendCommentPageParam;
import com.shop.cereshop.business.param.recommend.RecommendCommentReplyParam;
import com.shop.cereshop.commons.domain.common.Page;

public interface CereRecommendCommentService {
    Page<CereRecommendCommentPage> commentPage(RecommendCommentPageParam param);

    void deleteComment(Long recommendCommentId);

    void replyComment(RecommendCommentReplyParam param);
}
