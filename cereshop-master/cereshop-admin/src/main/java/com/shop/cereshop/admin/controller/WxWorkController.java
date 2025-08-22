package com.shop.cereshop.admin.controller;

import com.alibaba.fastjson.JSON;
import com.shop.cereshop.admin.annotation.NoRepeatSubmit;
import com.shop.cereshop.admin.annotation.NoRepeatWebLog;
import com.shop.cereshop.admin.config.WxWorkProperties;
import com.shop.cereshop.admin.dao.customer_service.CereCustomerServiceConfigDAO;
import com.shop.cereshop.admin.pay.weixin.skd.IOUtils;
import com.shop.cereshop.admin.pay.weixin.skd.PaymentKit;
import com.shop.cereshop.admin.redis.service.api.StringRedisService;
import com.shop.cereshop.admin.third.weixin.WXBizMsgCrypt;
import com.shop.cereshop.admin.utils.ContextUtil;
import com.shop.cereshop.commons.constant.WxCpConstants;
import com.shop.cereshop.commons.utils.TimeUtils;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
import me.chanjar.weixin.common.api.WxConsts;
import me.chanjar.weixin.common.bean.WxAccessToken;
import me.chanjar.weixin.cp.api.WxCpKfService;
import me.chanjar.weixin.cp.api.impl.WxCpServiceImpl;
import me.chanjar.weixin.cp.bean.WxCpTpPermanentCodeInfo;
import me.chanjar.weixin.cp.bean.kf.*;
import me.chanjar.weixin.cp.bean.kf.msg.WxCpKfEventMsg;
import me.chanjar.weixin.cp.bean.kf.msg.WxCpKfTextMsg;
import me.chanjar.weixin.cp.bean.message.WxCpTpXmlMessage;
import me.chanjar.weixin.cp.constant.WxCpTpConsts;
import me.chanjar.weixin.cp.tp.service.WxCpTpService;
import me.chanjar.weixin.cp.util.crypto.WxCpCryptUtil;
import me.chanjar.weixin.cp.util.crypto.WxCpTpCryptUtil;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.nio.charset.StandardCharsets;
import java.util.Map;

import static com.shop.cereshop.commons.constant.WxCpConstants.MSG_CURSOR;

/**
 * 企业微信对接模块
 */
@RestController
@RequestMapping("wxWork")
/**
 * 注解方式生成日志对象，指定topic生成对象类名
 */
@Slf4j(topic = "WxWorkController")
@Api(value = "企业微信对接模块", tags = "企业微信对接模块")
public class WxWorkController {

    @Autowired
    private WxWorkProperties wxWorkProperties;

    @Autowired
    private WxCpTpService wxCpTpService;

    @Autowired
    private WxCpServiceImpl wxCpService;

    @Autowired
    private CereCustomerServiceConfigDAO cereCustomerServiceConfigDAO;

    @Autowired
    private StringRedisService stringRedisService;

