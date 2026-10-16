package com.lifeuse.auth.register.repository;

import com.lifeuse.user.models.User;

import java.util.Optional;

public interface IRegisterRepository {

    boolean existsByEmail(String email);

    boolean existsByUsername(String username);

    boolean existsByPhoneNumber(String phoneNumber);

    User save(User user);

    Optional<User> findByEmail(String email);

    Optional<User> findByUsername(String username);

    Optional<User> findByPhoneNumber(String phoneNumber);
}
