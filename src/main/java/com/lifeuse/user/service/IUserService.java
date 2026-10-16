package com.lifeuse.user.service;

import com.lifeuse.user.models.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;

public interface IUserService extends UserDetailsService {

    @Override
    UserDetails loadUserByUsername(String loginIdentifier);

    User getById(Long id);

    User getByEmail(String email);

    User getByUsername(String username);

    User save(User user);

    boolean existsByEmail(String email);

    boolean existsByPhoneNumber(String phoneNumber);

    boolean existsByUsername(String username);
}
