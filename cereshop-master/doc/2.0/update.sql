CREATE TABLE `cere_brand`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '品牌id',
  `brand_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '品牌名称',
  `brand_logo` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '品牌图标',
  `create_time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '创建时间',
  `update_time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '品牌表' ROW_FORMAT = Dynamic;


CREATE TABLE `cere_channel`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '渠道id',
  `channel_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '渠道名称',
  `register_url` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '渠道注册链接',
  `channel_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '渠道码',
  `create_time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '创建时间',
  `update_time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '渠道表' ROW_FORMAT = Dynamic;


CREATE TABLE `cere_scrm_verify`  (
  `shop_id` bigint(20) NOT NULL COMMENT '店铺id',
  `encode_secret` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '秘钥编码之后的值',
  PRIMARY KEY (`shop_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = 'scrm同步数据配置表' ROW_FORMAT = Dynamic;


CREATE TABLE `cere_shop_channel_activity`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '渠道活动id',
  `shop_id` bigint(20) NOT NULL COMMENT '店铺id',
  `activity_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '活动名称',
  `remark` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '备注',
  `start_time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '开始时间',
  `end_time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '结束时间',
  `publish_count` int(11) NOT NULL DEFAULT 1 COMMENT '活动发放数量',
  `remain_count` int(11) NOT NULL DEFAULT 0 COMMENT '剩余份数',
  `state` int(11) NOT NULL COMMENT '状态 0-未开始 1-已开始 2-已结束',
  `create_time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '创建时间',
  `update_time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '渠道活动表' ROW_FORMAT = Dynamic;


CREATE TABLE `cere_shop_channel_activity_coupon`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '渠道活动id',
  `coupon_id` bigint(20) NOT NULL COMMENT '渠道券id',
  `shop_id` bigint(20) NOT NULL COMMENT '店铺id',
  `create_time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '创建时间',
  `update_time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`, `coupon_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '渠道活动关联渠道券表' ROW_FORMAT = Dynamic;




ALTER TABLE `cere_buyer_user` MODIFY COLUMN `terminal` int(11) NOT NULL COMMENT '注册来源 0-未知 1-APP 2-微信小程序 3-H5 4-支付宝小程序 5-PC' AFTER `credit`;

ALTER TABLE `cere_buyer_user` ADD COLUMN `register_ip` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '注册时的ip' AFTER `terminal`;

ALTER TABLE `cere_buyer_user` ADD COLUMN `last_login_ip` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '最近一次登录时的ip' AFTER `register_ip`;

ALTER TABLE `cere_buyer_user` ADD COLUMN `channel_code` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '渠道编码' AFTER `last_login_ip`;




ALTER TABLE `cere_shop_coupon` ADD COLUMN `take_start` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '领券开始时间' AFTER `time_type`;

ALTER TABLE `cere_shop_coupon` ADD COLUMN `take_end` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '领券结束时间' AFTER `take_start`;

ALTER TABLE `cere_shop_coupon` ADD COLUMN `type` int(11) NOT NULL DEFAULT 1 COMMENT '优惠券分类 1-普通券 2-渠道券' AFTER `if_add`;




ALTER TABLE `cere_shop_product` ADD COLUMN `brand_id` bigint(20) NULL DEFAULT NULL COMMENT '品牌id' AFTER `credit_limit`;

alter table `cere_shop_cart` add UNIQUE KEY `uqe_buyer_user_id_sku_id` (`buyer_user_id`,`sku_id`);

-- 2023-07-07更新
CREATE TABLE `cere_shop_coupon_exclude` (
  `shop_coupon_id` bigint(20) NOT NULL COMMENT '店铺优惠券id',
  `product_id` bigint(20) NOT NULL COMMENT '商品id'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='店铺优惠券商品明细信息表';