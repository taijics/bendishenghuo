/*
 * Copyright (C) 2017-2021
 * All rights reserved, Designed By 深圳中科鑫智科技有限公司
 * Copyright authorization contact 18814114118
 */
package com.shop.cereshop.business.service.order.impl;

import com.alibaba.fastjson.JSON;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.shop.cereshop.business.dao.buyer.CereBuyerUserDAO;
import com.shop.cereshop.business.dao.order.CereOrderParentDAO;
import com.shop.cereshop.business.dao.order.CereShopOrderDAO;
import com.shop.cereshop.business.page.finance.*;
import com.shop.cereshop.business.page.order.Product;
import com.shop.cereshop.business.page.order.ShopOrder;
import com.shop.cereshop.business.param.finance.FinanceCountParam;
import com.shop.cereshop.business.param.finance.FinanceDetailParam;
import com.shop.cereshop.business.param.finance.FinanceWithdrawalParam;
import com.shop.cereshop.business.param.order.OrderGetAllParam;
import com.shop.cereshop.business.param.order.UpdateOrderPriceParam;
import com.shop.cereshop.business.pay.PayFactory;
import com.shop.cereshop.business.pay.PayService;
import com.shop.cereshop.business.redis.service.api.StringRedisService;
import com.shop.cereshop.business.service.activity.CereBuyerCouponService;
import com.shop.cereshop.business.service.buyer.CereBuyerShopCouponService;
import com.shop.cereshop.business.service.log.CerePlatformLogService;
import com.shop.cereshop.business.service.notice.CereNoticeService;
import com.shop.cereshop.business.service.order.CereOrderReconciliationService;
import com.shop.cereshop.business.service.order.CereShopOrderService;
import com.shop.cereshop.business.service.pay.CerePayLogService;
import com.shop.cereshop.business.service.product.CereProductSkuService;
import com.shop.cereshop.business.service.tool.CereShopDiscountDetailService;
import com.shop.cereshop.business.service.tool.CereShopDiscountService;
import com.shop.cereshop.business.service.tool.CereShopSeckillDetailService;
import com.shop.cereshop.business.service.tool.CereShopSeckillService;
import com.shop.cereshop.business.utils.EncodeUtil;
import com.shop.cereshop.commons.constant.CoReturnFormat;
import com.shop.cereshop.commons.constant.IntegerEnum;
import com.shop.cereshop.commons.constant.StringEnum;
import com.shop.cereshop.commons.constant.WxPayEnum;
import com.shop.cereshop.commons.domain.activity.CereBuyerCoupon;
import com.shop.cereshop.commons.domain.business.CerePlatformBusiness;
import com.shop.cereshop.commons.domain.buyer.CereBuyerShopCoupon;
import com.shop.cereshop.commons.domain.buyer.CereBuyerUser;
import com.shop.cereshop.commons.domain.common.Page;
import com.shop.cereshop.commons.domain.notice.CereNotice;
import com.shop.cereshop.commons.domain.order.CereOrderParent;
import com.shop.cereshop.commons.domain.order.CereOrderReconciliation;
import com.shop.cereshop.commons.domain.order.CereShopOrder;
import com.shop.cereshop.commons.domain.pay.CerePayLog;
import com.shop.cereshop.commons.domain.product.CereProductSku;
import com.shop.cereshop.commons.domain.tool.CereShopDiscount;
import com.shop.cereshop.commons.domain.tool.CereShopDiscountDetail;
import com.shop.cereshop.commons.domain.tool.CereShopSeckill;
import com.shop.cereshop.commons.domain.tool.CereShopSeckillDetail;
import com.shop.cereshop.commons.exception.CoBusinessException;
import com.shop.cereshop.commons.utils.EmptyUtils;
import com.shop.cereshop.commons.utils.SpringUtil;
import com.shop.cereshop.commons.utils.StringUtils;
import com.shop.cereshop.commons.utils.TimeUtils;
import org.apache.commons.collections4.CollectionUtils;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.*;
import java.util.function.Function;
import java.util.stream.Collectors;

@Service
public class CereShopOrderServiceImpl implements CereShopOrderService {