    /**
     * 回调
     *
     * @return
     */
    @RequestMapping(value = "callback", method = {RequestMethod.POST, RequestMethod.GET})
    @NoRepeatSubmit
    @ApiOperation(value = "回调")
    @NoRepeatWebLog
    public String callback(HttpServletRequest request, HttpServletResponse resp) throws Exception {
        ContextUtil.clearAdmin();
        /**url中的签名**/
        String signature = request.getParameter("msg_signature");
        /**url中的时间戳*/
        String timestamp = request.getParameter("timestamp");
        /** url中的随机字符串 **/
        String nonce = request.getParameter("nonce");
        /** 创建套件时验证回调url有效性时传入**/
        String echoStr = request.getParameter("echostr");

        String logPrefix = "callback-- ";

        log.info(logPrefix + "signature: {}, timestamp: {}, nonce: {}, echostr: {}", signature, timestamp, nonce, echoStr);

        if (StringUtils.isNotBlank(echoStr)) {
            WXBizMsgCrypt wxcpt = new WXBizMsgCrypt(wxWorkProperties.getToken(), wxWorkProperties.getAesKey(), wxWorkProperties.getCorpId());
            String sEchoStr = wxcpt.VerifyURL(signature, timestamp, nonce, echoStr);
            log.info("sEchoStr {}", sEchoStr);
            return sEchoStr;
        }

        try {
            WxCpCryptUtil cryptUtil = new WxCpCryptUtil(wxCpService.getWxCpConfigStorage());
            String encryptedXml = IOUtils.toString(request.getInputStream(), StandardCharsets.UTF_8);
            String decryptedXml = cryptUtil.decrypt(signature, timestamp, nonce, encryptedXml);
            log.info(logPrefix + "decryptedXml: {}", decryptedXml);

            Map<String, String> messageMap = PaymentKit.xmlToMap(decryptedXml);
            String msgType = messageMap.get("MsgType");

            log.info(logPrefix + " messageMap {}", JSON.toJSONString(messageMap));
            String receiveOpenKfId = messageMap.get("OpenKfId");
            String event = messageMap.get("Event");
            String token = messageMap.get("Token");

            //WxCpXmlMessage inMessage = WxCpXmlMessage.fromXml(decryptedXml, wxCpService.getWxCpConfigStorage().getCorpId());
            WxCpKfService kfService = wxCpService.getKfService();
            switch (msgType) {
                case WxConsts.XmlMsgType.EVENT:
                    if ("kf_msg_or_event".equals(event)) {
                        String cursorKey = receiveOpenKfId + ":" + MSG_CURSOR;
                        String nextCursor = (String) stringRedisService.get(cursorKey);
                        boolean hasMore = true;
                        while (hasMore) {
                            log.info(logPrefix + " nextCursor {}", nextCursor);
                            WxCpKfMsgListResp kfMsgListResp = kfService.syncMsg(nextCursor, token, null, null, receiveOpenKfId);
                            //log.info("kfMsgListResp {}", JSON.toJSONString(kfMsgListResp));
                            for (WxCpKfMsgListResp.WxCpKfMsgItem msgItem : kfMsgListResp.getMsgList()) {
                                String innerMsgType = msgItem.getMsgType();
                                if ("event".equals(innerMsgType) && msgItem.getOrigin() == 4) {
                                    WxCpKfEventMsg eventMsg = msgItem.getEvent();
                                    if ("enter_session".equals(eventMsg.getEventType())) {
                                        String openKfId = eventMsg.getOpenKfid();
                                        String externalUserId = eventMsg.getExternalUserId();
                                        String welcomeCode = eventMsg.getWelcomeCode();
                                        try {
                                            WxCpKfServiceStateResp stateResp = kfService.getServiceState(openKfId, externalUserId);
                                            log.info("stateResp {} {} {} {}", openKfId, externalUserId, welcomeCode, stateResp.getServiceState());
                                            if (stateResp.getServiceState() == 0 || stateResp.getServiceState() == 1) {
                                                if (StringUtils.isNotBlank(welcomeCode)) {
                                                    //发送只能客服欢迎语
                                                    WxCpKfMsgSendRequest sendRequest = new WxCpKfMsgSendRequest();
                                                    sendRequest.setCode(welcomeCode);
                                                    sendRequest.setMsgType("text");
                                                    WxCpKfTextMsg msg = new WxCpKfTextMsg();
                                                    msg.setContent("欢迎咨询,正在为您安排客服人员,请稍候!");
                                                    sendRequest.setText(msg);
                                                    WxCpKfMsgSendResp sendResp = kfService.sendMsgOnEvent(sendRequest);
                                                    log.info("sendResp errcode {}, errmsg {}", sendResp.getErrcode(), sendResp.getErrmsg());
                                                }
                                                WxCpKfServiceStateTransResp transResp = kfService.transServiceState(openKfId, externalUserId, 2, null);
                                                log.info("transResp {}", transResp);
                                            }
                                        } catch (Exception e) {
                                            log.error("transServiceState fail {}", e.getMessage(), e);
                                        }
                                    }
                                }
                            }

                            Integer msgHasMore = kfMsgListResp.getHasMore();
                            hasMore = msgHasMore != null && msgHasMore == 1;
                            nextCursor = kfMsgListResp.getNextCursor();
                        }
                        stringRedisService.set(cursorKey, nextCursor);
                    }
                    break;
            }



            /*WxCpTpXmlMessage inMessage = WxCpTpXmlMessage.fromXml(decryptedXml);
            switch(inMessage.getInfoType()) {
                case WxCpTpConsts.InfoType.SUITE_TICKET:
                    refreshSuiteTicket(inMessage, logPrefix);
                    break;
                case WxCpTpConsts.InfoType.CREATE_AUTH:
                    authCallback(inMessage, logPrefix);
                    break;
                case WxCpTpConsts.InfoType.CHANGE_AUTH:
                    log.info(logPrefix + "change auth");
                    break;
                case WxCpTpConsts.InfoType.CANCEL_AUTH:
                    log.info(logPrefix + "cancel auth");
                    clearAuthCallback(inMessage, logPrefix);
                    break;
                default:
                    log.info(logPrefix + "unknown info_type: {}", inMessage.getInfoType());
            }*/

        } catch (Exception e) {
            log.error(logPrefix + "commandCallback fail: " + e.getMessage(), e);
        }

        return "success";
    }

