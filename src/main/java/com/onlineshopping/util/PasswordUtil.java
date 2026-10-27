
package com.onlineshopping.util;

import java.security.MessageDigest;
import java.security.SecureRandom;
import java.util.Base64;

import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;

public class PasswordUtil {

    private static final int ITERATIONS = 210000;
    private static final int SALT_LENGTH = 16;
    private static final int KEY_LENGTH = 256;

    private static final SecureRandom RANDOM = new SecureRandom();

    public static String hashPassword(String password) {
        byte[] salt = new byte[SALT_LENGTH];
        RANDOM.nextBytes(salt);

        byte[] hash = derive(password, salt, ITERATIONS);

        return "pbkdf2$" + ITERATIONS + "$"
                + Base64.getEncoder().encodeToString(salt) + "$"
                + Base64.getEncoder().encodeToString(hash);
    }

    public static boolean isHashed(String storedValue) {
        return storedValue != null
                && storedValue.startsWith("pbkdf2$");
    }

    public static boolean verifyPassword(
            String password, String storedValue) {

        try {
            String[] parts = storedValue.split("\\$", -1);

            if (parts.length != 4 || !parts[0].equals("pbkdf2")) {
                return false;
            }

            int iterations = Integer.parseInt(parts[1]);

            // Reject unreasonable or malformed iteration counts.
            if (iterations < 100000 || iterations > 1000000) {
                return false;
            }

            byte[] salt = Base64.getDecoder().decode(parts[2]);
            byte[] expectedHash =
                    Base64.getDecoder().decode(parts[3]);

            if (salt.length != SALT_LENGTH
                    || expectedHash.length != KEY_LENGTH / 8) {
                return false;
            }

            byte[] actualHash = derive(password, salt, iterations);

            return MessageDigest.isEqual(expectedHash, actualHash);

        } catch (IllegalArgumentException e) {
            return false;
        }
    }

    private static byte[] derive(
            String password, byte[] salt, int iterations) {

        PBEKeySpec spec = new PBEKeySpec(
                password.toCharArray(),
                salt,
                iterations,
                KEY_LENGTH
        );

        try {
            SecretKeyFactory factory =
                    SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256");

            return factory.generateSecret(spec).getEncoded();

        } catch (Exception e) {
            throw new IllegalStateException(
                    "Password hashing failed.", e);

        } finally {
            spec.clearPassword();
        }
    }
}