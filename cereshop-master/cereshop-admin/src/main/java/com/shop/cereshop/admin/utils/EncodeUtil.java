package com.shop.cereshop.admin.utils;

import com.shop.cereshop.admin.redis.service.api.StringRedisService;
import com.shop.cereshop.commons.utils.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.parameters.P;
import org.springframework.stereotype.Component;

import java.util.Objects;

@Component
public class EncodeUtil {

    static ThreadLocal<Long> userIdTL = new ThreadLocal<>();

    @Autowired
    private StringRedisService stringRedisService;

    public void setUserIdTL(Long userId) {
        userIdTL.set(userId);
    }

    private static final String PRIVACY_SHOW_SWITCH = "privacy_show_switch_";

    public String encodePhone(String phone) {
        if (Objects.equals(userIdTL.get(), 2L)) {
            return phone;
        }
        Long privacyShowSwitch = (Long)stringRedisService.get(PRIVACY_SHOW_SWITCH + userIdTL.get());
        if (privacyShowSwitch != null && privacyShowSwitch > 0) {
            return phone;
        }
        return StringUtils.encodePhone(phone);
    }

    public String encodeInfo(String info) {
        if (Objects.equals(userIdTL.get(), 2L)) {
            return info;
        }
        Long privacyShowSwitch = (Long)stringRedisService.get(PRIVACY_SHOW_SWITCH + userIdTL.get());
        if (privacyShowSwitch != null && privacyShowSwitch > 0) {
            return info;
        }
        return StringUtils.encodeInfo(info);
    }

}
