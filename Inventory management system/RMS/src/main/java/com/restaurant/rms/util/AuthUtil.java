package com.restaurant.rms.util;

import com.restaurant.rms.model.User;
import jakarta.servlet.http.HttpSession;

public class AuthUtil {
    public static boolean isAdmin(HttpSession session) {
        User user = (User) session.getAttribute("user");
        return user != null && user.getRole() == User.Role.ADMIN;
    }

    /**
     * Retrieve the current user's ID from the session.
     *
     * @param session The HTTP session.
     * @return The user ID, or null if no user is logged in.
     */
    public static Long getCurrentUserId(HttpSession session) {
        User user = (User) session.getAttribute("user");
        return user != null ? user.getId() : null;
    }
}