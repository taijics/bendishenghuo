/*
 * Copyright (C) 2017-2021
 * All rights reserved, Designed By 深圳中科鑫智科技有限公司
 * Copyright authorization contact 18814114118
 */
package com.shop.cereshop.business.dao.order;

import com.shop.cereshop.business.page.finance.Bank;
import com.shop.cereshop.business.page.finance.Finance;
import com.shop.cereshop.business.page.finance.FlowingWater;
import com.shop.cereshop.business.page.finance.WithdrawalDetail;
import com.shop.cereshop.business.page.index.OrderConvertDTO;
import com.shop.cereshop.business.page.order.Product;
import com.shop.cereshop.business.page.order.ShopOrder;
import com.shop.cereshop.business.page.order.ShopOrderAfter;
import com.shop.cereshop.business.page.order.SkuDetail;
import com.shop.cereshop.business.param.finance.FinanceDetailParam;
import com.shop.cereshop.business.param.finance.FinanceWithdrawalParam;
import com.shop.cereshop.business.param.order.OrderGetAllParam;
import com.shop.cereshop.commons.domain.order.CereShopOrder;
import com.shop.cereshop.commons.domain.pay.CerePayLog;
import com.shop.cereshop.commons.domain.product.CereProductSku;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

@Mapper
public interface CereShopOrderDAO extends BaseMapper<CereShopOrder> {
    int deleteByPrimaryKey(Long orderId);

    CereShopOrder selectByPrimaryKey(Long orderId);

    int updateByPrimaryKeySelective(CereShopOrder record);

    List<ShopOrder> getAll(OrderGetAllParam param);

    ShopOrder getById(@Param("orderId") Long orderId, @Param("shopId") Long shopId);

    Integer getOrderTotals(@Param("buyerUserId") Long buyerUserId);

    List<Product> getProducts(@Param("orderId") Long orderId);

    void updateState(CereShopOrder cereShopOrder);

    BigDecimal getTurnover(@Param("shopId") Long shopId);

    BigDecimal getFrozenMoney(@Param("shopId") Long shopId);

    BigDecimal getWithdrawableMoney(@Param("shopId") Long shopId);

    BigDecimal getAllWithdrawableMoney(@Param("shopId") Long shopId);

    BigDecimal getWithdrawableStayMoney(@Param("shopId") Long shopId);

    List<Finance> getFinanceByDay(@Param("shopId") Long shopId,@Param("time") String time,@Param("type") int type);

    List<Finance> getFinanceByMonth(@Param("shopId") Long shopId,@Param("time") String time,@Param("type") int type);

    Bank getBank(@Param("shopId") Long shopId);

    List<WithdrawalDetail> getWithdrawalDetails(FinanceWithdrawalParam param);

    List<FlowingWater> getDetails(FinanceDetailParam param);

    BigDecimal getTurnoverByTime(FlowingWater flowingWater);

    BigDecimal getWithdrawableStayMoneyByTime(FlowingWater flowingWater);

    BigDecimal getAllWithdrawableMoneyByTime(FlowingWater flowingWater);

    BigDecimal getWithdrawableMoneyByTime(FlowingWater flowingWater);

    List<SkuDetail> findSkuAttribute(@Param("orderProductId") Long orderProductId);

    void updateBatchStock(@Param("skus") List<CereProductSku> skus);

    List<CereShopOrder> findByIds(@Param("ids") List<Long> ids);

    CerePayLog findPayLog(@Param("orderFormid") String orderFormid);

    CereShopOrder findByOrderFormid(@Param("orderFormId") String orderFormId);

    List<CereShopOrder> findUnPayBySeckillId(@Param("shopSeckillId") Long shopSeckillId);

    List<CereShopOrder> findUnPayByDiscountId(@Param("shopDiscountId") Long shopDiscountId);

    List<ShopOrderAfter> findAfter();

    List<OrderConvertDTO> selectWaitToPayStatsByDate(@Param("shopId") Long shopId,
                                                      @Param("startTime") String startTime,
                                                      @Param("endTime") String endTime);

    List<OrderConvertDTO> selectPayStatsByDate(@Param("shopId") Long shopId,
                                                     @Param("startTime") String startTime,
                                                     @Param("endTime") String endTime);

    List<OrderConvertDTO> selectDeliverStatsByDate(@Param("shopId") Long shopId,
                                                     @Param("startTime") String startTime,
                                                     @Param("endTime") String endTime);

    List<OrderConvertDTO> selectAfterSaleStatsByDate(@Param("shopId") Long shopId,
                                                     @Param("startTime") String startTime,
                                                     @Param("endTime") String endTime);

    List<Map<String, Object>> selectSalesVolumeBySkuIdList(List<Long> skuIdList);

}
