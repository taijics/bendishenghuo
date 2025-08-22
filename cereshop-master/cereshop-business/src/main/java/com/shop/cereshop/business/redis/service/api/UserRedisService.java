/*
 * Copyright (C) 2017-2021
 * All rights reserved, Designed By 深圳中科鑫智科技有限公司
 * Copyright authorization contact 18814114118
 */
package com.shop.cereshop.business.redis.service.api;

public interface UserRedisService {

    /** 保存用户id到redis中 */
    void saveUser(String token, Long userId,Long time);

    /** 根据token获取用户id */
    Long getBuyerUserIdByToken(String token);

    void refreshToken(String token);

    /**
     * 根据用户查询token
     */
    String getToken(Long userId);

    /**
     * 生成token并且保存到缓存
     * @param username /
     * @param userId /
     * @return token
     */
    String createToken(String username, Long userId);

    /**
     * 生成token并且以记住登录的方式保存到缓存
     * @param username /
     * @param userId /
     * @return token
     */
    String createToken4Remember(String username, Long userId);

}
