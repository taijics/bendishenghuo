/*
 * Copyright (C) 2017-2021
 * All rights reserved, Designed By 深圳中科鑫智科技有限公司
 * Copyright authorization contact 18814114118
 */
package com.shop.cereshop.admin.service.live;

import com.shop.cereshop.admin.param.live.LiveGetAllParam;
import com.shop.cereshop.admin.param.live.LiveParam;
import com.shop.cereshop.admin.param.live.LiveProductPageParam;
import com.shop.cereshop.commons.domain.common.Page;
import com.shop.cereshop.commons.domain.live.CereLive;
import com.shop.cereshop.commons.domain.user.CerePlatformUser;
import com.shop.cereshop.commons.exception.CoBusinessException;

import java.util.List;

public interface CereLiveService {

    Page getAll(LiveGetAllParam param) throws CoBusinessException;

    int audit(LiveParam param, CerePlatformUser user) throws CoBusinessException;

    CereLive getById(LiveParam param);

    Page getLiveProductRelPageByLiveId(LiveProductPageParam param);

    List<CereLive> selectLiveList();
}
