
DROP TABLE IF EXISTS `cere_sku_real_info`;

DROP TABLE IF EXISTS `cere_sku_member_real_info`;

CREATE TABLE cere_buyer_product_record (
  buyer_user_id BIGINT (20) NOT NULL COMMENT '用户id',
  product_id BIGINT (20) NOT NULL COMMENT '商品id',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (buyer_user_id, product_id),
  KEY idx_create_time (create_time)
) COMMENT '用户购买过某商品的记录';


alter table cere_shop_product
add column `classify_id1` bigint(20) not null default 0 comment '一级分类id';

alter table cere_shop_product
add column `classify_id2` bigint(20) not null default 0 comment '二级分类id';

alter table cere_shop_product
add column `classify_id3` bigint(20) not null default 0 comment '三级分类id';

alter table cere_shop_product
add key idx_classify_id1(classify_id1);

alter table cere_shop_product
add key idx_classify_id2(classify_id2);

alter table cere_shop_product
add key idx_classify_id3(classify_id3);


alter table cere_product_classify
add key idx_classify_pid(classify_pid);


-- 重建表
CREATE TABLE `cere_sku_member_real_info` (
  `sku_id` bigint(20) NOT NULL COMMENT 'skuId',
  `product_id` bigint(20) NOT NULL COMMENT '商品id',
  `member_level_id` bigint(11) NOT NULL COMMENT '会员等级id, 0为未登录或无等级',
  `activity_type` int(11) NOT NULL COMMENT '参考IntegerEnum.ACTIVITY_TYPE_XXX',
  `activity_id` bigint(20) NOT NULL COMMENT '活动id',
  `cur_price` decimal(10,2) NOT NULL COMMENT '当前价格',
  `cur_original_price` decimal(10,2) NOT NULL COMMENT '当前原价',
  `min_price` decimal(10,2) NOT NULL COMMENT '最小价格',
  `max_price` decimal(10,2) NOT NULL COMMENT '最大价格',
  `limit_number` int(11) NOT NULL DEFAULT '0' COMMENT '限购数量',
  `if_enable` tinyint(2) NOT NULL DEFAULT '1' COMMENT '活动预热   1-停用  2-启用',
  `enable_time` int(11) NOT NULL DEFAULT '0' COMMENT '预热几小时前',
  `if_add` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否可叠加优惠券 0-不可叠加 1-可叠加',
  `person` tinyint(11) NOT NULL DEFAULT '0' COMMENT '成团人数',
  `sales_user_count` int(11) NOT NULL DEFAULT '0' COMMENT '商品维度的下单人数 只要下过单的都算',
  `sales_volume` int(11) NOT NULL DEFAULT '0' COMMENT '当前销量,根据activityType不同而有变化',
  `sku_sales_volume` int(11) NOT NULL DEFAULT '0' COMMENT '该sku总销量',
  `product_sales_volume` int(11) NOT NULL DEFAULT '0' COMMENT '商品总销量',
  `start_time` varchar(20) COLLATE utf8mb4_bin NOT NULL DEFAULT '' COMMENT '活动开始时间',
  `end_time` varchar(20) COLLATE utf8mb4_bin NOT NULL DEFAULT '' COMMENT '活动开始时间',
  `state` int(11) NOT NULL DEFAULT '0' COMMENT '活动状态 对于平台端 0-报名未开始 1-报名进行中 2-活动待开始 3-活动进行中 4-活动已结束; 对于商家端  0-未开始 1-进行中 2-已结束',
  `create_time` varchar(20) COLLATE utf8mb4_bin NOT NULL DEFAULT '1970-01-01 00:00:00' COMMENT '创建时间',
  `update_time` varchar(20) COLLATE utf8mb4_bin NOT NULL DEFAULT '1970-01-01 00:00:00' COMMENT '更新时间',
  PRIMARY KEY (`sku_id`,`member_level_id`) USING BTREE,
  KEY `idx_product_id` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='sku根据会员等级设置价格';


update cere_shop_product a
join cere_product_classify b on b.classify_id = a.classify_id
set a.classify_id3 = b.classify_id, a.classify_id2 = b.classify_pid
where b.classify_level = 3;

update cere_shop_product a
join cere_product_classify b on b.classify_id = a.classify_id
set a.classify_id2 = b.classify_id, a.classify_id1 = b.classify_pid
where b.classify_level = 2;

update cere_shop_product a
join cere_product_classify b on b.classify_id = a.classify_id
set a.classify_id1 = b.classify_id
where b.classify_level = 1;

update cere_shop_product a
join cere_product_classify b on b.classify_id = a.classify_id2
set a.classify_id1 = b.classify_pid;