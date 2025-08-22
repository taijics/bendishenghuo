package com.shop.cereshop.business.utils;

import cn.hutool.core.codec.Base64;
import com.shop.cereshop.business.dao.business.CereScrmVerifyDAO;
import com.shop.cereshop.business.pay.weixin.skd.Tools;
import com.shop.cereshop.commons.constant.CoReturnFormat;
import com.shop.cereshop.commons.domain.business.CereScrmVerify;
import com.shop.cereshop.commons.exception.CoBusinessException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class ScrmSyncVerifyUtil {

    @Autowired
    private CereScrmVerifyDAO cereScrmVerifyDAO;

    /**
     * 校验秘钥是否正确
     * @param shopId
     * @param secret
     * @throws CoBusinessException
     */
    public void verify(Long shopId, String secret) throws CoBusinessException {
        String encodeSecret = Tools.md5(Base64.encode(secret.getBytes()));
        CereScrmVerify verify = cereScrmVerifyDAO.selectById(shopId);
        if (verify == null) {
            throw new CoBusinessException(CoReturnFormat.SECRET_ERROR);
        }
        if (!encodeSecret.equals(verify.getEncodeSecret().toLowerCase())) {
            throw new CoBusinessException(CoReturnFormat.SECRET_ERROR);
        }
    }

}
