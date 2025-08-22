package com.shop.cereshop.commons.utils.third;

import cn.hutool.core.collection.ListUtil;
import cn.hutool.core.date.DateField;
import cn.hutool.core.date.DateUtil;
import cn.hutool.core.map.MapUtil;
import cn.hutool.core.util.ObjectUtil;
import cn.hutool.json.JSONUtil;
import com.baomidou.mybatisplus.core.toolkit.IdWorker;
import com.github.binarywang.wxpay.bean.marketing.*;
import com.github.binarywang.wxpay.bean.marketing.busifavor.*;
import com.github.binarywang.wxpay.bean.marketing.enums.StockTypeEnum;
import com.github.binarywang.wxpay.bean.media.MarketingImageUploadResult;
import com.github.binarywang.wxpay.config.WxPayConfig;
import com.github.binarywang.wxpay.constant.WxPayConstants;
import com.github.binarywang.wxpay.exception.WxPayException;
import com.github.binarywang.wxpay.service.MarketingBusiFavorService;
import com.github.binarywang.wxpay.service.MarketingMediaService;
import com.github.binarywang.wxpay.service.WxPayService;
import com.github.binarywang.wxpay.util.SignUtils;
import com.shop.cereshop.commons.constant.IntegerEnum;
import com.shop.cereshop.commons.domain.coupon.PlugRequestParam;
import com.shop.cereshop.commons.domain.coupon.PlugRequestParamVO;
import com.shop.cereshop.commons.domain.coupon.SendCouponParam;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.extern.slf4j.Slf4j;

import java.io.IOException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.net.HttpURLConnection;
import java.net.URL;
import java.text.SimpleDateFormat;
import java.util.*;

@Slf4j(topic = "WxCardUtil")
@Data
@AllArgsConstructor
public class WxCardUtil {

    private final static SimpleDateFormat DATE_FORMAT = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");

    /* 优惠券顶部图标 */
    private static final String COUPON_LOGO_URL = "https://zk-cereshop.oss-cn-shenzhen.aliyuncs.com/test/2021-12-11/34a18c9c0efc4a8a80a726ba6b6c7765coupon.jpeg";

    private WxPayService wxPayService;

    private MarketingMediaService marketingMediaService;

