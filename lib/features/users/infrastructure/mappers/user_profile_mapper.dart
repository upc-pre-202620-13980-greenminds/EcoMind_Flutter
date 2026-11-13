import 'package:ecomind_parents/features/iam/domain/social_role.dart';
import 'package:ecomind_parents/features/users/domain/user_profile.dart';
import 'package:ecomind_parents/features/users/infrastructure/remote/user_profile_dto.dart';

extension UserProfileDtoMapper on UserProfileDto {
  UserProfile toDomain() {
    return UserProfile(
      id: id,
      name: name,
      socialRole: socialRole == 'PARENT'
          ? SocialRole.parent
          : SocialRole.student,
      streak: streak,
      lastStreakDate: lastStreakDate == null
          ? null
          : DateTime.parse(lastStreakDate!),
      ecopoints: ecopoints,
      gemBalance: gemBalance,
      avatarImageReference: avatarImageReference,
    );
  }
}

extension UserProfileMapper on UserProfile {
  UserProfileDto toDto() {
    return UserProfileDto(
      id: id,
      name: name,
      socialRole: socialRole == SocialRole.parent ? 'PARENT' : 'STUDENT',
      streak: streak,
      // The backend expects only the date, as 2026-10-08
      lastStreakDate: lastStreakDate?.toIso8601String().substring(0, 10),
      ecopoints: ecopoints,
      gemBalance: gemBalance,
      avatarImageReference: avatarImageReference,
    );
  }
}
