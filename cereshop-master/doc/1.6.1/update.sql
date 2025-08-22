ALTER TABLE `cere_order_product`
ADD COLUMN `logistics_price` decimal(15,2) NOT NULL DEFAULT '0.00' COMMENT '运费';

ALTER TABLE `cere_shop_order`
ADD COLUMN `pricing_price` decimal(15, 2) NULL COMMENT '定价捆绑优惠金额';

ALTER TABLE `cere_platform_business`
ADD COLUMN `phone` varchar(20) NULL COMMENT '手机号' AFTER `avatar`;

ALTER TABLE `cere_platform_business`
ADD UNIQUE INDEX `uqe_idx_phone`(`phone`) USING BTREE;

CREATE TABLE `cere_privacy_verify_setting` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project` int(11) NOT NULL COMMENT '平台端为1，商家端则为shop_id',
  `phone` varchar(20) COLLATE utf8mb4_bin NOT NULL COMMENT '隐私二次认证手机号',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uqe_idx_project` (`project`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

/* 商家端菜单 */
INSERT INTO `cere_platform_permission`(`permission_id`, `permission_pid`, `permission_name`, `permission_uri`, `permission`, `icon`, `describe`, `resource_type`, `sort`, `project`, `create_time`, `update_time`) VALUES (4095, 0, '二次认证管理', '', 'two', 'el-icon-view', '', 'catalog', 2, 0, '2022-02-18 17:57:13', NULL);
INSERT INTO `cere_platform_permission`(`permission_id`, `permission_pid`, `permission_name`, `permission_uri`, `permission`, `icon`, `describe`, `resource_type`, `sort`, `project`, `create_time`, `update_time`) VALUES (4096, 4095, '二次认证', '', '/setup/privacy', 'el-icon-finished', '', 'menu', 1534, 0, '2022-02-18 17:57:55', NULL);
INSERT INTO `cere_platform_permission`(`permission_id`, `permission_pid`, `permission_name`, `permission_uri`, `permission`, `icon`, `describe`, `resource_type`, `sort`, `project`, `create_time`, `update_time`) VALUES (4097, 69, '手机号管理', '', '/setup/phone', 'el-icon-phone', '', 'menu', 1513, 0, '2022-02-15 18:31:09', NULL);

/* 平台端菜单 */
INSERT INTO `cere_platform_permission`(`permission_id`, `permission_pid`, `permission_name`, `permission_uri`, `permission`, `icon`, `describe`, `resource_type`, `sort`, `project`, `create_time`, `update_time`) VALUES (4025, 1, '手机号管理', '', '/setup/phone', 'el-icon-phone', '', 'menu', 1510, 1, '2022-02-15 15:27:54', '2022-02-15 16:08:07');
INSERT INTO `cere_platform_permission`(`permission_id`, `permission_pid`, `permission_name`, `permission_uri`, `permission`, `icon`, `describe`, `resource_type`, `sort`, `project`, `create_time`, `update_time`) VALUES (4092, 0, '二次认证管理', '', 'two', 'el-icon-view', '二次认证', 'catalog', 2, 1, '2022-02-18 10:50:01', '2022-02-18 10:55:19');
INSERT INTO `cere_platform_permission`(`permission_id`, `permission_pid`, `permission_name`, `permission_uri`, `permission`, `icon`, `describe`, `resource_type`, `sort`, `project`, `create_time`, `update_time`) VALUES (4094, 4092, '二次认证', '', '/setup/privacy', 'el-icon-finished', '', 'menu', 1533, 1, '2022-02-18 10:56:34', NULL);

INSERT INTO `cere_platform_role_permission`(`role_id`, `permission_id`) VALUES (1, 4025);
INSERT INTO `cere_platform_role_permission`(`role_id`, `permission_id`) VALUES (1, 4092);
INSERT INTO `cere_platform_role_permission`(`role_id`, `permission_id`) VALUES (1, 4094);
