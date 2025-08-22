/*
 * Copyright (C) 2017-2021
 * All rights reserved, Designed By 深圳中科鑫智科技有限公司
 * Copyright authorization contact 18814114118
 */
package com.shop.cereshop.admin.dao.role;

import com.shop.cereshop.commons.domain.role.CerePlatformRolePermission;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface CerePlatformRolePermissionDAO extends BaseMapper<CerePlatformRolePermission> {

    int insertSelective(CerePlatformRolePermission record);

    void deleteByRoleId(@Param("roleId") Long roleId);

    int deleteRolePermission(@Param("project") Long project,
                             @Param("businessUserId") Long businessUserId,
                             @Param("resourceType") String resourceType,
                              @Param("permissionList") List<String> permissionList);

    void insertBatch(@Param("list") List<CerePlatformRolePermission> list);

    void deleteByPermissionId(@Param("permissionId") Long permissionId);
}
