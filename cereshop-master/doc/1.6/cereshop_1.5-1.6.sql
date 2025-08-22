

SET FOREIGN_KEY_CHECKS=0;

ALTER TABLE `cereshop1.5`.`cere_buyer_coupon` ADD COLUMN `source` int(11) NOT NULL DEFAULT 1 COMMENT '来源 1-正常领取 2-营销发券 3-积分兑换 4-支付有礼' AFTER `reduce_money`;

ALTER TABLE `cereshop1.5`.`cere_buyer_coupon` ADD COLUMN `coupon_code` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '微信卡券的coupon_code' AFTER `source`;

ALTER TABLE `cereshop1.5`.`cere_buyer_polite_record` ADD COLUMN `credit` int(11) NOT NULL DEFAULT 0 COMMENT '奖励的积分' AFTER `growth`;

ALTER TABLE `cereshop1.5`.`cere_buyer_polite_record` MODIFY COLUMN `polite_type` tinyint(4) NOT NULL COMMENT '奖励类型 1-成长值，2-满减券，3-折扣券, 4-积分' AFTER `polite_id`;

ALTER TABLE `cereshop1.5`.`cere_buyer_user` ADD COLUMN `credit` int(11) NOT NULL DEFAULT 0 COMMENT '积分值' AFTER `growth`;

