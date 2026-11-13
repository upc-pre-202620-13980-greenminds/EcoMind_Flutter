import 'package:ecomind_parents/features/iam/domain/social_role.dart';

class UserProfile {
  final int id;
  final String name;
  final SocialRole socialRole;
  final int streak;
  final DateTime? lastStreakDate;
  final int ecopoints;
  final int gemBalance;
  // Avatar equipped in Store; null shows the initials
  final String? avatarImageReference;

  const new({
    required this.id,
    required this.name,
    required this.socialRole,
    required this.streak,
    required this.lastStreakDate,
    required this.ecopoints,
    required this.gemBalance,
    this.avatarImageReference,
  });

  // Only the name can be edited; the rest comes from other contexts
  UserProfile withName(String newName) {
    return UserProfile(
      id: id,
      name: newName,
      socialRole: socialRole,
      streak: streak,
      lastStreakDate: lastStreakDate,
      ecopoints: ecopoints,
      gemBalance: gemBalance,
      avatarImageReference: avatarImageReference,
    );
  }
}
