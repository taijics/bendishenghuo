package com.shop.cereshop.app.utils.gust;

import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import java.time.Duration;

@Component
public class PayApiTestRunner implements CommandLineRunner {

	private final TgjfConfigProperties cfg;

	public PayApiTestRunner(TgjfConfigProperties cfg) {
		this.cfg = cfg;
	}

	@Override
	public void run(String... args) throws Exception {
		String baseUrl = nvl(cfg.getBaseUrl(), "https://yapi.newict.com.cn/mock/35");
		String secretKey = required(cfg.getSecretKey(), "tgjf.secretKey");
		String account = required(cfg.getAccount(), "tgjf.account");
		String notifyUrl = required(cfg.getNotifyUrl(), "tgjf.notifyUrl");
		String returnUrl = cfg.getReturnUrl();
		String directPayType = cfg.getDirectPayType();
		String reverseAccount = nvl(cfg.getReverse().getAccount(), account);
		String reverseLowId = cfg.getReverse().getLowOrderId();
		String reverseUpId = cfg.getReverse().getUpOrderId();
		String refundAcctType = cfg.getRefundAccountType();

		WxH5PayClient client = WxH5PayClient.newDefault(baseUrl, secretKey).withTimeout(Duration.ofSeconds(15));

		System.out.println("=== 基础配置 ===");
		System.out.println("baseUrl         = " + baseUrl);
		System.out.println("account         = " + account);
		System.out.println("notifyUrl       = " + notifyUrl);
		System.out.println("returnUrl       = " + (isBlank(returnUrl) ? "(null)" : returnUrl));
		System.out.println("directPayType   = " + (isBlank(directPayType) ? "(null)" : directPayType));
		System.out.println("reverse.account = " + reverseAccount);
		System.out.println("reverse.lowOrderId = " + (isBlank(reverseLowId) ? "(null)" : reverseLowId));
		System.out.println("reverse.upOrderId  = " + (isBlank(reverseUpId) ? "(null)" : reverseUpId));
		System.out.println("refundAccountType  = " + (isBlank(refundAcctType) ? "(null)" : refundAcctType));
		System.out.println();

		WxH5PayResponse wxResp = PayApiTestToolHelpers.testWxH5Pay(client, account, notifyUrl);
		UnionExpressResponse ueResp = PayApiTestToolHelpers.testUnionExpress(client, account, notifyUrl, returnUrl,
				directPayType);

		String useLowOrderId;
		String useUpOrderId;
		String useAccount = reverseAccount;

		if (wxResp != null && wxResp.isSignatureValid() && wxResp.getStatus() == 100 && !isBlank(wxResp.getLowOrderId())
				&& !isBlank(wxResp.getUpOrderId())) {
			useLowOrderId = wxResp.getLowOrderId();
			useUpOrderId = wxResp.getUpOrderId();
			useAccount = account;
			System.out.println("将使用微信H5支付返回的订单号发起撤销。");
		} else if (ueResp != null && ueResp.isSignatureValid()
				&& (ueResp.getStatus() != null && ueResp.getStatus() == 100) && !isBlank(ueResp.getUpOrderId())) {
			useLowOrderId = nvl(reverseLowId, null);
			useUpOrderId = ueResp.getUpOrderId();
			useAccount = nvl(ueResp.getAccount(), nvl(reverseAccount, account));
			System.out.println("将使用银联快捷支付返回的 upOrderId 及配置的 lowOrderId 发起撤销。");
		} else {
			useLowOrderId = reverseLowId;
			useUpOrderId = reverseUpId;
			System.out.println("未获取到可用的支付返回单号，将使用外部配置的撤销订单号。");
		}

		PayApiTestToolHelpers.testReverse(client, useAccount, useLowOrderId, useUpOrderId, refundAcctType);
	}

	private static boolean isBlank(String s) {
		return s == null || s.trim().isEmpty();
	}

	private static String nvl(String v, String def) {
		return isBlank(v) ? def : v;
	}

	private static String required(String v, String key) {
		if (isBlank(v))
			throw new IllegalArgumentException("Missing required config: " + key);
		return v;
	}
}