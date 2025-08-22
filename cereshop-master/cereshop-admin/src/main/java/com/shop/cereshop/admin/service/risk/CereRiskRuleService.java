/*
* Copyright (C) 2017-2021
* All rights reserved, Designed By 深圳中科鑫智科技有限公司
* Copyright authorization contact 18814114118
*/
package com.shop.cereshop.admin.service.risk;


import com.shop.cereshop.commons.domain.common.Page;
import com.shop.cereshop.commons.domain.common.PageParam;
import com.shop.cereshop.commons.domain.risk.CereRiskRule;

/**
 * <p>
 * 业务接口
 * 风控规则表
 * </p>
 *
 * @author JustArgo
 * @date 2021-12-06
 */
public interface CereRiskRuleService {

    Page<CereRiskRule> getAllRiskRule(PageParam param);

    int save(CereRiskRule param);

    int update(CereRiskRule param);

    int delete(CereRiskRule param);
}
