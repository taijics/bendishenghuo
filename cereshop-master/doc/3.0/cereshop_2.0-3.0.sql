SET FOREIGN_KEY_CHECKS=0;

ALTER TABLE `cere_buyer_user` MODIFY COLUMN `terminal` int(11) NOT NULL COMMENT '注册来源 0-未知 1-APP 2-微信小程序 3-H5 4-支付宝小程序 5-PC 6-商家端后台' AFTER `credit`;

ALTER TABLE `cere_collage_order_detail` ADD INDEX `idx_cere_collage_order_detail_order_id`(`order_id`) USING BTREE;

ALTER TABLE `cere_order_after` ADD INDEX `idx_cere_order_after_order_id`(`order_id`) USING BTREE;

ALTER TABLE `cere_order_dilever` ADD INDEX `idx_cere_order_dilever_order_id`(`order_id`) USING BTREE;

ALTER TABLE `cere_order_product` ADD INDEX `idx_cere_order_product_order_id`(`order_id`) USING BTREE;

ALTER TABLE `cere_order_product` ADD INDEX `idx_product_id`(`product_id`) USING BTREE;

ALTER TABLE `cere_pay_log` ADD INDEX `idx_cere_pay_log_order_formid`(`order_formid`) USING BTREE;

ALTER TABLE `cere_platform_canvas` MODIFY COLUMN `json` longtext NULL COMMENT '画布json数据' AFTER `terminal`;

ALTER TABLE `cere_platform_canvas` ADD UNIQUE INDEX `uk_terminal_type`(`shop_id`, `terminal`, `type`) USING BTREE;

ALTER TABLE `cere_product_image` ADD INDEX `idx_cere_product_image_product_id`(`product_id`) USING BTREE;

ALTER TABLE `cere_product_sku` ADD INDEX `idx_cere_product_sku_product_id`(`product_id`) USING BTREE;

ALTER TABLE `cere_shop_order` ADD INDEX `idx_cere_shop_order_shop_id`(`shop_id`) USING BTREE;

ALTER TABLE `cere_shop_order` ADD INDEX `idx_cere_shop_order_buyer_user_id`(`buyer_user_id`) USING BTREE;

ALTER TABLE `cere_shop_order` ADD INDEX `idx_cere_shop_order_order_id`(`order_id`) USING BTREE;

ALTER TABLE `cere_shop_product` DROP INDEX `index`;

ALTER TABLE `cere_sku_name` ADD INDEX `idx_cere_sku_name_sku_id`(`sku_id`) USING BTREE;

ALTER TABLE `cere_sku_real_info` ADD COLUMN `if_enable` tinyint(2) NOT NULL DEFAULT 1 COMMENT '活动预热   1-停用  2-启用' AFTER `limit_number`;

ALTER TABLE `cere_sku_real_info` ADD COLUMN `enable_time` int(11) NOT NULL DEFAULT 0 COMMENT '预热几小时前' AFTER `if_enable`;

ALTER TABLE `cere_sku_real_info` ADD COLUMN `sales_user_count` int(11) NOT NULL DEFAULT 0 COMMENT '商品维度的下单人数 只要下过单的都算' AFTER `enable_time`;

ALTER TABLE `cere_sku_real_info` ADD COLUMN `start_time` varchar(20) NOT NULL DEFAULT '' COMMENT '活动开始时间' AFTER `product_sales_volume`;

ALTER TABLE `cere_sku_real_info` ADD COLUMN `end_time` varchar(20) NOT NULL DEFAULT '' COMMENT '活动开始时间' AFTER `start_time`;

ALTER TABLE `cere_sku_real_info` ADD COLUMN `state` int(11) NOT NULL DEFAULT 0 COMMENT '活动状态 对于平台端 0-报名未开始 1-报名进行中 2-活动待开始 3-活动进行中 4-活动已结束; 对于商家端  0-未开始 1-进行中 2-已结束' AFTER `end_time`;

SET FOREIGN_KEY_CHECKS=1;