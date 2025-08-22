/*
 * Copyright (C) 2017-2021
 * All rights reserved, Designed By 深圳中科鑫智科技有限公司
 * Copyright authorization contact 18814114118
 */
package com.shop.cereshop.business.alioss.service.impl;

import com.alipay.api.internal.util.file.IOUtils;
import com.aliyun.oss.OSSClient;
import com.aliyun.oss.model.*;
import com.shop.cereshop.business.alioss.listener.PutObjectProgressListener;
import com.shop.cereshop.business.alioss.service.FileUploadService;
import com.shop.cereshop.business.config.ConstantProperties;
import com.shop.cereshop.commons.constant.StringEnum;
import com.shop.cereshop.commons.utils.ImageUtil;
import org.springframework.stereotype.Service;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.text.SimpleDateFormat;
import java.util.*;

@Service
public class FileUploadServiceImpl implements FileUploadService {

    private final SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");

    private static final int PART_SIZE = 1024 * 1024; // 分片大小为1MB

    @Override
    public String uploadFile(String filename, InputStream in,long size) throws Exception {
        Objects.requireNonNull(filename);
        filename = filename.replaceAll(" ", "");
        String fileName = ConstantProperties.ALIOSS_FILE_HOST;
        // 创建OSSClient实例。
        OSSClient ossClient = new OSSClient(ConstantProperties.ALIOSS_END_POINT,
                ConstantProperties.ALIOSS_ACCESS_KEY_ID, ConstantProperties.ALIOSS_ACCESS_KEY_SECRET);
        String dateStr = format.format(new Date());
        //创建文件路径
        String fileUrl = fileName + "/" + (dateStr + "/" + UUID.randomUUID().toString().replace("-", "") + "_" + filename);
        InputStream inputStream = in;
        if (size > 5 * 1024 * 1024) {
            //大于5M就压缩
            if (filename.contains("jpg") || filename.contains("png")) {
                //如果是图片,压缩一下
                inputStream = ImageUtil.compressImg(in, 1.1f);
            }
        }
        if (filename.contains("mp4")) {
            // 初始化分片上传
            InitiateMultipartUploadRequest initRequest = new InitiateMultipartUploadRequest(
                    ConstantProperties.ALIOSS_BUCKET_NAME, fileUrl);
            InitiateMultipartUploadResult initResult = ossClient.initiateMultipartUpload(initRequest);

            // 计算分片数量
            int partCount = (int) Math.ceil((double) size / PART_SIZE);

            // 上传每个分片
            List<PartETag> partETags = new ArrayList<>();
            for (int i = 1; i <= partCount; i++) {
                byte[] partData = i == partCount ? IOUtils.readFully(in, (int) (size - (i - 1) * PART_SIZE)) : IOUtils.readFully(in, PART_SIZE);
                UploadPartRequest uploadPartRequest = new UploadPartRequest();
                uploadPartRequest.setBucketName(ConstantProperties.ALIOSS_BUCKET_NAME);
                uploadPartRequest.setKey(fileUrl);
                uploadPartRequest.setUploadId(initResult.getUploadId());
                uploadPartRequest.setInputStream(new ByteArrayInputStream(partData));
                uploadPartRequest.setPartNumber(i);
                uploadPartRequest.setPartSize(partData.length);
                UploadPartResult uploadPartResult = ossClient.uploadPart(uploadPartRequest);
                partETags.add(uploadPartResult.getPartETag());
            }

            // 完成分片上传
            CompleteMultipartUploadRequest completeRequest = new CompleteMultipartUploadRequest(
                    ConstantProperties.ALIOSS_BUCKET_NAME, fileUrl, initResult.getUploadId(), partETags);
            CompleteMultipartUploadResult completeResult = ossClient.completeMultipartUpload(completeRequest);

        } else {
            // 上传网络流。
            ossClient.putObject(new PutObjectRequest(ConstantProperties.ALIOSS_BUCKET_NAME, fileUrl, inputStream).
                    <PutObjectRequest>withProgressListener(new PutObjectProgressListener(null, 0)));
        }

        ossClient.shutdown();
        if (inputStream != null) {
            inputStream.close();
        }
        if (in != null) {
            in.close();
        }
        return StringEnum.HTTPS_PREFIX.getCode() + ConstantProperties.ALIOSS_BUCKET_NAME + "." + ConstantProperties.ALIOSS_END_POINT + "/" + fileUrl;
    }

    @Override
    public String uploadFile(String filename,byte[] bytes) throws Exception {
        // 创建OSSClient实例。
        OSSClient ossClient = new OSSClient(ConstantProperties.ALIOSS_END_POINT,
                ConstantProperties.ALIOSS_ACCESS_KEY_ID, ConstantProperties.ALIOSS_ACCESS_KEY_SECRET);
        String dateStr = format.format(new Date());
        //创建文件路径
        String fileUrl = ConstantProperties.ALIOSS_FILE_HOST+"/"+(dateStr + "/" + UUID.randomUUID().toString().replace("-","") + "_" + filename);
        long l = System.currentTimeMillis();
        ossClient.putObject(new PutObjectRequest(ConstantProperties.ALIOSS_BUCKET_NAME, fileUrl,new ByteArrayInputStream(bytes)).
                <PutObjectRequest>withProgressListener(new PutObjectProgressListener(null,0)));

        return StringEnum.HTTPS_PREFIX.getCode() + ConstantProperties.ALIOSS_BUCKET_NAME + "." + ConstantProperties.ALIOSS_END_POINT + "/" + fileUrl;
    }

    @Override
    public InputStream getInputStream(String url) {
        try {
            HttpURLConnection connection = (HttpURLConnection) new URL(url).openConnection();
            connection.setReadTimeout(5000);
            connection.setConnectTimeout(5000);
            connection.setRequestMethod("GET");
            if (connection.getResponseCode() == HttpURLConnection.HTTP_OK) {
                return connection.getInputStream();
            }
        } catch (IOException e) {
            System.out.println("获取网络图片出现异常，图片路径为：" + url);
            e.printStackTrace();
        }
        return null;

    }

}
