/*
 * Copyright (C) 2017-2021
 * All rights reserved, Designed By 深圳中科鑫智科技有限公司
 * Copyright authorization contact 18814114118
 */
package com.shop.cereshop.admin.utils;

import com.shop.cereshop.commons.constant.CoReturnFormat;
import com.shop.cereshop.commons.exception.CoBusinessException;
import org.springframework.stereotype.Component;

@Component
public class ContextUtil {

    static ThreadLocal<Boolean> adminTL = new ThreadLocal<>();

    public static void setAdmin(){
        adminTL.set(true);
    }

    public static void clearAdmin(){
        adminTL.set(false);
    }

    public static boolean getAdmin(){
        return false;
        //return adminTL.get() != null && adminTL.get();
    }

    public static void interceptDelete() throws CoBusinessException {
        //throw new CoBusinessException(CoReturnFormat.DEMON_ACCOUNT_NOT_PERMITTED);
    }

}
