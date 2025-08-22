/*
* Copyright (C) 2017-2021
* All rights reserved, Designed By 深圳中科鑫智科技有限公司
* Copyright authorization contact 18814114118
*/
package com.shop.cereshop.admin.service.advert;


import com.shop.cereshop.admin.param.advert.CerePopupAdvertParam;
import com.shop.cereshop.commons.domain.advert.CerePopupAdvert;
import com.shop.cereshop.commons.domain.common.Page;
import com.shop.cereshop.commons.exception.CoBusinessException;

/**
 * <p>
 * 业务接口
 * 弹窗广告表
 * </p>
 *
 * @author JustArgo
 * @date 2021-12-04
 */
public interface CerePopupAdvertService {

    Page<CerePopupAdvert> getAll(CerePopupAdvertParam advert);

    int save(CerePopupAdvert advert) throws CoBusinessException;

    int update(CerePopupAdvert advert) throws CoBusinessException;

    int delete(Long id);

    int toggleState(Long id, Integer state) throws CoBusinessException;
}
