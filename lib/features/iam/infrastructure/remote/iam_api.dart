import 'dart:convert';
import 'dart:io';

import 'package:ecomind_parents/core/api_config.dart';
import 'package:ecomind_parents/core/api_exception.dart';
import 'package:ecomind_parents/features/iam/infrastructure/remote/authentication_dto.dart';
import 'package:ecomind_parents/features/iam/infrastructure/remote/profile_role_dto.dart';
import 'package:http/http.dart' as http;

class IamApi {
  static const Map<String, String> _jsonHeaders = {
    'Content-Type': 'application/json',
  };

  Future<AuthenticationDto> signIn(String email, String password) async {
    final http.Response response = await http
        .post(
          ApiConfig.uri('/api/v1/authentication/sign-in'),
          headers: _jsonHeaders,
          body: jsonEncode({'email': email, 'password': password}),
        )
        .timeout(ApiConfig.timeout);

    if (response.statusCode == HttpStatus.ok) {
      // Read as UTF-8: without a charset in the response, body would use latin1
      return AuthenticationDto.fromJson(
        jsonDecode(utf8.decode(response.bodyBytes)),
      );
    }
    throw ApiException.fromResponse(response);
  }

  Future<ProfileRoleDto> getProfile(String accessToken, int userId) async {
    final http.Response response = await http
        .get(
          ApiConfig.uri('/api/v1/user/$userId'),
          headers: {'Authorization': 'Bearer $accessToken'},
        )
        .timeout(ApiConfig.timeout);

    if (response.statusCode == HttpStatus.ok) {
      return ProfileRoleDto.fromJson(
        jsonDecode(utf8.decode(response.bodyBytes)),
      );
    }
    throw ApiException.fromResponse(response);
  }

  // The backend stores the registration as pending and sends the code by email
  Future<void> signUp(
    String name,
    String email,
    String password,
    String socialRole,
  ) async {
    final http.Response response = await http
        .post(
          ApiConfig.uri('/api/v1/authentication/sign-up'),
          headers: _jsonHeaders,
          body: jsonEncode({
            'name': name,
            'email': email,
            'password': password,
            'socialRole': socialRole,
          }),
        )
        .timeout(ApiConfig.timeout);

    if (response.statusCode != HttpStatus.created) {
      throw ApiException.fromResponse(response);
    }
  }

  // The token is not revoked on the server; the application deletes it afterwards
  Future<void> logout(String accessToken) async {
    final http.Response response = await http
        .post(
          ApiConfig.uri('/api/v1/authentication/logout'),
          headers: {'Authorization': 'Bearer $accessToken'},
        )
        .timeout(ApiConfig.timeout);

    if (response.statusCode != HttpStatus.noContent) {
      throw ApiException.fromResponse(response);
    }
  }

  // The account is created only when the code is correct
  Future<void> verifyEmail(String email, String code) async {
    final http.Response response = await http
        .post(
          ApiConfig.uri('/api/v1/authentication/verify-email'),
          headers: _jsonHeaders,
          body: jsonEncode({'email': email, 'code': code}),
        )
        .timeout(ApiConfig.timeout);

    if (response.statusCode != HttpStatus.created) {
      throw ApiException.fromResponse(response);
    }
  }

  // Same answer for known and unknown emails, so the account cannot be guessed
  Future<void> requestPasswordRecovery(
    String email, {
    String? languageTag,
  }) async {
    final http.Response response = await http
        .post(
          ApiConfig.uri('/api/v1/authentication/password-recovery/request'),
          headers: {
            ..._jsonHeaders,
            // The backend may write the email in this language
            'Accept-Language': ?languageTag,
          },
          body: jsonEncode({'email': email}),
        )
        .timeout(ApiConfig.timeout);

    if (response.statusCode != HttpStatus.ok) {
      throw ApiException.fromResponse(response);
    }
  }

  // The token comes from the emailed link and can be used only once
  Future<void> confirmPasswordRecovery(String token, String newPassword) async {
    final http.Response response = await http
        .post(
          ApiConfig.uri('/api/v1/authentication/password-recovery/confirm'),
          headers: _jsonHeaders,
          body: jsonEncode({'token': token, 'newPassword': newPassword}),
        )
        .timeout(ApiConfig.timeout);

    if (response.statusCode != HttpStatus.noContent) {
      throw ApiException.fromResponse(response);
    }
  }
}
