package com.shop.cereshop.business.config;

import cn.binarywang.wx.miniapp.api.WxMaService;
import cn.binarywang.wx.miniapp.api.impl.WxMaServiceHttpClientImpl;
import cn.binarywang.wx.miniapp.config.impl.WxMaDefaultConfigImpl;
import com.shop.cereshop.commons.constant.WxCpConstants;
import com.shop.cereshop.commons.utils.third.WxLiveUtil;
import me.chanjar.weixin.cp.api.WxCpUserService;
import me.chanjar.weixin.cp.api.impl.WxCpServiceImpl;
import me.chanjar.weixin.cp.api.impl.WxCpUserServiceImpl;
import me.chanjar.weixin.cp.config.WxCpConfigStorage;
import me.chanjar.weixin.cp.config.impl.WxCpDefaultConfigImpl;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class WxServiceConfig {

    @Autowired
    private WxWorkProperties wxWorkProperties;

    @Autowired
    private WxAppletProperties wxAppletProperties;

    //private WxCpTpService wxCpTpService;

    private WxCpServiceImpl wxCpService;

    private WxMaService wxMaService;

    /*private WxCpTpDefaultConfigImpl cpTpDefaultConfig;*/

    private WxCpDefaultConfigImpl config;

    /*@Bean
    public WxCpTpService getWxCpTpService() {
        if (wxCpTpService == null) {
            wxCpTpService = new WxCpTpServiceApacheHttpClientImpl();
            wxCpTpService.setWxCpTpConfigStorage(wxCpTpConfigStorage());
        }
        return wxCpTpService;
    }*/

    @Bean
    public WxCpServiceImpl getWxCpServiceImpl(){
        if (wxCpService == null) {
            wxCpService = new WxCpServiceImpl();
            wxCpService.setWxCpConfigStorage(wxCpConfigStorage());
        }
        return wxCpService;
    }

    @Bean
    public WxCpUserService getWxCpUserService() {
        return new WxCpUserServiceImpl(getWxCpServiceImpl());
    }

    @Bean
    public WxMaService getWxMaService() {
        if (wxMaService == null) {
            wxMaService = new WxMaServiceHttpClientImpl();
            WxMaDefaultConfigImpl wxMaConfig = new WxMaDefaultConfigImpl();
            wxMaConfig.setAppid(wxAppletProperties.getAppid());
            wxMaConfig.setSecret(wxAppletProperties.getSecret());
            wxMaService.setWxMaConfig(wxMaConfig);
        }
        return wxMaService;
    }

    @Bean
    public WxLiveUtil getWxLiveUtil() {
        return new WxLiveUtil(getWxMaService());
    }

    /*@Bean
    public WxCpTpConfigStorage wxCpTpConfigStorage() {
        if (cpTpDefaultConfig == null) {
            cpTpDefaultConfig = new WxCpTpDefaultConfigImpl();
            cpTpDefaultConfig.setBaseApiUrl(WxCpConstants.QY_API);
            BeanUtils.copyProperties(wxWorkProperties, cpTpDefaultConfig);
        }
        return cpTpDefaultConfig;
    }*/

    @Bean
    public WxCpConfigStorage wxCpConfigStorage() {
        if (config == null) {
            config = new WxCpDefaultConfigImpl();
            config.setBaseApiUrl(WxCpConstants.QY_API);
            BeanUtils.copyProperties(wxWorkProperties, config);
        }
        return config;
    }

}
