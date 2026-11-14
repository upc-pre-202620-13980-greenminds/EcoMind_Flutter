import 'package:ecomind_parents/features/iam/domain/session.dart';
import 'package:ecomind_parents/features/iam/domain/social_role.dart';
import 'package:ecomind_parents/features/iam/infrastructure/remote/authentication_dto.dart';
import 'package:ecomind_parents/features/iam/infrastructure/remote/profile_role_dto.dart';

extension AuthenticationDtoMapper on AuthenticationDto {
  Session toDomain() {
    return Session(
      accessToken: accessToken,
      expiresAt: DateTime.parse(expiresAt),
      accountId: accountId,
    );
  }
}

extension ProfileRoleDtoMapper on ProfileRoleDto {
  SocialRole toDomain() {
    return socialRole == 'PARENT' ? SocialRole.parent : SocialRole.student;
  }
}

extension SocialRoleMapper on SocialRole {
  // Value expected by the backend
  String toApi() {
    return switch (this) {
      SocialRole.parent => 'PARENT',
      SocialRole.student => 'STUDENT',
    };
  }
}
