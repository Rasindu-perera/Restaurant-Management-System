package com.restaurant.rms.service;

import com.restaurant.rms.dao.UserDAO;
import com.restaurant.rms.model.User;
import org.mindrot.jbcrypt.BCrypt;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

public class AuthService {
    private static final Logger logger = Logger.getLogger(AuthService.class.getName());
    private final UserDAO userDAO;

    public AuthService() {
        this.userDAO = new UserDAO();
    }

    public User authenticate(String username, String password) {
        try {
            User user = userDAO.findByUsername(username);
            if (user == null) {
                logger.log(Level.FINE, "User not found: {0}", username);
                return null;
            }

            if (!user.isActive()) {
                logger.log(Level.WARNING, "Inactive user attempt: {0}", username);
                return null;
            }

            if (BCrypt.checkpw(password, user.getPasswordHash())) {
                logger.log(Level.INFO, "User authenticated: {0}", username);
                return user;
            }

            logger.log(Level.FINE, "Invalid password for user: {0}", username);
            return null;
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Authentication error", e);
            return null;
        }
    }

    public User registerUser(String username, String password, String fullName, String email, String phone) {
        try {
            if (userDAO.findByUsername(username) != null) {
                throw new IllegalArgumentException("Username already exists");
            }

            if (email != null && !email.isEmpty() && userDAO.findByEmail(email) != null) {
                throw new IllegalArgumentException("Email already registered");
            }

            User newUser = new User();
            newUser.setUsername(username);
            newUser.setPasswordHash(BCrypt.hashpw(password, BCrypt.gensalt(12)));
            newUser.setFullName(fullName);
            newUser.setEmail(email);
            newUser.setPhone(phone);
            newUser.setRole(User.Role.STAFF);
            newUser.setActive(true);
            newUser.setVerificationToken(UUID.randomUUID().toString());

            userDAO.save(newUser);

            logger.log(Level.INFO, "User registered: {0}", username);
            return newUser;
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Registration failed", e);
            throw e;
        }
    }

    public boolean verifyEmail(String token) {
        User user = userDAO.findByVerificationToken(token);
        if (user != null && !user.isEmailVerified()) {
            user.setEmailVerified(true);
            user.setVerificationToken(null);
            userDAO.update(user);
            return true;
        }
        return false;
    }
}