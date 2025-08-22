/*
 * Copyright (C) 2017-2021
 * All rights reserved, Designed By 深圳中科鑫智科技有限公司
 * Copyright authorization contact 18814114118
 */
package com.shop.cereshop.admin.service.credit;


import com.shop.cereshop.admin.param.credit.CreditRecordGetAllParam;
import com.shop.cereshop.commons.domain.common.Page;

/**
 * <p>
 * 业务接口
 * 积分流水表
 * </p>
 *
 * @author JustArgo
 * @date 2021-12-04
 */
public interface CereCreditRecordService {

    Page getAll(CreditRecordGetAllParam param);
}