    @Autowired
    private CereShopOrderDAO cereShopOrderDAO;

    @Autowired
    private CereOrderParentDAO cereOrderParentDAO;

    @Autowired
    private CereShopSeckillService cereShopSeckillService;

    @Autowired
    private CereShopSeckillDetailService cereShopSeckillDetailService;

    @Autowired
    private CereShopDiscountService cereShopDiscountService;

    @Autowired
    private CereShopDiscountDetailService cereShopDiscountDetailService;

    @Autowired
    private StringRedisService stringRedisService;

    @Autowired
    private CereProductSkuService cereProductSkuService;

    @Autowired
    private CereOrderReconciliationService cereOrderReconciliationService;

    @Autowired
    private CerePayLogService cerePayLogService;

    @Autowired
    private CereNoticeService cereNoticeService;

    @Autowired
    private CereBuyerShopCouponService cereBuyerShopCouponService;

    @Autowired
    private CereBuyerCouponService cereBuyerCouponService;

    @Autowired
    private CerePlatformLogService cerePlatformLogService;

    @Autowired
    private EncodeUtil encodeUtil;

    @Autowired
    private CereBuyerUserDAO cereBuyerUserDAO;

    @Override
    public Page getAll(OrderGetAllParam param) throws CoBusinessException {
        PageHelper.startPage(param.getPage(),param.getPageSize());
        List<ShopOrder> list=cereShopOrderDAO.getAll(param);
        //过滤空对象
        list.stream().filter(Objects::nonNull).peek(s->{
            if(s.getCustomerName()!=null){
                String customerName = StringUtils.showStartAndEnd(s.getCustomerName(), 1, 1);
                s.setCustomerName(customerName);
            }
            s.setReceiveName(encodeUtil.encodeInfo(s.getReceiveName()));
            s.setReceivePhone(encodeUtil.encodePhone(s.getReceivePhone()));
            s.setCustomerName(encodeUtil.encodeInfo(s.getCustomerName()));
            List<Product> products=cereShopOrderDAO.getProducts(s.getOrderId());
            s.setProducts(products);
            s.setTotal(cereShopOrderDAO.getOrderTotals(s.getBuyerUserId()));
            if(s.getPaymentState()==0){
                s.setPaymentMode(null);
            }
        }).collect(Collectors.toList());
        PageInfo<ShopOrder> pageInfo=new PageInfo<>(list);
        Page page=new Page(pageInfo.getList(),pageInfo.getTotal());
        return page;
    }

    @Override
    public ShopOrder getById(Long shopId, Long orderId) throws CoBusinessException {
        ShopOrder shopOrder=cereShopOrderDAO.getById(orderId, shopId);
        if(shopOrder!=null){
            //根据买家账户查询下单总数
            shopOrder.setTotal(cereShopOrderDAO.getOrderTotals(shopOrder.getBuyerUserId()));
            //查询商品信息
            List<Product> products=cereShopOrderDAO.getProducts(orderId);
            if(!EmptyUtils.isEmpty(products)){
                //封装规格属性数据
                products.forEach(product -> product.setSkuDetails(cereShopOrderDAO.findSkuAttribute(product.getOrderProductId())));
            }
            shopOrder.setProducts(products);
            shopOrder.setCustomerName(encodeUtil.encodeInfo(shopOrder.getCustomerName()));
            shopOrder.setReceiveName(encodeUtil.encodeInfo(shopOrder.getReceiveName()));
            shopOrder.setReceivePhone(encodeUtil.encodePhone(shopOrder.getReceivePhone()));
            shopOrder.setAddress(encodeUtil.encodeInfo(shopOrder.getAddress()));
            CereBuyerUser user = cereBuyerUserDAO.selectById(shopOrder.getBuyerUserId());
            if (user != null) {
                shopOrder.setUnionId(user.getWechatUnionId());
                shopOrder.setBuyerPhone(user.getPhone());
            }
        }
        return shopOrder;
    }

    @Override
    public void updateState(CereShopOrder cereShopOrder) throws CoBusinessException {
        cereShopOrderDAO.updateState(cereShopOrder);
    }

