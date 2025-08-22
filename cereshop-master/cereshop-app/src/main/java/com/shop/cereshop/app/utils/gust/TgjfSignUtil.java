package com.shop.cereshop.app.utils.gust;

import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
import java.security.*;
import java.security.interfaces.RSAPrivateKey;
import java.security.interfaces.RSAPublicKey;
import java.security.spec.*;
import java.util.*;
import java.util.Base64;
import javax.crypto.Mac;

/**
 * 通用签名工具类
 *
 * 支持两类签名方案：
 * 1) MD5_WITH_KEY（原有方案）：字段按 ASCII 升序 + QueryString + &key=密钥 + MD5(大写)
 * 2) RSA（平台示例方案）：字段按 ASCII 升序 + QueryString（不追加 key）+ RSA 私钥签名/公钥验签
 *
 * 规则（两类方案通用）：
 * - 不参与签名的字段：sign；以及以 "reserved"（忽略大小写）为前缀的字段
 * - 字段名与字段值均不做 URL 编码，直接使用原始值
 * - 默认为“空值不参与签名”（null 或 ""），如需包含空值，可使用带 excludeEmpty=false 的重载
 */
public final class TgjfSignUtil {

	private static final String SIGN_FIELD = "sign";
	private static final String RESERVED_PREFIX = "reserved";
	private static final Charset DEFAULT_CHARSET = StandardCharsets.UTF_8;

	private TgjfSignUtil() {
	}

	// ----------------- 旧方案：MD5 + &key=secretKey -----------------

	/**
	 * 计算 MD5-with-key 签名（老方案，兼容现有接口）。
	 * 规则：对非空参数按 ASCII 升序，用 key=value&... 拼接，最后再拼接 &key=secretKey，MD5 后转大写。
	 */
	public static String computeSign(Map<String, ?> params, String secretKey) {
		String plaintext = buildSignPlaintextWithKey(params, secretKey, true);
		return md5Upper(plaintext);
	}

	/**
	 * 验证 MD5-with-key 签名（老方案）。
	 */
	public static boolean verifySign(Map<String, ?> paramsWithSign, String secretKey) {
		if (paramsWithSign == null || paramsWithSign.isEmpty())
			return false;
		Object signObj = paramsWithSign.get(SIGN_FIELD);
		if (isEmpty(signObj))
			return false;

		Map<String, Object> copy = new HashMap<>();
		for (Map.Entry<String, ?> e : paramsWithSign.entrySet()) {
			String k = e.getKey();
			if (k == null)
				continue;
			if (SIGN_FIELD.equalsIgnoreCase(k))
				continue;
			copy.put(k, e.getValue());
		}
		String expect = computeSign(copy, secretKey);
		String actual = String.valueOf(signObj);
		return expect.equalsIgnoreCase(actual);
	}

	// ----------------- 新增方案：RSA 私钥签名 / 公钥验签 -----------------

	/**
	 * 计算 RSA 签名，默认算法 SHA256withRSA，UTF-8 字符集，空值不参与签名。
	 * privateKeyBase64OrPem：PKCS#8 私钥（Base64 或 PEM 文本）。
	 */
	public static String computeRsaSign(Map<String, ?> params, String privateKeyBase64OrPem)
			throws GeneralSecurityException {
		return computeRsaSign(params, privateKeyBase64OrPem, "SHA256withRSA", DEFAULT_CHARSET, true);
	}

	/**
	 * 计算 RSA 签名（可选算法/字符集/是否排除空值）。
	 * 常见算法："SHA256withRSA" 或 "SHA1withRSA"（按平台 SignUtil.sign 实际实现选择）。
	 */
	public static String computeRsaSign(Map<String, ?> params, String privateKeyBase64OrPem, String algorithm,
			Charset charset, boolean excludeEmpty) throws GeneralSecurityException {
		String plaintext = buildSignPlaintext(params, excludeEmpty);
		PrivateKey pri = loadPrivateKey(privateKeyBase64OrPem);
		Signature signature = Signature.getInstance(algorithm);
		signature.initSign(pri);
		signature.update(plaintext.getBytes(charset == null ? DEFAULT_CHARSET : charset));
		byte[] sigBytes = signature.sign();
		return Base64.getEncoder().encodeToString(sigBytes);
	}

