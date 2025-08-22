/*
 * Copyright (C) 2017-2021
 * All rights reserved, Designed By 深圳中科鑫智科技有限公司
 * Copyright authorization contact 18814114118
 */
package com.shop.cereshop.commons.utils;

import com.google.gson.Gson;
import com.shop.cereshop.commons.domain.express.HttpResult;
import okhttp3.*;
import org.apache.http.HttpEntity;
import org.apache.http.NameValuePair;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.ContentType;
import org.apache.http.entity.StringEntity;
import org.apache.http.entity.mime.MultipartEntityBuilder;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.http.message.BasicHeader;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.protocol.HTTP;
import org.apache.http.util.EntityUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


/**
 * @Author: api.kuaidi100.com
 * @Date: 2020-07-14 16:59
 */
public class HttpUtils {

    private final static String CHARSET_DEFAULT = "UTF-8";
    private static Logger record = LoggerFactory.getLogger("record");

    /**
     * post请求  编码格式默认UTF-8
     *
     * @param url     请求url
     * @return
     */
    public static HttpResult doPost(String url, Object obj) {
        CloseableHttpClient httpClient = HttpClientBuilder.create().build();
        CloseableHttpResponse resp = null;

        HttpResult result = new HttpResult();
        try {
            Map<String, String> params = objectToMap(obj);
            HttpPost httpPost = new HttpPost(url);
            if (params != null && params.size() > 0) {
                List<NameValuePair> list = new ArrayList<NameValuePair>();
                for (Map.Entry<String, String> entry : params.entrySet()) {
                    list.add(new BasicNameValuePair(entry.getKey(), entry.getValue()));
                }
                httpPost.setEntity(new UrlEncodedFormEntity(list, CHARSET_DEFAULT));
            }

            resp = httpClient.execute(httpPost);
            String body = EntityUtils.toString(resp.getEntity(), CHARSET_DEFAULT);
            int statusCode = resp.getStatusLine().getStatusCode();

            result.setStatus(statusCode);
            result.setBody(body);
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
        return result;
    }

    /**
     * post请求 参数为json形式  编码格式默认UTF-8
     *
     * @param url     请求url
     * @return
     */
    public static HttpResult doPostJson(String url, Object obj) {
        CloseableHttpClient httpClient = HttpClientBuilder.create().build();
        CloseableHttpResponse resp = null;

        HttpResult result = new HttpResult();
        try {

            HttpPost httpPost = new HttpPost(url);

            StringEntity entity = new StringEntity(obj.toString());
            entity.setContentType("text/json");
            entity.setContentEncoding(new BasicHeader(HTTP.CONTENT_TYPE, "application/json"));
            httpPost.setEntity(entity);

            httpPost.setHeader("Content-Type", "application/json;charset=utf-8");
            resp = httpClient.execute(httpPost);
            String body = EntityUtils.toString(resp.getEntity(), CHARSET_DEFAULT);
            int statusCode = resp.getStatusLine().getStatusCode();

            result.setStatus(statusCode);
            result.setBody(body);
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
        return result;
    }

    /**
     * post请求  编码格式默认UTF-8
     *
     * @param url     请求url
     * @return
     */
    public static HttpResult doPostFile(String url,  File file) {
        CloseableHttpClient httpClient = HttpClientBuilder.create().build();
        CloseableHttpResponse resp = null;

        HttpResult result = new HttpResult();
        try {

            HttpPost httpPost = new HttpPost(url);
            MultipartEntityBuilder builder = MultipartEntityBuilder.create();
            // 把文件加到HTTP的post请求中
            builder.addBinaryBody(
                    "file",
                    new FileInputStream(file),
                    ContentType.MULTIPART_FORM_DATA,
                    file.getName()
            );
            //HttpEntity
            HttpEntity entity = builder.build();
            httpPost.setEntity(entity);
            resp = httpClient.execute(httpPost);
            result.setStatus(resp.getStatusLine().getStatusCode());
            result.setBody(EntityUtils.toString(resp.getEntity(), CHARSET_DEFAULT));
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
        return result;
    }


    /**
     * 将Object对象里面的属性和值转化成Map对象
     *
     * @param obj
     * @return
     * @throws IllegalAccessException
     */
    public static Map<String, String> objectToMap(Object obj) throws IllegalAccessException {
        if (obj == null) {
            return null;
        }
        Map<String, String> map = new HashMap<String,String>();
        Class<?> clazz = obj.getClass();
        for (Field field : clazz.getDeclaredFields()) {
            field.setAccessible(true);
            String fieldName = field.getName();
            String fieldValue = "";
            if (field.getType()== String.class || field.getType() == Integer.class || field.getType() == int.class){
                fieldValue = field.get(obj)==null?"": field.get(obj).toString();
            }else {
                fieldValue = new Gson().toJson(field.get(obj));
            }
            map.put(fieldName, fieldValue);
        }
        return map;
    }

    public static String getAppletNoticeToken(String appid, String secret) throws IOException {
        OkHttpClient client = new OkHttpClient().newBuilder()
                .build();
        Request request = new Request.Builder()
                .url("https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid=" + appid + "&secret=" + secret)
                .get()
                .build();
        Response response = client.newCall(request).execute();
        assert response.body() != null;
        return response.body().string();
    }

    public static String sendAppletNotice(String token, String bodyString) throws IOException {
        OkHttpClient client = new OkHttpClient().newBuilder()
                .build();
        MediaType mediaType = MediaType.parse("text/plain");
        RequestBody body = RequestBody.create(mediaType, bodyString);
        Request request = new Request.Builder()
                .url("https://api.weixin.qq.com/wxa/sec/order/upload_shipping_info?access_token="+token)
                .method("POST", body)
                .build();
        Response response = client.newCall(request).execute();
        assert response.body() != null;
        return response.body().string();
    }

}