    @Override
    public FinanceCount getFinanceCount(FinanceCountParam param) throws CoBusinessException {
        FinanceCount count=new FinanceCount();
        //查询累计营业额
        count.setTurnover(cereShopOrderDAO.getTurnover(param.getShopId()));
        //查询冻结金额
        count.setFrozenMoney(cereShopOrderDAO.getFrozenMoney(param.getShopId()));
        //查询提现中金额
        count.setWithdrawableStayMoney(cereShopOrderDAO.getWithdrawableStayMoney(param.getShopId()));
        //查询总的可提现金额
        BigDecimal withdrawableMoney = cereShopOrderDAO.getAllWithdrawableMoney(param.getShopId());
        //查询已提现的金额
        BigDecimal money=cereShopOrderDAO.getWithdrawableMoney(param.getShopId());
        //计算可提现金额=总的提现金额-提现中金额-已提现金额
        count.setWithdrawableMoney(withdrawableMoney.subtract(count.getWithdrawableStayMoney()).subtract(money));
        if(IntegerEnum.DAY_CONDITION.getCode().equals(param.getCondition())){
            //查询指定月份下每天的收入
            List<Finance> incomes=cereShopOrderDAO.getFinanceByDay(param.getShopId(),param.getTime(),1);
            //查询指定月份下每天的支出
            List<Finance> expenditures=cereShopOrderDAO.getFinanceByDay(param.getShopId(),param.getTime(),2);
            //将支出数据转为map
            Map<String, Finance> map = expenditures.stream()
                    .filter(Objects::nonNull)
                    .collect(Collectors.toMap(Finance::getTime, Function.identity()));
            if(!EmptyUtils.isEmpty(incomes)){
                incomes.forEach(a -> {
                    if(!EmptyUtils.isEmpty(map.get(a.getTime()))){
                        a.setExpenditure(map.get(a.getTime()).getIncome());
                    }
                });
            }
            count.setFinances(incomes);
        }else {
            //查询指定月份下每月的收入
            List<Finance> incomes=cereShopOrderDAO.getFinanceByMonth(param.getShopId(),param.getTime(),1);
            //查询指定月份下每月的支出
            List<Finance> expenditures=cereShopOrderDAO.getFinanceByMonth(param.getShopId(),param.getTime(),2);
            //将支出数据转为map
            Map<String, Finance> map = expenditures.stream()
                    .filter(Objects::nonNull)
                    .collect(Collectors.toMap(Finance::getTime, Function.identity()));
            if(!EmptyUtils.isEmpty(incomes)){
                incomes.forEach(a -> {
                    if(!EmptyUtils.isEmpty(map.get(a.getTime()))){
                        a.setExpenditure(map.get(a.getTime()).getIncome());
                    }
                });
            }
            count.setFinances(incomes);
        }
        return count;
    }

    @Override
    public Bank getBank(Long shopId) throws CoBusinessException {
//        //查询提现中金额
//        BigDecimal stayMoney = cereShopOrderDAO.getWithdrawableStayMoney(shopId);
//        //查询总的可提现金额
//        BigDecimal withdrawableMoney = cereShopOrderDAO.getAllWithdrawableMoney(shopId);
//        //查询已提现的金额
//        BigDecimal money=cereShopOrderDAO.getWithdrawableMoney(shopId);
//        //计算可提现金额=总的提现金额-提现中金额-已提现金额
//        BigDecimal total = withdrawableMoney.subtract(stayMoney).subtract(money);
//        if(total.compareTo(BigDecimal.ZERO)!=1){
//            throw new CoBusinessException(CoReturnFormat.BALANCE_NOT_ENOUGH);
//        }
        return cereShopOrderDAO.getBank(shopId);
    }

    @Override
    public List<WithdrawalDetail> getWithdrawalDetails(FinanceWithdrawalParam param) throws CoBusinessException {
        return cereShopOrderDAO.getWithdrawalDetails(param);
    }

