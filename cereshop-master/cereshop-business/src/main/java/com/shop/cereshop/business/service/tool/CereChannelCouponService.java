/*
* Copyright (C) 2017-2021
* All rights reserved, Designed By 深圳中科鑫智科技有限公司
* Copyright authorization contact 18814114118
*/
package com.shop.cereshop.business.service.tool;

import com.shop.cereshop.business.page.tool.ChannelCouponDetail;
import com.shop.cereshop.business.param.tool.ChannelCouponParam;
import com.shop.cereshop.commons.domain.common.Page;
import com.shop.cereshop.commons.domain.tool.CereChannelCoupon;
import com.shop.cereshop.commons.exception.CoBusinessException;

/**
 * <p>
 * 业务接口
 * 渠道券表
 * </p>
 *
 * @date 2021-12-12
 */
public interface CereChannelCouponService {

    Page<ChannelCouponDetail> getAll(ChannelCouponParam param);

    int save(CereChannelCoupon channelCoupon) throws CoBusinessException;

    String generateLink(CereChannelCoupon channelCoupon);
}
