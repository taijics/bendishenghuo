-- 订单查询接口加索引解决慢sql
create index idx_cere_shop_order_buyer_user_id on cere_shop_order (buyer_user_id);
create index idx_cere_order_after_after_id on cere_order_after (after_id);
create index idx_cere_order_after_order_id on cere_order_after (order_id);
create index idx_cere_order_dilever_order_id on cere_order_dilever (order_id);
create index idx_cere_order_product_order_id on cere_order_product (order_id);
create index idx_cere_collage_order_detail_order_id on cere_collage_order_detail (order_id);
create index idx_cere_shop_order_order_id on cere_shop_order (order_id);
create index idx_cere_pay_log_order_formid on cere_pay_log (order_formid);
create index idx_cere_product_sku_product_id on cere_product_sku(product_id)
create index idx_cere_product_image_product_id on cere_product_image(product_id)