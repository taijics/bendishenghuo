/*
 * Copyright (C) 2017-2021
 * All rights reserved, Designed By 深圳中科鑫智科技有限公司
 * Copyright authorization contact 18814114118
 */
package com.shop.cereshop.business.controller;

import cn.binarywang.wx.miniapp.api.WxMaService;
import cn.hutool.core.util.IdUtil;
import com.shop.cereshop.business.alioss.page.Url;
import com.shop.cereshop.business.redis.service.api.StringRedisService;
import com.shop.cereshop.business.service.customer_service.CereCustomerServiceConfigService;
import com.shop.cereshop.commons.constant.CoReturnFormat;
import com.shop.cereshop.commons.domain.upload.UploadResult;
import com.shop.cereshop.commons.result.Result;
import com.shop.cereshop.commons.upload.strategy.FileStrategy;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
import me.chanjar.weixin.common.api.WxConsts;
import me.chanjar.weixin.common.bean.result.WxMediaUploadResult;
import me.chanjar.weixin.common.error.WxErrorException;
import me.chanjar.weixin.cp.api.impl.WxCpServiceImpl;
import org.apache.commons.io.FilenameUtils;
import org.apache.poi.util.IOUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import java.io.*;

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

    /*@Autowired
    private WxCpMediaService wxCpMediaService;*/

    @Autowired
    private WxMaService wxMaService;

    //@Autowired
    //private WxCpTpService wxCpTpService;

    @Autowired
    private StringRedisService stringRedisService;

    @Autowired
    private CereCustomerServiceConfigService cereCustomerServiceConfigService;

    @Autowired
    private WxCpServiceImpl wxCpServiceImpl;

    /**
     * 文件上传
     * @param file
     */
    @PostMapping("upload")
    @ApiOperation(value = "文件上传")
    public Result<Url> upload(MultipartFile file) throws Exception{
        Result result=new Result();
        try {
            if(null != file){
                if(file.getOriginalFilename().contains("mp4")){
                    //如果上传的视频,校验大小不能超过2M
                    /*if(file.getSize()>2048*1024){
                        return new Result(CoReturnFormat.MP4_FILE_NOT_2M);
                    }*/
                }
                String url=fileStrategy.upload(file);
                result=new Result(new Url(url));
            }
            return result;
        } catch (Exception e) {
            log.error(e.getMessage(), e);
        }
        return null;
    }

    /**
     * 企业微信媒体-文件上传
     * @param file
     */
    @PostMapping("uploadQyMedia")
    @ApiOperation(value = "企业微信-文件上传")
    public Result<UploadResult> uploadWorkMedia(MultipartFile file, HttpServletRequest request) throws Exception {
        Result<UploadResult> result=new Result<>();
        if(null != file){
            try {
                String fileName = file.getOriginalFilename();
                log.info("fileName: {}", fileName);

                InputStream inputStream = file.getInputStream();
                ByteArrayOutputStream baos = cloneInputStream(file.getInputStream());

                WxMediaUploadResult uploadMediaResult = wxCpServiceImpl.getMediaService().upload(WxConsts.MediaFileType.IMAGE, transferToFile(file, fileName));
                if (uploadMediaResult.getMediaId() != null) {
                    UploadResult data = new UploadResult();
                    data.setMediaId(uploadMediaResult.getMediaId());

                    String url = fileStrategy.uploadStream(fileName, IOUtils.toByteArray(new ByteArrayInputStream(baos.toByteArray())), new ByteArrayInputStream(baos.toByteArray()), inputStream.available());
                    data.setUrl(url);

                    result.setData(data);
                    result.setCode(CoReturnFormat.SUCCESS);
                    return result;
                }
            } catch (Exception e) {
                log.error("uploadWorkMedia: " + e.getMessage(), e);
            }
        }
        return result;
    }

    /**
     * 微信媒体(当前配置小程序)-文件上传
     * @param file
     */
    @PostMapping("uploadWxMedia")
    @ApiOperation(value = "微信-文件上传")
    public Result<UploadResult> uploadWxMedia(MultipartFile file) throws Exception {
        Result<UploadResult> result=new Result<>();
        if(null != file){
            try {
                String fileName = file.getOriginalFilename();
                log.info("fileName: {}", fileName);

                InputStream inputStream = file.getInputStream();
                int available = inputStream.available();
                String ext = FilenameUtils.getExtension(fileName);
                ByteArrayOutputStream baos = cloneInputStream(file.getInputStream());

                assert fileName != null;
                WxMediaUploadResult uploadMediaResult = wxMaService.getMediaService().uploadMedia(WxConsts.MediaFileType.IMAGE, ext, inputStream);
                if (uploadMediaResult.getMediaId() != null) {
                    UploadResult data = new UploadResult();
                    data.setMediaId(uploadMediaResult.getMediaId());

                    if (baos != null) {
                        String url = fileStrategy.uploadStream(fileName, IOUtils.toByteArray(new ByteArrayInputStream(baos.toByteArray())),
                                new ByteArrayInputStream(baos.toByteArray()), available);
                        data.setUrl(url);
                    }

                    result.setData(data);
                    result.setCode(CoReturnFormat.SUCCESS);
                    return result;
                }
            } catch (Exception e) {
                log.error("uploadWxMedia: " + e.getMessage(), e);
            }
        }
        return result;
    }

    /*@PostMapping("uploadImg")
    @ApiOperation(value = "上传客服头像")
    public Result<String> updateImg(MultipartFile multipartFile) {
        //获取当前登录账户
        *//*CerePlatformBusiness user = (CerePlatformBusiness) request.getAttribute("user");
        param.setShopId(user.getShopId())*//*;
        //cereCustomerServiceService.save(param);

        try {
            String fileName = multipartFile.getOriginalFilename();
            log.info("fileName: {}", fileName);
            WxMediaUploadResult uploadResult = wxCpTpMediaService.upload(WxConsts.MediaFileType.IMAGE, transferToFile(multipartFile), "ww6f05330db97eb85a");
            if (uploadResult.getMediaId() != null) {
                return new Result(uploadResult.getMediaId());
            }
        } catch (Exception e) {
            log.error("uploadImg: " + e.getMessage(), e);
        }
        return new Result<>("");
    }*/

    private File transferToFile(MultipartFile multipartFile, String fileName) {
        File file = null;
        try {
            //String originalFilename = multipartFile.getOriginalFilename();
            String[] filename = fileName.split("\\.");
            file= File.createTempFile(IdUtil.simpleUUID(), filename[1]);
            multipartFile.transferTo(file);
            file.deleteOnExit();
        } catch (IOException e) {
            e.printStackTrace();
        }
        return file;
    }

    private static ByteArrayOutputStream cloneInputStream(InputStream input) {
        try {
            ByteArrayOutputStream baos = new ByteArrayOutputStream();
            byte[] buffer = new byte[1024];
            int len;
            while ((len = input.read(buffer)) > -1) {
                baos.write(buffer, 0, len);
            }
            baos.flush();
            return baos;
        } catch (IOException e) {
            e.printStackTrace();
            return null;
        }
    }

    /**
     * 查询授权corpId
     * @param request
     * @return
     */
    private String getCorpId(HttpServletRequest request) throws WxErrorException {
        /*CerePlatformBusiness user = (CerePlatformBusiness) request.getAttribute("user");
        String suiteTicket = (String)stringRedisService.get(WxCpConstants.SUITE_TICKET_KEY);
        wxCpTpService.setSuiteTicket(suiteTicket);

        CereCustomerServiceConfig config = cereCustomerServiceConfigService.getByShopId(user.getShopId());
        String authCorpId = config.getAuthCorpId();
        String permanentCode = config.getPermanentCode();

        WxAccessToken accessToken = wxCpTpService.getCorpToken(authCorpId, permanentCode, false);
        log.info("accessToken: {}", accessToken.getAccessToken());*/
        return null;
    }
}
