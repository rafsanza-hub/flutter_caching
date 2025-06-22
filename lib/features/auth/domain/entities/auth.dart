import 'package:flutter_caching/features/auth/domain/entities/user.dart';

class Auth {
  final String accessToken;
  final User user;

  Auth({
    required this.accessToken,
    required this.user,
  });
}