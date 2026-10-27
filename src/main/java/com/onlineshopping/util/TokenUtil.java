package com.onlineshopping.util;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.util.Base64;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;

public final class TokenUtil {

    private static final String HMAC_ALGORITHM = "HmacSHA256";

    private static final String SECRET =
            "9f2c41ab7de60358c1ea47b902fd65c8b0d4713e6f2a8c95";

    private static final long VALIDITY_MILLIS = 30L * 24L * 60L * 60L * 1000L;

    private static final String SEPARATOR = "\n";

    private TokenUtil() {
    }

    public static long getValiditySeconds() {
        return VALIDITY_MILLIS / 1000L;
    }

    public static String createToken(String username, String role) {

        String payload = username + SEPARATOR + role + SEPARATOR
                + (System.currentTimeMillis() + VALIDITY_MILLIS);

        String encodedPayload =
                encode(payload.getBytes(StandardCharsets.UTF_8));

        return encodedPayload + "." + encode(sign(encodedPayload));
    }

    public static String[] verify(String token) {

        if (token == null || token.isEmpty()) {
            return null;
        }

        int separator = token.indexOf('.');

        if (separator < 1) {
            return null;
        }

        String encodedPayload = token.substring(0, separator);

        try {

            if (!MessageDigest.isEqual(sign(encodedPayload),
                    decode(token.substring(separator + 1)))) {
                return null;
            }

            String payload = new String(
                    decode(encodedPayload), StandardCharsets.UTF_8);

            String[] parts = payload.split(SEPARATOR, 3);

            if (parts.length != 3) {
                return null;
            }

            if (Long.parseLong(parts[2]) < System.currentTimeMillis()) {
                return null;
            }

            return new String[] { parts[0], parts[1] };

        } catch (IllegalArgumentException e) {
            return null;
        }
    }

    private static byte[] sign(String encodedPayload) {

        try {

            Mac mac = Mac.getInstance(HMAC_ALGORITHM);

            mac.init(new SecretKeySpec(
                    SECRET.getBytes(StandardCharsets.UTF_8),
                    HMAC_ALGORITHM));

            return mac.doFinal(
                    encodedPayload.getBytes(StandardCharsets.UTF_8));

        } catch (Exception e) {
            throw new IllegalStateException(
                    "Unable to sign remember-me token", e);
        }
    }

    private static String encode(byte[] value) {
        return Base64.getUrlEncoder().withoutPadding().encodeToString(value);
    }

    private static byte[] decode(String value) {
        return Base64.getUrlDecoder().decode(value);
    }
}
