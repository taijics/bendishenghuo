/*
 * Copyright (C) 2017-2021
 * All rights reserved, Designed By 深圳中科鑫智科技有限公司
 * Copyright authorization contact 18814114118
 */
package com.shop.cereshop.business.service.live;

import com.shop.cereshop.business.param.live.*;
import com.shop.cereshop.commons.domain.business.CerePlatformBusiness;
import com.shop.cereshop.commons.domain.common.Page;
import com.shop.cereshop.commons.domain.live.CereLive;
import com.shop.cereshop.commons.exception.CoBusinessException;

public interface CereLiveService {

    Page getAll(LiveGetAllParam param) throws CoBusinessException;

    int save(CereLive param, CerePlatformBusiness user) throws CoBusinessException;

    int update(CereLive param, CerePlatformBusiness user) throws CoBusinessException;

    int delete(Long id, CerePlatformBusiness user);

    CereLive getById(LiveParam param);

    int importProduct(LiveProductRelParam param, CerePlatformBusiness user) throws CoBusinessException;

    Page getLiveProductRelPageByLiveId(LiveProductPageParam param);

    int reExamine(LiveParam param) throws CoBusinessException;

    boolean verifyAnchor(AnchorWechatParam param) throws CoBusinessException;
}
