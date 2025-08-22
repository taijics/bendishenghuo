/*
 * Copyright (C) 2017-2021
 * All rights reserved, Designed By 深圳中科鑫智科技有限公司
 * Copyright authorization contact 18814114118
 */
package com.shop.cereshop.business.service.order.impl;

import cn.hutool.core.date.DateUtil;
import cn.hutool.json.JSONUtil;
import com.shop.cereshop.business.dao.buyer.CereBuyerUserDAO;
import com.shop.cereshop.business.dao.order.CereOrderDileverDAO;
import com.shop.cereshop.business.dao.order.CereShopOrderDAO;
import com.shop.cereshop.business.message.service.miaoxin.MiaoxinMessageService;
import com.shop.cereshop.business.page.order.ShopOrder;
import com.shop.cereshop.business.param.after.AfterIdParam;
import com.shop.cereshop.business.param.order.OrderDileveryParam;
import com.shop.cereshop.business.param.order.applet.*;
import com.shop.cereshop.business.pay.weixin.skd.Tools;
import com.shop.cereshop.business.redis.service.api.StringRedisService;
import com.shop.cereshop.business.service.after.CereAfterDileverService;
import com.shop.cereshop.business.service.after.CereOrderAfterService;
import com.shop.cereshop.business.service.dict.CerePlatformDictService;
import com.shop.cereshop.business.service.log.CerePlatformLogService;
import com.shop.cereshop.business.service.notice.CereNoticeService;
import com.shop.cereshop.business.service.order.CereOrderDileverService;
import com.shop.cereshop.business.service.order.CereShopOrderService;
import com.shop.cereshop.business.service.redis.CereRedisKeyServcice;
import com.shop.cereshop.commons.constant.IntegerEnum;
import com.shop.cereshop.commons.constant.StringEnum;
import com.shop.cereshop.commons.domain.after.CereAfterDilever;
import com.shop.cereshop.commons.domain.after.CereOrderDilever;
import com.shop.cereshop.commons.domain.business.CerePlatformBusiness;
import com.shop.cereshop.commons.domain.buyer.CereBuyerUser;
import com.shop.cereshop.commons.domain.dict.CerePlatformDict;
import com.shop.cereshop.commons.domain.notice.CereNotice;
import com.shop.cereshop.commons.domain.order.CereShopOrder;
import com.shop.cereshop.commons.domain.pay.CerePayLog;
import com.shop.cereshop.commons.exception.CoBusinessException;
import com.shop.cereshop.commons.utils.HttpUtils;
import com.shop.cereshop.commons.utils.TimeUtils;
import lombok.extern.slf4j.Slf4j;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.CollectionUtils;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Objects;

@Slf4j
@Service
public class CereOrderDileverServiceImpl implements CereOrderDileverService {

    @Autowired
    private CereOrderDileverDAO cereOrderDileverDAO;

    @Autowired
    private CerePlatformLogService cerePlatformLogService;

    @Autowired
    private CereRedisKeyServcice cereRedisKeyServcice;

    @Autowired
    private StringRedisService stringRedisService;

    @Autowired
    private CereShopOrderService cereShopOrderService;

    @Autowired
    private CereAfterDileverService cereAfterDileverService;

    @Autowired
    private CereNoticeService cereNoticeService;

    @Autowired
    private CereOrderAfterService cereOrderAfterService;

    @Autowired
    private MiaoxinMessageService miaoxinMessageService;

    @Autowired
    private CereShopOrderDAO cereShopOrderDAO;

    @Autowired
    private CerePlatformDictService cerePlatformDictService;

    @Autowired
    private CereBuyerUserDAO cereBuyerUserDAO;


    @Value("${autoDeliveryTime}")
    private Long autoDeliveryTime;

    @Value("${weixin.appid}")
    private String appid;


    @Value("${weixin.secret}")
    private String secret;


