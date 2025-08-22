package com.shop.cereshop.app.utils.gust;

import java.time.Duration;

import java.time.Duration;

/**
 * 支付接口测试工具类（Java 8）
 *
 * 说明：
 * - 使用 WxH5PayClient（OkHttp 版本）分别调用：
 *   1) 微信H5支付
 *   2) 银联快捷支付
 *   3) 全额退款（撤销）
 *
 * - 支持从系统属性或环境变量读取配置，便于在不同环境下运行
 * - 默认使用 Mock 地址：https://yapi.newict.com.cn/mock/35
 *
 * 配置优先级：System Property > Environment Variable > 默认值
 * 可用键：
 * - baseUrl               (sys: tgjf.baseUrl, env: TGJF_BASE_URL)
 * - secretKey             (sys: tgjf.secretKey, env: TGJF_SECRET_KEY)
 * - account               (sys: tgjf.account,  env: TGJF_ACCOUNT)
 * - notifyUrl             (sys: tgjf.notifyUrl, env: TGJF_NOTIFY_URL)
 * - returnUrl             (sys: tgjf.returnUrl, env: TGJF_RETURN_URL)  // 仅银联快捷需要
 * - directPayType         (sys: tgjf.directPayType, env: TGJF_DIRECT_PAY_TYPE) // 可选：银联直连或收银台模式
 *
 * 退款（撤销）相关可选配置（当无法从支付响应中获得订单号时使用）：
 * - reverse.account       (sys: tgjf.reverse.account, env: TGJF_REVERSE_ACCOUNT) // 默认沿用 account
 * - reverse.lowOrderId    (sys: tgjf.reverse.lowOrderId, env: TGJF_REVERSE_LOW_ORDER_ID)
 * - reverse.upOrderId     (sys: tgjf.reverse.upOrderId, env: TGJF_REVERSE_UP_ORDER_ID)
 * - refundAccountType     (sys: tgjf.refundAccountType, env: TGJF_REFUND_ACCOUNT_TYPE) // 可选：FUND_ACCOUNT
 *
 * 运行示例（Mock）：
 * java -Dtgjf.baseUrl=https://yapi.newict.com.cn/mock/35 \
 *      -Dtgjf.secretKey=your_secret \
 *      -Dtgjf.account=yourAccount \
 *      -Dtgjf.notifyUrl=https://your.domain/notify \
 *      -Dtgjf.returnUrl=https://your.domain/return \
 *      -cp your-app.jar com.example.tgjf.pay.PayApiTestTool
 */
public class PayApiTestTool {

	private static final String DEFAULT_BASE_URL = "https://tgpay.833006.net";
	private static final String SECRETKEY = "66b153f7df3720ed633eaaf844a22f9b";
	private static final String ACCOUNT = "53842293114119";
	private static final String MCHID = "10091624326";
	private static final String NOTIFYURL = "https://tgpay.833006.net";
	private static final String RETURNURL = "https://tgpay.833006.net";
	private static final String DIRECTPAYTYPE = "";
	private static final String REVERSEACCOUNT = "";
	private static final String reverselowid = "";
	private static final String reverseupid = "";
	private static final String REFUNDACCTTYPE = "";
	
	//公众号appid和sercert
	//wx5f3e4a449aad3099   91d0951a6f8bc937d8b4a017ed64b5f7 