	/**
	 * 验证 RSA 签名，默认算法 SHA256withRSA，UTF-8 字符集，空值不参与签名。
	 * publicKeyBase64OrPem：X.509 公钥（Base64 或 PEM 文本）。
	 */
	public static boolean verifyRsaSign(Map<String, ?> paramsWithSign, String publicKeyBase64OrPem)
			throws GeneralSecurityException {
		return verifyRsaSign(paramsWithSign, publicKeyBase64OrPem, "SHA256withRSA", DEFAULT_CHARSET, true);
	}

	/**
	 * 验证 RSA 签名（可选算法/字符集/是否排除空值）。
	 */
	public static boolean verifyRsaSign(Map<String, ?> paramsWithSign, String publicKeyBase64OrPem, String algorithm,
			Charset charset, boolean excludeEmpty) throws GeneralSecurityException {
		if (paramsWithSign == null || paramsWithSign.isEmpty())
			return false;
		Object signObj = paramsWithSign.get(SIGN_FIELD);
		if (isEmpty(signObj))
			return false;
		String signBase64 = String.valueOf(signObj);

		Map<String, Object> copy = new HashMap<>();
		for (Map.Entry<String, ?> e : paramsWithSign.entrySet()) {
			String k = e.getKey();
			if (k == null)
				continue;
			if (SIGN_FIELD.equalsIgnoreCase(k))
				continue;
			copy.put(k, e.getValue());
		}
		String plaintext = buildSignPlaintext(copy, excludeEmpty);
		PublicKey pub = loadPublicKey(publicKeyBase64OrPem);
		Signature signature = Signature.getInstance(algorithm);
		signature.initVerify(pub);
		signature.update(plaintext.getBytes(charset == null ? DEFAULT_CHARSET : charset));
		byte[] sigBytes = Base64.getDecoder().decode(signBase64);
		return signature.verify(sigBytes);
	}

	// ----------------- 原文串构造 -----------------

	/**
	 * 构造签名原文串（不追加 &key=...），默认空值不参与，忽略 sign 与 reserved* 字段。
	 * 例如：a=1&b=2&c=3
	 */
	public static String buildSignPlaintext(Map<String, ?> params, boolean excludeEmpty) {
		TreeMap<String, String> sorted = new TreeMap<>();
		if (params != null) {
			for (Map.Entry<String, ?> e : params.entrySet()) {
				String k = e.getKey();
				if (k == null)
					continue;
				if (SIGN_FIELD.equalsIgnoreCase(k))
					continue;
				if (startsWithReserved(k))
					continue;
				Object v = e.getValue();
				if (excludeEmpty && isEmpty(v))
					continue;
				sorted.put(k, stringify(v));
			}
		}
		StringBuilder sb = new StringBuilder();
		boolean first = true;
		for (Map.Entry<String, String> e : sorted.entrySet()) {
			if (!first)
				sb.append('&');
			sb.append(e.getKey()).append('=').append(e.getValue());
			first = false;
		}
		return sb.toString();
	}

	/**
	 * 构造 MD5 方案用的原文串（在末尾追加 &key=secretKey），默认空值不参与，忽略 sign 与 reserved* 字段。
	 * 例如：a=1&b=2&key=xxx
	 */
	public static String buildSignPlaintextWithKey(Map<String, ?> params, String secretKey, boolean excludeEmpty) {
		String base = buildSignPlaintext(params, excludeEmpty);
		StringBuilder sb = new StringBuilder();
		if (base != null && !base.isEmpty()) {
			sb.append(base).append('&');
		}
		sb.append("key=").append(secretKey == null ? "" : secretKey);
		return sb.toString();
	}