    @Override
    @Transactional(isolation= Isolation.DEFAULT,propagation= Propagation.REQUIRED,rollbackFor = {CoBusinessException.class, Exception.class})
    public void dilevery(OrderDileveryParam param, CerePlatformBusiness user) throws CoBusinessException,Exception {
        String time = TimeUtils.yyMMddHHmmss();
        CereOrderDilever cereOrderDilever = new CereOrderDilever();
        cereOrderDilever.setOrderId(param.getOrderId());
        cereOrderDilever.setExpress(param.getExpress());
        cereOrderDilever.setDeliverFormid(param.getDeliverFormid());
        cereOrderDilever.setCreateTime(time);
        cereOrderDileverDAO.insert(cereOrderDilever);
        //更新订单状态为待收货
        CereShopOrder cereShopOrder = cereShopOrderService.findById(param.getOrderId());
        cereShopOrder.setOrderId(param.getOrderId());
        cereShopOrder.setState(IntegerEnum.ORDER_HAVE_DILEVERY.getCode());
        cereShopOrderService.updateState(cereShopOrder);
        //新增日志
        cerePlatformLogService.addLog(user, "订单管理", "商户端操作", "发货", cereOrderDilever.getOrderId(), time);
        //新增自动15天确认收货定时任务
        stringRedisService.set(StringEnum.ORDER_CONFIRM_DILEVERY.getCode()+"-"+param.getOrderId(),1,15*24*60*60*1000);
        cereRedisKeyServcice.add(StringEnum.ORDER_CONFIRM_DILEVERY.getCode()+"-"+param.getOrderId(),TimeUtils.getMoreDayAfter(time,15));

        long deliveryTime = 7 * 24 * 3600 * 1000L;
        if (autoDeliveryTime != null) {
            deliveryTime = autoDeliveryTime;
        }
        Date endTime = new Date(TimeUtils.parseDate(time).getTime() + deliveryTime);
        //如果订单申请了退款或者退货，并且在流程中，则不做自动确认收货
        List<Integer> afterStateList = cereOrderAfterService.selectAfterStateList(param.getOrderId());
        boolean containAllStateFree = IntegerEnum.CONFIRM_DELIVERY_AFTER_STATE_LIST.containsAll(afterStateList);
        if (CollectionUtils.isEmpty(afterStateList) || containAllStateFree) {
            stringRedisService.set(StringEnum.ORDER_CONFIRM_DILEVERY.getCode() + "-" + param.getOrderId(), 1, deliveryTime);
            cereRedisKeyServcice.add(StringEnum.ORDER_CONFIRM_DILEVERY.getCode() + "-" + param.getOrderId(), Tools.date2Str(endTime));
            log.info("add ORDER_CONFIRM_DILEVERY Redis Message key = {}", StringEnum.ORDER_CONFIRM_DILEVERY.getCode() + "-" + param.getOrderId());
        }

        //新增订单已完成消息
        CereNotice cereNotice = new CereNotice();
        cereNotice.setNoticeType(IntegerEnum.NOTICE_TYPE_SYSTEM.getCode());
        cereNotice.setJump(IntegerEnum.NOTICE_JUMP_ORDER.getCode());
        cereNotice.setBuyerUserId(cereShopOrder.getBuyerUserId());
        cereNotice.setShopId(cereShopOrder.getShopId());
        cereNotice.setReceive(3);
        cereNotice.setNoticeTitle(StringEnum.NOTICE_TITLE_ORDER_DELIVERY.getCode());
        cereNotice.setNoticeContent("您购买的" + cereShopOrder.getOrderFormid() + "商家已发货，点击查看物流详情");
        cereNotice.setOnly(cereShopOrder.getOrderId());
        cereNotice.setCreateTime(time);
        cereNotice.setIfRead(IntegerEnum.NO.getCode());
        cereNoticeService.insert(cereNotice);

        //发送短信
        if (StringUtils.isNotBlank(cereShopOrder.getCustomerPhone()) && cereShopOrder.getCustomerPhone().equals("15986612770")) {
            miaoxinMessageService.sendContent(cereShopOrder.getCustomerPhone(), "您订购的商品已发货，宝贝快马加鞭的奔向您，请注意查收！海觅海淘竭诚为您服务！【海觅SeaMee】");
        }
//        //查询快递公司
//        CerePlatformDict express = cerePlatformDictService.getExpressSelect().stream().filter(it -> Objects.equals(it.getDictId(), param.getExpress())).findAny().get();
//
//        //发送小程序发货通知
//        ShopOrder order = cereShopOrderService.getById(null, param.getOrderId());
//        CerePayLog cerePayLog = cereShopOrderDAO.findPayLog(order.getOrderFormid());
//        if (cerePayLog.getOutTradeNo().contains("XCX")) {
//            //发送小程序通知
//            String token = HttpUtils.getAppletNoticeToken(appid, secret);
//            TokenResult result = JSONUtil.toBean(token, TokenResult.class);
//            AppletNoticeDto appletNoticeDto = new AppletNoticeDto();
//            OrderKey orderKey = new OrderKey(2, cerePayLog.getTransactionId());
//            List<ShippingList> list = new ArrayList<>();
//            ShippingList shippingList = new ShippingList();
//
//            shippingList.setContact(new Contact("", ""));
//            String desc = "";
//            if (order.getProducts().size() <= 1) {
//                desc = order.getProducts().get(0).getProductName();
//            } else {
//                desc = order.getProducts().get(0).getProductName() + "等";
//            }
//            shippingList.setItem_desc(desc);
//            shippingList.setExpress_company(express.getDictDescribe());
//            shippingList.setTracking_no(param.getDeliverFormid());
//            list.add(shippingList);
//            appletNoticeDto.setOrder_key(orderKey);
//            appletNoticeDto.setDelivery_mode(1);
//            appletNoticeDto.setLogistics_type(1);
//            appletNoticeDto.setUpload_time(DateUtil.format(new Date(), "yyyy-MM-dd'T'HH:mm:ssXXX"));
//            CereBuyerUser buyerUser = cereBuyerUserDAO.selectByPrimaryKey(order.getBuyerUserId());
//            appletNoticeDto.setPayer(new Payer(buyerUser.getWechatOpenId()));
//            appletNoticeDto.setShipping_list(list);
//            assert result != null;
//            String res = HttpUtils.sendAppletNotice(result.getAccess_token(), JSONUtil.toJsonStr(appletNoticeDto));
//            log.info("发送小程序通知结果{}",res);
//        }
    }