    /**
     * 指令回调
     *
     * @return
     */
    @RequestMapping(value = "commandCallback", method = {RequestMethod.POST, RequestMethod.GET})
    @NoRepeatSubmit
    @ApiOperation(value = "指令回调")
    @NoRepeatWebLog
    public String commandCallback(HttpServletRequest request, HttpServletResponse resp) throws Exception {
        ContextUtil.clearAdmin();
        /**url中的签名**/
        String msgSignature = request.getParameter("msg_signature");
        /**url中的时间戳*/
        String timestamp = request.getParameter("timestamp");
        /** url中的随机字符串 **/
        String nonce = request.getParameter("nonce");
        /** 创建套件时验证回调url有效性时传入**/
        String echoStr = request.getParameter("echostr");

        String logPrefix = "commandCallback-- ";

        log.info(logPrefix + "msgSignature: {}, timestamp: {}, nonce: {}, echoStr: {}", msgSignature, timestamp, nonce, echoStr);

        if (StringUtils.isNotBlank(echoStr)) {
            WXBizMsgCrypt wxcpt = new WXBizMsgCrypt(wxWorkProperties.getToken(), wxWorkProperties.getAesKey(), wxWorkProperties.getCorpId());
            String sEchoStr = wxcpt.VerifyURL(msgSignature, timestamp, nonce, echoStr);
            log.info(logPrefix + "sEchoStr {}", sEchoStr);
            return sEchoStr;
        }

        try {
            WxCpTpCryptUtil cryptUtil = new WxCpTpCryptUtil(wxCpTpService.getWxCpTpConfigStorage());
            String encryptedXml = IOUtils.toString(request.getInputStream(), StandardCharsets.UTF_8);
            String decryptedXml = cryptUtil.decrypt(msgSignature, timestamp, nonce, encryptedXml);
            log.info(logPrefix + "decryptedXml: {}", decryptedXml);

            /*WxCpTpXmlMessage inMessage = WxCpTpXmlMessage.fromXml(decryptedXml);
            switch(inMessage.getInfoType()) {
                case WxCpTpConsts.InfoType.SUITE_TICKET:
                    refreshSuiteTicket(inMessage, logPrefix);
                    break;
                case WxCpTpConsts.InfoType.CREATE_AUTH:
                    authCallback(inMessage, logPrefix);
                    break;
                case WxCpTpConsts.InfoType.CHANGE_AUTH:
                    log.info(logPrefix + "change auth");
                    break;
                case WxCpTpConsts.InfoType.CANCEL_AUTH:
                    log.info(logPrefix + "cancel auth");
                    clearAuthCallback(inMessage, logPrefix);
                    break;
                default:
                    log.info(logPrefix + "unknown info_type: {}", inMessage.getInfoType());
            }*/

        } catch (Exception e) {
            log.error(logPrefix + "commandCallback fail: " + e.getMessage(), e);
        }

        return "success";
    }

