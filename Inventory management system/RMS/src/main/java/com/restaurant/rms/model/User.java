package com.restaurant.rms.model;

import jakarta.persistence.*;
import lombok.Data;
import java.util.Date;

@Data
@Entity
@Table(name = "users")
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "user_id")
    private Long id;

    @Column(unique = true, nullable = false, length = 255)
    private String username;

    @Column(name = "password_hash", nullable = false, length = 255)
    private String passwordHash;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, columnDefinition = "ENUM('ADMIN','MANAGER','STAFF')")
    private Role role;

    @Column(name = "full_name", nullable = false, length = 255)
    private String fullName;

    @Column(name = "last_login")
    @Temporal(TemporalType.TIMESTAMP)
    private Date lastLogin;

    @Column(nullable = false, columnDefinition = "BOOLEAN DEFAULT TRUE")
    private Boolean active = true;

    @Column(unique = true)
    private String email;

    private String phone;

    @Column(name = "verification_token")
    private String verificationToken;

    @Column(name = "email_verified", columnDefinition = "BOOLEAN DEFAULT FALSE")
    private Boolean emailVerified = false;

    @Column(name = "reset_token")
    private String resetToken;

    @Column(name = "reset_token_expiry")
    @Temporal(TemporalType.TIMESTAMP)
    private Date resetTokenExpiry;

    public enum Role {
        ADMIN, MANAGER, STAFF
    }

    // Convenience method for checking active status
    public boolean isActive() {
        return active != null && active;
    }

    // Convenience method for checking email verification
    public boolean isEmailVerified() {
        return emailVerified != null && emailVerified;
    }
}