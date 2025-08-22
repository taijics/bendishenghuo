/*
 * Copyright (C) 2017-2021
 * All rights reserved, Designed By 深圳中科鑫智科技有限公司
 * Copyright authorization contact 18814114118
 */
package com.shop.cereshop.business.service.live;

import com.shop.cereshop.business.param.live.LiveGetAllParam;
import com.shop.cereshop.business.param.live.LiveParam;
import com.shop.cereshop.business.param.live.LiveProductGetAllParam;
import com.shop.cereshop.business.param.live.LiveProductParam;
import com.shop.cereshop.commons.domain.business.CerePlatformBusiness;
import com.shop.cereshop.commons.domain.common.Page;
import com.shop.cereshop.commons.domain.live.CereLive;
import com.shop.cereshop.commons.domain.live.CereLiveProduct;
import com.shop.cereshop.commons.exception.CoBusinessException;

public interface CereLiveProductService {

    Page getAll(LiveProductGetAllParam param) throws CoBusinessException;

    int save(LiveProductParam param, CerePlatformBusiness user) throws CoBusinessException;

    int update(LiveProductParam param, CerePlatformBusiness user) throws CoBusinessException;

    int delete(Long id, CerePlatformBusiness user);

    CereLiveProduct getById(LiveProductParam param);

    int reExamine(LiveProductParam param) throws CoBusinessException;
}
