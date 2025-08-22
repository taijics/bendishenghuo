/*
 * Copyright (C) 2017-2021
 * All rights reserved, Designed By 深圳中科鑫智科技有限公司
 * Copyright authorization contact 18814114118
 */
package com.shop.cereshop.business.controller;

import com.shop.cereshop.business.annotation.NoRepeatSubmit;
import com.shop.cereshop.business.annotation.NoRepeatWebLog;
import com.shop.cereshop.business.page.after.After;
import com.shop.cereshop.business.page.after.AfterExportDTO;
import com.shop.cereshop.business.param.after.AfterGetAllParam;
import com.shop.cereshop.business.param.after.AfterGetByIdParam;
import com.shop.cereshop.business.param.after.AfterIdParam;
import com.shop.cereshop.business.pay.weixin.skd.HttpKit;
import com.shop.cereshop.business.pay.weixin.skd.PaymentKit;
import com.shop.cereshop.business.service.after.CereOrderAfterService;
import com.shop.cereshop.business.service.order.CereOrderDileverService;
import com.shop.cereshop.business.utils.ContextUtil;
import com.shop.cereshop.commons.constant.IntegerEnum;
import com.shop.cereshop.commons.constant.StringEnum;
import com.shop.cereshop.commons.domain.business.CerePlatformBusiness;
import com.shop.cereshop.commons.domain.common.Page;
import com.shop.cereshop.commons.enums.AfterTypeEnum;
import com.shop.cereshop.commons.enums.OrderStateEnum;
import com.shop.cereshop.commons.exception.CoBusinessException;
import com.shop.cereshop.commons.poi.export.ExcelExportUtils;
import com.shop.cereshop.commons.result.Result;
import com.shop.cereshop.commons.utils.EmptyUtils;
import com.shop.cereshop.commons.utils.GsonUtil;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * 售后
 */
@RestController
@RequestMapping("after")
/**
 * 注解方式生成日志对象，指定topic生成对象类名
 */
@Slf4j(topic = "AfterController")
@Api(value = "售后模块", tags = "售后模块")
public class AfterController {

    @Autowired
    private CereOrderAfterService cereOrderAfterService;

    @Autowired
    private CereOrderDileverService cereOrderDileverService;

    /**
     * 商户秘钥
     */
    @Value("${weixin.key}")
    private String key;

    /**
     * 售后管理查询
     * @param param
     * @return
     */
    @PostMapping(value = "getAll")
    @ApiOperation(value = "售后管理查询")
    public Result<Page<After>> getAll(@RequestBody AfterGetAllParam param) throws CoBusinessException{
        param.setShopId(ContextUtil.getShopId());
        Page page=cereOrderAfterService.getAll(param);
        return new Result(page);
    }

    /**
     * 售后详情查询
     * @param param
     * @return
     */
    @PostMapping(value = "getById")
    @ApiOperation(value = "售后详情查询")
    public Result<After> getById(@RequestBody AfterGetByIdParam param) throws CoBusinessException{
        After after=cereOrderAfterService.getById(param.getAfterId());
        return new Result(after);
    }

    /**
     * 仅退款同意退款申请
     * @param param
     * @return
     */
    @PostMapping(value = "refundSuccess")
    @NoRepeatSubmit
    @ApiOperation(value = "仅退款同意退款申请")
    @NoRepeatWebLog
    public Result refundSuccess(@RequestBody AfterIdParam param, HttpServletRequest request) throws CoBusinessException,Exception{
        //获取当前登录账户
        CerePlatformBusiness user = (CerePlatformBusiness) request.getAttribute("user");
        cereOrderAfterService.refundSuccess(param,user);
        return new Result(user.getUsername(),"仅退款同意退款申请", GsonUtil.objectToGson(param));
    }

    /**
     * 仅退款拒绝退款申请
     * @param param
     * @return
     */
    @PostMapping(value = "refundRefuse")
    @NoRepeatSubmit
    @ApiOperation(value = "仅退款拒绝退款申请")
    @NoRepeatWebLog
    public Result refundRefuse(@RequestBody AfterIdParam param, HttpServletRequest request) throws CoBusinessException,Exception{
        //获取当前登录账户
        CerePlatformBusiness user = (CerePlatformBusiness) request.getAttribute("user");
        cereOrderAfterService.refundRefuse(param,user);
        return new Result(user.getUsername(),"仅退款拒绝退款申请", GsonUtil.objectToGson(param));
    }

    /**
     * 仅退款发货
     * @param param
     * @return
     */
    @PostMapping(value = "refundDilevery")
    @NoRepeatSubmit
    @ApiOperation(value = "仅退款发货")
    @NoRepeatWebLog
    public Result dilevery(@RequestBody AfterIdParam param, HttpServletRequest request) throws CoBusinessException,Exception{
        //获取当前登录账户
        CerePlatformBusiness user = (CerePlatformBusiness) request.getAttribute("user");
        cereOrderDileverService.refundDilevery(param,user);
        return new Result(user.getUsername(),"仅退款发货", GsonUtil.objectToGson(param));
    }

    /**
     * 退货退款同意
     * @param param
     * @return
     */
    @PostMapping(value = "success")
    @NoRepeatSubmit
    @ApiOperation(value = "退货退款同意")
    @NoRepeatWebLog
    public Result success(@RequestBody AfterIdParam param, HttpServletRequest request) throws CoBusinessException{
        //获取当前登录账户
        CerePlatformBusiness user = (CerePlatformBusiness) request.getAttribute("user");
        cereOrderAfterService.success(param,user);
        return new Result(user.getUsername(),"退货退款同意", GsonUtil.objectToGson(param));
    }

