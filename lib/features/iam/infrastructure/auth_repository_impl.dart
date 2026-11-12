import 'dart:async';
import 'dart:io';

import 'package:ecomind_parents/core/api_exception.dart';
import 'package:ecomind_parents/features/iam/domain/auth_exception.dart';
import 'package:ecomind_parents/features/iam/domain/auth_repository.dart';
import 'package:ecomind_parents/features/iam/domain/session.dart';
import 'package:ecomind_parents/features/iam/domain/social_role.dart';
import 'package:ecomind_parents/features/iam/infrastructure/mappers/authentication_mapper.dart';
import 'package:ecomind_parents/features/iam/infrastructure/remote/iam_api.dart';
import 'package:http/http.dart' as http;

class AuthRepositoryImpl implements AuthRepository {
  final IamApi api;

  const new({required this.api});

  @override
  Future<Session> signIn(String email, String password) {
    return _guard(() async {
      final dto = await api.signIn(email, password);
      return dto.toDomain();
    });
  }

  @override
  Future<SocialRole> getSocialRole(Session session) {
    return _guard(() async {
      final dto = await api.getProfile(session.accessToken, session.accountId);
      return dto.toDomain();
    });
  }

  @override
  Future<void> signUp(
    String name,
    String email,
    String password,
    SocialRole role,
  ) {
    return _guard(() => api.signUp(name, email, password, role.toApi()));
  }

  @override
  Future<void> verifyEmail(String email, String code) {
    return _guard(() => api.verifyEmail(email, code));
  }

  @override
  Future<void> signOut(Session session) {
    return _guard(() => api.logout(session.accessToken));
  }

  @override
  Future<void> requestPasswordRecovery(String email, {String? languageTag}) {
    return _guard(
      () => api.requestPasswordRecovery(email, languageTag: languageTag),
    );
  }

  @override
  Future<void> confirmPasswordRecovery(String token, String newPassword) {
    return _guard(() => api.confirmPasswordRecovery(token, newPassword));
  }

  // Turns the errors of the network and of the backend into errors of the domain
  Future<T> _guard<T>(Future<T> Function() request) async {
    try {
      return await request();
    } on ApiException catch (e) {
      throw AuthException(_errorFor(e.code));
    } on TimeoutException {
      throw const AuthException(AuthError.connection);
    } on SocketException {
      throw const AuthException(AuthError.connection);
    } on http.ClientException {
      throw const AuthException(AuthError.connection);
    }
  }

  AuthError _errorFor(String code) {
    return switch (code) {
      'INVALID_CREDENTIALS' => AuthError.invalidCredentials,
      'EMAIL_CONFLICT' => AuthError.emailConflict,
      'PASSWORD_POLICY_VIOLATION' => AuthError.passwordPolicy,
      'VERIFICATION_CODE_INVALID' => AuthError.codeInvalid,
      'VERIFICATION_CODE_EXPIRED' => AuthError.codeExpired,
      'VERIFICATION_ATTEMPTS_EXCEEDED' => AuthError.tooManyAttempts,
      'PASSWORD_RESET_TOKEN_INVALID' => AuthError.resetTokenInvalid,
      'EMAIL_DELIVERY_FAILED' => AuthError.emailDelivery,
      _ => AuthError.unknown,
    };
  }
}
