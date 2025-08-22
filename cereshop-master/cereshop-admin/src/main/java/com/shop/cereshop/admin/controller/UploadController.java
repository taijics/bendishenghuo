/*
 * Copyright (C) 2017-2021
 * All rights reserved, Designed By 深圳中科鑫智科技有限公司
 * Copyright authorization contact 18814114118
 */
package com.shop.cereshop.admin.controller;

import com.shop.cereshop.admin.alioss.page.Url;
import com.shop.cereshop.admin.alioss.service.FileUploadService;
import com.shop.cereshop.commons.constant.CoReturnFormat;
import com.shop.cereshop.commons.exception.CoBusinessException;
import com.shop.cereshop.commons.result.Result;
import com.shop.cereshop.commons.upload.strategy.FileStrategy;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

/**
 * 文件上传
 */
@RestController
@RequestMapping("file")
/**
 * 注解方式生成日志对象，指定topic生成对象类名
 */
@Slf4j(topic = "UploadController")
@Api(value = "文件上传", tags = "文件上传")
public class UploadController {

    @Autowired
    private FileStrategy fileStrategy;

    /**
     * 文件上传
     * @param file
     */
    @PostMapping("upload")
    @ApiOperation(value = "文件上传")
    public Result<Url> upload(MultipartFile file) throws Exception{
        Result result=new Result();
        if(null != file){
            if(file.getOriginalFilename().contains("mp4")){
                //如果上传的视频,校验大小不能超过2M
                if(file.getSize()>2048*1024){
                    return new Result(CoReturnFormat.MP4_FILE_NOT_2M);
                }
            }
            String url=fileStrategy.upload(file);
            result=new Result(new Url(url));
        }
        return result;
    }
}
