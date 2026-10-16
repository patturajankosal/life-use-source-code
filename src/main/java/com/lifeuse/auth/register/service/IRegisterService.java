package com.lifeuse.auth.register.service;

import com.lifeuse.auth.register.models.RegisterRequest;
import com.lifeuse.auth.register.models.RegisterResponse;

public interface IRegisterService {

    RegisterResponse register(RegisterRequest request);
}
