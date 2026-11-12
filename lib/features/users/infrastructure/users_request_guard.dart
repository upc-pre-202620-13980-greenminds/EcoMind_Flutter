import 'dart:async';
import 'dart:io';

import 'package:ecomind_parents/core/api_exception.dart';
import 'package:ecomind_parents/features/iam/domain/session.dart';
import 'package:ecomind_parents/features/iam/domain/session_repository.dart';
import 'package:ecomind_parents/features/users/domain/users_exception.dart';
import 'package:http/http.dart' as http;

// Shared by the repositories of Users: reads the session saved by IAM and turns
// the errors of the network and of the backend into errors of the domain
Future<T> guardUsersRequest<T>(
  SessionRepository sessionRepository,
  Future<T> Function(Session session) request,
) async {
  final session = await sessionRepository.getSession();
  if (session == null || session.isExpired(DateTime.now())) {
    throw const UsersException(UsersError.sessionExpired);
  }
  try {
    return await request(session);
  } on ApiException catch (e) {
    throw UsersException(_errorFor(e));
  } on TimeoutException {
    throw const UsersException(UsersError.connection);
  } on SocketException {
    throw const UsersException(UsersError.connection);
  } on http.ClientException {
    throw const UsersException(UsersError.connection);
  }
}

UsersError _errorFor(ApiException e) {
  switch (e.code) {
    case 'FAMILY_CREATOR_NOT_PARENT':
      return UsersError.creatorNotParent;
    case 'FAMILY_MEMBERSHIP_CONFLICT':
      return UsersError.membershipConflict;
    case 'FAMILY_PARENT_SELF_REMOVAL':
      return UsersError.parentSelfRemoval;
  }
  return switch (e.statusCode) {
    HttpStatus.unauthorized => UsersError.sessionExpired,
    HttpStatus.forbidden => UsersError.forbidden,
    HttpStatus.notFound => UsersError.notFound,
    _ => UsersError.unknown,
  };
}
