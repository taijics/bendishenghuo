/*
* Copyright (C) 2017-2021
* All rights reserved, Designed By 深圳中科鑫智科技有限公司
* Copyright authorization contact 18814114118
*/
package com.shop.cereshop.admin.service.risk;

import com.shop.cereshop.admin.page.risk.CereRiskUserBlack;
import com.shop.cereshop.admin.param.risk.CereRiskBlackPageParam;
import com.shop.cereshop.commons.domain.common.Page;
import com.shop.cereshop.commons.domain.risk.CereRiskBlack;
import com.shop.cereshop.commons.exception.CoBusinessException;

/**
 * <p>
 * 业务接口
 * 黑名单表
 * </p>
 *
 * @author JustArgo
 * @date 2021-12-06
 */
public interface CereRiskBlackService {

    Page<CereRiskBlack> getAllIpBlackList(CereRiskBlackPageParam param);

    Page<CereRiskUserBlack> getUserBlackList(CereRiskBlackPageParam param);

    int save(CereRiskBlack param) throws CoBusinessException;

    int update(CereRiskBlack param) throws CoBusinessException;

    int delete(CereRiskBlack param);
}