    /**
     * 请求微信接口 成功返回 stockId
     *
     * @return stockId
     */
    public String createMerchantCoupon(Long couponId, Integer couponType, String title, String color, String notice,
                                                            Date beginTime, Date endTime, int quantity, Integer getLimit,
                                                            BigDecimal fullMoney, BigDecimal reduceMoney) {
        try {
            MarketingBusiFavorService marketingBusiFavorService = wxPayService.getMarketingBusiFavorService();
            BusiFavorStocksCreateRequest request = new BusiFavorStocksCreateRequest();

            request.setStockName(title);
            request.setBelongMerchant(wxPayService.getConfig().getMchId());
            request.setGoodsName(notice);
            StockTypeEnum stockTypeEnum = null;
            FixedNormalCoupon fixedNormalCoupon = null;
            DiscountCoupon discountCoupon = null;
            BigDecimal oneHundred = new BigDecimal(100);
            if (IntegerEnum.COUPON_TYPE_REDUTION.getCode().equals(couponType)) {
                stockTypeEnum = StockTypeEnum.NORMAL;

                //固定优惠券金额
                fixedNormalCoupon = new FixedNormalCoupon();
                fixedNormalCoupon.setDiscountAmount(reduceMoney.multiply(oneHundred).intValue());
                fixedNormalCoupon.setTransactionMinimum(fullMoney.multiply(oneHundred).intValue());
            } else {
                stockTypeEnum = StockTypeEnum.DISCOUNT;
                discountCoupon = new DiscountCoupon();
                discountCoupon.setDiscountPercent(reduceMoney.multiply(BigDecimal.TEN).intValue());
                discountCoupon.setTransactionMinimum(fullMoney.multiply(oneHundred).intValue());
            }
            request.setStockType(stockTypeEnum);
            //优惠券使用规则
            CouponUseRule couponUseRule = new CouponUseRule();
            //使用时间
            CouponAvailableTime couponAvailableTime = new CouponAvailableTime();
            couponAvailableTime.setAvailableBeginTime(DATE_FORMAT.format(DateUtil.offset(beginTime, DateField.HOUR_OF_DAY, -8)));
            couponAvailableTime.setAvailableEndTime(DATE_FORMAT.format(DateUtil.offset(endTime, DateField.HOUR_OF_DAY, -8)));
            couponUseRule.setCouponAvailableTime(couponAvailableTime);

            couponUseRule.setFixedNormalCoupon(fixedNormalCoupon);
            couponUseRule.setDiscountCoupon(discountCoupon);
            couponUseRule.setMiniProgramsAppid(wxPayService.getConfig().getAppId());
            couponUseRule.setUseMethod("MINI_PROGRAMS");
            couponUseRule.setMiniProgramsPath("/pages_category_page1/coupon/product?id=" + couponId);

            request.setCouponUseRule(couponUseRule);
            //优惠券发放规则
            StockSendRule stockSendRule = new StockSendRule();
            stockSendRule.setMaxCoupons(quantity);
            stockSendRule.setMaxCouponsPerUser(getLimit);
            request.setStockSendRule(stockSendRule);
            request.setOutRequestNo(UUID.randomUUID().toString());
            //自定义入口 券跳转信息
            CustomEntrance customEntrance = new CustomEntrance();
            //小程序入口
            CustomEntrance.MiniProgramsInfo miniProgramsInfo = new CustomEntrance.MiniProgramsInfo();
            miniProgramsInfo.setMiniProgramsAppid(wxPayService.getConfig().getAppId());
            miniProgramsInfo.setMiniProgramsPath("/pages/tabbar/index/index");
            miniProgramsInfo.setEntranceWords("小程序");
            miniProgramsInfo.setGuidingWords("获取更多优惠");
            customEntrance.setMiniProgramsInfo(miniProgramsInfo);
            request.setCustomEntrance(customEntrance);
            //样式信息
            DisplayPatternInfo displayPatternInfo = new DisplayPatternInfo();
            displayPatternInfo.setBackgroundColor(color);
            InputStream inputStream = getImageFromNetByUrl(COUPON_LOGO_URL);
            MarketingImageUploadResult uploadResult = marketingMediaService.imageUploadV3(inputStream, UUID.randomUUID().toString());
            displayPatternInfo.setMerchantLogoUrl(uploadResult.getMediaUrl());
            displayPatternInfo.setMerchantName("多商户优惠券");
            request.setDisplayPatternInfo(displayPatternInfo);
            request.setCouponCodeMode("WECHATPAY_MODE");
            //回调配置
    //        NotifyConfig notifyConfig = new NotifyConfig();
    //        notifyConfig.setNotifyAppId();
    //        request.setNotifyConfig(notifyConfig);
            BusiFavorStocksCreateResult busiFavorStocksV3 = null;

            busiFavorStocksV3 = marketingBusiFavorService.createBusiFavorStocksV3(request);
            log.info("\n【请求数据】：{}\n【响应数据】：{}", JSONUtil.toJsonStr(request), JSONUtil.toJsonStr(busiFavorStocksV3));
            return busiFavorStocksV3.getStockId();
        } catch (WxPayException e) {
            log.error("\n【异常信息】：{}", e.toString(), e);
        } catch (IOException ioe) {
            log.error("imageUploadV3 fail: " + ioe.getMessage(), ioe);
        }
        return null;
    }

    /**
     * 核销用户券
     *
     * @return
     */
    public Map<String, Object> useMerchantCoupon(String stockId, String openId, String couponCode) {
        WxPayConfig wxPayConfig = wxPayService.getConfig();
        MarketingBusiFavorService marketingBusiFavorService = wxPayService.getMarketingBusiFavorService();
        BusiFavorCouponsUseRequest request = new BusiFavorCouponsUseRequest();
        request.setAppId(wxPayConfig.getAppId());
        request.setCouponCode(couponCode);
        request.setOpenid(openId);
        request.setStockId(stockId);
        request.setUseRequestNo(UUID.randomUUID().toString().replaceAll("-", ""));
        request.setUseTime(DATE_FORMAT.format(new Date()));
        BusiFavorCouponsUseResult res = null;
        try {
            res = marketingBusiFavorService.verifyBusiFavorCouponsUseV3(request);
            log.error("\n【请求数据】：{}\n【响应数据】：{}", JSONUtil.toJsonStr(request), JSONUtil.toJsonStr(res));
            return JSONUtil.parseObj(res);
        } catch (WxPayException e) {
            log.error("\n【请求数据】：{}\n【异常信息】：{}", JSONUtil.toJsonStr(request), e.toString());
            e.printStackTrace();
        }
        return null;
    }