    @Override
    public Page getDetails(FinanceDetailParam param) throws CoBusinessException {
        PageHelper.startPage(param.getPage(),param.getPageSize());
        //查询当天所有流水数据
        List<FlowingWater> list=cereShopOrderDAO.getDetails(param);
        if(!EmptyUtils.isEmpty(list)){
            list.forEach(a -> {
                a.setShopId(param.getShopId());
                //查询流水发生时的冻结金额和可用余额之和
                a.setBalance(getBalance(a));
            });
        }
        PageInfo<FlowingWater> pageInfo=new PageInfo<>(list);
        Page page=new Page(pageInfo.getList(),pageInfo.getTotal());
        return page;
    }

    @Override
    public void updateBatchStock(List<CereProductSku> skus) throws CoBusinessException {
        cereShopOrderDAO.updateBatchStock(skus);
    }

    @Override
    public BigDecimal getWithdrawableStayMoney(Long shopId) {
        return cereShopOrderDAO.getWithdrawableStayMoney(shopId);
    }

    @Override
    public BigDecimal getAllWithdrawableMoney(Long shopId) {
        return cereShopOrderDAO.getAllWithdrawableMoney(shopId);
    }

    @Override
    public BigDecimal getWithdrawableMoney(Long shopId) {
        return cereShopOrderDAO.getWithdrawableMoney(shopId);
    }

    @Override
    public CereShopOrder findById(Long orderId) {
        return cereShopOrderDAO.selectByPrimaryKey(orderId);
    }

