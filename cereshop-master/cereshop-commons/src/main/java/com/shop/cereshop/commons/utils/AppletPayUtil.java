/*
 * Copyright (C) 2017-2021
 * All rights reserved, Designed By 深圳中科鑫智科技有限公司
 * Copyright authorization contact 18814114118
 */
package com.shop.cereshop.commons.utils;

import com.alibaba.fastjson.JSONObject;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang.StringUtils;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.http.util.EntityUtils;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.net.InetAddress;
import java.net.UnknownHostException;

/****************************************************
 *
 *
 *
 * @author majker
 * @date 2019-03-07 21:24
 * @version 1.0
 **************************************************/
@Slf4j
public class AppletPayUtil {

    // 获取客户端ip
    public static String getClientIp(HttpServletRequest request) {
        String ip = request.getHeader("x-forwarded-for");
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("X-Real-IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("Proxy-Client-IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("WL-Proxy-Client-IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getRemoteAddr();
        }
        if (ip == null || ip.length() == 0 || ip.contains(":")) {
            try {
                ip = InetAddress.getLocalHost().getHostAddress();
            } catch (UnknownHostException e) {
                ip = null;
            }
        }
        if (ip != null && ip.length() != 0) {
            String[] ipArr = ip.split(",");
            for (String ipCur:ipArr) {
                if (!ipCur.trim().equals("127.0.0.1")) {
                    ip = ipCur.trim();
                    break;
                }
            }
        }
        return ip;
    }

    public static String getIpLocation(String ip) {
        CloseableHttpClient httpClient = HttpClientBuilder.create().build();
        CloseableHttpResponse resp = null;

        try {
            HttpPost httpPost = new HttpPost("http://whois.pconline.com.cn/ipJson.jsp?json=true&ip=" + ip);
            resp = httpClient.execute(httpPost);
            String body = EntityUtils.toString(resp.getEntity(), "UTF-8");
            int statusCode = resp.getStatusLine().getStatusCode();
            if (statusCode == 200 && StringUtils.isNotBlank(body)) {
                JSONObject jsonObject = JSONObject.parseObject(body);
                String province = jsonObject.getString("pro");
                String city = jsonObject.getString("city");
                if (StringUtils.isBlank(province) && StringUtils.isBlank(city)) {
                    return "未知";
                }
                if (StringUtils.isBlank(province)) {
                    return city;
                }
                if (StringUtils.isBlank(city)) {
                    return province;
                }
                return province + " " + city;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (null != resp) {
                try {
                    resp.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
        return "未知";
    }
}

