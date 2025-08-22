package com.shop.cereshop.app.utils.gust;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import okhttp3.MediaType;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;
import okhttp3.Response;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.time.Duration;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.TimeUnit;

/**
 * 支付接口客户端工具类（Java 8 + OkHttp 版本）
 *
 * 已集成：
 * - 微信H5支付：POST /tgPosp/services/payApi/wxH5Pay
 * - 银联快捷支付：POST /tgPosp/services/payApi/unionExpress
 * - 全额退款（撤销）：POST /tgPosp/services/payApi/reverse
 *
 * 通用要求：
 * - Content-Type: application/json; charset=UTF-8
 * - 方法：POST；编码：UTF-8
 * - 必须使用签名（见 TgjfSignUtil）
 * - 生产环境请务必使用 HTTPS 域名调用
 */
public class WxH5PayClient {

	public static final String PATH_WX_H5_PAY = "/tgPosp/services/payApi/wxH5Pay";
	public static final String PATH_UNION_EXPRESS = "/tgPosp/services/payApi/unionExpress";
	public static final String PATH_REVERSE = "/tgPosp/services/payApi/reverse";
	public static final String DEFAULT_CONTENT_TYPE = "application/json; charset=UTF-8";
	private static final MediaType JSON = MediaType.parse("application/json; charset=utf-8");

	private final String baseUrl;
	private final String secretKey;
	private OkHttpClient httpClient;
	private final ObjectMapper objectMapper;
	private Duration timeout = Duration.ofSeconds(15);

	public WxH5PayClient(String baseUrl, String secretKey, OkHttpClient httpClient, ObjectMapper objectMapper) {
		this.baseUrl = trimTrailingSlash(baseUrl);
		this.secretKey = secretKey;
		this.objectMapper = objectMapper != null ? objectMapper : new ObjectMapper();
		if (httpClient != null) {
			this.httpClient = httpClient;
		} else {
			this.httpClient = buildClientWithTimeout(this.timeout);
		}
	}

	public static WxH5PayClient newDefault(String baseUrl, String secretKey) {
		return new WxH5PayClient(baseUrl, secretKey, null, new ObjectMapper());
	}

	public WxH5PayClient withTimeout(Duration timeout) {
		if (timeout != null) {
			this.timeout = timeout;
			this.httpClient = buildClientWithTimeout(timeout);
		}
		return this;
	}

	private OkHttpClient buildClientWithTimeout(Duration timeout) {
		long millis = timeout.toMillis();
		return new OkHttpClient.Builder().callTimeout(millis, TimeUnit.MILLISECONDS)
				.connectTimeout(millis, TimeUnit.MILLISECONDS).readTimeout(millis, TimeUnit.MILLISECONDS)
				.writeTimeout(millis, TimeUnit.MILLISECONDS).build();
	}

	// -------- 微信H5支付 --------
	public WxH5PayResponse callWxH5Pay(WxH5PayRequest request) throws IOException {
		if (request == null)
			throw new IllegalArgumentException("request cannot be null");
		validateRequiredWxH5(request);

		Map<String, Object> params = new HashMap<>(request.toParamMapWithoutSign());
		String sign = TgjfSignUtil.computeSign(params, secretKey);
		params.put("sign", sign);

		String url = buildUrl(PATH_WX_H5_PAY);
		String body = doPost(url, params);

		Map<String, Object> respMap = parseJsonToMap(body);
		boolean signatureValid = TgjfSignUtil.verifySign(respMap, secretKey);

		WxH5PayResponse resp = mapToWxH5Response(respMap);
		resp.setSignatureValid(signatureValid);
		resp.setRawBody(body);
		resp.setAllFields(respMap);
		return resp;
	}

	// -------- 银联快捷支付 --------
	public UnionExpressResponse callUnionExpress(UnionExpressRequest request) throws IOException {
		if (request == null)
			throw new IllegalArgumentException("request cannot be null");
		validateRequiredUnionExpress(request);

		Map<String, Object> params = new HashMap<>(request.toParamMapWithoutSign());
		String sign = TgjfSignUtil.computeSign(params, secretKey);
		params.put("sign", sign);

		String url = buildUrl(PATH_UNION_EXPRESS);
		String body = doPost(url, params);

		Map<String, Object> respMap = parseJsonToMap(body);
		boolean signatureValid = TgjfSignUtil.verifySign(respMap, secretKey);

		UnionExpressResponse resp = mapToUnionExpressResponse(respMap);
		resp.setSignatureValid(signatureValid);
		resp.setRawBody(body);
		resp.setAllFields(respMap);
		return resp;
	}

	// -------- 全额退款（撤销） --------
	public ReverseResponse callReverse(ReverseRequest request) throws IOException {
		if (request == null)
			throw new IllegalArgumentException("request cannot be null");
		validateRequiredReverse(request);

		Map<String, Object> params = new HashMap<>(request.toParamMapWithoutSign());
		String sign = TgjfSignUtil.computeSign(params, secretKey);
		params.put("sign", sign);

		String url = buildUrl(PATH_REVERSE);
		String body = doPost(url, params);

		Map<String, Object> respMap = parseJsonToMap(body);
		boolean signatureValid = TgjfSignUtil.verifySign(respMap, secretKey);

		ReverseResponse resp = mapToReverseResponse(respMap);
		resp.setSignatureValid(signatureValid);
		resp.setRawBody(body);
		resp.setAllFields(respMap);
		return resp;
	}

