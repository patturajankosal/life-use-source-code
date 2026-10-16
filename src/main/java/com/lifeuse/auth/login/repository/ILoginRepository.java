package com.lifeuse.auth.login.repository;

import com.lifeuse.user.models.User;

import java.util.Optional;

public interface ILoginRepository {

    Optional<User> findByLoginIdentifier(String loginIdentifier);

    Optional<User> findByUsername(String username);

    Optional<User> findByEmail(String email);

    Optional<User> findByPhoneNumber(String phoneNumber);
}