    /**
     * 第三方相关指令回调
     *
     * @return
     */
    @RequestMapping(value = "thirdPartyCommandCallback", method = {RequestMethod.POST, RequestMethod.GET})
    @NoRepeatSubmit
    @ApiOperation(value = "第三方相关指令回调")
    @NoRepeatWebLog
    public String thirdPartyCommandCallback(HttpServletRequest request) throws Exception {
        ContextUtil.clearAdmin();
        /**url中的签名**/
        String msgSignature = request.getParameter("msg_signature");
        /**url中的时间戳*/
        String timestamp = request.getParameter("timestamp");
        /** url中的随机字符串 **/
        String nonce = request.getParameter("nonce");
        /** 创建套件时验证回调url有效性时传入**/
        String echoStr = request.getParameter("echostr");

        String logPrefix = "thirdPartyCommandCallback-- ";

        log.info(logPrefix + "msgSignature: {}, timestamp: {}, nonce: {}, echoStr: {}", msgSignature, timestamp, nonce, echoStr);

        if (StringUtils.isNotBlank(echoStr)) {
            WXBizMsgCrypt wxcpt = new WXBizMsgCrypt(wxWorkProperties.getToken(), wxWorkProperties.getAesKey(), wxWorkProperties.getCorpId());
            String sEchoStr = wxcpt.VerifyURL(msgSignature, timestamp, nonce, echoStr);
            log.info(logPrefix + "sEchoStr {}", sEchoStr);
            return sEchoStr;
        }

        try {
            WxCpTpCryptUtil cryptUtil = new WxCpTpCryptUtil(wxCpTpService.getWxCpTpConfigStorage());
            String encryptedXml = IOUtils.toString(request.getInputStream(), StandardCharsets.UTF_8);
            String decryptedXml = cryptUtil.decrypt(msgSignature, timestamp, nonce, encryptedXml);
            log.info(logPrefix + "decryptedXml: {}", decryptedXml);
            WxCpTpXmlMessage inMessage = WxCpTpXmlMessage.fromXml(decryptedXml);
            switch (inMessage.getInfoType()) {
                case WxCpTpConsts.InfoType.SUITE_TICKET:
                    refreshSuiteTicket(inMessage, logPrefix);
                    break;
                case WxCpTpConsts.InfoType.CREATE_AUTH:
                    authCallback(inMessage, logPrefix);
                    break;
                case WxCpTpConsts.InfoType.CHANGE_AUTH:
                    log.info(logPrefix + "change auth");
                    break;
                case WxCpTpConsts.InfoType.CANCEL_AUTH:
                    log.info(logPrefix + "cancel auth");
                    clearAuthCallback(inMessage, logPrefix);
                    break;
                default:
                    log.info(logPrefix + "unknown info_type: {}", inMessage.getInfoType());
            }

        } catch (Exception e) {
            log.error(logPrefix + "commandCallback fail: " + e.getMessage(), e);
        }

        return "success";
    }

    /**
     * 获取ip段
     *
     * @return
     */
    @RequestMapping(value = "getIpList", method = {RequestMethod.POST, RequestMethod.GET})
    @NoRepeatSubmit
    @ApiOperation(value = "获取ip段")
    @NoRepeatWebLog
    public String getIpList(HttpServletRequest request, HttpServletResponse resp) throws Exception {
        try {
            String suiteTicket = (String) stringRedisService.get(WxCpConstants.SUITE_TICKET_KEY);
            wxCpTpService.setSuiteTicket(suiteTicket);
            String result = wxCpTpService.get(WxCpConstants.GET_IP_LIST, null);
            log.info("result1: {}" + result);
        } catch (Exception e) {
            log.error("result1: " + e.getMessage(), e);
        }

        try {
            WxAccessToken token = wxCpTpService.getCorpToken("xxx", "xxx", true);
            String result = wxCpTpService.get(WxCpConstants.GET_IP_LIST + "?access_token=" + token.getAccessToken(), null, true);
            log.info("result2: {}" + result);
        } catch (Exception e) {
            log.error("result2: " + e.getMessage(), e);
        }
        return "";
    }