CREATE TABLE `cereshop1.5`.`cere_channel_coupon`  (
  `shop_coupon_id` bigint(20) NOT NULL COMMENT '优惠券id',
  `product_id` bigint(20) NOT NULL COMMENT '商品id',
  `shop_id` bigint(20) NOT NULL COMMENT '店铺id',
  `create_time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '创建时间',
  `update_time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '更新时间',
  PRIMARY KEY (`shop_coupon_id`, `product_id`) USING BTREE,
  INDEX `idx_shop_id`(`shop_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '渠道券表' ROW_FORMAT = Dynamic;

CREATE TABLE `cereshop1.5`.`cere_close_advert`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `buyer_user_id` bigint(20) NULL DEFAULT NULL COMMENT '用户id',
  `device_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '设备id',
  `trigger_condition` int(11) NOT NULL DEFAULT 1 COMMENT '触发页面 1-首页 2-支付完成页',
  `close_date` date NOT NULL COMMENT '关闭日期',
  `create_time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '创建时间',
  `update_time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_buyer_user_id`(`buyer_user_id`) USING BTREE,
  INDEX `idx_device_id`(`device_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '关闭广告记录表' ROW_FORMAT = Dynamic;

CREATE TABLE `cereshop1.5`.`cere_credit_record`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `buyer_user_id` bigint(20) NOT NULL COMMENT '用户id',
  `record_type` int(11) NOT NULL DEFAULT 1 COMMENT '流水类型 1-收入 2-支出',
  `opt_type` int(11) NOT NULL DEFAULT 0 COMMENT '操作类型 参考OptTypeEnum',
  `record_content` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT '' COMMENT '操作描述',
  `credit` int(11) NOT NULL DEFAULT 0 COMMENT '本次收入或支出积分',
  `remain_credit` int(11) NOT NULL DEFAULT 0 COMMENT '剩余积分',
  `create_time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '创建时间',
  `update_time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_buyer_user_id`(`buyer_user_id`) USING BTREE COMMENT '用户id索引'
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '积分流水表' ROW_FORMAT = Dynamic;

CREATE TABLE `cereshop1.5`.`cere_credit_sign_setting`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `day` int(11) NOT NULL DEFAULT 1 COMMENT '第几天',
  `credit` int(11) NOT NULL DEFAULT 0 COMMENT '赠送积分值',
  `display` int(11) NOT NULL DEFAULT 1 COMMENT '是否显示 1-是 0-否',
  `sort` int(11) NOT NULL DEFAULT 1 COMMENT '排序',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '积分签到配置' ROW_FORMAT = Dynamic;

CREATE TABLE `cereshop1.5`.`cere_credit_signin_record`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '签到id',
  `buyer_user_id` bigint(20) NOT NULL COMMENT '客户id',
  `term_id` int(11) NOT NULL DEFAULT 1 COMMENT '轮询id,第一天签到则为1，第2天签到则为2，连续签到值越来越大',
  `continue_day` int(11) NOT NULL DEFAULT 1 COMMENT '连续第几天签到',
  `credit` int(11) NOT NULL DEFAULT 10 COMMENT '奖励的积分',
  `create_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_buyer_user_id`(`buyer_user_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '积分签到表' ROW_FORMAT = Dynamic;

CREATE TABLE `cereshop1.5`.`cere_customer_service_config`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `shop_id` bigint(20) NOT NULL COMMENT '店铺id',
  `create_time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '创建时间',
  `update_time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '更新时间',
  `permanent_code` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '永久授权码',
  `auth_corp_id` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '授权企业的id',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `idx_shop_id`(`shop_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '商家客服配置表' ROW_FORMAT = Dynamic;

CREATE TABLE `cereshop1.5`.`cere_live`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `shop_id` bigint(20) NOT NULL COMMENT '店铺id',
  `title` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '标题',
  `anchor_nickname` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '主播昵称',
  `anchor_wechat` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '主播微信号',
  `anchor_head_img` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '主播头像',
  `live_type` int(11) NULL DEFAULT NULL COMMENT '直播间类型 0-手机直播 1-推流',
  `screen_type` int(11) NULL DEFAULT NULL COMMENT '屏幕方向 0-竖屏 1-横屏',
  `close_like` int(11) NULL DEFAULT NULL COMMENT '是否关闭点赞',
  `close_goods_shelf` int(11) NULL DEFAULT NULL COMMENT '是否关闭商品上架',
  `close_comment` int(11) NULL DEFAULT NULL COMMENT '是否关闭评论',
  `close_playback` int(11) NULL DEFAULT NULL COMMENT '是否关闭回放',
  `close_share` int(11) NULL DEFAULT NULL COMMENT '是否关闭分享',
  `close_service` int(11) NULL DEFAULT NULL COMMENT '是否关闭客服',
  `close_appointment` int(11) NULL DEFAULT NULL COMMENT '是否关闭直播预约',
  `start_time` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '开始时间',
  `end_time` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '结束时间',
  `cover_img` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '直播间背景图',
  `share_img` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '直播间分享图片',
  `feeds_img` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '封面图',
  `cover_media_id` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '背景图媒体id',
  `share_media_id` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '分享图媒体id',
  `feeds_media_id` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '封面图媒体id',
  `room_id` int(11) NULL DEFAULT NULL COMMENT '微信端-直播间id',
  `state` int(11) NULL DEFAULT NULL COMMENT '状态: 0 - 待审核 1 - 审核已通过 2 - 审核未通过',
  `remark` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '审核备注',
  `create_time` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '直播表' ROW_FORMAT = Dynamic;

CREATE TABLE `cereshop1.5`.`cere_live_examine`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `live_id` bigint(20) NOT NULL COMMENT '直播间id',
  `re_examine_date` date NOT NULL COMMENT '重新审核日期',
  `create_time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '创建时间',
  `update_time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '更新时间',
  INDEX `id`(`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '直播间重新审核表' ROW_FORMAT = Dynamic;

CREATE TABLE `cereshop1.5`.`cere_live_product`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `shop_id` bigint(20) NOT NULL COMMENT '店铺id',
  `product_id` bigint(20) NOT NULL COMMENT '商品id',
  `goods_id` int(11) NULL DEFAULT NULL COMMENT '微信直播商品id',
  `product_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品名称',
  `product_image` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品封面图',
  `product_image_media_id` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商品封面图媒体id',
  `price_type` int(11) NOT NULL COMMENT '价格类型 1- 一口价 2-价格区间 3-折扣价',
  `fixed_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '一口价 当price_type = 1时有值',
  `market_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '市场价 当price_type = 3时有值',
  `original_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '现价 当price_type = 3时可能有值',
  `min_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '最低价 当price_type = 2时有值',
  `max_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '最高价 当price_type = 2时有值',
  `stock_number` int(11) NOT NULL DEFAULT 0 COMMENT '商品库存',
  `total` int(11) NOT NULL COMMENT '商品初始库存',
  `state` int(11) NULL DEFAULT NULL COMMENT '状态 0-待审核 1-审核通过 2-审核失败',
  `remark` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  `create_time` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '创建时间',
  `update_time` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '直播间商品表' ROW_FORMAT = Dynamic;

CREATE TABLE `cereshop1.5`.`cere_live_product_examine`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `live_product_id` bigint(20) NOT NULL COMMENT '直播商品id',
  `re_examine_date` date NOT NULL COMMENT '重新审核日期',
  `create_time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '创建时间',
  `update_time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '更新时间',
  INDEX `id`(`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '直播间商品重新审核表' ROW_FORMAT = Dynamic;

CREATE TABLE `cereshop1.5`.`cere_live_product_rel`  (
  `live_id` bigint(20) NOT NULL COMMENT '直播间id',
  `live_product_id` bigint(20) NOT NULL COMMENT '直播间商品id, 关联cere_live_product的id',
  `create_time` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '创建时间',
  `update_time` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '修改时间',
  PRIMARY KEY (`live_id`, `live_product_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '直播间和直播间商品的关联表' ROW_FORMAT = Dynamic;

CREATE TABLE `cereshop1.5`.`cere_live_sale_stat`  (
  `product_id` bigint(20) NOT NULL COMMENT '商品id',
  `sale_number` int(11) NOT NULL DEFAULT 0 COMMENT '直播销量',
  `sale_amount` decimal(10, 2) NOT NULL COMMENT '直播销售额',
  PRIMARY KEY (`product_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '直播商品销售统计' ROW_FORMAT = Dynamic;

CREATE TABLE `cereshop1.5`.`cere_live_subscribe`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `live_id` bigint(20) NOT NULL COMMENT '直播间id',
  `buyer_user_id` bigint(20) NOT NULL COMMENT '用户id',
  `create_time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '创建时间',
  `update_time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '直播订阅表' ROW_FORMAT = Dynamic;

ALTER TABLE `cereshop1.5`.`cere_order_product` ADD COLUMN `type` tinyint(1) NULL DEFAULT NULL COMMENT '所属订单类型  1-常规订单 2-赠品营销子订单' AFTER `weight`;

ALTER TABLE `cereshop1.5`.`cere_order_product` ADD COLUMN `write_number` int(10) NULL DEFAULT NULL COMMENT '已核销数量' AFTER `type`;

ALTER TABLE `cereshop1.5`.`cere_order_product` ADD COLUMN `write_code` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '核销码地址' AFTER `write_number`;

ALTER TABLE `cereshop1.5`.`cere_order_product` ADD COLUMN `use_credit` int(11) NOT NULL DEFAULT 0 COMMENT '该sku抵扣的积分' AFTER `activity_id`;

ALTER TABLE `cereshop1.5`.`cere_order_product` ADD COLUMN `use_credit_amount` decimal(15, 2) NOT NULL DEFAULT 0.00 COMMENT '该sku积分抵扣的金额' AFTER `use_credit`;

ALTER TABLE `cereshop1.5`.`cere_platform_activity` ADD COLUMN `if_credit` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否开启积分兑换 1-是 0-否' AFTER `image`;

ALTER TABLE `cereshop1.5`.`cere_platform_activity` ADD COLUMN `credit` int(11) NOT NULL DEFAULT 0 COMMENT '兑换所需积分' AFTER `if_credit`;

ALTER TABLE `cereshop1.5`.`cere_platform_activity` ADD COLUMN `apply_type` int(11) NOT NULL DEFAULT 1 COMMENT '可用范围 1-全部 2-选择类别' AFTER `credit`;

ALTER TABLE `cereshop1.5`.`cere_platform_activity` ADD COLUMN `apply_category` bigint(20) NULL DEFAULT NULL COMMENT '可用类别' AFTER `apply_type`;

ALTER TABLE `cereshop1.5`.`cere_platform_activity` ADD COLUMN `sync_card` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否同步微信卡券 1-同步 0-不同步' AFTER `apply_category`;

ALTER TABLE `cereshop1.5`.`cere_platform_activity` ADD COLUMN `card_title` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '卡券标题' AFTER `sync_card`;

ALTER TABLE `cereshop1.5`.`cere_platform_activity` ADD COLUMN `card_color` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '卡券主题色' AFTER `card_title`;

ALTER TABLE `cereshop1.5`.`cere_platform_activity` ADD COLUMN `card_notice` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '卡券使用须知' AFTER `card_color`;

ALTER TABLE `cereshop1.5`.`cere_platform_activity` ADD COLUMN `card_id` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '关联的微信卡券id' AFTER `card_notice`;

ALTER TABLE `cereshop1.5`.`cere_platform_business` MODIFY COLUMN `token` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '商家用户token' AFTER `email`;

CREATE TABLE `cereshop1.5`.`cere_platform_collection`  (
  `id` bigint(11) NOT NULL AUTO_INCREMENT,
  `collection_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '平台收款码地址',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '平台收款码信息表' ROW_FORMAT = Dynamic;


ALTER TABLE `cereshop1.5`.`cere_platform_polite` ADD COLUMN `credit` int(11) NULL DEFAULT NULL COMMENT '积分' AFTER `growth`;

ALTER TABLE `cereshop1.5`.`cere_platform_shop` ADD COLUMN `divide` int(10) NULL DEFAULT NULL COMMENT '交易分成比例' AFTER `update_time`;

ALTER TABLE `cereshop1.5`.`cere_platform_shop` ADD COLUMN `collection_code` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '平台收款码' AFTER `divide`;

ALTER TABLE `cereshop1.5`.`cere_platform_shop` ADD COLUMN `audit_live` tinyint(1) NULL DEFAULT 1 COMMENT '审核直播间 1-开启 0-关闭' AFTER `collection_code`;

ALTER TABLE `cereshop1.5`.`cere_platform_shop` ADD COLUMN `audit_live_product` tinyint(1) NULL DEFAULT 1 COMMENT '审核直播间商品 1-开启 0-关闭' AFTER `audit_live`;


ALTER TABLE `cereshop1.5`.`cere_platform_user` MODIFY COLUMN `token` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '账户token' AFTER `email`;

CREATE TABLE `cereshop1.5`.`cere_popup_advert`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT '' COMMENT '广告名称',
  `start_time` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '开始时间',
  `end_time` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '结束时间',
  `popup_img` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '弹窗广告图片',
  `close_img` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '关闭图片',
  `jump_type` int(11) NOT NULL COMMENT '跳转类型 1-商品 2-分类 3-优惠券 4-小程序 5-公众号文章',
  `jump_content` varchar(8192) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '跳转内容，根据jump_type不同存储不同的内容',
  `trigger_condition` int(11) NOT NULL DEFAULT 1 COMMENT '触发条件 1-首页 2-支付完成页',
  `apply_group` int(11) NOT NULL DEFAULT 1 COMMENT '应用人群 1-所有人 2-会员',
  `state` int(11) NOT NULL DEFAULT 1 COMMENT '状态 1-有效 0-无效',
  `create_time` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '弹窗广告表' ROW_FORMAT = Dynamic;

CREATE TABLE `cereshop1.5`.`cere_risk_black`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `type` int(11) NOT NULL COMMENT '类型 1：ip  2:用户',
  `ip` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'ip地址',
  `buyer_user_id` bigint(20) NULL DEFAULT NULL COMMENT '用户id',
  `state` tinyint(1) NULL DEFAULT 1 COMMENT '是否有效，0否 1是',
  `create_time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '创建时间',
  `update_time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '黑名单表' ROW_FORMAT = Dynamic;

CREATE TABLE `cereshop1.5`.`cere_risk_rule`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `rule_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '规则名称',
  `status` int(11) NOT NULL DEFAULT 0 COMMENT '状态 0未发布 1已发布',
  `rule_type` int(11) NOT NULL COMMENT '触发条件 1：满足任一一项  2：满足所有',
  `rule_place_order_limit` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建订单数限制规则，json保存参数',
  `rule_wait_pay_limit` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '待付款订单数限制规则，json保存参数',
  `rule_sku_limit` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '单sku商品采购数限制规则，json保存参数',
  `rule_post_sale_limit` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '单sku商品采购数限制规则，json保存参数',
  `rule_switch_post_sale` int(11) NOT NULL DEFAULT 0 COMMENT '售后规则开关  0关闭 1开启',
  `rule_switch_sku` int(11) NOT NULL DEFAULT 0 COMMENT '单sku商品规则开关 0关闭 1开启',
  `rule_switch_place_order` int(11) NOT NULL DEFAULT 0 COMMENT '下单规则开关 0关闭 1开启',
  `rule_switch_wait_pay` int(11) NOT NULL DEFAULT 0 COMMENT '待付款规则开关 0关闭 1开启',
  `create_time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '创建时间',
  `update_time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '风控规则表' ROW_FORMAT = Dynamic;

ALTER TABLE `cereshop1.5`.`cere_shop_order` ADD COLUMN `type` tinyint(1) NULL DEFAULT NULL COMMENT '类型 1-常规订单 2-商家收款订单（扫码）' AFTER `scene_id`;

ALTER TABLE `cereshop1.5`.`cere_shop_order` ADD COLUMN `write_state` tinyint(1) NULL DEFAULT NULL COMMENT '核销状态  0-无需核销 1-部分核销 2-已核销' AFTER `type`;

ALTER TABLE `cereshop1.5`.`cere_shop_order` MODIFY COLUMN `state` tinyint(1) NOT NULL COMMENT '订单状态 1-待付款 2-待发货 3-待收货 4-已完成 5-已取消 6-待成团 7-待售后' AFTER `price`;

ALTER TABLE `cereshop1.5`.`cere_shop_product` ADD COLUMN `distribution` tinyint(1) NULL DEFAULT NULL COMMENT '配送属性 1-线下核销 2-快递' AFTER `reject`;

ALTER TABLE `cereshop1.5`.`cere_shop_product` ADD COLUMN `if_gift` tinyint(1) NULL DEFAULT NULL COMMENT '是否参与赠品 1-是 0-否' AFTER `distribution`;

ALTER TABLE `cereshop1.5`.`cere_shop_product` ADD COLUMN `if_credit` tinyint(1) NULL DEFAULT 0 COMMENT '是否积分抵扣 1-是 0-否' AFTER `if_gift`;

ALTER TABLE `cereshop1.5`.`cere_shop_product` ADD COLUMN `credit_limit` int(11) NULL DEFAULT NULL COMMENT '单笔最大抵扣多少积分' AFTER `if_credit`;

ALTER TABLE `cereshop1.5`.`cere_shop_product` MODIFY COLUMN `fictitious_number` int(11) NOT NULL DEFAULT 0 COMMENT '虚拟销量' AFTER `update_time`;


SET FOREIGN_KEY_CHECKS=1;
