/*
* Copyright (C) 2017-2021
* All rights reserved, Designed By 深圳中科鑫智科技有限公司
* Copyright authorization contact 18814114118
*/
package com.shop.cereshop.admin.service.credit;

import com.shop.cereshop.commons.domain.common.Page;
import com.shop.cereshop.commons.domain.common.PageParam;
import com.shop.cereshop.commons.domain.credit.CereCreditSignSetting;
import com.shop.cereshop.commons.exception.CoBusinessException;

/**
 * <p>
 * 业务接口
 * 积分签到配置
 * </p>
 *
 * @author JustArgo
 * @date 2021-12-04
 */
public interface CereCreditSignSettingService {

    Page getAll(PageParam param);

    int save(CereCreditSignSetting param) throws CoBusinessException;

    int update(CereCreditSignSetting param) throws CoBusinessException;

    int delete(Long id);
}
