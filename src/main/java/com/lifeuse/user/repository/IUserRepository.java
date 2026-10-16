package com.lifeuse.user.repository;

import com.lifeuse.user.models.User;

import java.util.Optional;

public interface IUserRepository {

    Optional<User> findById(Long id);

    Optional<User> findByLoginIdentifier(String loginIdentifier);

    Optional<User> findByEmail(String email);

    Optional<User> findByUsername(String username);

    Optional<User> findByPhoneNumber(String phoneNumber);

    boolean existsByEmail(String email);

    boolean existsByUsername(String username);

    boolean existsByPhoneNumber(String phoneNumber);

    User save(User user);
}
