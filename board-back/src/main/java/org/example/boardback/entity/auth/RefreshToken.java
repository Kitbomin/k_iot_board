package org.example.boardback.entity.auth;


import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.Instant;

@Entity
@Table(name = "refresh_tokens", indexes = {@Index(name = "idx_refresh_token_user_id", columnList = "user_id")})
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class RefreshToken {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", updatable = false)
    private Long id;

    @Column(name = "user_id", nullable = false, unique = true)
    private Long userId;

    @Column(nullable = false, length = 350)
    private String token;

    @Column(nullable = false)
    private Instant expiry;

    @Builder
    private RefreshToken(String token, Instant expiry) {
        this.token = token;
        this.expiry = expiry;
    }

    public void renew (String newToken, Instant newExpiry) {
        this.token = newToken;
        this.expiry = newExpiry;
    }

    // 만료 여부 판단
    public boolean isExpired() {
        return Instant.now().isAfter(expiry);
    }
}