    /**
     * 刷新suiteTicket
     *
     * @param xmlMessage
     * @param logPrefix
     */
    private void refreshSuiteTicket(WxCpTpXmlMessage xmlMessage, String logPrefix) {
        try {
            if (StringUtils.isNotBlank(xmlMessage.getSuiteTicket())) {
                log.info(logPrefix + "suiteTicket: {}", xmlMessage.getSuiteTicket());
                wxCpTpService.setSuiteTicket(xmlMessage.getSuiteTicket());
                //将suiteTicket设置到缓存
                stringRedisService.set(WxCpConstants.SUITE_TICKET_KEY, xmlMessage.getSuiteTicket());
            }
/*
            String result = wxCpTpService.get(wxCpTpService.getWxCpTpConfigStorage().getApiUrl(WxCpApiPathConsts.Tp.GET_PREAUTH_CODE), null);
            WxCpTpPreauthCode preAuthCode = WxCpTpPreauthCode.fromJson(result);
            log.info("preAuthCode: {}", preAuthCode.getPreAuthCode());*/
        } catch (Exception e) {
            log.error(logPrefix + "refreshSuiteTicket fail: " + e.getMessage(), e);
        }
    }

    /**
     * 更新授权回调
     *
     * @param xmlMessage
     * @param logPrefix
     */
    private void authCallback(WxCpTpXmlMessage xmlMessage, String logPrefix) {
        try {
            String shopId = xmlMessage.getState();
            WxCpTpPermanentCodeInfo permanentCodeInfo = wxCpTpService.getPermanentCodeInfo(xmlMessage.getAuthCode());
            log.info("permanentCodeInfo: {}", JSON.toJSONString(permanentCodeInfo));

            String permanentCode = permanentCodeInfo.getPermanentCode();
            String authCorpId = permanentCodeInfo.getAuthCorpInfo().getCorpId();
            cereCustomerServiceConfigDAO.updatePermanentCode(Long.valueOf(shopId), permanentCode, authCorpId);

        } catch (Exception e) {
            log.error(logPrefix + "authCallback " + e.getMessage(), e);
        }
    }

    /**
     * 解除授权回调
     *
     * @param xmlMessage
     * @param logPrefix
     */
    private void clearAuthCallback(WxCpTpXmlMessage xmlMessage, String logPrefix) {
        try {
            String authCorpId = xmlMessage.getAuthCorpId();
            cereCustomerServiceConfigDAO.clearAuthInfo(authCorpId, TimeUtils.yyMMddHHmmss());
        } catch (Exception e) {
            log.error(logPrefix + "clearAuthCallback " + e.getMessage(), e);
        }
    }

    /**
     * 授权跳转
     * @return
     */
    /* @GetMapping(value = "authRedirect")
    @NoRepeatSubmit
    @ApiOperation(value = "授权跳转")
    @NoRepeatWebLog
    public void authRedirect(HttpServletRequest request) throws Exception {
        String authCode = request.getParameter("auth_code");
        String state = request.getParameter("state");
        String decodeState = URLDecoder.decode(state, "UTF-8");
        String permanentCode = "";
        // 1
        try {

            log.info("authRedirect: authCode = {}, state = {}, decodeState = {}", authCode, state, decodeState);
            WxCpTpPermanentCodeInfo permanentCodeInfo = wxCpTpService.getPermanentCodeInfo(authCode);
            log.info("permanentCodeInfo: {}", JSON.toJSONString(permanentCodeInfo));
            permanentCode = permanentCodeInfo.getPermanentCode();

        } catch (Exception e) {
            log.error("authRedirect error: " + e.getMessage(), e);
        }

        // 2
        try {

            WxCpTpAuthInfo authInfo = wxCpTpService.getAuthInfo(authCorpId, permanentCode);
            log.info("authInfo: {}", JSON.toJSONString(authInfo));

        } catch (Exception e) {
            log.error("authRedirect2 error: " + e.getMessage(), e);
        }

        // 3
        try {

            String authCorpJsApiTicket = wxCpTpService.getAuthCorpJsApiTicket(authCorpId, true);
            log.info("authCorpJsApiTicket: {}", authCorpJsApiTicket);

        } catch (Exception e) {
            log.error("authRedirect3 error: " + e.getMessage(), e);
        }

        // 4
        try {

            WxAccessToken corpToken = wxCpTpService.getCorpToken(authCorpId, permanentCode);
            log.info("corpToken: {}", corpToken);

            String result = wxCpTpService.get(WxCpConstants.API_KF_LIST, "access_token=" + corpToken);
            log.info("corpKf: {}", result);

        } catch (Exception e) {
            log.error("authRedirect4 error: " + e.getMessage(), e);
        }
    }
    */
}