    @Override
    @Transactional(isolation= Isolation.DEFAULT,propagation= Propagation.REQUIRED,rollbackFor = {CoBusinessException.class, Exception.class})
    public void refundDilevery(AfterIdParam param,CerePlatformBusiness user) throws CoBusinessException,Exception {
        String time= TimeUtils.yyMMddHHmmss();
        CereAfterDilever cereAfterDilever=new CereAfterDilever();
        cereAfterDilever.setCreateTime(time);
        cereAfterDilever.setExpress(param.getExpress());
        cereAfterDilever.setDeliverFormid(param.getDeliverFormid());
        cereAfterDilever.setOrderId(param.getOrderId());
    //    cereAfterDilever.setAfterId(param.getAfterId());
        cereAfterDileverService.insert(cereAfterDilever);
        //更新订单状态为待收货
//        CereShopOrder cereShopOrder=new CereShopOrder();
//        cereShopOrder.setOrderId(param.getOrderId());
//        cereShopOrder.setState(IntegerEnum.ORDER_HAVE_DILEVERY.getCode());
//        cereShopOrderService.updateState(cereShopOrder);
        //新增日志
        cerePlatformLogService.addLog(user,"售后管理","商户端操作","仅退款发货",param.getAfterId(),time);
        //新增自动15天确认收货定时任务
//        stringRedisService.set(StringEnum.ORDER_CONFIRM_DILEVERY.getCode()+"-"+param.getOrderId(),1,15*24*60*60*1000);
//        cereRedisKeyServcice.add(StringEnum.ORDER_CONFIRM_DILEVERY.getCode()+"-"+param.getOrderId(),TimeUtils.getMoreDayAfter(time,15));
    }


    private static String getAppletNoticeToken(String appid, String secret) throws IOException {
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

}
