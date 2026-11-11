import 'dart:async';
import 'dart:io';

import 'package:ecomind_parents/core/api_exception.dart';
import 'package:ecomind_parents/features/iam/domain/session.dart';
import 'package:ecomind_parents/features/iam/domain/session_repository.dart';
import 'package:ecomind_parents/features/users/domain/user_profile.dart';
import 'package:ecomind_parents/features/users/domain/user_profile_repository.dart';
import 'package:ecomind_parents/features/users/domain/users_exception.dart';
import 'package:ecomind_parents/features/users/infrastructure/mappers/user_profile_mapper.dart';
import 'package:ecomind_parents/features/users/infrastructure/remote/user_api.dart';
import 'package:http/http.dart' as http;

class UserProfileRepositoryImpl implements UserProfileRepository {
  final UserApi api;
  // The token and the id of the parent come from the session saved by IAM
  final SessionRepository sessionRepository;

  const new({required this.api, required this.sessionRepository});

  @override
  Future<UserProfile> getCurrentProfile() {
    return _guard((session) async {
      final dto = await api.getUser(session.accessToken, session.accountId);
      return dto.toDomain();
    });
  }

  @override
  Future<UserProfile> updateProfile(UserProfile profile) {
    return _guard((session) async {
      final dto = await api.updateUser(session.accessToken, profile.toDto());
      return dto.toDomain();
    });
  }

  // Turns the errors of the network and of the backend into errors of the domain
  Future<T> _guard<T>(Future<T> Function(Session session) request) async {
    final session = await sessionRepository.getSession();
    if (session == null || session.isExpired(DateTime.now())) {
      throw const UsersException(UsersError.sessionExpired);
    }
    try {
      return await request(session);
    } on ApiException catch (e) {
      throw UsersException(switch (e.statusCode) {
        HttpStatus.unauthorized => UsersError.sessionExpired,
        HttpStatus.forbidden => UsersError.forbidden,
        HttpStatus.notFound => UsersError.notFound,
        _ => UsersError.unknown,
      });
    } on TimeoutException {
      throw const UsersException(UsersError.connection);
    } on SocketException {
      throw const UsersException(UsersError.connection);
    } on http.ClientException {
      throw const UsersException(UsersError.connection);
    }
  }
}
