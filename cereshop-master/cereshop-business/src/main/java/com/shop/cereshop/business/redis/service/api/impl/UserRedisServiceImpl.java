/*
 * Copyright (C) 2017-2021
 * All rights reserved, Designed By 深圳中科鑫智科技有限公司
 * Copyright authorization contact 18814114118
 */
package com.shop.cereshop.business.redis.service.api.impl;

import com.shop.cereshop.business.redis.service.api.UserRedisService;
import com.shop.cereshop.business.utils.TokenProvider;
import com.shop.cereshop.commons.config.SecurityProperties;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;

import java.util.concurrent.TimeUnit;

@Service
public class UserRedisServiceImpl implements UserRedisService {

    @Autowired
    private RedisTemplate redisTemplate;

    @Autowired
    private SecurityProperties securityProperties;

    @Autowired
    private TokenProvider tokenProvider;


    @Override
    public void saveUser(String token, Long userId, Long time) {
        if (!securityProperties.isMultiLogin()) {
            Object oldTokenKey = redisTemplate.opsForValue().get(securityProperties.getUserLoginKey() + userId);
            if (oldTokenKey != null) {
                redisTemplate.delete(oldTokenKey);
            }
        }
        redisTemplate.opsForValue().set(token, userId, time, TimeUnit.SECONDS);
        redisTemplate.opsForValue().set(securityProperties.getUserLoginKey() + userId, token);
    }

    @Override
    public Long getBuyerUserIdByToken(String token) {
        if (StringUtils.isNotBlank(token)) {
            Object obj = redisTemplate.opsForValue().get(token);
            if (obj != null) {
                return Long.valueOf(obj.toString());
            }
        }
        return null;
    }

    @Override
    public void refreshToken(String token) {
        redisTemplate.expire(token, securityProperties.getRenew(), TimeUnit.MILLISECONDS);
    }

    @Override
    public String getToken(Long userId) {
        return (String) redisTemplate.opsForValue().get(securityProperties.getUserLoginKey() + userId);
    }

    @Override
    public String createToken(String username, Long userId) {
        String token = tokenProvider.createToken(username);

        //token保存到redis
        this.saveUser(token, userId, securityProperties.getTokenValidityInSeconds());
        return token;
    }

    @Override
    public String createToken4Remember(String username, Long userId) {
        String token = tokenProvider.createToken(username);

        //token保存到redis
        this.saveUser(token, userId, securityProperties.getRememberLoginValidity());
        return token;
    }
}
