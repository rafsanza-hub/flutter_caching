import 'package:flutter_caching/features/auth/domain/entities/auth.dart';

class AuthResponseModel extends Auth {
  AuthResponseModel({
    required super.accessToken,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      accessToken: json['access_token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
    };
  }
}
