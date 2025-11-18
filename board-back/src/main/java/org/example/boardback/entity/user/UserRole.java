package org.example.boardback.entity.user;

import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "user_roles",
        uniqueConstraints = {
            @UniqueConstraint(name = "uk_user_roles_user_id_role_name", columnNames = {"user_id", "role_name"})},
        indexes = {
            @Index(name = "idx_user_roles_user_id", columnList = "user_id"),
            @Index(name = "idx_user_roles_role_name", columnList = "role_name"),
        }
)
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED) // 동등 선상에 있거나 자식엔터티들만 여기에 접근 가능하게 설정
public class UserRole {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", updatable = false)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "user_id", foreignKey = @ForeignKey(name = "fk_user_role_user"))
    private User user;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "role_name", referencedColumnName = "role_name", foreignKey = @ForeignKey(name = "fk_user_role_role"))
    private Role role;

    public UserRole(User user, Role role) {
        this.user = user;
        this.role = role;
    }
}
