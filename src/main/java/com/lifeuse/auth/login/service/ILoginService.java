package com.lifeuse.auth.login.service;

import com.lifeuse.auth.login.models.LoginRequest;
import com.lifeuse.auth.login.models.LoginResponse;

public interface ILoginService {

    LoginResponse login(LoginRequest request);
}
