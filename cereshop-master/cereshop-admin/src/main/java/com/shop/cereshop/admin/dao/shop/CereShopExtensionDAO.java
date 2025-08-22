/*
 * Copyright (C) 2017-2021
 * All rights reserved, Designed By 深圳中科鑫智科技有限公司
 * Copyright authorization contact 18814114118
 */
package com.shop.cereshop.admin.dao.shop;

import com.shop.cereshop.commons.domain.shop.CereShopExtension;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface CereShopExtensionDAO extends BaseMapper<CereShopExtension> {
    int deleteByPrimaryKey(Long extensionId);

    int insertSelective(CereShopExtension record);

    CereShopExtension selectByPrimaryKey(Long extensionId);

    int updateByPrimaryKeySelective(CereShopExtension record);

    int updateByPrimaryKey(CereShopExtension record);
}