	public static void main(String[] args) throws Exception {

		// 构建客户端
		WxH5PayClient client = WxH5PayClient.newDefault(DEFAULT_BASE_URL, SECRETKEY).withTimeout(Duration.ofSeconds(15));

		// 1) 测试微信H5支付
		//WxH5PayResponse wxResp = testWxH5Pay(client, ACCOUNT, NOTIFYURL);

		// 2) 测试银联快捷支付
		UnionExpressResponse ueResp = testUnionExpress(client, ACCOUNT, NOTIFYURL, RETURNURL, DIRECTPAYTYPE);
		
		/*// 3) 测试全额退款（撤销）
		// 优先使用刚才支付成功返回的订单号；若无，则使用配置的 reverse.lowOrderId / reverse.upOrderId
		String useLowOrderId = null;
		String useUpOrderId = null;
		String useAccount = REVERSEACCOUNT;
		
		if (wxResp != null && wxResp.isSignatureValid() && wxResp.getStatus() == 100 && !isBlank(wxResp.getLowOrderId())
				&& !isBlank(wxResp.getUpOrderId())) {
			useLowOrderId = wxResp.getLowOrderId();
			useUpOrderId = wxResp.getUpOrderId();
			useAccount = ACCOUNT;
			System.out.println("将使用微信H5支付返回的订单号发起撤销。");
		} else if (ueResp != null && ueResp.isSignatureValid()
				&& (ueResp.getStatus() != null && ueResp.getStatus() == 100) && !isBlank(ueResp.getUpOrderId())) {
			// 银联快捷返回规范里 lowOrderId 非必返，若没有则需要你外部保存；这里只示例使用配置项
			useLowOrderId = firstNonBlank(reverselowid);
			useUpOrderId = ueResp.getUpOrderId();
			useAccount = firstNonBlank(ueResp.getAccount(), REVERSEACCOUNT, ACCOUNT);
			System.out.println("将使用银联快捷支付返回的 upOrderId 及配置的 lowOrderId 发起撤销。");
		} else {
			useLowOrderId = reverselowid;
			useUpOrderId = reverseupid;
			System.out.println("未获取到可用的支付返回单号，将使用外部配置的撤销订单号。");
		}
		
		testReverse(client, useAccount, useLowOrderId, useUpOrderId, REFUNDACCTTYPE);*/
	}

	// ========== 测试：微信H5支付 ==========
	private static WxH5PayResponse testWxH5Pay(WxH5PayClient client, String account, String notifyUrl) {
		System.out.println("=== 调用 微信H5支付 开始 ===");
		try {
			String lowOrderId = "WXH5-" + System.currentTimeMillis();
			WxH5PayRequest req = WxH5PayRequest.builder().account(account).lowOrderId(lowOrderId).payMoney("9.99")
					.body("测试商品-微信H5").notifyUrl(notifyUrl).build();

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
	private static UnionExpressResponse testUnionExpress(WxH5PayClient client, String account, String notifyUrl,
			String returnUrl, String directPayType) {
		System.out.println("=== 调用 银联快捷支付 开始 ===");
		try {
			if (isBlank(returnUrl)) {
				throw new IllegalArgumentException(
						"returnUrl is required for UnionExpress test. 请通过 -Dtgjf.returnUrl 或环境变量 TGJF_RETURN_URL 提供。");
			}
			String lowOrderId = "UEXP-" + System.currentTimeMillis();

			UnionExpressRequest.Builder b = UnionExpressRequest.builder().account(account).payMoney("19.88")
					.lowOrderId(lowOrderId).userNo("user-" + account) // 首次支付的唯一标识；后续同一用户需保持一致
					.userType("USER_ID").notifyUrl(notifyUrl).returnUrl(returnUrl);
			if (!isBlank(directPayType)) {
				b.directPayType(directPayType);
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
	private static void testReverse(WxH5PayClient client, String account, String lowOrderId, String upOrderId,
			String refundAccountType) {
		System.out.println("=== 调用 全额退款（撤销） 开始 ===");
		try {
			if (isBlank(account) || isBlank(lowOrderId) || isBlank(upOrderId)) {
				System.err.println("撤销参数不完整，跳过调用。需要提供：account、lowOrderId、upOrderId。");
				System.err.println("可通过支付成功返回的订单号，或配置 -Dtgjf.reverse.lowOrderId / -Dtgjf.reverse.upOrderId 提供。");
				return;
			}

			ReverseRequest.Builder b = ReverseRequest.builder().account(account).lowOrderId(lowOrderId)
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
	private static String firstNonBlank(String... vals) {
		if (vals == null)
			return null;
		for (String v : vals) {
			if (!isBlank(v))
				return v;
		}
		return null;
	}

	private static boolean isBlank(String s) {
		return s == null || s.trim().isEmpty();
	}

	private static String mustGet(String name, String sys, String env) {
		String v = firstNonBlank(sys, env);
		if (isBlank(v)) {
			throw new IllegalArgumentException("Missing required config: " + name + " (system property or env var).");
		}
		return v;
	}

	private static String safeJson(String s) {
		if (s == null)
			return "(null)";
		// 简单压缩打印
		return s.replaceAll("\\s+", " ");
	}
}