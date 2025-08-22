/*
 * Copyright (C) 2017-2021
 * All rights reserved, Designed By 深圳中科鑫智科技有限公司
 * Copyright authorization contact 18814114118
 */
package com.shop.cereshop.admin.dao.recommend;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.shop.cereshop.admin.page.product.RecommendProduct;
import com.shop.cereshop.commons.domain.recommend.CereRecommendRelation;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface CereRecommendRelationDAO extends BaseMapper<CereRecommendRelation> {

    List<RecommendProduct> getRecommendProducts(@Param("recommendId") Long recommendId);

}