    @Override
    @Transactional(isolation= Isolation.DEFAULT,propagation= Propagation.REQUIRED,rollbackFor = {CoBusinessException.class, Exception.class})
    public void cancelBatch(List<Long> ids) throws CoBusinessException,Exception {
        String time = TimeUtils.yyMMddHHmmss();
        //查询订单信息
        List<CereShopOrder> orders=cereShopOrderDAO.findByIds(ids);
        for (CereShopOrder order : orders) {
            //修改订单状态为已取消
            order.setUpdateTime(time);
            order.setState(IntegerEnum.ORDER_STOP.getCode());
            cereShopOrderDAO.updateByPrimaryKeySelective(order);
            if(!EmptyUtils.isEmpty(order.getShopSeckillId())){
                //查询秒杀活动数据
                CereShopSeckill cereShopSeckill=cereShopSeckillService.findById(order.getShopSeckillId());
                if(IntegerEnum.YES.getCode().equals(cereShopSeckill.getIfNumber())){
                    //如果限量,需要更新限量库存数据
                    List<CereShopSeckillDetail> seckillDetails=cereShopSeckillDetailService.findNumberDetails(order.getOrderId(),cereShopSeckill.getShopSeckillId());
                    if(!EmptyUtils.isEmpty(seckillDetails)){
                        //更新redis限量库存
                        seckillDetails.forEach(detail -> {
                            stringRedisService.set("秒杀活动商品仅剩件数"+detail.getShopSeckillId() + detail.getSkuId(),detail.getNumber());
                        });
                        cereShopSeckillDetailService.updateBatch(seckillDetails);
                    }
                }
            }
            if(!EmptyUtils.isEmpty(order.getShopDiscountId())){
                //查询秒杀活动数据
                CereShopDiscount cereShopDiscount=cereShopDiscountService.findById(order.getShopDiscountId());
                if(IntegerEnum.YES.getCode().equals(cereShopDiscount.getIfNumber())){
                    //如果限量,需要更新限量库存数据
                    List<CereShopDiscountDetail> discountDetails=cereShopDiscountDetailService.findNumberDetails(order.getOrderId(),cereShopDiscount.getShopDiscountId());
                    if(!EmptyUtils.isEmpty(discountDetails)){
                        //更新redis限量库存
                        discountDetails.forEach(detail -> {
                            stringRedisService.set("限时折扣活动商品仅剩件数"+detail.getShopDiscountId() + detail.getSkuId(),detail.getNumber());
                        });
                        cereShopDiscountDetailService.updateBatch(discountDetails);
                    }
                }
            }
            //更新库存数据
            List<CereProductSku> productSkus=cereProductSkuService.findStockNumberByOrderId(order.getOrderId());
            if(!EmptyUtils.isEmpty(productSkus)){
                //更新库存数量
                productSkus.forEach(sku -> {
                    int stockNumber=cereProductSkuService.findStockNumberBySkuId(sku.getSkuId());
                    if(!EmptyUtils.isEmpty(stringRedisService.get(String.valueOf(sku.getSkuId())))){
                        stockNumber=(int) stringRedisService.get(String.valueOf(sku.getSkuId()));
                    }
                    sku.setStockNumber(stockNumber+sku.getStockNumber());
                    //更新redis商品库存
                    stringRedisService.set(String.valueOf(sku.getSkuId()),sku.getStockNumber());
                });
                cereProductSkuService.updateBatchSkus(productSkus);
            }
            if(IntegerEnum.YES.getCode().equals(order.getPaymentState())){
                //如果付款了,需要退款,查询支付流水数据
                CerePayLog refund=cereShopOrderDAO.findPayLog(order.getOrderFormid());
                if(refund!=null){
                    //微信支付没通,暂时直接处理业务
//                    handleRefundTestWxLog(order.getOrderFormid(),refund.getTransactionId(),refund.getOutTradeNo());
                    PayService payService = PayFactory.getPayService(refund.getPaymentMode());
                    Map<String, String> resultMap = payService.orderRefund(refund.getTransactionId(), refund.getOutRefundNo(), refund.getTotalFee(), refund.getTotalFee());
                    if(!EmptyUtils.isEmpty(resultMap)){
                        if(resultMap.get("return_msg").equals(WxPayEnum.REFUND_SUCCESS.getCode())&&
                                resultMap.get("return_code").equals(WxPayEnum.REFUND_OK.getCode())){
                            //退款成功 支付宝的退款是立即退款的，需要同步处理
                            if (Arrays.asList(IntegerEnum.ORDER_PAY_ALI.getCode(),
                                    IntegerEnum.ORDER_PAY_HUABEI.getCode()).contains(order.getPaymentMode())) {
                                //内部调用不会执行事务，所以通过springUtil获取service对象
                                CereShopOrderService cereShopOrderService = SpringUtil.getBean(CereShopOrderService.class);
                                cereShopOrderService.handleRefundWxLog(refund.getOrderFormid(),refund.getTransactionId(),refund.getOutTradeNo());
                            }
                        }else if(resultMap.get("return_code").equals(WxPayEnum.BUSINESS_BALANCE_NOTENOUGH.getCode())){
                            //退款失败,商户余额不足
                            throw new CoBusinessException(CoReturnFormat.BUSINESS_BALANCE_NOT);
                        }
                    }
                }
            }
            //新增订单关闭消息
            CereNotice cereNotice=new CereNotice();
            cereNotice.setNoticeType(IntegerEnum.NOTICE_TYPE_SYSTEM.getCode());
            cereNotice.setJump(IntegerEnum.NOTICE_JUMP_ORDER.getCode());
            cereNotice.setBuyerUserId(order.getBuyerUserId());
            cereNotice.setShopId(order.getShopId());
            cereNotice.setNoticeTitle(StringEnum.NOTICE_TITLE_ORDER_CANCEL.getCode());
            cereNotice.setNoticeContent("您未在规定时间完成付款，订单"+order.getOrderFormid()+"已关闭,点击查看详情");
            cereNotice.setOnly(order.getOrderId());
            cereNotice.setCreateTime(time);
            cereNotice.setIfRead(IntegerEnum.NO.getCode());
            cereNoticeService.insert(cereNotice);
        }
    }

    private BigDecimal getBalance(FlowingWater flowingWater) {
        BigDecimal decimal=BigDecimal.ZERO;
        //根据该流水发生时间查询截止到这个时间为止的冻结金额
        BigDecimal frozen = cereShopOrderDAO.getTurnoverByTime(flowingWater);
        //根据该流水发生时间查询截止到这个时间为止的提现中金额
        BigDecimal decimal1 = cereShopOrderDAO.getWithdrawableStayMoneyByTime(flowingWater);
        //根据该流水发生时间查询截止到这个时间为止的总可提现金额
        BigDecimal decimal2 = cereShopOrderDAO.getAllWithdrawableMoneyByTime(flowingWater);
        //根据该流水发生时间查询截止到这个时间为止的已提现金额
        BigDecimal decimal3 = cereShopOrderDAO.getWithdrawableMoneyByTime(flowingWater);
        //计算可提现金额=总的提现金额-提现中金额-已提现金额
        BigDecimal decimal4=decimal2.subtract(decimal1).subtract(decimal3);
        return decimal.add(frozen).add(decimal4);
    }