	// -------- 内部公共方法 --------
	private String doPost(String url, Map<String, Object> params) throws IOException {
		String json = objectMapper.writeValueAsString(params);
		RequestBody requestBody = RequestBody.create(JSON, json.getBytes(StandardCharsets.UTF_8));
		Request httpRequest = new Request.Builder().url(url).addHeader("Content-Type", DEFAULT_CONTENT_TYPE)
				.post(requestBody).build();

		try (Response response = httpClient.newCall(httpRequest).execute()) {
			if (!response.isSuccessful()) {
				throw new IOException("HTTP " + response.code() + " calling " + url);
			}
			if (response.body() == null)
				return "";
			return response.body().string();
		}
	}

	private Map<String, Object> parseJsonToMap(String body) throws IOException {
		Map<String, Object> respMap = objectMapper.readValue(body, new TypeReference<Map<String, Object>>() {
		});
		return respMap != null ? respMap : new HashMap<String, Object>();
	}

	private WxH5PayResponse mapToWxH5Response(Map<String, Object> m) {
		WxH5PayResponse r = new WxH5PayResponse();
		r.setStatus((int) toNumber(m.get("status"), 0));
		r.setMessage(toStringOrNull(m.get("message")));
		r.setSign(toStringOrNull(m.get("sign")));
		r.setPay_url(toStringOrNull(m.get("pay_url")));
		r.setLowOrderId(toStringOrNull(m.get("lowOrderId")));
		r.setUpOrderId(toStringOrNull(m.get("upOrderId")));
		return r;
	}

	private UnionExpressResponse mapToUnionExpressResponse(Map<String, Object> m) {
		UnionExpressResponse r = new UnionExpressResponse();
		r.setStatus(toInteger(m.get("status")));
		r.setMessage(toStringOrNull(m.get("message")));
		r.setSign(toStringOrNull(m.get("sign")));
		r.setCodeUrl(toStringOrNull(m.get("codeUrl")));
		r.setUpOrderId(toStringOrNull(m.get("upOrderId")));
		r.setUpperOrderId(toStringOrNull(m.get("upperOrderId")));
		r.setState(toStringOrNull(m.get("state")));
		r.setAccount(toStringOrNull(m.get("account")));
		return r;
	}

	private ReverseResponse mapToReverseResponse(Map<String, Object> m) {
		ReverseResponse r = new ReverseResponse();
		r.setStatus(toInteger(m.get("status")));
		r.setMessage(toStringOrNull(m.get("message")));
		r.setAccount(toStringOrNull(m.get("account")));
		r.setUpOrderId(toStringOrNull(m.get("upOrderId")));
		r.setLowOrderId(toStringOrNull(m.get("lowOrderId")));
		r.setState(toStringOrNull(m.get("state")));
		r.setSign(toStringOrNull(m.get("sign")));
		return r;
	}

	private static Number toNumber(Object o, int defaultVal) {
		if (o == null)
			return defaultVal;
		if (o instanceof Number)
			return (Number) o;
		try {
			return Integer.parseInt(String.valueOf(o));
		} catch (Exception e) {
			return defaultVal;
		}
	}

	private static Integer toInteger(Object o) {
		if (o == null)
			return null;
		if (o instanceof Number)
			return ((Number) o).intValue();
		try {
			return Integer.parseInt(String.valueOf(o));
		} catch (Exception e) {
			return null;
		}
	}

	private static String toStringOrNull(Object o) {
		return o == null ? null : String.valueOf(o);
	}

	private String buildUrl(String path) {
		if (path == null || path.isEmpty())
			return baseUrl;
		if (path.startsWith("http://") || path.startsWith("https://"))
			return path;
		String p = path.startsWith("/") ? path : ("/" + path);
		return baseUrl + p;
	}

	private static String trimTrailingSlash(String s) {
		if (s == null)
			return null;
		if (s.endsWith("/"))
			return s.substring(0, s.length() - 1);
		return s;
	}

	private static void validateRequiredWxH5(WxH5PayRequest req) {
		if (isEmpty(req.getAccount()))
			throw new IllegalArgumentException("account is required");
		if (isEmpty(req.getLowOrderId()))
			throw new IllegalArgumentException("lowOrderId is required");
		if (isEmpty(req.getPayMoney()))
			throw new IllegalArgumentException("payMoney is required");
		if (isEmpty(req.getBody()))
			throw new IllegalArgumentException("body is required");
		if (isEmpty(req.getNotifyUrl()))
			throw new IllegalArgumentException("notifyUrl is required");
	}

	private static void validateRequiredUnionExpress(UnionExpressRequest r) {
		if (isEmpty(r.getAccount()))
			throw new IllegalArgumentException("account is required");
		if (isEmpty(r.getPayMoney()))
			throw new IllegalArgumentException("payMoney is required");
		if (isEmpty(r.getLowOrderId()))
			throw new IllegalArgumentException("lowOrderId is required");
		if (isEmpty(r.getUserNo()))
			throw new IllegalArgumentException("userNo is required");
		if (isEmpty(r.getUserType()))
			throw new IllegalArgumentException("userType is required");
		if (isEmpty(r.getNotifyUrl()))
			throw new IllegalArgumentException("notifyUrl is required");
		if (isEmpty(r.getReturnUrl()))
			throw new IllegalArgumentException("returnUrl is required");
	}

	private static void validateRequiredReverse(ReverseRequest r) {
		if (isEmpty(r.getAccount()))
			throw new IllegalArgumentException("account is required");
		if (isEmpty(r.getLowOrderId()))
			throw new IllegalArgumentException("lowOrderId is required");
		if (isEmpty(r.getUpOrderId()))
			throw new IllegalArgumentException("upOrderId is required");
	}

	private static boolean isEmpty(String s) {
		return s == null || s.isEmpty();
	}
}