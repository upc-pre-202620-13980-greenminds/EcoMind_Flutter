import 'package:ecomind_parents/features/iam/domain/social_role.dart';
import 'package:ecomind_parents/features/users/domain/family.dart';
import 'package:ecomind_parents/features/users/domain/family_member.dart';
import 'package:ecomind_parents/features/users/domain/family_role.dart';
import 'package:ecomind_parents/features/users/infrastructure/remote/family_dto.dart';
import 'package:ecomind_parents/features/users/infrastructure/remote/user_profile_dto.dart';

// The family resource only has user ids, so the names come from the profiles
extension FamilyDtoMapper on FamilyDto {
  Family toDomain(Map<int, UserProfileDto> profiles, int currentUserId) {
    return Family(
      id: id,
      name: name,
      commitment: commitment,
      members: members
          .map((member) => member.toDomain(profiles, currentUserId))
          .toList(),
    );
  }
}

extension FamilyMemberDtoMapper on FamilyMemberDto {
  FamilyMember toDomain(Map<int, UserProfileDto> profiles, int currentUserId) {
    final profile = profiles[userId];
    return FamilyMember(
      id: id,
      userId: userId,
      name: profile?.name ?? '',
      role: familyRole == 'PARENT' ? FamilyRole.parent : FamilyRole.child,
      socialRole: profile?.socialRole == 'PARENT'
          ? SocialRole.parent
          : SocialRole.student,
      isCurrentUser: userId == currentUserId,
    );
  }
}

extension FamilyRoleMapper on FamilyRole {
  // Value expected by the backend
  String toApi() {
    return switch (this) {
      FamilyRole.parent => 'PARENT',
      FamilyRole.child => 'CHILD',
    };
  }
}
