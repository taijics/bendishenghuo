/*
 * Copyright (C) 2017-2021
 * All rights reserved, Designed By 深圳中科鑫智科技有限公司
 * Copyright authorization contact 18814114118
 */
package com.shop.cereshop.admin.dao.credit;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.shop.cereshop.admin.page.credit.CereCreditRecordPage;
import com.shop.cereshop.admin.param.credit.CreditRecordGetAllParam;
import com.shop.cereshop.commons.domain.credit.CereCreditRecord;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

/**
 * <p>
 * Mapper 接口
 * 积分流水表
 * </p>
 *
 * @author JustArgo
 * @date 2021-12-04
 */
@Mapper
public interface CereCreditRecordDAO extends BaseMapper<CereCreditRecord> {

    List<CereCreditRecordPage> getAll(CreditRecordGetAllParam param);
}
