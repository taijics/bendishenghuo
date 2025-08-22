package com.shop.cereshop.app.utils.gust;

import java.util.HashMap;
import java.util.Map;

/**
 * 微信H5支付-请求模型
 * 必填字段：account, lowOrderId, payMoney(元), body, notifyUrl
 * 可选字段：appId
 */
public class WxH5PayRequest {
	private String account; // 聚合账号（必填）
	private String appId; // 商户公众账号ID（可选）
	private String lowOrderId; // 下游订单号（必填）
	private String payMoney; // 支付金额(元)（必填，字符串格式）
	private String body; // 商品描述（必填）
	private String notifyUrl; // 通知回调地址（必填）

	public WxH5PayRequest() {
	}

	public WxH5PayRequest(String account, String appId, String lowOrderId, String payMoney, String body,
			String notifyUrl) {
		this.account = account;
		this.appId = appId;
		this.lowOrderId = lowOrderId;
		this.payMoney = payMoney;
		this.body = body;
		this.notifyUrl = notifyUrl;
	}

	public String getAccount() {
		return account;
	}

	public String getAppId() {
		return appId;
	}

	public String getLowOrderId() {
		return lowOrderId;
	}

	public String getPayMoney() {
		return payMoney;
	}

	public String getBody() {
		return body;
	}

	public String getNotifyUrl() {
		return notifyUrl;
	}

	public void setAccount(String account) {
		this.account = account;
	}

	public void setAppId(String appId) {
		this.appId = appId;
	}

	public void setLowOrderId(String lowOrderId) {
		this.lowOrderId = lowOrderId;
	}

	public void setPayMoney(String payMoney) {
		this.payMoney = payMoney;
	}

	public void setBody(String body) {
		this.body = body;
	}

	public void setNotifyUrl(String notifyUrl) {
		this.notifyUrl = notifyUrl;
	}

	/**
	 * 构造成用于签名/请求的参数Map（不包含sign）
	 * 空值字段不放入Map，遵循签名规则。
	 */
	public Map<String, Object> toParamMapWithoutSign() {
		Map<String, Object> m = new HashMap<>();
		putIfNotEmpty(m, "account", account);
		putIfNotEmpty(m, "appId", appId);
		putIfNotEmpty(m, "lowOrderId", lowOrderId);
		putIfNotEmpty(m, "payMoney", payMoney);
		putIfNotEmpty(m, "body", body);
		putIfNotEmpty(m, "notifyUrl", notifyUrl);
		return m;
	}

	private static void putIfNotEmpty(Map<String, Object> map, String key, String val) {
		if (val != null && !val.isEmpty()) {
			map.put(key, val);
		}
	}

	public static Builder builder() {
		return new Builder();
	}

	public static class Builder {
		private final WxH5PayRequest req = new WxH5PayRequest();

		public Builder account(String v) {
			req.setAccount(v);
			return this;
		}

		public Builder appId(String v) {
			req.setAppId(v);
			return this;
		}

		public Builder lowOrderId(String v) {
			req.setLowOrderId(v);
			return this;
		}

		public Builder payMoney(String v) {
			req.setPayMoney(v);
			return this;
		}

		public Builder body(String v) {
			req.setBody(v);
			return this;
		}

		public Builder notifyUrl(String v) {
			req.setNotifyUrl(v);
			return this;
		}

		public WxH5PayRequest build() {
			return req;
		}
	}
}