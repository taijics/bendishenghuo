SET NAMES utf8mb4;
SET
FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for cere_recommend_comment
-- ----------------------------
DROP TABLE IF EXISTS `cere_recommend_comment`;
CREATE TABLE `cere_recommend_comment`
(
    `recommend_comment_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '种草评论id',
    `root_comment_id`      bigint(20) DEFAULT NULL COMMENT '最上级评论id',
    `parent_comment_id`    bigint(20) DEFAULT NULL COMMENT '父评论ID，若为一级评论则为NUL',
    `recommend_id`         bigint(20) NOT NULL COMMENT '种草id',
    `user_id`              bigint(20) NOT NULL COMMENT '评论用户id',
    `user_type`            tinyint(4) NOT NULL COMMENT '评论用户类型：1、用户，2、商家',
    `target_user_id`       bigint(20) DEFAULT NULL COMMENT '目标评论用户id',
    `target_user_type`     tinyint(4) DEFAULT NULL COMMENT '目标评论用户类型：1、用户，2、商家',
    `content`              text NOT NULL COMMENT '评论内容',
    `read_status`          tinyint(4) DEFAULT '0' COMMENT '是否已读：0、未读 1、已读',
    `reply_count`          int(10) DEFAULT '0' COMMENT '回复数',
    `create_time`          varchar(20) DEFAULT NULL COMMENT '创建时间',
    PRIMARY KEY (`recommend_comment_id`)
) ENGINE=InnoDB AUTO_INCREMENT=214 DEFAULT CHARSET=utf8 COMMENT='种草评论表';

-- ----------------------------
-- Table structure for cere_recommend_likes
-- ----------------------------
DROP TABLE IF EXISTS `cere_recommend_likes`;
CREATE TABLE `cere_recommend_likes`
(
    `recommend_like_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '种草点赞id',
    `user_id`           bigint(20) NOT NULL COMMENT '点赞用户id',
    `recommend_id`      bigint(20) NOT NULL COMMENT '种草id',
    `create_time`       varchar(20) DEFAULT NULL COMMENT '创建时间',
    PRIMARY KEY (`recommend_like_id`),
    KEY                 `idx_recommend_id` (`recommend_id`)
) ENGINE=InnoDB AUTO_INCREMENT=68 DEFAULT CHARSET=utf8 COMMENT='种草点赞表';

