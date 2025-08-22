/*
* Copyright (C) 2017-2021
* All rights reserved, Designed By 深圳中科鑫智科技有限公司
* Copyright authorization contact 18814114118
*/
package com.shop.cereshop.admin.dao.advert;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.shop.cereshop.admin.param.advert.CerePopupAdvertParam;
import com.shop.cereshop.commons.domain.advert.CerePopupAdvert;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

/**
 * <p>
 * Mapper 接口
 * 弹窗广告表
 * </p>
 *
 * @author JustArgo
 * @date 2021-12-04
 */
@Mapper
public interface CerePopupAdvertDAO extends BaseMapper<CerePopupAdvert> {

    List<CerePopupAdvert> getAll(CerePopupAdvertParam advert);

    int checkConflict(CerePopupAdvert advert);
}
