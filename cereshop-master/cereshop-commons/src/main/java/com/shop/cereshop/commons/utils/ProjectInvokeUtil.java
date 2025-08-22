package com.shop.cereshop.commons.utils;

import com.alibaba.fastjson.JSON;
import com.shop.cereshop.commons.constant.RefreshSkuRealInfoSourceEnum;
import com.shop.cereshop.commons.domain.express.HttpResult;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.util.HashMap;
import java.util.Map;

@Component
public class ProjectInvokeUtil {

    @Value("${refreshSkuRealInfoUrl:''}")
    private String refreshSkuRealInfoUrl;

    @Value("${verifyCode:''}")
    private String verifyCode;

    public HttpResult postRefreshSkuRealInfo(Long productId,
                                             RefreshSkuRealInfoSourceEnum sourceEnum) {
        return postRefreshSkuRealInfo(productId, null, sourceEnum, null);
    }

    public HttpResult postRefreshSkuRealInfo(Long productId, Long skuId,
                                                    RefreshSkuRealInfoSourceEnum sourceEnum,
                                                    Integer fictitiousNumber) {
        Map<String, Object> map = new HashMap<>();
        map.put("productId", productId);
        map.put("skuId", skuId);
        map.put("fictitiousNumber", fictitiousNumber);
        map.put("sourceEnum", sourceEnum.ordinal());
        map.put("verifyCode", verifyCode);
        if (StringUtils.isBlank(refreshSkuRealInfoUrl)) {
            return new HttpResult(200, "{}", null);
        }
        return HttpUtils.doPostJson(refreshSkuRealInfoUrl, JSON.toJSONString(map));
    }

    public HttpResult postRefreshSkuRealInfoForActivity(Long activityId,
                                             RefreshSkuRealInfoSourceEnum sourceEnum) {
        Map<String, Object> map = new HashMap<>();
        map.put("activityId", activityId);
        map.put("sourceEnum", sourceEnum.ordinal());
        map.put("verifyCode", verifyCode);
        if (StringUtils.isBlank(refreshSkuRealInfoUrl)) {
            return new HttpResult(200, "{}", null);
        }
        return HttpUtils.doPostJson(refreshSkuRealInfoUrl, JSON.toJSONString(map));
    }

}