-- ----------------------------
-- Table structure for cere_recommend_relation
-- ----------------------------
DROP TABLE IF EXISTS `cere_recommend_relation`;
CREATE TABLE `cere_recommend_relation`
(
    `recommend_relation_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '关联id',
    `recommend_id`          bigint(20) NOT NULL COMMENT '种草id',
    `product_id`            bigint(20) NOT NULL COMMENT '商品id',
    PRIMARY KEY (`recommend_relation_id`)
) ENGINE=InnoDB AUTO_INCREMENT=126 DEFAULT CHARSET=utf8 COMMENT='种草商品关联表';

-- ----------------------------
-- Table structure for cere_recommend_trends
-- ----------------------------
DROP TABLE IF EXISTS `cere_recommend_trends`;
CREATE TABLE `cere_recommend_trends`
(
    `recommend_id`   bigint(20) NOT NULL AUTO_INCREMENT COMMENT '种草id',
    `shop_id`        bigint(20) DEFAULT NULL COMMENT '店铺id',
    `recommend_type` tinyint(1) NOT NULL COMMENT '种草类型',
    `file_type`      tinyint(1) NOT NULL COMMENT '文件类型 1-图文 2-视频',
    `cover`          text COMMENT '封面',
    `file_url`       text COMMENT '文件地址',
    `remark`         text COMMENT '文案',
    `review_content` varchar(255) DEFAULT NULL COMMENT '审核内容',
    `publish_status` tinyint(1) DEFAULT '0' COMMENT '发布状态 0-未审核 1-已发布 2-审核失败',
    `product_count`  int(10) DEFAULT '0' COMMENT '商品数量',
    `like_count`     int(10) DEFAULT '0' COMMENT '点赞数',
    `comment_count`  int(10) DEFAULT '0' COMMENT '评论数',
    `browse_count`   int(10) DEFAULT '0' COMMENT '浏览数',
    `share_count`    int(10) DEFAULT '0' COMMENT '分享数',
    `publish_time`   varchar(20)  DEFAULT NULL COMMENT '发布时间',
    `create_time`    varchar(20)  DEFAULT NULL COMMENT '创建时间',
    `update_time`    varchar(20)  DEFAULT NULL COMMENT '更新时间',
    PRIMARY KEY (`recommend_id`)
) ENGINE=InnoDB AUTO_INCREMENT=82 DEFAULT CHARSET=utf8 COMMENT='种草动态表';

-- ----------------------------
-- Table structure for cere_recommend_type
-- ----------------------------
DROP TABLE IF EXISTS `cere_recommend_type`;
CREATE TABLE `cere_recommend_type`
(
    `recommend_type_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '关联id',
    `name`              varchar(20) NOT NULL COMMENT '类型名称',
    `sort`              int(10) NOT NULL COMMENT '排序',
    PRIMARY KEY (`recommend_type_id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8 COMMENT='种草类型管理表';

SET
FOREIGN_KEY_CHECKS = 1;

INSERT INTO `cere_platform_permission` (`permission_id`, `permission_pid`, `permission_name`, `permission_uri`,
                                        `permission`, `icon`, `describe`, `resource_type`, `sort`, `project`,
                                        `create_time`, `update_time`)
VALUES (2713, 0, '内容管理', '', '/content', 'Notebook', '', 'catalog', 4, 1, '2024-04-17 20:04:43', NULL);
INSERT INTO `cere_platform_permission` (`permission_id`, `permission_pid`, `permission_name`, `permission_uri`,
                                        `permission`, `icon`, `describe`, `resource_type`, `sort`, `project`,
                                        `create_time`, `update_time`)
VALUES (2714, 2713, '种草管理', '', '/content/manage', 'Setting', '', 'menu', 1, 1, '2024-04-17 20:06:49', NULL);
INSERT INTO `cere_platform_permission` (`permission_id`, `permission_pid`, `permission_name`, `permission_uri`,
                                        `permission`, `icon`, `describe`, `resource_type`, `sort`, `project`,
                                        `create_time`, `update_time`)
VALUES (2715, 2713, '内容风控', '', '/content/control', 'Discount', '', 'menu', 2, 1, '2024-04-17 20:08:37', NULL);
INSERT INTO `cere_platform_permission` (`permission_id`, `permission_pid`, `permission_name`, `permission_uri`,
                                        `permission`, `icon`, `describe`, `resource_type`, `sort`, `project`,
                                        `create_time`, `update_time`)
VALUES (2716, 2713, '种草分类', '', '/content/classify', 'List', '', 'menu', 2, 1, '2024-04-17 20:17:53', NULL);
INSERT INTO `cere_platform_permission` (`permission_id`, `permission_pid`, `permission_name`, `permission_uri`,
                                        `permission`, `icon`, `describe`, `resource_type`, `sort`, `project`,
                                        `create_time`, `update_time`)
VALUES (2717, 0, '内容管理', '', '/content', 'Document', '', 'catalog', 3, 0, '2024-04-26 15:42:41', NULL);
INSERT INTO `cere_platform_permission` (`permission_id`, `permission_pid`, `permission_name`, `permission_uri`,
                                        `permission`, `icon`, `describe`, `resource_type`, `sort`, `project`,
                                        `create_time`, `update_time`)
VALUES (2718, 2717, '种草动态', '', '/content/dynamic', 'Football', '', 'menu', 50, 0, '2024-04-26 15:44:07', NULL);
INSERT INTO `cere_platform_permission` (`permission_id`, `permission_pid`, `permission_name`, `permission_uri`,
                                        `permission`, `icon`, `describe`, `resource_type`, `sort`, `project`,
                                        `create_time`, `update_time`)
VALUES (2719, 2717, '种草评论', '', '/content/comment', 'Tickets', '', 'menu', 52, 0, '2024-04-26 15:44:45', NULL);