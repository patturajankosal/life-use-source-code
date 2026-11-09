import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// User entity model matching backend com.lifeuse.user.models.User.
class UserModel {
  final int id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String role;
  final bool emailVerified;
  final bool phoneVerified;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.role,
    required this.emailVerified,
    required this.phoneVerified,
  });

  String get fullName {
    if (firstName.isNotEmpty || lastName.isNotEmpty) {
      return '$firstName $lastName'.trim();
    }
    return username;
  }

  String get roleDisplay {
    final clean = role.toUpperCase().replaceAll('ROLE_', '');
    switch (clean) {
      case 'SUPER_ADMIN':
      case 'SUPERADMIN':
        return 'SuperAdmin';
      case 'ADMIN':
        return 'Admin';
      case 'CUSTOMER':
        return 'Customer';
      case 'USER':
      default:
        return 'User';
    }
  }

  Color get roleColor {
    final clean = role.toUpperCase().replaceAll('ROLE_', '');
    switch (clean) {
      case 'SUPER_ADMIN':
      case 'SUPERADMIN':
        return AppColors.roleSuperAdmin;
      case 'ADMIN':
        return AppColors.roleAdmin;
      case 'CUSTOMER':
        return AppColors.roleCustomer;
      case 'USER':
      default:
        return AppColors.roleUser;
    }
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: (json['id'] as num?)?.toInt() ??
          (json['userId'] as num?)?.toInt() ??
          0,
      username: json['username']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      firstName: json['firstName']?.toString() ?? '',
      lastName: json['lastName']?.toString() ?? '',
      phoneNumber: json['phoneNumber']?.toString() ?? '',
      role: json['role']?.toString() ?? 'ROLE_USER',
      emailVerified: json['emailVerified'] == true,
      phoneVerified: json['phoneVerified'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'role': role,
      'emailVerified': emailVerified,
      'phoneVerified': phoneVerified,
    };
  }
}
