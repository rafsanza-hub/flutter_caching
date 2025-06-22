import 'package:flutter_caching/features/auth/data/models/user_model.dart';
import 'package:flutter_caching/features/auth/domain/entities/auth.dart';

class AuthResponseModel extends Auth {
  AuthResponseModel({
    required super.accessToken,
    required UserModel super.user,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      accessToken: json['accessToken'],
      user: UserModel.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'user': (user as UserModel).toJson(),
    };
  }
}