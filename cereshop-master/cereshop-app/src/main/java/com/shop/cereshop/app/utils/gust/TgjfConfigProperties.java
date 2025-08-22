package com.shop.cereshop.app.utils.gust;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

import lombok.Data;

@Component
@ConfigurationProperties(prefix = "tgjf")
@Data
public class TgjfConfigProperties {
	private String baseUrl;
	private String secretKey;
	private String account;
	private String mchid;
	private String notifyUrl;
	private String returnUrl;
	private String directPayType;

	public static class Reverse {
		private String account;
		private String lowOrderId;
		private String upOrderId;

		public String getAccount() {
			return account;
		}

		public void setAccount(String account) {
			this.account = account;
		}

		public String getLowOrderId() {
			return lowOrderId;
		}

		public void setLowOrderId(String lowOrderId) {
			this.lowOrderId = lowOrderId;
		}

		public String getUpOrderId() {
			return upOrderId;
		}

		public void setUpOrderId(String upOrderId) {
			this.upOrderId = upOrderId;
		}
	}

	private Reverse reverse = new Reverse();
	private String refundAccountType;

}