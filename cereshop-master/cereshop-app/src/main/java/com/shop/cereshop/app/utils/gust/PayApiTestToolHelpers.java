package com.shop.cereshop.app.utils.gust;
public final class PayApiTestToolHelpers {

    private PayApiTestToolHelpers() {}

    // ========== 测试：微信H5支付 ==========
    public static WxH5PayResponse testWxH5Pay(WxH5PayClient client, String account, String notifyUrl) {
        System.out.println("=== 调用 微信H5支付 开始 ===");
        try {
            String lowOrderId = "WXH5-" + System.currentTimeMillis();
            WxH5PayRequest req = WxH5PayRequest.builder()
                    .account(account)
                    .lowOrderId(lowOrderId)
                    .payMoney("9.99")
                    .body("测试商品-微信H5")
                    .notifyUrl(notifyUrl)
                    .build();

            WxH5PayResponse resp = client.callWxH5Pay(req);

            System.out.println("响应 status        = " + resp.getStatus());
            System.out.println("响应 message       = " + resp.getMessage());
            System.out.println("响应 pay_url       = " + resp.getPay_url());
            System.out.println("响应 lowOrderId    = " + resp.getLowOrderId());
            System.out.println("响应 upOrderId     = " + resp.getUpOrderId());
            System.out.println("响应 验签通过       = " + resp.isSignatureValid());
            System.out.println("原始响应           = " + safeJson(resp.getRawBody()));
            return resp;
        } catch (Exception e) {
            System.err.println("微信H5支付调用失败: " + e.getMessage());
            e.printStackTrace(System.err);
            return null;
        } finally {
            System.out.println("=== 调用 微信H5支付 结束 ===\n");
        }
    }

    // ========== 测试：银联快捷支付 ==========
    public static UnionExpressResponse testUnionExpress(WxH5PayClient client,
                                                        String account,
                                                        String notifyUrl,
                                                        String returnUrl,
                                                        String directPayType) {
        System.out.println("=== 调用 银联快捷支付 开始 ===");
        try {
            if (isBlank(returnUrl)) {
                throw new IllegalArgumentException("returnUrl is required for UnionExpress test. 请通过配置 tgjf.returnUrl 提供。");
            }
            String lowOrderId = "UEXP-" + System.currentTimeMillis();

            UnionExpressRequest.Builder b = UnionExpressRequest.builder()
                    .account(account)
                    .payMoney("19.88")
                    .lowOrderId(lowOrderId)
                    .userNo("user-" + account) // 首次支付的唯一标识；后续同一用户需保持一致
                    .userType("USER_ID")
                    .notifyUrl(notifyUrl)
                    .returnUrl(returnUrl);
            if (!isBlank(directPayType)) {
                b.directPayType(directPayType); // 可选：直连/收银台模式
            }

            UnionExpressRequest req = b.build();

            UnionExpressResponse resp = client.callUnionExpress(req);

            System.out.println("响应 status        = " + resp.getStatus());
            System.out.println("响应 state         = " + resp.getState());
            System.out.println("响应 message       = " + resp.getMessage());
            System.out.println("响应 codeUrl       = " + resp.getCodeUrl());
            System.out.println("响应 upOrderId     = " + resp.getUpOrderId());
            System.out.println("响应 upperOrderId  = " + resp.getUpperOrderId());
            System.out.println("响应 account       = " + resp.getAccount());
            System.out.println("响应 验签通过       = " + resp.isSignatureValid());
            System.out.println("原始响应           = " + safeJson(resp.getRawBody()));
            return resp;
        } catch (Exception e) {
            System.err.println("银联快捷支付调用失败: " + e.getMessage());
            e.printStackTrace(System.err);
            return null;
        } finally {
            System.out.println("=== 调用 银联快捷支付 结束 ===\n");
        }
    }

    // ========== 测试：全额退款（撤销） ==========
    public static void testReverse(WxH5PayClient client,
                                   String account,
                                   String lowOrderId,
                                   String upOrderId,
                                   String refundAccountType) {
        System.out.println("=== 调用 全额退款（撤销） 开始 ===");
        try {
            if (isBlank(account) || isBlank(lowOrderId) || isBlank(upOrderId)) {
                System.err.println("撤销参数不完整，跳过调用。需要提供：account、lowOrderId、upOrderId。");
                return;
            }

            ReverseRequest.Builder b = ReverseRequest.builder()
                    .account(account)
                    .lowOrderId(lowOrderId)
                    .upOrderId(upOrderId);
            if (!isBlank(refundAccountType)) {
                b.refundAccountType(refundAccountType); // 可选：FUND_ACCOUNT
            }
            ReverseRequest req = b.build();

            ReverseResponse resp = client.callReverse(req);

            System.out.println("响应 status        = " + resp.getStatus());
            System.out.println("响应 state         = " + resp.getState());
            System.out.println("响应 message       = " + resp.getMessage());
            System.out.println("响应 account       = " + resp.getAccount());
            System.out.println("响应 upOrderId     = " + resp.getUpOrderId());
            System.out.println("响应 lowOrderId    = " + resp.getLowOrderId());
            System.out.println("响应 验签通过       = " + resp.isSignatureValid());
            System.out.println("原始响应           = " + safeJson(resp.getRawBody()));
        } catch (Exception e) {
            System.err.println("全额退款（撤销）调用失败: " + e.getMessage());
            e.printStackTrace(System.err);
        } finally {
            System.out.println("=== 调用 全额退款（撤销） 结束 ===\n");
        }
    }

    // ----------- 工具方法 -----------
    private static boolean isBlank(String s) {
        return s == null || s.trim().isEmpty();
    }

    private static String safeJson(String s) {
        if (s == null) return "(null)";
        return s.replaceAll("\\s+", " ");
    }
}