    @Override
    @Transactional(isolation= Isolation.DEFAULT,propagation= Propagation.REQUIRED,rollbackFor = {CoBusinessException.class, Exception.class})
    public void handleRefundWxLog(String orderFormId, String transaction_id, String orderNo) throws Exception {
        String time = TimeUtils.yyMMddHHmmss();
        //查询订单数据
        CereShopOrder order=cereShopOrderDAO.findByOrderFormid(orderFormId);
        if(order!=null){
            //新增对账单数据
            CereOrderReconciliation reconciliation=new CereOrderReconciliation();
            reconciliation.setOrderId(order.getOrderId());
            reconciliation.setMoney(order.getPrice());
            reconciliation.setState(IntegerEnum.RELATIONSHIP_SOLVE_FROZEN.getCode());
            reconciliation.setType(IntegerEnum.RELATIONSHIP_ONCOME.getCode());
            reconciliation.setCreateTime(time);
            cereOrderReconciliationService.insert(reconciliation);
            //查询支付流水
            CerePayLog cerePayLog=cereShopOrderDAO.findPayLog(order.getOrderFormid());
            //插入退款流水
            CerePayLog payLog=new CerePayLog();
            payLog.setCreateTime(time);
            payLog.setOrderFormid(order.getOrderFormid());
            payLog.setOutTradeNo(orderNo);
            payLog.setTransactionId(transaction_id);
            payLog.setPaymentMode(order.getPaymentMode());
            payLog.setShopId(order.getShopId());
            payLog.setState(StringEnum.PAY_LOG_REFUND.getCode());
            payLog.setTotalFee(order.getPrice());
            payLog.setUserId(String.valueOf(order.getBuyerUserId()));
            payLog.setOutRefundNo(cerePayLog.getOutRefundNo());
            payLog.setRemark(order.getCustomerName()+"取消订单退款"+order.getPrice()+"元,退款单号为："+cerePayLog.getOutRefundNo()
                    +",退款时间为"+time);
            cerePayLogService.insert(payLog);

            //更新订单状态为已取消
            order.setUpdateTime(time);
            order.setState(IntegerEnum.ORDER_STOP.getCode());
            order.setPrice(BigDecimal.ZERO);
            order.setPaymentState(IntegerEnum.NO.getCode());
            cereShopOrderDAO.updateByPrimaryKeySelective(order);
        }
    }

    @Override
    public List<CereShopOrder> findUnPayBySeckillId(Long shopSeckillId) {
        return cereShopOrderDAO.findUnPayBySeckillId(shopSeckillId);
    }