    /**
     * 查询用户券
     * @return
     */
    public BusiFavorQueryOneUserCouponsResult queryUserCoupon(String openId, String couponState,
                                                              int offset, int limit) {
        WxPayConfig wxPayConfig = wxPayService.getConfig();
        MarketingBusiFavorService marketingBusiFavorService = wxPayService.getMarketingBusiFavorService();
        BusiFavorQueryUserCouponsRequest request = new BusiFavorQueryUserCouponsRequest();
        request.setOpenid(openId);
        request.setAppid(wxPayConfig.getAppId());
        //request.setBelongMerchant(criteria.getBelongMerchant());
        //request.setSenderMerchant(criteria.getSenderMerchant());
        request.setCouponState(couponState);
        //request.setCreatorMerchant(criteria.getCreatorMerchant());
        request.setOffset(offset);
        request.setLimit(limit);

        try {
            BusiFavorQueryUserCouponsResult userCouponsResult = marketingBusiFavorService.queryBusiFavorUsersCoupons(request);
            List<BusiFavorQueryOneUserCouponsResult> data = userCouponsResult.getData();
            return data.stream()
                    .findFirst()
                    .orElseGet(BusiFavorQueryOneUserCouponsResult::new);
        } catch (WxPayException e) {
            log.error(e.getErrCode(), e.getErrCodeDes());
        }
        return null;
    }

    /**
     * 根据地址获得数据的字节流
     *
     * @param strUrl 网络连接地址
     * @return
     */
    private static InputStream getImageFromNetByUrl(String strUrl) {
        try {
            URL url = new URL(strUrl);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setConnectTimeout(5 * 1000);
            if (ObjectUtil.isNull(conn.getInputStream())) {
                return null;
            }
            return conn.getInputStream();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }


    public PlugRequestParamVO buildParam4Plug(List<String> stockIds) {
        PlugRequestParamVO PlugRequestParamVO = new PlugRequestParamVO();
        if (ObjectUtil.isEmpty(stockIds)) {
            return PlugRequestParamVO;
        }
        WxPayConfig wxPayConfig = wxPayService.getConfig();

        //构建发券参数
        List<SendCouponParam> sendCouponParams = ListUtil.list(false);
        for (String stockId : stockIds) {
            SendCouponParam couponParam = new SendCouponParam();
            couponParam.setStock_id(stockId);
            couponParam.setOut_request_no(IdWorker.getIdStr());
            sendCouponParams.add(couponParam);
        }
        PlugRequestParamVO.setSend_coupon_params(sendCouponParams);

        //构建 sign
        Map<String, String> param = MapUtil.newHashMap();
        for (int i = 0; i < sendCouponParams.size(); i++) {
            SendCouponParam couponParam = sendCouponParams.get(i);
            param.put("stock_id" + i, couponParam.getStock_id());
            param.put("out_request_no" + i, couponParam.getOut_request_no());
        }
        param.put("send_coupon_merchant", wxPayConfig.getMchId());
        String sign = SignUtils.createSign(param, WxPayConstants.SignType.HMAC_SHA256, wxPayConfig.getMchKey(), null);
        PlugRequestParamVO.setSign(sign);
        PlugRequestParamVO.setSend_coupon_merchant(wxPayConfig.getMchId());
        return PlugRequestParamVO;
    }


    public List<PlugRequestParamVO> buildParam4PlugList(List<PlugRequestParam> paramDtos) {
        List<PlugRequestParamVO> list = ListUtil.list(false);
        paramDtos.forEach(plugRequestParamDto -> {
            PlugRequestParamVO PlugRequestParamVO = this.buildParam4Plug(Arrays.asList(plugRequestParamDto.getStockId()));
            PlugRequestParamVO.setCid(plugRequestParamDto.getCId());
            list.add(PlugRequestParamVO);
        });
        return list;
    }
}
