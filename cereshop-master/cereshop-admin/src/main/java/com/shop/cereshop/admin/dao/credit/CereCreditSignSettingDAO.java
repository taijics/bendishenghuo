/*
* Copyright (C) 2017-2021
* All rights reserved, Designed By 深圳中科鑫智科技有限公司
* Copyright authorization contact 18814114118
*/
package com.shop.cereshop.admin.dao.credit;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.shop.cereshop.admin.page.credit.CereCreditRecordPage;
import com.shop.cereshop.admin.param.credit.CreditRecordGetAllParam;
import com.shop.cereshop.commons.domain.common.PageParam;
import com.shop.cereshop.commons.domain.credit.CereCreditSignSetting;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * <p>
 * Mapper 接口
 * 积分签到配置
 * </p>
 *
 * @author JustArgo
 * @date 2021-12-04
 */
@Mapper
public interface CereCreditSignSettingDAO extends BaseMapper<CereCreditSignSetting> {

    List<CereCreditSignSetting> getAll(PageParam param);

    int selectExistsDay(@Param("day") Integer day, @Param("id") Long id);
}