    @Override
    public void updateBatchCancelOrder(List<CereShopOrder> list) throws CoBusinessException {
        String time = TimeUtils.yyMMddHHmmss();
        for (CereShopOrder order : list) {
            //更新订单状态为已关闭
            order.setState(IntegerEnum.ORDER_STOP.getCode());
            order.setUpdateTime(time);
            cereShopOrderDAO.updateByPrimaryKeySelective(order);
            if(!EmptyUtils.isEmpty(order.getCouponId())){
                //修改平台优惠券状态为已领取
                CereBuyerCoupon cereBuyerCoupon=new CereBuyerCoupon();
                cereBuyerCoupon.setBuyerUserId(order.getBuyerUserId());
                cereBuyerCoupon.setCouponId(order.getCouponId());
                cereBuyerCoupon.setUpdateTime(time);
                cereBuyerCoupon.setState(IntegerEnum.COUPON_HAVE.getCode());
                cereBuyerCouponService.updateByUserIdAndCouponId(cereBuyerCoupon);
            }
            if(!EmptyUtils.isEmpty(order.getId())){
                //修改店铺优惠券状态为已领取
                CereBuyerShopCoupon cereBuyerShopCoupon=new CereBuyerShopCoupon();
                cereBuyerShopCoupon.setId(order.getId());
                cereBuyerShopCoupon.setUpdateTime(time);
                cereBuyerShopCoupon.setState(IntegerEnum.COUPON_HAVE.getCode());
                cereBuyerShopCouponService.updateState(cereBuyerShopCoupon);
            }
            //拿到商品库存数据
            List<CereProductSku> productSkus=cereProductSkuService.findStockNumberByOrderId(order.getOrderId());
            if(!EmptyUtils.isEmpty(productSkus)){
                productSkus.forEach(sku -> {
                    Object obj = stringRedisService.get(String.valueOf(sku.getSkuId()));
                    Integer stockNumber=  obj==null?0:(Integer)obj;
                    stringRedisService.set(String.valueOf(sku.getSkuId()),stockNumber+sku.getStockNumber());
                });
            }
            if(!EmptyUtils.isEmpty(productSkus)){
                //批量更新库存数据
                cereShopOrderDAO.updateBatchStock(productSkus);
            }
            if(!EmptyUtils.isEmpty(order.getShopSeckillId())){
                //查询秒杀活动数据
                CereShopSeckill cereShopSeckill=cereShopSeckillService.findById(order.getShopSeckillId());
                if(IntegerEnum.YES.getCode().equals(cereShopSeckill.getIfNumber())){
                    //如果限量,需要更新限量库存数据
                    List<CereShopSeckillDetail> seckillDetails=cereShopSeckillDetailService.findNumberDetails(order.getOrderId(),cereShopSeckill.getShopSeckillId());
                    if(!EmptyUtils.isEmpty(seckillDetails)){
                        //更新redis限量库存
                        seckillDetails.forEach(detail -> {
                            stringRedisService.set("秒杀活动商品仅剩件数"+detail.getShopSeckillId() + detail.getSkuId(),detail.getNumber());
                        });
                        cereShopSeckillDetailService.updateBatch(seckillDetails);
                    }
                }
            }
            if(!EmptyUtils.isEmpty(order.getShopDiscountId())){
                //查询秒杀活动数据
                CereShopDiscount cereShopDiscount=cereShopDiscountService.findById(order.getShopDiscountId());
                if(IntegerEnum.YES.getCode().equals(cereShopDiscount.getIfNumber())){
                    //如果限量,需要更新限量库存数据
                    List<CereShopDiscountDetail> discountDetails=cereShopDiscountDetailService.findNumberDetails(order.getOrderId(),cereShopDiscount.getShopDiscountId());
                    if(!EmptyUtils.isEmpty(discountDetails)){
                        //更新redis限量库存
                        discountDetails.forEach(detail -> {
                            stringRedisService.set("限时折扣活动商品仅剩件数"+detail.getShopDiscountId() + detail.getSkuId(),detail.getNumber());
                        });
                        cereShopDiscountDetailService.updateBatch(discountDetails);
                    }
                }
            }
            //新增订单关闭消息
            CereNotice cereNotice=new CereNotice();
            cereNotice.setNoticeType(IntegerEnum.NOTICE_TYPE_SYSTEM.getCode());
            cereNotice.setJump(IntegerEnum.NOTICE_JUMP_ORDER.getCode());
            cereNotice.setBuyerUserId(order.getBuyerUserId());
            cereNotice.setShopId(order.getShopId());
            cereNotice.setNoticeTitle(StringEnum.NOTICE_TITLE_ORDER_CANCEL.getCode());
            cereNotice.setNoticeContent("您未在规定时间完成付款，订单"+order.getOrderFormid()+"已关闭,点击查看详情");
            cereNotice.setOnly(order.getOrderId());
            cereNotice.setCreateTime(time);
            cereNotice.setIfRead(IntegerEnum.NO.getCode());
            cereNoticeService.insert(cereNotice);
        }
    }

    @Override
    public List<CereShopOrder> findUnPayByDiscountId(Long shopDiscountId) {
        return cereShopOrderDAO.findUnPayByDiscountId(shopDiscountId);
    }

