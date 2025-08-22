/*
 Navicat Premium Data Transfer

 Source Server         : ceres
 Source Server Type    : MySQL
 Source Server Version : 50732
 Source Host           : rm-wz92b6cyd3u358ouquo.mysql.rds.aliyuncs.com:3306
 Source Schema         : cereshop3.0

 Target Server Type    : MySQL
 Target Server Version : 50732
 File Encoding         : 65001

 Date: 29/10/2023 09:43:56
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for cere_activity_sign
-- ----------------------------
DROP TABLE IF EXISTS `cere_activity_sign`;
CREATE TABLE `cere_activity_sign`  (
  `sign_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '报名id',
  `sign_code` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '交易流水号',
  `shop_id` bigint(20) NOT NULL COMMENT '关联店铺id',
  `activity_id` bigint(20) NOT NULL COMMENT '关联活动id',
  `bond_money` decimal(15, 2) NULL DEFAULT NULL COMMENT '保证金',
  `payment_mode` tinyint(1) NULL DEFAULT 1 COMMENT '支付方式  1-微信支付 2-支付宝支付',
  `qr_image` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '收款二维码',
  `state` tinyint(1) NOT NULL DEFAULT 0 COMMENT '审核状态 0-待审核 1-报名成功 2-报名失败 3-报名进行中(未支付)',
  `bond_state` tinyint(1) NULL DEFAULT NULL COMMENT '保证金状态 0-未支付 1-冻结中 2-已退回',
  `payment_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '缴纳时间',
  `return_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '退保时间',
  `remark` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '审核备注',
  `sign_type` tinyint(1) NULL DEFAULT NULL COMMENT '报名活动类型  1-平台优惠券 2-平台秒杀 3-平台限时折扣',
  `create_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`sign_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 193 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '商家报名活动申请信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_after_dilever
-- ----------------------------
DROP TABLE IF EXISTS `cere_after_dilever`;
CREATE TABLE `cere_after_dilever`  (
  `order_id` bigint(20) NOT NULL COMMENT '关联订单id',
  `after_id` bigint(20) NULL DEFAULT NULL COMMENT '关联售后单id',
  `express` bigint(20) NOT NULL COMMENT '快递公司（取数据字典）',
  `deliver_formid` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '快递单号',
  `reason` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '说明',
  `image` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '凭证图片，多个以逗号隔开',
  `create_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新时间'
) ENGINE = InnoDB AUTO_INCREMENT = 15 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '买家退货信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_after_product
-- ----------------------------
DROP TABLE IF EXISTS `cere_after_product`;
CREATE TABLE `cere_after_product`  (
  `after_product_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '售后单商品明细id',
  `after_id` bigint(20) NOT NULL COMMENT '关联售后单id',
  `product_id` bigint(20) NOT NULL COMMENT '关联商品id',
  `sku_id` bigint(20) NOT NULL COMMENT '关联规格id',
  `product_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '商品名称',
  `number` int(11) NOT NULL COMMENT '购买数量',
  `product_price` decimal(15, 2) NOT NULL COMMENT '商品售价',
  `image` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '图片地址',
  `SKU` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'SKU',
  `weight` decimal(15, 2) NULL DEFAULT NULL COMMENT '重量',
  PRIMARY KEY (`after_product_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 306 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '售后单商品信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_after_product_attribute
-- ----------------------------
DROP TABLE IF EXISTS `cere_after_product_attribute`;
CREATE TABLE `cere_after_product_attribute`  (
  `after_product_id` bigint(20) NOT NULL COMMENT '关联售后商品明细id',
  `sku_name` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '规格名',
  `sku_value` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '规格值',
  `name_code` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '规格名级别',
  `value_code` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '规格值级别'
) ENGINE = InnoDB AUTO_INCREMENT = 115 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '售后商品属性信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_brand
-- ----------------------------
DROP TABLE IF EXISTS `cere_brand`;
CREATE TABLE `cere_brand`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '品牌id',
  `brand_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '品牌名称',
  `brand_logo` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '品牌图标',
  `create_time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '创建时间',
  `update_time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '品牌表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_business_buyer_user
-- ----------------------------
DROP TABLE IF EXISTS `cere_business_buyer_user`;
CREATE TABLE `cere_business_buyer_user`  (
  `shop_id` bigint(20) NOT NULL COMMENT '店铺id',
  `buyer_user_id` bigint(20) NOT NULL COMMENT '用户id',
  `create_time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '创建时间(首次成为客户时间)',
  `update_time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '更新时间(上次消费时间)',
  PRIMARY KEY (`shop_id`, `buyer_user_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '商家客户关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_business_shop
-- ----------------------------
DROP TABLE IF EXISTS `cere_business_shop`;
CREATE TABLE `cere_business_shop`  (
  `business_user_id` bigint(20) NOT NULL COMMENT '商家用户id',
  `shop_id` bigint(20) NOT NULL COMMENT '店铺id',
  `if_binding` tinyint(1) NOT NULL COMMENT '是否绑定当前店铺 1-是 0-否'
) ENGINE = InnoDB AUTO_INCREMENT = 66 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '商家用户绑定店铺信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of cere_business_shop
-- ----------------------------
INSERT INTO `cere_business_shop` VALUES (210, 155, 1);

-- ----------------------------
-- Table structure for cere_business_user_role
-- ----------------------------
DROP TABLE IF EXISTS `cere_business_user_role`;
CREATE TABLE `cere_business_user_role`  (
  `business_user_id` bigint(20) NOT NULL COMMENT '商家用户id',
  `role_id` bigint(20) NOT NULL COMMENT '关联角色表id'
) ENGINE = InnoDB AUTO_INCREMENT = 24 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '商家用户关联角色表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of cere_business_user_role
-- ----------------------------
INSERT INTO `cere_business_user_role` VALUES (210, 56);

-- ----------------------------
-- Table structure for cere_buyer_bank
-- ----------------------------
DROP TABLE IF EXISTS `cere_buyer_bank`;
CREATE TABLE `cere_buyer_bank`  (
  `bank_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '银行卡id',
  `buyer_user_id` bigint(20) NOT NULL COMMENT '客户id',
  `name` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '姓名',
  `phone` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '手机号',
  `bank_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '银行名称',
  `bank_card` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '卡号',
  PRIMARY KEY (`bank_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 67 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '客户绑定银行卡信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_buyer_collect
-- ----------------------------
DROP TABLE IF EXISTS `cere_buyer_collect`;
CREATE TABLE `cere_buyer_collect`  (
  `collect_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '收藏id',
  `buyer_user_id` bigint(20) NOT NULL COMMENT '客户id',
  `collect_type` tinyint(1) NOT NULL COMMENT '收藏类型 1-商品 2-店铺',
  `product_id` bigint(20) NULL DEFAULT NULL COMMENT '商品id',
  `shop_id` bigint(20) NULL DEFAULT NULL COMMENT '店铺id',
  `state` tinyint(1) NOT NULL COMMENT '是否收藏 1-是 0-否',
  `selected` tinyint(1) NULL DEFAULT NULL COMMENT '是否选中 1-是 0-否',
  `create_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`collect_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 459 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '客户收藏信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_buyer_comment_like
-- ----------------------------
DROP TABLE IF EXISTS `cere_buyer_comment_like`;
CREATE TABLE `cere_buyer_comment_like`  (
  `comment_id` bigint(20) NOT NULL COMMENT '评论id',
  `buyer_user_id` bigint(20) NOT NULL COMMENT '点赞客户id',
  `if_like` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否点赞 1-是 0-否',
  PRIMARY KEY (`comment_id`, `buyer_user_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '客户评论点赞信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_buyer_coupon
-- ----------------------------
DROP TABLE IF EXISTS `cere_buyer_coupon`;
CREATE TABLE `cere_buyer_coupon`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `coupon_id` bigint(20) NOT NULL COMMENT '优惠券id',
  `buyer_user_id` bigint(20) NOT NULL COMMENT '客户id',
  `activity_id` bigint(20) NOT NULL COMMENT '平台活动id',
  `activity_name` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '活动名称',
  `start_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '活动开始时间',
  `end_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '活动结束时间',
  `discount_mode` tinyint(1) NOT NULL DEFAULT 1 COMMENT '优惠方式 1-满减 2-优惠券',
  `discount_programme` tinyint(1) NOT NULL DEFAULT 1 COMMENT '优惠方案  1-叠加优惠 2-阶梯优惠',
  `state` tinyint(1) NOT NULL COMMENT '状态 0-已领取 1-已使用 2-已过期',
  `full_money` decimal(15, 2) NULL DEFAULT NULL COMMENT '满多少元',
  `reduce_money` decimal(15, 2) NULL DEFAULT NULL COMMENT '减多少元',
  `source` int(11) NOT NULL DEFAULT 1 COMMENT '来源 1-正常领取 2-营销发券 3-积分兑换 4-支付有礼',
  `coupon_code` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '微信卡券的coupon_code',
  `create_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 154 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '客户关联优惠券信息实体类' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_buyer_discount_visit
-- ----------------------------
DROP TABLE IF EXISTS `cere_buyer_discount_visit`;
CREATE TABLE `cere_buyer_discount_visit`  (
  `shop_discount_id` bigint(20) NOT NULL COMMENT '限时折扣活动id',
  `buyer_user_id` bigint(20) NOT NULL COMMENT '浏览客户id',
  `visit_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '浏览时间'
) ENGINE = InnoDB AUTO_INCREMENT = 1052 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '客户浏览限时折扣记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_buyer_footprint
-- ----------------------------
DROP TABLE IF EXISTS `cere_buyer_footprint`;
CREATE TABLE `cere_buyer_footprint`  (
  `footprint_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '足迹id',
  `shop_id` bigint(20) NOT NULL COMMENT '店铺id',
  `product_id` bigint(20) NOT NULL COMMENT '商品id',
  `sku_id` bigint(20) NOT NULL COMMENT '规格id',
  `buyer_user_id` bigint(20) NOT NULL COMMENT '客户id',
  `selected` tinyint(1) NULL DEFAULT NULL COMMENT '是否选中 1-是 0-否',
  `create_time` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`footprint_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 20174 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '商品足迹信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_buyer_label
-- ----------------------------
DROP TABLE IF EXISTS `cere_buyer_label`;
CREATE TABLE `cere_buyer_label`  (
  `buyer_user_id` bigint(20) NOT NULL COMMENT '关联客户id',
  `buyer_label_id` bigint(20) NOT NULL COMMENT '关联平台标签id'
) ENGINE = InnoDB AUTO_INCREMENT = 16 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '客户关联标签信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_buyer_notice
-- ----------------------------
DROP TABLE IF EXISTS `cere_buyer_notice`;
CREATE TABLE `cere_buyer_notice`  (
  `notice_id` bigint(20) NOT NULL COMMENT '消息id',
  `buyer_user_id` bigint(20) NOT NULL COMMENT '客户id'
) ENGINE = InnoDB AUTO_INCREMENT = 632 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '客户已读公告、站内信消息关系表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_buyer_platform_discount_visit
-- ----------------------------
DROP TABLE IF EXISTS `cere_buyer_platform_discount_visit`;
CREATE TABLE `cere_buyer_platform_discount_visit`  (
  `discount_id` bigint(20) NOT NULL COMMENT '平台限时折扣活动id',
  `buyer_user_id` bigint(20) NOT NULL COMMENT '浏览客户id',
  `visit_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '浏览时间',
  `shop_id` bigint(11) NOT NULL COMMENT '店铺id'
) ENGINE = InnoDB AUTO_INCREMENT = 2474 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '客户浏览平台限时折扣记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_buyer_platform_seckill_visit
-- ----------------------------
DROP TABLE IF EXISTS `cere_buyer_platform_seckill_visit`;
CREATE TABLE `cere_buyer_platform_seckill_visit`  (
  `seckill_id` bigint(20) NOT NULL COMMENT '平台秒杀活动id',
  `buyer_user_id` bigint(20) NOT NULL COMMENT '浏览客户id',
  `visit_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '浏览时间',
  `shop_id` bigint(11) NOT NULL COMMENT '店铺id'
) ENGINE = InnoDB AUTO_INCREMENT = 2658 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '客户浏览平台秒杀记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_buyer_polite_record
-- ----------------------------
DROP TABLE IF EXISTS `cere_buyer_polite_record`;
CREATE TABLE `cere_buyer_polite_record`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `buyer_user_id` bigint(20) NOT NULL COMMENT '用户id',
  `order_id` bigint(20) NOT NULL COMMENT '关联订单id',
  `polite_id` bigint(20) NOT NULL COMMENT '关联的支付有礼活动id',
  `polite_type` tinyint(4) NOT NULL COMMENT '奖励类型 1-成长值，2-满减券，3-折扣券, 4-积分',
  `growth` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '奖励的成长值',
  `credit` int(11) NOT NULL DEFAULT 0 COMMENT '奖励的积分',
  `discount` decimal(15, 2) NOT NULL DEFAULT 0.00 COMMENT '奖励的优惠券金额，或折扣券的折扣额度',
  `create_time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_buyer_user_id`(`buyer_user_id`) USING BTREE,
  INDEX `idx_order_id`(`order_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 64 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户支付有礼记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_buyer_receive
-- ----------------------------
DROP TABLE IF EXISTS `cere_buyer_receive`;
CREATE TABLE `cere_buyer_receive`  (
  `receive_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '收货地址id',
  `buyer_user_id` bigint(20) NOT NULL COMMENT '关联客户id',
  `receive_name` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '收货人姓名',
  `receive_phone` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '收货人电话',
  `receive_adress` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '收货地址',
  `address` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '详细地址',
  `label` varchar(5) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '地址标签 家、公司、学校',
  `if_default` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否默认 1-是 0-否',
  `create_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`receive_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 502 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '客户收货地址信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_buyer_search
-- ----------------------------
DROP TABLE IF EXISTS `cere_buyer_search`;
CREATE TABLE `cere_buyer_search`  (
  `search_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '搜索id',
  `buyer_user_id` bigint(20) NOT NULL COMMENT '客户id',
  `search` varchar(40) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '搜索内容',
  PRIMARY KEY (`search_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 786 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '客户历史搜索信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_buyer_seckill_visit
-- ----------------------------
DROP TABLE IF EXISTS `cere_buyer_seckill_visit`;
CREATE TABLE `cere_buyer_seckill_visit`  (
  `shop_seckill_id` bigint(20) NOT NULL COMMENT '秒杀活动id',
  `buyer_user_id` bigint(20) NOT NULL COMMENT '浏览客户id',
  `visit_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '浏览时间'
) ENGINE = InnoDB AUTO_INCREMENT = 548 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '客户浏览秒杀记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_buyer_shop_coupon
-- ----------------------------
DROP TABLE IF EXISTS `cere_buyer_shop_coupon`;
CREATE TABLE `cere_buyer_shop_coupon`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `shop_operate_id` bigint(20) NULL DEFAULT NULL COMMENT '运营计划id',
  `shop_coupon_id` bigint(20) NOT NULL COMMENT '商家优惠券id',
  `buyer_user_id` bigint(20) NOT NULL COMMENT '客户id',
  `coupon_name` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '优惠券名称',
  `start_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '用券开始时间',
  `end_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '用券结束时间',
  `coupon_type` tinyint(1) NOT NULL COMMENT '优惠券类型 1-满减券 2-折扣券',
  `state` tinyint(1) NOT NULL COMMENT '状态 0-已领取 1-已使用 2-已过期',
  `full_money` decimal(15, 2) NULL DEFAULT NULL COMMENT '满多少元',
  `reduce_money` decimal(15, 2) NULL DEFAULT NULL COMMENT '减多少元/打几折',
  `create_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1474224215132512277 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '客户关联商家优惠券信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_buyer_shop_label
-- ----------------------------
DROP TABLE IF EXISTS `cere_buyer_shop_label`;
CREATE TABLE `cere_buyer_shop_label`  (
  `buyer_user_id` bigint(20) NOT NULL COMMENT '关联客户id',
  `label_id` bigint(20) NOT NULL COMMENT '关联商家标签id'
) ENGINE = InnoDB AUTO_INCREMENT = 19 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '客户关联商家标签信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_buyer_track_report
-- ----------------------------
DROP TABLE IF EXISTS `cere_buyer_track_report`;
CREATE TABLE `cere_buyer_track_report`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `event_type` int(11) NOT NULL DEFAULT 1 COMMENT '事件类型 1-商品详情页访问5s, 2-添加到购物车, 3-提交订单',
  `product_ids` varchar(4096) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '商品id列表, 用,分割',
  `create_time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '创建时间',
  `create_user` bigint(20) NOT NULL COMMENT '创建人id',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_create_user`(`create_user`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 241 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '用户埋点上报' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_buyer_user
-- ----------------------------
DROP TABLE IF EXISTS `cere_buyer_user`;
CREATE TABLE `cere_buyer_user`  (
  `buyer_user_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '昵称',
  `sex` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '性别',
  `birthday` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '生日',
  `wechat_open_id` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '微信openID',
  `wechat_union_id` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '微信unionId',
  `wechat_name` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '微信昵称',
  `wechat_number` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '微信号',
  `ali_user_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '支付宝小程序用户id',
  `phone` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '注册手机号',
  `password` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '密码',
  `head_image` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '头像图片',
  `state` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否启用   1-是 0-否',
  `if_black` tinyint(1) NULL DEFAULT 0 COMMENT '是否加入黑名单 1-是 0-否',
  `remark` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `token` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '请求token',
  `member_level_id` bigint(20) NULL DEFAULT NULL COMMENT '会员等级id',
  `growth` int(11) NULL DEFAULT 0 COMMENT '成长值',
  `credit` int(11) NOT NULL DEFAULT 0 COMMENT '积分值',
  `terminal` int(11) NOT NULL COMMENT '注册来源 0-未知 1-APP 2-微信小程序 3-H5 4-支付宝小程序 5-PC 6-商家端后台',
  `register_ip` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '注册时的ip',
  `last_login_ip` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '最近一次登录时的ip',
  `channel_code` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '渠道编码',
  `create_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`buyer_user_id`) USING BTREE,
  UNIQUE INDEX `index`(`phone`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2051 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '客户信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_buyer_withdrawal
-- ----------------------------
DROP TABLE IF EXISTS `cere_buyer_withdrawal`;
CREATE TABLE `cere_buyer_withdrawal`  (
  `withdrawal_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '提现申请id',
  `buyer_user_id` bigint(20) NOT NULL COMMENT '客户id',
  `bank_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '银行名称',
  `bank_card` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '银行卡号',
  `withdrawal_money` decimal(15, 2) NOT NULL COMMENT '提现金额',
  `state` tinyint(1) NOT NULL DEFAULT 0 COMMENT '处理状态  0-审核中 1-通过 2-拒绝',
  `apply_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '申请时间',
  `handle_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '处理时间',
  PRIMARY KEY (`withdrawal_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '客户提现信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_cart_attribute
-- ----------------------------
DROP TABLE IF EXISTS `cere_cart_attribute`;
CREATE TABLE `cere_cart_attribute`  (
  `cart_id` bigint(20) NOT NULL COMMENT '关联购物车id',
  `sku_name` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '规格名',
  `sku_value` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '规格值',
  `name_code` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '规格名级别',
  `value_code` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '规格值级别'
) ENGINE = InnoDB AUTO_INCREMENT = 869 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '购物车商品属性表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_channel
-- ----------------------------
DROP TABLE IF EXISTS `cere_channel`;
CREATE TABLE `cere_channel`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '渠道id',
  `channel_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '渠道名称',
  `register_url` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '渠道注册链接',
  `channel_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '渠道码',
  `create_time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '创建时间',
  `update_time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '渠道表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_channel_coupon
-- ----------------------------
DROP TABLE IF EXISTS `cere_channel_coupon`;
CREATE TABLE `cere_channel_coupon`  (
  `shop_coupon_id` bigint(20) NOT NULL COMMENT '优惠券id',
  `product_id` bigint(20) NOT NULL COMMENT '商品id',
  `shop_id` bigint(20) NOT NULL COMMENT '店铺id',
  `create_time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '创建时间',
  `update_time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '更新时间',
  PRIMARY KEY (`shop_coupon_id`, `product_id`) USING BTREE,
  INDEX `idx_shop_id`(`shop_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '渠道券表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_city_manage
-- ----------------------------
DROP TABLE IF EXISTS `cere_city_manage`;
CREATE TABLE `cere_city_manage`  (
  `city_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '城市id',
  `city_pid` bigint(20) NOT NULL COMMENT '上级节点id',
  `city_name` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '城市名称',
  `create_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`city_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 820001 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '城市管理信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of cere_city_manage
-- ----------------------------
INSERT INTO `cere_city_manage` VALUES (110000, 0, '北京市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (110100, 110000, '北京市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (110101, 110100, '东城区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (110102, 110100, '西城区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (110105, 110100, '朝阳区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (110106, 110100, '丰台区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (110107, 110100, '石景山区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (110108, 110100, '海淀区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (110109, 110100, '门头沟区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (110111, 110100, '房山区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (110112, 110100, '通州区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (110113, 110100, '顺义区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (110114, 110100, '昌平区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (110115, 110100, '大兴区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (110116, 110100, '怀柔区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (110117, 110100, '平谷区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (110118, 110100, '密云区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (110119, 110100, '延庆区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (120000, 0, '天津市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (120100, 120000, '天津市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (120101, 120100, '和平区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (120102, 120100, '河东区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (120103, 120100, '河西区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (120104, 120100, '南开区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (120105, 120100, '河北区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (120106, 120100, '红桥区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (120110, 120100, '东丽区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (120111, 120100, '西青区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (120112, 120100, '津南区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (120113, 120100, '北辰区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (120114, 120100, '武清区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (120115, 120100, '宝坻区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (120116, 120100, '滨海新区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (120117, 120100, '宁河区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (120118, 120100, '静海区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (120119, 120100, '蓟州区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130000, 0, '河北省', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130100, 130000, '石家庄市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130102, 130100, '长安区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130104, 130100, '桥西区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130105, 130100, '新华区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130107, 130100, '井陉矿区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130108, 130100, '裕华区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130109, 130100, '藁城区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130110, 130100, '鹿泉区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130111, 130100, '栾城区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130121, 130100, '井陉县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130123, 130100, '正定县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130125, 130100, '行唐县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130126, 130100, '灵寿县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130127, 130100, '高邑县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130128, 130100, '深泽县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130129, 130100, '赞皇县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130130, 130100, '无极县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130131, 130100, '平山县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130132, 130100, '元氏县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130133, 130100, '赵县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130181, 130100, '辛集市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130183, 130100, '晋州市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130184, 130100, '新乐市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130200, 130000, '唐山市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130202, 130200, '路南区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130203, 130200, '路北区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130204, 130200, '古冶区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130205, 130200, '开平区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130207, 130200, '丰南区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130208, 130200, '丰润区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130209, 130200, '曹妃甸区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130223, 130200, '滦县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130224, 130200, '滦南县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130225, 130200, '乐亭县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130227, 130200, '迁西县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130229, 130200, '玉田县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130281, 130200, '遵化市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130283, 130200, '迁安市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130300, 130000, '秦皇岛市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130302, 130300, '海港区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130303, 130300, '山海关区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130304, 130300, '北戴河区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130306, 130300, '抚宁区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130321, 130300, '青龙满族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130322, 130300, '昌黎县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130324, 130300, '卢龙县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130400, 130000, '邯郸市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130402, 130400, '邯山区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130403, 130400, '丛台区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130404, 130400, '复兴区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130406, 130400, '峰峰矿区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130407, 130400, '肥乡区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130408, 130400, '永年区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130423, 130400, '临漳县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130424, 130400, '成安县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130425, 130400, '大名县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130426, 130400, '涉县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130427, 130400, '磁县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130430, 130400, '邱县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130431, 130400, '鸡泽县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130432, 130400, '广平县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130433, 130400, '馆陶县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130434, 130400, '魏县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130435, 130400, '曲周县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130481, 130400, '武安市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130500, 130000, '邢台市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130502, 130500, '桥东区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130503, 130500, '桥西区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130521, 130500, '邢台县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130522, 130500, '临城县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130523, 130500, '内丘县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130524, 130500, '柏乡县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130525, 130500, '隆尧县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130526, 130500, '任县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130527, 130500, '南和县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130528, 130500, '宁晋县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130529, 130500, '巨鹿县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130530, 130500, '新河县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130531, 130500, '广宗县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130532, 130500, '平乡县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130533, 130500, '威县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130534, 130500, '清河县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130535, 130500, '临西县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130581, 130500, '南宫市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130582, 130500, '沙河市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130600, 130000, '保定市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130602, 130600, '竞秀区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130606, 130600, '莲池区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130607, 130600, '满城区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130608, 130600, '清苑区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130609, 130600, '徐水区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130623, 130600, '涞水县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130624, 130600, '阜平县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130626, 130600, '定兴县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130627, 130600, '唐县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130628, 130600, '高阳县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130629, 130600, '容城县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130630, 130600, '涞源县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130631, 130600, '望都县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130632, 130600, '安新县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130633, 130600, '易县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130634, 130600, '曲阳县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130635, 130600, '蠡县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130636, 130600, '顺平县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130637, 130600, '博野县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130638, 130600, '雄县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130681, 130000, '涿州市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130682, 130000, '定州市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130683, 130000, '安国市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130684, 130000, '高碑店市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130700, 130000, '张家口市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130702, 130700, '桥东区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130703, 130700, '桥西区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130705, 130700, '宣化区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130706, 130700, '下花园区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130708, 130700, '万全区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130709, 130700, '崇礼区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130722, 130700, '张北县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130723, 130700, '康保县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130724, 130700, '沽源县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130725, 130700, '尚义县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130726, 130700, '蔚县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130727, 130700, '阳原县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130728, 130700, '怀安县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130730, 130700, '怀来县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130731, 130700, '涿鹿县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130732, 130700, '赤城县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130800, 130000, '承德市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130802, 130800, '双桥区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130803, 130800, '双滦区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130804, 130800, '鹰手营子矿区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130821, 130800, '承德县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130822, 130800, '兴隆县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130824, 130800, '滦平县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130825, 130800, '隆化县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130826, 130800, '丰宁满族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130827, 130800, '宽城满族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130828, 130800, '围场满族蒙古族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130881, 130800, '平泉市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130900, 130000, '沧州市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130902, 130900, '新华区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130903, 130900, '运河区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130921, 130900, '沧县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130922, 130900, '青县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130923, 130900, '东光县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130924, 130900, '海兴县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130925, 130900, '盐山县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130926, 130900, '肃宁县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130927, 130900, '南皮县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130928, 130900, '吴桥县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130929, 130900, '献县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130930, 130900, '孟村回族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130981, 130900, '泊头市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130982, 130900, '任丘市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130983, 130900, '黄骅市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (130984, 130900, '河间市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (131000, 130000, '廊坊市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (131002, 131000, '安次区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (131003, 131000, '广阳区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (131022, 131000, '固安县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (131023, 131000, '永清县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (131024, 131000, '香河县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (131025, 131000, '大城县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (131026, 131000, '文安县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (131028, 131000, '大厂回族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (131081, 131000, '霸州市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (131082, 131000, '三河市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (131100, 130000, '衡水市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (131102, 131100, '桃城区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (131103, 131100, '冀州区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (131121, 131100, '枣强县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (131122, 131100, '武邑县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (131123, 131100, '武强县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (131124, 131100, '饶阳县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (131125, 131100, '安平县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (131126, 131100, '故城县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (131127, 131100, '景县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (131128, 131100, '阜城县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (131182, 131100, '深州市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (140000, 0, '山西省', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (140100, 140000, '太原市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (140105, 140100, '小店区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (140106, 140100, '迎泽区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (140107, 140100, '杏花岭区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (140108, 140100, '尖草坪区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (140109, 140100, '万柏林区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (140110, 140100, '晋源区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (140121, 140100, '清徐县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (140122, 140100, '阳曲县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (140123, 140100, '娄烦县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (140181, 140100, '古交市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (140200, 140000, '大同市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (140202, 140200, '城区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (140203, 140200, '矿区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (140211, 140200, '南郊区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (140212, 140200, '新荣区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (140221, 140200, '阳高县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (140222, 140200, '天镇县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (140223, 140200, '广灵县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (140224, 140200, '灵丘县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (140225, 140200, '浑源县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (140226, 140200, '左云县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (140227, 140200, '大同县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (140300, 140000, '阳泉市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (140302, 140300, '城区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (140303, 140300, '矿区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (140311, 140300, '郊区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (140321, 140300, '平定县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (140322, 140300, '盂县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (140400, 140000, '长治市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (140402, 140400, '城区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (140411, 140400, '郊区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (140421, 140400, '长治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (140423, 140400, '襄垣县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (140424, 140400, '屯留县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (140425, 140400, '平顺县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (140426, 140400, '黎城县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (140427, 140400, '壶关县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (140428, 140400, '长子县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (140429, 140400, '武乡县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (140430, 140400, '沁县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (140431, 140400, '沁源县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (140481, 140400, '潞城市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (140500, 140000, '晋城市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (140502, 140500, '城区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (140521, 140500, '沁水县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (140522, 140500, '阳城县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (140524, 140500, '陵川县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (140525, 140500, '泽州县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (140581, 140500, '高平市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (140600, 140000, '朔州市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (140602, 140600, '朔城区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (140603, 140600, '平鲁区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (140621, 140600, '山阴县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (140622, 140600, '应县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (140623, 140600, '右玉县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (140624, 140600, '怀仁县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (140700, 140000, '晋中市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (140702, 140700, '榆次区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (140721, 140700, '榆社县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (140722, 140700, '左权县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (140723, 140700, '和顺县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (140724, 140700, '昔阳县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (140725, 140700, '寿阳县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (140726, 140700, '太谷县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (140727, 140700, '祁县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (140728, 140700, '平遥县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (140729, 140700, '灵石县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (140781, 140700, '介休市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (140800, 140000, '运城市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (140802, 140800, '盐湖区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (140821, 140800, '临猗县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (140822, 140800, '万荣县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (140823, 140800, '闻喜县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (140824, 140800, '稷山县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (140825, 140800, '新绛县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (140826, 140800, '绛县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (140827, 140800, '垣曲县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (140828, 140800, '夏县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (140829, 140800, '平陆县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (140830, 140800, '芮城县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (140881, 140800, '永济市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (140882, 140800, '河津市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (140900, 140000, '忻州市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (140902, 140900, '忻府区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (140921, 140900, '定襄县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (140922, 140900, '五台县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (140923, 140900, '代县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (140924, 140900, '繁峙县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (140925, 140900, '宁武县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (140926, 140900, '静乐县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (140927, 140900, '神池县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (140928, 140900, '五寨县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (140929, 140900, '岢岚县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (140930, 140900, '河曲县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (140931, 140900, '保德县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (140932, 140900, '偏关县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (140981, 140900, '原平市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (141000, 140000, '临汾市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (141002, 141000, '尧都区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (141021, 141000, '曲沃县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (141022, 141000, '翼城县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (141023, 141000, '襄汾县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (141024, 141000, '洪洞县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (141025, 141000, '古县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (141026, 141000, '安泽县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (141027, 141000, '浮山县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (141028, 141000, '吉县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (141029, 141000, '乡宁县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (141030, 141000, '大宁县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (141031, 141000, '隰县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (141032, 141000, '永和县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (141033, 141000, '蒲县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (141034, 141000, '汾西县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (141081, 141000, '侯马市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (141082, 141000, '霍州市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (141100, 140000, '吕梁市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (141102, 141100, '离石区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (141121, 141100, '文水县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (141122, 141100, '交城县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (141123, 141100, '兴县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (141124, 141100, '临县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (141125, 141100, '柳林县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (141126, 141100, '石楼县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (141127, 141100, '岚县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (141128, 141100, '方山县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (141129, 141100, '中阳县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (141130, 141100, '交口县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (141181, 141100, '孝义市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (141182, 141100, '汾阳市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (150000, 0, '内蒙古自治区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (150100, 150000, '呼和浩特市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (150102, 150100, '新城区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (150103, 150100, '回民区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (150104, 150100, '玉泉区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (150105, 150100, '赛罕区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (150121, 150100, '土默特左旗', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (150122, 150100, '托克托县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (150123, 150100, '和林格尔县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (150124, 150100, '清水河县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (150125, 150100, '武川县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (150200, 150000, '包头市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (150202, 150200, '东河区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (150203, 150200, '昆都仑区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (150204, 150200, '青山区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (150205, 150200, '石拐区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (150206, 150200, '白云鄂博矿区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (150207, 150200, '九原区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (150221, 150200, '土默特右旗', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (150222, 150200, '固阳县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (150223, 150200, '达尔罕茂明安联合旗', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (150300, 150000, '乌海市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (150302, 150300, '海勃湾区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (150303, 150300, '海南区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (150304, 150300, '乌达区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (150400, 150000, '赤峰市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (150402, 150400, '红山区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (150403, 150400, '元宝山区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (150404, 150400, '松山区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (150421, 150400, '阿鲁科尔沁旗', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (150422, 150400, '巴林左旗', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (150423, 150400, '巴林右旗', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (150424, 150400, '林西县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (150425, 150400, '克什克腾旗', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (150426, 150400, '翁牛特旗', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (150428, 150400, '喀喇沁旗', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (150429, 150400, '宁城县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (150430, 150400, '敖汉旗', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (150500, 150000, '通辽市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (150502, 150500, '科尔沁区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (150521, 150500, '科尔沁左翼中旗', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (150522, 150500, '科尔沁左翼后旗', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (150523, 150500, '开鲁县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (150524, 150500, '库伦旗', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (150525, 150500, '奈曼旗', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (150526, 150500, '扎鲁特旗', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (150581, 150500, '霍林郭勒市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (150600, 150000, '鄂尔多斯市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (150602, 150600, '东胜区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (150603, 150600, '康巴什区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (150621, 150600, '达拉特旗', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (150622, 150600, '准格尔旗', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (150623, 150600, '鄂托克前旗', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (150624, 150600, '鄂托克旗', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (150625, 150600, '杭锦旗', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (150626, 150600, '乌审旗', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (150627, 150600, '伊金霍洛旗', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (150700, 150000, '呼伦贝尔市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (150702, 150700, '海拉尔区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (150703, 150700, '扎赉诺尔区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (150721, 150700, '阿荣旗', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (150722, 150700, '莫力达瓦达斡尔族自治旗', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (150723, 150700, '鄂伦春自治旗', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (150724, 150700, '鄂温克族自治旗', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (150725, 150700, '陈巴尔虎旗', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (150726, 150700, '新巴尔虎左旗', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (150727, 150700, '新巴尔虎右旗', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (150781, 150700, '满洲里市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (150782, 150700, '牙克石市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (150783, 150700, '扎兰屯市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (150784, 150700, '额尔古纳市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (150785, 150700, '根河市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (150800, 150000, '巴彦淖尔市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (150802, 150800, '临河区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (150821, 150800, '五原县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (150822, 150800, '磴口县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (150823, 150800, '乌拉特前旗', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (150824, 150800, '乌拉特中旗', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (150825, 150800, '乌拉特后旗', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (150826, 150800, '杭锦后旗', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (150900, 150000, '乌兰察布市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (150902, 150900, '集宁区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (150921, 150900, '卓资县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (150922, 150900, '化德县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (150923, 150900, '商都县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (150924, 150900, '兴和县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (150925, 150900, '凉城县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (150926, 150900, '察哈尔右翼前旗', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (150927, 150900, '察哈尔右翼中旗', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (150928, 150900, '察哈尔右翼后旗', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (150929, 150900, '四子王旗', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (150981, 150900, '丰镇市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (152200, 150000, '兴安盟', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (152201, 152200, '乌兰浩特市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (152202, 152200, '阿尔山市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (152221, 152200, '科尔沁右翼前旗', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (152222, 152200, '科尔沁右翼中旗', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (152223, 152200, '扎赉特旗', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (152224, 152200, '突泉县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (152500, 150000, '锡林郭勒盟', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (152501, 152500, '二连浩特市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (152502, 152500, '锡林浩特市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (152522, 152500, '阿巴嘎旗', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (152523, 152500, '苏尼特左旗', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (152524, 152500, '苏尼特右旗', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (152525, 152500, '东乌珠穆沁旗', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (152526, 152500, '西乌珠穆沁旗', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (152527, 152500, '太仆寺旗', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (152528, 152500, '镶黄旗', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (152529, 152500, '正镶白旗', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (152530, 152500, '正蓝旗', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (152531, 152500, '多伦县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (152900, 150000, '阿拉善盟', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (152921, 152900, '阿拉善左旗', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (152922, 152900, '阿拉善右旗', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (152923, 152900, '额济纳旗', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (210000, 0, '辽宁省', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (210100, 210000, '沈阳市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (210102, 210100, '和平区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (210103, 210100, '沈河区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (210104, 210100, '大东区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (210105, 210100, '皇姑区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (210106, 210100, '铁西区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (210111, 210100, '苏家屯区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (210112, 210100, '浑南区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (210113, 210100, '沈北新区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (210114, 210100, '于洪区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (210115, 210100, '辽中区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (210123, 210100, '康平县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (210124, 210100, '法库县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (210181, 210100, '新民市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (210200, 210000, '大连市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (210202, 210200, '中山区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (210203, 210200, '西岗区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (210204, 210200, '沙河口区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (210211, 210200, '甘井子区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (210212, 210200, '旅顺口区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (210213, 210200, '金州区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (210214, 210200, '普兰店区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (210224, 210200, '长海县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (210281, 210200, '瓦房店市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (210283, 210200, '庄河市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (210300, 210000, '鞍山市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (210302, 210300, '铁东区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (210303, 210300, '铁西区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (210304, 210300, '立山区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (210311, 210300, '千山区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (210321, 210300, '台安县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (210323, 210300, '岫岩满族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (210381, 210300, '海城市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (210400, 210000, '抚顺市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (210402, 210400, '新抚区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (210403, 210400, '东洲区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (210404, 210400, '望花区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (210411, 210400, '顺城区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (210421, 210400, '抚顺县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (210422, 210400, '新宾满族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (210423, 210400, '清原满族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (210500, 210000, '本溪市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (210502, 210500, '平山区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (210503, 210500, '溪湖区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (210504, 210500, '明山区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (210505, 210500, '南芬区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (210521, 210500, '本溪满族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (210522, 210500, '桓仁满族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (210600, 210000, '丹东市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (210602, 210600, '元宝区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (210603, 210600, '振兴区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (210604, 210600, '振安区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (210624, 210600, '宽甸满族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (210681, 210600, '东港市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (210682, 210600, '凤城市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (210700, 210000, '锦州市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (210702, 210700, '古塔区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (210703, 210700, '凌河区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (210711, 210700, '太和区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (210726, 210700, '黑山县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (210727, 210700, '义县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (210781, 210700, '凌海市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (210782, 210700, '北镇市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (210800, 210000, '营口市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (210802, 210800, '站前区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (210803, 210800, '西市区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (210804, 210800, '鲅鱼圈区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (210811, 210800, '老边区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (210881, 210800, '盖州市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (210882, 210800, '大石桥市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (210900, 210000, '阜新市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (210902, 210900, '海州区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (210903, 210900, '新邱区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (210904, 210900, '太平区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (210905, 210900, '清河门区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (210911, 210900, '细河区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (210921, 210900, '阜新蒙古族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (210922, 210900, '彰武县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (211000, 210000, '辽阳市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (211002, 211000, '白塔区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (211003, 211000, '文圣区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (211004, 211000, '宏伟区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (211005, 211000, '弓长岭区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (211011, 211000, '太子河区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (211021, 211000, '辽阳县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (211081, 211000, '灯塔市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (211100, 210000, '盘锦市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (211102, 211100, '双台子区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (211103, 211100, '兴隆台区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (211104, 211100, '大洼区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (211122, 211100, '盘山县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (211200, 210000, '铁岭市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (211202, 211200, '银州区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (211204, 211200, '清河区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (211221, 211200, '铁岭县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (211223, 211200, '西丰县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (211224, 211200, '昌图县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (211281, 211200, '调兵山市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (211282, 211200, '开原市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (211300, 210000, '朝阳市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (211302, 211300, '双塔区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (211303, 211300, '龙城区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (211321, 211300, '朝阳县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (211322, 211300, '建平县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (211324, 211300, '喀喇沁左翼蒙古族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (211381, 211300, '北票市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (211382, 211300, '凌源市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (211400, 210000, '葫芦岛市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (211402, 211400, '连山区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (211403, 211400, '龙港区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (211404, 211400, '南票区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (211421, 211400, '绥中县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (211422, 211400, '建昌县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (211481, 211400, '兴城市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (220000, 0, '吉林省', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (220100, 220000, '长春市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (220102, 220100, '南关区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (220103, 220100, '宽城区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (220104, 220100, '朝阳区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (220105, 220100, '二道区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (220106, 220100, '绿园区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (220112, 220100, '双阳区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (220113, 220100, '九台区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (220122, 220100, '农安县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (220182, 220100, '榆树市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (220183, 220100, '德惠市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (220200, 220000, '吉林市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (220202, 220200, '昌邑区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (220203, 220200, '龙潭区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (220204, 220200, '船营区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (220211, 220200, '丰满区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (220221, 220200, '永吉县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (220281, 220200, '蛟河市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (220282, 220200, '桦甸市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (220283, 220200, '舒兰市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (220284, 220200, '磐石市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (220300, 220000, '四平市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (220302, 220300, '铁西区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (220303, 220300, '铁东区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (220322, 220300, '梨树县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (220323, 220300, '伊通满族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (220381, 220300, '公主岭市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (220382, 220300, '双辽市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (220400, 220000, '辽源市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (220402, 220400, '龙山区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (220403, 220400, '西安区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (220421, 220400, '东丰县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (220422, 220400, '东辽县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (220500, 220000, '通化市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (220502, 220500, '东昌区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (220503, 220500, '二道江区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (220521, 220500, '通化县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (220523, 220500, '辉南县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (220524, 220500, '柳河县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (220581, 220500, '梅河口市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (220582, 220500, '集安市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (220600, 220000, '白山市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (220602, 220600, '浑江区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (220605, 220600, '江源区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (220621, 220600, '抚松县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (220622, 220600, '靖宇县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (220623, 220600, '长白朝鲜族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (220681, 220600, '临江市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (220700, 220000, '松原市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (220702, 220700, '宁江区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (220721, 220700, '前郭尔罗斯蒙古族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (220722, 220700, '长岭县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (220723, 220700, '乾安县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (220781, 220700, '扶余市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (220800, 220000, '白城市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (220802, 220800, '洮北区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (220821, 220800, '镇赉县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (220822, 220800, '通榆县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (220881, 220800, '洮南市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (220882, 220800, '大安市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (222400, 220000, '延边朝鲜族自治州', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (222401, 222400, '延吉市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (222402, 222400, '图们市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (222403, 222400, '敦化市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (222404, 222400, '珲春市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (222405, 222400, '龙井市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (222406, 222400, '和龙市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (222424, 222400, '汪清县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (222426, 222400, '安图县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230000, 0, '黑龙江省', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230100, 230000, '哈尔滨市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230102, 230100, '道里区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230103, 230100, '南岗区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230104, 230100, '道外区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230108, 230100, '平房区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230109, 230100, '松北区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230110, 230100, '香坊区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230111, 230100, '呼兰区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230112, 230100, '阿城区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230113, 230100, '双城区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230123, 230100, '依兰县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230124, 230100, '方正县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230125, 230100, '宾县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230126, 230100, '巴彦县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230127, 230100, '木兰县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230128, 230100, '通河县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230129, 230100, '延寿县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230183, 230100, '尚志市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230184, 230100, '五常市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230200, 230000, '齐齐哈尔市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230202, 230200, '龙沙区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230203, 230200, '建华区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230204, 230200, '铁锋区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230205, 230200, '昂昂溪区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230206, 230200, '富拉尔基区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230207, 230200, '碾子山区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230208, 230200, '梅里斯达斡尔族区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230221, 230200, '龙江县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230223, 230200, '依安县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230224, 230200, '泰来县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230225, 230200, '甘南县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230227, 230200, '富裕县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230229, 230200, '克山县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230230, 230200, '克东县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230231, 230200, '拜泉县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230281, 230200, '讷河市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230300, 230000, '鸡西市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230302, 230300, '鸡冠区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230303, 230300, '恒山区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230304, 230300, '滴道区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230305, 230300, '梨树区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230306, 230300, '城子河区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230307, 230300, '麻山区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230321, 230300, '鸡东县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230381, 230300, '虎林市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230382, 230300, '密山市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230400, 230000, '鹤岗市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230402, 230400, '向阳区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230403, 230400, '工农区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230404, 230400, '南山区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230405, 230400, '兴安区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230406, 230400, '东山区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230407, 230400, '兴山区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230421, 230400, '萝北县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230422, 230400, '绥滨县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230500, 230000, '双鸭山市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230502, 230500, '尖山区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230503, 230500, '岭东区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230505, 230500, '四方台区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230506, 230500, '宝山区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230521, 230500, '集贤县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230522, 230500, '友谊县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230523, 230500, '宝清县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230524, 230500, '饶河县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230600, 230000, '大庆市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230602, 230600, '萨尔图区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230603, 230600, '龙凤区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230604, 230600, '让胡路区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230605, 230600, '红岗区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230606, 230600, '大同区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230621, 230600, '肇州县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230622, 230600, '肇源县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230623, 230600, '林甸县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230624, 230600, '杜尔伯特蒙古族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230700, 230000, '伊春市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230702, 230700, '伊春区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230703, 230700, '南岔区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230704, 230700, '友好区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230705, 230700, '西林区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230706, 230700, '翠峦区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230707, 230700, '新青区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230708, 230700, '美溪区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230709, 230700, '金山屯区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230710, 230700, '五营区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230711, 230700, '乌马河区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230712, 230700, '汤旺河区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230713, 230700, '带岭区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230714, 230700, '乌伊岭区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230715, 230700, '红星区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230716, 230700, '上甘岭区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230722, 230700, '嘉荫县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230781, 230700, '铁力市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230800, 230000, '佳木斯市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230803, 230800, '向阳区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230804, 230800, '前进区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230805, 230800, '东风区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230811, 230800, '郊区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230822, 230800, '桦南县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230826, 230800, '桦川县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230828, 230800, '汤原县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230881, 230800, '同江市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230882, 230800, '富锦市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230883, 230800, '抚远市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230900, 230000, '七台河市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230902, 230900, '新兴区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230903, 230900, '桃山区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230904, 230900, '茄子河区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (230921, 230900, '勃利县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (231000, 230000, '牡丹江市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (231002, 231000, '东安区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (231003, 231000, '阳明区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (231004, 231000, '爱民区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (231005, 231000, '西安区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (231025, 231000, '林口县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (231081, 231000, '绥芬河市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (231083, 231000, '海林市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (231084, 231000, '宁安市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (231085, 231000, '穆棱市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (231086, 231000, '东宁市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (231100, 230000, '黑河市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (231102, 231100, '爱辉区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (231121, 231100, '嫩江县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (231123, 231100, '逊克县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (231124, 231100, '孙吴县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (231181, 231100, '北安市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (231182, 231100, '五大连池市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (231200, 230000, '绥化市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (231202, 231200, '北林区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (231221, 231200, '望奎县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (231222, 231200, '兰西县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (231223, 231200, '青冈县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (231224, 231200, '庆安县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (231225, 231200, '明水县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (231226, 231200, '绥棱县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (231281, 231200, '安达市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (231282, 231200, '肇东市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (231283, 231200, '海伦市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (232700, 230000, '大兴安岭地区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (232721, 232700, '呼玛县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (232722, 232700, '塔河县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (232723, 232700, '漠河县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (310000, 0, '上海市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (310100, 310000, '上海市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (310101, 310100, '黄浦区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (310104, 310100, '徐汇区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (310105, 310100, '长宁区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (310106, 310100, '静安区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (310107, 310100, '普陀区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (310109, 310100, '虹口区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (310110, 310100, '杨浦区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (310112, 310100, '闵行区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (310113, 310100, '宝山区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (310114, 310100, '嘉定区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (310115, 310100, '浦东新区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (310116, 310100, '金山区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (310117, 310100, '松江区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (310118, 310100, '青浦区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (310120, 310100, '奉贤区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (310151, 310100, '崇明区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (320000, 0, '江苏省', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (320100, 320000, '南京市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (320102, 320100, '玄武区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (320104, 320100, '秦淮区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (320105, 320100, '建邺区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (320106, 320100, '鼓楼区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (320111, 320100, '浦口区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (320113, 320100, '栖霞区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (320114, 320100, '雨花台区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (320115, 320100, '江宁区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (320116, 320100, '六合区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (320117, 320100, '溧水区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (320118, 320100, '高淳区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (320200, 320000, '无锡市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (320205, 320200, '锡山区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (320206, 320200, '惠山区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (320211, 320200, '滨湖区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (320213, 320200, '梁溪区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (320214, 320200, '新吴区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (320281, 320200, '江阴市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (320282, 320200, '宜兴市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (320300, 320000, '徐州市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (320302, 320300, '鼓楼区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (320303, 320300, '云龙区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (320305, 320300, '贾汪区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (320311, 320300, '泉山区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (320312, 320300, '铜山区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (320321, 320300, '丰县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (320322, 320300, '沛县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (320324, 320300, '睢宁县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (320381, 320300, '新沂市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (320382, 320300, '邳州市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (320400, 320000, '常州市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (320402, 320400, '天宁区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (320404, 320400, '钟楼区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (320411, 320400, '新北区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (320412, 320400, '武进区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (320413, 320400, '金坛区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (320481, 320400, '溧阳市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (320500, 320000, '苏州市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (320505, 320500, '虎丘区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (320506, 320500, '吴中区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (320507, 320500, '相城区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (320508, 320500, '姑苏区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (320509, 320500, '吴江区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (320581, 320500, '常熟市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (320582, 320500, '张家港市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (320583, 320500, '昆山市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (320585, 320500, '太仓市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (320600, 320000, '南通市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (320602, 320600, '崇川区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (320611, 320600, '港闸区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (320612, 320600, '通州区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (320621, 320600, '海安县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (320623, 320600, '如东县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (320681, 320600, '启东市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (320682, 320600, '如皋市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (320684, 320600, '海门市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (320700, 320000, '连云港市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (320703, 320700, '连云区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (320706, 320700, '海州区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (320707, 320700, '赣榆区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (320722, 320700, '东海县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (320723, 320700, '灌云县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (320724, 320700, '灌南县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (320800, 320000, '淮安市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (320803, 320800, '淮安区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (320804, 320800, '淮阴区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (320812, 320800, '清江浦区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (320813, 320800, '洪泽区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (320826, 320800, '涟水县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (320830, 320800, '盱眙县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (320831, 320800, '金湖县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (320900, 320000, '盐城市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (320902, 320900, '亭湖区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (320903, 320900, '盐都区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (320904, 320900, '大丰区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (320921, 320900, '响水县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (320922, 320900, '滨海县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (320923, 320900, '阜宁县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (320924, 320900, '射阳县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (320925, 320900, '建湖县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (320981, 320900, '东台市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (321000, 320000, '扬州市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (321002, 321000, '广陵区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (321003, 321000, '邗江区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (321012, 321000, '江都区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (321023, 321000, '宝应县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (321081, 321000, '仪征市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (321084, 321000, '高邮市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (321100, 320000, '镇江市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (321102, 321100, '京口区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (321111, 321100, '润州区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (321112, 321100, '丹徒区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (321181, 321100, '丹阳市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (321182, 321100, '扬中市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (321183, 321100, '句容市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (321200, 320000, '泰州市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (321202, 321200, '海陵区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (321203, 321200, '高港区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (321204, 321200, '姜堰区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (321281, 321200, '兴化市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (321282, 321200, '靖江市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (321283, 321200, '泰兴市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (321300, 320000, '宿迁市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (321302, 321300, '宿城区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (321311, 321300, '宿豫区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (321322, 321300, '沭阳县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (321323, 321300, '泗阳县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (321324, 321300, '泗洪县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (330000, 0, '浙江省', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (330100, 330000, '杭州市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (330102, 330100, '上城区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (330103, 330100, '下城区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (330104, 330100, '江干区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (330105, 330100, '拱墅区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (330106, 330100, '西湖区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (330108, 330100, '滨江区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (330109, 330100, '萧山区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (330110, 330100, '余杭区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (330111, 330100, '富阳区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (330112, 330100, '临安区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (330122, 330100, '桐庐县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (330127, 330100, '淳安县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (330182, 330100, '建德市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (330200, 330000, '宁波市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (330203, 330200, '海曙区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (330205, 330200, '江北区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (330206, 330200, '北仑区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (330211, 330200, '镇海区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (330212, 330200, '鄞州区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (330213, 330200, '奉化区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (330225, 330200, '象山县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (330226, 330200, '宁海县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (330281, 330200, '余姚市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (330282, 330200, '慈溪市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (330300, 330000, '温州市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (330302, 330300, '鹿城区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (330303, 330300, '龙湾区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (330304, 330300, '瓯海区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (330305, 330300, '洞头区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (330324, 330300, '永嘉县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (330326, 330300, '平阳县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (330327, 330300, '苍南县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (330328, 330300, '文成县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (330329, 330300, '泰顺县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (330381, 330300, '瑞安市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (330382, 330300, '乐清市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (330400, 330000, '嘉兴市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (330402, 330400, '南湖区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (330411, 330400, '秀洲区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (330421, 330400, '嘉善县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (330424, 330400, '海盐县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (330481, 330400, '海宁市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (330482, 330400, '平湖市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (330483, 330400, '桐乡市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (330500, 330000, '湖州市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (330502, 330500, '吴兴区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (330503, 330500, '南浔区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (330521, 330500, '德清县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (330522, 330500, '长兴县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (330523, 330500, '安吉县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (330600, 330000, '绍兴市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (330602, 330600, '越城区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (330603, 330600, '柯桥区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (330604, 330600, '上虞区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (330624, 330600, '新昌县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (330681, 330600, '诸暨市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (330683, 330600, '嵊州市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (330700, 330000, '金华市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (330702, 330700, '婺城区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (330703, 330700, '金东区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (330723, 330700, '武义县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (330726, 330700, '浦江县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (330727, 330700, '磐安县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (330781, 330700, '兰溪市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (330782, 330700, '义乌市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (330783, 330700, '东阳市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (330784, 330700, '永康市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (330800, 330000, '衢州市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (330802, 330800, '柯城区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (330803, 330800, '衢江区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (330822, 330800, '常山县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (330824, 330800, '开化县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (330825, 330800, '龙游县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (330881, 330800, '江山市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (330900, 330000, '舟山市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (330902, 330900, '定海区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (330903, 330900, '普陀区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (330921, 330900, '岱山县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (330922, 330900, '嵊泗县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (331000, 330000, '台州市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (331002, 331000, '椒江区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (331003, 331000, '黄岩区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (331004, 331000, '路桥区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (331022, 331000, '三门县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (331023, 331000, '天台县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (331024, 331000, '仙居县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (331081, 331000, '温岭市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (331082, 331000, '临海市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (331083, 331000, '玉环市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (331100, 330000, '丽水市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (331102, 331100, '莲都区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (331121, 331100, '青田县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (331122, 331100, '缙云县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (331123, 331100, '遂昌县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (331124, 331100, '松阳县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (331125, 331100, '云和县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (331126, 331100, '庆元县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (331127, 331100, '景宁畲族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (331181, 331100, '龙泉市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (340000, 0, '安徽省', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (340100, 340000, '合肥市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (340102, 340100, '瑶海区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (340103, 340100, '庐阳区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (340104, 340100, '蜀山区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (340111, 340100, '包河区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (340121, 340100, '长丰县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (340122, 340100, '肥东县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (340123, 340100, '肥西县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (340124, 340100, '庐江县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (340181, 340100, '巢湖市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (340200, 340000, '芜湖市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (340202, 340200, '镜湖区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (340203, 340200, '弋江区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (340207, 340200, '鸠江区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (340208, 340200, '三山区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (340221, 340200, '芜湖县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (340222, 340200, '繁昌县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (340223, 340200, '南陵县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (340225, 340200, '无为县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (340300, 340000, '蚌埠市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (340302, 340300, '龙子湖区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (340303, 340300, '蚌山区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (340304, 340300, '禹会区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (340311, 340300, '淮上区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (340321, 340300, '怀远县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (340322, 340300, '五河县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (340323, 340300, '固镇县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (340400, 340000, '淮南市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (340402, 340400, '大通区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (340403, 340400, '田家庵区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (340404, 340400, '谢家集区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (340405, 340400, '八公山区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (340406, 340400, '潘集区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (340421, 340400, '凤台县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (340422, 340400, '寿县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (340500, 340000, '马鞍山市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (340503, 340500, '花山区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (340504, 340500, '雨山区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (340506, 340500, '博望区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (340521, 340500, '当涂县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (340522, 340500, '含山县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (340523, 340500, '和县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (340600, 340000, '淮北市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (340602, 340600, '杜集区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (340603, 340600, '相山区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (340604, 340600, '烈山区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (340621, 340600, '濉溪县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (340700, 340000, '铜陵市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (340705, 340700, '铜官区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (340706, 340700, '义安区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (340711, 340700, '郊区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (340722, 340700, '枞阳县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (340800, 340000, '安庆市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (340802, 340800, '迎江区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (340803, 340800, '大观区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (340811, 340800, '宜秀区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (340822, 340800, '怀宁县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (340824, 340800, '潜山县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (340825, 340800, '太湖县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (340826, 340800, '宿松县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (340827, 340800, '望江县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (340828, 340800, '岳西县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (340881, 340800, '桐城市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (341000, 340000, '黄山市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (341002, 341000, '屯溪区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (341003, 341000, '黄山区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (341004, 341000, '徽州区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (341021, 341000, '歙县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (341022, 341000, '休宁县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (341023, 341000, '黟县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (341024, 341000, '祁门县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (341100, 340000, '滁州市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (341102, 341100, '琅琊区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (341103, 341100, '南谯区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (341122, 341100, '来安县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (341124, 341100, '全椒县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (341125, 341100, '定远县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (341126, 341100, '凤阳县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (341181, 341100, '天长市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (341182, 341100, '明光市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (341200, 340000, '阜阳市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (341202, 341200, '颍州区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (341203, 341200, '颍东区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (341204, 341200, '颍泉区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (341221, 341200, '临泉县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (341222, 341200, '太和县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (341225, 341200, '阜南县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (341226, 341200, '颍上县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (341282, 341200, '界首市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (341300, 340000, '宿州市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (341302, 341300, '埇桥区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (341321, 341300, '砀山县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (341322, 341300, '萧县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (341323, 341300, '灵璧县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (341324, 341300, '泗县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (341500, 340000, '六安市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (341502, 341500, '金安区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (341503, 341500, '裕安区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (341504, 341500, '叶集区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (341522, 341500, '霍邱县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (341523, 341500, '舒城县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (341524, 341500, '金寨县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (341525, 341500, '霍山县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (341600, 340000, '亳州市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (341602, 341600, '谯城区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (341621, 341600, '涡阳县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (341622, 341600, '蒙城县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (341623, 341600, '利辛县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (341700, 340000, '池州市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (341702, 341700, '贵池区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (341721, 341700, '东至县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (341722, 341700, '石台县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (341723, 341700, '青阳县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (341800, 340000, '宣城市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (341802, 341800, '宣州区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (341821, 341800, '郎溪县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (341822, 341800, '广德县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (341823, 341800, '泾县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (341824, 341800, '绩溪县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (341825, 341800, '旌德县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (341881, 341800, '宁国市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (350000, 0, '福建省', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (350100, 350000, '福州市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (350102, 350100, '鼓楼区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (350103, 350100, '台江区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (350104, 350100, '仓山区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (350105, 350100, '马尾区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (350111, 350100, '晋安区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (350112, 350100, '长乐区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (350121, 350100, '闽侯县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (350122, 350100, '连江县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (350123, 350100, '罗源县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (350124, 350100, '闽清县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (350125, 350100, '永泰县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (350128, 350100, '平潭县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (350181, 350100, '福清市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (350200, 350000, '厦门市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (350203, 350200, '思明区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (350205, 350200, '海沧区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (350206, 350200, '湖里区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (350211, 350200, '集美区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (350212, 350200, '同安区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (350213, 350200, '翔安区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (350300, 350000, '莆田市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (350302, 350300, '城厢区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (350303, 350300, '涵江区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (350304, 350300, '荔城区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (350305, 350300, '秀屿区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (350322, 350300, '仙游县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (350400, 350000, '三明市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (350402, 350400, '梅列区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (350403, 350400, '三元区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (350421, 350400, '明溪县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (350423, 350400, '清流县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (350424, 350400, '宁化县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (350425, 350400, '大田县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (350426, 350400, '尤溪县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (350427, 350400, '沙县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (350428, 350400, '将乐县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (350429, 350400, '泰宁县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (350430, 350400, '建宁县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (350481, 350400, '永安市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (350500, 350000, '泉州市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (350502, 350500, '鲤城区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (350503, 350500, '丰泽区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (350504, 350500, '洛江区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (350505, 350500, '泉港区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (350521, 350500, '惠安县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (350524, 350500, '安溪县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (350525, 350500, '永春县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (350526, 350500, '德化县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (350527, 350500, '金门县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (350581, 350500, '石狮市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (350582, 350500, '晋江市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (350583, 350500, '南安市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (350600, 350000, '漳州市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (350602, 350600, '芗城区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (350603, 350600, '龙文区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (350622, 350600, '云霄县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (350623, 350600, '漳浦县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (350624, 350600, '诏安县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (350625, 350600, '长泰县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (350626, 350600, '东山县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (350627, 350600, '南靖县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (350628, 350600, '平和县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (350629, 350600, '华安县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (350681, 350600, '龙海市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (350700, 350000, '南平市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (350702, 350700, '延平区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (350703, 350700, '建阳区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (350721, 350700, '顺昌县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (350722, 350700, '浦城县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (350723, 350700, '光泽县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (350724, 350700, '松溪县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (350725, 350700, '政和县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (350781, 350700, '邵武市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (350782, 350700, '武夷山市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (350783, 350700, '建瓯市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (350800, 350000, '龙岩市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (350802, 350800, '新罗区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (350803, 350800, '永定区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (350821, 350800, '长汀县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (350823, 350800, '上杭县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (350824, 350800, '武平县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (350825, 350800, '连城县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (350881, 350800, '漳平市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (350900, 350000, '宁德市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (350902, 350900, '蕉城区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (350921, 350900, '霞浦县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (350922, 350900, '古田县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (350923, 350900, '屏南县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (350924, 350900, '寿宁县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (350925, 350900, '周宁县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (350926, 350900, '柘荣县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (350981, 350900, '福安市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (350982, 350900, '福鼎市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (360000, 0, '江西省', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (360100, 360000, '南昌市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (360102, 360100, '东湖区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (360103, 360100, '西湖区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (360104, 360100, '青云谱区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (360105, 360100, '湾里区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (360111, 360100, '青山湖区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (360112, 360100, '新建区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (360121, 360100, '南昌县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (360123, 360100, '安义县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (360124, 360100, '进贤县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (360200, 360000, '景德镇市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (360202, 360200, '昌江区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (360203, 360200, '珠山区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (360222, 360200, '浮梁县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (360281, 360200, '乐平市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (360300, 360000, '萍乡市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (360302, 360300, '安源区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (360313, 360300, '湘东区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (360321, 360300, '莲花县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (360322, 360300, '上栗县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (360323, 360300, '芦溪县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (360400, 360000, '九江市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (360402, 360400, '濂溪区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (360403, 360400, '浔阳区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (360404, 360400, '柴桑区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (360423, 360400, '武宁县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (360424, 360400, '修水县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (360425, 360400, '永修县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (360426, 360400, '德安县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (360428, 360400, '都昌县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (360429, 360400, '湖口县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (360430, 360400, '彭泽县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (360481, 360400, '瑞昌市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (360482, 360400, '共青城市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (360483, 360400, '庐山市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (360500, 360000, '新余市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (360502, 360500, '渝水区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (360521, 360500, '分宜县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (360600, 360000, '鹰潭市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (360602, 360600, '月湖区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (360622, 360600, '余江县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (360681, 360600, '贵溪市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (360700, 360000, '赣州市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (360702, 360700, '章贡区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (360703, 360700, '南康区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (360704, 360700, '赣县区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (360722, 360700, '信丰县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (360723, 360700, '大余县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (360724, 360700, '上犹县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (360725, 360700, '崇义县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (360726, 360700, '安远县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (360727, 360700, '龙南县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (360728, 360700, '定南县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (360729, 360700, '全南县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (360730, 360700, '宁都县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (360731, 360700, '于都县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (360732, 360700, '兴国县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (360733, 360700, '会昌县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (360734, 360700, '寻乌县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (360735, 360700, '石城县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (360781, 360700, '瑞金市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (360800, 360000, '吉安市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (360802, 360800, '吉州区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (360803, 360800, '青原区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (360821, 360800, '吉安县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (360822, 360800, '吉水县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (360823, 360800, '峡江县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (360824, 360800, '新干县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (360825, 360800, '永丰县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (360826, 360800, '泰和县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (360827, 360800, '遂川县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (360828, 360800, '万安县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (360829, 360800, '安福县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (360830, 360800, '永新县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (360881, 360800, '井冈山市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (360900, 360000, '宜春市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (360902, 360900, '袁州区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (360921, 360900, '奉新县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (360922, 360900, '万载县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (360923, 360900, '上高县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (360924, 360900, '宜丰县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (360925, 360900, '靖安县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (360926, 360900, '铜鼓县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (360981, 360900, '丰城市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (360982, 360900, '樟树市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (360983, 360900, '高安市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (361000, 360000, '抚州市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (361002, 361000, '临川区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (361003, 361000, '东乡区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (361021, 361000, '南城县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (361022, 361000, '黎川县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (361023, 361000, '南丰县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (361024, 361000, '崇仁县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (361025, 361000, '乐安县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (361026, 361000, '宜黄县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (361027, 361000, '金溪县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (361028, 361000, '资溪县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (361030, 361000, '广昌县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (361100, 360000, '上饶市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (361102, 361100, '信州区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (361103, 361100, '广丰区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (361121, 361100, '上饶县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (361123, 361100, '玉山县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (361124, 361100, '铅山县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (361125, 361100, '横峰县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (361126, 361100, '弋阳县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (361127, 361100, '余干县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (361128, 361100, '鄱阳县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (361129, 361100, '万年县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (361130, 361100, '婺源县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (361181, 361100, '德兴市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (370000, 0, '山东省', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (370100, 370000, '济南市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (370102, 370100, '历下区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (370103, 370100, '市中区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (370104, 370100, '槐荫区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (370105, 370100, '天桥区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (370112, 370100, '历城区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (370113, 370100, '长清区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (370114, 370100, '章丘区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (370124, 370100, '平阴县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (370125, 370100, '济阳县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (370126, 370100, '商河县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (370200, 370000, '青岛市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (370202, 370200, '市南区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (370203, 370200, '市北区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (370211, 370200, '黄岛区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (370212, 370200, '崂山区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (370213, 370200, '李沧区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (370214, 370200, '城阳区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (370215, 370200, '即墨区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (370281, 370200, '胶州市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (370283, 370200, '平度市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (370285, 370200, '莱西市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (370300, 370000, '淄博市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (370302, 370300, '淄川区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (370303, 370300, '张店区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (370304, 370300, '博山区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (370305, 370300, '临淄区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (370306, 370300, '周村区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (370321, 370300, '桓台县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (370322, 370300, '高青县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (370323, 370300, '沂源县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (370400, 370000, '枣庄市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (370402, 370400, '市中区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (370403, 370400, '薛城区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (370404, 370400, '峄城区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (370405, 370400, '台儿庄区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (370406, 370400, '山亭区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (370481, 370400, '滕州市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (370500, 370000, '东营市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (370502, 370500, '东营区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (370503, 370500, '河口区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (370505, 370500, '垦利区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (370522, 370500, '利津县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (370523, 370500, '广饶县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (370600, 370000, '烟台市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (370602, 370600, '芝罘区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (370611, 370600, '福山区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (370612, 370600, '牟平区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (370613, 370600, '莱山区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (370634, 370600, '长岛县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (370681, 370600, '龙口市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (370682, 370600, '莱阳市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (370683, 370600, '莱州市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (370684, 370600, '蓬莱市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (370685, 370600, '招远市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (370686, 370600, '栖霞市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (370687, 370600, '海阳市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (370700, 370000, '潍坊市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (370702, 370700, '潍城区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (370703, 370700, '寒亭区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (370704, 370700, '坊子区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (370705, 370700, '奎文区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (370724, 370700, '临朐县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (370725, 370700, '昌乐县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (370781, 370700, '青州市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (370782, 370700, '诸城市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (370783, 370700, '寿光市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (370784, 370700, '安丘市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (370785, 370700, '高密市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (370786, 370700, '昌邑市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (370800, 370000, '济宁市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (370811, 370800, '任城区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (370812, 370800, '兖州区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (370826, 370800, '微山县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (370827, 370800, '鱼台县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (370828, 370800, '金乡县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (370829, 370800, '嘉祥县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (370830, 370800, '汶上县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (370831, 370800, '泗水县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (370832, 370800, '梁山县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (370881, 370800, '曲阜市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (370883, 370800, '邹城市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (370900, 370000, '泰安市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (370902, 370900, '泰山区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (370911, 370900, '岱岳区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (370921, 370900, '宁阳县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (370923, 370900, '东平县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (370982, 370900, '新泰市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (370983, 370900, '肥城市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (371000, 370000, '威海市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (371002, 371000, '环翠区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (371003, 371000, '文登区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (371082, 371000, '荣成市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (371083, 371000, '乳山市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (371100, 370000, '日照市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (371102, 371100, '东港区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (371103, 371100, '岚山区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (371121, 371100, '五莲县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (371122, 371100, '莒县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (371200, 370000, '莱芜市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (371202, 371200, '莱城区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (371203, 371200, '钢城区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (371300, 370000, '临沂市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (371302, 371300, '兰山区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (371311, 371300, '罗庄区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (371312, 371300, '河东区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (371321, 371300, '沂南县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (371322, 371300, '郯城县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (371323, 371300, '沂水县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (371324, 371300, '兰陵县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (371325, 371300, '费县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (371326, 371300, '平邑县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (371327, 371300, '莒南县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (371328, 371300, '蒙阴县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (371329, 371300, '临沭县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (371400, 370000, '德州市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (371402, 371400, '德城区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (371403, 371400, '陵城区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (371422, 371400, '宁津县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (371423, 371400, '庆云县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (371424, 371400, '临邑县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (371425, 371400, '齐河县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (371426, 371400, '平原县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (371427, 371400, '夏津县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (371428, 371400, '武城县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (371481, 371400, '乐陵市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (371482, 371400, '禹城市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (371500, 370000, '聊城市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (371502, 371500, '东昌府区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (371521, 371500, '阳谷县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (371522, 371500, '莘县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (371523, 371500, '茌平县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (371524, 371500, '东阿县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (371525, 371500, '冠县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (371526, 371500, '高唐县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (371581, 371500, '临清市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (371600, 370000, '滨州市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (371602, 371600, '滨城区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (371603, 371600, '沾化区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (371621, 371600, '惠民县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (371622, 371600, '阳信县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (371623, 371600, '无棣县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (371625, 371600, '博兴县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (371626, 371600, '邹平县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (371700, 370000, '菏泽市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (371702, 371700, '牡丹区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (371703, 371700, '定陶区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (371721, 371700, '曹县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (371722, 371700, '单县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (371723, 371700, '成武县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (371724, 371700, '巨野县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (371725, 371700, '郓城县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (371726, 371700, '鄄城县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (371728, 371700, '东明县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (410000, 0, '河南省', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (410100, 410000, '郑州市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (410102, 410100, '中原区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (410103, 410100, '二七区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (410104, 410100, '管城回族区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (410105, 410100, '金水区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (410106, 410100, '上街区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (410108, 410100, '惠济区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (410122, 410100, '中牟县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (410181, 410100, '巩义市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (410182, 410100, '荥阳市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (410183, 410100, '新密市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (410184, 410100, '新郑市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (410185, 410100, '登封市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (410200, 410000, '开封市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (410202, 410200, '龙亭区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (410203, 410200, '顺河回族区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (410204, 410200, '鼓楼区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (410205, 410200, '禹王台区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (410212, 410200, '祥符区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (410221, 410200, '杞县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (410222, 410200, '通许县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (410223, 410200, '尉氏县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (410225, 410200, '兰考县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (410300, 410000, '洛阳市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (410302, 410300, '老城区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (410303, 410300, '西工区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (410304, 410300, '瀍河回族区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (410305, 410300, '涧西区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (410306, 410300, '吉利区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (410311, 410300, '洛龙区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (410322, 410300, '孟津县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (410323, 410300, '新安县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (410324, 410300, '栾川县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (410325, 410300, '嵩县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (410326, 410300, '汝阳县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (410327, 410300, '宜阳县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (410328, 410300, '洛宁县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (410329, 410300, '伊川县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (410381, 410300, '偃师市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (410400, 410000, '平顶山市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (410402, 410400, '新华区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (410403, 410400, '卫东区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (410404, 410400, '石龙区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (410411, 410400, '湛河区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (410421, 410400, '宝丰县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (410422, 410400, '叶县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (410423, 410400, '鲁山县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (410425, 410400, '郏县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (410481, 410400, '舞钢市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (410482, 410400, '汝州市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (410500, 410000, '安阳市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (410502, 410500, '文峰区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (410503, 410500, '北关区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (410505, 410500, '殷都区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (410506, 410500, '龙安区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (410522, 410500, '安阳县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (410523, 410500, '汤阴县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (410526, 410500, '滑县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (410527, 410500, '内黄县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (410581, 410500, '林州市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (410600, 410000, '鹤壁市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (410602, 410600, '鹤山区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (410603, 410600, '山城区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (410611, 410600, '淇滨区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (410621, 410600, '浚县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (410622, 410600, '淇县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (410700, 410000, '新乡市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (410702, 410700, '红旗区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (410703, 410700, '卫滨区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (410704, 410700, '凤泉区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (410711, 410700, '牧野区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (410721, 410700, '新乡县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (410724, 410700, '获嘉县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (410725, 410700, '原阳县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (410726, 410700, '延津县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (410727, 410700, '封丘县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (410728, 410700, '长垣县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (410781, 410700, '卫辉市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (410782, 410700, '辉县市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (410800, 410000, '焦作市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (410802, 410800, '解放区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (410803, 410800, '中站区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (410804, 410800, '马村区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (410811, 410800, '山阳区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (410821, 410800, '修武县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (410822, 410800, '博爱县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (410823, 410800, '武陟县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (410825, 410800, '温县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (410882, 410800, '沁阳市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (410883, 410800, '孟州市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (410900, 410000, '濮阳市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (410902, 410900, '华龙区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (410922, 410900, '清丰县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (410923, 410900, '南乐县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (410926, 410900, '范县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (410927, 410900, '台前县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (410928, 410900, '濮阳县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (411000, 410000, '许昌市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (411002, 411000, '魏都区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (411003, 411000, '建安区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (411024, 411000, '鄢陵县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (411025, 411000, '襄城县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (411081, 411000, '禹州市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (411082, 411000, '长葛市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (411100, 410000, '漯河市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (411102, 411100, '源汇区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (411103, 411100, '郾城区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (411104, 411100, '召陵区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (411121, 411100, '舞阳县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (411122, 411100, '临颍县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (411200, 410000, '三门峡市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (411202, 411200, '湖滨区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (411203, 411200, '陕州区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (411221, 411200, '渑池县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (411224, 411200, '卢氏县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (411281, 411200, '义马市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (411282, 411200, '灵宝市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (411300, 410000, '南阳市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (411302, 411300, '宛城区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (411303, 411300, '卧龙区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (411321, 411300, '南召县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (411322, 411300, '方城县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (411323, 411300, '西峡县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (411324, 411300, '镇平县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (411325, 411300, '内乡县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (411326, 411300, '淅川县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (411327, 411300, '社旗县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (411328, 411300, '唐河县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (411329, 411300, '新野县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (411330, 411300, '桐柏县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (411381, 411300, '邓州市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (411400, 410000, '商丘市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (411402, 411400, '梁园区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (411403, 411400, '睢阳区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (411421, 411400, '民权县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (411422, 411400, '睢县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (411423, 411400, '宁陵县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (411424, 411400, '柘城县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (411425, 411400, '虞城县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (411426, 411400, '夏邑县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (411481, 411400, '永城市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (411500, 410000, '信阳市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (411502, 411500, '浉河区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (411503, 411500, '平桥区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (411521, 411500, '罗山县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (411522, 411500, '光山县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (411523, 411500, '新县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (411524, 411500, '商城县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (411525, 411500, '固始县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (411526, 411500, '潢川县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (411527, 411500, '淮滨县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (411528, 411500, '息县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (411600, 410000, '周口市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (411602, 411600, '川汇区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (411621, 411600, '扶沟县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (411622, 411600, '西华县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (411623, 411600, '商水县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (411624, 411600, '沈丘县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (411625, 411600, '郸城县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (411626, 411600, '淮阳县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (411627, 411600, '太康县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (411628, 411600, '鹿邑县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (411681, 411600, '项城市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (411700, 410000, '驻马店市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (411702, 411700, '驿城区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (411721, 411700, '西平县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (411722, 411700, '上蔡县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (411723, 411700, '平舆县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (411724, 411700, '正阳县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (411725, 411700, '确山县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (411726, 411700, '泌阳县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (411727, 411700, '汝南县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (411728, 411700, '遂平县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (411729, 411700, '新蔡县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (419001, 410000, '济源市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (420000, 0, '湖北省', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (420100, 420000, '武汉市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (420102, 420100, '江岸区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (420103, 420100, '江汉区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (420104, 420100, '硚口区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (420105, 420100, '汉阳区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (420106, 420100, '武昌区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (420107, 420100, '青山区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (420111, 420100, '洪山区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (420112, 420100, '东西湖区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (420113, 420100, '汉南区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (420114, 420100, '蔡甸区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (420115, 420100, '江夏区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (420116, 420100, '黄陂区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (420117, 420100, '新洲区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (420200, 420000, '黄石市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (420202, 420200, '黄石港区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (420203, 420200, '西塞山区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (420204, 420200, '下陆区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (420205, 420200, '铁山区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (420222, 420200, '阳新县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (420281, 420200, '大冶市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (420300, 420000, '十堰市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (420302, 420300, '茅箭区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (420303, 420300, '张湾区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (420304, 420300, '郧阳区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (420322, 420300, '郧西县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (420323, 420300, '竹山县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (420324, 420300, '竹溪县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (420325, 420300, '房县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (420381, 420300, '丹江口市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (420500, 420000, '宜昌市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (420502, 420500, '西陵区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (420503, 420500, '伍家岗区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (420504, 420500, '点军区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (420505, 420500, '猇亭区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (420506, 420500, '夷陵区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (420525, 420500, '远安县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (420526, 420500, '兴山县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (420527, 420500, '秭归县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (420528, 420500, '长阳土家族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (420529, 420500, '五峰土家族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (420581, 420500, '宜都市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (420582, 420500, '当阳市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (420583, 420500, '枝江市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (420600, 420000, '襄阳市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (420602, 420600, '襄城区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (420606, 420600, '樊城区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (420607, 420600, '襄州区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (420624, 420600, '南漳县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (420625, 420600, '谷城县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (420626, 420600, '保康县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (420682, 420600, '老河口市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (420683, 420600, '枣阳市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (420684, 420600, '宜城市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (420700, 420000, '鄂州市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (420702, 420700, '梁子湖区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (420703, 420700, '华容区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (420704, 420700, '鄂城区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (420800, 420000, '荆门市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (420802, 420800, '东宝区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (420804, 420800, '掇刀区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (420821, 420800, '京山县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (420822, 420800, '沙洋县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (420881, 420800, '钟祥市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (420900, 420000, '孝感市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (420902, 420900, '孝南区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (420921, 420900, '孝昌县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (420922, 420900, '大悟县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (420923, 420900, '云梦县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (420981, 420900, '应城市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (420982, 420900, '安陆市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (420984, 420900, '汉川市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (421000, 420000, '荆州市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (421002, 421000, '沙市区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (421003, 421000, '荆州区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (421022, 421000, '公安县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (421023, 421000, '监利县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (421024, 421000, '江陵县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (421081, 421000, '石首市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (421083, 421000, '洪湖市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (421087, 421000, '松滋市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (421100, 420000, '黄冈市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (421102, 421100, '黄州区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (421121, 421100, '团风县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (421122, 421100, '红安县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (421123, 421100, '罗田县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (421124, 421100, '英山县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (421125, 421100, '浠水县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (421126, 421100, '蕲春县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (421127, 421100, '黄梅县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (421181, 421100, '麻城市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (421182, 421100, '武穴市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (421200, 420000, '咸宁市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (421202, 421200, '咸安区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (421221, 421200, '嘉鱼县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (421222, 421200, '通城县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (421223, 421200, '崇阳县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (421224, 421200, '通山县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (421281, 421200, '赤壁市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (421300, 420000, '随州市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (421303, 421300, '曾都区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (421321, 421300, '随县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (421381, 421300, '广水市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (422800, 420000, '恩施土家族苗族自治州', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (422801, 422800, '恩施市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (422802, 422800, '利川市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (422822, 422800, '建始县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (422823, 422800, '巴东县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (422825, 422800, '宣恩县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (422826, 422800, '咸丰县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (422827, 422800, '来凤县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (422828, 422800, '鹤峰县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (429004, 420000, '仙桃市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (429005, 420000, '潜江市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (429006, 420000, '天门市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (429021, 420000, '神农架林区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (430000, 0, '湖南省', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (430100, 430000, '长沙市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (430102, 430100, '芙蓉区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (430103, 430100, '天心区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (430104, 430100, '岳麓区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (430105, 430100, '开福区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (430111, 430100, '雨花区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (430112, 430100, '望城区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (430121, 430100, '长沙县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (430181, 430100, '浏阳市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (430182, 430100, '宁乡市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (430200, 430000, '株洲市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (430202, 430200, '荷塘区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (430203, 430200, '芦淞区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (430204, 430200, '石峰区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (430211, 430200, '天元区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (430221, 430200, '株洲县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (430223, 430200, '攸县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (430224, 430200, '茶陵县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (430225, 430200, '炎陵县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (430281, 430200, '醴陵市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (430300, 430000, '湘潭市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (430302, 430300, '雨湖区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (430304, 430300, '岳塘区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (430321, 430300, '湘潭县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (430381, 430300, '湘乡市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (430382, 430300, '韶山市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (430400, 430000, '衡阳市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (430405, 430400, '珠晖区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (430406, 430400, '雁峰区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (430407, 430400, '石鼓区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (430408, 430400, '蒸湘区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (430412, 430400, '南岳区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (430421, 430400, '衡阳县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (430422, 430400, '衡南县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (430423, 430400, '衡山县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (430424, 430400, '衡东县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (430426, 430400, '祁东县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (430481, 430400, '耒阳市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (430482, 430400, '常宁市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (430500, 430000, '邵阳市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (430502, 430500, '双清区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (430503, 430500, '大祥区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (430511, 430500, '北塔区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (430521, 430500, '邵东县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (430522, 430500, '新邵县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (430523, 430500, '邵阳县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (430524, 430500, '隆回县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (430525, 430500, '洞口县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (430527, 430500, '绥宁县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (430528, 430500, '新宁县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (430529, 430500, '城步苗族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (430581, 430500, '武冈市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (430600, 430000, '岳阳市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (430602, 430600, '岳阳楼区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (430603, 430600, '云溪区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (430611, 430600, '君山区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (430621, 430600, '岳阳县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (430623, 430600, '华容县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (430624, 430600, '湘阴县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (430626, 430600, '平江县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (430681, 430600, '汨罗市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (430682, 430600, '临湘市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (430700, 430000, '常德市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (430702, 430700, '武陵区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (430703, 430700, '鼎城区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (430721, 430700, '安乡县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (430722, 430700, '汉寿县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (430723, 430700, '澧县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (430724, 430700, '临澧县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (430725, 430700, '桃源县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (430726, 430700, '石门县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (430781, 430700, '津市市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (430800, 430000, '张家界市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (430802, 430800, '永定区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (430811, 430800, '武陵源区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (430821, 430800, '慈利县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (430822, 430800, '桑植县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (430900, 430000, '益阳市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (430902, 430900, '资阳区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (430903, 430900, '赫山区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (430921, 430900, '南县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (430922, 430900, '桃江县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (430923, 430900, '安化县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (430981, 430900, '沅江市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (431000, 430000, '郴州市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (431002, 431000, '北湖区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (431003, 431000, '苏仙区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (431021, 431000, '桂阳县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (431022, 431000, '宜章县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (431023, 431000, '永兴县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (431024, 431000, '嘉禾县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (431025, 431000, '临武县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (431026, 431000, '汝城县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (431027, 431000, '桂东县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (431028, 431000, '安仁县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (431081, 431000, '资兴市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (431100, 430000, '永州市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (431102, 431100, '零陵区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (431103, 431100, '冷水滩区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (431121, 431100, '祁阳县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (431122, 431100, '东安县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (431123, 431100, '双牌县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (431124, 431100, '道县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (431125, 431100, '江永县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (431126, 431100, '宁远县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (431127, 431100, '蓝山县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (431128, 431100, '新田县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (431129, 431100, '江华瑶族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (431200, 430000, '怀化市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (431202, 431200, '鹤城区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (431221, 431200, '中方县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (431222, 431200, '沅陵县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (431223, 431200, '辰溪县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (431224, 431200, '溆浦县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (431225, 431200, '会同县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (431226, 431200, '麻阳苗族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (431227, 431200, '新晃侗族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (431228, 431200, '芷江侗族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (431229, 431200, '靖州苗族侗族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (431230, 431200, '通道侗族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (431281, 431200, '洪江市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (431300, 430000, '娄底市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (431302, 431300, '娄星区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (431321, 431300, '双峰县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (431322, 431300, '新化县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (431381, 431300, '冷水江市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (431382, 431300, '涟源市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (433100, 430000, '湘西土家族苗族自治州', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (433101, 433100, '吉首市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (433122, 433100, '泸溪县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (433123, 433100, '凤凰县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (433124, 433100, '花垣县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (433125, 433100, '保靖县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (433126, 433100, '古丈县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (433127, 433100, '永顺县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (433130, 433100, '龙山县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (440000, 0, '广东省', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (440100, 440000, '广州市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (440103, 440100, '荔湾区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (440104, 440100, '越秀区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (440105, 440100, '海珠区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (440106, 440100, '天河区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (440111, 440100, '白云区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (440112, 440100, '黄埔区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (440113, 440100, '番禺区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (440114, 440100, '花都区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (440115, 440100, '南沙区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (440117, 440100, '从化区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (440118, 440100, '增城区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (440200, 440000, '韶关市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (440203, 440200, '武江区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (440204, 440200, '浈江区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (440205, 440200, '曲江区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (440222, 440200, '始兴县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (440224, 440200, '仁化县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (440229, 440200, '翁源县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (440232, 440200, '乳源瑶族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (440233, 440200, '新丰县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (440281, 440200, '乐昌市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (440282, 440200, '南雄市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (440300, 440000, '深圳市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (440303, 440300, '罗湖区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (440304, 440300, '福田区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (440305, 440300, '南山区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (440306, 440300, '宝安区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (440307, 440300, '龙岗区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (440308, 440300, '盐田区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (440309, 440300, '龙华区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (440310, 440300, '坪山区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (440400, 440000, '珠海市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (440402, 440400, '香洲区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (440403, 440400, '斗门区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (440404, 440400, '金湾区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (440500, 440000, '汕头市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (440507, 440500, '龙湖区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (440511, 440500, '金平区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (440512, 440500, '濠江区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (440513, 440500, '潮阳区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (440514, 440500, '潮南区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (440515, 440500, '澄海区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (440523, 440500, '南澳县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (440600, 440000, '佛山市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (440604, 440600, '禅城区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (440605, 440600, '南海区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (440606, 440600, '顺德区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (440607, 440600, '三水区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (440608, 440600, '高明区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (440700, 440000, '江门市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (440703, 440700, '蓬江区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (440704, 440700, '江海区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (440705, 440700, '新会区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (440781, 440700, '台山市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (440783, 440700, '开平市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (440784, 440700, '鹤山市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (440785, 440700, '恩平市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (440800, 440000, '湛江市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (440802, 440800, '赤坎区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (440803, 440800, '霞山区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (440804, 440800, '坡头区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (440811, 440800, '麻章区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (440823, 440800, '遂溪县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (440825, 440800, '徐闻县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (440881, 440800, '廉江市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (440882, 440800, '雷州市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (440883, 440800, '吴川市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (440900, 440000, '茂名市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (440902, 440900, '茂南区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (440904, 440900, '电白区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (440981, 440900, '高州市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (440982, 440900, '化州市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (440983, 440900, '信宜市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (441200, 440000, '肇庆市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (441202, 441200, '端州区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (441203, 441200, '鼎湖区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (441204, 441200, '高要区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (441223, 441200, '广宁县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (441224, 441200, '怀集县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (441225, 441200, '封开县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (441226, 441200, '德庆县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (441284, 441200, '四会市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (441300, 440000, '惠州市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (441302, 441300, '惠城区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (441303, 441300, '惠阳区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (441322, 441300, '博罗县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (441323, 441300, '惠东县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (441324, 441300, '龙门县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (441400, 440000, '梅州市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (441402, 441400, '梅江区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (441403, 441400, '梅县区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (441422, 441400, '大埔县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (441423, 441400, '丰顺县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (441424, 441400, '五华县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (441426, 441400, '平远县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (441427, 441400, '蕉岭县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (441481, 441400, '兴宁市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (441500, 440000, '汕尾市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (441502, 441500, '城区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (441521, 441500, '海丰县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (441523, 441500, '陆河县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (441581, 441500, '陆丰市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (441600, 440000, '河源市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (441602, 441600, '源城区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (441621, 441600, '紫金县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (441622, 441600, '龙川县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (441623, 441600, '连平县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (441624, 441600, '和平县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (441625, 441600, '东源县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (441700, 440000, '阳江市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (441702, 441700, '江城区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (441704, 441700, '阳东区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (441721, 441700, '阳西县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (441781, 441700, '阳春市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (441800, 440000, '清远市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (441802, 441800, '清城区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (441803, 441800, '清新区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (441821, 441800, '佛冈县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (441823, 441800, '阳山县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (441825, 441800, '连山壮族瑶族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (441826, 441800, '连南瑶族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (441881, 441800, '英德市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (441882, 441800, '连州市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (441900, 440000, '东莞市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (442000, 440000, '中山市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (445100, 440000, '潮州市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (445102, 445100, '湘桥区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (445103, 445100, '潮安区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (445122, 445100, '饶平县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (445200, 440000, '揭阳市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (445202, 445200, '榕城区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (445203, 445200, '揭东区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (445222, 445200, '揭西县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (445224, 445200, '惠来县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (445281, 445200, '普宁市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (445300, 440000, '云浮市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (445302, 445300, '云城区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (445303, 445300, '云安区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (445321, 445300, '新兴县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (445322, 445300, '郁南县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (445381, 445300, '罗定市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (450000, 0, '广西壮族自治区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (450100, 450000, '南宁市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (450102, 450100, '兴宁区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (450103, 450100, '青秀区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (450105, 450100, '江南区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (450107, 450100, '西乡塘区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (450108, 450100, '良庆区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (450109, 450100, '邕宁区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (450110, 450100, '武鸣区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (450123, 450100, '隆安县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (450124, 450100, '马山县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (450125, 450100, '上林县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (450126, 450100, '宾阳县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (450127, 450100, '横县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (450200, 450000, '柳州市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (450202, 450200, '城中区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (450203, 450200, '鱼峰区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (450204, 450200, '柳南区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (450205, 450200, '柳北区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (450206, 450200, '柳江区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (450222, 450200, '柳城县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (450223, 450200, '鹿寨县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (450224, 450200, '融安县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (450225, 450200, '融水苗族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (450226, 450200, '三江侗族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (450300, 450000, '桂林市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (450302, 450300, '秀峰区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (450303, 450300, '叠彩区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (450304, 450300, '象山区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (450305, 450300, '七星区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (450311, 450300, '雁山区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (450312, 450300, '临桂区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (450321, 450300, '阳朔县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (450323, 450300, '灵川县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (450324, 450300, '全州县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (450325, 450300, '兴安县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (450326, 450300, '永福县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (450327, 450300, '灌阳县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (450328, 450300, '龙胜各族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (450329, 450300, '资源县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (450330, 450300, '平乐县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (450331, 450300, '荔浦县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (450332, 450300, '恭城瑶族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (450400, 450000, '梧州市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (450403, 450400, '万秀区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (450405, 450400, '长洲区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (450406, 450400, '龙圩区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (450421, 450400, '苍梧县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (450422, 450400, '藤县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (450423, 450400, '蒙山县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (450481, 450400, '岑溪市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (450500, 450000, '北海市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (450502, 450500, '海城区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (450503, 450500, '银海区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (450512, 450500, '铁山港区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (450521, 450500, '合浦县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (450600, 450000, '防城港市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (450602, 450600, '港口区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (450603, 450600, '防城区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (450621, 450600, '上思县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (450681, 450600, '东兴市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (450700, 450000, '钦州市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (450702, 450700, '钦南区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (450703, 450700, '钦北区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (450721, 450700, '灵山县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (450722, 450700, '浦北县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (450800, 450000, '贵港市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (450802, 450800, '港北区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (450803, 450800, '港南区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (450804, 450800, '覃塘区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (450821, 450800, '平南县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (450881, 450800, '桂平市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (450900, 450000, '玉林市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (450902, 450900, '玉州区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (450903, 450900, '福绵区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (450921, 450900, '容县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (450922, 450900, '陆川县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (450923, 450900, '博白县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (450924, 450900, '兴业县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (450981, 450900, '北流市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (451000, 450000, '百色市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (451002, 451000, '右江区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (451021, 451000, '田阳县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (451022, 451000, '田东县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (451023, 451000, '平果县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (451024, 451000, '德保县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (451026, 451000, '那坡县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (451027, 451000, '凌云县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (451028, 451000, '乐业县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (451029, 451000, '田林县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (451030, 451000, '西林县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (451031, 451000, '隆林各族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (451081, 451000, '靖西市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (451100, 450000, '贺州市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (451102, 451100, '八步区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (451103, 451100, '平桂区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (451121, 451100, '昭平县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (451122, 451100, '钟山县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (451123, 451100, '富川瑶族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (451200, 450000, '河池市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (451202, 451200, '金城江区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (451203, 451200, '宜州区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (451221, 451200, '南丹县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (451222, 451200, '天峨县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (451223, 451200, '凤山县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (451224, 451200, '东兰县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (451225, 451200, '罗城仫佬族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (451226, 451200, '环江毛南族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (451227, 451200, '巴马瑶族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (451228, 451200, '都安瑶族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (451229, 451200, '大化瑶族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (451300, 450000, '来宾市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (451302, 451300, '兴宾区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (451321, 451300, '忻城县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (451322, 451300, '象州县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (451323, 451300, '武宣县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (451324, 451300, '金秀瑶族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (451381, 451300, '合山市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (451400, 450000, '崇左市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (451402, 451400, '江州区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (451421, 451400, '扶绥县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (451422, 451400, '宁明县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (451423, 451400, '龙州县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (451424, 451400, '大新县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (451425, 451400, '天等县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (451481, 451400, '凭祥市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (460000, 0, '海南省', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (460100, 460000, '海口市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (460105, 460100, '秀英区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (460106, 460100, '龙华区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (460107, 460100, '琼山区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (460108, 460100, '美兰区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (460200, 460000, '三亚市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (460202, 460200, '海棠区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (460203, 460200, '吉阳区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (460204, 460200, '天涯区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (460205, 460200, '崖州区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (460300, 460000, '三沙市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (460400, 460000, '儋州市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (469001, 460000, '五指山市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (469002, 460000, '琼海市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (469005, 460000, '文昌市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (469006, 460000, '万宁市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (469007, 460000, '东方市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (469021, 460000, '定安县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (469022, 460000, '屯昌县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (469023, 460000, '澄迈县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (469024, 460000, '临高县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (469025, 460000, '白沙黎族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (469026, 460000, '昌江黎族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (469027, 460000, '乐东黎族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (469028, 460000, '陵水黎族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (469029, 460000, '保亭黎族苗族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (469030, 460000, '琼中黎族苗族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (500000, 0, '重庆市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (500100, 500000, '重庆市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (500101, 500100, '万州区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (500102, 500100, '涪陵区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (500103, 500100, '渝中区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (500104, 500100, '大渡口区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (500105, 500100, '江北区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (500106, 500100, '沙坪坝区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (500107, 500100, '九龙坡区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (500108, 500100, '南岸区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (500109, 500100, '北碚区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (500110, 500100, '綦江区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (500111, 500100, '大足区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (500112, 500100, '渝北区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (500113, 500100, '巴南区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (500114, 500100, '黔江区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (500115, 500100, '长寿区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (500116, 500100, '江津区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (500117, 500100, '合川区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (500118, 500100, '永川区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (500119, 500100, '南川区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (500120, 500100, '璧山区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (500151, 500100, '铜梁区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (500152, 500100, '潼南区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (500153, 500100, '荣昌区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (500154, 500100, '开州区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (500155, 500100, '梁平区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (500156, 500100, '武隆区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (500229, 500100, '城口县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (500230, 500100, '丰都县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (500231, 500100, '垫江县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (500233, 500100, '忠县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (500235, 500100, '云阳县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (500236, 500100, '奉节县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (500237, 500100, '巫山县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (500238, 500100, '巫溪县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (500240, 500100, '石柱土家族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (500241, 500100, '秀山土家族苗族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (500242, 500100, '酉阳土家族苗族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (500243, 500100, '彭水苗族土家族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (510000, 0, '四川省', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (510100, 510000, '成都市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (510104, 510100, '锦江区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (510105, 510100, '青羊区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (510106, 510100, '金牛区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (510107, 510100, '武侯区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (510108, 510100, '成华区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (510112, 510100, '龙泉驿区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (510113, 510100, '青白江区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (510114, 510100, '新都区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (510115, 510100, '温江区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (510116, 510100, '双流区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (510117, 510100, '郫都区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (510121, 510100, '金堂县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (510129, 510100, '大邑县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (510131, 510100, '蒲江县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (510132, 510100, '新津县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (510181, 510100, '都江堰市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (510182, 510100, '彭州市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (510183, 510100, '邛崃市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (510184, 510100, '崇州市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (510185, 510100, '简阳市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (510300, 510000, '自贡市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (510302, 510300, '自流井区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (510303, 510300, '贡井区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (510304, 510300, '大安区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (510311, 510300, '沿滩区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (510321, 510300, '荣县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (510322, 510300, '富顺县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (510400, 510000, '攀枝花市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (510402, 510400, '东区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (510403, 510400, '西区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (510411, 510400, '仁和区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (510421, 510400, '米易县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (510422, 510400, '盐边县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (510500, 510000, '泸州市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (510502, 510500, '江阳区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (510503, 510500, '纳溪区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (510504, 510500, '龙马潭区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (510521, 510500, '泸县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (510522, 510500, '合江县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (510524, 510500, '叙永县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (510525, 510500, '古蔺县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (510600, 510000, '德阳市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (510603, 510600, '旌阳区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (510623, 510600, '中江县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (510626, 510600, '罗江县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (510681, 510600, '广汉市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (510682, 510600, '什邡市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (510683, 510600, '绵竹市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (510700, 510000, '绵阳市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (510703, 510700, '涪城区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (510704, 510700, '游仙区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (510705, 510700, '安州区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (510722, 510700, '三台县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (510723, 510700, '盐亭县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (510725, 510700, '梓潼县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (510726, 510700, '北川羌族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (510727, 510700, '平武县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (510781, 510700, '江油市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (510800, 510000, '广元市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (510802, 510800, '利州区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (510811, 510800, '昭化区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (510812, 510800, '朝天区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (510821, 510800, '旺苍县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (510822, 510800, '青川县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (510823, 510800, '剑阁县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (510824, 510800, '苍溪县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (510900, 510000, '遂宁市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (510903, 510900, '船山区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (510904, 510900, '安居区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (510921, 510900, '蓬溪县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (510922, 510900, '射洪县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (510923, 510900, '大英县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (511000, 510000, '内江市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (511002, 511000, '市中区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (511011, 511000, '东兴区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (511024, 511000, '威远县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (511025, 511000, '资中县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (511083, 511000, '隆昌市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (511100, 510000, '乐山市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (511102, 511100, '市中区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (511111, 511100, '沙湾区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (511112, 511100, '五通桥区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (511113, 511100, '金口河区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (511123, 511100, '犍为县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (511124, 511100, '井研县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (511126, 511100, '夹江县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (511129, 511100, '沐川县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (511132, 511100, '峨边彝族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (511133, 511100, '马边彝族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (511181, 511100, '峨眉山市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (511300, 510000, '南充市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (511302, 511300, '顺庆区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (511303, 511300, '高坪区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (511304, 511300, '嘉陵区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (511321, 511300, '南部县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (511322, 511300, '营山县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (511323, 511300, '蓬安县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (511324, 511300, '仪陇县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (511325, 511300, '西充县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (511381, 511300, '阆中市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (511400, 510000, '眉山市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (511402, 511400, '东坡区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (511403, 511400, '彭山区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (511421, 511400, '仁寿县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (511423, 511400, '洪雅县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (511424, 511400, '丹棱县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (511425, 511400, '青神县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (511500, 510000, '宜宾市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (511502, 511500, '翠屏区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (511503, 511500, '南溪区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (511521, 511500, '宜宾县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (511523, 511500, '江安县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (511524, 511500, '长宁县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (511525, 511500, '高县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (511526, 511500, '珙县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (511527, 511500, '筠连县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (511528, 511500, '兴文县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (511529, 511500, '屏山县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (511600, 510000, '广安市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (511602, 511600, '广安区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (511603, 511600, '前锋区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (511621, 511600, '岳池县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (511622, 511600, '武胜县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (511623, 511600, '邻水县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (511681, 511600, '华蓥市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (511700, 510000, '达州市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (511702, 511700, '通川区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (511703, 511700, '达川区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (511722, 511700, '宣汉县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (511723, 511700, '开江县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (511724, 511700, '大竹县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (511725, 511700, '渠县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (511781, 511700, '万源市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (511800, 510000, '雅安市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (511802, 511800, '雨城区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (511803, 511800, '名山区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (511822, 511800, '荥经县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (511823, 511800, '汉源县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (511824, 511800, '石棉县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (511825, 511800, '天全县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (511826, 511800, '芦山县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (511827, 511800, '宝兴县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (511900, 510000, '巴中市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (511902, 511900, '巴州区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (511903, 511900, '恩阳区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (511921, 511900, '通江县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (511922, 511900, '南江县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (511923, 511900, '平昌县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (512000, 510000, '资阳市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (512002, 512000, '雁江区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (512021, 512000, '安岳县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (512022, 512000, '乐至县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (513200, 510000, '阿坝藏族羌族自治州', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (513201, 513200, '马尔康市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (513221, 513200, '汶川县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (513222, 513200, '理县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (513223, 513200, '茂县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (513224, 513200, '松潘县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (513225, 513200, '九寨沟县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (513226, 513200, '金川县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (513227, 513200, '小金县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (513228, 513200, '黑水县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (513230, 513200, '壤塘县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (513231, 513200, '阿坝县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (513232, 513200, '若尔盖县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (513233, 513200, '红原县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (513300, 510000, '甘孜藏族自治州', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (513301, 513300, '康定市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (513322, 513300, '泸定县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (513323, 513300, '丹巴县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (513324, 513300, '九龙县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (513325, 513300, '雅江县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (513326, 513300, '道孚县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (513327, 513300, '炉霍县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (513328, 513300, '甘孜县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (513329, 513300, '新龙县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (513330, 513300, '德格县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (513331, 513300, '白玉县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (513332, 513300, '石渠县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (513333, 513300, '色达县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (513334, 513300, '理塘县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (513335, 513300, '巴塘县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (513336, 513300, '乡城县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (513337, 513300, '稻城县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (513338, 513300, '得荣县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (513400, 510000, '凉山彝族自治州', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (513401, 513400, '西昌市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (513422, 513400, '木里藏族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (513423, 513400, '盐源县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (513424, 513400, '德昌县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (513425, 513400, '会理县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (513426, 513400, '会东县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (513427, 513400, '宁南县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (513428, 513400, '普格县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (513429, 513400, '布拖县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (513430, 513400, '金阳县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (513431, 513400, '昭觉县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (513432, 513400, '喜德县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (513433, 513400, '冕宁县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (513434, 513400, '越西县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (513435, 513400, '甘洛县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (513436, 513400, '美姑县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (513437, 513400, '雷波县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (520000, 0, '贵州省', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (520100, 520000, '贵阳市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (520102, 520100, '南明区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (520103, 520100, '云岩区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (520111, 520100, '花溪区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (520112, 520100, '乌当区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (520113, 520100, '白云区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (520115, 520100, '观山湖区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (520121, 520100, '开阳县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (520122, 520100, '息烽县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (520123, 520100, '修文县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (520181, 520100, '清镇市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (520200, 520000, '六盘水市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (520201, 520200, '钟山区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (520203, 520200, '六枝特区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (520221, 520200, '水城县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (520281, 520200, '盘州市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (520300, 520000, '遵义市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (520302, 520300, '红花岗区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (520303, 520300, '汇川区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (520304, 520300, '播州区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (520322, 520300, '桐梓县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (520323, 520300, '绥阳县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (520324, 520300, '正安县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (520325, 520300, '道真仡佬族苗族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (520326, 520300, '务川仡佬族苗族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (520327, 520300, '凤冈县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (520328, 520300, '湄潭县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (520329, 520300, '余庆县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (520330, 520300, '习水县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (520381, 520300, '赤水市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (520382, 520300, '仁怀市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (520400, 520000, '安顺市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (520402, 520400, '西秀区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (520403, 520400, '平坝区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (520422, 520400, '普定县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (520423, 520400, '镇宁布依族苗族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (520424, 520400, '关岭布依族苗族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (520425, 520400, '紫云苗族布依族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (520500, 520000, '毕节市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (520502, 520500, '七星关区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (520521, 520500, '大方县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (520522, 520500, '黔西县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (520523, 520500, '金沙县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (520524, 520500, '织金县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (520525, 520500, '纳雍县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (520526, 520500, '威宁彝族回族苗族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (520527, 520500, '赫章县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (520600, 520000, '铜仁市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (520602, 520600, '碧江区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (520603, 520600, '万山区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (520621, 520600, '江口县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (520622, 520600, '玉屏侗族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (520623, 520600, '石阡县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (520624, 520600, '思南县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (520625, 520600, '印江土家族苗族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (520626, 520600, '德江县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (520627, 520600, '沿河土家族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (520628, 520600, '松桃苗族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (522300, 520000, '黔西南布依族苗族自治州', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (522301, 522300, '兴义市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (522322, 522300, '兴仁县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (522323, 522300, '普安县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (522324, 522300, '晴隆县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (522325, 522300, '贞丰县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (522326, 522300, '望谟县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (522327, 522300, '册亨县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (522328, 522300, '安龙县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (522600, 520000, '黔东南苗族侗族自治州', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (522601, 522600, '凯里市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (522622, 522600, '黄平县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (522623, 522600, '施秉县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (522624, 522600, '三穗县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (522625, 522600, '镇远县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (522626, 522600, '岑巩县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (522627, 522600, '天柱县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (522628, 522600, '锦屏县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (522629, 522600, '剑河县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (522630, 522600, '台江县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (522631, 522600, '黎平县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (522632, 522600, '榕江县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (522633, 522600, '从江县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (522634, 522600, '雷山县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (522635, 522600, '麻江县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (522636, 522600, '丹寨县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (522700, 520000, '黔南布依族苗族自治州', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (522701, 522700, '都匀市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (522702, 522700, '福泉市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (522722, 522700, '荔波县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (522723, 522700, '贵定县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (522725, 522700, '瓮安县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (522726, 522700, '独山县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (522727, 522700, '平塘县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (522728, 522700, '罗甸县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (522729, 522700, '长顺县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (522730, 522700, '龙里县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (522731, 522700, '惠水县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (522732, 522700, '三都水族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (530000, 0, '云南省', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (530100, 530000, '昆明市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (530102, 530100, '五华区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (530103, 530100, '盘龙区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (530111, 530100, '官渡区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (530112, 530100, '西山区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (530113, 530100, '东川区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (530114, 530100, '呈贡区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (530115, 530100, '晋宁区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (530124, 530100, '富民县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (530125, 530100, '宜良县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (530126, 530100, '石林彝族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (530127, 530100, '嵩明县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (530128, 530100, '禄劝彝族苗族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (530129, 530100, '寻甸回族彝族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (530181, 530100, '安宁市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (530300, 530000, '曲靖市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (530302, 530300, '麒麟区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (530303, 530300, '沾益区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (530321, 530300, '马龙县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (530322, 530300, '陆良县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (530323, 530300, '师宗县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (530324, 530300, '罗平县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (530325, 530300, '富源县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (530326, 530300, '会泽县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (530381, 530300, '宣威市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (530400, 530000, '玉溪市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (530402, 530400, '红塔区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (530403, 530400, '江川区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (530422, 530400, '澄江县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (530423, 530400, '通海县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (530424, 530400, '华宁县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (530425, 530400, '易门县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (530426, 530400, '峨山彝族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (530427, 530400, '新平彝族傣族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (530428, 530400, '元江哈尼族彝族傣族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (530500, 530000, '保山市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (530502, 530500, '隆阳区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (530521, 530500, '施甸县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (530523, 530500, '龙陵县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (530524, 530500, '昌宁县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (530581, 530500, '腾冲市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (530600, 530000, '昭通市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (530602, 530600, '昭阳区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (530621, 530600, '鲁甸县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (530622, 530600, '巧家县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (530623, 530600, '盐津县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (530624, 530600, '大关县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (530625, 530600, '永善县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (530626, 530600, '绥江县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (530627, 530600, '镇雄县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (530628, 530600, '彝良县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (530629, 530600, '威信县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (530630, 530600, '水富县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (530700, 530000, '丽江市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (530702, 530700, '古城区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (530721, 530700, '玉龙纳西族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (530722, 530700, '永胜县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (530723, 530700, '华坪县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (530724, 530700, '宁蒗彝族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (530800, 530000, '普洱市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (530802, 530800, '思茅区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (530821, 530800, '宁洱哈尼族彝族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (530822, 530800, '墨江哈尼族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (530823, 530800, '景东彝族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (530824, 530800, '景谷傣族彝族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (530825, 530800, '镇沅彝族哈尼族拉祜族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (530826, 530800, '江城哈尼族彝族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (530827, 530800, '孟连傣族拉祜族佤族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (530828, 530800, '澜沧拉祜族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (530829, 530800, '西盟佤族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (530900, 530000, '临沧市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (530902, 530900, '临翔区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (530921, 530900, '凤庆县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (530922, 530900, '云县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (530923, 530900, '永德县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (530924, 530900, '镇康县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (530925, 530900, '双江拉祜族佤族布朗族傣族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (530926, 530900, '耿马傣族佤族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (530927, 530900, '沧源佤族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (532300, 530000, '楚雄彝族自治州', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (532301, 532300, '楚雄市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (532322, 532300, '双柏县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (532323, 532300, '牟定县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (532324, 532300, '南华县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (532325, 532300, '姚安县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (532326, 532300, '大姚县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (532327, 532300, '永仁县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (532328, 532300, '元谋县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (532329, 532300, '武定县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (532331, 532300, '禄丰县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (532500, 530000, '红河哈尼族彝族自治州', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (532501, 532500, '个旧市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (532502, 532500, '开远市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (532503, 532500, '蒙自市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (532504, 532500, '弥勒市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (532523, 532500, '屏边苗族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (532524, 532500, '建水县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (532525, 532500, '石屏县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (532527, 532500, '泸西县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (532528, 532500, '元阳县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (532529, 532500, '红河县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (532530, 532500, '金平苗族瑶族傣族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (532531, 532500, '绿春县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (532532, 532500, '河口瑶族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (532600, 530000, '文山壮族苗族自治州', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (532601, 532600, '文山市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (532622, 532600, '砚山县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (532623, 532600, '西畴县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (532624, 532600, '麻栗坡县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (532625, 532600, '马关县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (532626, 532600, '丘北县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (532627, 532600, '广南县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (532628, 532600, '富宁县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (532800, 530000, '西双版纳傣族自治州', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (532801, 532800, '景洪市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (532822, 532800, '勐海县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (532823, 532800, '勐腊县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (532900, 530000, '大理白族自治州', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (532901, 532900, '大理市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (532922, 532900, '漾濞彝族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (532923, 532900, '祥云县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (532924, 532900, '宾川县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (532925, 532900, '弥渡县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (532926, 532900, '南涧彝族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (532927, 532900, '巍山彝族回族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (532928, 532900, '永平县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (532929, 532900, '云龙县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (532930, 532900, '洱源县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (532931, 532900, '剑川县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (532932, 532900, '鹤庆县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (533100, 530000, '德宏傣族景颇族自治州', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (533102, 533100, '瑞丽市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (533103, 533100, '芒市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (533122, 533100, '梁河县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (533123, 533100, '盈江县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (533124, 533100, '陇川县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (533300, 530000, '怒江傈僳族自治州', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (533301, 533300, '泸水市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (533323, 533300, '福贡县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (533324, 533300, '贡山独龙族怒族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (533325, 533300, '兰坪白族普米族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (533400, 530000, '迪庆藏族自治州', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (533401, 533400, '香格里拉市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (533422, 533400, '德钦县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (533423, 533400, '维西傈僳族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (540000, 0, '西藏自治区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (540100, 540000, '拉萨市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (540102, 540100, '城关区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (540103, 540100, '堆龙德庆区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (540104, 540100, '达孜区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (540121, 540100, '林周县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (540122, 540100, '当雄县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (540123, 540100, '尼木县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (540124, 540100, '曲水县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (540127, 540100, '墨竹工卡县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (540200, 540000, '日喀则市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (540202, 540200, '桑珠孜区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (540221, 540200, '南木林县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (540222, 540200, '江孜县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (540223, 540200, '定日县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (540224, 540200, '萨迦县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (540225, 540200, '拉孜县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (540226, 540200, '昂仁县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (540227, 540200, '谢通门县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (540228, 540200, '白朗县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (540229, 540200, '仁布县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (540230, 540200, '康马县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (540231, 540200, '定结县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (540232, 540200, '仲巴县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (540233, 540200, '亚东县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (540234, 540200, '吉隆县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (540235, 540200, '聂拉木县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (540236, 540200, '萨嘎县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (540237, 540200, '岗巴县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (540300, 540000, '昌都市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (540302, 540300, '卡若区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (540321, 540300, '江达县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (540322, 540300, '贡觉县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (540323, 540300, '类乌齐县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (540324, 540300, '丁青县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (540325, 540300, '察雅县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (540326, 540300, '八宿县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (540327, 540300, '左贡县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (540328, 540300, '芒康县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (540329, 540300, '洛隆县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (540330, 540300, '边坝县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (540400, 540000, '林芝市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (540402, 540400, '巴宜区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (540421, 540400, '工布江达县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (540422, 540400, '米林县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (540423, 540400, '墨脱县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (540424, 540400, '波密县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (540425, 540400, '察隅县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (540426, 540400, '朗县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (540500, 540000, '山南市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (540502, 540500, '乃东区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (540521, 540500, '扎囊县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (540522, 540500, '贡嘎县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (540523, 540500, '桑日县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (540524, 540500, '琼结县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (540525, 540500, '曲松县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (540526, 540500, '措美县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (540527, 540500, '洛扎县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (540528, 540500, '加查县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (540529, 540500, '隆子县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (540530, 540500, '错那县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (540531, 540500, '浪卡子县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (540600, 540000, '那曲市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (540602, 540600, '色尼区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (540621, 540600, '嘉黎县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (540622, 540600, '比如县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (540623, 540600, '聂荣县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (540624, 540600, '安多县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (540625, 540600, '申扎县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (540626, 540600, '索县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (540627, 540600, '班戈县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (540628, 540600, '巴青县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (540629, 540600, '尼玛县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (540630, 540600, '双湖县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (542500, 540000, '阿里地区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (542521, 542500, '普兰县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (542522, 542500, '札达县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (542523, 542500, '噶尔县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (542524, 542500, '日土县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (542525, 542500, '革吉县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (542526, 542500, '改则县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (542527, 542500, '措勤县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610000, 0, '陕西省', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610100, 610000, '西安市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610102, 610100, '新城区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610103, 610100, '碑林区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610104, 610100, '莲湖区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610111, 610100, '灞桥区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610112, 610100, '未央区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610113, 610100, '雁塔区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610114, 610100, '阎良区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610115, 610100, '临潼区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610116, 610100, '长安区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610117, 610100, '高陵区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610118, 610100, '鄠邑区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610122, 610100, '蓝田县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610124, 610100, '周至县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610200, 610000, '铜川市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610202, 610200, '王益区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610203, 610200, '印台区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610204, 610200, '耀州区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610222, 610200, '宜君县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610300, 610000, '宝鸡市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610302, 610300, '渭滨区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610303, 610300, '金台区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610304, 610300, '陈仓区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610322, 610300, '凤翔县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610323, 610300, '岐山县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610324, 610300, '扶风县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610326, 610300, '眉县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610327, 610300, '陇县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610328, 610300, '千阳县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610329, 610300, '麟游县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610330, 610300, '凤县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610331, 610300, '太白县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610400, 610000, '咸阳市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610402, 610400, '秦都区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610403, 610400, '杨陵区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610404, 610400, '渭城区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610422, 610400, '三原县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610423, 610400, '泾阳县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610424, 610400, '乾县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610425, 610400, '礼泉县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610426, 610400, '永寿县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610427, 610400, '彬县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610428, 610400, '长武县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610429, 610400, '旬邑县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610430, 610400, '淳化县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610431, 610400, '武功县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610481, 610400, '兴平市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610500, 610000, '渭南市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610502, 610500, '临渭区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610503, 610500, '华州区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610522, 610500, '潼关县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610523, 610500, '大荔县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610524, 610500, '合阳县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610525, 610500, '澄城县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610526, 610500, '蒲城县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610527, 610500, '白水县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610528, 610500, '富平县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610581, 610500, '韩城市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610582, 610500, '华阴市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610600, 610000, '延安市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610602, 610600, '宝塔区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610603, 610600, '安塞区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610621, 610600, '延长县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610622, 610600, '延川县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610623, 610600, '子长县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610625, 610600, '志丹县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610626, 610600, '吴起县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610627, 610600, '甘泉县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610628, 610600, '富县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610629, 610600, '洛川县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610630, 610600, '宜川县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610631, 610600, '黄龙县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610632, 610600, '黄陵县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610700, 610000, '汉中市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610702, 610700, '汉台区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610703, 610700, '南郑区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610722, 610700, '城固县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610723, 610700, '洋县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610724, 610700, '西乡县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610725, 610700, '勉县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610726, 610700, '宁强县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610727, 610700, '略阳县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610728, 610700, '镇巴县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610729, 610700, '留坝县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610730, 610700, '佛坪县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610800, 610000, '榆林市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610802, 610800, '榆阳区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610803, 610800, '横山区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610822, 610800, '府谷县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610824, 610800, '靖边县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610825, 610800, '定边县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610826, 610800, '绥德县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610827, 610800, '米脂县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610828, 610800, '佳县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610829, 610800, '吴堡县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610830, 610800, '清涧县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610831, 610800, '子洲县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610881, 610800, '神木市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610900, 610000, '安康市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610902, 610900, '汉滨区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610921, 610900, '汉阴县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610922, 610900, '石泉县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610923, 610900, '宁陕县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610924, 610900, '紫阳县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610925, 610900, '岚皋县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610926, 610900, '平利县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610927, 610900, '镇坪县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610928, 610900, '旬阳县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (610929, 610900, '白河县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (611000, 610000, '商洛市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (611002, 611000, '商州区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (611021, 611000, '洛南县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (611022, 611000, '丹凤县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (611023, 611000, '商南县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (611024, 611000, '山阳县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (611025, 611000, '镇安县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (611026, 611000, '柞水县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (620000, 0, '甘肃省', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (620100, 620000, '兰州市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (620102, 620100, '城关区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (620103, 620100, '七里河区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (620104, 620100, '西固区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (620105, 620100, '安宁区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (620111, 620100, '红古区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (620121, 620100, '永登县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (620122, 620100, '皋兰县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (620123, 620100, '榆中县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (620200, 620000, '嘉峪关市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (620300, 620000, '金昌市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (620302, 620300, '金川区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (620321, 620300, '永昌县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (620400, 620000, '白银市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (620402, 620400, '白银区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (620403, 620400, '平川区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (620421, 620400, '靖远县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (620422, 620400, '会宁县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (620423, 620400, '景泰县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (620500, 620000, '天水市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (620502, 620500, '秦州区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (620503, 620500, '麦积区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (620521, 620500, '清水县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (620522, 620500, '秦安县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (620523, 620500, '甘谷县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (620524, 620500, '武山县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (620525, 620500, '张家川回族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (620600, 620000, '武威市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (620602, 620600, '凉州区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (620621, 620600, '民勤县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (620622, 620600, '古浪县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (620623, 620600, '天祝藏族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (620700, 620000, '张掖市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (620702, 620700, '甘州区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (620721, 620700, '肃南裕固族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (620722, 620700, '民乐县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (620723, 620700, '临泽县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (620724, 620700, '高台县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (620725, 620700, '山丹县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (620800, 620000, '平凉市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (620802, 620800, '崆峒区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (620821, 620800, '泾川县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (620822, 620800, '灵台县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (620823, 620800, '崇信县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (620824, 620800, '华亭县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (620825, 620800, '庄浪县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (620826, 620800, '静宁县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (620900, 620000, '酒泉市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (620902, 620900, '肃州区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (620921, 620900, '金塔县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (620922, 620900, '瓜州县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (620923, 620900, '肃北蒙古族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (620924, 620900, '阿克塞哈萨克族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (620981, 620900, '玉门市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (620982, 620900, '敦煌市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (621000, 620000, '庆阳市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (621002, 621000, '西峰区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (621021, 621000, '庆城县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (621022, 621000, '环县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (621023, 621000, '华池县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (621024, 621000, '合水县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (621025, 621000, '正宁县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (621026, 621000, '宁县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (621027, 621000, '镇原县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (621100, 620000, '定西市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (621102, 621100, '安定区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (621121, 621100, '通渭县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (621122, 621100, '陇西县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (621123, 621100, '渭源县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (621124, 621100, '临洮县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (621125, 621100, '漳县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (621126, 621100, '岷县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (621200, 620000, '陇南市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (621202, 621200, '武都区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (621221, 621200, '成县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (621222, 621200, '文县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (621223, 621200, '宕昌县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (621224, 621200, '康县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (621225, 621200, '西和县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (621226, 621200, '礼县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (621227, 621200, '徽县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (621228, 621200, '两当县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (622900, 620000, '临夏回族自治州', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (622901, 622900, '临夏市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (622921, 622900, '临夏县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (622922, 622900, '康乐县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (622923, 622900, '永靖县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (622924, 622900, '广河县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (622925, 622900, '和政县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (622926, 622900, '东乡族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (622927, 622900, '积石山保安族东乡族撒拉族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (623000, 620000, '甘南藏族自治州', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (623001, 623000, '合作市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (623021, 623000, '临潭县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (623022, 623000, '卓尼县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (623023, 623000, '舟曲县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (623024, 623000, '迭部县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (623025, 623000, '玛曲县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (623026, 623000, '碌曲县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (623027, 623000, '夏河县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (630000, 0, '青海省', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (630100, 630000, '西宁市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (630102, 630100, '城东区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (630103, 630100, '城中区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (630104, 630100, '城西区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (630105, 630100, '城北区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (630121, 630100, '大通回族土族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (630122, 630100, '湟中县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (630123, 630100, '湟源县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (630200, 630000, '海东市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (630202, 630200, '乐都区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (630203, 630200, '平安区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (630222, 630200, '民和回族土族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (630223, 630200, '互助土族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (630224, 630200, '化隆回族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (630225, 630200, '循化撒拉族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (632200, 630000, '海北藏族自治州', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (632221, 632200, '门源回族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (632222, 632200, '祁连县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (632223, 632200, '海晏县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (632224, 632200, '刚察县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (632300, 630000, '黄南藏族自治州', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (632321, 632300, '同仁县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (632322, 632300, '尖扎县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (632323, 632300, '泽库县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (632324, 632300, '河南蒙古族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (632500, 630000, '海南藏族自治州', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (632521, 632500, '共和县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (632522, 632500, '同德县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (632523, 632500, '贵德县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (632524, 632500, '兴海县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (632525, 632500, '贵南县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (632600, 630000, '果洛藏族自治州', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (632621, 632600, '玛沁县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (632622, 632600, '班玛县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (632623, 632600, '甘德县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (632624, 632600, '达日县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (632625, 632600, '久治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (632626, 632600, '玛多县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (632700, 630000, '玉树藏族自治州', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (632701, 632700, '玉树市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (632722, 632700, '杂多县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (632723, 632700, '称多县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (632724, 632700, '治多县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (632725, 632700, '囊谦县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (632726, 632700, '曲麻莱县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (632800, 630000, '海西蒙古族藏族自治州', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (632801, 632800, '格尔木市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (632802, 632800, '德令哈市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (632821, 632800, '乌兰县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (632822, 632800, '都兰县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (632823, 632800, '天峻县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (640000, 0, '宁夏回族自治区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (640100, 640000, '银川市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (640104, 640100, '兴庆区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (640105, 640100, '西夏区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (640106, 640100, '金凤区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (640121, 640100, '永宁县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (640122, 640100, '贺兰县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (640181, 640100, '灵武市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (640200, 640000, '石嘴山市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (640202, 640200, '大武口区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (640205, 640200, '惠农区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (640221, 640200, '平罗县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (640300, 640000, '吴忠市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (640302, 640300, '利通区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (640303, 640300, '红寺堡区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (640323, 640300, '盐池县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (640324, 640300, '同心县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (640381, 640300, '青铜峡市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (640400, 640000, '固原市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (640402, 640400, '原州区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (640422, 640400, '西吉县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (640423, 640400, '隆德县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (640424, 640400, '泾源县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (640425, 640400, '彭阳县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (640500, 640000, '中卫市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (640502, 640500, '沙坡头区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (640521, 640500, '中宁县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (640522, 640500, '海原县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (650000, 0, '新疆维吾尔自治区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (650100, 650000, '乌鲁木齐市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (650102, 650100, '天山区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (650103, 650100, '沙依巴克区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (650104, 650100, '新市区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (650105, 650100, '水磨沟区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (650106, 650100, '头屯河区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (650107, 650100, '达坂城区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (650109, 650100, '米东区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (650121, 650100, '乌鲁木齐县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (650200, 650000, '克拉玛依市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (650202, 650200, '独山子区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (650203, 650200, '克拉玛依区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (650204, 650200, '白碱滩区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (650205, 650200, '乌尔禾区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (650400, 650000, '吐鲁番市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (650402, 650400, '高昌区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (650421, 650400, '鄯善县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (650422, 650400, '托克逊县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (650500, 650000, '哈密市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (650502, 650500, '伊州区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (650521, 650500, '巴里坤哈萨克自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (650522, 650500, '伊吾县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (652300, 650000, '昌吉回族自治州', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (652301, 652300, '昌吉市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (652302, 652300, '阜康市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (652323, 652300, '呼图壁县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (652324, 652300, '玛纳斯县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (652325, 652300, '奇台县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (652327, 652300, '吉木萨尔县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (652328, 652300, '木垒哈萨克自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (652700, 650000, '博尔塔拉蒙古自治州', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (652701, 652700, '博乐市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (652702, 652700, '阿拉山口市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (652722, 652700, '精河县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (652723, 652700, '温泉县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (652800, 650000, '巴音郭楞蒙古自治州', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (652801, 652800, '库尔勒市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (652822, 652800, '轮台县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (652823, 652800, '尉犁县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (652824, 652800, '若羌县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (652825, 652800, '且末县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (652826, 652800, '焉耆回族自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (652827, 652800, '和静县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (652828, 652800, '和硕县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (652829, 652800, '博湖县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (652900, 650000, '阿克苏地区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (652901, 652900, '阿克苏市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (652922, 652900, '温宿县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (652923, 652900, '库车县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (652924, 652900, '沙雅县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (652925, 652900, '新和县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (652926, 652900, '拜城县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (652927, 652900, '乌什县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (652928, 652900, '阿瓦提县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (652929, 652900, '柯坪县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (653000, 650000, '克孜勒苏柯尔克孜自治州', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (653001, 653000, '阿图什市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (653022, 653000, '阿克陶县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (653023, 653000, '阿合奇县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (653024, 653000, '乌恰县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (653100, 650000, '喀什地区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (653101, 653100, '喀什市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (653121, 653100, '疏附县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (653122, 653100, '疏勒县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (653123, 653100, '英吉沙县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (653124, 653100, '泽普县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (653125, 653100, '莎车县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (653126, 653100, '叶城县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (653127, 653100, '麦盖提县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (653128, 653100, '岳普湖县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (653129, 653100, '伽师县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (653130, 653100, '巴楚县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (653131, 653100, '塔什库尔干塔吉克自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (653200, 650000, '和田地区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (653201, 653200, '和田市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (653221, 653200, '和田县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (653222, 653200, '墨玉县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (653223, 653200, '皮山县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (653224, 653200, '洛浦县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (653225, 653200, '策勒县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (653226, 653200, '于田县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (653227, 653200, '民丰县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (654000, 650000, '伊犁哈萨克自治州', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (654002, 654000, '伊宁市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (654003, 654000, '奎屯市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (654004, 654000, '霍尔果斯市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (654021, 654000, '伊宁县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (654022, 654000, '察布查尔锡伯自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (654023, 654000, '霍城县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (654024, 654000, '巩留县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (654025, 654000, '新源县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (654026, 654000, '昭苏县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (654027, 654000, '特克斯县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (654028, 654000, '尼勒克县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (654200, 650000, '塔城地区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (654201, 654200, '塔城市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (654202, 654200, '乌苏市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (654221, 654200, '额敏县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (654223, 654200, '沙湾县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (654224, 654200, '托里县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (654225, 654200, '裕民县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (654226, 654200, '和布克赛尔蒙古自治县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (654300, 650000, '阿勒泰地区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (654301, 654300, '阿勒泰市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (654321, 654300, '布尔津县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (654322, 654300, '富蕴县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (654323, 654300, '福海县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (654324, 654300, '哈巴河县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (654325, 654300, '青河县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (654326, 654300, '吉木乃县', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (659001, 650000, '石河子市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (659002, 650000, '阿拉尔市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (659003, 650000, '图木舒克市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (659004, 650000, '五家渠市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (659005, 650000, '北屯市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (659006, 650000, '铁门关市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (659007, 650000, '双河市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (659008, 650000, '可克达拉市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (659009, 650000, '昆玉市', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (710000, 0, '台湾省', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (810000, 0, '香港特别行政区', '2020-09-05 15:20:46', NULL);
INSERT INTO `cere_city_manage` VALUES (820000, 0, '澳门特别行政区', '2020-09-05 15:20:46', NULL);

-- ----------------------------
-- Table structure for cere_close_advert
-- ----------------------------
DROP TABLE IF EXISTS `cere_close_advert`;
CREATE TABLE `cere_close_advert`  (
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
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '关闭广告记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_collage_order
-- ----------------------------
DROP TABLE IF EXISTS `cere_collage_order`;
CREATE TABLE `cere_collage_order`  (
  `collage_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '拼团单id',
  `shop_group_work_id` bigint(20) NOT NULL COMMENT '拼团活动id',
  `state` tinyint(1) NOT NULL COMMENT '拼单状态，0-待成团，1-拼团成功，2-拼团失败',
  `collage_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '拼团名称',
  `buyer_user_id` bigint(20) NULL DEFAULT NULL COMMENT '发起人用户ID',
  `surplus_number` int(11) NULL DEFAULT NULL COMMENT '剩余人数',
  `create_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`collage_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 260 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '拼单信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_collage_order_detail
-- ----------------------------
DROP TABLE IF EXISTS `cere_collage_order_detail`;
CREATE TABLE `cere_collage_order_detail`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `collage_id` bigint(20) NOT NULL COMMENT '拼团单id',
  `order_id` bigint(20) NOT NULL COMMENT '订单id',
  `state` tinyint(1) NULL DEFAULT NULL COMMENT '状态   1-正常 0-失效订单',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_cere_collage_order_detail_order_id`(`order_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 289 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '拼单关联订单信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_comment_word
-- ----------------------------
DROP TABLE IF EXISTS `cere_comment_word`;
CREATE TABLE `cere_comment_word`  (
  `comment_id` bigint(20) NOT NULL COMMENT '评论id',
  `product_id` bigint(20) NOT NULL COMMENT '商品id',
  `word_id` bigint(20) NOT NULL COMMENT '关键词id',
  `key_word` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '关键词'
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '关键词关联评论信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_compose_product
-- ----------------------------
DROP TABLE IF EXISTS `cere_compose_product`;
CREATE TABLE `cere_compose_product`  (
  `compose_id` bigint(11) NOT NULL COMMENT '组合捆绑id',
  `product_id` bigint(11) NOT NULL COMMENT '商品id'
) ENGINE = InnoDB AUTO_INCREMENT = 68 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '商家组合捆绑商品信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_credit_record
-- ----------------------------
DROP TABLE IF EXISTS `cere_credit_record`;
CREATE TABLE `cere_credit_record`  (
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
) ENGINE = InnoDB AUTO_INCREMENT = 52 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '积分流水表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_credit_sign_setting
-- ----------------------------
DROP TABLE IF EXISTS `cere_credit_sign_setting`;
CREATE TABLE `cere_credit_sign_setting`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `day` int(11) NOT NULL DEFAULT 1 COMMENT '第几天',
  `credit` int(11) NOT NULL DEFAULT 0 COMMENT '赠送积分值',
  `display` int(11) NOT NULL DEFAULT 1 COMMENT '是否显示 1-是 0-否',
  `sort` int(11) NOT NULL DEFAULT 1 COMMENT '排序',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 12 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '积分签到配置' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_credit_signin_record
-- ----------------------------
DROP TABLE IF EXISTS `cere_credit_signin_record`;
CREATE TABLE `cere_credit_signin_record`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '签到id',
  `buyer_user_id` bigint(20) NOT NULL COMMENT '客户id',
  `term_id` int(11) NOT NULL DEFAULT 1 COMMENT '轮询id,第一天签到则为1，第2天签到则为2，连续签到值越来越大',
  `continue_day` int(11) NOT NULL DEFAULT 1 COMMENT '连续第几天签到',
  `credit` int(11) NOT NULL DEFAULT 10 COMMENT '奖励的积分',
  `create_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_buyer_user_id`(`buyer_user_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 43 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '积分签到表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_customer_service_config
-- ----------------------------
DROP TABLE IF EXISTS `cere_customer_service_config`;
CREATE TABLE `cere_customer_service_config`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `shop_id` bigint(20) NOT NULL COMMENT '店铺id',
  `create_time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '创建时间',
  `update_time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '更新时间',
  `permanent_code` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '永久授权码',
  `auth_corp_id` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '授权企业的id',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `idx_shop_id`(`shop_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '商家客服配置表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_distribution_order
-- ----------------------------
DROP TABLE IF EXISTS `cere_distribution_order`;
CREATE TABLE `cere_distribution_order`  (
  `order_id` bigint(20) NOT NULL COMMENT '关联订单id',
  `order_formid` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '订单编号',
  `distributor_id` bigint(20) NOT NULL COMMENT '关联分销员id',
  `distributor_name` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '分销员名称',
  `distributor_phone` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '分销员手机号',
  `price` decimal(15, 2) NOT NULL COMMENT '订单实付金额',
  `commission` decimal(15, 2) NOT NULL COMMENT '佣金',
  `state` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否结算 1-是 0-否',
  `transaction_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '交易时间',
  `type` tinyint(1) NOT NULL DEFAULT 1 COMMENT '佣金类型 1-直接佣金 2-间接佣金'
) ENGINE = InnoDB AUTO_INCREMENT = 40 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '分销员订单信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_distributor_buyer
-- ----------------------------
DROP TABLE IF EXISTS `cere_distributor_buyer`;
CREATE TABLE `cere_distributor_buyer`  (
  `shop_id` bigint(20) NOT NULL COMMENT '关联店铺id',
  `distributor_id` bigint(20) NOT NULL COMMENT '关联分销员id',
  `buyer_user_id` bigint(20) NOT NULL COMMENT '关联客户id',
  `if_bind` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否绑定 1-是 0-否',
  `update_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '关系更新时间'
) ENGINE = InnoDB AUTO_INCREMENT = 27 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '分销员绑定客户信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_label_attribute
-- ----------------------------
DROP TABLE IF EXISTS `cere_label_attribute`;
CREATE TABLE `cere_label_attribute`  (
  `label_id` bigint(20) NOT NULL COMMENT '关联标签id',
  `image` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '图片地址',
  `link` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '链接'
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '店铺标签属性表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_label_source
-- ----------------------------
DROP TABLE IF EXISTS `cere_label_source`;
CREATE TABLE `cere_label_source`  (
  `label_id` bigint(20) NOT NULL COMMENT '店铺标签id',
  `label_type` tinyint(1) NULL DEFAULT NULL COMMENT '素材类型 1-图片 2-视频',
  `image` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '图片地址',
  `link` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '链接'
) ENGINE = InnoDB AUTO_INCREMENT = 80 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '店铺素材信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_live
-- ----------------------------
DROP TABLE IF EXISTS `cere_live`;
CREATE TABLE `cere_live`  (
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
) ENGINE = InnoDB AUTO_INCREMENT = 60 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '直播表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_live_examine
-- ----------------------------
DROP TABLE IF EXISTS `cere_live_examine`;
CREATE TABLE `cere_live_examine`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `live_id` bigint(20) NOT NULL COMMENT '直播间id',
  `re_examine_date` date NOT NULL COMMENT '重新审核日期',
  `create_time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '创建时间',
  `update_time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '更新时间',
  INDEX `id`(`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 18 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '直播间重新审核表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_live_product
-- ----------------------------
DROP TABLE IF EXISTS `cere_live_product`;
CREATE TABLE `cere_live_product`  (
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
) ENGINE = InnoDB AUTO_INCREMENT = 1474328158890135565 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '直播间商品表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_live_product_examine
-- ----------------------------
DROP TABLE IF EXISTS `cere_live_product_examine`;
CREATE TABLE `cere_live_product_examine`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `live_product_id` bigint(20) NOT NULL COMMENT '直播商品id',
  `re_examine_date` date NOT NULL COMMENT '重新审核日期',
  `create_time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '创建时间',
  `update_time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '更新时间',
  INDEX `id`(`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '直播间商品重新审核表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_live_product_rel
-- ----------------------------
DROP TABLE IF EXISTS `cere_live_product_rel`;
CREATE TABLE `cere_live_product_rel`  (
  `live_id` bigint(20) NOT NULL COMMENT '直播间id',
  `live_product_id` bigint(20) NOT NULL COMMENT '直播间商品id, 关联cere_live_product的id',
  `create_time` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '创建时间',
  `update_time` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '修改时间',
  PRIMARY KEY (`live_id`, `live_product_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '直播间和直播间商品的关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_live_sale_stat
-- ----------------------------
DROP TABLE IF EXISTS `cere_live_sale_stat`;
CREATE TABLE `cere_live_sale_stat`  (
  `product_id` bigint(20) NOT NULL COMMENT '商品id',
  `sale_number` int(11) NOT NULL DEFAULT 0 COMMENT '直播销量',
  `sale_amount` decimal(10, 2) NOT NULL COMMENT '直播销售额',
  PRIMARY KEY (`product_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '直播商品销售统计' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_live_subscribe
-- ----------------------------
DROP TABLE IF EXISTS `cere_live_subscribe`;
CREATE TABLE `cere_live_subscribe`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `live_id` bigint(20) NOT NULL COMMENT '直播间id',
  `buyer_user_id` bigint(20) NOT NULL COMMENT '用户id',
  `create_time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '创建时间',
  `update_time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '直播订阅表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_logistics_charge
-- ----------------------------
DROP TABLE IF EXISTS `cere_logistics_charge`;
CREATE TABLE `cere_logistics_charge`  (
  `logistics_id` bigint(20) NOT NULL COMMENT '关联物流方案id',
  `region` text CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '配送区域 省-市',
  `weight` decimal(5, 2) NULL DEFAULT NULL COMMENT '首重 多少KG/件',
  `price` decimal(15, 2) NULL DEFAULT NULL COMMENT '首重价格',
  `second_weight` decimal(5, 2) NULL DEFAULT NULL COMMENT '续重',
  `second_price` decimal(15, 2) NULL DEFAULT NULL COMMENT '续重价格'
) ENGINE = InnoDB AUTO_INCREMENT = 18 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '物流计费明细信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of cere_logistics_charge
-- ----------------------------
INSERT INTO `cere_logistics_charge` VALUES (43, '北京市;天津市;河北省;山西省;内蒙古自治区;辽宁省;吉林省;黑龙江省;上海市;江苏省;浙江省;安徽省;福建省;江西省;山东省;河南省;湖北省;湖南省;广东省;广西壮族自治区;海南省;重庆市;四川省;贵州省;云南省;西藏自治区;陕西省;甘肃省;青海省;宁夏回族自治区;新疆维吾尔自治区;台湾省;香港特别行政区;澳门特别行政区', 0.00, 0.00, 0.00, 0.00);

-- ----------------------------
-- Table structure for cere_member_signin_record
-- ----------------------------
DROP TABLE IF EXISTS `cere_member_signin_record`;
CREATE TABLE `cere_member_signin_record`  (
  `signin_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '签到id',
  `buyer_user_id` bigint(20) NOT NULL COMMENT '客户id',
  `term_id` int(11) NOT NULL DEFAULT 1 COMMENT '轮询id,第一天签到则为1，第2天签到则为2，到7之后，从1重新开始',
  `growth` int(11) NOT NULL DEFAULT 10 COMMENT '奖励的成长值',
  `create_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`signin_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 182 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '会员签到表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_message_log
-- ----------------------------
DROP TABLE IF EXISTS `cere_message_log`;
CREATE TABLE `cere_message_log`  (
  `message_id` bigint(20) NOT NULL COMMENT '关联短信id',
  `template` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '短信模板编号',
  `phone` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '接收者',
  `subject` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '主体',
  `message` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '发送内容',
  `state` tinyint(1) NOT NULL DEFAULT 1 COMMENT '执行状态 1-执行成功 2-执行失败',
  `create_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建时间'
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '短信发送记录信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_notice
-- ----------------------------
DROP TABLE IF EXISTS `cere_notice`;
CREATE TABLE `cere_notice`  (
  `notice_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '消息id',
  `notice_type` tinyint(1) NOT NULL COMMENT '消息类型 1-系统消息（系统自动发送） 2-公告（后台录入） 3-站内信',
  `jump` tinyint(1) NULL DEFAULT NULL COMMENT '跳转类型 1-商品详情 2-订单详情',
  `receive` tinyint(1) NULL DEFAULT 1 COMMENT '接收用户类型 1-全部用户 2-商家 3-普通用户',
  `if_read` tinyint(1) NULL DEFAULT NULL COMMENT '是否读取 1-是 0-否',
  `buyer_user_id` bigint(20) NULL DEFAULT NULL COMMENT '客户id',
  `shop_id` bigint(20) NULL DEFAULT NULL COMMENT '店铺id',
  `notice_title` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '消息标题',
  `notice_content` longtext CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '消息内容',
  `only` bigint(20) NULL DEFAULT NULL COMMENT '跳转详情唯一标识',
  `image` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '图片',
  `create_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`notice_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3122 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '系统消息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_order_after
-- ----------------------------
DROP TABLE IF EXISTS `cere_order_after`;
CREATE TABLE `cere_order_after`  (
  `after_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '售后单id',
  `order_id` bigint(20) NOT NULL COMMENT '关联订单id',
  `after_formid` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '售后单号',
  `after_state` tinyint(4) NOT NULL DEFAULT 1 COMMENT '售后状态 1-审核中 2-退款中 3-退货中 4-退款成功 5-退款失败 6-审核不通过 7-评审中 8-退货完成，拒绝退款 9-已关闭 10-审核通过',
  `goods_state` tinyint(1) NULL DEFAULT NULL COMMENT '（货物状态）是否收到货 1-是 0-否',
  `after_type` tinyint(1) NOT NULL DEFAULT 1 COMMENT '售后类型  1-仅退款  2-退货退款',
  `price` decimal(15, 2) NOT NULL COMMENT '退款金额',
  `explain` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '买家说明',
  `return_reason` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '售后原因',
  `remark` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `reason` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '商家处理留言',
  `image` varchar(1000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '图片地址（多个以逗号隔开）',
  `create_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`after_id`) USING BTREE,
  INDEX `idx_cere_order_after_order_id`(`order_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 286 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '售后单信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_order_dilever
-- ----------------------------
DROP TABLE IF EXISTS `cere_order_dilever`;
CREATE TABLE `cere_order_dilever`  (
  `order_id` bigint(20) NOT NULL COMMENT '关联订单id',
  `express` bigint(20) NOT NULL COMMENT '快递公司（取数据字典）',
  `deliver_formid` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '快递单号',
  `create_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新时间',
  INDEX `idx_cere_order_dilever_order_id`(`order_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 69 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '订单发货信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_order_logistics
-- ----------------------------
DROP TABLE IF EXISTS `cere_order_logistics`;
CREATE TABLE `cere_order_logistics`  (
  `logistics_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '物流方案id',
  `shop_id` bigint(20) NOT NULL COMMENT '店铺id',
  `logistics_name` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '方案名称',
  `charge_type` tinyint(1) NOT NULL DEFAULT 1 COMMENT '计费方式 1-按件数 2-按重量 3-全国包邮',
  `create_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`logistics_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 44 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '物流方案设置信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of cere_order_logistics
-- ----------------------------
INSERT INTO `cere_order_logistics` VALUES (43, 155, '包邮', 3, '2023-10-29 09:37:34', NULL);

-- ----------------------------
-- Table structure for cere_order_parent
-- ----------------------------
DROP TABLE IF EXISTS `cere_order_parent`;
CREATE TABLE `cere_order_parent`  (
  `parent_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '父订单id',
  `parent_formid` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '父订单编号',
  `order_price` decimal(15, 2) NOT NULL COMMENT '所有子订单总价之和',
  `logistics_price` decimal(15, 2) NULL DEFAULT NULL COMMENT '所有子订单物流费用之和',
  `price` decimal(15, 2) NOT NULL COMMENT '所有子订单支付金额之和',
  `create_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`parent_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2545 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '父订单信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_order_product
-- ----------------------------
DROP TABLE IF EXISTS `cere_order_product`;
CREATE TABLE `cere_order_product`  (
  `order_product_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '订单商品明细id',
  `order_id` bigint(20) NOT NULL COMMENT '关联订单id',
  `product_id` bigint(20) NOT NULL COMMENT '关联商品id',
  `sku_id` bigint(20) NOT NULL COMMENT '关联规格id',
  `product_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '商品名称',
  `number` int(11) NOT NULL COMMENT '购买数量',
  `product_price` decimal(15, 2) NOT NULL COMMENT '商品售价',
  `actual_price` decimal(15, 6) NOT NULL DEFAULT 0.000000 COMMENT '该sku实际总支付价格，不算运费和积分',
  `image` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '图片地址',
  `SKU` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'SKU',
  `weight` decimal(15, 2) NULL DEFAULT NULL COMMENT '重量',
  `type` tinyint(1) NULL DEFAULT NULL COMMENT '所属订单类型  1-常规订单 2-赠品营销子订单',
  `write_number` int(10) NULL DEFAULT NULL COMMENT '已核销数量',
  `write_code` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '核销码地址',
  `activity_type` int(11) NOT NULL DEFAULT 0 COMMENT '商品活动类型 参考IntegerEnum.ACTIVITY_TYPE_XXX',
  `activity_id` bigint(20) NULL DEFAULT NULL COMMENT '活动id',
  `use_credit` int(11) NOT NULL DEFAULT 0 COMMENT '该sku抵扣的积分',
  `use_credit_amount` decimal(15, 2) NOT NULL DEFAULT 0.00 COMMENT '该sku积分抵扣的金额',
  `logistics_price` decimal(15, 4) NOT NULL DEFAULT 0.0000 COMMENT '运费',
  PRIMARY KEY (`order_product_id`) USING BTREE,
  INDEX `index`(`sku_id`) USING BTREE,
  INDEX `idx_cere_order_product_order_id`(`order_id`) USING BTREE,
  INDEX `idx_product_id`(`product_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2729 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '订单商品信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_order_product_attribute
-- ----------------------------
DROP TABLE IF EXISTS `cere_order_product_attribute`;
CREATE TABLE `cere_order_product_attribute`  (
  `order_product_id` bigint(20) NOT NULL COMMENT '关联订单商品明细id',
  `sku_name` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '规格名',
  `sku_value` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '规格值',
  `name_code` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '规格名级别',
  `value_code` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '规格值级别'
) ENGINE = InnoDB AUTO_INCREMENT = 1330 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '订单商品属性表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_order_reconciliation
-- ----------------------------
DROP TABLE IF EXISTS `cere_order_reconciliation`;
CREATE TABLE `cere_order_reconciliation`  (
  `reconciliation_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '对账单id',
  `order_id` bigint(20) NOT NULL COMMENT '关联订单id',
  `money` decimal(15, 2) NOT NULL COMMENT '金额',
  `state` tinyint(1) NOT NULL DEFAULT 1 COMMENT '状态  1-冻结 2-解冻',
  `type` tinyint(1) NOT NULL DEFAULT 1 COMMENT '收支状态 1-收入(付款) 2-支出（退款）',
  `create_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`reconciliation_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 943 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '订单对账单信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_order_return
-- ----------------------------
DROP TABLE IF EXISTS `cere_order_return`;
CREATE TABLE `cere_order_return`  (
  `return_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '退货单id',
  `return_formid` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '退货单号',
  `order_id` bigint(20) NOT NULL COMMENT '关联订单id',
  `create_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`return_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '退货单信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_pay_log
-- ----------------------------
DROP TABLE IF EXISTS `cere_pay_log`;
CREATE TABLE `cere_pay_log`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `shop_id` bigint(20) NOT NULL COMMENT '关联店铺id',
  `order_formid` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '关联订单编号',
  `out_trade_no` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '订单支付编号',
  `transaction_id` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '支付生成的订单号',
  `out_refund_no` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '商户系统内部的退款单号,商户系统内部唯一，只能是数字、大小写字母_-|*@ ，同一退款单号多次请求只退一笔。退货流水号',
  `total_fee` decimal(15, 2) NULL DEFAULT NULL COMMENT '订单总金额',
  `refund_fee` decimal(15, 2) NULL DEFAULT NULL COMMENT '退款总金额，订单总金额，单位为分',
  `user_id` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '支付或退款用户ID',
  `state` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '支付、退款、提现',
  `remark` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `payment_mode` tinyint(1) NULL DEFAULT 1 COMMENT '支付方式 1-微信 2-支付宝',
  `after` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '售后单id,多个以逗号隔开（多次退款使用）',
  `create_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_cere_pay_log_order_formid`(`order_formid`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1469996391463743529 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '支付日志信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_platform_activity
-- ----------------------------
DROP TABLE IF EXISTS `cere_platform_activity`;
CREATE TABLE `cere_platform_activity`  (
  `activity_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '活动id',
  `activity_name` varchar(60) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '优惠券活动名称',
  `activity_introduce` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `sign_start_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '报名开始时间',
  `sign_end_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '报名结束时间',
  `activity_start_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '活动开始时间',
  `activity_end_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '活动结束时间',
  `if_bond` tinyint(1) NULL DEFAULT 1 COMMENT '是否需要保证金  1-是 0-否',
  `bond_money` decimal(15, 2) NULL DEFAULT NULL COMMENT '保证金金额',
  `threshold` decimal(15, 2) NOT NULL COMMENT '使用门槛满多少元，无门槛为0',
  `discount_mode` tinyint(1) NULL DEFAULT 1 COMMENT '优惠券类型 1-满减 2-折扣',
  `coupon_content` decimal(15, 2) NOT NULL COMMENT '优惠内容减多少元/打多少折',
  `number` int(11) NULL DEFAULT NULL COMMENT '发放数量',
  `stock_number` int(11) NULL DEFAULT NULL COMMENT '库存数量',
  `receive_type` tinyint(1) NOT NULL COMMENT '每人限领次数  1-无限次 2-限制几次',
  `frequency` int(11) NULL DEFAULT NULL COMMENT '限制次数',
  `image` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '图片地址',
  `if_credit` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否开启积分兑换 1-是 0-否',
  `credit` int(11) NOT NULL DEFAULT 0 COMMENT '兑换所需积分',
  `apply_type` int(11) NOT NULL DEFAULT 1 COMMENT '可用范围 1-全部 2-选择类别',
  `apply_category` bigint(20) NULL DEFAULT NULL COMMENT '可用类别',
  `sync_card` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否同步微信卡券 1-同步 0-不同步',
  `card_title` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '卡券标题',
  `card_color` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '卡券主题色',
  `card_notice` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '卡券使用须知',
  `card_id` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '关联的微信卡券id',
  `state` tinyint(1) NULL DEFAULT 0 COMMENT '活动状态  0-报名未开始 1-报名进行中 2-活动待开始 3-活动进行中 4-活动已结束',
  `create_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`activity_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 58 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '平台优惠券活动信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_platform_activity_detail
-- ----------------------------
DROP TABLE IF EXISTS `cere_platform_activity_detail`;
CREATE TABLE `cere_platform_activity_detail`  (
  `coupon_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '优惠券id',
  `activity_id` bigint(20) NOT NULL COMMENT '关联营销活动id',
  `full_money` decimal(15, 2) NOT NULL COMMENT '满多少元',
  `reduce_money` decimal(15, 2) NOT NULL COMMENT '减多少元',
  PRIMARY KEY (`coupon_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '营销活动优惠方案明细信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_platform_after
-- ----------------------------
DROP TABLE IF EXISTS `cere_platform_after`;
CREATE TABLE `cere_platform_after`  (
  `order_id` bigint(20) NOT NULL COMMENT '关联订单id',
  `reason` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '问题描述',
  `image` varchar(1000) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '举证图片',
  `remark` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '处理备注',
  `state` tinyint(1) NULL DEFAULT 0 COMMENT '处理状态 0-未处理 1-同意 2-拒绝',
  `create_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建时间',
  `handle_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '平台处理时间'
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '平台介入售后信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_platform_business
-- ----------------------------
DROP TABLE IF EXISTS `cere_platform_business`;
CREATE TABLE `cere_platform_business`  (
  `business_user_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '商家用户id',
  `username` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '商家登录账号',
  `password` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '商家登录密码',
  `name` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '商家昵称',
  `sex` varchar(2) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '商家性别',
  `avatar` varchar(256) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '头像',
  `phone` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '手机号',
  `email` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '商家邮箱',
  `token` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '商家用户token',
  `state` tinyint(1) NULL DEFAULT NULL COMMENT '是否启用 1-是 0-否',
  `create_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`business_user_id`) USING BTREE,
  UNIQUE INDEX `uqe_idx_phone`(`phone`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 211 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '平台商家用户表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of cere_platform_business
-- ----------------------------
INSERT INTO `cere_platform_business` VALUES (210, '15738051864', '5f39GmYmX2gTALaf3BjzWA==', '商家', NULL, NULL, '15738051864', NULL, NULL, 1, '2023-10-29 09:32:21', NULL);

-- ----------------------------
-- Table structure for cere_platform_canvas
-- ----------------------------
DROP TABLE IF EXISTS `cere_platform_canvas`;
CREATE TABLE `cere_platform_canvas`  (
  `canvas_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '画布id',
  `terminal` tinyint(1) NOT NULL COMMENT '终端 1-小程序 2-H5 3-APP 4-PC',
  `json` longtext CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '画布json数据',
  `type` tinyint(1) NOT NULL DEFAULT 1 COMMENT '类型 1-系统画布 2-自定义页面 3-商家店铺装修',
  `name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '名称',
  `shop_id` bigint(20) NOT NULL DEFAULT 0 COMMENT '店铺id，当type=3的时候，值为具体的店铺id，其它情况为0',
  `custom_id` bigint(20) NULL DEFAULT 0 COMMENT '自定义页面id，当type=2时，值为自定义页面对应的id，其它情况为0',
  `create_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`canvas_id`) USING BTREE,
  UNIQUE INDEX `uk_terminal_type`(`shop_id`, `terminal`, `type`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 45 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '画布信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_platform_canvas_custom
-- ----------------------------
DROP TABLE IF EXISTS `cere_platform_canvas_custom`;
CREATE TABLE `cere_platform_canvas_custom`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '名称',
  `create_time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '自定义页面信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_platform_collection
-- ----------------------------
DROP TABLE IF EXISTS `cere_platform_collection`;
CREATE TABLE `cere_platform_collection`  (
  `id` bigint(11) NOT NULL AUTO_INCREMENT,
  `collection_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '平台收款码地址',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '平台收款码信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_platform_dict
-- ----------------------------
DROP TABLE IF EXISTS `cere_platform_dict`;
CREATE TABLE `cere_platform_dict`  (
  `dict_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '字典id',
  `dict_pid` bigint(20) NOT NULL COMMENT '父节点id',
  `dict_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '字典名称',
  `dict_describe` mediumtext CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '字典描述',
  `create_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`dict_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2376 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '数据字典信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of cere_platform_dict
-- ----------------------------
INSERT INTO `cere_platform_dict` VALUES (1, 0, '所属银行', '银行列表', '2020-11-21 01:07:46', '2020-11-23 23:18:07');
INSERT INTO `cere_platform_dict` VALUES (5, 0, '证件类型', '证件', '2020-11-20 06:38:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (6, 5, '身份证', '身份证', '2020-11-17 17:54:46', '2020-11-23 23:17:49');
INSERT INTO `cere_platform_dict` VALUES (7, 0, '快递100所属快递公司', '快递100', '2020-11-17 21:16:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (8, 0, '快递鸟所属快递公司', '快递鸟', '2020-11-19 05:39:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (117, 7, '韵达快递', 'yunda', '2020-11-18 14:45:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (118, 7, '顺丰速运', 'shunfeng', '2020-11-18 09:50:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (119, 7, '中通快递', 'zhongtong', '2020-11-19 05:54:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (120, 7, '邮政快递包裹', 'youzhengguonei', '2020-11-17 02:20:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (121, 7, '百世快递', 'huitongkuaidi', '2020-11-17 17:36:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (122, 7, '申通快递', 'shentong', '2020-11-20 10:03:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (123, 7, '京东物流', 'jd', '2020-11-18 01:07:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (124, 7, 'EMS', 'ems', '2020-11-18 23:06:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (125, 7, '天天快递', 'tiantian', '2020-11-23 17:08:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (126, 7, '极兔速递', 'jtexpress', '2020-11-23 21:23:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (127, 7, '邮政标准快递', 'youzhengbk', '2020-11-17 11:13:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (128, 7, '德邦', 'debangwuliu', '2020-11-19 12:53:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (129, 7, '苏宁物流', 'suning', '2020-11-21 09:06:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (130, 7, '德邦快递', 'debangkuaidi', '2020-11-17 10:33:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (131, 7, '宅急送', 'zhaijisong', '2020-11-19 23:47:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (132, 7, '众邮快递', 'zhongyouex', '2020-11-23 17:37:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (133, 7, '百世快运', 'baishiwuliu', '2020-11-20 21:42:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (134, 7, '优速快递', 'youshuwuliu', '2020-11-23 07:21:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (135, 7, '韵达快运', 'yundakuaiyun', '2020-11-22 23:17:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (136, 7, '圆通快运', 'yuantongkuaiyun', '2020-11-21 00:44:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (137, 7, '安能快运', 'annengwuliu', '2020-11-19 06:49:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (138, 7, '中通快运', 'zhongtongkuaiyun', '2020-11-23 07:34:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (139, 7, '中通国际', 'zhongtongguoji', '2020-11-20 22:20:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (140, 7, '国际包裹', 'youzhengguoji', '2020-11-17 18:01:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (141, 7, 'DHL-全球件', 'dhlen', '2020-11-22 21:23:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (142, 7, '特急送', 'lntjs', '2020-11-23 09:52:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (143, 7, '跨越速运', 'kuayue', '2020-11-17 12:50:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (144, 7, '安得物流', 'annto', '2020-11-21 07:37:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (145, 7, 'UPS-全球件', 'upsen', '2020-11-23 03:12:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (146, 7, '壹米滴答', 'yimidida', '2020-11-20 20:49:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (147, 7, 'FedEx-国际件', 'fedex', '2020-11-17 23:31:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (148, 7, '丹鸟', 'danniao', '2020-11-17 06:46:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (149, 7, 'DHL-中国件', 'dhl', '2020-11-22 11:00:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (150, 7, '速尔快递', 'suer', '2020-11-22 15:39:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (151, 7, '同城快寄', 'shpost', '2020-11-21 23:38:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (152, 7, 'EWE全球快递', 'ewe', '2020-11-18 01:31:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (153, 7, '日日顺物流', 'rrs', '2020-11-21 07:03:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (154, 7, 'USPS', 'usps', '2020-11-21 10:21:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (155, 7, '联昊通', 'lianhaowuliu', '2020-11-19 08:55:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (156, 7, 'EMS-国际件', 'emsguoji', '2020-11-22 13:11:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (157, 7, '九曳供应链', 'jiuyescm', '2020-11-23 18:52:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (158, 7, '芝麻开门', 'zhimakaimen', '2020-11-20 10:27:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (159, 7, 'UPS', 'ups', '2020-11-20 19:17:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (160, 7, '联合快递', 'gslhkd', '2020-11-18 19:27:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (161, 7, '微特派', 'weitepai', '2020-11-21 15:03:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (162, 7, '顺心捷达', 'sxjdfreight', '2020-11-20 20:32:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (163, 7, '优邦速运', 'ubonex', '2020-11-22 10:31:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (164, 7, '快捷速递', 'kuaijiesudi', '2020-11-18 18:39:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (165, 7, '国通快递', 'guotongkuaidi', '2020-11-23 12:03:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (166, 7, '龙邦速递', 'longbanwuliu', '2020-11-23 09:17:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (167, 7, '递四方', 'disifang', '2020-11-22 12:35:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (168, 7, '美快国际物流', 'meiquick', '2020-11-18 13:26:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (169, 7, '信丰物流', 'xinfengwuliu', '2020-11-22 03:46:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (170, 7, '新顺丰（NSF）', 'nsf', '2020-11-17 07:33:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (171, 7, '中铁快运', 'ztky', '2020-11-17 00:44:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (172, 7, '澳大利亚(Australia Post)', 'auspost', '2020-11-23 04:42:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (173, 7, '宇鑫物流', 'yuxinwuliu', '2020-11-20 03:40:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (174, 7, '京广速递', 'jinguangsudikuaijian', '2020-11-21 03:52:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (175, 7, '澳邮中国快运', 'auexpress', '2020-11-21 10:40:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (176, 7, '邦泰快运', 'btexpress', '2020-11-19 20:05:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (177, 7, 'D速快递', 'dsukuaidi', '2020-11-17 21:25:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (178, 7, '圆通国际', 'yuantongguoji', '2020-11-19 22:30:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (179, 7, '大马鹿', 'idamalu', '2020-11-22 02:33:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (180, 7, '顺丰快运', 'shunfengkuaiyun', '2020-11-19 20:55:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (181, 7, '日本（Japan Post）', 'japanposten', '2020-11-23 00:37:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (182, 7, '澳洲飞跃物流', 'rlgaus', '2020-11-17 17:22:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (183, 7, '中邮物流', 'zhongyouwuliu', '2020-11-23 09:57:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (184, 7, 'YUN TRACK', 'yuntrack', '2020-11-19 03:58:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (185, 7, 'Austa国际速递', 'austa', '2020-11-22 12:20:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (186, 7, 'Xlobo贝海国际', 'xlobo', '2020-11-17 06:47:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (187, 7, '速必达', 'subida', '2020-11-22 17:54:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (188, 7, '运通速运', 'yuntong', '2020-11-17 03:28:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (189, 7, '卓志速运', 'chinaicip', '2020-11-21 08:38:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (190, 7, '顺达快递', 'sundarexpress', '2020-11-17 13:47:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (191, 7, 'TNT', 'tnt', '2020-11-20 17:21:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (192, 7, '联邦快递', 'lianbangkuaidi', '2020-11-20 01:03:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (193, 7, '转运四方', 'zhuanyunsifang', '2020-11-21 02:14:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (194, 7, '转运中国', 'uszcn', '2020-11-21 10:19:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (195, 7, '海信物流', 'savor', '2020-11-19 23:13:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (196, 7, '全峰快递', 'quanfengkuaidi', '2020-11-18 14:10:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (197, 7, '申通国际', 'stosolution', '2020-11-23 00:51:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (198, 7, '泛捷国际速递', 'epanex', '2020-11-21 14:46:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (199, 7, '中邮速递', 'wondersyd', '2020-11-22 00:15:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (200, 7, '安能快递', 'ane66', '2020-11-21 07:19:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (201, 7, '程光快递', 'flyway', '2020-11-23 12:49:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (202, 7, '如风达', 'rufengda', '2020-11-22 21:48:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (203, 7, 'Fedex-国际件-中文', 'fedexcn', '2020-11-20 00:54:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (204, 7, '鑫正一快递', 'zhengyikuaidi', '2020-11-21 10:43:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (205, 7, '天马迅达', 'tianma', '2020-11-23 05:16:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (206, 7, '加运美', 'jiayunmeiwuliu', '2020-11-20 21:50:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (207, 7, '速达通', 'sdto', '2020-11-17 22:21:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (208, 7, '天地华宇', 'tiandihuayu', '2020-11-23 20:36:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (209, 7, '中远e环球', 'cosco', '2020-11-20 18:18:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (210, 7, '汇森速运', 'huisenky', '2020-11-22 05:20:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (211, 7, 'EMS包裹', 'emsbg', '2020-11-17 23:28:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (212, 7, '金岸物流', 'jinan', '2020-11-20 03:37:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (213, 7, 'TNT-全球件', 'tnten', '2020-11-22 22:03:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (214, 7, 'Superb Grace', 'superb', '2020-11-23 07:06:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (215, 7, '增益速递', 'zengyisudi', '2020-11-23 19:38:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (216, 7, '安迅物流', 'anxl', '2020-11-18 08:34:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (217, 7, '疯狂快递', 'crazyexpress', '2020-11-17 06:16:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (218, 7, '方舟速递', 'arkexpress', '2020-11-21 05:16:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (219, 7, 'EMS-国际件-英文', 'emsinten', '2020-11-23 11:13:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (220, 7, '富腾达国际货运', 'ftd', '2020-11-22 19:55:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (221, 7, '平安达腾飞', 'pingandatengfei', '2020-11-19 20:19:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (222, 7, '广东邮政', 'guangdongyouzhengwuliu', '2020-11-20 17:29:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (223, 7, '广东速腾物流', 'suteng', '2020-11-20 04:49:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (224, 7, '新西兰（New Zealand Post）', 'newzealand', '2020-11-21 20:38:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (225, 7, 'DPD', 'dpd', '2020-11-17 20:20:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (226, 7, '燕文物流', 'yw56', '2020-11-20 14:09:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (227, 7, 'Aramex', 'aramex', '2020-11-18 13:26:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (228, 7, '鼎润物流', 'la911', '2020-11-21 00:20:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (229, 7, '比利时（Bpost）', 'bpost', '2020-11-18 13:03:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (230, 7, '斑马物流', 'banma', '2020-11-19 15:55:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (231, 7, '盛辉物流', 'shenghuiwuliu', '2020-11-18 18:48:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (232, 7, 'DHL-德国件（DHL Deutschland）', 'dhlde', '2020-11-17 23:12:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (233, 7, '中环快递', 'zhonghuan', '2020-11-23 11:17:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (234, 7, '新杰物流', 'sunjex', '2020-11-18 17:10:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (235, 7, '龙邦物流', 'lbex', '2020-11-20 02:17:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (236, 7, '速通物流', 'sut56', '2020-11-20 10:17:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (237, 7, '嘉里大通', 'jialidatong', '2020-11-17 22:52:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (238, 7, '联合速运', 'unitedex', '2020-11-18 11:10:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (239, 7, 'OCS', 'ocs', '2020-11-21 12:14:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (240, 7, '极地快递', 'polarexpress', '2020-11-21 07:21:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (241, 7, '叁虎物流', 'sanhuwuliu', '2020-11-18 02:21:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (242, 7, '安达速递', 'adapost', '2020-11-23 12:02:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (243, 7, '中铁飞豹', 'zhongtiewuliu', '2020-11-18 11:28:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (244, 7, '盛丰物流', 'sfwl', '2020-11-18 19:33:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (245, 7, '富吉速运', 'fujisuyun', '2020-11-21 16:22:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (246, 7, '澳天速运', 'aotsd', '2020-11-21 02:49:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (247, 7, '长江国际速递', 'changjiang', '2020-11-23 13:58:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (248, 7, '恒路物流', 'hengluwuliu', '2020-11-23 17:05:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (249, 7, '联邦快递-英文', 'lianbangkuaidien', '2020-11-16 23:11:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (250, 7, '德坤物流', 'dekuncn', '2020-11-17 13:38:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (251, 7, '环球速运', 'huanqiu', '2020-11-19 23:39:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (252, 7, '万象物流', 'wanxiangwuliu', '2020-11-23 07:42:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (253, 7, '中国香港(HongKong Post)', 'hkpost', '2020-11-18 20:32:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (254, 7, 'AAE-中国件', 'aae', '2020-11-21 05:53:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (255, 7, '一速递', 'oneexpress', '2020-11-18 19:31:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (256, 7, 'CJ物流', 'doortodoor', '2020-11-20 07:36:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (257, 7, '百福东方', 'baifudongfang', '2020-11-21 05:48:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (258, 7, '美国申通', 'stoexpress', '2020-11-21 08:29:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (259, 7, '宅急便', 'zhaijibian', '2020-11-19 03:23:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (260, 7, '优优速递', 'youyou', '2020-11-21 15:08:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (261, 7, '佳怡物流', 'jiayiwuliu', '2020-11-19 21:11:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (262, 7, 'TST速运通', 'tstexp', '2020-11-17 13:31:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (263, 7, 'COE', 'coe', '2020-11-18 03:43:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (264, 7, '源安达', 'yuananda', '2020-11-21 03:00:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (265, 7, '景顺物流', 'jingshun', '2020-11-20 07:33:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (266, 7, '易达通快递', 'qexpress', '2020-11-21 05:43:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (267, 7, '集先锋快递', 'jxfex', '2020-11-21 08:17:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (268, 7, '达发物流', 'dfwl', '2020-11-19 02:37:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (269, 7, '万家物流', 'wanjiawuliu', '2020-11-21 11:55:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (270, 7, '聚盟共建', 'jumstc', '2020-11-19 07:21:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (271, 7, '7号速递', 'express7th', '2020-11-22 00:42:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (272, 7, '澳德物流', 'auod', '2020-11-21 09:08:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (273, 7, 'EMS-英文', 'emsen', '2020-11-23 20:32:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (274, 7, '中速快递', 'zhongsukuaidi', '2020-11-17 08:18:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (275, 7, '大田物流', 'datianwuliu', '2020-11-19 00:51:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (276, 7, '上海缤纷物流', 'bflg', '2020-11-19 05:43:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (277, 7, '中翼国际物流', 'chnexp', '2020-11-22 03:00:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (278, 7, '速递中国', 'sendtochina', '2020-11-22 01:34:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (279, 7, '新元国际', 'xynyc', '2020-11-20 01:09:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (280, 7, '出口易', 'chukou1', '2020-11-17 02:04:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (281, 7, '易境达国际物流', 'uscbexpress', '2020-11-22 05:11:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (282, 7, '亚马逊中国', 'yamaxunwuliu', '2020-11-22 00:43:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (283, 7, '苏通快运', 'zjstky', '2020-11-19 14:25:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (284, 7, '快捷快物流', 'gdkjk56', '2020-11-21 21:32:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (285, 7, '南方传媒物流', 'ndwl', '2020-11-19 20:07:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (286, 7, '美通', 'valueway', '2020-11-23 11:41:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (287, 7, '全联速运', 'guexp', '2020-11-20 03:00:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (288, 7, 'Highsince', 'highsince', '2020-11-20 03:40:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (289, 7, '迅达速递', 'xdexpress', '2020-11-23 10:20:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (290, 7, '百事亨通', 'bsht', '2020-11-18 21:39:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (291, 7, '海带宝', 'haidaibao', '2020-11-21 03:34:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (292, 7, '洋包裹', 'yangbaoguo', '2020-11-18 04:33:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (293, 7, '佐川急便', 'sagawa', '2020-11-17 11:45:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (294, 7, '龙枫国际快递', 'lfexpress', '2020-11-22 20:43:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (295, 7, '皮牙子快递', 'bazirim', '2020-11-17 02:41:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (296, 7, '时达通', 'jssdt56', '2020-11-20 20:17:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (297, 7, '黄马甲', 'huangmajia', '2020-11-22 01:03:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (298, 7, '德国(Deutsche Post)', 'deutschepost', '2020-11-23 18:41:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (299, 7, '城晓国际快递', 'ckeex', '2020-11-21 21:59:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (300, 7, 'TNT Australia', 'tntau', '2020-11-21 06:51:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (301, 7, '速派快递', 'fastgoexpress', '2020-11-23 17:20:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (302, 7, '铁中快运', 'tzky', '2020-11-16 23:04:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (303, 7, '签收快递', 'signedexpress', '2020-11-17 12:20:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (304, 7, '加拿大(Canada Post)', 'canpost', '2020-11-19 17:31:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (305, 7, '耀飞同城快递', 'yaofeikuaidi', '2020-11-22 04:52:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (306, 7, '英国大包、EMS（Parcel Force）', 'parcelforce', '2020-11-20 23:26:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (307, 7, 'DHL Benelux', 'dhlbenelux', '2020-11-21 07:35:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (308, 7, '丰通快运', 'ftky365', '2020-11-19 17:59:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (309, 7, '景光物流', 'jgwl', '2020-11-17 20:09:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (310, 7, '亚洲顺物流', 'yzswuliu', '2020-11-19 22:27:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (311, 7, '成都立即送', 'lijisong', '2020-11-22 06:11:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (312, 7, 'CNPEX中邮快递', 'cnpex', '2020-11-20 15:10:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (313, 7, '邮邦国际', 'youban', '2020-11-19 10:21:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (314, 7, '新西兰中通', 'nzzto', '2020-11-18 07:12:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (315, 7, '易客满', 'ecmscn', '2020-11-23 04:39:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (316, 7, '德国优拜物流', 'ubuy', '2020-11-23 06:37:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (317, 7, '商桥物流', 'shangqiao56', '2020-11-22 21:30:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (318, 7, '西班牙(Correos de Espa?a)', 'correosdees', '2020-11-20 18:00:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (319, 7, '三真驿道', 'zlink', '2020-11-18 02:28:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (320, 7, '飞洋快递', 'shipgce', '2020-11-18 05:59:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (321, 7, '安信达', 'anxindakuaixi', '2020-11-19 23:30:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (322, 7, '佳吉快运', 'jiajiwuliu', '2020-11-21 05:56:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (323, 7, '荷兰邮政-中文(PostNL international registered mail)', 'postnlcn', '2020-11-22 09:28:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (324, 7, '运通中港快递', 'ytkd', '2020-11-17 09:14:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (325, 7, 'CNE', 'cnexps', '2020-11-23 14:43:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (326, 7, '原飞航', 'yuanfeihangwuliu', '2020-11-21 04:16:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (327, 7, 'DPEX', 'dpex', '2020-11-18 02:11:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (328, 7, '法国小包（colissimo）', 'colissimo', '2020-11-23 20:26:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (329, 7, '黑猫宅急便', 'tcat', '2020-11-20 05:57:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (330, 7, '展勤快递', 'byht', '2020-11-19 16:09:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (331, 7, '瀚朝物流', 'hac56', '2020-11-20 15:51:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (332, 7, '鸿泰物流', 'hnht56', '2020-11-20 09:09:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (333, 7, 'EFS Post（平安快递）', 'efs', '2020-11-22 23:11:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (334, 7, 'LUCFLOW EXPRESS', 'longfx', '2020-11-22 20:11:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (335, 7, '久久物流', 'jiujiuwl', '2020-11-21 09:39:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (336, 7, 'UBI Australia', 'gotoubi', '2020-11-21 12:43:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (337, 7, '秦远物流', 'qinyuan', '2020-11-19 12:57:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (338, 7, '锋鸟物流', 'beebird', '2020-11-23 02:17:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (339, 7, '星云速递', 'nebuex', '2020-11-19 01:35:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (340, 7, 'GLS', 'gls', '2020-11-22 23:24:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (341, 7, '宏递快运', 'hd', '2020-11-19 21:16:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (342, 7, '美西快递', 'meixi', '2020-11-20 11:49:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (343, 7, '合心速递', 'hexinexpress', '2020-11-18 21:34:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (344, 7, '考拉速递', 'koalaexp', '2020-11-23 00:04:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (345, 7, '中集冷云', 'cccc58', '2020-11-20 12:37:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (346, 7, 'EMS物流', 'emswuliu', '2020-11-23 14:35:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (347, 7, '承诺达', 'ytchengnuoda', '2020-11-18 16:02:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (348, 7, '顺丰同城', 'shunfengtongcheng', '2020-11-19 10:45:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (349, 7, 'GTS快递', 'gts', '2020-11-17 07:58:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (350, 7, '明通国际快递', 'tnjex', '2020-11-18 07:17:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (351, 7, '乌克兰邮政包裹', 'ukrpostcn', '2020-11-22 13:31:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (352, 7, '顺丰-繁体', 'shunfenghk', '2020-11-20 02:45:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (353, 7, '顺捷达', 'shunjieda', '2020-11-22 20:52:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (354, 7, 'UEQ快递', 'ueq', '2020-11-23 03:46:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (355, 7, 'SYNSHIP快递', 'synship', '2020-11-23 06:34:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (356, 7, '华美快递', 'hmus', '2020-11-22 23:52:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (357, 7, '全时速运', 'runhengfeng', '2020-11-21 05:59:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (358, 7, '优速通达', 'yousutongda', '2020-11-20 07:16:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (359, 7, '全一快递', 'quanyikuaidi', '2020-11-20 19:26:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (360, 7, '全速物流', 'quansu', '2020-11-19 05:41:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (361, 7, '智通物流', 'ztong', '2020-11-23 17:48:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (362, 7, '商壹国际物流', 'com1express', '2020-11-23 04:55:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (363, 7, '东方汇', 'est365', '2020-11-20 21:31:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (364, 7, '春风物流', 'spring56', '2020-11-17 21:52:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (365, 7, '汇通天下物流', 'httx56', '2020-11-23 19:06:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (366, 7, '爱尔兰(An Post)', 'anposten', '2020-11-20 12:12:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (367, 7, '西翼物流', 'westwing', '2020-11-21 03:23:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (368, 7, '锦程快递', 'hrex', '2020-11-20 06:40:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (369, 7, '意大利(Poste Italiane)', 'italiane', '2020-11-21 00:11:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (370, 7, '八达通', 'bdatong', '2020-11-20 07:14:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (371, 7, '尚橙物流', 'shangcheng', '2020-11-21 12:36:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (372, 7, '威时沛运货运', 'wtdchina', '2020-11-22 19:39:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (373, 7, '合众速递(UCS）', 'ucs', '2020-11-18 16:06:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (374, 7, 'airpak expresss', 'airpak', '2020-11-21 19:55:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (375, 7, '一号线', 'lineone', '2020-11-22 06:56:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (376, 7, 'Hermes', 'hermes', '2020-11-22 01:16:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (377, 7, '法国(La Poste)', 'csuivi', '2020-11-19 11:52:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (378, 7, '能达速递', 'ganzhongnengda', '2020-11-21 07:14:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (379, 7, '全速通', 'quansutong', '2020-11-17 04:10:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (380, 7, '安鲜达', 'exfresh', '2020-11-18 21:30:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (381, 7, '急先达', 'jixianda', '2020-11-19 01:21:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (382, 7, 'CHS中环国际快递', 'chszhonghuanguoji', '2020-11-21 15:16:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (383, 7, '三态速递', 'santaisudi', '2020-11-20 03:56:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (384, 7, '极光转运', 'jiguang', '2020-11-18 22:53:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (385, 7, '店通快递', 'diantongkuaidi', '2020-11-17 07:35:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (386, 7, '韩国（Korea Post）', 'koreapost', '2020-11-19 16:57:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (387, 7, '佰麒快递', 'beckygo', '2020-11-22 16:20:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (388, 7, 'Canpar', 'canpar', '2020-11-23 10:30:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (389, 7, 'E速达', 'exsuda', '2020-11-18 07:10:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (390, 7, '全际通', 'quanjitong', '2020-11-18 02:38:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (391, 7, '佳成快递 ', 'jiacheng', '2020-11-18 16:41:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (392, 7, '品骏快递', 'pjbest', '2020-11-22 04:30:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (393, 7, '淘布斯国际物流', 'taoplus', '2020-11-17 01:29:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (394, 7, '一正达速运', 'yizhengdasuyun', '2020-11-22 14:53:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (395, 7, '安捷物流', 'anjie88', '2020-11-17 04:19:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (396, 7, '荷兰邮政-中国件', 'postnlchina', '2020-11-21 21:58:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (397, 7, '丰程物流', 'sccod', '2020-11-20 05:50:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (398, 7, '百腾物流', 'baitengwuliu', '2020-11-18 12:16:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (399, 7, '渥途国际速运', 'wotu', '2020-11-21 19:31:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (400, 7, '递五方云仓', 'di5pll', '2020-11-22 16:25:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (401, 7, '雪域易购', 'qhxyyg', '2020-11-17 03:15:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (402, 7, '瑞典（Sweden Post）', 'ruidianyouzheng', '2020-11-21 11:59:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (403, 7, '51跨境通', 'wykjt', '2020-11-18 07:09:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (404, 7, '宇佳物流', 'yujiawl', '2020-11-16 23:28:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (405, 7, '直德邮', 'zdepost', '2020-11-19 23:33:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (406, 7, '飞远配送', 'feiyuanvipshop', '2020-11-18 03:00:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (407, 7, '五六快运', 'wuliuky', '2020-11-20 16:03:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (408, 7, '易达通', 'yidatong', '2020-11-18 02:54:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (409, 7, '陆本速递 LUBEN EXPRESS', 'luben', '2020-11-18 14:02:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (410, 7, '晟邦物流', 'nanjingshengbang', '2020-11-21 14:26:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (411, 7, '英超物流', 'yingchao', '2020-11-21 09:44:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (412, 7, 'Toll', 'dpexen', '2020-11-18 07:42:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (413, 7, '魔速达', 'mosuda', '2020-11-17 08:58:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (414, 7, 'OnTrac', 'ontrac', '2020-11-21 21:23:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (415, 7, '荷兰邮政(PostNL international registered mail)', 'postnl', '2020-11-19 13:00:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (416, 7, 'Asendia USA', 'asendiausa', '2020-11-22 00:32:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (417, 7, '中国香港(HongKong Post)英文', 'hkposten', '2020-11-20 15:21:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (418, 7, 'PCA Express', 'pcaexpress', '2020-11-20 04:10:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (419, 7, '德尚国际速递', 'gslexpress', '2020-11-21 23:47:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (420, 7, '佳吉快递', 'jiajikuaidi', '2020-11-18 14:05:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (421, 7, '骏丰国际速递', 'junfengguoji', '2020-11-23 21:25:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (422, 7, '台湾（中华邮政）', 'postserv', '2020-11-18 23:11:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (423, 7, '全日通', 'quanritongkuaidi', '2020-11-20 01:57:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (424, 7, '三象速递', 'sxexpress', '2020-11-19 14:34:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (425, 7, '星空国际', 'wlwex', '2020-11-20 19:57:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (426, 7, '西游寄', 'xiyoug', '2020-11-21 10:23:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (427, 7, '上大物流', 'shangda', '2020-11-20 18:23:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (428, 7, '荷兰速递(Nederland Post)', 'nederlandpost', '2020-11-22 13:49:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (429, 7, '一智通', '1ziton', '2020-11-19 17:35:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (430, 7, '飞豹快递', 'feibaokuaidi', '2020-11-20 22:06:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (431, 7, '韩国邮政', 'koreapostcn', '2020-11-21 12:08:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (432, 7, '荷兰包裹(PostNL International Parcels)', 'postnlpacle', '2020-11-20 20:41:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (433, 7, '欧亚专线', 'euasia', '2020-11-22 20:00:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (434, 7, '华瀚快递', 'hhair56', '2020-11-20 17:36:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (435, 7, '永昌物流', 'yongchangwuliu', '2020-11-18 04:59:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (436, 7, '泰国中通ZTO', 'thaizto', '2020-11-18 19:50:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (437, 7, 'TransRush', 'transrush', '2020-11-22 13:11:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (438, 7, '泛远国际物流', 'farlogistis', '2020-11-18 11:27:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (439, 7, '俄顺达', 'eshunda', '2020-11-21 16:00:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (440, 7, 'FedEx-美国件', 'fedexus', '2020-11-22 01:20:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (441, 7, 'MoreLink', 'morelink56', '2020-11-21 09:01:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (442, 7, 'wedepot物流', 'wedepot', '2020-11-23 18:03:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (443, 7, '邦送物流', 'bangsongwuliu', '2020-11-23 18:52:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (444, 7, '中天万运', 'zhongtianwanyun', '2020-11-23 18:30:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (445, 7, 'GSM', 'gsm', '2020-11-23 14:13:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (446, 7, '卡塔尔（Qatar Post）', 'qpost', '2020-11-22 17:56:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (447, 7, '威盛快递', 'wherexpess', '2020-11-19 01:22:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (448, 7, '家家通快递', 'newsway', '2020-11-17 00:43:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (449, 7, '万家康物流', 'wjkwl', '2020-11-17 23:06:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (450, 7, '诚和通', 'cht361', '2020-11-21 18:24:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (451, 7, 'dhl小包', 'dhlecommerce', '2020-11-17 03:39:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (452, 7, '一起送', 'yiqisong', '2020-11-17 09:26:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (453, 7, '日本郵便', 'japanpost', '2020-11-18 13:13:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (454, 7, '优海国际速递', 'uhi', '2020-11-23 14:48:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (455, 7, 'e直运', 'edtexpress', '2020-11-17 16:38:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (456, 7, '迅速快递', 'xunsuexpress', '2020-11-21 11:48:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (457, 7, '安世通快递', 'astexpress', '2020-11-23 12:47:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (458, 7, '天翼快递', 'tykd', '2020-11-22 08:10:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (459, 7, '喀麦隆(CAMPOST)', 'cameroon', '2020-11-17 04:47:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (460, 7, 'track-parcel', 'trackparcel', '2020-11-22 20:28:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (461, 7, '宇航通物流', 'yhtlogistics', '2020-11-17 22:19:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (462, 7, '云邮跨境快递', 'hkems', '2020-11-18 00:32:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (463, 7, '货运皇', 'kingfreight', '2020-11-19 08:42:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (464, 7, '顺通快递', 'stkd', '2020-11-18 20:12:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (465, 7, 'TRAKPAK', 'trakpak', '2020-11-19 03:56:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (466, 7, '雅澳物流', 'yourscm', '2020-11-22 08:03:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (467, 7, '比利时国际(Bpost international)', 'bpostinter', '2020-11-23 08:09:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (468, 7, '大洋物流', 'dayangwuliu', '2020-11-18 20:15:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (469, 7, '北京EMS', 'bjemstckj', '2020-11-21 03:07:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (470, 7, 'LaserShip', 'lasership', '2020-11-18 06:29:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (471, 7, '比利时(Belgium Post)', 'belgiumpost', '2020-11-17 22:47:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (472, 7, '城通物流', 'chengtong', '2020-11-17 23:26:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (473, 7, '韵丰物流', 'yunfeng56', '2020-11-19 01:49:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (474, 7, '传喜物流', 'chuanxiwuliu', '2020-11-17 13:08:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (475, 7, '飞力士物流', 'flysman', '2020-11-20 11:53:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (476, 7, '天天快物流', 'guoeryue', '2020-11-18 23:39:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (477, 7, 'Gati-中文', 'gaticn', '2020-11-23 10:17:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (478, 7, '远成物流', 'yuanchengwuliu', '2020-11-22 09:26:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (479, 7, '飞康达', 'feikangda', '2020-11-17 18:42:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (480, 7, '上海航瑞货运', 'hangrui', '2020-11-18 15:33:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (481, 7, '天天欧洲物流', 'ttkeurope', '2020-11-22 22:37:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (482, 7, '宇捷通', 'yujtong', '2020-11-20 23:28:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (483, 7, 'BHT', 'bht', '2020-11-19 02:29:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (484, 7, 'Newgistics', 'newgistics', '2020-11-22 13:42:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (485, 7, '如家国际快递', 'homecourier', '2020-11-17 18:00:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (486, 7, '黑猫速运', 'heimao56', '2020-11-17 23:15:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (487, 7, '好来运', 'hlyex', '2020-11-19 15:14:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (488, 7, '骏达快递', 'jdexpressusa', '2020-11-20 08:48:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (489, 7, '亚风速递', 'yafengsudi', '2020-11-19 00:35:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (490, 7, '宜送物流', 'yiex', '2020-11-17 01:31:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (491, 7, '创一快递', 'chuangyi', '2020-11-18 05:32:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (492, 7, '新加坡小包(Singapore Post)', 'singpost', '2020-11-23 00:04:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (493, 7, '维普恩物流', 'vps', '2020-11-22 12:48:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (494, 7, '远成快运', 'ycgky', '2020-11-19 18:05:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (495, 7, '澳通华人物流', 'cllexpress', '2020-11-21 03:40:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (496, 7, '速舟物流', 'cnspeedster', '2020-11-22 14:25:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (497, 7, '百通物流', 'buytong', '2020-11-18 16:48:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (498, 7, '皇家物流', 'pfcexpress', '2020-11-22 15:03:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (499, 7, '顺捷丰达', 'shunjiefengda', '2020-11-19 05:51:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (500, 7, '美国云达', 'yundaexus', '2020-11-18 07:47:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (501, 7, '鹏远国际速递', 'pengyuanexpress', '2020-11-23 20:59:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (502, 7, '泰国138国际物流', 'sd138', '2020-11-19 15:58:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (503, 7, '元智捷诚', 'yuanzhijiecheng', '2020-11-23 15:10:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (504, 7, '恒宇运通', 'hyytes', '2020-11-21 08:55:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (505, 7, '聚鼎物流', 'juding', '2020-11-19 00:07:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (506, 7, '民航快递', 'minghangkuaidi', '2020-11-20 21:29:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (507, 7, '一号仓', 'onehcang', '2020-11-23 13:25:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (508, 7, '捷安达', 'jieanda', '2020-11-17 07:37:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (509, 7, '吉捷国际速递', 'luckyfastex', '2020-11-19 18:51:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (510, 7, '百世云配', 'baishiyp', '2020-11-23 01:45:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (511, 7, '尼尔快递', 'nell', '2020-11-18 05:10:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (512, 7, '泰国（Thailand Thai Post）', 'thailand', '2020-11-18 18:54:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (513, 7, '澳捷物流', 'ajlogistics', '2020-11-22 08:03:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (514, 7, '成都东骏物流', 'dongjun', '2020-11-17 12:30:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (515, 7, 'ABF', 'abf', '2020-11-17 12:41:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (516, 7, '海红网送', 'haihongwangsong', '2020-11-18 02:58:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (517, 7, '明达国际速递', 'tmwexpress', '2020-11-21 01:45:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (518, 7, 'A2U速递', 'a2u', '2020-11-20 03:31:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (519, 7, '小飞侠速递', 'cyxfx', '2020-11-20 13:21:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (520, 7, '中粮鲜到家物流', 'zlxdjwl', '2020-11-18 10:31:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (521, 7, '中邮电商', 'chinapostcb', '2020-11-20 12:12:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (522, 7, '飞快达', 'feikuaida', '2020-11-23 07:48:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (523, 7, '明大快递', 'adaexpress', '2020-11-17 07:25:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (524, 7, '中骅物流', 'chunghwa56', '2020-11-20 10:41:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (525, 7, 'E通速递', 'etong', '2020-11-19 10:51:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (526, 7, '优莎速运', 'eusacn', '2020-11-18 23:12:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (527, 7, '共速达', 'gongsuda', '2020-11-19 12:24:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (528, 7, '配思货运', 'peisihuoyunkuaidi', '2020-11-23 17:26:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (529, 7, '俄罗斯邮政(Russian Post)', 'pochta', '2020-11-22 06:58:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (530, 7, '北极星快运', 'polarisexpress', '2020-11-23 07:31:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (531, 7, '赛澳递for买卖宝', 'saiaodimmb', '2020-11-18 20:23:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (532, 7, '邦通国际', 'comexpress', '2020-11-21 05:42:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (533, 7, '英国(大包,EMS)', 'england', '2020-11-18 18:59:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (534, 7, '凡宇快递', 'fanyukuaidi', '2020-11-20 05:31:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (535, 7, '科捷物流', 'kejie', '2020-11-20 20:57:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (536, 7, '马来西亚小包（Malaysia Post(Registered)）', 'malaysiapost', '2020-11-19 18:32:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (537, 7, '丹麦(Post Denmark)', 'postdanmarken', '2020-11-19 06:47:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (538, 7, '臣邦同城', 'wto56kj', '2020-11-20 03:22:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (539, 7, '运通中港', 'yuntongkuaidi', '2020-11-18 22:47:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (540, 7, '易优包裹', 'eupackage', '2020-11-17 08:50:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (541, 7, '飞鹰物流', 'hnfy', '2020-11-19 23:27:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (542, 7, '柬埔寨中通', 'khzto', '2020-11-23 21:06:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (543, 7, '志腾物流', 'zhitengwuliu', '2020-11-21 16:10:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (544, 7, '捷记方舟', 'ajexpress', '2020-11-19 18:31:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (545, 7, '河北橙配', 'chengpei', '2020-11-23 19:44:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (546, 7, '城市映急', 'city56', '2020-11-22 00:08:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (547, 7, '华中快递', 'cpsair', '2020-11-21 14:27:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (548, 7, 'EU-EXPRESS', 'euexpress', '2020-11-18 02:11:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (549, 7, '高铁快运', 'gaotieex', '2020-11-22 13:54:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (550, 7, '飞豹速递', 'hkeex', '2020-11-20 19:59:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (551, 7, '腾达速递', 'nntengda', '2020-11-19 11:10:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (552, 7, '越丰物流', 'yuefengwuliu', '2020-11-17 20:54:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (553, 7, '卡邦配送', 'ahkbps', '2020-11-20 22:42:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (554, 7, '青岛安捷快递', 'anjiekuaidi', '2020-11-20 06:26:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (555, 7, 'AOL澳通速递', 'aolau', '2020-11-21 13:05:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (556, 7, '安的快递', 'gda', '2020-11-23 00:27:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (557, 7, '日日顺智慧物联', 'gooday365', '2020-11-19 14:38:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (558, 7, '南非（South African Post Office）', 'southafrican', '2020-11-18 23:30:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (559, 7, '瑞士邮政', 'swisspostcn', '2020-11-19 02:34:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (560, 7, '法国大包、EMS-法文（Chronopost France）', 'chronopostfra', '2020-11-21 15:23:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (561, 7, 'EASY EXPRESS', 'easyexpress', '2020-11-20 00:54:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (562, 7, 'GE2D跨境物流', 'ge2d', '2020-11-18 07:19:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (563, 7, '华企快运', 'huaqikuaiyun', '2020-11-21 09:33:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (564, 7, '牙买加（Jamaica Post）', 'jamaicapost', '2020-11-21 05:29:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (565, 7, '捷邦物流', 'jieborne', '2020-11-18 01:04:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (566, 7, '美国快递', 'meiguokuaidi', '2020-11-23 11:12:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (567, 7, '新加坡EMS、大包(Singapore Speedpost)', 'speedpost', '2020-11-18 11:11:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (568, 7, '深圳邮政', 'szyouzheng', '2020-11-18 20:37:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (569, 7, '中运全速', 'topspeedex', '2020-11-21 22:31:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (570, 7, '三三国际物流', 'zenzen', '2020-11-22 06:25:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (571, 7, '中外运速递', 'zhongwaiyun', '2020-11-21 14:52:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (572, 7, '中联速递', 'auvanda', '2020-11-17 09:27:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (573, 7, '加拿大邮政', 'canpostfr', '2020-11-19 00:59:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (574, 7, 'CCES/国通快递', 'cces', '2020-11-19 02:51:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (575, 7, '法国大包、EMS-英文(Chronopost France)', 'chronopostfren', '2020-11-21 12:20:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (576, 7, 'C&C国际速递', 'cncexp', '2020-11-19 08:48:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (577, 7, '东风快递', 'dfkuaidi', '2020-11-22 06:37:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (578, 7, '易邮国际', 'euguoji', '2020-11-22 10:23:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (579, 7, '高捷快运', 'goldjet', '2020-11-21 10:22:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (580, 7, '爱拜物流', 'ibuy8', '2020-11-22 21:44:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (581, 7, '6LS EXPRESS', 'lsexpress', '2020-11-19 09:13:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (582, 7, 'MyHermes', 'myhermes', '2020-11-18 04:31:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (583, 7, 'Purolator', 'purolator', '2020-11-22 18:36:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (584, 7, '红马甲物流', 'sxhongmajia', '2020-11-21 12:27:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (585, 7, '安达信', 'advancing', '2020-11-22 07:28:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (586, 7, '保加利亚（Bulgarian Posts）', 'bulgarian', '2020-11-23 02:17:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (587, 7, 'City-Link', 'citylink', '2020-11-17 16:43:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (588, 7, '嘉诚速达', 'jcsuda', '2020-11-23 01:46:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (589, 7, '急递', 'jdpplus', '2020-11-17 12:57:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (590, 7, 'Landmark Global', 'landmarkglobal', '2020-11-22 08:30:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (591, 7, 'NLE', 'nle', '2020-11-21 08:37:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (592, 7, '7E速递', 'qesd', '2020-11-22 18:37:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (593, 7, '日日顺快线', 'rrskx', '2020-11-18 22:51:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (594, 7, '圣安物流', 'shenganwuliu', '2020-11-23 08:46:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (595, 7, '新速航', 'sunspeedy', '2020-11-22 04:18:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (596, 7, '联运通物流', 'szuem', '2020-11-23 20:11:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (597, 7, '万博快递', 'wanboex', '2020-11-21 19:41:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (598, 7, 'ADP国际快递', 'adp', '2020-11-20 14:53:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (599, 7, '加拿大民航快递', 'airgtc', '2020-11-20 16:21:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (600, 7, '心怡物流', 'alog', '2020-11-17 15:27:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (601, 7, '奔腾物流', 'benteng', '2020-11-23 02:33:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (602, 7, '飞狐快递', 'feihukuaidi', '2020-11-17 20:41:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (603, 7, '海外环球', 'haiwaihuanqiu', '2020-11-23 20:46:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (604, 7, '河南全速通', 'hnqst', '2020-11-21 00:10:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (605, 7, '红远物流', 'hongywl', '2020-11-23 10:11:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (606, 7, '汇强快递', 'huiqiangkuaidi', '2020-11-23 06:03:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (607, 7, '民邦速递', 'minbangsudi', '2020-11-22 02:02:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (608, 7, '明亮物流', 'mingliangwuliu', '2020-11-23 17:02:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (609, 7, '猛犸速递', 'mmlogi', '2020-11-21 10:45:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (610, 7, '乌兹别克斯坦(Post of Uzbekistan)', 'uzbekistan', '2020-11-19 03:39:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (611, 7, '伍圆速递', 'wuyuansudi', '2020-11-21 09:41:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (612, 7, '祥龙运通物流', 'xianglongyuntong', '2020-11-18 17:09:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (613, 7, '鑫世锐达', 'xsrd', '2020-11-19 08:19:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (614, 7, '银捷速递', 'yinjiesudi', '2020-11-23 15:08:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (615, 7, '准实快运', 'zsky123', '2020-11-22 07:45:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (616, 7, '中远快运', 'zy100', '2020-11-23 18:21:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (617, 7, '德方物流', 'ahdf', '2020-11-21 00:08:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (618, 7, '无忧物流', 'aliexpress', '2020-11-23 17:18:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (619, 7, '新干线快递', 'anlexpress', '2020-11-17 19:04:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (620, 7, '澳世速递', 'ausexpress', '2020-11-21 16:27:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (621, 7, '彪记快递', 'biaojikuaidi', '2020-11-17 06:04:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (622, 7, '贝业物流', 'boyol', '2020-11-18 03:18:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (623, 7, 'CNAIR', 'cnair', '2020-11-21 23:17:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (624, 7, 'FQ狂派速递', 'freakyquick', '2020-11-17 15:32:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (625, 7, '贵州星程快递', 'gzxingcheng', '2020-11-19 06:08:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (626, 7, '嘉里大荣物流', 'kerrytj', '2020-11-19 10:24:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (627, 7, '快达物流', 'kuaidawuliu', '2020-11-22 10:35:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (628, 7, '菲律宾（Philippine Postal）', 'phlpost', '2020-11-23 01:22:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (629, 7, '秦邦快运', 'qbexpress', '2020-11-17 02:47:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (630, 7, '赛澳递', 'saiaodi', '2020-11-20 06:49:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (631, 7, '世华通物流', 'szshihuatong56', '2020-11-19 05:25:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (632, 7, '易邮速运', 'yiyou', '2020-11-18 07:38:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (633, 7, '纵通速运', 'ynztsy', '2020-11-23 21:34:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (634, 7, '远航国际快运', 'yuanhhk', '2020-11-19 19:16:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (635, 7, '玥玛速运', 'yue777', '2020-11-17 07:20:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (636, 7, '卓实快运', 'zhuoshikuaiyun', '2020-11-17 02:30:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (637, 7, '增速跨境 ', 'zyzoom', '2020-11-23 14:09:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (638, 7, '亚马逊中国订单', 'amazoncnorder', '2020-11-21 21:36:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (639, 7, '阿塞拜疆EMS(EMS AzerExpressPost)', 'azerbaijan', '2020-11-21 18:31:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (640, 7, '鑫宸物流', 'cdxinchen56', '2020-11-19 06:09:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (641, 7, '华欣物流', 'chinastarlogistics', '2020-11-20 22:51:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (642, 7, 'Chronopost Portugal', 'chronopostport', '2020-11-23 02:09:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (643, 7, '泰国中通CTO', 'ctoexp', '2020-11-21 17:51:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (644, 7, '澳州顺风快递', 'emms', '2020-11-22 11:49:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (645, 7, '中外运', 'esinotrans', '2020-11-23 07:53:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (646, 7, '大达物流', 'idada', '2020-11-18 07:36:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (647, 7, '楽道物流', 'ledaowuliu', '2020-11-18 12:43:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (648, 7, '马来西亚大包、EMS（Malaysia Post(parcel,EMS)）', 'malaysiaems', '2020-11-20 17:45:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (649, 7, '浩博物流', 'njhaobo', '2020-11-17 06:16:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (650, 7, '土耳其', 'ptt', '2020-11-21 00:23:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (651, 7, '通和天下', 'tonghetianxia', '2020-11-22 10:51:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (652, 7, '乌克兰小包、大包(UkrPost)', 'ukrpost', '2020-11-18 08:44:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (653, 7, '泰捷达国际物流', 'ztjieda', '2020-11-21 09:26:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (654, 7, '全球快运', 'abcglobal', '2020-11-21 00:37:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (655, 7, '银雁专送', 'cfss', '2020-11-17 01:09:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (656, 7, '哥伦比亚(4-72 La Red Postal de Colombia)', 'colombia', '2020-11-19 02:12:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (657, 7, '大道物流', 'dadaoex', '2020-11-20 09:54:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (658, 7, '深圳德创物流', 'dechuangwuliu', '2020-11-20 21:13:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (659, 7, '龙象国际物流', 'edragon', '2020-11-19 06:43:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (660, 7, 'FOX国际快递', 'fox', '2020-11-23 17:39:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (661, 7, '广东通路', 'guangdongtonglu', '2020-11-23 01:02:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (662, 7, '海联快递', 'hltop', '2020-11-20 02:36:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (663, 7, '匈牙利（Magyar Posta）', 'hungary', '2020-11-21 09:32:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (664, 7, '驿扬国际速运', 'iyoungspeed', '2020-11-22 18:11:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (665, 7, '加州猫速递', 'jiazhoumao', '2020-11-18 18:01:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (666, 7, '晋越快递', 'jinyuekuaidi', '2020-11-22 09:54:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (667, 7, '中国澳门(Macau Post)', 'macao', '2020-11-18 00:23:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (668, 7, 'rpx', 'rpx', '2020-11-19 18:35:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (669, 7, '林道国际快递', 'shlindao', '2020-11-20 22:06:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (670, 7, '中外运空运', 'sinoairinex', '2020-11-21 09:04:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (671, 7, '鑫远东速运', 'xyd666', '2020-11-20 05:22:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (672, 7, '云达通', 'ydglobe', '2020-11-20 00:40:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (673, 7, 'YODEL', 'yodel', '2020-11-22 12:14:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (674, 7, '中环转运', 'zhonghuanus', '2020-11-21 14:50:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (675, 7, '忠信达', 'zhongxinda', '2020-11-23 14:29:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (676, 7, '转瞬达集运', 'zsda56', '2020-11-22 07:33:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (677, 7, '德国雄鹰速递', 'adlerlogi', '2020-11-23 19:18:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (678, 7, '澳货通', 'auex', '2020-11-21 05:31:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (679, 7, '奥地利(Austrian Post)', 'austria', '2020-11-17 18:40:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (680, 7, '帮帮发', 'bangbangpost', '2020-11-22 03:08:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (681, 7, '宝通快递', 'baotongkd', '2020-11-19 12:40:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (682, 7, '蜜蜂速递', 'bee001', '2020-11-21 05:35:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (683, 7, '白俄罗斯(Belpochta)', 'belpost', '2020-11-23 16:15:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (684, 7, '长宇物流', 'changyuwuliu', '2020-11-23 20:12:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (685, 7, '中澳速递', 'cnausu', '2020-11-17 07:54:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (686, 7, '云南诚中物流', 'czwlyn', '2020-11-18 23:55:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (687, 7, 'DHL-荷兰（DHL Netherlands）', 'dhlnetherlands', '2020-11-19 02:13:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (688, 7, '递四方澳洲', 'disifangau', '2020-11-21 12:19:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (689, 7, '天翔东捷运', 'djy56', '2020-11-19 10:36:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (690, 7, 'DPD Germany', 'dpdgermany', '2020-11-22 15:45:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (691, 7, '可可树美中速运', 'excocotree', '2020-11-17 03:56:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (692, 7, '全速快递', 'fsexp', '2020-11-21 17:25:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (693, 7, 'globaltracktrace', 'globaltracktrace', '2020-11-19 08:18:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (694, 7, '海盟速递', 'haimengsudi', '2020-11-21 12:56:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (695, 7, '开心快递', 'happylink', '2020-11-18 19:24:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (696, 7, '猴急送', 'hjs', '2020-11-19 09:51:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (697, 7, '中国香港环球快运', 'huanqiuabc', '2020-11-23 16:03:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (698, 7, 'JDIEX', 'jdiex', '2020-11-22 07:42:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (699, 7, '金大物流', 'jindawuliu', '2020-11-23 15:20:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (700, 7, 'KCS', 'kcs', '2020-11-20 09:15:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (701, 7, '淘韩国际快递', 'krtao', '2020-11-20 23:55:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (702, 7, '快速递', 'ksudi', '2020-11-19 22:09:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (703, 7, '黎巴嫩(Liban Post)', 'libanpost', '2020-11-19 16:01:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (704, 7, '小熊物流', 'littlebearbear', '2020-11-21 14:37:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (705, 7, 'LWE', 'lwe', '2020-11-18 04:41:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (706, 7, '马其顿(Macedonian Post)', 'macedonia', '2020-11-23 01:53:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (707, 7, '毛里求斯(Mauritius Post)', 'mauritius', '2020-11-23 00:24:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (708, 7, '澳洲迈速快递', 'maxeedexpress', '2020-11-21 22:40:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (709, 7, 'Nova Poshta', 'novaposhta', '2020-11-23 17:08:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (710, 7, '葡萄牙（Portugal CTT）', 'portugalctt', '2020-11-21 21:18:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (711, 7, '人人转运', 'renrenex', '2020-11-21 08:09:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (712, 7, '四川星程快递', 'scxingcheng', '2020-11-17 03:12:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (713, 7, '上海快通', 'shanghaikuaitong', '2020-11-18 13:50:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (714, 7, '闪货极速达', 'shanhuodidi', '2020-11-17 13:55:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (715, 7, 'SHL畅灵国际物流', 'shlexp', '2020-11-22 03:46:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (716, 7, 'wish邮', 'shpostwish', '2020-11-20 06:05:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (717, 7, '斯洛文尼亚(Slovenia Post)', 'slovenia', '2020-11-17 20:08:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (718, 7, 'TNT UK', 'tntuk', '2020-11-18 10:05:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (719, 7, 'Toll Priority(Toll Online)', 'tollpriority', '2020-11-21 15:00:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (720, 7, '优联吉运', 'uluckex', '2020-11-22 00:27:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (721, 7, '万庚国际速递', 'vangenexpress', '2020-11-21 07:34:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (722, 7, '越南EMS(VNPost Express)', 'vnpost', '2020-11-23 13:29:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (723, 7, 'YDH', 'ydhex', '2020-11-23 00:24:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (724, 7, '亿领速运', 'yilingsuyun', '2020-11-20 11:53:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (725, 7, '易欧洲国际物流', 'yiouzhou', '2020-11-23 09:52:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (726, 7, '亿顺航', 'yishunhang', '2020-11-17 18:41:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (727, 7, '友家速递', 'youjia', '2020-11-22 12:49:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (728, 7, '西安运逸快递', 'yyexp', '2020-11-21 13:02:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (729, 7, '珠峰速运', 'zf365', '2020-11-23 03:42:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (730, 7, '中技物流', 'zhongjiwuliu', '2020-11-20 07:04:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (731, 7, '明辉物流', 'zsmhwl', '2020-11-21 23:55:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (732, 7, '阿富汗(Afghan Post)', 'afghan', '2020-11-18 06:04:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (733, 7, 'amazon-国内订单', 'amcnorder', '2020-11-22 04:53:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (734, 7, 'amazon-国际订单', 'amusorder', '2020-11-18 11:12:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (735, 7, 'apgecommerce', 'apgecommerce', '2020-11-22 15:43:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (736, 7, '美国汉邦快递', 'aplus100', '2020-11-20 01:58:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (737, 7, 'Aplus物流', 'aplusex', '2020-11-22 10:23:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (738, 7, 'AUV国际快递', 'auvexpress', '2020-11-21 01:41:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (739, 7, 'BCWELT', 'bcwelt', '2020-11-21 02:13:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (740, 7, '飛斯特', 'bester', '2020-11-18 08:25:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (741, 7, '鑫锐达', 'bjxsrd', '2020-11-18 11:04:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (742, 7, '佰乐捷通', 'bljt56', '2020-11-20 07:07:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (743, 7, '柬埔寨(Cambodia Post)', 'cambodia', '2020-11-22 04:43:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (744, 7, '河南次晨达', 'ccd', '2020-11-19 05:54:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (745, 7, '昌宇国际', 'changwooair', '2020-11-19 14:59:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (746, 7, '同舟行物流', 'chinatzx', '2020-11-23 10:14:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (747, 7, 'CE易欧通国际速递', 'cloudexpress', '2020-11-20 11:15:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (748, 7, '中欧物流', 'cneulogistics', '2020-11-22 01:11:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (749, 7, '重庆星程快递', 'cqxingcheng', '2020-11-17 23:51:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (750, 7, '新时速物流', 'csxss', '2020-11-20 18:00:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (751, 7, '德中快递', 'decnlh', '2020-11-18 22:10:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (752, 7, 'Deltec Courier', 'deltec', '2020-11-22 08:29:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (753, 7, '云南滇驿物流', 'dianyi', '2020-11-17 04:54:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (754, 7, '递达速运', 'didasuyun', '2020-11-22 20:04:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (755, 7, '递四方美国', 'disifangus', '2020-11-17 19:59:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (756, 7, 'DPD Poland', 'dpdpoland', '2020-11-17 14:03:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (757, 7, '多道供应链', 'duodao56', '2020-11-17 11:19:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (758, 7, 'EFSPOST', 'efspost', '2020-11-17 15:27:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (759, 7, '易联通达', 'el56', '2020-11-18 20:16:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (760, 7, '南非EMS', 'emssouthafrica', '2020-11-17 09:21:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (761, 7, 'europeanecom', 'europeanecom', '2020-11-20 09:37:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (762, 7, '飞邦快递', 'fbkd', '2020-11-18 23:39:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (763, 7, 'FedRoad 联邦转运', 'fedroad', '2020-11-23 17:07:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (764, 7, '冠捷物流 ', 'gjwl', '2020-11-23 19:38:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (765, 7, '广通速递', 'gtongsudi', '2020-11-17 02:29:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (766, 7, '航宇快递', 'hangyu', '2020-11-17 22:31:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (767, 7, '好又快物流', 'haoyoukuai', '2020-11-21 10:08:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (768, 7, '华通快运', 'htongexpress', '2020-11-22 10:46:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (769, 7, '兰州伙伴物流', 'huoban', '2020-11-17 03:08:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (770, 7, '户通物流', 'hutongwuliu', '2020-11-22 04:19:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (771, 7, '佳辰国际速递', 'jiachenexpress', '2020-11-21 17:12:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (772, 7, '加佳物流', 'jiajiawl', '2020-11-18 03:22:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (773, 7, '九宫物流', 'jiugong', '2020-11-22 11:34:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (774, 7, '吉祥邮（澳洲）', 'jixiangyouau', '2020-11-20 04:45:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (775, 7, '骏绅物流', 'jsexpress', '2020-11-23 12:44:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (776, 7, '哈萨克斯坦(Kazpost)', 'kazpost', '2020-11-19 06:23:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (777, 7, '番薯国际货运', 'koali', '2020-11-22 16:05:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (778, 7, '蓝镖快递', 'lanbiaokuaidi', '2020-11-17 18:14:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (779, 7, '林道国际快递-英文', 'ldxpres', '2020-11-17 17:15:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (780, 7, '莱索托(Lesotho Post)', 'lesotho', '2020-11-18 08:34:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (781, 7, '联运快递', 'lianyun', '2020-11-21 16:04:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (782, 7, '良藤国际速递', 'lmfex', '2020-11-22 10:17:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (783, 7, '加拿大龙行速运', 'longcps', '2020-11-23 05:34:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (784, 7, '隆浪快递', 'longlangkuaidi', '2020-11-18 00:40:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (785, 7, '恒通快递', 'lqht', '2020-11-17 08:57:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (786, 7, '卢森堡(Luxembourg Post)', 'luxembourg', '2020-11-22 18:25:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (787, 7, '迈隆递运', 'mailongdy', '2020-11-16 23:35:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (788, 7, '阿曼(Oman Post)', 'oman', '2020-11-20 11:38:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (789, 7, '全球速递', 'pdstow', '2020-11-20 15:04:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (790, 7, '鹏程快递', 'pengcheng', '2020-11-17 18:49:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (791, 7, '品速心达快递', 'pinsuxinda', '2020-11-17 00:32:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (792, 7, '急顺通', 'pzhjst', '2020-11-21 17:51:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (793, 7, 'ANTS EXPRESS', 'qdants', '2020-11-19 20:39:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (794, 7, '启辰国际速递', 'qichen', '2020-11-17 02:44:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (795, 7, '千顺快递', 'qskdyxgs', '2020-11-22 22:04:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (796, 7, '全川物流', 'quanchuan56', '2020-11-18 12:27:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (797, 7, '全信通快递', 'quanxintong', '2020-11-20 18:22:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (798, 7, '荣庆物流', 'rokin', '2020-11-17 10:10:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (799, 7, '日日通国际', 'rrthk', '2020-11-21 18:02:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (800, 7, 'S2C', 's2c', '2020-11-18 16:41:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (801, 7, '三盛快递', 'sanshengco', '2020-11-18 05:00:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (802, 7, '塞尔维亚(PE Post of Serbia)', 'serbia', '2020-11-17 23:57:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (803, 7, '十方通物流', 'sfift', '2020-11-18 09:44:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (804, 7, '圣飞捷快递', 'sfjhd', '2020-11-21 01:48:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (805, 7, '神马快递', 'shenma', '2020-11-19 07:27:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (806, 7, '阳光快递', 'shiningexpress', '2020-11-23 07:33:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (807, 7, '中外运速递-中文', 'sinoex', '2020-11-20 20:24:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (808, 7, 'skynet', 'skynet', '2020-11-17 08:20:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (809, 7, 'SkyNet Malaysia', 'skynetmalaysia', '2020-11-21 02:48:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (810, 7, '斯里兰卡(Sri Lanka Post)', 'slpost', '2020-11-22 16:41:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (811, 7, '申必达', 'speedoex', '2020-11-19 06:40:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (812, 7, '苏丹（Sudapost）', 'sudapost', '2020-11-18 06:59:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (813, 7, '穗佳物流', 'suijiawuliu', '2020-11-23 14:35:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (814, 7, '速配欧翼', 'superoz', '2020-11-18 10:16:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (815, 7, '瑞士(Swiss Post)', 'swisspost', '2020-11-18 05:56:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (816, 7, '天翔快递', 'tianxiang', '2020-11-18 23:52:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (817, 7, '万家通快递', 'timedg', '2020-11-23 06:31:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (818, 7, '天联快运', 'tlky', '2020-11-21 14:01:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (819, 7, '通达兴物流', 'tongdaxing', '2020-11-21 03:33:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (820, 7, '乌克兰小包、大包(UkrPoshta)', 'ukraine', '2020-11-17 02:01:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (821, 7, '华夏国际速递', 'uschuaxia', '2020-11-18 21:46:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (822, 7, '越南小包(Vietnam Posts)', 'vietnam', '2020-11-19 09:06:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (823, 7, '鹰运国际速递', 'vipexpress', '2020-11-23 05:13:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (824, 7, '豌豆物流', 'wandougongzhu', '2020-11-20 03:47:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (825, 7, '沃埃家', 'wowvip', '2020-11-21 02:56:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (826, 7, '微转运', 'wzhaunyun', '2020-11-21 05:39:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (827, 7, '蓝天物流', 'xflt56', '2020-11-18 21:48:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (828, 7, '艺凡快递', 'yifankd', '2020-11-20 19:40:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (829, 7, '一柒国际物流', 'yiqiguojiwuliu', '2020-11-23 11:19:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (830, 7, '武汉优进汇', 'yjhgo', '2020-11-17 02:36:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (831, 7, '洋口岸', 'ykouan', '2020-11-19 00:02:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (832, 7, '永邦国际物流', 'yongbangwuliu', '2020-11-19 18:42:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (833, 7, '壹品速递', 'ypsd', '2020-11-17 23:43:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (834, 7, '一运全成物流', 'yyqc56', '2020-11-20 14:11:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (835, 7, '众派速递', 'zhpex', '2020-11-18 03:26:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (836, 7, '创运物流', 'zjcy56', '2020-11-18 22:16:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (837, 7, 'ZTE中兴物流', 'zteexpress', '2020-11-23 06:04:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (838, 7, '安达易国际速递', 'adiexpress', '2020-11-21 16:32:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (839, 7, 'AFL', 'afl', '2020-11-21 17:26:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (840, 7, '全程快递', 'agopost', '2020-11-19 15:54:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (841, 7, '阿尔巴尼亚(Posta shqipatre)', 'albania', '2020-11-23 02:53:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (842, 7, '安家同城快运', 'anjiatongcheng', '2020-11-18 19:43:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (843, 7, '澳速物流', 'aosu', '2020-11-21 16:17:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (844, 7, '艾瑞斯远', 'ariesfar', '2020-11-21 01:55:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (845, 7, '阿鲁巴[荷兰]（Post Aruba）', 'aruba', '2020-11-23 09:43:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (846, 7, '澳达国际物流', 'auadexpress', '2020-11-22 22:30:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (847, 7, '澳邦国际物流', 'ausbondexpress', '2020-11-20 13:44:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (848, 7, '澳新物流', 'axexpress', '2020-11-17 02:07:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (849, 7, '巴林(Bahrain Post)', 'bahrain', '2020-11-20 15:42:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (850, 7, '孟加拉国(EMS)', 'bangladesh', '2020-11-21 03:50:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (851, 7, '报通快递', 'baoxianda', '2020-11-19 22:23:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (852, 7, '巴巴多斯(Barbados Post)', 'barbados', '2020-11-19 05:27:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (853, 7, '伯利兹(Belize Postal)', 'belize', '2020-11-19 09:04:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (854, 7, '笨鸟国际', 'benniao', '2020-11-22 06:02:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (855, 7, '青云物流', 'bjqywl', '2020-11-22 06:35:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (856, 7, 'BlueDart', 'bluedart', '2020-11-20 17:08:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (857, 7, '标杆物流', 'bmlchina', '2020-11-19 18:58:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (858, 7, '波黑(JP BH Posta)', 'bohei', '2020-11-19 20:25:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (859, 7, '玻利维亚', 'bolivia', '2020-11-22 22:10:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (860, 7, 'BorderGuru', 'borderguru', '2020-11-17 06:37:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (861, 7, '堡昕德速递', 'bosind', '2020-11-21 11:33:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (862, 7, '博茨瓦纳', 'botspost', '2020-11-17 18:54:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (863, 7, '速方(Sufast)', 'bphchina', '2020-11-21 10:10:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (864, 7, '百千诚物流', 'bqcwl', '2020-11-22 21:51:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (865, 7, '巴西(Brazil Post/Correios)', 'brazilposten', '2020-11-19 10:23:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (866, 7, '文莱(Brunei Postal)', 'brunei', '2020-11-18 10:04:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (867, 7, '新喀里多尼亚[法国](New Caledonia)', 'caledonia', '2020-11-23 18:50:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (868, 7, '到了港', 'camekong', '2020-11-18 22:20:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (869, 7, 'Campbell’s Express', 'campbellsexpress', '2020-11-20 05:28:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (870, 7, '能装能送', 'canhold', '2020-11-20 10:40:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (871, 7, '卢森堡航空', 'cargolux', '2020-11-17 15:16:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (872, 7, '钏博物流', 'cbo56', '2020-11-23 18:42:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (873, 7, 'CDEK', 'cdek', '2020-11-21 06:01:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (874, 7, '捷祥物流', 'cdjx56', '2020-11-17 22:59:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (875, 7, '捷克（?eská po?ta）', 'ceskaposta', '2020-11-22 23:12:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (876, 7, 'CEVA Logistic', 'cevalogistics', '2020-11-23 04:02:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (877, 7, '城铁速递', 'cex', '2020-11-23 00:53:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (878, 7, '成达国际速递', 'chengda', '2020-11-21 18:40:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (879, 7, '城际快递', 'chengji', '2020-11-22 19:41:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (880, 7, '智利(Correos Chile)', 'chile', '2020-11-17 22:05:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (881, 7, 'SQK国际速递', 'chinasqk', '2020-11-18 01:42:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (882, 7, '嘉荣物流', 'chllog', '2020-11-19 15:16:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (883, 7, '中国香港骏辉物流', 'chunfai', '2020-11-20 01:33:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (884, 7, 'citysprint', 'citysprint', '2020-11-17 12:16:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (885, 7, '大韩通运', 'cjkoreaexpress', '2020-11-17 08:23:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (886, 7, 'CL日中速运', 'clsp', '2020-11-17 06:08:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (887, 7, 'CNUP 中联邮', 'cnup', '2020-11-17 06:30:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (888, 7, '中国翼', 'cnws', '2020-11-17 15:06:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (889, 7, '莫桑比克（Correios de Moçambique）', 'correios', '2020-11-19 08:58:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (890, 7, '乌拉圭（Correo Uruguayo）', 'correo', '2020-11-20 01:53:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (891, 7, '阿根廷(Correo Argentina)', 'correoargentino', '2020-11-18 08:51:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (892, 7, '哥斯达黎加(Correos de Costa Rica)', 'correos', '2020-11-21 14:18:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (893, 7, '环旅快运', 'crossbox', '2020-11-22 00:36:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (894, 7, '塞浦路斯(Cyprus Post)', 'cypruspost', '2020-11-21 10:27:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (895, 7, '丹递56', 'dande56', '2020-11-17 04:46:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (896, 7, '达速物流', 'dasu', '2020-11-18 14:48:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (897, 7, 'DCS', 'dcs', '2020-11-17 14:01:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (898, 7, '澳行快递', 'desworks', '2020-11-22 01:24:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (899, 7, '达方物流', 'dfpost', '2020-11-19 17:56:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (900, 7, 'DHL HK', 'dhlhk', '2020-11-22 13:09:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (901, 7, 'DHL-波兰（DHL Poland）', 'dhlpoland', '2020-11-22 15:37:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (902, 7, '叮咚澳洲转运', 'dindon', '2020-11-21 16:59:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (903, 7, '叮咚快递', 'dingdong', '2020-11-23 15:03:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (904, 7, 'Direct Link', 'directlink', '2020-11-22 03:57:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (905, 7, '东瀚物流', 'donghanwl', '2020-11-22 23:38:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (906, 7, '东红物流', 'donghong', '2020-11-17 13:57:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (907, 7, 'DPD UK', 'dpduk', '2020-11-22 19:52:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (908, 7, 'DTDC India', 'dtdcindia', '2020-11-23 14:29:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (909, 7, '东方航空物流', 'ealceair', '2020-11-18 16:30:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (910, 7, 'E跨通', 'ecallturn', '2020-11-19 13:24:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (911, 7, 'EC-Firstclass', 'ecfirstclass', '2020-11-17 19:47:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (912, 7, 'ECMS Express', 'ecmsglobal', '2020-11-20 10:25:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (913, 7, '东西E全运', 'ecotransite', '2020-11-17 20:25:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (914, 7, '厄瓜多尔(Correos del Ecuador)', 'ecuador', '2020-11-17 22:29:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (915, 7, '易达快运', 'edaeuexpress', '2020-11-19 04:11:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (916, 7, '埃及（Egypt Post）', 'egypt', '2020-11-18 03:48:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (917, 7, '艾菲尔国际速递', 'eiffel', '2020-11-23 06:05:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (918, 7, '希腊包裹（ELTA Hellenic Post）', 'elta', '2020-11-17 01:20:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (919, 7, '希腊EMS（ELTA Courier）', 'eltahell', '2020-11-19 09:27:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (920, 7, '阿联酋(Emirates Post)', 'emirates', '2020-11-21 21:36:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (921, 7, '波兰小包(Poczta Polska)', 'emonitoring', '2020-11-20 11:18:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (922, 7, '乌克兰EMS(EMS Ukraine)', 'emsukraine', '2020-11-19 16:43:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (923, 7, '乌克兰EMS-中文(EMS Ukraine)', 'emsukrainecn', '2020-11-20 02:41:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (924, 7, '联众国际', 'epspost', '2020-11-17 13:36:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (925, 7, 'Estafeta', 'estafeta', '2020-11-17 11:36:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (926, 7, 'Estes', 'estes', '2020-11-17 18:14:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (927, 7, '易达国际速递', 'eta100', '2020-11-19 09:21:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (928, 7, 'ETEEN专线', 'eteenlog', '2020-11-19 18:24:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (929, 7, '埃塞俄比亚(Ethiopian postal)', 'ethiopia', '2020-11-23 16:54:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (930, 7, '中欧国际物流', 'eucnrail', '2020-11-21 10:21:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (931, 7, '德国 EUC POST', 'eucpost', '2020-11-19 02:01:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (932, 7, '败欧洲', 'europe8', '2020-11-21 02:44:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (933, 7, '澳洲新干线快递', 'expressplus', '2020-11-17 11:18:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (934, 7, '易转运', 'ezhuanyuan', '2020-11-20 22:35:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (935, 7, '颿达国际快递-英文', 'fandaguoji', '2020-11-21 10:43:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (936, 7, '颿达国际快递', 'fardarww', '2020-11-20 12:11:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (937, 7, '加拿大联通快运', 'fastontime', '2020-11-21 05:43:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (938, 7, 'Fastway Ireland', 'fastway', '2020-11-20 18:23:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (939, 7, '正途供应链', 'fastzt', '2020-11-23 03:46:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (940, 7, 'FedEx-英国件（FedEx UK)', 'fedexuk', '2020-11-22 15:23:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (941, 7, 'FedEx-英国件', 'fedexukcn', '2020-11-19 19:56:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (942, 7, '凤凰快递', 'fenghuangkuaidi', '2020-11-21 05:10:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (943, 7, '丰羿', 'fengyee', '2020-11-22 16:21:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (944, 7, '斐济(Fiji Post)', 'fiji', '2020-11-18 21:58:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (945, 7, '芬兰(Itella Posti Oy)', 'finland', '2020-11-23 11:04:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (946, 7, '花瓣转运', 'flowerkd', '2020-11-22 18:26:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (947, 7, '四方格', 'fourpxus', '2020-11-19 13:19:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (948, 7, '法翔速运', 'ftlexpress', '2020-11-19 10:57:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (949, 7, '飞云快递系统', 'fyex', '2020-11-21 15:47:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (950, 7, 'Gati-英文', 'gatien', '2020-11-19 01:43:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (951, 7, 'Gati-KWE', 'gatikwe', '2020-11-20 08:55:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (952, 7, '广东诚通物流', 'gdct56', '2020-11-20 17:44:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (953, 7, '全网物流', 'gdqwwl', '2020-11-18 16:18:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (954, 7, '容智快运', 'gdrz58', '2020-11-21 03:55:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (955, 7, '新鹏快递', 'gdxp', '2020-11-18 22:24:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (956, 7, '格鲁吉亚(Georgian Pos）', 'georgianpost', '2020-11-21 03:56:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (957, 7, '环创物流', 'ghl', '2020-11-18 04:06:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (958, 7, 'GHT物流', 'ghtexpress', '2020-11-17 08:23:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (959, 7, '直布罗陀[英国]( Royal Gibraltar Post)', 'gibraltar', '2020-11-22 05:18:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (960, 7, '英脉物流', 'gml', '2020-11-21 06:21:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (961, 7, '格陵兰[丹麦]（TELE Greenland A/S）', 'greenland', '2020-11-22 16:50:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (962, 7, '潍鸿', 'grivertek', '2020-11-18 20:47:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (963, 7, '哥士传奇速递', 'gscq365', '2020-11-23 03:44:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (964, 7, '万通快递', 'gswtkd', '2020-11-21 09:18:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (965, 7, 'GT国际快运', 'gtgogo', '2020-11-20 12:21:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (966, 7, 'GTT EXPRESS快递', 'gttexpress', '2020-11-21 10:51:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (967, 7, '冠庭国际物流', 'guanting', '2020-11-21 19:29:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (968, 7, '国送快运', 'guosong', '2020-11-20 19:14:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (969, 7, '宏观国际快递', 'gvpexpress', '2020-11-21 14:41:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (970, 7, '光线速递', 'gxwl', '2020-11-21 18:05:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (971, 7, '海红for买卖宝', 'haihongmmb', '2020-11-20 00:41:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (972, 7, '海星桥快递', 'haixingqiao', '2020-11-17 22:11:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (973, 7, '海中转运', 'haizhongzhuanyun', '2020-11-19 12:31:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (974, 7, '汉邦国际速递', 'handboy', '2020-11-19 22:21:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (975, 7, '翰丰快递', 'hanfengjl', '2020-11-17 04:32:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (976, 7, '亚美尼亚(Haypost-Armenian Postal)', 'haypost', '2020-11-23 01:58:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (977, 7, '汇达物流', 'hdcexpress', '2020-11-19 02:35:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (978, 7, '恒瑞物流', 'hengrui56', '2020-11-23 05:22:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (979, 7, '环国运物流', 'hgy56', '2020-11-21 00:02:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (980, 7, 'Hi淘易快递', 'hitaoe', '2020-11-18 09:03:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (981, 7, '互联快运', 'hlkytj', '2020-11-18 20:52:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (982, 7, '共联配', 'hlpgyl', '2020-11-22 06:12:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (983, 7, '顺时达物流', 'hnssd56', '2020-11-23 20:02:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (984, 7, '中强物流', 'hnzqwl', '2020-11-21 13:15:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (985, 7, '居家通', 'homexpress', '2020-11-19 07:09:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (986, 7, '红背心', 'hongbeixin', '2020-11-21 19:41:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (987, 7, '宏捷国际物流', 'hongjie', '2020-11-20 08:36:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (988, 7, '宏品物流', 'hongpinwuliu', '2020-11-19 08:58:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (989, 7, '皇家云仓', 'hotwms', '2020-11-18 20:02:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (990, 7, '环球通达 ', 'hqtd', '2020-11-19 02:14:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (991, 7, '卓烨快递', 'hrbzykd', '2020-11-22 00:07:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (992, 7, '高铁速递', 'hre', '2020-11-21 21:31:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (993, 7, '克罗地亚（Hrvatska Posta）', 'hrvatska', '2020-11-19 13:36:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (994, 7, '海硕高铁速递', 'hsgtsd', '2020-11-22 03:06:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (995, 7, '海淘物流', 'ht22', '2020-11-21 02:20:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (996, 7, '华通务达物流', 'htwd', '2020-11-22 03:25:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (997, 7, '华达快运', 'huada', '2020-11-23 12:22:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (998, 7, '环东物流', 'huandonglg', '2020-11-20 07:18:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (999, 7, '华夏货运', 'huaxiahuoyun', '2020-11-20 23:02:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1000, 7, '驼峰国际', 'humpline', '2020-11-19 23:36:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1001, 7, '鸿远物流', 'hyeship', '2020-11-20 01:53:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1002, 7, '上海昊宏国际货物', 'hyk', '2020-11-23 11:38:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1003, 7, '华航快递', 'hzpl', '2020-11-19 09:29:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1004, 7, '冰岛(Iceland Post)', 'iceland', '2020-11-23 10:53:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1005, 7, '泛太优达', 'iex', '2020-11-21 06:59:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1006, 7, 'iExpress', 'iexpress', '2020-11-19 03:15:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1007, 7, '无限速递', 'igcaexpress', '2020-11-21 18:59:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1008, 7, 'logen路坚', 'ilogen', '2020-11-20 16:49:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1009, 7, 'ILYANG', 'ilyang', '2020-11-21 04:09:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1010, 7, '艾姆勒', 'imlb2c', '2020-11-19 20:37:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1011, 7, '印度(India Post)', 'india', '2020-11-18 19:37:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1012, 7, '印度尼西亚EMS(Pos Indonesia-EMS)', 'indonesia', '2020-11-17 13:14:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1013, 7, '多米尼加（INPOSDOM – Instituto Postal Dominicano）', 'inposdom', '2020-11-21 07:01:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1014, 7, 'Interlink Express', 'interlink', '2020-11-22 23:04:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1015, 7, 'UPS i-parcel', 'iparcel', '2020-11-20 01:56:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1016, 7, '伊朗（Iran Post）', 'iran', '2020-11-21 12:09:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1017, 7, '以色列(Israel Post)', 'israelpost', '2020-11-23 09:17:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1018, 7, 'Italy SDA', 'italysad', '2020-11-21 13:36:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1019, 7, 'jcex', 'jcex', '2020-11-20 17:11:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1020, 7, '泽西岛', 'jerseypost', '2020-11-21 22:05:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1021, 7, '澳速通国际速递', 'jetexpressgroup', '2020-11-23 13:11:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1022, 7, '佳家通货运', 'jiajiatong56', '2020-11-21 03:22:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1023, 7, '锦程物流', 'jinchengwuliu', '2020-11-18 02:15:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1024, 7, '劲通快递', 'jintongkd', '2020-11-17 00:49:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1025, 7, '冀速物流', 'jisu', '2020-11-20 21:03:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1026, 7, '久易快递', 'jiuyicn', '2020-11-22 10:25:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1027, 7, '佳捷翔物流', 'jjx888', '2020-11-18 16:38:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1028, 7, '约旦(Jordan Post)', 'jordan', '2020-11-23 02:16:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1029, 7, '聚物物流', 'juwu', '2020-11-21 14:26:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1030, 7, '聚中大', 'juzhongda', '2020-11-21 18:20:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1031, 7, '考拉国际速递', 'kaolaexpress', '2020-11-20 02:42:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1032, 7, '肯尼亚(POSTA KENYA)', 'kenya', '2020-11-18 07:31:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1033, 7, '启邦国际物流', 'keypon', '2020-11-21 05:11:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1034, 7, '快服务', 'kfwnet', '2020-11-20 07:00:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1035, 7, '跨境直邮通', 'kjde', '2020-11-20 20:25:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1036, 7, '韩国邮政韩文', 'koreapostkr', '2020-11-19 11:27:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1037, 7, '快8速运', 'kuai8', '2020-11-17 21:01:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1038, 7, '快淘快递', 'kuaitao', '2020-11-20 22:24:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1039, 7, '四川快优达速递', 'kuaiyouda', '2020-11-20 04:38:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1040, 7, '凯信达', 'kxda', '2020-11-21 04:59:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1041, 7, '吉尔吉斯斯坦(Kyrgyz Post)', 'kyrgyzpost', '2020-11-21 13:18:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1042, 7, '跨跃国际', 'kyue', '2020-11-20 05:53:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1043, 7, '蓝弧快递', 'lanhukuaidi', '2020-11-19 14:33:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1044, 7, '老挝(Lao Express) ', 'lao', '2020-11-20 08:05:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1045, 7, '塞内加尔', 'laposte', '2020-11-18 23:08:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1046, 7, '林安物流', 'lasy56', '2020-11-23 19:02:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1047, 7, '拉脱维亚(Latvijas Pasts)', 'latvia', '2020-11-17 08:06:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1048, 7, '立白宝凯物流', 'lbbk', '2020-11-19 04:25:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1049, 7, '乐递供应链', 'ledii', '2020-11-20 00:05:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1050, 7, '云豹国际货运', 'leopard', '2020-11-18 13:32:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1051, 7, '美联快递', 'letseml', '2020-11-22 19:05:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1052, 7, 'lazada', 'lgs', '2020-11-20 11:51:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1053, 7, '联合速递', 'lhexpressus', '2020-11-17 02:58:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1054, 7, 'Linex', 'linex', '2020-11-21 01:35:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1055, 7, '丽狮物流', 'lishi', '2020-11-23 02:43:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1056, 7, '立陶宛（Lietuvos pa?tas）', 'lithuania', '2020-11-21 12:30:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1057, 7, '華信物流WTO', 'logistics', '2020-11-21 07:21:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1058, 7, '长风物流', 'longvast', '2020-11-18 01:33:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1059, 7, '乐天速递', 'ltexp', '2020-11-23 08:02:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1060, 7, '联通快递', 'ltparcel', '2020-11-17 17:54:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1061, 7, '论道国际物流', 'lundao', '2020-11-22 14:22:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1062, 7, '鲁通快运', 'lutong', '2020-11-21 23:08:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1063, 7, '麦力快递', 'mailikuaidi', '2020-11-18 02:54:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1064, 7, '马尔代夫(Maldives Post)', 'maldives', '2020-11-21 15:24:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1065, 7, '马耳他（Malta Post）', 'malta', '2020-11-23 00:01:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1066, 7, '芒果速递', 'mangguo', '2020-11-19 05:30:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1067, 7, '今枫国际快运', 'mapleexpress', '2020-11-17 03:10:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1068, 7, '木春货运', 'mchy', '2020-11-17 22:59:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1069, 7, '美邦国际快递', 'meibang', '2020-11-21 10:23:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1070, 7, '美达快递', 'meidaexpress', '2020-11-22 10:40:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1071, 7, '美泰物流', 'meitai', '2020-11-17 01:53:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1072, 7, '墨西哥（Correos de Mexico）', 'mexico', '2020-11-21 22:21:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1073, 7, 'Mexico Senda Express', 'mexicodenda', '2020-11-20 15:09:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1074, 7, '银河物流', 'milkyway', '2020-11-20 09:41:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1075, 7, '美龙快递', 'mjexp', '2020-11-23 03:57:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1076, 7, '摩尔多瓦(Posta Moldovei)', 'moldova', '2020-11-23 18:25:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1077, 7, '蒙古国(Mongol Post) ', 'mongolpost', '2020-11-18 11:51:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1078, 7, '黑山(Posta Crne Gore)', 'montenegro', '2020-11-18 02:20:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1079, 7, '摩洛哥 ( Morocco Post )', 'morocco', '2020-11-18 01:07:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1080, 7, 'MRW', 'mrw', '2020-11-18 23:37:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1081, 7, 'Mexico Multipack', 'multipack', '2020-11-23 19:44:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1082, 7, '中俄速通（淼信）', 'mxe56', '2020-11-17 10:08:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1083, 7, '新亚物流', 'nalexpress', '2020-11-19 12:28:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1084, 7, '纳米比亚(NamPost)', 'namibia', '2020-11-21 10:18:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1085, 7, '红马速递', 'nedahm', '2020-11-17 17:43:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1086, 7, '尼泊尔（Nepal Postal Services）', 'nepalpost', '2020-11-21 08:04:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1087, 7, '尼日利亚(Nigerian Postal)', 'nigerianpost', '2020-11-22 14:49:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1088, 7, '牛仔速运', 'niuzaiexpress', '2020-11-18 05:35:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1089, 7, '亚欧专线', 'nlebv', '2020-11-20 05:46:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1090, 7, '华赫物流', 'nmhuahe', '2020-11-22 14:26:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1091, 7, '诺尔国际物流', 'nuoer', '2020-11-21 10:30:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1092, 7, '偌亚奥国际快递', 'nuoyaao', '2020-11-22 10:12:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1093, 7, 'OCA Argentina', 'ocaargen', '2020-11-16 23:12:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1094, 7, 'OC-Post', 'ocpost', '2020-11-21 10:21:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1095, 7, '爱沙尼亚(Eesti Post)', 'omniva', '2020-11-18 11:12:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1096, 7, '昂威物流', 'onway', '2020-11-18 00:34:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1097, 7, 'OPEK', 'opek', '2020-11-17 18:15:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1098, 7, '波音速递', 'overseaex', '2020-11-17 18:32:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1099, 7, '巴基斯坦(Pakistan Post)', 'pakistan', '2020-11-18 14:55:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1100, 7, '巴拉圭(Correo Paraguayo)', 'paraguay', '2020-11-22 20:00:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1101, 7, '诚一物流', 'parcelchina', '2020-11-20 12:15:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1102, 7, '英国邮政大包EMS', 'parcelforcecn', '2020-11-17 02:13:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1103, 7, '顺捷美中速递', 'passerbyaexpress', '2020-11-20 20:40:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1104, 7, '派尔快递', 'peex', '2020-11-22 04:22:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1105, 7, '陪行物流', 'peixingwuliu', '2020-11-17 11:29:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1106, 7, '秘鲁(SERPOST)', 'peru', '2020-11-17 18:41:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1107, 7, '品信快递', 'pinxinkuaidi', '2020-11-19 11:57:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1108, 7, '先锋国际快递', 'pioneer', '2020-11-20 06:01:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1109, 7, '龙行天下', 'pmt0704be', '2020-11-18 20:37:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1110, 7, 'Portugal Seur', 'portugalseur', '2020-11-23 12:40:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1111, 7, '坦桑尼亚（Tanzania Posts Corporation）', 'posta', '2020-11-23 06:27:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1112, 7, 'PostElbe', 'postelbe', '2020-11-21 20:38:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1113, 7, 'PostNord(Posten AB)', 'postenab', '2020-11-22 12:46:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1114, 7, '挪威（Posten Norge）', 'postennorge', '2020-11-23 04:19:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1115, 7, '巴布亚新几内亚(PNG Post)', 'postpng', '2020-11-17 10:57:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1116, 7, '雪域快递', 'qhxykd', '2020-11-21 14:47:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1117, 7, '千里速递', 'qianli', '2020-11-17 22:05:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1118, 7, 'Quantium', 'quantium', '2020-11-21 16:25:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1119, 7, '全通快运', 'quantwl', '2020-11-23 19:31:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1120, 7, '全之鑫物流', 'qzx56', '2020-11-23 03:57:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1121, 7, 'Red Express', 'redexpress', '2020-11-20 11:34:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1122, 7, '叙利亚(Syrian Post)', 'republic', '2020-11-22 21:37:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1123, 7, '睿和泰速运', 'rhtexpress', '2020-11-22 05:04:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1124, 7, '日昱物流', 'riyuwuliu', '2020-11-18 10:48:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1125, 7, '罗马尼亚（Posta Romanian）', 'romanian', '2020-11-22 13:11:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1126, 7, '卢旺达(Rwanda i-posita)', 'rwanda', '2020-11-19 14:28:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1127, 7, 'Safexpress', 'safexpress', '2020-11-20 08:27:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1128, 7, '萨摩亚(Samoa Post)', 'samoa', '2020-11-19 01:13:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1129, 7, '沙特阿拉伯(Saudi Post)', 'saudipost', '2020-11-17 05:44:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1130, 7, '中加国际快递', 'scic', '2020-11-19 00:39:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1131, 7, '速佳达快运', 'scsujiada', '2020-11-19 12:25:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1132, 7, '速呈', 'sczpds', '2020-11-23 13:07:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1133, 7, '首达速运', 'sdsy888', '2020-11-21 09:19:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1134, 7, 'Selektvracht', 'selektvracht', '2020-11-19 08:13:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1135, 7, 'International Seur', 'seur', '2020-11-22 12:48:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1136, 7, '澳丰速递', 'sfau', '2020-11-23 19:03:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1137, 7, '曹操到', 'sfpost', '2020-11-20 12:29:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1138, 7, '衫达快运', 'shanda56', '2020-11-21 04:56:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1139, 7, '上海无疆for买卖宝', 'shanghaiwujiangmmb', '2020-11-20 13:34:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1140, 7, '尚途国际货运', 'shangtuguoji', '2020-11-22 06:00:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1141, 7, '捎客物流', 'shaoke', '2020-11-18 17:01:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1142, 7, '杰响物流', 'shbwch', '2020-11-23 17:24:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1143, 7, '商海德物流', 'shd56', '2020-11-17 18:17:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1144, 7, '盛通快递', 'shengtongscm', '2020-11-21 12:14:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1145, 7, '神骏物流', 'shenjun', '2020-11-23 09:57:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1146, 7, '王牌快递', 'shipbyace', '2020-11-21 16:44:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1147, 7, '苏豪快递', 'shipsoho', '2020-11-21 06:50:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1148, 7, '世运快递', 'shiyunkuaidi', '2020-11-17 10:18:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1149, 7, '顺邦国际物流', 'shunbang', '2020-11-20 05:18:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1150, 7, '顺士达速运', 'shunshid', '2020-11-17 23:16:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1151, 7, '四海快递', 'sihaiet', '2020-11-19 04:05:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1152, 7, '四海捷运', 'sihiexpress', '2020-11-18 00:59:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1153, 7, 'Siodemka', 'siodemka', '2020-11-22 16:20:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1154, 7, '易普递', 'sixroad', '2020-11-21 11:44:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1155, 7, 'skynetworldwide', 'skynetworldwide', '2020-11-22 10:37:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1156, 7, '荷兰Sky Post', 'skypost', '2020-11-23 20:15:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1157, 7, '斯洛伐克(Slovenská Posta)', 'slovak', '2020-11-21 01:04:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1158, 7, '嗖一下同城快递', 'sofast56', '2020-11-23 16:17:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1159, 7, '行必达', 'speeda', '2020-11-17 11:11:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1160, 7, '首通快运', 'staky', '2020-11-20 04:03:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1161, 7, '星速递', 'starex', '2020-11-17 14:22:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1162, 7, '星运快递', 'staryvr', '2020-11-17 11:22:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1163, 7, '智德物流', 'stzd56', '2020-11-17 14:42:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1164, 7, '速豹', 'subaoex', '2020-11-18 16:24:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1165, 7, '速呈宅配', 'sucheng', '2020-11-23 14:57:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1166, 7, '特急便物流', 'sucmj', '2020-11-17 07:50:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1167, 7, '速风快递', 'sufengkuaidi', '2020-11-19 15:18:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1168, 7, '郑州速捷', 'sujievip', '2020-11-22 07:23:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1169, 7, '速品快递', 'supinexpress', '2020-11-21 18:42:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1170, 7, '深圳DPEX', 'szdpex', '2020-11-18 01:37:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1171, 7, '泰进物流', 'taijin', '2020-11-21 22:23:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1172, 7, '天美快递', 'taimek', '2020-11-17 16:02:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1173, 7, '坦桑尼亚(Tanzania Posts)', 'tanzania', '2020-11-19 11:22:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1174, 7, 'TCI XPS', 'tcixps', '2020-11-20 11:02:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1175, 7, 'TCXB国际物流', 'tcxbthai', '2020-11-19 23:24:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1176, 7, 'TD Cargo', 'tdcargo', '2020-11-21 12:55:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1177, 7, '加拿大雷霆快递', 'thunderexpress', '2020-11-23 20:45:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1178, 7, '天纵物流', 'tianzong', '2020-11-23 20:37:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1179, 7, '株式会社T.M.G', 'tmg', '2020-11-23 19:11:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1180, 7, 'TNT Italy', 'tntitaly', '2020-11-23 12:23:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1181, 7, 'TNT Post', 'tntpostcn', '2020-11-22 06:43:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1182, 7, 'TNY物流', 'tny', '2020-11-23 21:28:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1183, 7, '顶世国际物流', 'topshey', '2020-11-21 18:48:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1184, 7, '突尼斯EMS(Rapid-Poste)', 'tunisia', '2020-11-20 06:36:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1185, 7, '海龟国际快递', 'turtle', '2020-11-19 01:36:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1186, 7, '天翼物流', 'tywl99', '2020-11-17 13:13:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1187, 7, 'UEX国际物流', 'uex', '2020-11-20 12:55:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1188, 7, '欧洲UEX', 'uexiex', '2020-11-19 04:38:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1189, 7, '乌干达(Posta Uganda)', 'uganda', '2020-11-17 09:26:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1190, 7, '邮鸽速运', 'ugoexpress', '2020-11-19 08:55:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1191, 7, 'UPS Freight', 'upsfreight', '2020-11-20 18:37:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1192, 7, 'UPS Mail Innovations', 'upsmailinno', '2020-11-21 20:40:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1193, 7, 'USPSCN', 'uspscn', '2020-11-23 01:47:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1194, 7, 'UTAO优到', 'utaoscm', '2020-11-18 22:36:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1195, 7, '瓦努阿图(Vanuatu Post)', 'vanuatu', '2020-11-22 09:59:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1196, 7, '越中国际物流', 'vctrans', '2020-11-17 11:09:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1197, 7, '宁夏万家通', 'wanjiatong', '2020-11-17 00:07:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1198, 7, '万达美', 'wdm', '2020-11-22 14:48:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1199, 7, '文捷航空', 'wenjiesudi', '2020-11-17 08:00:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1200, 7, '威速递', 'wexpress', '2020-11-22 16:36:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1201, 7, '香港伟豪国际物流', 'whgjkd', '2020-11-23 16:01:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1202, 7, '万邑通', 'winit', '2020-11-19 09:57:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1203, 7, '凡仕特物流', 'wlfast', '2020-11-23 00:01:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1204, 7, 'WTD海外通', 'wtdex', '2020-11-18 23:15:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1205, 7, '万运国际快递', 'wygj168', '2020-11-22 18:34:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1206, 7, '国晶物流', 'xdshipping', '2020-11-19 04:01:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1207, 7, '西安城联速递', 'xianchengliansudi', '2020-11-17 12:05:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1208, 7, '湘达物流', 'xiangdawuliu', '2020-11-20 00:01:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1209, 7, '翔腾物流', 'xiangteng', '2020-11-23 14:09:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1210, 7, '小C海淘', 'xiaocex', '2020-11-20 03:45:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1211, 7, '西安喜来快递', 'xilaikd', '2020-11-19 23:57:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1212, 7, '新元快递', 'xingyuankuaidi', '2020-11-22 13:30:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1213, 7, '新宁物流', 'xinning', '2020-11-21 23:17:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1214, 7, '西邮寄', 'xipost', '2020-11-18 06:16:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1215, 7, '鑫通宝物流', 'xtb', '2020-11-22 07:50:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1216, 7, '一辉物流', 'yatfai', '2020-11-19 01:21:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1217, 7, 'YCG物流', 'ycgglobal', '2020-11-18 06:54:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1218, 7, '易达丰国际速递', 'ydfexpress', '2020-11-17 07:26:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1219, 7, '也门(Yemen Post)', 'yemen', '2020-11-21 16:10:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1220, 7, '一邦速递', 'yibangwuliu', '2020-11-18 15:32:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1221, 7, '驿递汇速递', 'yidihui', '2020-11-18 04:50:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1222, 7, '易航物流', 'yihangmall', '2020-11-18 02:34:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1223, 7, '宜送', 'yisong', '2020-11-18 23:19:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1224, 7, '易通达', 'yitongda', '2020-11-23 13:52:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1225, 7, '邮来速递', 'youlai', '2020-11-23 04:24:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1226, 7, '运通快运', 'ytky168', '2020-11-21 06:44:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1227, 7, '远盾物流', 'yuandun', '2020-11-19 21:27:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1228, 7, '粤中国际货运代理（上海）有限公司', 'yuezhongsh', '2020-11-18 16:03:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1229, 7, '御风速运', 'yufeng', '2020-11-23 15:37:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1230, 7, '德国云快递', 'yunexpress', '2020-11-17 12:13:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1231, 7, '远为快递', 'ywexpress', '2020-11-20 11:13:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1232, 7, '众辉达物流', 'zhdwl', '2020-11-18 23:09:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1233, 7, '众川国际', 'zhongchuan', '2020-11-23 09:46:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1234, 7, '振捷国际货运', 'zjgj56', '2020-11-22 08:23:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1235, 8, '百世快递', 'HTKY', '2020-11-17 14:56:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1236, 8, '中通快递', 'ZTO', '2020-11-17 23:51:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1237, 8, '申通快递', 'STO', '2020-11-20 03:27:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1238, 8, '圆通速递', 'YTO', '2020-11-22 20:00:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1239, 8, '韵达速递', 'YD', '2020-11-22 21:22:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1240, 8, '邮政快递包裹', 'YZPY', '2020-11-22 01:09:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1241, 8, 'EMS', 'EMS', '2020-11-17 15:58:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1242, 8, '天天快递', 'HHTT', '2020-11-19 02:45:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1243, 8, '京东快递', 'JD', '2020-11-18 16:09:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1244, 8, '优速快递', 'UC', '2020-11-19 01:29:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1245, 8, '德邦快递', 'DBL', '2020-11-22 07:59:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1246, 8, '宅急送', 'ZJS', '2020-11-23 15:10:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1247, 8, '安捷快递', 'AJ', '2020-11-20 07:31:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1248, 8, '阿里跨境电商物流', 'ALKJWL', '2020-11-20 15:45:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1249, 8, '安迅物流', 'AX', '2020-11-18 10:32:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1250, 8, '安邮美国', 'AYUS', '2020-11-20 05:04:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1251, 8, '亚马逊物流', 'AMAZON', '2020-11-21 20:05:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1252, 8, '澳门邮政', 'AOMENYZ', '2020-11-17 16:52:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1253, 8, '安能物流', 'ANE', '2020-11-19 22:26:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1254, 8, '澳多多', 'ADD', '2020-11-22 15:55:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1255, 8, '澳邮专线', 'AYCA', '2020-11-22 15:55:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1256, 8, '安鲜达', 'AXD', '2020-11-21 10:13:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1257, 8, '安能快运', 'ANEKY', '2020-11-22 04:18:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1258, 8, '澳邦国际', 'ABGJ', '2020-11-22 17:09:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1259, 8, '安得物流', 'ANNTO', '2020-11-23 03:14:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1260, 8, '澳德物流', 'AUODEXPRESS', '2020-11-23 15:00:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1261, 8, '转运四方', 'A4PX', '2020-11-17 21:01:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1262, 8, '八达通  ', 'BDT', '2020-11-22 09:02:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1263, 8, '百腾物流', 'BETWL', '2020-11-20 11:09:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1264, 8, '北极星快运', 'BJXKY', '2020-11-18 05:40:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1265, 8, '奔腾物流', 'BNTWL', '2020-11-19 18:30:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1266, 8, '百福东方', 'BFDF', '2020-11-20 05:51:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1267, 8, '贝海国际 ', 'BHGJ', '2020-11-18 00:07:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1268, 8, '八方安运', 'BFAY', '2020-11-19 06:41:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1269, 8, '百世快运', 'BTWL', '2020-11-18 11:23:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1270, 8, '帮帮发转运', 'BBFZY', '2020-11-17 13:52:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1271, 8, '百城通物流', 'BCTWL', '2020-11-22 10:51:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1272, 8, '春风物流', 'CFWL', '2020-11-21 17:40:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1273, 8, '诚通物流', 'CHTWL', '2020-11-17 10:09:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1274, 8, '传喜物流', 'CXHY', '2020-11-18 20:02:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1275, 8, '城市100', 'CITY100', '2020-11-18 00:03:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1276, 8, '城际快递', 'CJKD', '2020-11-23 11:48:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1277, 8, 'CNPEX中邮快递', 'CNPEX', '2020-11-18 17:11:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1278, 8, 'COE东方快递', 'COE', '2020-11-20 00:50:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1279, 8, '长沙创一', 'CSCY', '2020-11-20 03:00:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1280, 8, '成都善途速运', 'CDSTKY', '2020-11-23 13:27:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1281, 8, '联合运通', 'CTG', '2020-11-19 15:18:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1282, 8, '疯狂快递', 'CRAZY', '2020-11-17 11:46:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1283, 8, 'CBO钏博物流', 'CBO', '2020-11-18 12:36:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1284, 8, '佳吉快运', 'CNEX', '2020-11-23 04:44:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1285, 8, '承诺达', 'CND', '2020-11-22 14:52:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1286, 8, '畅顺通达', 'CSTD', '2020-11-19 14:28:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1287, 8, 'D速物流', 'DSWL', '2020-11-20 03:23:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1288, 8, '到了港', 'DLG ', '2020-11-17 23:50:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1289, 8, '大田物流', 'DTWL', '2020-11-19 12:42:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1290, 8, '东骏快捷物流', 'DNWL', '2020-11-19 18:21:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1291, 8, '德坤', 'DEKUN', '2020-11-23 06:37:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1292, 8, '德邦快运', 'DBLKY', '2020-11-19 07:02:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1293, 8, '大马鹿', 'DML', '2020-11-23 13:39:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1294, 8, '丹鸟物流', 'DNWL', '2020-11-22 04:09:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1295, 8, '东方汇', 'EST365', '2020-11-23 04:50:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1296, 8, 'E特快', 'ETK', '2020-11-18 15:20:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1297, 8, 'EMS国内', 'EMS2', '2020-11-20 12:30:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1298, 8, 'EWE', 'EWE', '2020-11-22 18:53:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1299, 8, 'E通速递', 'ETONG', '2020-11-21 12:33:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1300, 8, '卓志速运', 'ESDEX', '2020-11-22 07:08:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1301, 8, '飞康达', 'FKD', '2020-11-23 00:21:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1302, 8, '富腾达  ', 'FTD', '2020-11-17 08:01:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1303, 8, '凡宇货的', 'FYKD', '2020-11-21 12:00:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1304, 8, '速派快递', 'FASTGO', '2020-11-17 16:59:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1305, 8, '飞豹快递', 'FBKD', '2020-11-20 23:13:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1306, 8, '丰巢', 'FBOX', '2020-11-20 20:49:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1307, 8, '飞狐快递', 'FHKD', '2020-11-17 12:47:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1308, 8, '复融供应链', 'FRGYL', '2020-11-21 23:46:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1309, 8, '飞远配送', 'FYPS', '2020-11-19 13:30:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1310, 8, '凡宇速递', 'FYSD', '2020-11-21 19:53:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1311, 8, '丰通快运', 'FT', '2020-11-19 14:35:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1312, 8, '冠达   ', 'GD', '2020-11-22 12:55:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1313, 8, '广东邮政', 'GDEMS', '2020-11-23 00:32:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1314, 8, '共速达', 'GSD', '2020-11-23 14:15:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1315, 8, '广通       ', 'GTONG', '2020-11-18 01:20:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1316, 8, '冠达快递', 'GDKD', '2020-11-23 08:53:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1317, 8, '挂号信', 'GHX', '2020-11-17 22:45:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1318, 8, '广通速递', 'GTKD', '2020-11-23 12:07:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1319, 8, '高铁快运', 'GTKY', '2020-11-18 22:38:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1320, 8, '迦递快递', 'GAI', '2020-11-21 03:09:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1321, 8, '港快速递', 'GKSD', '2020-11-17 23:30:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1322, 8, '高铁速递', 'GTSD', '2020-11-23 10:25:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1323, 8, '黑狗冷链', 'HGLL', '2020-11-18 11:54:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1324, 8, '恒路物流', 'HLWL', '2020-11-19 02:34:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1325, 8, '天地华宇', 'HOAU', '2020-11-23 02:07:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1326, 8, '鸿桥供应链', 'HOTSCM', '2020-11-20 07:54:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1327, 8, '海派通物流公司', 'HPTEX', '2020-11-22 08:49:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1328, 8, '华强物流', 'hq568', '2020-11-20 00:05:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1329, 8, '环球速运  ', 'HQSY', '2020-11-22 21:37:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1330, 8, '华夏龙物流', 'HXLWL', '2020-11-23 15:31:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1331, 8, '河北建华', 'HBJH', '2020-11-18 16:22:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1332, 8, '汇丰物流', 'HF', '2020-11-19 09:37:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1333, 8, '华航快递', 'HHKD', '2020-11-17 01:19:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1334, 8, '华翰物流', 'HHWL', '2020-11-17 01:26:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1335, 8, '黄马甲快递', 'DNWL', '2020-11-17 04:13:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1336, 8, '海盟速递', 'HMSD', '2020-11-17 17:46:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1337, 8, '华企快运', 'HQKY', '2020-11-20 05:10:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1338, 8, '昊盛物流', 'HSWL', '2020-11-17 00:12:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1339, 8, '鸿泰物流', 'HTWL', '2020-11-21 07:51:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1340, 8, '豪翔物流 ', 'HXWL', '2020-11-17 19:40:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1341, 8, '合肥汇文', 'HFHW', '2020-11-22 01:05:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1342, 8, '辉隆物流', 'HLONGWL', '2020-11-18 23:27:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1343, 8, '华企快递', 'HQKD', '2020-11-18 17:39:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1344, 8, '韩润物流', 'HRWL', '2020-11-19 18:56:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1345, 8, '青岛恒通快递', 'HTKD', '2020-11-18 20:02:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1346, 8, '货运皇物流', 'HYH', '2020-11-17 20:20:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1347, 8, '好来运快递', 'HLYSD', '2020-11-22 17:17:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1348, 8, '皇家物流', 'HJWL', '2020-11-22 06:25:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1349, 8, '海信物流', 'HISENSE', '2020-11-19 06:33:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1350, 8, '汇森速运', 'HSSY', '2020-11-19 13:12:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1351, 8, '徽托邦物流', 'HTB56', '2020-11-22 23:19:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1352, 8, '捷安达  ', 'JAD', '2020-11-18 09:58:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1353, 8, '京广速递', 'JGSD', '2020-11-20 02:12:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1354, 8, '九曳供应链', 'JIUYE', '2020-11-21 07:28:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1355, 8, '急先达', 'JXD', '2020-11-22 09:05:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1356, 8, '晋越快递', 'JYKD', '2020-11-17 02:42:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1357, 8, '佳成国际', 'JCEX', '2020-11-22 07:13:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1358, 8, '捷特快递', 'JTKD', '2020-11-22 09:02:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1359, 8, '精英速运', 'JYSY', '2020-11-21 01:47:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1360, 8, '加运美', 'JYM', '2020-11-21 06:51:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1361, 8, '景光物流', 'JGWL', '2020-11-19 07:13:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1362, 8, '佳怡物流', 'JYWL', '2020-11-22 15:12:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1363, 8, '京东快运', 'JDKY', '2020-11-17 11:23:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1364, 8, '金大物流', 'JDWL', '2020-11-23 08:18:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1365, 8, '极兔速递', 'JTSD', '2020-11-19 13:40:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1366, 8, '跨越速运', 'KYSY', '2020-11-17 19:05:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1367, 8, '快服务', 'KFW', '2020-11-20 06:08:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1368, 8, '快速递物流', 'KSDWL', '2020-11-17 01:04:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1369, 8, '康力物流', 'KLWL', '2020-11-21 09:17:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1370, 8, '快淘快递', 'KTKD', '2020-11-18 00:13:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1371, 8, '快优达速递', 'KYDSD', '2020-11-22 19:32:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1372, 8, '跨越物流', 'KYWL', '2020-11-22 06:04:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1373, 8, '快8速运', 'KBSY', '2020-11-18 22:01:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1374, 8, '龙邦快递', 'LB', '2020-11-17 19:33:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1375, 8, '蓝弧快递', 'LHKD', '2020-11-22 07:21:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1376, 8, '乐捷递', 'LJD', '2020-11-20 07:06:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1377, 8, '立即送', 'LJS', '2020-11-17 14:28:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1378, 8, '联昊通速递', 'LHT', '2020-11-17 02:40:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1379, 8, '民邦快递', 'MB', '2020-11-22 17:37:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1380, 8, '民航快递', 'MHKD', '2020-11-17 14:27:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1381, 8, '美快    ', 'MK', '2020-11-23 16:24:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1382, 8, '门对门快递', 'MDM', '2020-11-20 20:59:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1383, 8, '迈达', 'MD', '2020-11-23 07:20:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1384, 8, '闽盛快递', 'MSKD', '2020-11-23 01:26:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1385, 8, '迈隆递运', 'MRDY', '2020-11-21 11:29:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1386, 8, '明亮物流', 'MLWL', '2020-11-21 06:06:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1387, 8, '南方传媒物流', 'NFCM', '2020-11-17 22:22:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1388, 8, '南京晟邦物流', 'NJSBWL', '2020-11-22 19:54:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1389, 8, '能达速递', 'NEDA', '2020-11-22 13:21:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1390, 8, '平安达腾飞快递', 'PADTF', '2020-11-20 09:27:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1391, 8, '泛捷快递', 'PANEX', '2020-11-17 08:08:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1392, 8, '品骏快递', 'PJ', '2020-11-22 10:42:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1393, 8, '陪行物流', 'PXWL', '2020-11-22 10:05:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1394, 8, 'PCA Express', 'PCA', '2020-11-20 20:39:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1395, 8, '全晨快递', 'QCKD', '2020-11-20 01:59:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1396, 8, '全日通快递', 'QRT', '2020-11-20 20:57:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1397, 8, '快客快递', 'QUICK', '2020-11-20 05:08:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1398, 8, '全信通', 'QXT', '2020-11-21 11:51:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1399, 8, '七曜中邮', 'QYZY', '2020-11-22 22:09:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1400, 8, '如风达', 'RFD', '2020-11-19 06:51:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1401, 8, '荣庆物流', 'RQ', '2020-11-17 15:30:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1402, 8, '日日顺物流', 'RRS', '2020-11-20 08:35:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1403, 8, '日昱物流', 'RLWL', '2020-11-18 00:05:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1404, 8, '瑞丰速递', 'RFEX', '2020-11-18 22:22:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1405, 8, '赛澳递', 'SAD', '2020-11-23 16:35:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1406, 8, '苏宁物流', 'SNWL', '2020-11-23 20:49:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1407, 8, '圣安物流', 'SAWL', '2020-11-17 10:01:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1408, 8, '晟邦物流', 'DNWL', '2020-11-19 08:35:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1409, 8, '上大物流', 'SDWL', '2020-11-20 15:14:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1410, 8, '盛丰物流', 'SFWL', '2020-11-21 04:44:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1411, 8, '速通物流', 'ST', '2020-11-20 04:17:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1412, 8, '速腾快递', 'STWL', '2020-11-20 08:12:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1413, 8, '速必达物流', 'SUBIDA', '2020-11-17 06:30:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1414, 8, '速递e站', 'SDEZ', '2020-11-22 06:15:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1415, 8, '速呈宅配', 'SCZPDS', '2020-11-21 16:46:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1416, 8, '速尔快递', 'SURE', '2020-11-17 19:23:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1417, 8, '山东海红', 'SDHH', '2020-11-20 20:59:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1418, 8, '顺丰国际', 'SFGJ', '2020-11-20 02:25:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1419, 8, '盛辉物流', 'SHWL', '2020-11-20 22:10:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1420, 8, '穗佳物流', 'SJWL', '2020-11-20 09:53:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1421, 8, '三态速递', 'STSD', '2020-11-22 07:56:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1422, 8, '山西红马甲', 'SXHMJ', '2020-11-19 13:42:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1423, 8, '世运快递', 'SYKD', '2020-11-20 20:23:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1424, 8, '闪送', 'SS', '2020-11-21 15:07:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1425, 8, '盛通快递', 'STKD', '2020-11-21 16:46:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1426, 8, '郑州速捷', 'SJ', '2020-11-19 16:49:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1427, 8, '顺心捷达', 'SX', '2020-11-23 09:28:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1428, 8, '商桥物流', 'SQWL', '2020-11-20 01:52:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1429, 8, '佳旺达物流', 'SYJWDX', '2020-11-20 04:35:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1430, 8, '速递中国', 'SENDCN', '2020-11-23 18:18:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1431, 8, '台湾邮政', 'TAIWANYZ', '2020-11-20 10:47:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1432, 8, '唐山申通', 'TSSTO', '2020-11-20 22:41:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1433, 8, '特急送', 'TJS', '2020-11-19 11:25:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1434, 8, '通用物流', 'TYWL', '2020-11-17 14:02:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1435, 8, '华宇物流', 'TDHY', '2020-11-19 11:34:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1436, 8, '通和天下', 'THTX', '2020-11-20 18:03:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1437, 8, '腾林物流', 'TLWL', '2020-11-21 09:52:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1438, 8, '泰捷达物流', 'TJDGJWL', '2020-11-20 21:34:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1439, 8, '全一快递', 'UAPEX', '2020-11-23 07:11:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1440, 8, 'UBI', 'UBI', '2020-11-22 22:56:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1441, 8, 'UEQ Express', 'UEQ', '2020-11-20 23:24:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1442, 8, '美国快递', 'USEX', '2020-11-19 01:12:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1443, 8, '万家康  ', 'WJK', '2020-11-22 07:30:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1444, 8, '万家物流', 'WJWL', '2020-11-23 13:34:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1445, 8, '武汉同舟行', 'WHTZX', '2020-11-20 00:57:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1446, 8, '维普恩', 'WPE', '2020-11-19 11:46:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1447, 8, '中粮我买网', 'WM', '2020-11-20 08:59:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1448, 8, '万象物流', 'DNWL', '2020-11-19 11:57:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1449, 8, '微特派', 'WTP', '2020-11-19 09:49:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1450, 8, '温通物流', 'WTWL', '2020-11-21 14:13:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1451, 8, '文捷航空速递', 'WJEXPRESS', '2020-11-18 21:18:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1452, 8, '迅驰物流  ', 'XCWL', '2020-11-19 15:33:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1453, 8, '信丰物流', 'XFEX', '2020-11-17 16:08:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1454, 8, '希优特', 'XYT', '2020-11-19 09:43:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1455, 8, '新邦物流', 'XBWL', '2020-11-20 02:29:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1456, 8, '祥龙运通', 'XLYT', '2020-11-18 09:38:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1457, 8, '新杰物流', 'XJ', '2020-11-21 16:22:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1458, 8, '晓毕物流', 'XIAOBI', '2020-11-22 08:37:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1459, 8, '迅达速递', 'XDEXPRESS', '2020-11-22 20:17:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1460, 8, '源安达快递', 'YAD', '2020-11-23 05:53:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1461, 8, '远成物流', 'YCWL', '2020-11-23 18:57:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1462, 8, '远成快运', 'YCSY', '2020-11-18 08:46:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1463, 8, '义达国际物流', 'YDH', '2020-11-17 09:17:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1464, 8, '易达通  ', 'YDT', '2020-11-21 19:47:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1465, 8, '原飞航物流', 'YFHEX', '2020-11-19 04:04:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1466, 8, '亚风快递', 'YFSD', '2020-11-20 08:38:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1467, 8, '运通快递', 'YTKD', '2020-11-20 09:17:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1468, 8, '亿翔快递', 'YXKD', '2020-11-23 21:34:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1469, 8, '运东西网', 'YUNDX', '2020-11-20 12:58:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1470, 8, '壹米滴答', 'YMDD', '2020-11-20 23:47:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1471, 8, '邮政国内标快', 'YZBK', '2020-11-19 10:23:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1472, 8, '一站通速运', 'YZTSY', '2020-11-17 05:34:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1473, 8, '驭丰速运', 'YFSUYUN', '2020-11-17 20:19:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1474, 8, '余氏东风', 'YSDF', '2020-11-20 13:54:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1475, 8, '耀飞快递', 'YF', '2020-11-18 12:11:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1476, 8, '韵达快运', 'YDKY', '2020-11-20 18:54:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1477, 8, '云路', 'YL', '2020-11-17 13:35:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1478, 8, '邮必佳', 'YBJ', '2020-11-22 09:36:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1479, 8, '越丰物流', 'YFEX', '2020-11-21 12:12:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1480, 8, '银捷速递', 'YJSD', '2020-11-23 09:14:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1481, 8, '优联吉运', 'YLJY', '2020-11-21 13:15:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1482, 8, '亿领速运', 'YLSY', '2020-11-20 15:31:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1483, 8, '英脉物流', 'YMWL', '2020-11-21 14:52:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1484, 8, '亿顺航', 'YSH', '2020-11-22 06:07:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1485, 8, '音素快运', 'YSKY', '2020-11-22 12:20:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1486, 8, '易通达', 'YTD', '2020-11-21 21:39:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1487, 8, '一统飞鸿', 'YTFH', '2020-11-18 01:34:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1488, 8, '圆通国际', 'YTOGJ', '2020-11-21 13:13:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1489, 8, '宇鑫物流', 'YXWL', '2020-11-22 17:03:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1490, 8, '包裹/平邮/挂号信', 'YZGN', '2020-11-18 01:14:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1491, 8, '一智通', 'YZT', '2020-11-19 01:23:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1492, 8, '优拜物流', 'YBWL', '2020-11-17 05:32:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1493, 8, '一路发物流', 'YLFWL', '2020-11-18 23:12:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1494, 8, '云聚物流', 'YJWL', '2020-11-19 05:44:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1495, 8, '增益快递', 'ZENY', '2020-11-22 08:04:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1496, 8, '中睿速递', 'ZRSD', '2020-11-23 02:50:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1497, 8, '中铁快运', 'ZTKY', '2020-11-17 17:36:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1498, 8, '中天万运', 'ZTWY', '2020-11-23 04:29:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1499, 8, '中外运速递', 'ZWYSD', '2020-11-17 23:57:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1500, 8, '澳转运', 'ZY_AZY', '2020-11-17 08:40:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1501, 8, '八达网', 'ZY_BDA', '2020-11-22 19:07:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1502, 8, '贝易购', 'ZY_BYECO', '2020-11-17 03:56:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1503, 8, '赤兔马转运', 'ZY_CTM', '2020-11-21 07:20:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1504, 8, 'CUL中美速递', 'ZY_CUL', '2020-11-17 05:51:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1505, 8, 'ETD', 'ZY_ETD', '2020-11-19 05:36:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1506, 8, '风驰快递', 'ZY_FCKD', '2020-11-20 12:48:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1507, 8, '风雷速递', 'ZY_FLSD', '2020-11-21 01:32:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1508, 8, '皓晨优递', 'ZY_HCYD', '2020-11-19 19:37:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1509, 8, '海带宝', 'ZY_HDB', '2020-11-18 22:27:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1510, 8, '汇丰美中速递', 'ZY_HFMZ', '2020-11-18 06:22:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1511, 8, '豪杰速递', 'ZY_HJSD', '2020-11-17 13:32:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1512, 8, '华美快递', 'ZY_HMKD', '2020-11-23 00:15:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1513, 8, '360hitao转运', 'ZY_HTAO', '2020-11-17 14:57:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1514, 8, '海淘村', 'ZY_HTCUN', '2020-11-22 23:00:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1515, 8, '365海淘客', 'ZY_HTKE', '2020-11-17 04:28:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1516, 8, '华通快运', 'ZY_HTONG', '2020-11-20 22:23:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1517, 8, '海星桥快递', 'ZY_HXKD', '2020-11-22 06:08:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1518, 8, '华兴速运', 'ZY_HXSY', '2020-11-17 15:12:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1519, 8, 'LogisticsY', 'ZY_IHERB', '2020-11-18 07:55:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1520, 8, '领跑者快递', 'ZY_LPZ', '2020-11-21 18:58:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1521, 8, '量子物流', 'ZY_LZWL', '2020-11-23 02:47:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1522, 8, '明邦转运', 'ZY_MBZY', '2020-11-19 08:39:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1523, 8, '美嘉快递', 'ZY_MJ', '2020-11-17 10:36:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1524, 8, '168 美中快递', 'ZY_MZ', '2020-11-19 02:44:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1525, 8, '欧e捷', 'ZY_OEJ', '2020-11-19 08:09:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1526, 8, '欧洲疯', 'ZY_OZF', '2020-11-22 09:35:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1527, 8, '欧洲GO', 'ZY_OZGO', '2020-11-23 03:06:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1528, 8, '全美通', 'ZY_QMT', '2020-11-17 14:27:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1529, 8, 'SCS国际物流', 'ZY_SCS', '2020-11-22 11:57:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1530, 8, 'SOHO苏豪国际', 'ZY_SOHO', '2020-11-21 21:23:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1531, 8, 'Sonic-Ex速递', 'ZY_SONIC', '2020-11-18 01:25:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1532, 8, '通诚美中快递', 'ZY_TCM', '2020-11-21 13:14:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1533, 8, 'TrakPak', 'ZY_TPAK', '2020-11-22 17:38:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1534, 8, '天天海淘', 'ZY_TTHT', '2020-11-18 04:07:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1535, 8, '天泽快递', 'ZY_TZKD', '2020-11-19 14:03:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1536, 8, '迅达快递', 'ZY_XDKD', '2020-11-19 12:11:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1537, 8, '信达速运', 'ZY_XDSY', '2020-11-21 19:49:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1538, 8, '新干线快递', 'ZY_XGX', '2020-11-19 18:10:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1539, 8, '信捷转运', 'ZY_XJ', '2020-11-23 07:03:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1540, 8, '优购快递', 'ZY_YGKD', '2020-11-19 09:45:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1541, 8, '友家速递(UCS)', 'ZY_YJSD', '2020-11-17 03:15:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1542, 8, '云畔网', 'ZY_YPW', '2020-11-17 10:39:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1543, 8, '易送网', 'ZY_YSW', '2020-11-18 20:33:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1544, 8, '中运全速', 'ZYQS', '2020-11-18 01:08:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1545, 8, '中邮物流', 'ZYWL', '2020-11-23 15:40:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1546, 8, '汇强快递', 'ZHQKD', '2020-11-19 09:15:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1547, 8, '众通快递', 'ZTE', '2020-11-22 21:37:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1548, 8, '中通快运', 'ZTOKY', '2020-11-18 13:19:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1549, 8, '中邮快递', 'ZYKD', '2020-11-21 00:04:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1550, 8, '芝麻开门', 'DNWL', '2020-11-18 12:01:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1551, 8, '中骅物流', 'ZHWL', '2020-11-19 11:36:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1552, 8, '中铁物流', 'ZTWL', '2020-11-18 00:15:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1553, 8, '智汇鸟', 'ZHN', '2020-11-21 14:07:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1554, 8, '众邮快递', 'ZYE', '2020-11-23 01:32:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1555, 8, '中环快递', 'ZHONGHUAN', '2020-11-19 16:59:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1556, 8, 'AAE全球专递', 'AAE', '2020-11-19 08:00:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1557, 8, 'ACS雅仕快递', 'ACS', '2020-11-20 14:03:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1558, 8, 'ADP Express Tracking', 'ADP', '2020-11-21 00:32:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1559, 8, '安圭拉邮政', 'ANGUILAYOU', '2020-11-19 10:53:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1560, 8, 'APAC', 'APAC', '2020-11-17 05:50:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1561, 8, 'Aramex', 'ARAMEX', '2020-11-17 20:11:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1562, 8, '奥地利邮政', 'AT', '2020-11-20 12:24:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1563, 8, 'AOL（澳通）', 'AOL', '2020-11-18 05:09:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1564, 8, 'Australia Post Tracking', 'AUSTRALIA', '2020-11-19 12:13:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1565, 8, '澳邮国际', 'AUEX', '2020-11-18 23:55:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1566, 8, '比利时邮政', 'BEL', '2020-11-19 11:59:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1567, 8, 'BHT快递', 'BHT', '2020-11-23 13:09:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1568, 8, '秘鲁邮政', 'BILUYOUZHE', '2020-11-21 10:46:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1569, 8, '巴西邮政', 'BR', '2020-11-19 15:24:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1570, 8, '巴伦支快递', 'BALUNZHI', '2020-11-23 20:22:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1571, 8, 'BETWL_Crack', 'BETWL_Crack', '2020-11-22 12:37:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1572, 8, '败欧洲', 'BEUROPE', '2020-11-17 04:22:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1573, 8, 'BCWELT   ', 'BCWELT', '2020-11-22 04:56:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1574, 8, '笨鸟国际', 'BN', '2020-11-21 16:33:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1575, 8, '宝凯物流', 'BKWL', '2020-11-17 22:20:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1576, 8, '巴伦支', 'BLZ', '2020-11-21 12:18:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1577, 8, 'BNTWL_Crack', 'BNTWL_Crack', '2020-11-22 22:11:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1578, 8, '北青小红帽', 'BQXHM', '2020-11-19 05:39:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1579, 8, '不丹邮政', 'BUDANYOUZH', '2020-11-17 09:25:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1580, 8, '邦送物流', 'BSWL', '2020-11-19 05:46:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1581, 8, '波兰邮政', 'BLYZ', '2020-11-20 02:55:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1582, 8, 'CCES快递', 'CCES', '2020-11-18 23:37:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1583, 8, '出口易', 'CKY', '2020-11-17 14:18:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1584, 8, '新配盟', 'CNXLM', '2020-11-21 00:22:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1585, 8, 'CDEK', 'CDEK', '2020-11-21 10:36:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1586, 8, '加拿大邮政', 'CA', '2020-11-20 06:12:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1587, 8, '程光物流', 'CG', '2020-11-20 00:14:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1588, 8, '递必易国际物流', 'DBYWL', '2020-11-22 07:33:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1589, 8, '大道物流', 'DDWL', '2020-11-20 16:41:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1590, 8, '德国云快递', 'DGYKD', '2020-11-19 13:49:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1591, 8, '到乐国际', 'DLGJ', '2020-11-18 20:01:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1592, 8, 'DHL', 'DHL', '2020-11-18 11:37:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1593, 8, 'DHL德国', 'DHL_DE', '2020-11-18 23:03:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1594, 8, 'DHL(英文版)', 'DHL_EN', '2020-11-22 09:23:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1595, 8, 'DHL全球', 'DHL_GLB', '2020-11-17 06:45:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1596, 8, 'DHL Global Mail', 'DHLGM', '2020-11-23 02:36:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1597, 8, '丹麦邮政', 'DK', '2020-11-18 23:05:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1598, 8, '德创物流', 'DCWL', '2020-11-22 09:59:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1599, 8, 'DHL(中国件)', 'DHL_C', '2020-11-17 09:39:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1600, 8, 'DHL(美国)', 'DHL_USA', '2020-11-23 15:18:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1601, 8, '东红物流', 'DHWL', '2020-11-21 05:55:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1602, 8, '店通快递', 'DTKD', '2020-11-18 08:40:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1603, 8, '大洋物流快递', 'DYWL', '2020-11-18 01:14:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1604, 8, 'DPD', 'DPD', '2020-11-18 05:12:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1605, 8, '递四方速递', 'D4PX', '2020-11-19 23:18:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1606, 8, 'DPEX', 'DPEX', '2020-11-21 07:11:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1607, 8, '鼎润物流', 'DRL', '2020-11-22 16:25:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1608, 8, 'EMS国际', 'EMSGJ', '2020-11-18 16:08:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1609, 8, '易客满', 'EKM', '2020-11-22 05:48:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1610, 8, 'EShipper', 'ESHIPPER', '2020-11-17 09:36:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1611, 8, 'EPS (联众国际快运)', 'EPS', '2020-11-17 04:56:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1612, 8, 'EASY-EXPRESS', 'EASYEX', '2020-11-23 19:30:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1613, 8, 'EFS POST', 'EASYEX', '2020-11-22 17:05:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1614, 8, '丰程物流', 'FCWL', '2020-11-18 05:12:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1615, 8, '法翔速运', 'FX', '2020-11-19 21:08:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1616, 8, 'FQ', 'FQ', '2020-11-20 20:21:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1617, 8, '芬兰邮政', 'FLYZ', '2020-11-20 16:42:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1618, 8, '方舟国际速递', 'FZGJ', '2020-11-17 00:46:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1619, 8, 'FEDEX联邦(国际件）', 'FEDEX_GJ', '2020-11-20 00:04:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1620, 8, 'FEDEX联邦(国内件）', 'FEDEX', '2020-11-18 01:43:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1621, 8, '国际e邮宝', 'GJEYB', '2020-11-20 08:02:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1622, 8, '国际邮政包裹', 'GJYZ', '2020-11-23 13:21:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1623, 8, 'GE2D', 'GE2D', '2020-11-18 23:41:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1624, 8, 'GLS', 'GLS', '2020-11-21 04:41:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1625, 8, '冠泰', 'GT', '2020-11-18 04:00:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1626, 8, '欧洲专线(邮政)', 'IOZYZ', '2020-11-17 05:40:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1627, 8, '澳大利亚邮政', 'IADLYYZ', '2020-11-21 15:58:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1628, 8, '阿尔巴尼亚邮政', 'IAEBNYYZ', '2020-11-18 19:52:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1629, 8, '阿尔及利亚邮政', 'IAEJLYYZ', '2020-11-19 03:05:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1630, 8, '阿富汗邮政', 'IAFHYZ', '2020-11-22 04:47:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1631, 8, '安哥拉邮政', 'IAGLYZ', '2020-11-22 18:23:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1632, 8, '埃及邮政', 'IAJYZ', '2020-11-23 07:54:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1633, 8, '阿鲁巴邮政', 'IALBYZ', '2020-11-17 12:00:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1634, 8, '阿联酋邮政', 'IALYYZ', '2020-11-21 09:18:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1635, 8, '阿塞拜疆邮政', 'IASBJYZ', '2020-11-23 14:09:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1636, 8, '博茨瓦纳邮政', 'IBCWNYZ', '2020-11-22 22:32:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1637, 8, '波多黎各邮政', 'IBDLGYZ', '2020-11-20 00:34:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1638, 8, '冰岛邮政', 'IBDYZ', '2020-11-21 06:55:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1639, 8, '白俄罗斯邮政', 'IBELSYZ', '2020-11-22 11:11:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1640, 8, '波黑邮政', 'IBHYZ', '2020-11-17 14:49:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1641, 8, '保加利亚邮政', 'IBJLYYZ', '2020-11-17 14:52:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1642, 8, '巴基斯坦邮政', 'IBJSTYZ', '2020-11-18 06:53:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1643, 8, '黎巴嫩邮政', 'IBLNYZ', '2020-11-21 14:47:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1644, 8, '波兰邮政', 'IBOLYZ', '2020-11-22 09:00:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1645, 8, '宝通达', 'IBTD', '2020-11-23 02:56:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1646, 8, '贝邮宝', 'IBYB', '2020-11-17 15:21:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1647, 8, '德国邮政', 'IDGYZ', '2020-11-22 16:58:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1648, 8, '危地马拉邮政', 'IWDMLYZ', '2020-11-22 19:46:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1649, 8, '乌干达邮政', 'IWGDYZ', '2020-11-22 02:15:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1650, 8, '乌克兰EMS', 'IWKLEMS', '2020-11-18 02:18:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1651, 8, '乌克兰邮政', 'IWKLYZ', '2020-11-21 03:06:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1652, 8, '乌拉圭邮政', 'IWLGYZ', '2020-11-20 12:14:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1653, 8, '林克快递', 'ILKKD', '2020-11-22 04:52:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1654, 8, '文莱邮政', 'IWLYZ', '2020-11-18 15:20:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1655, 8, '新喀里多尼亚邮政', 'IXGLDNYYZ', '2020-11-23 12:23:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1656, 8, '爱尔兰邮政', 'IE', '2020-11-23 20:54:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1657, 8, '夏浦物流', 'IXPWL', '2020-11-17 23:01:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1658, 8, '印度邮政', 'IYDYZ', '2020-11-22 01:25:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1659, 8, '夏浦世纪', 'IXPSJ', '2020-11-18 15:02:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1660, 8, '厄瓜多尔邮政', 'IEGDEYZ', '2020-11-23 21:15:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1661, 8, '俄罗斯邮政', 'IELSYZ', '2020-11-18 19:30:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1662, 8, '飞特物流', 'IFTWL', '2020-11-19 08:02:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1663, 8, '瓜德罗普岛邮政', 'IGDLPDYZ', '2020-11-23 06:42:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1664, 8, '哥斯达黎加邮政', 'IGSDLJYZ', '2020-11-20 14:22:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1665, 8, '韩国邮政', 'IHGYZ', '2020-11-23 03:26:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1666, 8, '互联易', 'IHLY', '2020-11-23 01:43:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1667, 8, '哈萨克斯坦邮政', 'IHSKSTYZ', '2020-11-22 00:36:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1668, 8, '黑山邮政', 'IHSYZ', '2020-11-17 00:11:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1669, 8, '津巴布韦邮政', 'IJBBWYZ', '2020-11-22 20:09:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1670, 8, '吉尔吉斯斯坦邮政', 'IJEJSSTYZ', '2020-11-18 10:31:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1671, 8, '捷克邮政', 'IJKYZ', '2020-11-20 14:26:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1672, 8, '加纳邮政', 'IJNYZ', '2020-11-23 18:58:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1673, 8, '柬埔寨邮政', 'IJPZYZ', '2020-11-19 08:33:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1674, 8, '安的列斯群岛邮政', 'IADLSQDYZ', '2020-11-22 08:12:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1675, 8, '阿根廷邮政', 'IAGTYZ', '2020-11-22 19:02:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1676, 8, '奥兰群岛邮政', 'IALQDYZ', '2020-11-23 00:53:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1677, 8, '阿曼邮政', 'IAMYZ', '2020-11-22 21:37:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1678, 8, '埃塞俄比亚邮政', 'IASEBYYZ', '2020-11-21 11:46:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1679, 8, '爱沙尼亚邮政', 'IASNYYZ', '2020-11-21 18:58:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1680, 8, '阿森松岛邮政', 'IASSDYZ', '2020-11-20 13:52:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1681, 8, '便利速递', 'IBLSD', '2020-11-20 13:27:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1682, 8, '巴林邮政', 'IBLYZ', '2020-11-17 04:00:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1683, 8, '百慕达邮政', 'IBMDYZ', '2020-11-21 01:59:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1684, 8, '达方物流', 'IDFWL', '2020-11-23 01:35:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1685, 8, '厄立特里亚邮政', 'IELTLYYZ', '2020-11-21 05:37:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1686, 8, '瓜德罗普岛EMS', 'IGDLPDEMS', '2020-11-20 00:21:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1687, 8, '俄速递', 'IGJESD', '2020-11-19 09:53:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1688, 8, '哥伦比亚邮政', 'IGLBYYZ', '2020-11-20 01:24:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1689, 8, '格陵兰邮政', 'IGLLYZ', '2020-11-18 03:40:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1690, 8, '科特迪瓦邮政', 'IKTDWYZ', '2020-11-20 13:49:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1691, 8, '卡塔尔邮政', 'IKTEYZ', '2020-11-17 13:46:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1692, 8, '利比亚邮政', 'ILBYYZ', '2020-11-23 01:40:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1693, 8, '卢森堡邮政', 'ILSBYZ', '2020-11-17 21:24:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1694, 8, '拉脱维亚邮政', 'ILTWYYZ', '2020-11-17 04:18:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1695, 8, '立陶宛邮政', 'ILTWYZ', '2020-11-22 04:59:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1696, 8, '列支敦士登邮政', 'ILZDSDYZ', '2020-11-21 17:03:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1697, 8, '马尔代夫邮政', 'IMEDFYZ', '2020-11-18 00:35:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1698, 8, '孟加拉国EMS', 'IMJLGEMS', '2020-11-21 22:05:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1699, 8, '摩洛哥邮政', 'IMLGYZ', '2020-11-17 17:42:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1700, 8, '毛里求斯邮政', 'IMLQSYZ', '2020-11-19 20:37:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1701, 8, '马来西亚EMS', 'IMLXYEMS', '2020-11-22 04:16:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1702, 8, '马来西亚邮政', 'IMLXYYZ', '2020-11-20 11:10:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1703, 8, '马其顿邮政', 'IMQDYZ', '2020-11-18 20:02:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1704, 8, '马提尼克EMS', 'IMTNKEMS', '2020-11-22 18:18:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1705, 8, '马提尼克邮政', 'IMTNKYZ', '2020-11-19 12:27:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1706, 8, '墨西哥邮政', 'IMXGYZ', '2020-11-19 07:00:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1707, 8, '南非邮政', 'INFYZ', '2020-11-20 22:39:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1708, 8, '挪威邮政', 'INWYZ', '2020-11-22 22:34:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1709, 8, '葡萄牙邮政', 'IPTYYZ', '2020-11-21 00:33:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1710, 8, '全球快递', 'IQQKD', '2020-11-19 08:02:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1711, 8, '全通物流', 'IQTWL', '2020-11-23 14:11:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1712, 8, '苏丹邮政', 'ISDYZ', '2020-11-22 03:48:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1713, 8, '萨尔瓦多邮政', 'ISEWDYZ', '2020-11-23 01:28:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1714, 8, '斯洛伐克邮政', 'ISLFKYZ', '2020-11-17 23:36:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1715, 8, '斯洛文尼亚邮政', 'ISLWNYYZ', '2020-11-17 15:57:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1716, 8, '沙特阿拉伯邮政', 'ISTALBYZ', '2020-11-17 09:55:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1717, 8, '土耳其邮政', 'ITEQYZ', '2020-11-17 02:44:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1718, 8, '泰国邮政', 'ITGYZ', '2020-11-23 07:36:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1719, 8, '特立尼达和多巴哥EMS', 'ITLNDHDBGE', '2020-11-20 12:08:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1720, 8, '突尼斯邮政', 'ITNSYZ', '2020-11-22 13:32:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1721, 8, '坦桑尼亚邮政', 'ITSNYYZ', '2020-11-20 10:58:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1722, 8, '乌兹别克斯坦EMS', 'IWZBKSTEMS', '2020-11-17 15:11:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1723, 8, '小飞龙物流', 'IXFLWL', '2020-11-23 17:21:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1724, 8, '新加坡邮政', 'IXJPYZ', '2020-11-20 23:35:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1725, 8, '叙利亚邮政', 'IXLYYZ', '2020-11-23 17:30:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1726, 8, '匈牙利邮政', 'IXYLYZ', '2020-11-17 21:44:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1727, 8, '印度尼西亚邮政', 'IYDNXYYZ', '2020-11-22 05:12:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1728, 8, '伊朗邮政', 'IYLYZ', '2020-11-19 13:47:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1729, 8, '越南邮政', 'IYNYZ', '2020-11-21 04:59:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1730, 8, '以色列邮政', 'IYSLYZ', '2020-11-23 09:52:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1731, 8, '易通关', 'IYTG', '2020-11-22 14:05:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1732, 8, '燕文物流', 'IYWWL', '2020-11-18 19:08:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1733, 8, '直布罗陀邮政', 'IZBLTYZ', '2020-11-23 03:47:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1734, 8, '克罗地亚邮政', 'IKNDYYZ', '2020-11-21 14:30:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1735, 8, '肯尼亚邮政', 'IKNYYZ', '2020-11-21 14:11:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1736, 8, '科特迪瓦EMS', 'IKTDWEMS', '2020-11-19 05:42:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1737, 8, '罗马尼亚邮政', 'ILMNYYZ', '2020-11-21 09:40:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1738, 8, '摩尔多瓦邮政', 'IMEDWYZ', '2020-11-18 10:52:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1739, 8, '马耳他邮政', 'IMETYZ', '2020-11-18 01:00:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1740, 8, '尼日利亚邮政', 'INRLYYZ', '2020-11-17 21:23:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1741, 8, '塞尔维亚邮政', 'ISEWYYZ', '2020-11-18 08:55:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1742, 8, '塞浦路斯邮政', 'ISPLSYZ', '2020-11-21 05:25:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1743, 8, '乌兹别克斯坦邮政', 'IWZBKSTYZ', '2020-11-20 04:02:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1744, 8, '西班牙邮政', 'IXBYYZ', '2020-11-20 04:54:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1745, 8, '新加坡EMS', 'IXJPEMS', '2020-11-23 13:25:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1746, 8, '希腊邮政', 'IXLYZ', '2020-11-19 09:21:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1747, 8, '新西兰邮政', 'IXXLYZ', '2020-11-23 04:53:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1748, 8, '意大利邮政', 'IYDLYZ', '2020-11-20 01:21:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1749, 8, '英国邮政', 'IYGYZ', '2020-11-20 15:44:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1750, 8, '亚美尼亚邮政', 'IYMNYYZ', '2020-11-19 04:58:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1751, 8, '智利邮政', 'IZLYZ', '2020-11-17 02:39:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1752, 8, '也门邮政', 'IYMYZ', '2020-11-17 21:58:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1753, 8, '日本邮政', 'JP', '2020-11-21 06:57:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1754, 8, '今枫国际', 'JFGJ', '2020-11-21 20:28:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1755, 8, '极光转运', 'JGZY', '2020-11-21 11:51:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1756, 8, '吉祥邮转运', 'JXYKD', '2020-11-18 00:10:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1757, 8, '嘉里国际', 'JLDT', '2020-11-22 11:35:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1758, 8, '上海久易国际', 'JYSD', '2020-11-20 14:27:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1759, 8, '绝配国际速递', 'JPKD', '2020-11-18 14:30:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1760, 8, '联运通', 'LYT', '2020-11-21 04:50:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1761, 8, '联合快递', 'LHKDS', '2020-11-19 08:19:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1762, 8, '新顺丰', 'NSF', '2020-11-23 02:46:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1763, 8, '荷兰邮政', 'NL', '2020-11-19 17:51:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1764, 8, 'ONTRAC', 'ONTRAC', '2020-11-19 08:36:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1765, 8, 'OCS', 'OCS', '2020-11-20 14:28:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1766, 8, '啪啪供应链', 'PAPA', '2020-11-21 00:51:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1767, 8, 'POSTEIBE', 'POSTEIBE', '2020-11-19 11:11:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1768, 8, '全球邮政', 'QQYZ', '2020-11-17 06:23:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1769, 8, '秦远海运', 'QYHY', '2020-11-17 22:01:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1770, 8, '瑞典邮政', 'RDSE', '2020-11-20 19:57:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1771, 8, '澳洲飞跃', 'RLG', '2020-11-19 13:23:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1772, 8, 'SKYPOST', 'SKYPOST', '2020-11-18 08:04:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1773, 8, '林道国际', 'SHLDHY', '2020-11-22 23:50:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1774, 8, '佳惠尔', 'SYJHE', '2020-11-22 03:56:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1775, 8, '瑞士邮政', 'SWCH', '2020-11-17 22:34:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1776, 8, '首达速运', 'SDSY', '2020-11-20 03:19:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1777, 8, '穗空物流', 'SK', '2020-11-22 23:13:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1778, 8, '首通快运', 'STONG', '2020-11-23 13:47:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1779, 8, '申通快递国际单', 'STO_INTL', '2020-11-18 02:58:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1780, 8, '光线速递', 'SUNSHINE', '2020-11-23 18:28:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1781, 8, 'TNT快递', 'TNT', '2020-11-19 17:45:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1782, 8, '泰国138', 'TAILAND138', '2020-11-17 09:01:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1783, 8, '优邦国际速运', 'UBONEX', '2020-11-17 15:32:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1784, 8, 'UEX   ', 'UEX', '2020-11-19 03:38:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1785, 8, 'USPS美国邮政', 'USPS', '2020-11-18 21:52:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1786, 8, '万国邮政', 'UPU', '2020-11-20 03:28:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1787, 8, 'UPS', 'UPS', '2020-11-20 02:01:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1788, 8, '启辰国际', 'VENUCIA', '2020-11-23 00:42:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1789, 8, '中越国际物流', 'VCTRANS', '2020-11-17 02:29:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1790, 8, '星空国际', 'XKGJ', '2020-11-20 07:19:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1791, 8, '迅达国际', 'XD', '2020-11-19 08:46:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1792, 8, '香港邮政', 'XGYZ', '2020-11-18 22:52:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1793, 8, '喜来快递', 'XLKD', '2020-11-19 17:04:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1794, 8, '鑫世锐达', 'XSRD', '2020-11-17 19:05:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1795, 8, '新元国际', 'XYGJ', '2020-11-19 19:52:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1796, 8, '西邮寄', 'XYJ', '2020-11-21 20:23:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1797, 8, 'ADLER雄鹰国际速递', 'XYGJSD', '2020-11-18 22:01:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1798, 8, '日本大和运输(Yamato)', 'YAMA', '2020-11-19 00:34:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1799, 8, 'YODEL', 'YODEL', '2020-11-21 09:48:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1800, 8, '一号线', 'YHXGJSD', '2020-11-19 02:59:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1801, 8, '约旦邮政', 'YUEDANYOUZ', '2020-11-21 09:11:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1802, 8, '玥玛速运', 'YMSY', '2020-11-18 16:39:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1803, 8, '鹰运', 'YYSD', '2020-11-19 07:22:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1804, 8, '易境达', 'YJD', '2020-11-23 11:51:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1805, 8, '洋包裹', 'YBG', '2020-11-21 18:12:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1806, 8, '友家速递', 'YJ', '2020-11-21 08:25:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1807, 8, '爱购转运', 'ZY_AG', '2020-11-17 13:49:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1808, 8, '爱欧洲', 'ZY_AOZ', '2020-11-20 18:08:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1809, 8, '澳世速递', 'ZY_AUSE', '2020-11-20 04:56:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1810, 8, 'AXO', 'ZY_AXO', '2020-11-21 19:15:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1811, 8, '贝海速递', 'ZY_BH', '2020-11-17 13:08:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1812, 8, '蜜蜂速递', 'ZY_BEE', '2020-11-19 06:12:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1813, 8, '百利快递', 'ZY_BL', '2020-11-19 17:59:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1814, 8, '斑马物流', 'ZY_BM', '2020-11-17 01:36:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1815, 8, '百通物流', 'ZY_BT', '2020-11-23 00:26:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1816, 8, '策马转运', 'ZY_CM', '2020-11-19 03:40:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1817, 8, '宜送转运', 'ZY_ESONG', '2020-11-23 15:23:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1818, 8, '飞碟快递', 'ZY_FD', '2020-11-22 22:55:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1819, 8, '飞鸽快递', 'ZY_FG', '2020-11-19 22:46:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1820, 8, '风行快递', 'ZY_FX', '2020-11-20 20:47:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1821, 8, '风行速递', 'ZY_FXSD', '2020-11-20 13:54:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1822, 8, '飞洋快递', 'ZY_FY', '2020-11-23 08:10:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1823, 8, '皓晨快递', 'ZY_HC', '2020-11-17 04:10:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1824, 8, '海悦速递', 'ZY_HYSD', '2020-11-19 17:17:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1825, 8, '君安快递', 'ZY_JA', '2020-11-23 04:18:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1826, 8, '时代转运', 'ZY_JD', '2020-11-18 22:37:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1827, 8, '骏达快递', 'ZY_JDKD', '2020-11-22 02:32:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1828, 8, '骏达转运', 'ZY_JDZY', '2020-11-22 20:27:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1829, 8, '久禾快递', 'ZY_JH', '2020-11-17 02:18:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1830, 8, '金海淘', 'ZY_JHT', '2020-11-20 19:12:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1831, 8, '联邦转运FedRoad', 'ZY_LBZY', '2020-11-21 20:46:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1832, 8, '龙象快递', 'ZY_LX', '2020-11-23 00:33:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1833, 8, '美国转运', 'ZY_MGZY', '2020-11-18 16:07:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1834, 8, '美速通', 'ZY_MST', '2020-11-21 05:18:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1835, 8, '美西转运', 'ZY_MXZY', '2020-11-19 05:47:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1836, 8, 'QQ-EX', 'ZY_QQEX', '2020-11-22 12:43:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1837, 8, '瑞天快递', 'ZY_RT', '2020-11-17 03:15:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1838, 8, '瑞天速递', 'ZY_RTSD', '2020-11-21 23:04:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1839, 8, '速达快递', 'ZY_SDKD', '2020-11-20 14:37:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1840, 8, '四方转运', 'ZY_SFZY', '2020-11-20 04:50:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1841, 8, '上腾快递', 'ZY_ST', '2020-11-22 05:21:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1842, 8, '天际快递', 'ZY_TJ', '2020-11-19 15:53:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1843, 8, '天马转运', 'ZY_TM', '2020-11-21 15:03:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1844, 8, '滕牛快递', 'ZY_TN', '2020-11-18 07:18:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1845, 8, '太平洋快递', 'ZY_TPY', '2020-11-23 13:40:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1846, 8, '唐三藏转运', 'ZY_TSZ', '2020-11-18 04:44:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1847, 8, 'TWC转运世界', 'ZY_TWC', '2020-11-17 05:02:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1848, 8, '润东国际快线', 'ZY_RDGJ', '2020-11-21 10:37:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1849, 8, '同心快递', 'ZY_TX', '2020-11-17 18:59:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1850, 8, '天翼快递', 'ZY_TY', '2020-11-21 13:26:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1851, 8, '德国海淘之家', 'ZY_DGHT', '2020-11-23 13:53:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1852, 8, '德运网', 'ZY_DYW', '2020-11-22 08:46:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1853, 8, '文达国际DCS', 'ZY_WDCS', '2020-11-17 04:30:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1854, 8, '同舟快递', 'ZY_TZH', '2020-11-22 17:13:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1855, 8, 'UCS合众快递', 'ZY_UCS', '2020-11-17 06:54:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1856, 8, '星辰快递', 'ZY_XC', '2020-11-22 03:51:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1857, 8, '先锋快递', 'ZY_XF', '2020-11-21 03:34:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1858, 8, '云骑快递', 'ZY_YQ', '2020-11-22 07:18:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1859, 8, '优晟速递', 'ZY_YSSD', '2020-11-17 05:28:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1860, 8, '运淘美国', 'ZY_YTUSA', '2020-11-23 02:26:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1861, 8, '至诚速递', 'ZY_ZCSD', '2020-11-19 02:05:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1862, 8, '增速海淘', 'ZYZOOM', '2020-11-23 01:29:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1863, 8, '中驰物流', 'ZH', '2020-11-20 06:09:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1864, 8, '中欧快运', 'ZO', '2020-11-22 02:00:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1865, 8, '准实快运', 'ZSKY', '2020-11-18 19:10:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1866, 8, '中外速运', 'ZWSY', '2020-11-17 17:31:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1867, 8, '郑州建华', 'ZZJH', '2020-11-22 05:43:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1868, 8, '中通国际', 'ZTOGLOBAL', '2020-11-20 05:04:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1869, 8, '转运四方国际快递', 'ZYSFGJ', '2020-11-17 09:12:46', NULL);
INSERT INTO `cere_platform_dict` VALUES (1883, 0, '退款原因', '退款原因', '2020-12-09 16:18:38', '2020-12-09 16:18:38');
INSERT INTO `cere_platform_dict` VALUES (1884, 1883, '7天无理由退换货', '7天无理由退换货', '2020-12-09 16:18:38', '2020-12-09 16:18:38');
INSERT INTO `cere_platform_dict` VALUES (1885, 1883, '退运费', '退运费', '2020-12-09 16:18:38', '2020-12-09 16:18:38');
INSERT INTO `cere_platform_dict` VALUES (1886, 1883, '大小/尺寸与商品描述不符', '大小/尺寸与商品描述不符', '2020-12-09 16:18:38', '2020-12-09 16:18:38');
INSERT INTO `cere_platform_dict` VALUES (1887, 1883, '颜色/图案/款式与商品描述不符', '颜色/图案/款式与商品描述不符', '2020-12-09 16:18:38', '2020-12-09 16:18:38');
INSERT INTO `cere_platform_dict` VALUES (1888, 1883, '材质与商品描述不符', '材质与商品描述不符', '2020-12-09 16:18:38', '2020-12-09 16:18:38');
INSERT INTO `cere_platform_dict` VALUES (1889, 1883, '生产日期/保质期与商品描述不符', '生产日期/保质期与商品描述不符', '2020-12-09 16:18:38', '2020-12-09 16:18:38');
INSERT INTO `cere_platform_dict` VALUES (1890, 1883, '不想要或拍多了', '不想要或拍多了', '2020-12-09 16:18:38', '2020-12-09 16:18:38');
INSERT INTO `cere_platform_dict` VALUES (1891, 1883, '商品信息拍错(颜色/规格/尺码等)', '商品信息拍错(颜色/规格/尺码等)', '2020-12-09 16:18:38', '2020-12-09 16:18:38');
INSERT INTO `cere_platform_dict` VALUES (1892, 1883, '地址/电话信息填写错误', '地址/电话信息填写错误', '2020-12-09 16:18:38', '2020-12-09 16:18:38');
INSERT INTO `cere_platform_dict` VALUES (1893, 1883, '没用/少用优惠', '没用/少用优惠', '2020-12-09 16:18:38', '2020-12-09 16:18:38');
INSERT INTO `cere_platform_dict` VALUES (1894, 1883, '协商一致退款', '协商一致退款', '2020-12-09 16:18:38', '2020-12-09 16:18:38');
INSERT INTO `cere_platform_dict` VALUES (1895, 1883, '缺货', '缺货', '2020-12-09 16:18:38', '2020-12-09 16:18:38');
INSERT INTO `cere_platform_dict` VALUES (1896, 1883, '其他', '其他', '2020-12-09 16:18:38', '2020-12-09 16:18:38');
INSERT INTO `cere_platform_dict` VALUES (1900, 0, 'CREDIT_CONFIG', '积分配置', '2021-12-04 14:00:55', '2021-12-15 17:42:39');
INSERT INTO `cere_platform_dict` VALUES (1901, 1900, 'credit_switch', '1', '2021-12-04 14:01:20', '2021-12-31 23:05:10');
INSERT INTO `cere_platform_dict` VALUES (1902, 1900, 'credit_order_rate', '1', '2021-12-04 14:02:10', '2021-12-29 15:22:00');
INSERT INTO `cere_platform_dict` VALUES (1903, 1900, 'credit_deduct_limit', '100', '2021-12-04 14:03:18', '2021-12-29 22:53:48');
INSERT INTO `cere_platform_dict` VALUES (1906, 1900, 'credit_order_amount_threshold', '0.02', '2021-12-28 09:22:23', NULL);
INSERT INTO `cere_platform_dict` VALUES (1907, 1900, 'credit_exchange_rate', '0.1', '2021-12-29 20:11:58', '2021-12-31 10:38:04');
INSERT INTO `cere_platform_dict` VALUES (2001, 1, '工商银行', '工商银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2002, 1, '中国进出口银行', '中国进出口银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2003, 1, '国家开发银行', '国家开发银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2004, 1, '建设银行', '建设银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2005, 1, '农业银行', '农业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2006, 1, '中国银行', '中国银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2007, 1, '交通银行', '交通银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2008, 1, '邮储银行', '邮储银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2009, 1, '招商银行', '招商银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2010, 1, '兴业银行', '兴业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2011, 1, '浦发银行', '浦发银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2012, 1, '民生银行', '民生银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2013, 1, '中信银行', '中信银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2014, 1, '华夏银行', '华夏银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2015, 1, '平安银行', '平安银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2016, 1, '广发银行', '广发银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2017, 1, '光大银行', '光大银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2018, 1, '渤海银行', '渤海银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2019, 1, '浙商银行', '浙商银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2020, 1, '恒丰银行', '恒丰银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2021, 1, '北京银行', '北京银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2022, 1, '临商银行', '临商银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2023, 1, '天津银行', '天津银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2024, 1, '齐商银行', '齐商银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2025, 1, '河北银行', '河北银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2026, 1, '日照银行', '日照银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2027, 1, '保定银行', '保定银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2028, 1, '泰安银行', '泰安银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2029, 1, '沧州银行', '沧州银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2030, 1, '威海市商业银行', '威海市商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2031, 1, '承德银行', '承德银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2032, 1, '潍坊银行', '潍坊银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2033, 1, '邯郸银行', '邯郸银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2034, 1, '烟台银行', '烟台银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2035, 1, '衡水银行', '衡水银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2036, 1, '枣庄银行', '枣庄银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2037, 1, '廊坊银行', '廊坊银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2038, 1, '中原银行', '中原银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2039, 1, '秦皇岛银行', '秦皇岛银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2040, 1, '郑州银行', '郑州银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2041, 1, '唐山银行', '唐山银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2042, 1, '平顶山银行', '平顶山银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2043, 1, '邢台银行', '邢台银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2044, 1, '洛阳银行', '洛阳银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2045, 1, '张家口银行', '张家口银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2046, 1, '晋商银行', '晋商银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2047, 1, '华融湘江银行', '华融湘江银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2048, 1, '大同银行', '大同银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2049, 1, '长沙银行', '长沙银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2050, 1, '晋城银行', '晋城银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2051, 1, '汉口银行', '汉口银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2052, 1, '晋中银行', '晋中银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2053, 1, '湖北银行', '湖北银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2054, 1, '阳泉市商业银行', '阳泉市商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2055, 1, '广州银行', '广州银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2056, 1, '长治银行', '长治银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2057, 1, '东莞银行', '东莞银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2058, 1, '包商银行', '包商银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2059, 1, '广东华兴银行', '广东华兴银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2060, 1, '内蒙古银行', '内蒙古银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2061, 1, '广东南粤银行', '广东南粤银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2062, 1, '鄂尔多斯银行', '鄂尔多斯银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2063, 1, '珠海华润银行', '珠海华润银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2064, 1, '乌海银行', '乌海银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2065, 1, '广西北部湾银行', '广西北部湾银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2066, 1, '中德住房储蓄银行', '中德住房储蓄银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2067, 1, '网商银行', '网商银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2068, 1, '微众银行', '微众银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2069, 1, '温州民商银行', '温州民商银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2070, 1, '上海华瑞银行', '上海华瑞银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2071, 1, '天津金城银行', '天津金城银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2072, 1, '湖南三湘银行', '湖南三湘银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2073, 1, '重庆富民银行', '重庆富民银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2074, 1, '四川新网银行', '四川新网银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2075, 1, '北京中关村银行', '北京中关村银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2076, 1, '吉林亿联银行', '吉林亿联银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2077, 1, '武汉众邦银行', '武汉众邦银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2078, 1, '福建华通银行', '福建华通银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2079, 1, '威海蓝海银行', '威海蓝海银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2080, 1, '江苏苏宁银行', '江苏苏宁银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2081, 1, '梅州客商银行', '梅州客商银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2082, 1, '安徽新安银行', '安徽新安银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2083, 1, '辽宁振兴银行', '辽宁振兴银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2084, 1, '江西裕民银行', '江西裕民银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2085, 1, '汇丰银行', '汇丰银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2086, 1, '渣打银行', '渣打银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2087, 1, '东亚银行', '东亚银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2088, 1, '花旗银行', '花旗银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2089, 1, '星展银行', '星展银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2090, 1, '恒生银行', '恒生银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2091, 1, '华侨银行', '华侨银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2092, 1, '南洋商业银行', '南洋商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2093, 1, '大华银行', '大华银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2094, 1, '盛京银行', '盛京银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2095, 1, '桂林银行', '桂林银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2096, 1, '锦州银行', '锦州银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2097, 1, '柳州银行', '柳州银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2098, 1, '鞍山银行', '鞍山银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2099, 1, '海南银行', '海南银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2100, 1, '本溪银行', '本溪银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2101, 1, '重庆三峡银行', '重庆三峡银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2102, 1, '朝阳银行', '朝阳银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2103, 1, '重庆银行', '重庆银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2104, 1, '丹东银行', '丹东银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2105, 1, '成都银行', '成都银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2106, 1, '抚顺银行', '抚顺银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2107, 1, '达州银行', '达州银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2108, 1, '阜新银行', '阜新银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2109, 1, '长城华西银行', '长城华西银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2110, 1, '葫芦岛银行', '葫芦岛银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2111, 1, '乐山市商业银行', '乐山市商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2112, 1, '辽阳银行', '辽阳银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2113, 1, '凉山州银行', '凉山州银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2114, 1, '盘锦银行', '盘锦银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2115, 1, '泸州银行', '泸州银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2116, 1, '铁岭银行', '铁岭银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2117, 1, '绵阳市商业银行', '绵阳市商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2118, 1, '营口沿海银行', '营口沿海银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2119, 1, '四川天府银行', '四川天府银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2120, 1, '营口银行', '营口银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2121, 1, '攀枝花市商业银行', '攀枝花市商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2122, 1, '吉林银行', '吉林银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2123, 1, '遂宁银行', '遂宁银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2124, 1, '哈尔滨银行', '哈尔滨银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2125, 1, '雅安市商业银行', '雅安市商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2126, 1, '龙江银行', '龙江银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2127, 1, '宜宾市商业银行', '宜宾市商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2128, 1, '上海银行', '上海银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2129, 1, '自贡银行', '自贡银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2130, 1, '江苏银行', '江苏银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2131, 1, '贵阳银行', '贵阳银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2132, 1, '南京银行', '南京银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2133, 1, '贵州银行', '贵州银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2134, 1, '苏州银行', '苏州银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2135, 1, '富滇银行', '富滇银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2136, 1, '苏州长江商业银行', '苏州长江商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2137, 1, '曲靖市商业银行', '曲靖市商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2138, 1, '杭州银行', '杭州银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2139, 1, '云南红塔银行', '云南红塔银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2140, 1, '湖州银行', '湖州银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2141, 1, '西藏银行', '西藏银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2142, 1, '嘉兴银行', '嘉兴银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2143, 1, '西安银行', '西安银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2144, 1, '金华银行', '金华银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2145, 1, '长安银行', '长安银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2146, 1, '绍兴银行', '绍兴银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2147, 1, '甘肃银行', '甘肃银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2148, 1, '台州银行', '台州银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2149, 1, '兰州银行', '兰州银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2150, 1, '温州银行', '温州银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2151, 1, '青海银行', '青海银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2152, 1, '浙江稠州商业银行', '浙江稠州商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2153, 1, '宁夏银行', '宁夏银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2154, 1, '浙江民泰商业银行', '浙江民泰商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2155, 1, '石嘴山银行', '石嘴山银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2156, 1, '浙江泰隆商业银行', '浙江泰隆商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2157, 1, '乌鲁木齐银行', '乌鲁木齐银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2158, 1, '徽商银行', '徽商银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2159, 1, '昆仑银行', '昆仑银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2160, 1, '福建海峡银行', '福建海峡银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2161, 1, '哈密市商业银行', '哈密市商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2162, 1, '泉州银行', '泉州银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2163, 1, '库尔勒银行', '库尔勒银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2164, 1, '江西银行', '江西银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2165, 1, '新疆汇和银行', '新疆汇和银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2166, 1, '赣州银行', '赣州银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2167, 1, '大连银行', '大连银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2168, 1, '九江银行', '九江银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2169, 1, '宁波银行', '宁波银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2170, 1, '上饶银行', '上饶银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2171, 1, '宁波东海银行', '宁波东海银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2172, 1, '齐鲁银行', '齐鲁银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2173, 1, '宁波通商银行', '宁波通商银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2174, 1, '德州银行', '德州银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2175, 1, '厦门银行', '厦门银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2176, 1, '东营银行', '东营银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2177, 1, '厦门国际银行', '厦门国际银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2178, 1, '济宁银行', '济宁银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2179, 1, '青岛银行', '青岛银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2180, 1, '莱商银行', '莱商银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2181, 1, '新疆银行', '新疆银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2182, 1, '北京农商银行', '北京农商银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2183, 1, '天津农村商业银行', '天津农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2184, 1, '天津滨海农村商业银行', '天津滨海农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2185, 1, '河南确山农村商业银行', '河南确山农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2186, 1, '河北井陉农村商业银行', '河北井陉农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2187, 1, '河南卢氏农村商业银行', '河南卢氏农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2188, 1, '河北正定农村商业银行', '河北正定农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2189, 1, '河南鄢陵农村商业银行', '河南鄢陵农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2190, 1, '河北晋州农村商业银行', '河北晋州农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2191, 1, '河南台前农村商业银行', '河南台前农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2192, 1, '河北辛集农村商业银行', '河北辛集农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2193, 1, '河南新郑农村商业银行', '河南新郑农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2194, 1, '河北平山农村商业银行', '河北平山农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2195, 1, '河南固始农村商业银行', '河南固始农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2196, 1, '河北元氏农村商业银行', '河北元氏农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2197, 1, '河南汴京农村商业银行', '河南汴京农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2198, 1, '河北灵寿农村商业银行', '河北灵寿农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2199, 1, '河南汝州农村商业银行', '河南汝州农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2200, 1, '石家庄鹿泉农村商业银行', '石家庄鹿泉农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2201, 1, '河南许昌许都农村商业银行', '河南许昌许都农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2202, 1, '张家口农村商业银行', '张家口农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2203, 1, '河南西峡农村商业银行', '河南西峡农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2204, 1, '河北怀来农村商业银行', '河北怀来农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2205, 1, '河南登封农村商业银行', '河南登封农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2206, 1, '河北张北农村商业银行', '河北张北农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2207, 1, '河南正阳农村商业银行', '河南正阳农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2208, 1, '河北沽源农村商业银行', '河北沽源农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2209, 1, '河南汝阳农村商业银行', '河南汝阳农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2210, 1, '河北涿鹿农村商业银行', '河北涿鹿农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2211, 1, '河南安阳商都农村商业银行', '河南安阳商都农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2212, 1, '河北阳原农村商业银行', '河北阳原农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2213, 1, '河南中牟农村商业银行', '河南中牟农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2214, 1, '河北宽城农村商业银行', '河北宽城农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2215, 1, '鹤壁农村商业银行', '鹤壁农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2216, 1, '河北滦平农村商业银行', '河北滦平农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2217, 1, '河南宜阳农村商业银行', '河南宜阳农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2218, 1, '河北围场农村商业银行', '河北围场农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2219, 1, '河南荥阳农村商业银行', '河南荥阳农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2220, 1, '河北丰宁农村商业银行', '河北丰宁农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2221, 1, '河南兰考农村商业银行', '河南兰考农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2222, 1, '河北承德热河农村商业银行', '河北承德热河农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2223, 1, '河南舞钢农村商业银行', '河南舞钢农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2224, 1, '河北卢龙农村商业银行', '河北卢龙农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2225, 1, '河南宝丰农村商业银行', '河南宝丰农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2226, 1, '河北滦州农村商业银行', '河北滦州农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2227, 1, '河南长葛农村商业银行', '河南长葛农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2228, 1, '河北滦南农村商业银行', '河北滦南农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2229, 1, '河南洛宁农村商业银行', '河南洛宁农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2230, 1, '河北迁安农村商业银行', '河北迁安农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2231, 1, '河南桐柏农村商业银行', '河南桐柏农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2232, 1, '河北玉田农村商业银行', '河北玉田农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2233, 1, '河南西平农村商业银行', '河南西平农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2234, 1, '河北唐山曹妃甸农村商业银行', '河北唐山曹妃甸农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2235, 1, '河南汤阴农村商业银行', '河南汤阴农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2236, 1, '河北唐山农村商业银行', '河北唐山农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2237, 1, '河南义马农村商业银行', '河南义马农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2238, 1, '河北永清农村商业银行', '河北永清农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2239, 1, '河南新密农村商业银行', '河南新密农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2240, 1, '河北三河农村商业银行', '河北三河农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2241, 1, '河南栾川农村商业银行', '河南栾川农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2242, 1, '河北固安农村商业银行', '河北固安农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2243, 1, '河南偃师农村商业银行', '河南偃师农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2244, 1, '河北霸州农村商业银行', '河北霸州农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2245, 1, '河南孟津农村商业银行', '河南孟津农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2246, 1, '河北香河农村商业银行', '河北香河农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2247, 1, '河南巩义农村商业银行', '河南巩义农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2248, 1, '河北文安农村商业银行', '河北文安农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2249, 1, '河南获嘉农村商业银行', '河南获嘉农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2250, 1, '河北大厂农村商业银行', '河北大厂农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2251, 1, '河南永城农村商业银行', '河南永城农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2252, 1, '河北蠡州北银农村商业银行', '河北蠡州北银农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2253, 1, '河南新安农村商业银行', '河南新安农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2254, 1, '河北定州农村商业银行', '河北定州农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2255, 1, '洛阳农村商业银行', '洛阳农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2256, 1, '河北高碑店农村商业银行', '河北高碑店农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2257, 1, '河南嵩县农村商业银行', '河南嵩县农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2258, 1, '河北涞水农村商业银行', '河北涞水农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2259, 1, '河南武陟农村商业银行', '河南武陟农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2260, 1, '河北涿州农村商业银行', '河北涿州农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2261, 1, '开封宋都农村商业银行', '开封宋都农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2262, 1, '河北保定农村商业银行', '河北保定农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2263, 1, '焦作解放农村商业银行', '焦作解放农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2264, 1, '河北安国农村商业银行', '河北安国农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2265, 1, '河南范县农村商业银行', '河南范县农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2266, 1, '河北沧州农村商业银行', '河北沧州农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2267, 1, '河南新乡平原农村商业银行', '河南新乡平原农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2268, 1, '河北南皮农村商业银行', '河北南皮农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2269, 1, '河南安阳相州农村商业银行', '河南安阳相州农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2270, 1, '河北献县农村商业银行', '河北献县农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2271, 1, '河南遂平农村商业银行', '河南遂平农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2272, 1, '河北黄骅农村商业银行', '河北黄骅农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2273, 1, '驻马店农村商业银行', '驻马店农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2274, 1, '河北衡水农村商业银行', '河北衡水农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2275, 1, '河南叶县农村商业银行', '河南叶县农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2276, 1, '河北阜城农村商业银行', '河北阜城农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2277, 1, '河南太康农村商业银行', '河南太康农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2278, 1, '河北武强农村商业银行', '河北武强农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2279, 1, '河南商水农村商业银行', '河南商水农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2280, 1, '河北景州农村商业银行', '河北景州农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2281, 1, '河南尉氏农村商业银行', '河南尉氏农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2282, 1, '河北冀州农村商业银行', '河北冀州农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2283, 1, '河南通许农村商业银行', '河南通许农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2284, 1, '河北安平农村商业银行', '河北安平农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2285, 1, '河南杞县农村商业银行', '河南杞县农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2286, 1, '河北深州农村商业银行', '河北深州农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2287, 1, '三门峡陕州农村商业银行', '三门峡陕州农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2288, 1, '河北枣强农村商业银行', '河北枣强农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2289, 1, '河南浚县农村商业银行', '河南浚县农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2290, 1, '河北邢台农村商业银行', '河北邢台农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2291, 1, '河南上蔡农村商业银行', '河南上蔡农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2292, 1, '河北沙河农村商业银行', '河北沙河农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2293, 1, '河南襄城农村商业银行', '河南襄城农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2294, 1, '河北清河农村商业银行', '河北清河农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2295, 1, '河南滑县农村商业银行', '河南滑县农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2296, 1, '河北南和农村商业银行', '河北南和农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2297, 1, '河南邓州农村商业银行', '河南邓州农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2298, 1, '河北临城农村商业银行', '河北临城农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2299, 1, '河南民权农村商业银行', '河南民权农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2300, 1, '河北宁晋农村商业银行', '河北宁晋农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2301, 1, '许昌农村商业银行', '许昌农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2302, 1, '河北临西农村商业银行', '河北临西农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2303, 1, '河南新蔡农村商业银行', '河南新蔡农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2304, 1, '河北任县农村商业银行', '河北任县农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2305, 1, '河南沈丘农村商业银行', '河南沈丘农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2306, 1, '河北广宗农村商业银行', '河北广宗农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2307, 1, '河南淮滨农村商业银行', '河南淮滨农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2308, 1, '河北巨鹿农村商业银行', '河北巨鹿农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2309, 1, '河南鹿邑农村商业银行', '河南鹿邑农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2310, 1, '河北柏乡农村商业银行', '河北柏乡农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2311, 1, '河南内乡农村商业银行', '河南内乡农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2312, 1, '河北邢州农村商业银行', '河北邢州农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2313, 1, '河南延津农村商业银行', '河南延津农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2314, 1, '河北涉县农村商业银行', '河北涉县农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2315, 1, '河南原阳农村商业银行', '河南原阳农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2316, 1, '河北邯郸农村商业银行', '河北邯郸农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2317, 1, '河南长垣农村商业银行', '河南长垣农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2318, 1, '河北大名农村商业银行', '河北大名农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2319, 1, '河南沁阳农村商业银行', '河南沁阳农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2320, 1, '河北鸡泽农村商业银行', '河北鸡泽农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2321, 1, '河南博爱农村商业银行', '河南博爱农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2322, 1, '山西阳曲农村商业银行', '山西阳曲农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2323, 1, '周口农村商业银行', '周口农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2324, 1, '山西古交农村商业银行', '山西古交农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2325, 1, '河南柘城农村商业银行', '河南柘城农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2326, 1, '山西清徐农村商业银行', '山西清徐农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2327, 1, '河南扶沟农村商业银行', '河南扶沟农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2328, 1, '大同农村商业银行', '大同农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2329, 1, '河南清丰农村商业银行', '河南清丰农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2330, 1, '山西左云农村商业银行', '山西左云农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2331, 1, '河南南乐农村商业银行', '河南南乐农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2332, 1, '山西灵丘农村商业银行', '山西灵丘农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2333, 1, '河南南召农村商业银行', '河南南召农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2334, 1, '朔州农村商业银行', '朔州农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2335, 1, '河南社旗农村商业银行', '河南社旗农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2336, 1, '山西山阴农村商业银行', '山西山阴农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2337, 1, '河南光山农村商业银行', '河南光山农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2338, 1, '山西怀仁农村商业银行', '山西怀仁农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2339, 1, '河南息县农村商业银行', '河南息县农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2340, 1, '山西右玉农村商业银行', '山西右玉农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2341, 1, '濮阳农村商业银行', '濮阳农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2342, 1, '山西忻州农村商业银行', '山西忻州农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2343, 1, '河南汝南农村商业银行', '河南汝南农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2344, 1, '山西五台农村商业银行', '山西五台农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2345, 1, '河南泌阳农村商业银行', '河南泌阳农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2346, 1, '山西原平农村商业银行', '山西原平农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2347, 1, '河南项城农村商业银行', '河南项城农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2348, 1, '山西繁峙农村商业银行', '山西繁峙农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2349, 1, '河南镇平农村商业银行', '河南镇平农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2350, 1, '山西宁武农村商业银行', '山西宁武农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2351, 1, '河南潢川农村商业银行', '河南潢川农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2352, 1, '山西静乐农村商业银行', '山西静乐农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2353, 1, '河南平舆农村商业银行', '河南平舆农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2354, 1, '山西神池农村商业银行', '山西神池农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2355, 1, '郑州农村商业银行', '郑州农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2356, 1, '山西五寨农村商业银行', '山西五寨农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2357, 1, '河南灵宝农村商业银行', '河南灵宝农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2358, 1, '山西岢岚农村商业银行', '山西岢岚农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2359, 1, '河南新野农村商业银行', '河南新野农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2360, 1, '山西河曲农村商业银行', '山西河曲农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2361, 1, '山西保德农村商业银行', '山西保德农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2362, 1, '武汉农村商业银行', '武汉农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2363, 1, '山西榆社农村商业银行', '山西榆社农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2364, 1, '黄石农村商业银行', '黄石农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2365, 1, '山西左权农村商业银行', '山西左权农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2366, 1, '湖北大冶农村商业银行', '湖北大冶农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2367, 1, '山西和顺农村商业银行', '山西和顺农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2368, 1, '湖北阳新农村商业银行', '湖北阳新农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2369, 1, '湖北十堰农村商业银行', '湖北十堰农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2370, 1, '山西寿阳农村商业银行', '山西寿阳农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2371, 1, '湖北竹溪农村商业银行', '湖北竹溪农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2372, 1, '山西榆次农村商业银行', '山西榆次农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');
INSERT INTO `cere_platform_dict` VALUES (2373, 1, '湖北郧县农村商业银行', '湖北郧县农村商业银行', '2020-11-22 05:25:46', '2020-11-23 23:12:22');

-- ----------------------------
-- Table structure for cere_platform_discount
-- ----------------------------
DROP TABLE IF EXISTS `cere_platform_discount`;
CREATE TABLE `cere_platform_discount`  (
  `discount_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '平台限时折扣活动id',
  `discount_name` varchar(60) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '活动名称',
  `remark` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `sign_start_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '报名开始时间',
  `sign_end_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '报名结束时间',
  `start_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '活动开始时间',
  `end_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '活动结束时间',
  `if_limit` tinyint(1) NOT NULL COMMENT '商品限购 1-不限购 2-限购',
  `limit_number` int(11) NULL DEFAULT NULL COMMENT '限购几件/人',
  `if_add` tinyint(1) NOT NULL COMMENT '优惠券是否叠加 1-是 0-否',
  `state` tinyint(1) NULL DEFAULT 0 COMMENT '活动状态  0-报名未开始 1-报名进行中 2-活动待开始 3-活动进行中 4-活动已结束',
  `if_bond` tinyint(1) NULL DEFAULT 1 COMMENT '是否需要保证金  1-是 0-否',
  `bond_money` decimal(15, 2) NULL DEFAULT NULL COMMENT '保证金金额',
  `discount` decimal(10, 2) NULL DEFAULT NULL COMMENT '打几折',
  `create_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`discount_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 61 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '平台限时折扣活动信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_platform_express
-- ----------------------------
DROP TABLE IF EXISTS `cere_platform_express`;
CREATE TABLE `cere_platform_express`  (
  `platform_user_id` bigint(20) NULL DEFAULT NULL COMMENT '操作人用户id   初始化为空',
  `express_type` tinyint(1) NOT NULL DEFAULT 1 COMMENT '对接第三方快递类型 1-快递100 2-快递鸟',
  `update_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新时间'
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '物流查询策略表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of cere_platform_express
-- ----------------------------
INSERT INTO `cere_platform_express` VALUES (1, 1, NULL);

-- ----------------------------
-- Table structure for cere_platform_label
-- ----------------------------
DROP TABLE IF EXISTS `cere_platform_label`;
CREATE TABLE `cere_platform_label`  (
  `buyer_label_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '客户标签id',
  `label_name` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '标签名称',
  `label_type` tinyint(1) NOT NULL DEFAULT 1 COMMENT '标签类型 1-手动标签 2-自动标签',
  `meet_conditions` tinyint(1) NOT NULL DEFAULT 1 COMMENT '满足条件 1-满足任意一个被选中条件即可  2-必须满足所有被选中条件',
  `last_consumption_time` tinyint(1) NULL DEFAULT 1 COMMENT '是否选中最后消费时间 1-是 0-否',
  `consumption_frequency` tinyint(1) NULL DEFAULT 1 COMMENT '是否选中累计消费次数  1-是 0-否',
  `consumption_money` tinyint(1) NULL DEFAULT 1 COMMENT '是否选中累计交易金额 1-是 0-否',
  `consumption_day` int(11) NULL DEFAULT NULL COMMENT '最近几天（天）',
  `consumption_start_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '最后消费开始时间',
  `consumption_end_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '最后消费结束时间',
  `frequency_start` int(11) NULL DEFAULT NULL COMMENT '起始次数',
  `frequency_end` int(11) NULL DEFAULT NULL COMMENT '截止次数',
  `money_start` decimal(15, 2) NULL DEFAULT NULL COMMENT '起始金额',
  `money_end` decimal(15, 2) NULL DEFAULT NULL COMMENT '截止金额',
  `create_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`buyer_label_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 12 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '平台标签信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_platform_log
-- ----------------------------
DROP TABLE IF EXISTS `cere_platform_log`;
CREATE TABLE `cere_platform_log`  (
  `log_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `platform_user_id` bigint(20) NOT NULL COMMENT '关联用户id',
  `module` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '模块名称',
  `operation` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '操作对应工程',
  `operation_describtion` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '操作功能描述',
  `only` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '操作功能对应唯一标识id',
  `create_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '操作时间',
  PRIMARY KEY (`log_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 37643 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '平台系统日志表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_platform_member_level
-- ----------------------------
DROP TABLE IF EXISTS `cere_platform_member_level`;
CREATE TABLE `cere_platform_member_level`  (
  `member_level_id` bigint(11) NOT NULL AUTO_INCREMENT COMMENT '会员等级id',
  `member_level_name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '等级名称',
  `member_level_icon` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '等级图标地址',
  `member_level_background` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '等级背景图地址',
  `growth` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '成长值',
  `member_ids` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '会员权益id(多个以逗号隔开)',
  `member_level_reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '会员等级说明',
  `create_time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`member_level_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 16 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '平台会员等级信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of cere_platform_member_level
-- ----------------------------
INSERT INTO `cere_platform_member_level` VALUES (1, '白银会员', 'https://zk-cereshop.oss-cn-shenzhen.aliyuncs.com/test/2022-01-05/2190cc5373d84e508f5444772b9721ee%E7%BB%84%2014033%402x%20%281%29.png', 'https://zk-cereshop.oss-cn-shenzhen.aliyuncs.com/test/2022-01-06/f8c886e4adf54d29b88fd4273ec74628%E7%BB%84%2015261%402x.png', 3800, '1,3,4,2', '白银会员', '2021-08-16 12:00:00', '2023-10-29 09:24:17');
INSERT INTO `cere_platform_member_level` VALUES (2, '铂金会员', 'https://zk-cereshop.oss-cn-shenzhen.aliyuncs.com/test/2022-01-05/7c0b2513f538444787d72086f8172987%E7%BB%84%2014033%402x.png', 'https://zk-cereshop.oss-cn-shenzhen.aliyuncs.com/test/2022-01-06/5ad279604c2d4a7891a2ba8d46dde158%E7%BB%84%2015263%402x.png', 8800, '1,2', '钻石会员说明', '2021-08-16 19:40:33', '2022-01-06 11:44:57');
INSERT INTO `cere_platform_member_level` VALUES (6, '黄金会员', 'https://zk-cereshop.oss-cn-shenzhen.aliyuncs.com/test/2022-01-05/37e9bada235a4d239ed211fba9f87cf2%E7%BB%84%2014033%402x%20%284%29.png', 'https://zk-cereshop.oss-cn-shenzhen.aliyuncs.com/test/2022-01-06/b73b88da877b453bb481b271b1e9a933%E7%BB%84%2015262%402x.png', 5000, '1,2,3,4', '铂金会员', '2021-08-25 21:42:45', '2022-01-06 11:44:53');
INSERT INTO `cere_platform_member_level` VALUES (13, '钻石会员', 'https://zk-cereshop.oss-cn-shenzhen.aliyuncs.com/test/2022-01-05/3206485c00164839b0f3e10e1a040d46%E7%BB%84%2014033%402x%20%283%29.png', 'https://zk-cereshop.oss-cn-shenzhen.aliyuncs.com/test/2022-01-06/877017e18e2d4e2d9a13084e061a9c95%E7%BB%84%2015264%402x.png', 10000, '2,3', '超级会员说明', '2021-08-31 23:09:41', '2022-01-06 14:45:29');
INSERT INTO `cere_platform_member_level` VALUES (15, '普通会员', 'https://zk-cereshop.oss-cn-shenzhen.aliyuncs.com/test/2022-01-05/38c1a88205614309b0ffe0aa125e1a75%E7%BB%84%2014033%402x.png', 'https://zk-cereshop.oss-cn-shenzhen.aliyuncs.com/test/2022-01-06/0f1652d5266d4e3197284443c7b31ace%E7%BB%84%2015260%402x.png', 0, '4,3,2', '新用户注册即为普通会员', '2021-10-12 21:09:15', '2022-01-06 11:44:38');

-- ----------------------------
-- Table structure for cere_platform_membership
-- ----------------------------
DROP TABLE IF EXISTS `cere_platform_membership`;
CREATE TABLE `cere_platform_membership`  (
  `member_id` bigint(11) NOT NULL AUTO_INCREMENT COMMENT '会员权益id',
  `member_name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '权益名称',
  `member_icon` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '权益图标地址',
  `member_reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '权益说明',
  `create_time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`member_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 15 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '会员权益信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of cere_platform_membership
-- ----------------------------
INSERT INTO `cere_platform_membership` VALUES (1, '会员折扣', 'https://zk-cereshop.oss-cn-shenzhen.aliyuncs.com/zkthink/2022-01-14/d5eea656b5304f5881f26df83ce188f0_组 14023@3x.png', '无', '2021-08-17 12:00:00', '2022-01-14 17:07:46');
INSERT INTO `cere_platform_membership` VALUES (2, '全场包邮', 'https://zk-cereshop.oss-cn-shenzhen.aliyuncs.com/zkthink/2022-01-14/2a9103032aab4eb6b46f278be9ea7724_组 14028@3x.png', '无', '2021-08-17 12:00:00', '2022-01-14 17:07:57');
INSERT INTO `cere_platform_membership` VALUES (3, '专属标识', 'https://zk-cereshop.oss-cn-shenzhen.aliyuncs.com/zkthink/2022-01-14/9a4889c712cd44a39bb02133ad81c46d_组 14026@3x.png', '无', '2021-08-17 12:00:00', '2022-01-14 17:08:09');
INSERT INTO `cere_platform_membership` VALUES (4, '专属客服', 'https://zk-cereshop.oss-cn-shenzhen.aliyuncs.com/zkthink/2022-01-14/a685e58754ad4653955d348cdfc260bd_组 14025@3x.png', '无', '2021-08-17 12:00:00', '2022-01-14 17:08:29');
INSERT INTO `cere_platform_membership` VALUES (13, '普通权益', 'https://zk-cereshop.oss-cn-shenzhen.aliyuncs.com/test/2021-10-12/a84c96f52cb0407c9002e9d4072dba06normal_privilege.png', '普通权益说明', '2021-08-31 23:09:41', '2021-10-12 21:19:12');

-- ----------------------------
-- Table structure for cere_platform_permission
-- ----------------------------
DROP TABLE IF EXISTS `cere_platform_permission`;
CREATE TABLE `cere_platform_permission`  (
  `permission_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '权限id',
  `permission_pid` bigint(20) NOT NULL COMMENT '父节点id',
  `permission_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '名称',
  `permission_uri` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '路由URI',
  `permission` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '组件',
  `icon` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '图标地址',
  `describe` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '文字描述',
  `resource_type` enum('menu','button','catalog') CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '权限类型',
  `sort` int(11) NULL DEFAULT NULL COMMENT '排序号',
  `project` bigint(11) NULL DEFAULT NULL,
  `create_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`permission_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5419 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '权限菜单信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of cere_platform_permission
-- ----------------------------
INSERT INTO `cere_platform_permission` VALUES (1, 0, '系统管理', '', 'system', 'zk-icon-menu', '目录菜单', 'catalog', 1, 1, '2020-11-12 11:44:56', '2021-12-17 16:23:25');
INSERT INTO `cere_platform_permission` VALUES (2, 1, '字典管理', '', '/setup/dict', 'DocumentAdd', '字典菜单', 'menu', 2, 1, '2020-11-12 12:44:56', '2020-11-23 14:49:08');
INSERT INTO `cere_platform_permission` VALUES (3, 1, '角色管理', '', '/setup/role', 'DocumentDelete', '角色菜单', 'menu', 3, 1, '2020-11-12 13:44:56', '2021-11-02 14:49:54');
INSERT INTO `cere_platform_permission` VALUES (4, 1, '菜单管理', '', '/setup/tabs', 'Aim', '菜单', 'menu', 4, 1, '2020-11-12 15:44:56', '2020-12-07 17:28:09');
INSERT INTO `cere_platform_permission` VALUES (5, 1, '用户管理', '', '/setup/user', 'Magnet', '用户菜单', 'menu', 5, 1, '2020-11-12 16:44:56', '2020-11-23 14:50:04');
INSERT INTO `cere_platform_permission` VALUES (6, 2, '新增', '', 'save', '', '新增按钮', 'button', 6, 1, '2020-11-12 17:44:56', NULL);
INSERT INTO `cere_platform_permission` VALUES (7, 2, '修改', '', 'update', '', '修改按钮', 'button', 7, 1, '2020-11-12 14:45:08', NULL);
INSERT INTO `cere_platform_permission` VALUES (8, 2, '删除', '', 'delete', '', '删除按钮', 'button', 8, 1, '2020-11-12 14:46:05', NULL);
INSERT INTO `cere_platform_permission` VALUES (9, 4, '新增父级菜单', '', 'save', 'el-icon-eleme', '新增按钮', 'button', 9, 1, '2020-11-12 16:43:44', '2020-12-07 14:50:16');
INSERT INTO `cere_platform_permission` VALUES (10, 4, '新增子级菜单', '', 'update', 'el-icon-minus', '修改按钮', 'button', 10, 1, '2020-11-12 16:43:56', '2020-12-07 14:50:39');
INSERT INTO `cere_platform_permission` VALUES (11, 4, '新增子级按钮', '', 'delete', 'el-icon-download', '删除按钮', 'button', 11, 1, '2020-11-12 16:44:07', '2020-12-07 14:50:54');
INSERT INTO `cere_platform_permission` VALUES (17, 0, '客户管理', '', 'customer', 'FirstAidKit', '客户', 'menu', 17, 1, '2020-11-24 09:16:30', NULL);
INSERT INTO `cere_platform_permission` VALUES (19, 0, '客户管理', '', 'sensitive', 'icon-user', '客户管理', 'menu', 19, 1, '2020-11-24 09:31:27', NULL);
INSERT INTO `cere_platform_permission` VALUES (20, 0, '231', '', '213', 'zk-icon-cash', '321', 'menu', 20, 1, '2020-11-24 09:35:17', NULL);
INSERT INTO `cere_platform_permission` VALUES (21, 18, '客户管理', '', '/customer/customerMage', 'icon-form', '啥', 'menu', 21, 1, '2020-11-24 09:41:37', '2020-12-07 17:50:40');
INSERT INTO `cere_platform_permission` VALUES (22, 18, '标签管理', '', '/customer/tips', 'zk-icon-commodity-set', '标签', 'menu', 22, 1, '2020-11-24 09:42:23', '2020-12-07 17:51:06');
INSERT INTO `cere_platform_permission` VALUES (23, 0, '评论', '', 'comment', 'zk-icon-coupon', '评论', 'menu', 23, 1, '2020-11-24 09:44:58', NULL);
INSERT INTO `cere_platform_permission` VALUES (24, 0, '评论管理', '', 'comment', 'zk-icon-scene', '评论', 'catalog', 24, 1, '2020-11-24 09:45:29', '2021-12-17 16:27:13');
INSERT INTO `cere_platform_permission` VALUES (25, 24, '敏感词管理', '', '/comment/sensitive', 'zk-icon-finance', '敏感词', 'menu', 25, 1, '2020-11-24 09:46:18', NULL);
INSERT INTO `cere_platform_permission` VALUES (26, 24, '评论管理', '', '/comment/commentSys', 'zk-icon-fullscreen', '搜索', 'menu', 26, 1, '2020-11-24 09:46:47', NULL);
INSERT INTO `cere_platform_permission` VALUES (27, 2, '添加', '', '1', 'zk-icon-label', '', 'button', 27, 1, '2020-12-07 01:32:37', NULL);
INSERT INTO `cere_platform_permission` VALUES (28, 0, '评论', '', 'comment', 'zk-icon-logistics-set', '这是评论', 'menu', 28, 1, '2020-12-07 14:21:46', NULL);
INSERT INTO `cere_platform_permission` VALUES (29, 0, '售后处理', '', 'comment/sensitive', 'zk-icon-management-customer', '售后', 'menu', 29, 1, '2020-12-07 14:23:51', NULL);
INSERT INTO `cere_platform_permission` VALUES (33, 0, '平台活动', '', '/active', 'zk-icon-management-rule', '', 'catalog', 32, 1, '2020-12-07 14:27:29', NULL);
INSERT INTO `cere_platform_permission` VALUES (34, 0, '商品管理', '', 'renovation', 'zk-icon-activity', '', 'catalog', 34, 1, '2020-12-07 14:29:02', '2021-12-17 16:24:33');
INSERT INTO `cere_platform_permission` VALUES (37, 34, '商品类别', '', '/renovation/commdityClass', 'zk-icon-material', '', 'menu', 37, 1, '2020-12-07 14:31:55', NULL);
INSERT INTO `cere_platform_permission` VALUES (38, 0, '商家管理', '', '/business', 'zk-icon-store-set', '', 'catalog', 38, 1, '2020-12-07 14:33:23', '2021-12-17 16:24:43');
INSERT INTO `cere_platform_permission` VALUES (39, 38, '商家列表', '', '/business/businessList', 'zk-icon-operation-plan2', '', 'menu', 39, 1, '2020-12-07 14:33:56', '2021-12-10 10:46:07');
INSERT INTO `cere_platform_permission` VALUES (40, 38, '入驻申请', '', '/business/settlement', 'zk-icon-order', '1', 'menu', 40, 1, '2020-12-07 14:49:00', '2021-12-10 10:44:34');
INSERT INTO `cere_platform_permission` VALUES (47, 22, '导出标签', '', 'excel', 'zk-icon-pending-order', '', 'button', 47, 1, '2020-12-07 15:06:28', NULL);
INSERT INTO `cere_platform_permission` VALUES (48, 24, '关键词管理', '', '/comment/keyword', 'zk-icon-price-bundling', '', 'menu', 48, 1, '2020-12-08 20:18:02', '2021-12-15 20:20:50');
INSERT INTO `cere_platform_permission` VALUES (52, 0, '订单', '', '/order', 'Connection', '', 'catalog', 52, 0, '2020-12-16 20:22:55', '2020-12-16 21:16:56');
INSERT INTO `cere_platform_permission` VALUES (53, 52, '待处理订单', '', '/order/pending', 'zk-icon-commodity-group', '', 'menu', 53, 0, '2020-12-16 20:23:44', NULL);
INSERT INTO `cere_platform_permission` VALUES (54, 52, '售后订单', '', '/order/aftersale', 'zk-icon-activity', '', 'menu', 54, 0, '2020-12-16 20:24:02', NULL);
INSERT INTO `cere_platform_permission` VALUES (55, 0, '商品', '', 'commodity', 'DataBoard', '', 'catalog', 55, 0, '2020-12-16 20:24:42', '2020-12-16 21:16:18');
INSERT INTO `cere_platform_permission` VALUES (56, 55, '商品管理', '', '/commodity/commoditySystem', 'zk-icon-binding', '', 'menu', 56, 0, '2020-12-16 20:25:05', NULL);
INSERT INTO `cere_platform_permission` VALUES (57, 55, '商品分组', '', '/commodity/commodityList', 'zk-icon-cash', '', 'menu', 57, 0, '2020-12-16 20:25:49', '2020-12-16 20:25:55');
INSERT INTO `cere_platform_permission` VALUES (58, 0, '店铺', '', '/shop', 'ScaleToOriginal', '', 'catalog', 58, 0, '2020-12-16 20:26:37', NULL);
INSERT INTO `cere_platform_permission` VALUES (59, 58, '店铺装修', '', 'https://ceres.zkthink.com/merchant-web/canvas.html', 'zk-icon-client-list', '', 'menu', 59, 0, '2020-12-16 20:27:05', '2021-09-27 17:11:58');
INSERT INTO `cere_platform_permission` VALUES (60, 58, '素材管理', '', '/shop/material', 'zk-icon-commodity-group', '', 'menu', 60, 0, '2020-12-16 20:27:38', NULL);
INSERT INTO `cere_platform_permission` VALUES (61, 0, '设置', '', '/system', 'Cpu', '', 'catalog', 61, 0, '2020-12-16 20:28:44', '2020-12-16 21:16:32');
INSERT INTO `cere_platform_permission` VALUES (62, 61, '店铺设置', '', '/system/shopSys', 'zk-icon-commodity-set', '', 'menu', 62, 0, '2020-12-16 20:29:19', NULL);
INSERT INTO `cere_platform_permission` VALUES (63, 61, '物流设置', '', '/system/logistics', 'zk-icon-commodity', '', 'menu', 63, 0, '2020-12-16 20:29:44', NULL);
INSERT INTO `cere_platform_permission` VALUES (64, 0, '财务', '', '/finance', 'PartlyCloudy', '', 'catalog', 64, 0, '2020-12-16 20:30:17', '2020-12-16 21:16:37');
INSERT INTO `cere_platform_permission` VALUES (65, 64, '财务明细', '', '/finance/list', 'zk-icon-customer-details', '', 'menu', 65, 0, '2020-12-16 20:30:33', '2021-12-23 17:28:27');
INSERT INTO `cere_platform_permission` VALUES (66, 64, '收款账户', '', '/finance/account', 'zk-icon-exit-fullscreen', '', 'menu', 66, 0, '2020-12-16 20:30:53', '2021-12-23 17:29:10');
INSERT INTO `cere_platform_permission` VALUES (67, 0, '分销员', '', '/Distributor/DistributorIndex', 'zk-icon-operation-plan2', '', 'catalog', 67, 0, '2020-12-16 20:31:31', '2021-12-24 10:37:14');
INSERT INTO `cere_platform_permission` VALUES (68, 0, '平台活动', '', '/active', 'More', '', 'catalog', 68, 0, '2020-12-16 20:31:55', '2021-12-23 17:27:29');
INSERT INTO `cere_platform_permission` VALUES (69, 0, '系统管理', '', '/setup', 'Operation', '', 'catalog', 69, 0, '2020-12-16 20:32:27', '2020-12-16 21:16:46');
INSERT INTO `cere_platform_permission` VALUES (70, 69, '用户管理', '', '/setup/user', 'UserFilled', '', 'menu', 70, 0, '2020-12-16 20:32:51', NULL);
INSERT INTO `cere_platform_permission` VALUES (71, 69, '角色管理', '', '/setup/role', 'Tickets', '', 'menu', 71, 0, '2020-12-16 20:33:16', NULL);
INSERT INTO `cere_platform_permission` VALUES (72, 69, '菜单管理', '', '/setup/tabs', 'Memo', '', 'menu', 72, 0, '2020-12-16 20:33:36', NULL);
INSERT INTO `cere_platform_permission` VALUES (73, 64, '保证金', '', '/finance/bond', 'Magnet', '', 'menu', 73, 0, '2020-12-16 22:26:08', NULL);
INSERT INTO `cere_platform_permission` VALUES (74, 0, '财务管理', '', '/finance', 'zk-icon-sales-order', '', 'catalog', 74, 1, '2020-12-17 21:47:27', '2021-09-03 19:01:37');
INSERT INTO `cere_platform_permission` VALUES (75, 74, '提现申请', '', '/finance/withdrawal', 'Help', '', 'menu', 75, 1, '2020-12-17 21:53:16', '2020-12-17 21:53:33');
INSERT INTO `cere_platform_permission` VALUES (76, 74, '财务概况', '', '/finance/overview', 'Soccer', '', 'menu', 76, 1, '2020-12-17 21:59:24', NULL);
INSERT INTO `cere_platform_permission` VALUES (77, 74, '保证金', '', '/finance/bond', 'ToiletPaper', '', 'menu', 77, 1, '2020-12-17 22:40:44', '2020-12-17 22:41:56');
INSERT INTO `cere_platform_permission` VALUES (78, 74, '用户提现申请', NULL, '/finance/application', 'ReadingLamp', NULL, 'menu', 78, 1, '2020-12-17 22:40:45', NULL);
INSERT INTO `cere_platform_permission` VALUES (79, 56, '批量导入', '', 'l', 'el-icon-minus', '', 'button', 79, 0, '2020-12-18 00:28:06', NULL);
INSERT INTO `cere_platform_permission` VALUES (80, 56, '新增商品', '', 's', 'el-icon-minus', '', 'button', 80, 0, '2020-12-18 00:28:34', NULL);
INSERT INTO `cere_platform_permission` VALUES (81, 57, '新增分组', '', 'add', 'el-icon-minus', '', 'button', 81, 0, '2020-12-18 00:29:28', NULL);
INSERT INTO `cere_platform_permission` VALUES (82, 60, '新增标签', '', 'add', 'el-icon-minus', '', 'button', 82, 0, '2020-12-18 00:30:06', NULL);
INSERT INTO `cere_platform_permission` VALUES (83, 60, '上传', '', 'upload', 'el-icon-minus', '', 'button', 83, 0, '2020-12-18 00:30:29', NULL);
INSERT INTO `cere_platform_permission` VALUES (84, 63, '新建方案', '', 'add', 'el-icon-minus', '', 'button', 84, 0, '2020-12-18 00:30:58', NULL);
INSERT INTO `cere_platform_permission` VALUES (496, 0, '终端装修', '', 'https://ceres.zkthink.com/admin-web/canvas.html', 'zk-icon-shop-decoration', '页面装修', 'catalog', 496, 1, '2021-01-13 23:37:04', '2021-12-17 16:25:05');
INSERT INTO `cere_platform_permission` VALUES (578, 0, '消息中心', '', 'notice', 'zk-icon-management-server', '消息中心', 'catalog', 578, 1, '2021-03-11 21:24:32', '2021-12-17 16:25:16');
INSERT INTO `cere_platform_permission` VALUES (579, 578, '历史消息', '', '/notice/history', 'Paperclip', '历史消息', 'menu', 579, 1, '2021-03-11 21:25:43', NULL);
INSERT INTO `cere_platform_permission` VALUES (580, 578, '消息推送', '', '/notice/push', 'MagicStick', '消息推送', 'menu', 580, 1, '2021-03-11 21:26:21', NULL);
INSERT INTO `cere_platform_permission` VALUES (707, 0, '营销活动', NULL, '/marketing', 'Avatar', NULL, 'catalog', 707, 0, '2021-03-21 15:47:37', NULL);
INSERT INTO `cere_platform_permission` VALUES (708, 707, '优惠券管理', NULL, '/marketing/coupon', 'zk-icon-finance-details', NULL, 'menu', 708, 0, '2021-03-21 15:47:37', NULL);
INSERT INTO `cere_platform_permission` VALUES (709, 707, '拼团', NULL, '/marketing/group', 'zk-icon-fullscreen', NULL, 'menu', 709, 0, '2021-03-21 15:47:37', '2021-12-24 17:07:09');
INSERT INTO `cere_platform_permission` VALUES (710, 707, '秒杀', NULL, '/marketing/spike', 'zk-icon-group-booking', NULL, 'menu', 710, 0, '2021-03-21 15:47:37', NULL);
INSERT INTO `cere_platform_permission` VALUES (711, 707, '限时折扣', NULL, '/marketing/discount', 'zk-icon-label', NULL, 'menu', 711, 0, '2021-03-21 15:47:37', NULL);
INSERT INTO `cere_platform_permission` VALUES (712, 0, '客户管理', NULL, '/customer', 'Promotion', NULL, 'catalog', 712, 0, '2021-03-21 15:47:37', NULL);
INSERT INTO `cere_platform_permission` VALUES (713, 712, '客户列表', NULL, '/customer/customerList', 'zk-icon-logistics-set', NULL, 'menu', 713, 0, '2021-03-21 15:47:37', NULL);
INSERT INTO `cere_platform_permission` VALUES (714, 712, '标签列表', NULL, '/customer/tagList', 'zk-icon-management-customer', NULL, 'menu', 714, 0, '2021-03-21 15:47:37', NULL);
INSERT INTO `cere_platform_permission` VALUES (715, 712, '客户分群', NULL, '/customer/clusteringList', 'zk-icon-management-rule', NULL, 'menu', 715, 0, '2021-03-21 15:47:37', NULL);
INSERT INTO `cere_platform_permission` VALUES (747, 712, '运营计划', '', '/customer/operate', 'zk-icon-marketing', '', 'menu', 747, 0, '2021-03-18 18:31:30', NULL);
INSERT INTO `cere_platform_permission` VALUES (910, 1, '商家菜单', '', '/setup/businessMenus', 'Basketball', '管理商家菜单', 'menu', 880, 1, '2021-03-26 23:15:19', NULL);
INSERT INTO `cere_platform_permission` VALUES (911, 33, '优惠券活动', '', '/active/couponlist', 'Baseball', '', 'menu', 887, 1, '2021-08-21 17:39:04', '2021-12-07 15:47:05');
INSERT INTO `cere_platform_permission` VALUES (914, 33, '秒杀活动', '', '/active/seckilllist', 'zk-icon-spell-group', '', 'menu', 884, 1, '2021-08-21 17:56:10', '2021-12-07 15:46:51');
INSERT INTO `cere_platform_permission` VALUES (915, 33, '限时折扣', '', '/active/discountlist', 'zk-icon-store-set', '', 'menu', 885, 1, '2021-08-21 17:56:58', '2021-12-07 15:46:56');
INSERT INTO `cere_platform_permission` VALUES (916, 33, '支付有礼', '', '/active/politelist', 'zk-icon-store', '', 'menu', 886, 1, '2021-08-21 17:57:33', '2021-12-07 15:47:01');
INSERT INTO `cere_platform_permission` VALUES (918, 0, '会员管理', '', '/member', 'zk-icon-management-customer', '', 'catalog', 18, 1, '2021-08-24 11:02:34', '2021-12-17 16:23:50');
INSERT INTO `cere_platform_permission` VALUES (919, 918, '会员管理', '', '/member/memberList', 'Coin', '', 'menu', 893, 1, '2021-08-24 14:54:18', '2021-08-28 16:10:53');
INSERT INTO `cere_platform_permission` VALUES (920, 918, '会员标签', '', '/member/tips', 'Goods', '', 'menu', 894, 1, '2021-08-24 16:09:53', '2021-08-26 14:32:03');
INSERT INTO `cere_platform_permission` VALUES (922, 920, '导出', '', 'excel', 'Sell', '', 'button', 896, 1, '2021-08-24 16:17:36', NULL);
INSERT INTO `cere_platform_permission` VALUES (923, 918, '会员权益', '', '/member/equity', 'SoldOut', '', 'menu', 989, 1, '2021-08-24 16:43:12', NULL);
INSERT INTO `cere_platform_permission` VALUES (924, 918, '会员等级', '', '/member/levelList', 'Key', '', 'menu', 990, 1, '2021-08-25 17:50:46', NULL);
INSERT INTO `cere_platform_permission` VALUES (927, 0, '订单管理', '', '/order', 'ShoppingCart', '', 'catalog', 16, 1, '2021-08-28 19:33:11', '2021-09-03 19:00:33');
INSERT INTO `cere_platform_permission` VALUES (928, 927, '订单管理', '', '/order/pending', 'ShoppingCartFull', '', 'menu', 993, 1, '2021-08-28 19:43:40', NULL);
INSERT INTO `cere_platform_permission` VALUES (929, 927, '售后处理', '', '/order/after', 'ShoppingTrolley', '', 'menu', 994, 1, '2021-08-28 19:45:02', '2021-08-28 20:57:11');
INSERT INTO `cere_platform_permission` VALUES (979, 707, '场景营销', '', '/marketing/scene', 'zk-icon-material', '', 'menu', 1011, 0, '2021-08-30 12:01:30', NULL);
INSERT INTO `cere_platform_permission` VALUES (980, 707, '组合捆绑', '', '/marketing/compose', 'zk-icon-member', '', 'menu', 1012, 0, '2021-08-30 12:02:28', NULL);
INSERT INTO `cere_platform_permission` VALUES (981, 707, '定价捆绑', '', '/marketing/price', 'zk-icon-menu', '', 'menu', 1013, 0, '2021-08-30 12:03:04', NULL);
INSERT INTO `cere_platform_permission` VALUES (1201, 34, '商品管理', '', '/renovation/commoditySystem', 'Phone', '', 'menu', 36, 1, '2021-09-03 11:11:07', '2021-09-03 11:12:00');
INSERT INTO `cere_platform_permission` VALUES (1603, 1602, '汽车管理', '', '/carManage/carList', 'Scissor', '汽车列表管理', 'menu', 1172, 1, '2021-11-20 16:15:25', '2021-11-20 16:48:43');
INSERT INTO `cere_platform_permission` VALUES (1604, 1602, '汽车类别', '', '/carManage/carType', 'Handbag', '汽车类别', 'menu', 1173, 1, '2021-11-20 17:00:43', NULL);
INSERT INTO `cere_platform_permission` VALUES (1605, 1602, '类别参数', '', '/carManage/typeParam', 'ShoppingBag', '类别参数', 'menu', 1174, 1, '2021-11-21 16:49:46', NULL);
INSERT INTO `cere_platform_permission` VALUES (1607, 1606, '房产管理', '', '/houseManage/houseList', 'Trophy', '', 'button', 1176, 1, '2021-11-24 09:42:13', '2021-11-24 09:43:25');
INSERT INTO `cere_platform_permission` VALUES (1609, 1608, '房产管理', '', '/houseManage/houseList', 'TrophyBase', '', 'menu', 1178, 1, '2021-11-24 09:46:10', NULL);
INSERT INTO `cere_platform_permission` VALUES (1610, 1608, '房产类型', '', '/houseManage/houseType', 'Stopwatch', '', 'menu', 1179, 1, '2021-11-24 09:53:26', '2021-11-24 09:56:12');
INSERT INTO `cere_platform_permission` VALUES (1611, 1608, '类别参数', '', '/houseManage/houseTypeParam', 'Timer', '', 'menu', 1180, 1, '2021-11-24 09:55:32', NULL);
INSERT INTO `cere_platform_permission` VALUES (1613, 1612, '沙石管理', '', '/sandManage/sandList', 'CollectionTag', '', 'menu', 1182, 1, '2021-11-24 10:03:11', NULL);
INSERT INTO `cere_platform_permission` VALUES (1614, 1612, '沙石类型', '', '/sandManage/sandType', 'TakeawayBox', '', 'menu', 1183, 1, '2021-11-24 10:04:03', NULL);
INSERT INTO `cere_platform_permission` VALUES (1615, 1612, '类别分类', '', '/sandManage/sandTypeParam', 'PriceTag', '', 'menu', 1184, 1, '2021-11-24 10:04:58', NULL);
INSERT INTO `cere_platform_permission` VALUES (1617, 1616, '再生管理', '', '/renewManage/renewList', 'Wallet', '', 'menu', 1186, 1, '2021-11-24 10:16:45', NULL);
INSERT INTO `cere_platform_permission` VALUES (1618, 1616, '再生类型', '', '/renewManage/renewType', 'Opportunity', '', 'menu', 1187, 1, '2021-11-24 10:17:22', NULL);
INSERT INTO `cere_platform_permission` VALUES (1619, 1616, '类别参数', '', '/renewManage/renewTypeParam', 'PhoneFilled', '', 'menu', 1188, 1, '2021-11-24 10:18:10', NULL);
INSERT INTO `cere_platform_permission` VALUES (1621, 1620, '税务管理', '', '/taxManage/taxList', 'WalletFilled', '', 'menu', 1190, 1, '2021-11-24 10:20:57', NULL);
INSERT INTO `cere_platform_permission` VALUES (1622, 1620, '税务类型', '', '/taxManage/taxType', 'GoodsFilled', '', 'menu', 1191, 1, '2021-11-24 10:21:26', NULL);
INSERT INTO `cere_platform_permission` VALUES (1623, 1620, '类别参数', '', '/taxManage/taxTypeParam', 'Flag', '', 'menu', 1192, 1, '2021-11-24 10:21:59', NULL);
INSERT INTO `cere_platform_permission` VALUES (1624, 0, '直播管理', '', '/liveMenu', 'BrushFilled', '', 'menu', 1193, 1, '2021-12-01 17:09:42', NULL);
INSERT INTO `cere_platform_permission` VALUES (1625, 0, '直播管理', '', '/liveMenu', 'Briefcase', '', 'catalog', 1194, 1, '2021-12-01 17:11:55', '2021-12-17 16:26:02');
INSERT INTO `cere_platform_permission` VALUES (1626, 0, '广告管理', '', '/adCoverConfig', 'el-icon-orange', '', 'menu', 1195, 1, '2021-12-01 17:12:17', NULL);
INSERT INTO `cere_platform_permission` VALUES (1627, 1625, '直播间管理', '', '/liveMenu/liveRoom', 'Headset', '', 'menu', 1196, 1, '2021-12-01 17:14:15', NULL);
INSERT INTO `cere_platform_permission` VALUES (1628, 0, '广告管理', '', '/adCoverConfig', 'el-icon-orange', '', 'menu', 1197, 1, '2021-12-01 17:14:24', NULL);
INSERT INTO `cere_platform_permission` VALUES (1629, 1625, '直播商品管理', '', '/liveMenu/liveProduct', 'Printer', '', 'menu', 1198, 1, '2021-12-01 17:15:02', NULL);
INSERT INTO `cere_platform_permission` VALUES (1630, 0, '广告管理', '', '/ad', 'zk-icon-operation-plan2', '', 'catalog', 1199, 1, '2021-12-01 17:16:25', '2021-12-17 16:26:14');
INSERT INTO `cere_platform_permission` VALUES (1631, 1630, '广告管理', '', '/ad/coverConfig', 'Calendar', '', 'menu', 1200, 1, '2021-12-01 17:17:35', '2021-12-01 17:35:24');
INSERT INTO `cere_platform_permission` VALUES (1632, 0, '风控管理', '', '/risk', 'zk-icon-finance-details', '', 'catalog', 1201, 1, '2021-12-01 18:51:54', '2021-12-17 16:26:29');
INSERT INTO `cere_platform_permission` VALUES (1685, 1632, 'IP黑名单', '', '/risk/IPBlacklist', 'CreditCard', '', 'menu', 1220, 1, '2021-12-06 15:24:02', '2021-12-06 15:25:25');
INSERT INTO `cere_platform_permission` VALUES (1686, 1632, '用户黑名单', '', '/risk/userBlacklist', 'Box', '', 'menu', 1221, 1, '2021-12-06 15:30:26', NULL);
INSERT INTO `cere_platform_permission` VALUES (1687, 1632, '风控规则', '', '/risk/riskRules', 'Money', '', 'menu', 1222, 1, '2021-12-06 15:31:36', NULL);
INSERT INTO `cere_platform_permission` VALUES (1688, 0, '客服配置', '', '/customerService', 'Refrigerator', '', 'menu', 1223, 1, '2021-12-06 17:17:11', NULL);
INSERT INTO `cere_platform_permission` VALUES (1689, 0, '客服管理', '', '/customerService', 'Cpu', '', 'button', 1224, 1, '2021-12-06 17:19:19', NULL);
INSERT INTO `cere_platform_permission` VALUES (1690, 0, '客服配置', '', 'customerService', 'Football', '', 'menu', 1225, 1, '2021-12-06 17:19:54', '2021-12-06 17:26:55');
INSERT INTO `cere_platform_permission` VALUES (1693, 0, '客服配置', '', 'customerService', 'Brush', '', 'menu', 1226, 1, '2021-12-06 17:28:33', '2021-12-08 14:55:07');
INSERT INTO `cere_platform_permission` VALUES (1697, 1696, '测试秒杀活动', '', '/active/seckill', 'Suitcase', '', 'menu', 1229, 1, '2021-12-07 15:56:49', '2021-12-07 16:05:10');
INSERT INTO `cere_platform_permission` VALUES (1698, 1696, '测试限时折扣', '', '/active/discount', 'SuitcaseLine', '', 'menu', 1230, 1, '2021-12-07 16:03:33', NULL);
INSERT INTO `cere_platform_permission` VALUES (1699, 1696, '测试支付有礼', '', '/active/polite', 'Umbrella', '', 'menu', 1231, 1, '2021-12-07 16:04:14', NULL);
INSERT INTO `cere_platform_permission` VALUES (1700, 1696, '测试优惠卷', '', '/active/coupon', 'AlarmClock', '', 'menu', 1232, 1, '2021-12-07 16:04:51', NULL);
INSERT INTO `cere_platform_permission` VALUES (1701, 0, '积分管理', '', '/integral', 'zk-icon-finance-details', '', 'catalog', 1000, 1, '2021-12-07 18:31:06', '2021-12-17 16:25:55');
INSERT INTO `cere_platform_permission` VALUES (1702, 1701, '积分配置', '', '/integral/configuration', 'Medal', '', 'menu', 1234, 1, '2021-12-07 18:33:49', '2021-12-07 18:48:54');
INSERT INTO `cere_platform_permission` VALUES (1703, 1701, '积分记录', '', '/integral/record', 'GoldMedal', '', 'menu', 1235, 1, '2021-12-07 18:34:25', NULL);
INSERT INTO `cere_platform_permission` VALUES (1704, 1701, '签到天数配置', '', '/integral/signConfiguration', 'Present', '', 'menu', 1236, 1, '2021-12-07 18:36:13', NULL);
INSERT INTO `cere_platform_permission` VALUES (1706, 0, '客服配置', '', '/customerService', 'zk-icon-management-server', '客服配置', 'catalog', 1237, 1, '2021-12-08 14:57:02', '2021-12-17 16:26:39');
INSERT INTO `cere_platform_permission` VALUES (1707, 1706, '微信客服配置', '', '/customerService', 'Mouse', '微信客服配置', 'menu', 1238, 1, '2021-12-08 15:01:00', '2021-12-13 10:14:16');
INSERT INTO `cere_platform_permission` VALUES (2175, 68, '平台活动', '', '/active', 'More', '', 'menu', 1263, 0, '2021-12-23 17:34:48', NULL);
INSERT INTO `cere_platform_permission` VALUES (2627, 0, '直播管理', '', '/liveMenu', 'Camera', '直播管理', 'catalog', 1264, 0, '2021-12-24 09:59:35', NULL);
INSERT INTO `cere_platform_permission` VALUES (2628, 2627, '直播间管理', '', '/liveMenu/liveRoom', 'TakeawayBox', '直播间管理', 'menu', 1265, 0, '2021-12-24 10:00:30', NULL);
INSERT INTO `cere_platform_permission` VALUES (2629, 2627, '直播间商品管理', '', '/liveMenu/liveProduct', 'GoodsFilled', '直播间商品管理', 'menu', 1266, 0, '2021-12-24 10:01:22', NULL);
INSERT INTO `cere_platform_permission` VALUES (2630, 0, '客服管理', '', '/customerService', 'Cellphone', '客服管理', 'catalog', 1267, 0, '2021-12-24 10:02:19', NULL);
INSERT INTO `cere_platform_permission` VALUES (2631, 2630, '微信客服管理', '', '/customerService/service', 'zk-icon-operation-plan', '微信客服管理', 'menu', 1268, 0, '2021-12-24 10:03:18', NULL);
INSERT INTO `cere_platform_permission` VALUES (2633, 67, '分销员', '', '/distributor/index', 'zk-icon-order', '', 'menu', 1270, 0, '2021-12-24 10:37:49', '2021-12-24 17:06:55');
INSERT INTO `cere_platform_permission` VALUES (3690, 707, '渠道优惠券管理', '', '/marketing/channelCoupons', 'zk-icon-finance', '商家渠道优惠券', 'menu', 709, 0, '2021-12-27 09:32:34', '2021-12-27 18:39:55');
INSERT INTO `cere_platform_permission` VALUES (3723, 0, '测试', '', 'ceshi', 'Watch', '', 'menu', 1416, 1, '2021-12-27 19:05:53', NULL);
INSERT INTO `cere_platform_permission` VALUES (4025, 1, '手机号管理', '', '/setup/phone', 'QuartzWatch', '', 'menu', 1510, 1, '2022-02-15 15:27:54', '2022-02-15 16:08:07');
INSERT INTO `cere_platform_permission` VALUES (4092, 0, '二次认证管理', '', 'two', 'Magnet', '二次认证', 'catalog', 2, 1, '2022-02-18 10:50:01', '2022-02-18 10:55:19');
INSERT INTO `cere_platform_permission` VALUES (4094, 4092, '二次认证', '', '/setup/privacy', 'Flag', '', 'menu', 1533, 1, '2022-02-18 10:56:34', NULL);
INSERT INTO `cere_platform_permission` VALUES (4095, 0, '二次认证管理', '', 'two', 'Connection', '', 'catalog', 2, 0, '2022-02-18 17:57:13', NULL);
INSERT INTO `cere_platform_permission` VALUES (4096, 4095, '二次认证', '', '/setup/privacy', 'zk-icon-sales-order', '', 'menu', 1534, 0, '2022-02-18 17:57:55', NULL);
INSERT INTO `cere_platform_permission` VALUES (4097, 69, '手机号管理', '', '/setup/phone', 'el-icon-phone', '', 'menu', 1513, 0, '2022-02-15 18:31:09', NULL);
INSERT INTO `cere_platform_permission` VALUES (5348, 0, '渠道管理', '', '/channel', 'BrushFilled', '渠道管理', 'catalog', 10085, 1, '2022-08-25 14:20:46', '2022-08-25 14:21:04');
INSERT INTO `cere_platform_permission` VALUES (5349, 5348, '渠道列表', '', '/channel/list', 'Briefcase', '渠道列表', 'menu', 10086, 1, '2022-08-25 14:22:19', NULL);
INSERT INTO `cere_platform_permission` VALUES (5350, 707, '渠道券管理', '', '/marketing/channelManage', 'zk-icon-pending-order', '渠道券管理', 'menu', 10087, 0, '2022-08-25 15:30:26', '2022-08-25 15:31:17');
INSERT INTO `cere_platform_permission` VALUES (5351, 707, '渠道券活动', '', '/marketing/channelActivity', 'zk-icon-price-bundling', '渠道券活动', 'menu', 10088, 0, '2022-08-25 15:32:04', NULL);
INSERT INTO `cere_platform_permission` VALUES (5354, 34, '品牌管理', '', '/renovation/brand', 'Stamp', '品牌管理', 'menu', 10089, 1, '2022-08-29 14:46:58', NULL);
INSERT INTO `cere_platform_permission` VALUES (5365, 0, '二次认证管理', NULL, 'two', 'Search', NULL, 'catalog', 10091, 155, '2023-10-29 09:32:39', NULL);
INSERT INTO `cere_platform_permission` VALUES (5366, 5365, '二次认证', NULL, '/setup/privacy', 'zk-icon-sales-order', NULL, 'menu', 10092, 155, '2023-10-29 09:32:39', NULL);
INSERT INTO `cere_platform_permission` VALUES (5367, 0, '订单', NULL, '/order', 'Connection', NULL, 'catalog', 10092, 155, '2023-10-29 09:32:39', NULL);
INSERT INTO `cere_platform_permission` VALUES (5368, 5367, '待处理订单', NULL, '/order/pending', 'zk-icon-commodity-group', NULL, 'menu', 10093, 155, '2023-10-29 09:32:39', NULL);
INSERT INTO `cere_platform_permission` VALUES (5369, 5367, '售后订单', NULL, '/order/aftersale', 'zk-icon-activity', NULL, 'menu', 10094, 155, '2023-10-29 09:32:39', NULL);
INSERT INTO `cere_platform_permission` VALUES (5370, 0, '商品', NULL, 'commodity', 'DataBoard', NULL, 'catalog', 10093, 155, '2023-10-29 09:32:39', NULL);
INSERT INTO `cere_platform_permission` VALUES (5371, 5370, '商品管理', NULL, '/commodity/commoditySystem', 'zk-icon-binding', NULL, 'menu', 10094, 155, '2023-10-29 09:32:39', NULL);
INSERT INTO `cere_platform_permission` VALUES (5372, 5371, '批量导入', NULL, 'l', 'el-icon-minus', NULL, 'button', 10095, 155, '2023-10-29 09:32:39', NULL);
INSERT INTO `cere_platform_permission` VALUES (5373, 5371, '新增商品', NULL, 's', 'el-icon-minus', NULL, 'button', 10096, 155, '2023-10-29 09:32:39', NULL);
INSERT INTO `cere_platform_permission` VALUES (5374, 5370, '商品分组', NULL, '/commodity/commodityList', 'zk-icon-cash', NULL, 'menu', 10097, 155, '2023-10-29 09:32:39', NULL);
INSERT INTO `cere_platform_permission` VALUES (5375, 5374, '新增分组', NULL, 'add', 'el-icon-minus', NULL, 'button', 10098, 155, '2023-10-29 09:32:39', NULL);
INSERT INTO `cere_platform_permission` VALUES (5376, 0, '店铺', NULL, '/shop', 'ScaleToOriginal', NULL, 'catalog', 10094, 155, '2023-10-29 09:32:39', NULL);
INSERT INTO `cere_platform_permission` VALUES (5377, 5376, '店铺装修', NULL, 'https://ceres.zkthink.com/merchant-web/canvas.html', 'zk-icon-client-list', NULL, 'menu', 10095, 155, '2023-10-29 09:32:39', NULL);
INSERT INTO `cere_platform_permission` VALUES (5378, 5376, '素材管理', NULL, '/shop/material', 'zk-icon-commodity-group', NULL, 'menu', 10096, 155, '2023-10-29 09:32:39', NULL);
INSERT INTO `cere_platform_permission` VALUES (5379, 5378, '新增标签', NULL, 'add', 'el-icon-minus', NULL, 'button', 10097, 155, '2023-10-29 09:32:39', NULL);
INSERT INTO `cere_platform_permission` VALUES (5380, 5378, '上传', NULL, 'upload', 'el-icon-minus', NULL, 'button', 10098, 155, '2023-10-29 09:32:39', NULL);
INSERT INTO `cere_platform_permission` VALUES (5381, 0, '设置', NULL, '/system', 'Cpu', NULL, 'catalog', 10095, 155, '2023-10-29 09:32:39', NULL);
INSERT INTO `cere_platform_permission` VALUES (5382, 5381, '店铺设置', NULL, '/system/shopSys', 'zk-icon-commodity-set', NULL, 'menu', 10096, 155, '2023-10-29 09:32:39', NULL);
INSERT INTO `cere_platform_permission` VALUES (5383, 5381, '物流设置', NULL, '/system/logistics', 'zk-icon-commodity', NULL, 'menu', 10097, 155, '2023-10-29 09:32:39', NULL);
INSERT INTO `cere_platform_permission` VALUES (5384, 5383, '新建方案', NULL, 'add', 'el-icon-minus', NULL, 'button', 10098, 155, '2023-10-29 09:32:39', NULL);
INSERT INTO `cere_platform_permission` VALUES (5385, 0, '财务', NULL, '/finance', 'PartlyCloudy', NULL, 'catalog', 10096, 155, '2023-10-29 09:32:39', NULL);
INSERT INTO `cere_platform_permission` VALUES (5386, 5385, '财务明细', NULL, '/finance/list', 'zk-icon-customer-details', NULL, 'menu', 10097, 155, '2023-10-29 09:32:39', NULL);
INSERT INTO `cere_platform_permission` VALUES (5387, 5385, '收款账户', NULL, '/finance/account', 'zk-icon-exit-fullscreen', NULL, 'menu', 10098, 155, '2023-10-29 09:32:39', NULL);
INSERT INTO `cere_platform_permission` VALUES (5388, 5385, '保证金', NULL, '/finance/bond', 'Magnet', NULL, 'menu', 10099, 155, '2023-10-29 09:32:39', NULL);
INSERT INTO `cere_platform_permission` VALUES (5389, 0, '分销员', NULL, '/Distributor/DistributorIndex', 'zk-icon-operation-plan2', NULL, 'catalog', 10097, 155, '2023-10-29 09:32:39', NULL);
INSERT INTO `cere_platform_permission` VALUES (5390, 5389, '分销员', NULL, '/distributor/index', 'zk-icon-order', NULL, 'menu', 10098, 155, '2023-10-29 09:32:39', NULL);
INSERT INTO `cere_platform_permission` VALUES (5391, 0, '平台活动', NULL, '/active', 'More', NULL, 'catalog', 10098, 155, '2023-10-29 09:32:39', NULL);
INSERT INTO `cere_platform_permission` VALUES (5392, 5391, '平台活动', NULL, '/active', 'More', NULL, 'menu', 10099, 155, '2023-10-29 09:32:39', NULL);
INSERT INTO `cere_platform_permission` VALUES (5393, 0, '系统管理', NULL, '/setup', 'Operation', NULL, 'catalog', 10099, 155, '2023-10-29 09:32:39', NULL);
INSERT INTO `cere_platform_permission` VALUES (5394, 5393, '用户管理', NULL, '/setup/user', 'UserFilled', NULL, 'menu', 10100, 155, '2023-10-29 09:32:39', NULL);
INSERT INTO `cere_platform_permission` VALUES (5395, 5393, '角色管理', NULL, '/setup/role', 'Tickets', NULL, 'menu', 10101, 155, '2023-10-29 09:32:39', NULL);
INSERT INTO `cere_platform_permission` VALUES (5396, 5393, '菜单管理', NULL, '/setup/tabs', 'Memo', NULL, 'menu', 10102, 155, '2023-10-29 09:32:39', NULL);
INSERT INTO `cere_platform_permission` VALUES (5397, 5393, '手机号管理', NULL, '/setup/phone', 'Phone', NULL, 'menu', 10103, 155, '2023-10-29 09:32:39', NULL);
INSERT INTO `cere_platform_permission` VALUES (5398, 0, '营销活动', NULL, '/marketing', 'Avatar', NULL, 'catalog', 10100, 155, '2023-10-29 09:32:39', NULL);
INSERT INTO `cere_platform_permission` VALUES (5399, 5398, '优惠券管理', NULL, '/marketing/coupon', 'zk-icon-finance-details', NULL, 'menu', 10101, 155, '2023-10-29 09:32:39', NULL);
INSERT INTO `cere_platform_permission` VALUES (5400, 5398, '渠道优惠券管理', NULL, '/marketing/channelCoupons', 'zk-icon-finance', NULL, 'menu', 10102, 155, '2023-10-29 09:32:39', NULL);
INSERT INTO `cere_platform_permission` VALUES (5401, 5398, '拼团', NULL, '/marketing/group', 'zk-icon-fullscreen', NULL, 'menu', 10103, 155, '2023-10-29 09:32:39', NULL);
INSERT INTO `cere_platform_permission` VALUES (5402, 5398, '秒杀', NULL, '/marketing/spike', 'zk-icon-group-booking', NULL, 'menu', 10104, 155, '2023-10-29 09:32:39', NULL);
INSERT INTO `cere_platform_permission` VALUES (5403, 5398, '限时折扣', NULL, '/marketing/discount', 'zk-icon-label', NULL, 'menu', 10105, 155, '2023-10-29 09:32:39', NULL);
INSERT INTO `cere_platform_permission` VALUES (5404, 5398, '场景营销', NULL, '/marketing/scene', 'zk-icon-material', NULL, 'menu', 10106, 155, '2023-10-29 09:32:39', NULL);
INSERT INTO `cere_platform_permission` VALUES (5405, 5398, '组合捆绑', NULL, '/marketing/compose', 'zk-icon-member', NULL, 'menu', 10107, 155, '2023-10-29 09:32:39', NULL);
INSERT INTO `cere_platform_permission` VALUES (5406, 5398, '定价捆绑', NULL, '/marketing/price', 'zk-icon-menu', NULL, 'menu', 10108, 155, '2023-10-29 09:32:39', NULL);
INSERT INTO `cere_platform_permission` VALUES (5407, 5398, '渠道券管理', NULL, '/marketing/channelManage', 'zk-icon-pending-order', NULL, 'menu', 10109, 155, '2023-10-29 09:32:39', NULL);
INSERT INTO `cere_platform_permission` VALUES (5408, 5398, '渠道券活动', NULL, '/marketing/channelActivity', 'zk-icon-price-bundling', NULL, 'menu', 10110, 155, '2023-10-29 09:32:39', NULL);
INSERT INTO `cere_platform_permission` VALUES (5409, 0, '客户管理', NULL, '/customer', 'Promotion', NULL, 'catalog', 10101, 155, '2023-10-29 09:32:39', NULL);
INSERT INTO `cere_platform_permission` VALUES (5410, 5409, '客户列表', NULL, '/customer/customerList', 'zk-icon-logistics-set', NULL, 'menu', 10102, 155, '2023-10-29 09:32:39', NULL);
INSERT INTO `cere_platform_permission` VALUES (5411, 5409, '标签列表', NULL, '/customer/tagList', 'zk-icon-management-customer', NULL, 'menu', 10103, 155, '2023-10-29 09:32:39', NULL);
INSERT INTO `cere_platform_permission` VALUES (5412, 5409, '客户分群', NULL, '/customer/clusteringList', 'zk-icon-management-rule', NULL, 'menu', 10104, 155, '2023-10-29 09:32:39', NULL);
INSERT INTO `cere_platform_permission` VALUES (5413, 5409, '运营计划', NULL, '/customer/operate', 'zk-icon-marketing', NULL, 'menu', 10105, 155, '2023-10-29 09:32:39', NULL);
INSERT INTO `cere_platform_permission` VALUES (5414, 0, '直播管理', NULL, '/liveMenu', 'Camera', NULL, 'catalog', 10102, 155, '2023-10-29 09:32:39', NULL);
INSERT INTO `cere_platform_permission` VALUES (5415, 5414, '直播间管理', NULL, '/liveMenu/liveRoom', 'TakeawayBox', NULL, 'menu', 10103, 155, '2023-10-29 09:32:39', NULL);
INSERT INTO `cere_platform_permission` VALUES (5416, 5414, '直播间商品管理', NULL, '/liveMenu/liveProduct', 'GoodsFilled', NULL, 'menu', 10104, 155, '2023-10-29 09:32:39', NULL);
INSERT INTO `cere_platform_permission` VALUES (5417, 0, '客服管理', NULL, '/customerService', 'Cellphone', NULL, 'catalog', 10103, 155, '2023-10-29 09:32:39', NULL);
INSERT INTO `cere_platform_permission` VALUES (5418, 5417, '微信客服管理', NULL, '/customerService/service', 'zk-icon-operation-plan', NULL, 'menu', 10104, 155, '2023-10-29 09:32:39', NULL);

-- ----------------------------
-- Table structure for cere_platform_polite
-- ----------------------------
DROP TABLE IF EXISTS `cere_platform_polite`;
CREATE TABLE `cere_platform_polite`  (
  `polite_id` bigint(11) NOT NULL AUTO_INCREMENT COMMENT '支付有礼活动id',
  `polite_name` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '活动名称',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  `start_time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '活动开始时间',
  `end_time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '活动结束时间',
  `buyer_mode` tinyint(1) NOT NULL COMMENT '消费方式   1-购买一定金额商品 2-购买一定数量商品',
  `buyer` decimal(15, 2) NULL DEFAULT NULL COMMENT '满多少元/件,参与活动',
  `growth` int(10) NULL DEFAULT NULL COMMENT '会员成长值',
  `credit` int(11) NULL DEFAULT NULL COMMENT '积分',
  `state` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '状态 0-未开始 1-进行中 2-已结束',
  `create_time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`polite_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 42 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '平台支付有礼活动信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_platform_polite_activity
-- ----------------------------
DROP TABLE IF EXISTS `cere_platform_polite_activity`;
CREATE TABLE `cere_platform_polite_activity`  (
  `polite_id` bigint(11) NOT NULL COMMENT '平台支付有礼活动id',
  `activity_id` bigint(11) NOT NULL COMMENT '平台优惠券活动id',
  `activity_name` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '优惠券名称',
  `activity_type` tinyint(1) NOT NULL COMMENT '优惠券类型 1-满减 2-折扣',
  `threshold` decimal(15, 2) NOT NULL COMMENT '使用门槛满多少元，无门槛为0',
  `coupon_content` decimal(15, 2) NULL DEFAULT NULL COMMENT '优惠内容减多少元/打多少折'
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '平台支付有礼活动优惠券信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_platform_role
-- ----------------------------
DROP TABLE IF EXISTS `cere_platform_role`;
CREATE TABLE `cere_platform_role`  (
  `role_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '角色id',
  `role_name` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '角色名称',
  `role_describe` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '角色描述',
  `project` bigint(11) NULL DEFAULT NULL,
  `create_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`role_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 57 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '角色信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of cere_platform_role
-- ----------------------------
INSERT INTO `cere_platform_role` VALUES (1, '管理员', '管理员', 1, '', '2021-01-04 12:43:23');
INSERT INTO `cere_platform_role` VALUES (56, '管理员', NULL, 155, '2023-10-29 09:32:39', NULL);

-- ----------------------------
-- Table structure for cere_platform_role_permission
-- ----------------------------
DROP TABLE IF EXISTS `cere_platform_role_permission`;
CREATE TABLE `cere_platform_role_permission`  (
  `role_id` bigint(20) NOT NULL COMMENT '关联角色id',
  `permission_id` bigint(20) NOT NULL COMMENT '关联权限id'
) ENGINE = InnoDB AUTO_INCREMENT = 1917 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '平台账户角色关联权限实体类' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of cere_platform_role_permission
-- ----------------------------
INSERT INTO `cere_platform_role_permission` VALUES (1, 1);
INSERT INTO `cere_platform_role_permission` VALUES (1, 2);
INSERT INTO `cere_platform_role_permission` VALUES (1, 6);
INSERT INTO `cere_platform_role_permission` VALUES (1, 7);
INSERT INTO `cere_platform_role_permission` VALUES (1, 8);
INSERT INTO `cere_platform_role_permission` VALUES (1, 27);
INSERT INTO `cere_platform_role_permission` VALUES (1, 9);
INSERT INTO `cere_platform_role_permission` VALUES (1, 10);
INSERT INTO `cere_platform_role_permission` VALUES (1, 11);
INSERT INTO `cere_platform_role_permission` VALUES (1, 910);
INSERT INTO `cere_platform_role_permission` VALUES (1, 927);
INSERT INTO `cere_platform_role_permission` VALUES (1, 928);
INSERT INTO `cere_platform_role_permission` VALUES (1, 929);
INSERT INTO `cere_platform_role_permission` VALUES (1, 918);
INSERT INTO `cere_platform_role_permission` VALUES (1, 919);
INSERT INTO `cere_platform_role_permission` VALUES (1, 920);
INSERT INTO `cere_platform_role_permission` VALUES (1, 922);
INSERT INTO `cere_platform_role_permission` VALUES (1, 923);
INSERT INTO `cere_platform_role_permission` VALUES (1, 924);
INSERT INTO `cere_platform_role_permission` VALUES (1, 24);
INSERT INTO `cere_platform_role_permission` VALUES (1, 25);
INSERT INTO `cere_platform_role_permission` VALUES (1, 26);
INSERT INTO `cere_platform_role_permission` VALUES (1, 48);
INSERT INTO `cere_platform_role_permission` VALUES (1, 914);
INSERT INTO `cere_platform_role_permission` VALUES (1, 915);
INSERT INTO `cere_platform_role_permission` VALUES (1, 916);
INSERT INTO `cere_platform_role_permission` VALUES (1, 911);
INSERT INTO `cere_platform_role_permission` VALUES (1, 34);
INSERT INTO `cere_platform_role_permission` VALUES (1, 1201);
INSERT INTO `cere_platform_role_permission` VALUES (1, 37);
INSERT INTO `cere_platform_role_permission` VALUES (1, 38);
INSERT INTO `cere_platform_role_permission` VALUES (1, 39);
INSERT INTO `cere_platform_role_permission` VALUES (1, 40);
INSERT INTO `cere_platform_role_permission` VALUES (1, 74);
INSERT INTO `cere_platform_role_permission` VALUES (1, 75);
INSERT INTO `cere_platform_role_permission` VALUES (1, 76);
INSERT INTO `cere_platform_role_permission` VALUES (1, 77);
INSERT INTO `cere_platform_role_permission` VALUES (1, 78);
INSERT INTO `cere_platform_role_permission` VALUES (1, 496);
INSERT INTO `cere_platform_role_permission` VALUES (1, 578);
INSERT INTO `cere_platform_role_permission` VALUES (1, 579);
INSERT INTO `cere_platform_role_permission` VALUES (1, 580);
INSERT INTO `cere_platform_role_permission` VALUES (1, 1701);
INSERT INTO `cere_platform_role_permission` VALUES (1, 1702);
INSERT INTO `cere_platform_role_permission` VALUES (1, 1703);
INSERT INTO `cere_platform_role_permission` VALUES (1, 1704);
INSERT INTO `cere_platform_role_permission` VALUES (1, 1625);
INSERT INTO `cere_platform_role_permission` VALUES (1, 1627);
INSERT INTO `cere_platform_role_permission` VALUES (1, 1629);
INSERT INTO `cere_platform_role_permission` VALUES (1, 1630);
INSERT INTO `cere_platform_role_permission` VALUES (1, 1631);
INSERT INTO `cere_platform_role_permission` VALUES (1, 1632);
INSERT INTO `cere_platform_role_permission` VALUES (1, 1685);
INSERT INTO `cere_platform_role_permission` VALUES (1, 1686);
INSERT INTO `cere_platform_role_permission` VALUES (1, 1687);
INSERT INTO `cere_platform_role_permission` VALUES (1, 1697);
INSERT INTO `cere_platform_role_permission` VALUES (1, 1698);
INSERT INTO `cere_platform_role_permission` VALUES (1, 1699);
INSERT INTO `cere_platform_role_permission` VALUES (1, 1700);
INSERT INTO `cere_platform_role_permission` VALUES (1, 3);
INSERT INTO `cere_platform_role_permission` VALUES (1, 4);
INSERT INTO `cere_platform_role_permission` VALUES (1, 5);
INSERT INTO `cere_platform_role_permission` VALUES (1, 33);
INSERT INTO `cere_platform_role_permission` VALUES (1, 911);
INSERT INTO `cere_platform_role_permission` VALUES (1, 914);
INSERT INTO `cere_platform_role_permission` VALUES (1, 916);
INSERT INTO `cere_platform_role_permission` VALUES (1, 4025);
INSERT INTO `cere_platform_role_permission` VALUES (1, 4092);
INSERT INTO `cere_platform_role_permission` VALUES (1, 4094);
INSERT INTO `cere_platform_role_permission` VALUES (1, 5354);
INSERT INTO `cere_platform_role_permission` VALUES (1, 5348);
INSERT INTO `cere_platform_role_permission` VALUES (1, 5349);
INSERT INTO `cere_platform_role_permission` VALUES (56, 5365);
INSERT INTO `cere_platform_role_permission` VALUES (56, 5366);
INSERT INTO `cere_platform_role_permission` VALUES (56, 5367);
INSERT INTO `cere_platform_role_permission` VALUES (56, 5368);
INSERT INTO `cere_platform_role_permission` VALUES (56, 5369);
INSERT INTO `cere_platform_role_permission` VALUES (56, 5370);
INSERT INTO `cere_platform_role_permission` VALUES (56, 5371);
INSERT INTO `cere_platform_role_permission` VALUES (56, 5372);
INSERT INTO `cere_platform_role_permission` VALUES (56, 5373);
INSERT INTO `cere_platform_role_permission` VALUES (56, 5374);
INSERT INTO `cere_platform_role_permission` VALUES (56, 5375);
INSERT INTO `cere_platform_role_permission` VALUES (56, 5376);
INSERT INTO `cere_platform_role_permission` VALUES (56, 5377);
INSERT INTO `cere_platform_role_permission` VALUES (56, 5378);
INSERT INTO `cere_platform_role_permission` VALUES (56, 5379);
INSERT INTO `cere_platform_role_permission` VALUES (56, 5380);
INSERT INTO `cere_platform_role_permission` VALUES (56, 5381);
INSERT INTO `cere_platform_role_permission` VALUES (56, 5382);
INSERT INTO `cere_platform_role_permission` VALUES (56, 5383);
INSERT INTO `cere_platform_role_permission` VALUES (56, 5384);
INSERT INTO `cere_platform_role_permission` VALUES (56, 5385);
INSERT INTO `cere_platform_role_permission` VALUES (56, 5386);
INSERT INTO `cere_platform_role_permission` VALUES (56, 5387);
INSERT INTO `cere_platform_role_permission` VALUES (56, 5388);
INSERT INTO `cere_platform_role_permission` VALUES (56, 5389);
INSERT INTO `cere_platform_role_permission` VALUES (56, 5390);
INSERT INTO `cere_platform_role_permission` VALUES (56, 5391);
INSERT INTO `cere_platform_role_permission` VALUES (56, 5392);
INSERT INTO `cere_platform_role_permission` VALUES (56, 5393);
INSERT INTO `cere_platform_role_permission` VALUES (56, 5394);
INSERT INTO `cere_platform_role_permission` VALUES (56, 5395);
INSERT INTO `cere_platform_role_permission` VALUES (56, 5396);
INSERT INTO `cere_platform_role_permission` VALUES (56, 5397);
INSERT INTO `cere_platform_role_permission` VALUES (56, 5398);
INSERT INTO `cere_platform_role_permission` VALUES (56, 5399);
INSERT INTO `cere_platform_role_permission` VALUES (56, 5400);
INSERT INTO `cere_platform_role_permission` VALUES (56, 5401);
INSERT INTO `cere_platform_role_permission` VALUES (56, 5402);
INSERT INTO `cere_platform_role_permission` VALUES (56, 5403);
INSERT INTO `cere_platform_role_permission` VALUES (56, 5404);
INSERT INTO `cere_platform_role_permission` VALUES (56, 5405);
INSERT INTO `cere_platform_role_permission` VALUES (56, 5406);
INSERT INTO `cere_platform_role_permission` VALUES (56, 5407);
INSERT INTO `cere_platform_role_permission` VALUES (56, 5408);
INSERT INTO `cere_platform_role_permission` VALUES (56, 5409);
INSERT INTO `cere_platform_role_permission` VALUES (56, 5410);
INSERT INTO `cere_platform_role_permission` VALUES (56, 5411);
INSERT INTO `cere_platform_role_permission` VALUES (56, 5412);
INSERT INTO `cere_platform_role_permission` VALUES (56, 5413);
INSERT INTO `cere_platform_role_permission` VALUES (56, 5414);
INSERT INTO `cere_platform_role_permission` VALUES (56, 5415);
INSERT INTO `cere_platform_role_permission` VALUES (56, 5416);
INSERT INTO `cere_platform_role_permission` VALUES (56, 5417);
INSERT INTO `cere_platform_role_permission` VALUES (56, 5418);

-- ----------------------------
-- Table structure for cere_platform_seckill
-- ----------------------------
DROP TABLE IF EXISTS `cere_platform_seckill`;
CREATE TABLE `cere_platform_seckill`  (
  `seckill_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '平台秒杀活动id',
  `seckill_name` varchar(60) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '活动名称',
  `remark` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `sign_start_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '报名开始时间',
  `sign_end_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '报名结束时间',
  `start_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '活动开始时间',
  `end_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '活动结束时间',
  `if_limit` tinyint(1) NOT NULL COMMENT '商品限购 1-不限购 2-限购',
  `limit_number` int(11) NULL DEFAULT NULL COMMENT '限购几件/人',
  `if_add` tinyint(1) NOT NULL COMMENT '优惠券是否叠加 1-是 0-否',
  `state` tinyint(1) NULL DEFAULT 0 COMMENT '活动状态  0-报名未开始 1-报名进行中 2-活动待开始 3-活动进行中 4-活动已结束',
  `if_bond` tinyint(1) NULL DEFAULT 1 COMMENT '是否需要保证金  1-是 0-否',
  `bond_money` decimal(15, 2) NULL DEFAULT NULL COMMENT '保证金金额',
  `seckill_money` decimal(15, 2) NULL DEFAULT NULL COMMENT '直降多少元',
  `create_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`seckill_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 109 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '平台秒杀活动信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_platform_sensitive
-- ----------------------------
DROP TABLE IF EXISTS `cere_platform_sensitive`;
CREATE TABLE `cere_platform_sensitive`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `sensitive_word` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '敏感词库',
  `state` tinyint(1) NULL DEFAULT 0 COMMENT '是否开启 1-是 0-否',
  `handle_measures` tinyint(1) NULL DEFAULT NULL COMMENT '处理措施  1-禁止发布 2-需审核',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '敏感词库信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_platform_shop
-- ----------------------------
DROP TABLE IF EXISTS `cere_platform_shop`;
CREATE TABLE `cere_platform_shop`  (
  `shop_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `shop_code` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '商家编码',
  `shop_name` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '店铺名称',
  `shop_brief` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '简介',
  `shop_phone` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '店铺账号',
  `shop_password` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '店铺密码',
  `charge_person_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '店铺负责人',
  `charge_person_phone` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '负责人电话',
  `shop_adress` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '店铺地址',
  `shop_adress_province` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '店铺地址-省',
  `shop_adress_city` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '店铺地址-市',
  `shop_adress_detail` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '店铺地址-详细地址',
  `shop_logo` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '店铺logo',
  `effective_date` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '生效日期  即时生效-设置当前时间 有值-指定日期生效',
  `effective_year` int(11) NULL DEFAULT NULL COMMENT '生效时限（年）',
  `contract_state` tinyint(1) NULL DEFAULT 1 COMMENT '合同状态 1-有效 0-无效',
  `authentication_state` tinyint(1) NOT NULL DEFAULT 1 COMMENT '认证状态 1-未认证 2-审核中 3-审核通过 4-审核失败 5-签约成功（使用中）',
  `check_state` tinyint(1) NOT NULL COMMENT '入驻处理状态  0-未处理 1-通过 2-拒绝',
  `state` tinyint(1) NOT NULL COMMENT '是否启用 1-是 0-否',
  `authen_type` tinyint(1) NULL DEFAULT NULL COMMENT '主体类型 1-个人 2-个体工商户 3-企业 4-其他组织',
  `wx_image` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '微信收款码',
  `ailpay_image` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '支付宝收款码',
  `create_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新时间',
  `divide` int(10) NULL DEFAULT NULL COMMENT '交易分成比例',
  `collection_code` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '平台收款码',
  `audit_live` tinyint(1) NULL DEFAULT 1 COMMENT '审核直播间 1-开启 0-关闭',
  `audit_live_product` tinyint(1) NULL DEFAULT 1 COMMENT '审核直播间商品 1-开启 0-关闭',
  PRIMARY KEY (`shop_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 156 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '商家信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of cere_platform_shop
-- ----------------------------
INSERT INTO `cere_platform_shop` VALUES (155, 'SJ97151215', '商家演示店铺', NULL, '15738051864', '5f39GmYmX2gTALaf3BjzWA==', '商家', '15738051864', '北京', NULL, NULL, NULL, 'https://zk-cereshop.oss-cn-shenzhen.aliyuncs.com/zkthink/2023-10-29/492378cec7b242dd9b5b74c5fa76a463_7f4116bbf465df61d4f119c3f3a8281e.jpg', '2023-10-01', 5, 1, 3, 1, 1, NULL, NULL, NULL, '2023-10-29 09:32:21', '2023-10-29 09:36:54', NULL, NULL, 0, 0);

-- ----------------------------
-- Table structure for cere_platform_user
-- ----------------------------
DROP TABLE IF EXISTS `cere_platform_user`;
CREATE TABLE `cere_platform_user`  (
  `platform_user_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '账户id',
  `username` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '平台登录账号',
  `name` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '昵称',
  `sex` varchar(5) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '性别',
  `phone` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '账户手机号',
  `password` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '账户登录密码',
  `email` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '邮箱',
  `avatar` varchar(256) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '头像',
  `token` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '账户token',
  `state` tinyint(1) NOT NULL COMMENT '是否启用   1-是 0-否',
  `create_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`platform_user_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 36 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '平台账户信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of cere_platform_user
-- ----------------------------
INSERT INTO `cere_platform_user` VALUES (2, 'admin', '大权限账号', '男', '1234567890', 'CNJmcGxnwmM=', '', NULL, '', 1, '2020-12-23 19:10:56', '2021-01-14 00:18:48');

-- ----------------------------
-- Table structure for cere_platform_user_role
-- ----------------------------
DROP TABLE IF EXISTS `cere_platform_user_role`;
CREATE TABLE `cere_platform_user_role`  (
  `platform_user_id` bigint(20) NOT NULL COMMENT '平台账户编号',
  `role_id` bigint(20) NOT NULL COMMENT '关联角色表id'
) ENGINE = InnoDB AUTO_INCREMENT = 12 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '平台账户关联角色信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of cere_platform_user_role
-- ----------------------------
INSERT INTO `cere_platform_user_role` VALUES (2, 1);

-- ----------------------------
-- Table structure for cere_platform_web_log
-- ----------------------------
DROP TABLE IF EXISTS `cere_platform_web_log`;
CREATE TABLE `cere_platform_web_log`  (
  `web_log_id` bigint(11) NOT NULL AUTO_INCREMENT COMMENT '请求记录id',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '请求用户名',
  `url` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '请求接口地址',
  `params` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '请求接口参数',
  `type` tinyint(1) NULL DEFAULT NULL COMMENT '请求服务类型    1-平台端 2-商家端 3-C端',
  `ip` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'IP地址',
  `ip_source` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'IP来源',
  `describe` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '描述',
  `browser_name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '浏览器',
  `time` int(10) NULL DEFAULT NULL COMMENT '耗时',
  `create_time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`web_log_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 24580 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '接口请求记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_platform_word
-- ----------------------------
DROP TABLE IF EXISTS `cere_platform_word`;
CREATE TABLE `cere_platform_word`  (
  `word_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '关键词id',
  `key_word` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '关键词内容',
  `state` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否启用 1-是 0-否',
  `create_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`word_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 19 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '关键词信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_platfrom_message
-- ----------------------------
DROP TABLE IF EXISTS `cere_platfrom_message`;
CREATE TABLE `cere_platfrom_message`  (
  `message_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '短信id',
  `message_project` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '第三方短信名称',
  `message_template` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '短信模板名称',
  `template_code` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '模板编码',
  `template_sign` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '模板签名',
  `template_describe` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '模板描述',
  `state` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否启用 1-是 0-否',
  `create_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`message_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '短信账号配置信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_popup_advert
-- ----------------------------
DROP TABLE IF EXISTS `cere_popup_advert`;
CREATE TABLE `cere_popup_advert`  (
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
) ENGINE = InnoDB AUTO_INCREMENT = 13 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '弹窗广告表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_price_product
-- ----------------------------
DROP TABLE IF EXISTS `cere_price_product`;
CREATE TABLE `cere_price_product`  (
  `price_id` bigint(11) NOT NULL COMMENT '定价捆绑id',
  `product_id` bigint(11) NOT NULL COMMENT '商品id'
) ENGINE = InnoDB AUTO_INCREMENT = 63 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '商家定价捆绑商品信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_price_rule
-- ----------------------------
DROP TABLE IF EXISTS `cere_price_rule`;
CREATE TABLE `cere_price_rule`  (
  `price_id` bigint(11) NOT NULL COMMENT '定价捆绑id',
  `number` int(11) NOT NULL COMMENT '任选几件',
  `price` decimal(15, 2) NOT NULL COMMENT '捆绑价'
) ENGINE = InnoDB AUTO_INCREMENT = 25 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '商家定价捆绑优惠规则信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_privacy_verify_setting
-- ----------------------------
DROP TABLE IF EXISTS `cere_privacy_verify_setting`;
CREATE TABLE `cere_privacy_verify_setting`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project` int(11) NOT NULL COMMENT '平台端为1，商家端则为shop_id',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '隐私二次认证手机号',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uqe_idx_project`(`project`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of cere_privacy_verify_setting
-- ----------------------------
INSERT INTO `cere_privacy_verify_setting` VALUES (1, 1, '12345678910');
INSERT INTO `cere_privacy_verify_setting` VALUES (3, 155, '15738051864');

-- ----------------------------
-- Table structure for cere_product_answer
-- ----------------------------
DROP TABLE IF EXISTS `cere_product_answer`;
CREATE TABLE `cere_product_answer`  (
  `answer_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '回答id',
  `problem_id` bigint(20) NOT NULL COMMENT '提问id',
  `product_id` bigint(20) NOT NULL COMMENT '商品id',
  `buyer_user_id` bigint(20) NOT NULL COMMENT '客户id',
  `answer` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `if_anonymous` tinyint(1) NOT NULL COMMENT '是否匿名 1-是 0-否',
  `selected` tinyint(1) NULL DEFAULT NULL COMMENT '是否选中 1-是 0-否',
  `create_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '回答时间',
  PRIMARY KEY (`answer_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 116 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '商品提问回答信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_product_classify
-- ----------------------------
DROP TABLE IF EXISTS `cere_product_classify`;
CREATE TABLE `cere_product_classify`  (
  `classify_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '分类id',
  `classify_pid` bigint(20) NOT NULL COMMENT '分类父id',
  `classify_hierarchy` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '分类层级结构名称',
  `classify_level` tinyint(4) NOT NULL COMMENT '分类级别',
  `classify_level_hierarchy` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '分类层级结构',
  `classify_name` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '分类名称',
  `classify_image` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '分类图片地址',
  `sort` int(11) NULL DEFAULT NULL COMMENT '排序号',
  `link` bigint(20) NULL DEFAULT NULL COMMENT '链接(取数据字典)',
  `create_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`classify_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 827 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '商品分类信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_product_image
-- ----------------------------
DROP TABLE IF EXISTS `cere_product_image`;
CREATE TABLE `cere_product_image`  (
  `product_id` bigint(20) NOT NULL COMMENT '关联商品id',
  `product_image` varchar(1000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '图片地址',
  `sort` int(11) NULL DEFAULT NULL COMMENT '排序值',
  INDEX `idx_cere_product_image_product_id`(`product_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 323 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '商品图片信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_product_member
-- ----------------------------
DROP TABLE IF EXISTS `cere_product_member`;
CREATE TABLE `cere_product_member`  (
  `product_id` bigint(11) NOT NULL COMMENT '商品id',
  `sku_id` bigint(11) NOT NULL COMMENT '规格id',
  `member_level_id` bigint(11) NOT NULL COMMENT '会员等级id',
  `mode` tinyint(1) NOT NULL COMMENT '优惠方式   1-折扣 2-指定价格',
  `price` decimal(15, 2) NOT NULL COMMENT '多少元/几折',
  `total` decimal(15, 2) NULL DEFAULT NULL COMMENT '最终价格'
) ENGINE = InnoDB AUTO_INCREMENT = 269 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '商品会员价格信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_product_problem
-- ----------------------------
DROP TABLE IF EXISTS `cere_product_problem`;
CREATE TABLE `cere_product_problem`  (
  `problem_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '提问id',
  `product_id` bigint(20) NOT NULL COMMENT '商品id',
  `problem` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `buyer_user_id` bigint(20) NOT NULL COMMENT '客户id',
  `if_anonymous` tinyint(1) NOT NULL COMMENT '是否匿名 1-是 0-否',
  `selected` tinyint(1) NULL DEFAULT NULL COMMENT '是否选中 1-是 0-否',
  `create_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '提问时间',
  PRIMARY KEY (`problem_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 195 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '商品提问信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_product_sku
-- ----------------------------
DROP TABLE IF EXISTS `cere_product_sku`;
CREATE TABLE `cere_product_sku`  (
  `sku_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '商品规格id',
  `product_id` bigint(20) NOT NULL COMMENT '关联商品id',
  `SKU` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'SKU',
  `price` decimal(15, 2) NOT NULL COMMENT '售价',
  `original_price` decimal(15, 2) NOT NULL COMMENT '原价',
  `stock_number` int(11) NULL DEFAULT NULL COMMENT '库存数量',
  `total` int(11) NULL DEFAULT NULL COMMENT '库存总数',
  `weight` decimal(15, 2) NULL DEFAULT NULL COMMENT '重量',
  `sku_image` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '规格图片地址',
  `style` tinyint(1) NOT NULL DEFAULT 1 COMMENT '款式  0-单款式 1-多款式',
  `create_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`sku_id`) USING BTREE,
  UNIQUE INDEX `index`(`sku_id`) USING BTREE,
  INDEX `idx_cere_product_sku_product_id`(`product_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2033 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '商品规格信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_product_stats_by_day
-- ----------------------------
DROP TABLE IF EXISTS `cere_product_stats_by_day`;
CREATE TABLE `cere_product_stats_by_day`  (
  `create_date` char(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '日期',
  `product_id` bigint(20) NOT NULL COMMENT '商品id',
  `shop_id` bigint(20) NOT NULL COMMENT '店铺id',
  `add_cart_count` int(11) NOT NULL DEFAULT 0 COMMENT '加购量',
  `visit_count` int(11) NOT NULL DEFAULT 0 COMMENT '访问量',
  `sales_volume` int(11) NOT NULL DEFAULT 0 COMMENT '销量',
  PRIMARY KEY (`create_date`, `product_id`) USING BTREE,
  INDEX `idx_product_id`(`product_id`) USING BTREE,
  INDEX `idx_shop_id`(`shop_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '商品日度统计表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_redis_key
-- ----------------------------
DROP TABLE IF EXISTS `cere_redis_key`;
CREATE TABLE `cere_redis_key`  (
  `redis_key` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'redis的延时任务key',
  `end_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '结束时间（到这个时间就需要业务处理）'
) ENGINE = InnoDB AUTO_INCREMENT = 345 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = 'redis的过期键信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_risk_black
-- ----------------------------
DROP TABLE IF EXISTS `cere_risk_black`;
CREATE TABLE `cere_risk_black`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `type` int(11) NOT NULL COMMENT '类型 1：ip  2:用户',
  `ip` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'ip地址',
  `buyer_user_id` bigint(20) NULL DEFAULT NULL COMMENT '用户id',
  `state` tinyint(1) NULL DEFAULT 1 COMMENT '是否有效，0否 1是',
  `create_time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '创建时间',
  `update_time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 18 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '黑名单表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_risk_rule
-- ----------------------------
DROP TABLE IF EXISTS `cere_risk_rule`;
CREATE TABLE `cere_risk_rule`  (
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
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '风控规则表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_scrm_verify
-- ----------------------------
DROP TABLE IF EXISTS `cere_scrm_verify`;
CREATE TABLE `cere_scrm_verify`  (
  `shop_id` bigint(20) NOT NULL COMMENT '店铺id',
  `encode_secret` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '秘钥编码之后的值',
  PRIMARY KEY (`shop_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = 'scrm同步数据配置表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_shop_bank
-- ----------------------------
DROP TABLE IF EXISTS `cere_shop_bank`;
CREATE TABLE `cere_shop_bank`  (
  `shop_id` bigint(20) NOT NULL COMMENT '关联店铺id',
  `card_name` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '持卡人姓名',
  `card_number` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '银行卡号',
  `bank` bigint(20) NOT NULL COMMENT '所属银行（取数据字典）'
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '店铺收款账户信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_shop_banner
-- ----------------------------
DROP TABLE IF EXISTS `cere_shop_banner`;
CREATE TABLE `cere_shop_banner`  (
  `banner_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'banner配置id',
  `shop_id` bigint(20) NOT NULL COMMENT '关联店铺id',
  `banner_style` tinyint(1) NOT NULL COMMENT '样式   1-留边  2-填充',
  `banner_image` varchar(1000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'banner图片地址（多张图片以逗号隔开）',
  `banner_url` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '跳转地址',
  `state` tinyint(1) NOT NULL COMMENT '是否启用 1-是 0-否',
  `create_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`banner_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = 'banner配置信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_shop_cart
-- ----------------------------
DROP TABLE IF EXISTS `cere_shop_cart`;
CREATE TABLE `cere_shop_cart`  (
  `cart_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '购物车id',
  `buyer_user_id` bigint(20) NOT NULL COMMENT '关联客户id',
  `shop_id` bigint(20) NOT NULL COMMENT '店铺id',
  `product_id` bigint(20) NOT NULL COMMENT '关联商品id',
  `sku_id` bigint(20) NOT NULL COMMENT '关联规格id',
  `product_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '商品名称',
  `number` int(11) NOT NULL COMMENT '购买数量',
  `product_price` decimal(15, 2) NOT NULL COMMENT '商品售价',
  `image` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '图片地址',
  `SKU` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'SKU',
  `weight` decimal(15, 2) NULL DEFAULT NULL COMMENT '重量',
  `selected` tinyint(1) NULL DEFAULT NULL COMMENT '是否选中 1-是 0-否',
  `create_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`cart_id`) USING BTREE,
  UNIQUE INDEX `uqe_buyer_user_id_sku_id`(`buyer_user_id`, `sku_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1709 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '购物车信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_shop_channel_activity
-- ----------------------------
DROP TABLE IF EXISTS `cere_shop_channel_activity`;
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
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '渠道活动表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_shop_channel_activity_coupon
-- ----------------------------
DROP TABLE IF EXISTS `cere_shop_channel_activity_coupon`;
CREATE TABLE `cere_shop_channel_activity_coupon`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '渠道活动id',
  `coupon_id` bigint(20) NOT NULL COMMENT '渠道券id',
  `shop_id` bigint(20) NOT NULL COMMENT '店铺id',
  `create_time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '创建时间',
  `update_time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`, `coupon_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '渠道活动关联渠道券表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_shop_check
-- ----------------------------
DROP TABLE IF EXISTS `cere_shop_check`;
CREATE TABLE `cere_shop_check`  (
  `check_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '处理id',
  `shop_id` bigint(20) NOT NULL COMMENT '关联店铺id',
  `check_handle` tinyint(1) NOT NULL COMMENT '入住处理 1-同意入驻 0-拒绝入驻',
  `reason` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '处理原因',
  `create_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`check_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 65 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '店铺入驻处理信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of cere_shop_check
-- ----------------------------
INSERT INTO `cere_shop_check` VALUES (64, 155, 1, '', '2023-10-29 09:32:39', NULL);

-- ----------------------------
-- Table structure for cere_shop_comment
-- ----------------------------
DROP TABLE IF EXISTS `cere_shop_comment`;
CREATE TABLE `cere_shop_comment`  (
  `comment_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '评论id',
  `shop_id` bigint(20) NOT NULL COMMENT '关联店铺id',
  `shop_name` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '商家名称',
  `shop_code` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '商家编码',
  `product_id` bigint(20) NULL DEFAULT NULL COMMENT '关联商品id',
  `sku_id` bigint(20) NULL DEFAULT NULL COMMENT '规格id',
  `order_id` bigint(20) NULL DEFAULT NULL COMMENT '订单id',
  `buyer_user_id` bigint(20) NULL DEFAULT NULL COMMENT '关联客户id',
  `image` varchar(1000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '图片地址（多个以逗号隔开）',
  `add_image` varchar(1000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '追加图片',
  `comment` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `add_comment` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `state` tinyint(1) NULL DEFAULT 0 COMMENT '是否隐藏 1-是 0-否',
  `if_sensitive` tinyint(1) NULL DEFAULT 0 COMMENT '是否敏感词审核  1-是 0-否',
  `add_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '追评时间',
  `star` tinyint(1) NULL DEFAULT NULL COMMENT '商品满意度(宝贝描述) 1-一星 2-二星 3-三星 4-四星 5-五星',
  `des` tinyint(1) NULL DEFAULT NULL COMMENT '描述相符 1-一星 2-二星 3-三星 4-四星 5-五星',
  `delivery` tinyint(1) NULL DEFAULT NULL COMMENT '物流服务 1-一星 2-二星 3-三星 4-四星 5-五星',
  `attitude` tinyint(1) NULL DEFAULT NULL COMMENT '服务态度 1-一星 2-二星 3-三星 4-四星 5-五星',
  `impression` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '商品印象',
  `create_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`comment_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 113 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '客户评论信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_shop_compose
-- ----------------------------
DROP TABLE IF EXISTS `cere_shop_compose`;
CREATE TABLE `cere_shop_compose`  (
  `compose_id` bigint(11) NOT NULL AUTO_INCREMENT COMMENT '组合捆绑id',
  `shop_id` bigint(11) NOT NULL COMMENT '店铺id',
  `compose_name` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '组合名称',
  `start_time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '活动开始时间',
  `end_time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '活动结束时间',
  `compose_type` tinyint(1) NOT NULL COMMENT '促销类型 1-直接定价 2-固定减价 3-折扣',
  `promote` decimal(15, 2) NOT NULL COMMENT '促销值(元/折)',
  `price` decimal(15, 2) NULL DEFAULT NULL COMMENT '最终价格',
  `state` tinyint(1) NOT NULL COMMENT '状态 0-未开始 1-进行中 2-已结束 3-已停用',
  `create_time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`compose_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 54 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '商家组合捆绑信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_shop_conversion
-- ----------------------------
DROP TABLE IF EXISTS `cere_shop_conversion`;
CREATE TABLE `cere_shop_conversion`  (
  `shop_id` bigint(20) NOT NULL COMMENT '店铺id',
  `type` tinyint(1) NULL DEFAULT NULL COMMENT '转化类型 1-访问人数 2-加购人数 3-结账人数 4-调用支付 5-支付成功',
  `create_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '转化时间'
) ENGINE = InnoDB AUTO_INCREMENT = 13827 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '店铺转化信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_shop_coupon
-- ----------------------------
DROP TABLE IF EXISTS `cere_shop_coupon`;
CREATE TABLE `cere_shop_coupon`  (
  `shop_coupon_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '店铺优惠券id',
  `shop_id` bigint(20) NOT NULL COMMENT '店铺id',
  `coupon_name` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '优惠券名称',
  `remark` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `coupon_type` tinyint(1) NOT NULL COMMENT '优惠券类型 1-满减券 2-折扣券',
  `apply_type` tinyint(1) NOT NULL DEFAULT 1 COMMENT '适用商品 1-全部商品 2-指定商品可用 3-指定商品不可用',
  `threshold` decimal(15, 2) NOT NULL COMMENT '使用门槛满多少元，无门槛为0',
  `coupon_content` decimal(15, 2) NOT NULL COMMENT '优惠内容减多少元/打多少折',
  `time_type` tinyint(1) NOT NULL COMMENT '用券时间 1-固定时间 2-领券当日起几天内可用',
  `take_start` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '领券开始时间',
  `take_end` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '领券结束时间',
  `effective_start` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '用券开始时间',
  `effective_end` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '用券结束时间',
  `effective_day` int(11) NULL DEFAULT NULL COMMENT '领券当日几天内（天数）',
  `number` int(11) NULL DEFAULT NULL COMMENT '发放数量',
  `stock_number` int(11) NULL DEFAULT NULL COMMENT '库存数量',
  `receive_type` tinyint(1) NOT NULL COMMENT '每人限领次数  1-无限次 2-限制几次',
  `frequency` int(11) NULL DEFAULT NULL COMMENT '限制次数',
  `state` tinyint(1) NULL DEFAULT NULL COMMENT '优惠券状态  0-未开始 1-进行中 2-已结束',
  `if_add` tinyint(1) NULL DEFAULT NULL COMMENT '是否叠加平台优惠 1-是 0-否',
  `type` int(11) NOT NULL DEFAULT 1 COMMENT '优惠券分类 1-普通券 2-渠道券',
  `create_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`shop_coupon_id`) USING BTREE,
  INDEX `idx_shop_id`(`shop_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 168 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '店铺优惠券信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_shop_coupon_detail
-- ----------------------------
DROP TABLE IF EXISTS `cere_shop_coupon_detail`;
CREATE TABLE `cere_shop_coupon_detail`  (
  `shop_coupon_id` bigint(20) NOT NULL COMMENT '店铺优惠券id',
  `product_id` bigint(20) NOT NULL COMMENT '商品id'
) ENGINE = InnoDB AUTO_INCREMENT = 1418 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '店铺优惠券商品明细信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_shop_coupon_exclude
-- ----------------------------
DROP TABLE IF EXISTS `cere_shop_coupon_exclude`;
CREATE TABLE `cere_shop_coupon_exclude`  (
  `shop_coupon_id` bigint(20) NOT NULL COMMENT '店铺优惠券id',
  `product_id` bigint(20) NOT NULL COMMENT '商品id'
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '店铺优惠券商品明细信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_shop_crowd
-- ----------------------------
DROP TABLE IF EXISTS `cere_shop_crowd`;
CREATE TABLE `cere_shop_crowd`  (
  `shop_crowd_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '店铺人群id',
  `shop_id` bigint(20) NOT NULL COMMENT '店铺id',
  `crowd_name` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '人群名称',
  `shop_buy_yes` int(11) NULL DEFAULT NULL COMMENT '店铺有购买最近几天购买过本店商品的客户（以支付成功为准，不剔除退款）',
  `shop_buy_no` int(11) NULL DEFAULT NULL COMMENT '店铺无购买最近几天没有购买过本店商品的客户（以支付成功为准，不剔除退款）',
  `shop_order_yes` int(11) NULL DEFAULT NULL COMMENT '店铺有下单最近几天在店铺有下单行为的客户（包含未付款客户）',
  `shop_order_no` int(11) NULL DEFAULT NULL COMMENT '店铺无下单最近几天（在店铺没有下单行为的客户）',
  `shop_add_yes` int(11) NULL DEFAULT NULL COMMENT '店铺有加购最近几天（加购过本店商品的客户）',
  `shop_add_no` int(11) NULL DEFAULT NULL COMMENT '店铺无加购最近几天（没有加购过本店商品的客户）',
  `shop_visit_yes` int(11) NULL DEFAULT NULL COMMENT '店铺有访问最近几天（访问过本店的客户）',
  `shop_visit_no` int(11) NULL DEFAULT NULL COMMENT '店铺无访问最近几天（没有访问过本店的客户）',
  `effective_buy` tinyint(1) NULL DEFAULT NULL COMMENT '有效购买次数比较类型  1-大于 2-等于 3-小于',
  `effective_buy_count` int(11) NULL DEFAULT NULL COMMENT '有效购买次数，客户累计在店铺交易成功的订单数量（剔除退款的订单）',
  `effective_price` tinyint(1) NULL DEFAULT NULL COMMENT '有效购买金额比较类型  1-大于 2-等于 3-小于',
  `effective_price_count` decimal(15, 2) NULL DEFAULT NULL COMMENT '有效购买金额，客户累计在店铺交易成功的金额数量（剔除退款金额）',
  `users` int(11) NULL DEFAULT NULL COMMENT '客户数量',
  `label_id` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '商家标签id，多个以逗号隔开',
  `ids` mediumtext CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '客户id，多个以逗号隔开',
  `create_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`shop_crowd_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 16 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '客户分群信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_shop_customer_service
-- ----------------------------
DROP TABLE IF EXISTS `cere_shop_customer_service`;
CREATE TABLE `cere_shop_customer_service`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `shop_id` bigint(20) NOT NULL COMMENT '店铺id',
  `open_kfid` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '客服id',
  `create_time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_shop_id`(`shop_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '店铺客服关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_shop_discount
-- ----------------------------
DROP TABLE IF EXISTS `cere_shop_discount`;
CREATE TABLE `cere_shop_discount`  (
  `shop_discount_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '店铺限时折扣活动id',
  `shop_id` bigint(20) NOT NULL COMMENT '店铺id',
  `discount_name` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '活动名称',
  `remark` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `start_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '活动开始时间',
  `end_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '活动结束时间',
  `if_limit` tinyint(1) NOT NULL COMMENT '商品限购 1-不限购 2-限购',
  `limit_number` int(11) NULL DEFAULT NULL COMMENT '限购几件/人',
  `if_number` tinyint(1) NOT NULL COMMENT '是否限量 1-是 0-否',
  `number` int(11) NULL DEFAULT NULL COMMENT '限制数量',
  `if_enable` tinyint(1) NOT NULL COMMENT '活动预热   1-停用  2-启用',
  `enable_time` int(11) NULL DEFAULT NULL COMMENT '预热几小时前',
  `if_add` tinyint(1) NOT NULL COMMENT '优惠券是否叠加 1-是 0-否',
  `state` tinyint(1) NULL DEFAULT NULL COMMENT '限时折扣活动状态 0-未开始 1-进行中 2-已结束',
  `create_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`shop_discount_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 38 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '店铺限时折扣活动信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_shop_discount_detail
-- ----------------------------
DROP TABLE IF EXISTS `cere_shop_discount_detail`;
CREATE TABLE `cere_shop_discount_detail`  (
  `shop_discount_id` bigint(20) NOT NULL COMMENT '店铺限时折扣活动id',
  `product_id` bigint(20) NOT NULL COMMENT '商品id',
  `sku_id` bigint(20) NOT NULL COMMENT '规格id',
  `discount` decimal(15, 2) NOT NULL COMMENT '折扣',
  `price` decimal(15, 2) NOT NULL COMMENT '活动价格',
  `number` int(11) NULL DEFAULT NULL COMMENT '限量数量（剩余）',
  `total` int(11) NULL DEFAULT NULL COMMENT '限制总数'
) ENGINE = InnoDB AUTO_INCREMENT = 16 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '店铺限时折扣活动商品明细信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_shop_distribution_level
-- ----------------------------
DROP TABLE IF EXISTS `cere_shop_distribution_level`;
CREATE TABLE `cere_shop_distribution_level`  (
  `distributor_level_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '分销员等级id',
  `shop_id` bigint(20) NOT NULL COMMENT '关联店铺id',
  `level_name` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '等级名称',
  `level_num` int(11) NOT NULL DEFAULT 1 COMMENT '等级编号，编号越大等级越高',
  `level_logo` varchar(1024) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '等级图标',
  `if_self` tinyint(1) NULL DEFAULT 0 COMMENT '是否开启自购分佣  1-是 0-否',
  `if_money` tinyint(1) NULL DEFAULT 0 COMMENT '是否勾选累计分销金额 1-是 0-否',
  `if_invitation` tinyint(1) NULL DEFAULT 0 COMMENT '是否勾选邀请下级满  1-是 0-否',
  `if_customer` tinyint(1) NULL DEFAULT 0 COMMENT '是否勾选客户  1-是 0-否',
  `condition_money` decimal(15, 2) NULL DEFAULT NULL COMMENT '累计分销金额',
  `condition_invitation` int(11) NULL DEFAULT NULL COMMENT '邀请下级满人数',
  `condition_customer` int(11) NULL DEFAULT NULL COMMENT '客户满人数',
  `direct_proportion` int(11) NULL DEFAULT NULL COMMENT '直接分佣比例（存整数最大99）',
  `indirect_proportion` int(11) NULL DEFAULT NULL COMMENT '间接分佣比例（存整数最大99）',
  `create_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`distributor_level_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 25 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '店铺分销员等级信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of cere_shop_distribution_level
-- ----------------------------
INSERT INTO `cere_shop_distribution_level` VALUES (1, 155, '青铜分销员', 1, 'https://zk-cereshop.oss-cn-shenzhen.aliyuncs.com/zkthink/2022-08-12/7b7aec4833ab4642849c6678dc24aed3_组 15846@2x.png', 1, 1, 0, 0, 0.01, NULL, NULL, 50, 10, '2021-12-09 11:39:08', '2023-09-12 11:01:18');
INSERT INTO `cere_shop_distribution_level` VALUES (2, 155, '金牌分销员', 2, 'https://zk-cereshop.oss-cn-shenzhen.aliyuncs.com/zkthink/2022-08-12/38b9e9d8b1f04121939a1d68ecdf7f1e_组 15848@2x.png', 1, 1, 1, 0, 500.00, 3, NULL, 5, 2, '2022-08-12 20:01:00', '2023-07-13 14:24:27');
INSERT INTO `cere_shop_distribution_level` VALUES (3, 155, '钻石分销员', 3, 'https://zk-cereshop.oss-cn-shenzhen.aliyuncs.com/zkthink/2022-08-12/8264e891808d4015bf2f5f8cd028d30b_组 15849@2x.png', 1, 1, 1, 1, 2000.00, 5, 30, 6, 4, '2022-08-12 20:07:06', '2023-07-13 14:24:27');

-- ----------------------------
-- Table structure for cere_shop_distributor
-- ----------------------------
DROP TABLE IF EXISTS `cere_shop_distributor`;
CREATE TABLE `cere_shop_distributor`  (
  `distributor_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '分销员id',
  `shop_id` bigint(20) NOT NULL COMMENT '关联店铺id',
  `distributor_name` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '分销员昵称',
  `distributor_phone` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '分销员手机号',
  `distributor_level_id` bigint(20) NULL DEFAULT NULL COMMENT '关联分销员等级id',
  `invitees` bigint(20) NULL DEFAULT NULL COMMENT '邀请人id',
  `state` tinyint(1) NOT NULL DEFAULT 0 COMMENT '审核状态 0-待处理 1-审核通过 2-审核不通过',
  `if_Liquidation` tinyint(1) NULL DEFAULT 0 COMMENT '是否清退 1-是 0-否',
  `join_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '审核通过时间',
  `invitation_code` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '邀请码',
  `create_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`distributor_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 48 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '分销员信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_shop_enterprise
-- ----------------------------
DROP TABLE IF EXISTS `cere_shop_enterprise`;
CREATE TABLE `cere_shop_enterprise`  (
  `shop_id` bigint(20) NOT NULL COMMENT '关联店铺id',
  `enterprise_name` varchar(110) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '企业名称',
  `enterprise_code` varchar(18) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '统一社会信用代码',
  `enterprise_region` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '地址  省-市-区',
  `enterprise_adress` varchar(256) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '详细地址',
  `enterprise_start_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '营业期限开始时间',
  `enterprise_end_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '营业期限结束时间',
  `enterprise_license` varchar(1000) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '营业执照图片地址（多个以逗号隔开）',
  `enterprise_operator` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '法人姓名',
  `enterprise_card_type` bigint(20) NOT NULL COMMENT '证件类型 （取数据字典）',
  `enterprise_id_card` varchar(18) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '法人身份证号码',
  `enterprise_card_start_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '证件有效开始时间',
  `enterprise_card_end_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '证件有效结束时间',
  `enterprise_card_positive` varchar(1000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '身份证正面照',
  `enterprise_card_side` varchar(1000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '身份证反面照',
  `administrators_phone` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '管理员手机号',
  `administrators_email` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '管理员邮箱',
  `account_open_bank` bigint(20) NULL DEFAULT 0 COMMENT '开户银行（取数据字典）',
  `account_bank_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '开户银行名称',
  `account_bank_region` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '开户银行地区   省-市',
  `account_bank_card` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '银行账户',
  `shop_abbreviation` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '商户简称',
  `service_phone` varchar(16) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '客服电话',
  `service_providing` bigint(20) NULL DEFAULT 0 COMMENT '提供服务（取数据字典）',
  `shop_index_image` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '店铺首页截图',
  `shop_backstage_image` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '店铺管理后台截图',
  `remark` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `create_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新时间'
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '店铺企业认证信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_shop_extension
-- ----------------------------
DROP TABLE IF EXISTS `cere_shop_extension`;
CREATE TABLE `cere_shop_extension`  (
  `extension_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '推广设置id',
  `title` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '推广标题',
  `shop_id` bigint(20) NOT NULL COMMENT '关联店铺id',
  `if_logo` tinyint(1) NOT NULL DEFAULT 1 COMMENT '店铺logo是否展示在二维码 1-是 0-否',
  `if_head` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否展示头像昵称 1-是 0-否',
  `extension_reason` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '推广语',
  `image` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '背景图片地址 875x1275像素',
  `poster` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '海报图片地址',
  `create_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`extension_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '店铺推广设置信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_shop_group
-- ----------------------------
DROP TABLE IF EXISTS `cere_shop_group`;
CREATE TABLE `cere_shop_group`  (
  `shop_group_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '商品分组id',
  `shop_id` bigint(20) NOT NULL COMMENT '关联店铺id',
  `group_name` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '分组名称',
  `group_describe` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '分组描述',
  `group_image` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '分组封面图片地址',
  `create_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`shop_group_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 144 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '店铺商品分组信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_shop_group_detail
-- ----------------------------
DROP TABLE IF EXISTS `cere_shop_group_detail`;
CREATE TABLE `cere_shop_group_detail`  (
  `shop_group_id` bigint(20) NOT NULL COMMENT '店铺分组id',
  `product_id` bigint(20) NOT NULL COMMENT '商品id'
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '分组关联商品信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_shop_group_work
-- ----------------------------
DROP TABLE IF EXISTS `cere_shop_group_work`;
CREATE TABLE `cere_shop_group_work`  (
  `shop_group_work_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '店铺拼团活动id',
  `shop_id` bigint(20) NOT NULL COMMENT '店铺id',
  `group_name` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '活动名称',
  `remark` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `start_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '活动开始时间',
  `end_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '活动结束时间',
  `person` int(11) NOT NULL COMMENT '成团人数',
  `effective_time` int(11) NOT NULL COMMENT '成团有效时间几（小时）',
  `if_limit` tinyint(1) NOT NULL COMMENT '商品限购 1-不限购 2-限购',
  `limit_number` int(11) NULL DEFAULT NULL COMMENT '限购几件/人',
  `if_enable` tinyint(1) NOT NULL COMMENT '活动预热   1-停用  2-启用',
  `enable_time` int(11) NULL DEFAULT NULL COMMENT '预热几小时前',
  `if_add` tinyint(1) NOT NULL COMMENT '优惠券是否叠加 1-是 0-否',
  `state` tinyint(1) NULL DEFAULT NULL COMMENT '拼团活动状态 0-未开始 1-进行中 2-已结束',
  `create_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`shop_group_work_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 98 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '店铺拼团活动信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_shop_group_work_detail
-- ----------------------------
DROP TABLE IF EXISTS `cere_shop_group_work_detail`;
CREATE TABLE `cere_shop_group_work_detail`  (
  `shop_group_work_id` bigint(20) NOT NULL COMMENT '店铺拼团活动id',
  `product_id` bigint(20) NOT NULL COMMENT '商品id',
  `sku_id` bigint(20) NOT NULL COMMENT '规格id',
  `price` decimal(15, 2) NOT NULL COMMENT '拼团价格'
) ENGINE = InnoDB AUTO_INCREMENT = 47 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '店铺拼团活动商品明细信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_shop_individual_businesses
-- ----------------------------
DROP TABLE IF EXISTS `cere_shop_individual_businesses`;
CREATE TABLE `cere_shop_individual_businesses`  (
  `shop_id` bigint(20) NOT NULL COMMENT '关联店铺id',
  `subject_name` varchar(110) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '商户名称',
  `subject_code` varchar(18) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '统一社会信用代码',
  `subject_region` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '地址  省-市-区',
  `subject_adress` varchar(256) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '详细地址',
  `subject_start_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '营业期限开始时间',
  `subject_end_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '营业期限结束时间',
  `subject_license` varchar(1000) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '营业执照图片地址（多个以逗号隔开）',
  `subject_operator` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '经营者姓名',
  `subject_card_type` bigint(20) NOT NULL COMMENT '证件类型 （取数据字典）',
  `subject_id_card` varchar(18) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '经营者身份证号码',
  `subject_card_start_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '证件有效开始时间',
  `subject_card_end_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '证件有效结束时间',
  `subject_card_positive` varchar(1000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '身份证正面照',
  `subject_card_side` varchar(1000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '身份证反面照',
  `administrators_phone` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '管理员手机号',
  `administrators_email` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '管理员邮箱',
  `account_type` tinyint(1) NULL DEFAULT 1 COMMENT '账户类型 1-对公 2-对私',
  `account_open_bank` bigint(20) NULL DEFAULT 0 COMMENT '开户银行（取数据字典）',
  `account_bank_region` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '开户银行地区   省-市',
  `account_bank_card` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '银行账户',
  `shop_abbreviation` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '商户简称',
  `service_phone` varchar(16) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '客服电话',
  `service_providing` bigint(20) NULL DEFAULT 0 COMMENT '提供服务（取数据字典）',
  `shop_index_image` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '店铺首页截图',
  `shop_backstage_image` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '店铺管理后台截图',
  `remark` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `create_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新时间'
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '店铺个体工商户认证信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_shop_label
-- ----------------------------
DROP TABLE IF EXISTS `cere_shop_label`;
CREATE TABLE `cere_shop_label`  (
  `label_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '标签id',
  `shop_id` bigint(20) NOT NULL COMMENT '关联店铺id',
  `label_name` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '标签名称',
  `label_type` tinyint(2) NULL DEFAULT 1 COMMENT '标签类型 1-图片 2-视频',
  `create_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`label_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 74 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '店铺标签信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_shop_operate
-- ----------------------------
DROP TABLE IF EXISTS `cere_shop_operate`;
CREATE TABLE `cere_shop_operate`  (
  `shop_operate_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '店铺运营计划id',
  `shop_id` bigint(20) NOT NULL COMMENT '店铺id',
  `operate_name` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '计划名称',
  `shop_crowd_id` bigint(20) NOT NULL COMMENT '店铺人群id',
  `plan_mode` tinyint(1) NOT NULL COMMENT '计划方式  1-自动长期计划 2-手动定时计划',
  `state` tinyint(1) NULL DEFAULT NULL COMMENT '状态 0-未开始 1-进行中 2-已结束',
  `plan_start` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '长期计划开始时间',
  `plan_end` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '长期计划结束时间',
  `manual_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '手动定时执行时间，如果为空说明是立即执行',
  `create_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`shop_operate_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 26 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '店铺运营计划信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_shop_operate_detail
-- ----------------------------
DROP TABLE IF EXISTS `cere_shop_operate_detail`;
CREATE TABLE `cere_shop_operate_detail`  (
  `shop_operate_id` bigint(20) NOT NULL,
  `shop_coupon_id` bigint(20) NOT NULL COMMENT '店铺优惠券id',
  `number` int(11) NOT NULL COMMENT '赠券数量'
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '店铺运营计划优惠券明细信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_shop_order
-- ----------------------------
DROP TABLE IF EXISTS `cere_shop_order`;
CREATE TABLE `cere_shop_order`  (
  `order_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '订单id',
  `parent_id` bigint(20) NOT NULL COMMENT '关联父订单id',
  `shop_id` bigint(20) NOT NULL COMMENT '关联店铺id',
  `order_formid` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '订单ID',
  `buyer_user_id` bigint(20) NOT NULL COMMENT '关联客户id',
  `coupon_id` bigint(11) NULL DEFAULT NULL COMMENT '平台优惠券id',
  `id` bigint(20) NULL DEFAULT NULL COMMENT '客户关联商家优惠券数据主键id',
  `shop_seckill_id` bigint(20) NULL DEFAULT NULL COMMENT '店铺秒杀活动id',
  `shop_group_work_id` bigint(20) NULL DEFAULT NULL COMMENT '店铺拼团活动id',
  `shop_discount_id` bigint(20) NULL DEFAULT NULL COMMENT '店铺限时折扣活动id',
  `shop_operate_id` bigint(20) NULL DEFAULT NULL COMMENT '运营计划id',
  `order_price` decimal(15, 2) NOT NULL COMMENT '订单总价',
  `logistics_price` decimal(15, 2) NULL DEFAULT NULL COMMENT '物流费用',
  `discount_price` decimal(15, 2) NULL DEFAULT NULL COMMENT '优惠金额',
  `price` decimal(15, 2) NOT NULL COMMENT '支付金额',
  `old_price` decimal(15, 2) NULL DEFAULT NULL COMMENT '改价前的支付金额',
  `state` tinyint(1) NOT NULL COMMENT '订单状态 1-待付款 2-待发货 3-待收货 4-已完成 5-已取消 6-待成团 7-待售后',
  `payment_state` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否支付 1-是 0-否',
  `payment_mode` tinyint(1) NOT NULL DEFAULT 1 COMMENT '支付方式 1-微信支付',
  `payment_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '支付时间',
  `customer_name` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '下单人姓名',
  `customer_phone` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '下单人手机号',
  `receive_name` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '收货人姓名',
  `receive_phone` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '收货人手机号',
  `receive_adress` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '收货地址',
  `address` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '详细地址',
  `receive_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '成交时间',
  `postal_code` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '邮政编码',
  `remark` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '订单备注',
  `after_state` tinyint(1) NULL DEFAULT NULL COMMENT '无用字段',
  `logistics_id` bigint(20) NULL DEFAULT NULL COMMENT '物流方案id',
  `distributor_id` bigint(20) NULL DEFAULT NULL COMMENT '关联分销员id',
  `direct_distributor_money` decimal(15, 2) NULL DEFAULT NULL COMMENT '直接分销佣金',
  `indirect_distributor_money` decimal(15, 2) NULL DEFAULT NULL COMMENT '间接分销佣金',
  `create_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新时间',
  `seckill_id` bigint(11) NULL DEFAULT NULL COMMENT '平台秒杀活动id',
  `discount_id` bigint(11) NULL DEFAULT NULL COMMENT '平台限时折扣活动id',
  `polite_id` bigint(11) NULL DEFAULT NULL COMMENT '平台支付有礼活动id',
  `scene_id` bigint(11) NULL DEFAULT NULL COMMENT '商家场景营销活动id',
  `type` tinyint(1) NULL DEFAULT NULL COMMENT '类型 1-常规订单 2-商家收款订单（扫码）',
  `write_state` tinyint(1) NULL DEFAULT NULL COMMENT '核销状态  0-无需核销 1-部分核销 2-已核销',
  `pricing_price` decimal(15, 2) NULL DEFAULT NULL COMMENT '定价捆绑优惠金额',
  PRIMARY KEY (`order_id`) USING BTREE,
  INDEX `idx_cere_shop_order_shop_id`(`shop_id`) USING BTREE,
  INDEX `idx_cere_shop_order_buyer_user_id`(`buyer_user_id`) USING BTREE,
  INDEX `idx_cere_shop_order_order_id`(`order_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2495 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '订单信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_shop_other_organizations
-- ----------------------------
DROP TABLE IF EXISTS `cere_shop_other_organizations`;
CREATE TABLE `cere_shop_other_organizations`  (
  `shop_id` bigint(20) NOT NULL COMMENT '关联店铺id',
  `other_name` varchar(110) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '组织名称',
  `other_code` varchar(18) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '组织机构代码',
  `other_region` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '地址  省-市-区',
  `other_adress` varchar(256) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '详细地址',
  `other_start_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '营业期限开始时间',
  `other_end_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '营业期限结束时间',
  `other_license` varchar(1000) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '机构证件或其他证明材料图片地址（多个以逗号隔开）',
  `other_operator` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '负责人姓名',
  `other_card_type` bigint(20) NOT NULL COMMENT '证件类型 （取数据字典）',
  `other_id_card` varchar(18) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '负责人身份证号码',
  `other_card_start_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '证件有效开始时间',
  `other_card_end_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '证件有效结束时间',
  `other_card_positive` varchar(1000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '身份证正面照',
  `other_card_side` varchar(1000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '身份证反面照',
  `administrators_phone` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '管理员手机号',
  `administrators_email` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '管理员邮箱',
  `account_open_bank` bigint(20) NULL DEFAULT 0 COMMENT '开户银行（取数据字典）',
  `account_bank_region` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '开户银行地区   省-市',
  `account_bank_card` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '银行账户',
  `shop_abbreviation` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '商户简称',
  `service_phone` varchar(16) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '客服电话',
  `service_providing` bigint(20) NULL DEFAULT 0 COMMENT '提供服务（取数据字典）',
  `shop_index_image` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '店铺首页截图',
  `shop_backstage_image` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '店铺管理后台截图',
  `remark` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `create_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新时间'
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '店铺其他组织认证信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_shop_personal
-- ----------------------------
DROP TABLE IF EXISTS `cere_shop_personal`;
CREATE TABLE `cere_shop_personal`  (
  `shop_id` bigint(20) NOT NULL COMMENT '关联店铺id',
  `personal_name` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '个人姓名',
  `personal_card_type` bigint(20) NOT NULL COMMENT '证件类型 （取数据字典）',
  `personal_id_card` varchar(18) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '法人身份证号码',
  `personal_card_start_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '证件有效开始时间',
  `personal_card_end_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '证件有效结束时间',
  `personal_card_positive` varchar(1000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '身份证正面照',
  `personal_card_side` varchar(1000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '身份证反面照',
  `personal_card_hand` varchar(1000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '手持身份证照',
  `administrators_phone` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '管理员手机号',
  `administrators_email` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '管理员邮箱',
  `account_open_bank` bigint(20) NULL DEFAULT 0 COMMENT '开户银行（取数据字典）',
  `account_bank_region` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '开户银行地区   省-市',
  `account_bank_card` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '银行账户',
  `shop_abbreviation` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '商户简称',
  `service_phone` varchar(16) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '客服电话',
  `service_providing` bigint(20) NULL DEFAULT 0 COMMENT '提供服务（取数据字典）',
  `shop_index_image` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '店铺首页截图',
  `shop_backstage_image` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '店铺管理后台截图',
  `remark` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `create_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新时间'
) ENGINE = InnoDB AUTO_INCREMENT = 49 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '店铺个人认证信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_shop_price
-- ----------------------------
DROP TABLE IF EXISTS `cere_shop_price`;
CREATE TABLE `cere_shop_price`  (
  `price_id` bigint(11) NOT NULL AUTO_INCREMENT COMMENT '定价捆绑id',
  `shop_id` bigint(11) NOT NULL COMMENT '店铺id',
  `compose_name` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '活动名称',
  `start_time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '活动开始时间',
  `end_time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '活动结束时间',
  `state` tinyint(1) NOT NULL COMMENT '状态 0-未开始 1-进行中 2-已结束 3-已停用',
  `create_time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`price_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 36 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '商家定价捆绑信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_shop_product
-- ----------------------------
DROP TABLE IF EXISTS `cere_shop_product`;
CREATE TABLE `cere_shop_product`  (
  `product_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '商品id',
  `shop_id` bigint(20) NOT NULL COMMENT '关联店铺id',
  `product_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '商品名称',
  `product_brief` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '卖点简介',
  `product_text` longtext CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '商品描述（富文本）',
  `shop_group_id` bigint(20) NULL DEFAULT NULL COMMENT '关联商品分组id',
  `classify_id` bigint(20) NOT NULL COMMENT '关联分类id',
  `supplier_id` bigint(20) NULL DEFAULT NULL COMMENT '关联供应商id',
  `supplier_name` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '供应商名称',
  `if_logistics` tinyint(1) NULL DEFAULT 1 COMMENT '是否需要物流 1-是 0-否',
  `shelve_state` tinyint(1) NULL DEFAULT 1 COMMENT '商品状态 0-已下架 1-已上架 2-待审核 3-审核失败',
  `if_oversold` tinyint(1) NULL DEFAULT 1 COMMENT '是否允许超卖 1-是 0-否',
  `if_huabei` tinyint(1) NULL DEFAULT 0 COMMENT '是否支持花呗分期',
  `create_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新时间',
  `fictitious_number` int(11) NOT NULL DEFAULT 0 COMMENT '虚拟销量',
  `reject` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '驳回原因',
  `distribution` tinyint(1) NULL DEFAULT NULL COMMENT '配送属性 1-线下核销 2-快递',
  `if_gift` tinyint(1) NULL DEFAULT NULL COMMENT '是否参与赠品 1-是 0-否',
  `if_credit` tinyint(1) NULL DEFAULT 0 COMMENT '是否积分抵扣 1-是 0-否',
  `credit_limit` int(11) NULL DEFAULT NULL COMMENT '单笔最大抵扣多少积分',
  `brand_id` bigint(20) NULL DEFAULT NULL COMMENT '品牌id',
  PRIMARY KEY (`product_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 556 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '店铺商品信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_shop_recruit
-- ----------------------------
DROP TABLE IF EXISTS `cere_shop_recruit`;
CREATE TABLE `cere_shop_recruit`  (
  `shop_id` bigint(20) NOT NULL COMMENT '关联店铺id',
  `purchase_everything` tinyint(1) NULL DEFAULT 0 COMMENT '是否勾选购买任意商品  1-是 0-否',
  `order_frequency` tinyint(1) NULL DEFAULT 0 COMMENT '是否勾选至少下单满多少  1-是 0-否',
  `consumption_money` tinyint(1) NULL DEFAULT 0 COMMENT '是否勾选消费金额满多少 1-是 0-否',
  `frequency` int(11) NULL DEFAULT NULL COMMENT '下单次数',
  `money` decimal(15, 2) NULL DEFAULT NULL COMMENT '消费金额',
  `if_examine` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否需要审核 1-是 0-否',
  `url` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '招募页链接'
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '店铺招募信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_shop_relationship
-- ----------------------------
DROP TABLE IF EXISTS `cere_shop_relationship`;
CREATE TABLE `cere_shop_relationship`  (
  `shop_id` bigint(20) NOT NULL COMMENT '关联店铺id',
  `if_invitation` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否允许邀请下级  1-是 0-否',
  `bind_validity` tinyint(1) NOT NULL DEFAULT 1 COMMENT '关系绑定有效期  1-永久有效 2-几天有效',
  `validity_day` int(11) NULL DEFAULT NULL COMMENT '关系绑定有效天数',
  `if_robbing` tinyint(1) NOT NULL DEFAULT 2 COMMENT '抢客条件 1-随时可抢客 2-不允许抢客 3-保护期几天内不允许抢',
  `robbing_day` int(11) NULL DEFAULT NULL COMMENT '保护期天数',
  `if_distribution_relationship` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否允许分销员之间建立客户关系 1-是 0-否'
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '店铺关系设置表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of cere_shop_relationship
-- ----------------------------
INSERT INTO `cere_shop_relationship` VALUES (155, 1, 1, NULL, 2, NULL, 0);

-- ----------------------------
-- Table structure for cere_shop_return
-- ----------------------------
DROP TABLE IF EXISTS `cere_shop_return`;
CREATE TABLE `cere_shop_return`  (
  `shop_id` bigint(20) NOT NULL COMMENT '关联店铺id',
  `return_adress` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '退货地址',
  `return_person` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '联系人',
  `return_phone` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '联系电话'
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '店铺退货地址信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of cere_shop_return
-- ----------------------------
INSERT INTO `cere_shop_return` VALUES (155, '北京', '小李', '15738051864');

-- ----------------------------
-- Table structure for cere_shop_scene
-- ----------------------------
DROP TABLE IF EXISTS `cere_shop_scene`;
CREATE TABLE `cere_shop_scene`  (
  `scene_id` bigint(11) NOT NULL AUTO_INCREMENT COMMENT '场景营销id',
  `shop_id` bigint(11) NOT NULL COMMENT '店铺id',
  `scene_type` tinyint(1) NOT NULL COMMENT '营销类型 1-节日营销 2-会员日营销 3-生日营销',
  `scene_name` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '营销名称',
  `start_time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '开始时间',
  `end_time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '结束时间',
  `scene_rule` tinyint(1) NOT NULL COMMENT '营销规则 1-所有等级会员，同一规则 2-不同等级会员,不同规则',
  `scene_time_type` tinyint(1) NULL DEFAULT NULL COMMENT '营销时间类型 1-每月 2-每周 3-每日 4-生日当天 5-生日当周 6-生日当月',
  `scene_time` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '营销事件 每月示例1-2表示每月一日到二日；每周示例1(周一)-2（周二）-3-4-5-6-7表示全选，0代表未选；每日示例2021-01-01 10:00:00至2021-01-01 12:00:00',
  `state` tinyint(1) UNSIGNED ZEROFILL NULL DEFAULT 0 COMMENT '状态 0-未开始 1-进行中 2-已停止',
  `create_time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`scene_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 83 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '场景营销信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_shop_scene_member
-- ----------------------------
DROP TABLE IF EXISTS `cere_shop_scene_member`;
CREATE TABLE `cere_shop_scene_member`  (
  `scene_id` bigint(11) NOT NULL COMMENT '场景营销id',
  `member_level_id` bigint(11) NOT NULL COMMENT '会员等级id',
  `if_free_shipping` tinyint(1) UNSIGNED NULL DEFAULT 0 COMMENT '是否包邮 1-是 0-否',
  `discount` decimal(10, 2) NULL DEFAULT NULL COMMENT '折扣'
) ENGINE = InnoDB AUTO_INCREMENT = 182 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '商家场景营销规则信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_shop_scene_member_coupon
-- ----------------------------
DROP TABLE IF EXISTS `cere_shop_scene_member_coupon`;
CREATE TABLE `cere_shop_scene_member_coupon`  (
  `scene_id` bigint(11) NOT NULL COMMENT '场景营销id',
  `member_level_id` bigint(11) NOT NULL COMMENT '会员等级id',
  `coupon_id` bigint(11) NOT NULL COMMENT '商家优惠券id'
) ENGINE = InnoDB AUTO_INCREMENT = 56 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '商家场景营销规则会员等级优惠券信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_shop_seckill
-- ----------------------------
DROP TABLE IF EXISTS `cere_shop_seckill`;
CREATE TABLE `cere_shop_seckill`  (
  `shop_seckill_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '店铺秒杀活动id',
  `shop_id` bigint(20) NOT NULL COMMENT '店铺id',
  `seckill_name` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '活动名称',
  `remark` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `effective_start` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '开始时间',
  `effective_end` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '结束时间',
  `if_limit` tinyint(1) NOT NULL COMMENT '商品限购 1-不限购 2-限购',
  `limit_number` int(11) NULL DEFAULT NULL COMMENT '限购几件/人',
  `if_number` tinyint(1) NOT NULL COMMENT '是否限量 1-是 0-否',
  `number` int(11) NULL DEFAULT NULL COMMENT '限制数量',
  `if_enable` tinyint(1) NOT NULL COMMENT '活动预热   1-停用  2-启用',
  `enable_time` int(11) NULL DEFAULT NULL COMMENT '预热几小时前',
  `if_add` tinyint(1) NOT NULL COMMENT '优惠券是否叠加 1-是 0-否',
  `state` tinyint(1) NULL DEFAULT NULL COMMENT '活动状态 0-未开始 1-进行中 2-已结束',
  `create_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`shop_seckill_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 63 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '店铺秒杀活动信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_shop_seckill_detail
-- ----------------------------
DROP TABLE IF EXISTS `cere_shop_seckill_detail`;
CREATE TABLE `cere_shop_seckill_detail`  (
  `shop_seckill_id` bigint(20) NOT NULL COMMENT '店铺秒杀活动id',
  `product_id` bigint(20) NOT NULL COMMENT '商品id',
  `sku_id` bigint(20) NOT NULL COMMENT '规格id',
  `down_price` decimal(15, 2) NOT NULL COMMENT '直降多少元',
  `seckill_price` decimal(15, 2) NOT NULL COMMENT '秒杀价格',
  `number` int(11) NULL DEFAULT NULL COMMENT '限量数量(剩余)',
  `total` int(11) NULL DEFAULT NULL COMMENT '限制总数'
) ENGINE = InnoDB AUTO_INCREMENT = 30 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '店铺秒杀活动商品明细信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_shop_user_label
-- ----------------------------
DROP TABLE IF EXISTS `cere_shop_user_label`;
CREATE TABLE `cere_shop_user_label`  (
  `label_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '店铺标签id',
  `shop_id` bigint(20) NOT NULL COMMENT '关联店铺id',
  `label_name` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '标签名称',
  `remark` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '备注信息',
  `create_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`label_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 57 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '店铺用户标签信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_shop_visit
-- ----------------------------
DROP TABLE IF EXISTS `cere_shop_visit`;
CREATE TABLE `cere_shop_visit`  (
  `shop_id` bigint(20) NOT NULL COMMENT '关联店铺id',
  `buyer_user_id` bigint(20) NOT NULL COMMENT '关联客户id',
  `visit_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '访问时间',
  `terminal` tinyint(1) NULL DEFAULT NULL COMMENT '访问终端  1-APP 2-小程序 3-PC端',
  `system` tinyint(1) NULL DEFAULT NULL COMMENT '操作系统1-Android 2-IOS 3-浏览器',
  `city` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '所在地区'
) ENGINE = InnoDB AUTO_INCREMENT = 9893 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '店铺访问信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_shop_withdrawal
-- ----------------------------
DROP TABLE IF EXISTS `cere_shop_withdrawal`;
CREATE TABLE `cere_shop_withdrawal`  (
  `withdrawal_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '提现申请id',
  `shop_id` bigint(20) NOT NULL COMMENT '关联店铺id',
  `shop_name` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '店铺名称',
  `shop_code` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '店铺编码',
  `bank_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '银行名称',
  `bank_card` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '银行卡号',
  `collection_name` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '收款人姓名',
  `withdrawal_money` decimal(15, 2) NOT NULL COMMENT '提现金额',
  `state` tinyint(1) NOT NULL DEFAULT 0 COMMENT '处理状态  0-待处理 1-已处理',
  `apply_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '申请时间',
  `handle_time` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '处理时间',
  `handling_fee` decimal(15, 0) NULL DEFAULT 0 COMMENT '提现手续费',
  PRIMARY KEY (`withdrawal_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 27 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '商家提现申请信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_sign_product
-- ----------------------------
DROP TABLE IF EXISTS `cere_sign_product`;
CREATE TABLE `cere_sign_product`  (
  `sign_id` bigint(20) NOT NULL COMMENT '关联报名id',
  `product_id` bigint(20) NOT NULL COMMENT '关联商品id',
  `number` int(11) NULL DEFAULT NULL COMMENT '商品限量（剩余）',
  `total` int(11) NULL DEFAULT NULL COMMENT '限量总数',
  INDEX `idx_sign_id`(`sign_id`) USING BTREE,
  INDEX `idx_productt_id`(`product_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 358 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '报名商品明细信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_sku_member_real_info
-- ----------------------------
DROP TABLE IF EXISTS `cere_sku_member_real_info`;
CREATE TABLE `cere_sku_member_real_info`  (
  `sku_id` bigint(20) NOT NULL COMMENT 'skuId',
  `product_id` bigint(20) NOT NULL COMMENT '商品id',
  `member_level_id` bigint(11) NOT NULL COMMENT '会员等级id',
  `cur_price` decimal(10, 2) NOT NULL COMMENT '当前价格',
  `cur_original_price` decimal(10, 2) NOT NULL COMMENT '当前原价',
  `create_time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT '1970-01-01 00:00:00' COMMENT '创建时间',
  `update_time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT '1970-01-01 00:00:00' COMMENT '更新时间',
  PRIMARY KEY (`sku_id`, `member_level_id`) USING BTREE,
  INDEX `idx_product_id`(`product_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = 'sku根据会员等级设置价格' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_sku_name
-- ----------------------------
DROP TABLE IF EXISTS `cere_sku_name`;
CREATE TABLE `cere_sku_name`  (
  `sku_id` bigint(20) NOT NULL COMMENT '规格id',
  `need` tinyint(1) NULL DEFAULT NULL COMMENT '是否需要配图 1-是 0-否',
  `sku_name` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '规格名',
  `sku_value` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '规格值',
  `image` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '图片地址',
  `name_code` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '规格名级别',
  `value_code` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '规格值级别',
  INDEX `idx_cere_sku_name_sku_id`(`sku_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1147 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '商品规格属性信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cere_sku_real_info
-- ----------------------------
DROP TABLE IF EXISTS `cere_sku_real_info`;
CREATE TABLE `cere_sku_real_info`  (
  `sku_id` bigint(20) NOT NULL COMMENT 'skuId',
  `product_id` bigint(20) NOT NULL COMMENT '商品id',
  `activity_type` int(11) NOT NULL COMMENT '参考IntegerEnum.ACTIVITY_TYPE_XXX',
  `activity_id` bigint(20) NOT NULL COMMENT '活动id',
  `cur_price` decimal(10, 2) NOT NULL COMMENT '当前价格',
  `cur_original_price` decimal(10, 2) NOT NULL COMMENT '当前原价',
  `min_price` decimal(10, 2) NOT NULL COMMENT '最小价格',
  `max_price` decimal(10, 2) NOT NULL COMMENT '最大价格',
  `limit_number` int(11) NOT NULL DEFAULT 0 COMMENT '限购数量',
  `if_enable` tinyint(2) NOT NULL DEFAULT 1 COMMENT '活动预热   1-停用  2-启用',
  `enable_time` int(11) NOT NULL DEFAULT 0 COMMENT '预热几小时前',
  `sales_user_count` int(11) NOT NULL DEFAULT 0 COMMENT '商品维度的下单人数 只要下过单的都算',
  `sales_volume` int(11) NOT NULL DEFAULT 0 COMMENT '当前销量,根据activityType不同而有变化',
  `sku_sales_volume` int(11) NOT NULL DEFAULT 0 COMMENT '该sku总销量',
  `product_sales_volume` int(11) NOT NULL DEFAULT 0 COMMENT '商品总销量',
  `start_time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT '' COMMENT '活动开始时间',
  `end_time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT '' COMMENT '活动开始时间',
  `state` int(11) NOT NULL DEFAULT 0 COMMENT '活动状态 对于平台端 0-报名未开始 1-报名进行中 2-活动待开始 3-活动进行中 4-活动已结束; 对于商家端  0-未开始 1-进行中 2-已结束',
  `create_time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT '1970-01-01 00:00:00' COMMENT '创建时间',
  `update_time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT '1970-01-01 00:00:00' COMMENT '更新时间',
  PRIMARY KEY (`sku_id`) USING BTREE,
  INDEX `idx_product_id`(`product_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin ROW_FORMAT = Dynamic;

SET FOREIGN_KEY_CHECKS = 1;
