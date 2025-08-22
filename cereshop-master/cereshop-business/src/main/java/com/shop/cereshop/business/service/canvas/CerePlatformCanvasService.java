/*
 * Copyright (C) 2017-2021
 * All rights reserved, Designed By 深圳中科鑫智科技有限公司
 * Copyright authorization contact 18814114118
 */
package com.shop.cereshop.business.service.canvas;

import com.shop.cereshop.commons.domain.business.CerePlatformBusiness;
import com.shop.cereshop.commons.domain.canvas.CerePlatformCanvas;
import com.shop.cereshop.commons.domain.user.CerePlatformUser;
import com.shop.cereshop.commons.exception.CoBusinessException;

public interface CerePlatformCanvasService {
    void saveCanvas(CerePlatformCanvas canvas, CerePlatformBusiness user) throws CoBusinessException;

    CerePlatformCanvas getCanvas(CerePlatformCanvas canvas) throws CoBusinessException;
}
