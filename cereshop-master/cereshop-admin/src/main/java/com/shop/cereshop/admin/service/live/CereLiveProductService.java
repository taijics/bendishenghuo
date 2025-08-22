/*
 * Copyright (C) 2017-2021
 * All rights reserved, Designed By 深圳中科鑫智科技有限公司
 * Copyright authorization contact 18814114118
 */
package com.shop.cereshop.admin.service.live;

import com.shop.cereshop.admin.param.live.LiveProductGetAllParam;
import com.shop.cereshop.admin.param.live.LiveProductParam;
import com.shop.cereshop.commons.domain.common.Page;
import com.shop.cereshop.commons.domain.live.CereLiveProduct;
import com.shop.cereshop.commons.domain.user.CerePlatformUser;
import com.shop.cereshop.commons.exception.CoBusinessException;

public interface CereLiveProductService {

    Page getAll(LiveProductGetAllParam param) throws CoBusinessException;

    int audit(LiveProductParam param, CerePlatformUser user) throws CoBusinessException;

    CereLiveProduct getById(LiveProductParam param);
}