	// ----------------- Key 解析（Base64 或 PEM） -----------------

	public static PrivateKey loadPrivateKey(String base64OrPem) throws GeneralSecurityException {
		try {
			byte[] keyBytes = decodeBase64OrPem(base64OrPem);
			PKCS8EncodedKeySpec spec = new PKCS8EncodedKeySpec(keyBytes);
			return KeyFactory.getInstance("RSA").generatePrivate(spec);
		} catch (GeneralSecurityException e) {
			throw e;
		} catch (Exception e) {
			throw new GeneralSecurityException("Failed to load RSA private key", e);
		}
	}

	public static PublicKey loadPublicKey(String base64OrPem) throws GeneralSecurityException {
		try {
			byte[] keyBytes = decodeBase64OrPem(base64OrPem);
			X509EncodedKeySpec spec = new X509EncodedKeySpec(keyBytes);
			return KeyFactory.getInstance("RSA").generatePublic(spec);
		} catch (GeneralSecurityException e) {
			throw e;
		} catch (Exception e) {
			throw new GeneralSecurityException("Failed to load RSA public key", e);
		}
	}

	private static byte[] decodeBase64OrPem(String base64OrPem) {
		String s = base64OrPem == null ? "" : base64OrPem.trim();
		if (s.startsWith("-----BEGIN")) {
			s = s.replaceAll("-----BEGIN(.*?)-----", "").replaceAll("-----END(.*?)-----", "").replaceAll("\\s", "");
		}
		return Base64.getDecoder().decode(s);
	}

	// ----------------- 辅助方法 -----------------

	private static boolean isEmpty(Object v) {
		if (v == null)
			return true;
		if (v instanceof CharSequence)
			return ((CharSequence) v).length() == 0;
		return false;
	}

	private static boolean startsWithReserved(String key) {
		if (key == null)
			return false;
		if (key.length() < RESERVED_PREFIX.length())
			return false;
		return key.regionMatches(true, 0, RESERVED_PREFIX, 0, RESERVED_PREFIX.length());
	}

	private static String stringify(Object v) {
		return String.valueOf(v);
	}

	private static String md5Upper(String text) {
		try {
			MessageDigest md = MessageDigest.getInstance("MD5");
			byte[] bytes = md.digest(text.getBytes(DEFAULT_CHARSET));
			return toHexUpper(bytes);
		} catch (NoSuchAlgorithmException e) {
			throw new IllegalStateException("MD5 algorithm not available", e);
		}
	}

	private static String toHexUpper(byte[] data) {
		char[] HEX = "0123456789ABCDEF".toCharArray();
		char[] out = new char[data.length * 2];
		for (int i = 0, j = 0; i < data.length; i++) {
			int v = data[i] & 0xFF;
			out[j++] = HEX[v >>> 4];
			out[j++] = HEX[v & 0x0F];
		}
		return new String(out);
	}

	// ----------------- 简单示例 -----------------
	public static void main(String[] args) throws Exception {
		Map<String, Object> params = new HashMap<>();
		params.put("b", "2");
		params.put("a", "1");
		params.put("reservedNote", "shouldSkip");
		params.put("empty", "");
		params.put("sign", "dummy");

		// MD5-with-key
		String md5Plain = buildSignPlaintextWithKey(params, "123qwe", true);
		String md5Sign = computeSign(params, "123qwe");
		System.out.println("MD5 Plain: " + md5Plain);
		System.out.println("MD5 Sign : " + md5Sign);

		// RSA demo（需要你替换为真实 RSA 密钥）
		// String rsaSign = computeRsaSign(params, PRIVATE_KEY_PEM_OR_BASE64);
		// boolean ok = verifyRsaSign(new HashMap<String,Object>(){{ putAll(params);
		// put("sign", rsaSign); }},
		// PUBLIC_KEY_PEM_OR_BASE64);
		// System.out.println("RSA verify: " + ok);
	}
}