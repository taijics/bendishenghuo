package com.shop.cereshop.admin.service.recommend;

import com.shop.cereshop.admin.page.recommend.CereRecommendTypePage;
import com.shop.cereshop.admin.param.recommend.RecommendTypePageParam;
import com.shop.cereshop.admin.param.recommend.RecommendTypeSaveParam;
import com.shop.cereshop.admin.param.recommend.RecommendTypeUpdateParam;
import com.shop.cereshop.commons.domain.common.Page;
import com.shop.cereshop.commons.exception.CoBusinessException;

public interface CereRecommendTypeService {

    int save(RecommendTypeSaveParam param) throws CoBusinessException;

    int update(RecommendTypeUpdateParam param) throws CoBusinessException;

    CereRecommendTypePage get(Long recommendTypeId);

    Page<CereRecommendTypePage> page(RecommendTypePageParam param);

    int delete(Long recommendTypeId);
}
