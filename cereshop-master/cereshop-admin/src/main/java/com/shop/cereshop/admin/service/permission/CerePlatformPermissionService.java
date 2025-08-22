/*
 * Copyright (C) 2017-2021
 * All rights reserved, Designed By 深圳中科鑫智科技有限公司
 * Copyright authorization contact 18814114118
 */
package com.shop.cereshop.admin.service.permission;

import com.shop.cereshop.admin.page.permission.MenuButton;
import com.shop.cereshop.admin.page.permission.RolePermission;
import com.shop.cereshop.admin.param.permission.PermissionDeleteParam;
import com.shop.cereshop.admin.param.permission.PermissionGetAllParam;
import com.shop.cereshop.admin.param.permission.PermissionSaveParam;
import com.shop.cereshop.admin.param.permission.PermissionUpdateParam;
import com.shop.cereshop.admin.param.role.RoleDistributionParam;
import com.shop.cereshop.admin.param.user.UserBuildParam;
import com.shop.cereshop.commons.domain.common.Page;
import com.shop.cereshop.commons.domain.permission.CerePlatformPermission;
import com.shop.cereshop.commons.domain.user.CerePlatformUser;
import com.shop.cereshop.commons.exception.CoBusinessException;

import java.util.List;

public interface CerePlatformPermissionService {
    /**
     * 保存权限
     * @param param
     * @param user
     * @throws CoBusinessException
     */
    void save(PermissionSaveParam param, CerePlatformUser user) throws CoBusinessException;

    /**
     * 更新权限
     * @param param
     * @param user
     * @throws CoBusinessException
     */
    void update(PermissionUpdateParam param, CerePlatformUser user) throws CoBusinessException;

    /**
     * 删除权限
     * @param param
     * @param user
     * @throws CoBusinessException
     */
    void delete(PermissionDeleteParam param, CerePlatformUser user) throws CoBusinessException;

    /**
     * 根据主键查询权限
     * @param permissionId
     * @return
     * @throws CoBusinessException
     */
    CerePlatformPermission getById(Long permissionId) throws CoBusinessException;

    /**
     * 查询权限列表
     * @param param
     * @return
     * @throws CoBusinessException
     */
    Page getAll(PermissionGetAllParam param) throws CoBusinessException;

    /**
     * 查询用户所有权限
     * @param user
     * @return
     * @throws CoBusinessException
     */
    List<MenuButton> getAllByUserId(UserBuildParam user) throws CoBusinessException;

    /**
     * 根据主键和排序查询单个权限
     * @param sort
     * @param id
     * @return
     */
    CerePlatformPermission findBySort(Integer sort,Long id);

    /**
     * 获取最大权限
     * @return
     * @throws CoBusinessException
     */
    Integer getMaxSort() throws CoBusinessException;

    /**
     * 获取角色权限
     * @param param
     * @return
     * @throws CoBusinessException
     */
    RolePermission getRolePermission(RoleDistributionParam param) throws CoBusinessException;

    /**
     * 查询所有权限
     * @return
     */
    List<MenuButton> findAllPermissionShop();

    /**
     * 新增权限
     * @param permission
     * @throws CoBusinessException
     */
    void insert(CerePlatformPermission permission) throws CoBusinessException;

    /**
     * 获取权限最大主键
     * @return
     */
    Long getMaxId();

    /**
     * 批量新增权限
     * @param permissions
     * @throws CoBusinessException
     */
    void insertBatch(List<CerePlatformPermission> permissions) throws CoBusinessException;
}