    @Override
    public List<ShopOrder> syncOrderList(Long shopId, Long lastOrderId, Integer pageSize) {
        List<CereShopOrder> list=cereShopOrderDAO.selectList(Wrappers.<CereShopOrder>lambdaQuery()
                .eq(CereShopOrder::getShopId, shopId)
                .gt(lastOrderId != null, CereShopOrder::getOrderId, lastOrderId)
                .orderByAsc(CereShopOrder::getOrderId)
                .last("limit " + pageSize));
        List<ShopOrder> result = new ArrayList<>();
        //过滤空对象list
        List<Long> buyerUserIdList = list.stream().map(CereShopOrder::getBuyerUserId).collect(Collectors.toList());
        Map<Long, CereBuyerUser> userUnionIdMap = new HashMap<>();
        if (CollectionUtils.isNotEmpty(buyerUserIdList)) {
            userUnionIdMap = cereBuyerUserDAO.selectBatchIds(buyerUserIdList).stream().collect(Collectors.toMap(CereBuyerUser::getBuyerUserId, Function.identity()));
        }
        for (CereShopOrder order:list) {
            ShopOrder shopOrder = new ShopOrder();
            BeanUtils.copyProperties(order, shopOrder);
            List<Product> products=cereShopOrderDAO.getProducts(order.getOrderId());
            shopOrder.setProducts(products);
            Optional.of(userUnionIdMap.get(order.getBuyerUserId())).ifPresent(obj -> {
                shopOrder.setUnionId(obj.getWechatUnionId());
                shopOrder.setBuyerPhone(obj.getPhone());
            });
            result.add(shopOrder);
        }
        return result;
    }

    public static void main(String[] args) {
        List<CereBuyerUser> userList = new ArrayList<>();
        CereBuyerUser user1 = new CereBuyerUser();
        user1.setBuyerUserId(1L);
        userList.add(user1);
        Map<Long, String> map = userList.stream().collect(Collectors.toMap(CereBuyerUser::getBuyerUserId, CereBuyerUser::getWechatUnionId));
        System.out.println(JSON.toJSONString(map) + " " + map.get(1L));
    }

    @Override
    public void updateOrderPrice(UpdateOrderPriceParam param, CerePlatformBusiness user) throws CoBusinessException {
        CereShopOrder shopOrder = cereShopOrderDAO.selectById(param.getOrderId());
        if (shopOrder != null && IntegerEnum.ORDER_STAY_PAY.getCode().equals(shopOrder.getState())
                && shopOrder.getShopId().equals(user.getShopId())) {
            String time = TimeUtils.yyMMddHHmmss();
            CereOrderParent orderParent = cereOrderParentDAO.selectById(shopOrder.getParentId());
            //改价后，新增的价格，有可能是负数
            BigDecimal addedPrice = param.getPrice().subtract(shopOrder.getPrice());
            orderParent.setPrice(orderParent.getPrice().add(addedPrice));
            orderParent.setUpdateTime(time);
            cereOrderParentDAO.updateById(orderParent);

            CereShopOrder updater = new CereShopOrder();
            updater.setOrderId(shopOrder.getOrderId());
            updater.setOldPrice(shopOrder.getPrice());
            updater.setPrice(param.getPrice());
            updater.setUpdateTime(time);
            cereShopOrderDAO.updateById(updater);
            cerePlatformLogService.addLog(user,"订单管理","订单改价","订单改价",param.getOrderId(),time);
        }
    }

    @Override
    public Map<Long, Integer> selectSalesVolumeBySkuIdList(List<Long> skuIdList) {
        List<Map<String, Object>> map = cereShopOrderDAO.selectSalesVolumeBySkuIdList(skuIdList);
        Map<Long, Integer> salesVolumeMap = new HashMap<>();
        map.forEach(item -> {
            salesVolumeMap.put(Long.parseLong(item.get("sku_id").toString()), Integer.parseInt(item.get("sales_volume").toString()));
        });
        for (Long skuId:skuIdList) {
            salesVolumeMap.putIfAbsent(skuId, 0);
        }
        return salesVolumeMap;
    }
}
