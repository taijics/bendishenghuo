alter table cere_platform_user
add column `avatar` varchar(256) DEFAULT NULL COMMENT '头像' after `email`;

create table cere_buyer_track_report
(
    id bigint(20) not null auto_increment,
    event_type int(11) not null default 1 comment '事件类型 1-商品详情页访问5s, 2-添加到购物车, 3-提交订单',
    product_ids varchar(4096) default null comment '商品id列表, 用,分割',
    create_time varchar(20) not null comment '创建时间',
    create_user bigint(20) not null comment '创建人id',
    primary key (`id`),
    key idx_create_user (`create_user`)
) comment '用户埋点上报';

alter table cere_shop_order
add column `old_price` decimal(15,2) DEFAULT NULL COMMENT '改价前的支付金额' after `price`;

alter table cere_buyer_user
add column `terminal` int(11) not null default 0 comment '终端 1-APP 2-微信小程序 3-H5 4-支付宝小程序 5-PC' after `credit`;

create table cere_product_stats_by_day
(
    create_date char(10) not null comment '日期',
    product_id bigint(20) not null comment '商品id',
    shop_id bigint(20) not null comment '店铺id',
    add_cart_count int(11) not null default 0 comment '加购量',
    visit_count int(11) not null default 0 comment '访问量',
    sales_volume int(11) not null default 0 comment '销量',
    primary key (`create_date`, `product_id`),
    key idx_product_id (`product_id`),
    key idx_shop_id (`shop_id`)
) comment '商品日度统计表';


ALTER TABLE `cere_buyer_comment_like`
ADD PRIMARY KEY (`comment_id`, `buyer_user_id`);

ALTER TABLE `cere_order_product`
ADD COLUMN `actual_price` decimal(15, 6) NOT NULL DEFAULT 0 COMMENT '该sku实际总支付价格，不算运费和积分' AFTER `product_price`;

ALTER TABLE `cere_sign_product`
ADD INDEX `idx_sign_id`(`sign_id`) USING BTREE,
ADD INDEX `idx_productt_id`(`product_id`) USING BTREE;

ALTER TABLE `cere_buyer_coupon`
ADD COLUMN `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键id' FIRST,
ADD PRIMARY KEY (`id`);

ALTER TABLE `cere_shop_coupon`
ADD INDEX `idx_shop_id`(`shop_id`) USING BTREE;

create table cere_shop_customer_service
(
    `id` bigint(20) not null auto_increment comment '主键id',
    `shop_id` bigint(20) not null comment '店铺id',
    `open_kfid` varchar(64) not null comment '客服id',
    `create_time` varchar(20) DEFAULT NULL COMMENT '创建时间',
    `update_time` varchar(20) DEFAULT NULL COMMENT '更新时间',
    primary key (`id`),
    key idx_shop_id(`shop_id`)
) comment '店铺客服关联表';

ALTER TABLE `cere_shop_distribution_level`
ADD COLUMN `level_logo` varchar(1024) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '等级图标' AFTER `level_num`;

ALTER TABLE `cere_logistics_charge` MODIFY COLUMN `region` text NOT NULL COMMENT '配送区域 省-市' AFTER `logistics_id`;

ALTER TABLE `cere_order_product` MODIFY COLUMN `logistics_price` decimal(15, 4) NOT NULL DEFAULT 0.0000 COMMENT '运费' AFTER `use_credit_amount`;
