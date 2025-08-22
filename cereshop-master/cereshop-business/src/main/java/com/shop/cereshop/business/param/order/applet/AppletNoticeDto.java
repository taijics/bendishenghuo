package com.shop.cereshop.business.param.order.applet;

import lombok.Data;

import java.io.Serializable;
import java.util.List;

/**
 * @ClassName 获取发送通知信息token
 * @Author shixiaokang
 * @Date 2023/6/19
 **/
@Data
public class AppletNoticeDto implements Serializable {

    private OrderKey order_key ;

    /***
     * 发货模式，发货模式枚举值：默认 1、UNIFIED_DELIVERY（统一发货）2、SPLIT_DELIVERY（分拆发货） 示例值: UNIFIED_DELIVERY
     */
    private Integer delivery_mode =1;

    /***
     * 物流模式，发货方式枚举值：默认 1、实体物流配送采用快递公司进行实体物流配送形式
     * 2、同城配送 3、虚拟商品，虚拟商品，例如话费充值，点卡等，无实体配送形式 4、用户自提
     */
    private Integer logistics_type = 1;

    private List<ShippingList> shipping_list;

    private String upload_time;

    private Payer payer;
}


