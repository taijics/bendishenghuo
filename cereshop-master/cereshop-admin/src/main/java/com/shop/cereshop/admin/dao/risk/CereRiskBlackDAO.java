/*
* Copyright (C) 2017-2021
* All rights reserved, Designed By 深圳中科鑫智科技有限公司
* Copyright authorization contact 18814114118
*/
package com.shop.cereshop.admin.dao.risk;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.shop.cereshop.admin.page.risk.CereRiskUserBlack;
import com.shop.cereshop.admin.param.risk.CereRiskBlackPageParam;
import com.shop.cereshop.commons.domain.risk.CereRiskBlack;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * <p>
 * Mapper 接口
 * 黑名单表
 * </p>
 *
 * @author JustArgo
 * @date 2021-12-06
 */
@Mapper
public interface CereRiskBlackDAO extends BaseMapper<CereRiskBlack> {

    List<CereRiskUserBlack> getUserBlackList(CereRiskBlackPageParam param);
}