    /**
     * 退货退款拒绝
     * @param param
     * @return
     */
    @PostMapping(value = "refuse")
    @NoRepeatSubmit
    @ApiOperation(value = "退货退款拒绝")
    @NoRepeatWebLog
    public Result refuse(@RequestBody AfterIdParam param, HttpServletRequest request) throws CoBusinessException,Exception{
        //获取当前登录账户
        CerePlatformBusiness user = (CerePlatformBusiness) request.getAttribute("user");
        cereOrderAfterService.refuse(param,user);
        return new Result(user.getUsername(),"退货退款拒绝", GsonUtil.objectToGson(param));
    }

    /**
     * 退货退款确认收货且退款
     * @param param
     * @return
     */
    @PostMapping(value = "confirmAndRefund")
    @NoRepeatSubmit
    @ApiOperation(value = "退货退款确认收货且退款")
    @NoRepeatWebLog
    public Result confirmAndRefund(@RequestBody AfterIdParam param, HttpServletRequest request) throws CoBusinessException,Exception{
        //获取当前登录账户
        CerePlatformBusiness user = (CerePlatformBusiness) request.getAttribute("user");
        cereOrderAfterService.confirmAndRefund(param,user);
        return new Result(user.getUsername(),"退货退款确认收货且退款", GsonUtil.objectToGson(param));
    }

    /**
     * 退货退款货物有损拒绝退款
     * @param param
     * @return
     */
    @PostMapping(value = "damaging")
    @NoRepeatSubmit
    @ApiOperation(value = "退货退款货物有损拒绝退款")
    @NoRepeatWebLog
    public Result damaging(@RequestBody AfterIdParam param, HttpServletRequest request) throws CoBusinessException{
        //获取当前登录账户
        CerePlatformBusiness user = (CerePlatformBusiness) request.getAttribute("user");
        cereOrderAfterService.damaging(param,user);
        return new Result(user.getUsername(),"退货退款货物有损拒绝退款", GsonUtil.objectToGson(param));
    }

    /**
     * 退款回调
     * @param request
     * @param response
     * @throws Exception
     */
    @PostMapping(value={"pay/rolBack"})
    public void wxProPayNotify(HttpServletRequest request, HttpServletResponse response) throws Exception {
        log.info("进入售后退款回调");
        System.out.println("进入售后退款回调");
        String xmlMsg = HttpKit.readData(request);
        log.info("微信小程序通知信息"+xmlMsg);
        System.out.println("微信小程序通知信息"+xmlMsg);
        Map<String, String> resultMap = PaymentKit.xmlToMap(xmlMsg);
        if(!EmptyUtils.isEmpty(resultMap)){
            //获取微信返回数据进行解密
            String req_info = resultMap.get("req_info");
            String str= EmptyUtils.decryption(req_info,key);
            log.info("解密后数据:"+str);
            System.out.println("解密后数据:"+str);
            Map<String, String> map = PaymentKit.xmlToMap(str);
            String orderNo = map.get("out_trade_no");
            log.info("回调out_trade_no="+orderNo);
            if(resultMap.get(StringEnum.WX_RETURN_CODE.getCode()).equals(StringEnum.WX_PAY_SUCCESS.getCode())){
                log.info("售后退款回调成功");
                cereOrderAfterService.handleRefundSuc(map.get("out_refund_no"),map.get("transaction_id"),orderNo, IntegerEnum.ORDER_PAY_WX.getCode());
            }else {
                //退款失败,修改售后单状态为退款失败
                cereOrderAfterService.refundError(map.get("out_refund_no"));
            }
        }else {
            log.info("map为null");
        }
        String result = "<xml><return_code><![CDATA[SUCCESS]]></return_code><return_msg><![CDATA[OK]]></return_msg></xml>";
        response.getWriter().write(result);
    }

    /**
     * 售后管理导出
     * @param param
     * @return
     */
    @PostMapping(value = "export")
    @ApiOperation(value = "售后管理导出")
    public void export(@RequestBody AfterGetAllParam param, HttpServletRequest request, HttpServletResponse response) throws CoBusinessException{
        param.setShopId(ContextUtil.getShopId());
        Page<After> page=cereOrderAfterService.getAll(param);
        List<AfterExportDTO> list = page.getList().stream().map(s -> {
            AfterExportDTO afterExportDTO = new AfterExportDTO();
            afterExportDTO.setAfterId(s.getAfterId());
            afterExportDTO.setAfterType(AfterTypeEnum.getMsgByCode(s.getAfterType()));
            afterExportDTO.setAfterFormid(s.getAfterFormid());
            afterExportDTO.setAfterProductNames(s.getAfterProductNames());
            afterExportDTO.setCustomerName(s.getCustomerName());
            afterExportDTO.setOrderId(s.getOrderId());
            afterExportDTO.setNumber(s.getNumber());
            afterExportDTO.setAfterState(s.getAfterStateName());
            afterExportDTO.setApplyTime(s.getCreateTime());
            afterExportDTO.setLastAfterTime(s.getLastAfterTime());
            afterExportDTO.setOrderState(OrderStateEnum.getMsgByCode(s.getOrderState()));
            afterExportDTO.setRefundMoney(s.getRefundMoney());
            afterExportDTO.setRemark(s.getRemark());
            return afterExportDTO;
        }).collect(Collectors.toList());
        //定义导出的excel名字
        String excelName = "售后订单列表";
        ExcelExportUtils.exportExcel(request,response,excelName,list, AfterExportDTO.class);
    }
}
