
ALTER TABLE `cere_buyer_notice`
ADD COLUMN `status` int(10) NOT NULL DEFAULT '0' COMMENT '0-未删除 1-已删除 主要针对系统公告和站内信使用';

-- 执行之前，可以先看下表中是否有重复的shop_id，如果有，要删除重复的数据
ALTER TABLE `cere_shop_recruit`
ADD PRIMARY KEY (`shop_id`);

-- 执行之前，可以先看下表中是否有重复的username，如果有，要删除重复的数据
ALTER TABLE `cere_platform_business`
ADD UNIQUE INDEX `uqe_idx_username`(`username`) USING BTREE;

-- 执行之前，可以先看下表中是否有重复的 distributor_id buyer_user_id，如果有，要删除重复的数据
ALTER TABLE `cere_distributor_buyer`
ADD PRIMARY KEY (`distributor_id`, `buyer_user_id`) USING BTREE;