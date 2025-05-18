package util;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Base64;
import java.util.logging.Level;
import java.util.logging.Logger;

public class PasswordUtil {
    
    private static final Logger LOGGER = Logger.getLogger(PasswordUtil.class.getName());
    
    // Hash password using SHA-256
    public static String hashPassword(String password) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hash = digest.digest(password.getBytes(StandardCharsets.UTF_8));
            String encoded = Base64.getEncoder().encodeToString(hash);
            
            LOGGER.log(Level.FINE, "Hashed password: {0} -> {1}", new Object[]{password, encoded});
            return encoded;
        } catch (NoSuchAlgorithmException e) {
            LOGGER.log(Level.SEVERE, "Error hashing password", e);
            return null;
        }
    }
    
    // Verify password with detailed logging
    public static boolean verifyPassword(String inputPassword, String storedPassword) {
        String hashedInput = hashPassword(inputPassword);
        boolean matches = hashedInput != null && hashedInput.equals(storedPassword);
        
        LOGGER.log(Level.FINE, "Password verification: {0}", matches ? "SUCCESS" : "FAILED");
        
        if (!matches) {
            LOGGER.log(Level.FINE, "Expected hash: {0}", storedPassword);
            LOGGER.log(Level.FINE, "Actual hash: {0}", hashedInput);
        }
        
        return matches;
    }
}
