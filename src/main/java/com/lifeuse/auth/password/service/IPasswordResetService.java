package com.lifeuse.auth.password.service;

import com.lifeuse.auth.password.models.ChangePasswordRequest;
import com.lifeuse.auth.password.models.ForgotPasswordRequest;
import com.lifeuse.auth.password.models.ResetPasswordRequest;
import com.lifeuse.user.models.User;

public interface IPasswordResetService {

    void initiateForgotPassword(ForgotPasswordRequest request);

    String verifyForgotPasswordOtp(String identifier, String otpCode);

    void resetPassword(ResetPasswordRequest request);

    void changePassword(User user, ChangePasswordRequest request);
}
